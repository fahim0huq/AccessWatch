// Routing on graph.json. Plain Dart with no Flutter imports, so it runs in an
// isolate through compute. Costs use only fields that exist in the graph.
import 'models/road_graph.dart';

/// Ways to travel. Each uses its own passable flag from the graph.
enum CareMode {
  car('normal_vehicle'),
  truck('high_clearance'),
  foot('foot');

  final String flagName;

  const CareMode(this.flagName);
}

/// fastest: `travel_time_min`. safest: `risk_cost`. Both break ties by length,
/// because many pieces have a time of 0 after the data's rounding to 0.1 min.
enum RouteCriterion { fastest, safest }

const _deep = 3;
const _shallow = 1;
const _medium = 2;
const _tieBreakPerMetre = 1e-6;

int _bit(RoadGraph g, String name) {
  final bit = g.flagBits[name];
  if (bit == null) throw StateError('graph.json has no "$name" flag');
  return bit;
}

/// A road piece is usable when the mode's flag says so. Car and truck also never
/// enter deep water, whatever a flag says.
bool passable(RoadGraph g, int edge, CareMode mode) {
  if (g.flags[edge] & _bit(g, mode.flagName) == 0) return false;
  return mode == CareMode.foot || g.depthClass[edge] != _deep;
}

class GraphRoute {
  /// Node indices from start to end.
  final List<int> nodes;
  final double lengthM, timeMin, riskCost, shallowM, mediumM;

  /// Road pieces on the route flagged as a bridge to check on the ground.
  final int uncertainBridges;

  /// Start and clinic share a road point: there is nothing to travel or draw.
  bool get isAtTarget => nodes.length < 2;

  const GraphRoute({
    required this.nodes,
    required this.lengthM,
    required this.timeMin,
    required this.riskCost,
    required this.shallowM,
    required this.mediumM,
    required this.uncertainBridges,
  });
}

class _Adjacency {
  final List<int> start, edge, other;

  _Adjacency(this.start, this.edge, this.other);

  factory _Adjacency.of(RoadGraph g) {
    final degree = List<int>.filled(g.nodeCount + 1, 0);
    for (var e = 0; e < g.edgeCount; e++) {
      degree[g.u[e] + 1]++;
      degree[g.v[e] + 1]++;
    }
    for (var i = 1; i < degree.length; i++) {
      degree[i] += degree[i - 1];
    }
    final fill = List<int>.of(degree);
    final edge = List<int>.filled(g.edgeCount * 2, 0), other = List<int>.filled(g.edgeCount * 2, 0);
    for (var e = 0; e < g.edgeCount; e++) {
      for (final (a, b) in [(g.u[e], g.v[e]), (g.v[e], g.u[e])]) {
        edge[fill[a]] = e;
        other[fill[a]] = b;
        fill[a]++;
      }
    }
    return _Adjacency(degree, edge, other);
  }
}

/// Binary min-heap of (cost, node).
class _Heap {
  final _cost = <double>[], _node = <int>[];

  bool get isEmpty => _cost.isEmpty;

  void push(double cost, int node) {
    _cost.add(cost);
    _node.add(node);
    var i = _cost.length - 1;
    while (i > 0) {
      final p = (i - 1) >> 1;
      if (_cost[p] <= _cost[i]) break;
      _swap(i, p);
      i = p;
    }
  }

  (double, int) pop() {
    final top = (_cost.first, _node.first);
    final lastCost = _cost.removeLast(), lastNode = _node.removeLast();
    if (_cost.isNotEmpty) {
      _cost[0] = lastCost;
      _node[0] = lastNode;
      var i = 0;
      while (true) {
        final l = 2 * i + 1, r = l + 1;
        var m = i;
        if (l < _cost.length && _cost[l] < _cost[m]) m = l;
        if (r < _cost.length && _cost[r] < _cost[m]) m = r;
        if (m == i) break;
        _swap(i, m);
        i = m;
      }
    }
    return top;
  }

  void _swap(int a, int b) {
    final c = _cost[a], n = _node[a];
    _cost[a] = _cost[b];
    _node[a] = _node[b];
    _cost[b] = c;
    _node[b] = n;
  }
}

/// Best route from [source] to each of [targets]. A target with no route is
/// simply absent: the caller must never draw a straight line instead.
Map<int, GraphRoute> findRoutes(RoadGraph g, int source, List<int> targets, CareMode mode, RouteCriterion criterion) {
  final adjacency = _Adjacency.of(g);
  final best = List<double>.filled(g.nodeCount, double.infinity);
  final viaEdge = List<int>.filled(g.nodeCount, -1);
  final wanted = targets.toSet();
  var remaining = wanted.length;
  final heap = _Heap()..push(0, source);
  best[source] = 0;
  while (!heap.isEmpty && remaining > 0) {
    final (cost, node) = heap.pop();
    if (cost > best[node]) continue;
    if (wanted.contains(node)) remaining--;
    for (var i = adjacency.start[node]; i < adjacency.start[node + 1]; i++) {
      final e = adjacency.edge[i];
      if (!passable(g, e, mode)) continue;
      final step = (criterion == RouteCriterion.fastest ? g.travelTimeMin[e] : g.riskCost[e]) +
          g.lengthM[e] * _tieBreakPerMetre;
      final next = adjacency.other[i];
      if (cost + step < best[next]) {
        best[next] = cost + step;
        viaEdge[next] = e;
        heap.push(cost + step, next);
      }
    }
  }
  return {
    for (final t in wanted)
      if (best[t].isFinite) t: _trace(g, source, t, viaEdge),
  };
}

GraphRoute _trace(RoadGraph g, int source, int target, List<int> viaEdge) {
  final nodes = <int>[target];
  var length = 0.0, time = 0.0, risk = 0.0, shallow = 0.0, medium = 0.0;
  var bridges = 0;
  final uncertainBit = _bit(g, 'bridge_uncertain');
  var node = target;
  while (node != source) {
    final e = viaEdge[node];
    length += g.lengthM[e];
    time += g.travelTimeMin[e];
    risk += g.riskCost[e];
    if (g.depthClass[e] == _shallow) shallow += g.lengthM[e];
    if (g.depthClass[e] == _medium) medium += g.lengthM[e];
    if (g.flags[e] & uncertainBit != 0) bridges++;
    node = g.u[e] == node ? g.v[e] : g.u[e];
    nodes.add(node);
  }
  return GraphRoute(
    nodes: nodes.reversed.toList(),
    lengthM: length,
    timeMin: time,
    riskCost: risk,
    shallowM: shallow,
    mediumM: medium,
    uncertainBridges: bridges,
  );
}

/// Connected pieces when only edges passing [keep] are used: (count, largest).
(int, int) components(RoadGraph g, bool Function(int edge) keep) {
  final parent = List<int>.generate(g.nodeCount, (i) => i);
  int find(int x) {
    while (parent[x] != x) {
      parent[x] = parent[parent[x]];
      x = parent[x];
    }
    return x;
  }

  for (var e = 0; e < g.edgeCount; e++) {
    if (keep(e)) parent[find(g.u[e])] = find(g.v[e]);
  }
  final sizes = <int, int>{};
  for (var i = 0; i < g.nodeCount; i++) {
    sizes.update(find(i), (n) => n + 1, ifAbsent: () => 1);
  }
  return (sizes.length, sizes.values.reduce((a, b) => a > b ? a : b));
}

/// One job for compute: every mode from one start node to the clinics.
class CareRouteRequest {
  final RoadGraph graph;
  final int source;
  final List<int> targets;
  final RouteCriterion criterion;

  const CareRouteRequest(this.graph, this.source, this.targets, this.criterion);
}

Map<CareMode, Map<int, GraphRoute>> careRoutes(CareRouteRequest r) => {
      for (final mode in CareMode.values) mode: findRoutes(r.graph, r.source, r.targets, mode, r.criterion),
    };
