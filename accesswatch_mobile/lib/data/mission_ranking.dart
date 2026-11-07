// Live re-ranking from priority_terms. Pure, so tests can check it directly.
import 'dart:math' as math;

import 'models/mission.dart';

/// How strongly each term counts. All 1.0 reproduces the published ranking,
/// because the priority score is the product of the three terms.
class PriorityWeights {
  static const min = 0.0, max = 2.0, published = 1.0;

  final double people, serviceLoss, difficulty;

  const PriorityWeights({this.people = published, this.serviceLoss = published, this.difficulty = published});

  bool get isPublished => people == published && serviceLoss == published && difficulty == published;

  double score(PriorityTerms t) =>
      math.pow(t.popNorm, people) * math.pow(t.serviceLossNorm, serviceLoss) * math.pow(t.difficultyNorm, difficulty) as double;
}

class RankedMission {
  final Mission mission;

  /// Position under the current weights. `mission.rank` stays the published rank.
  final int rank;
  final double score;

  const RankedMission(this.mission, this.rank, this.score);
}

/// Equal scores keep their published order, so the published weights give back
/// exactly the published ranking.
List<RankedMission> rankMissions(List<Mission> missions, PriorityWeights weights) {
  final scored = [for (final m in missions) (m, weights.score(m.priorityTerms))]
    ..sort((a, b) {
      final byScore = b.$2.compareTo(a.$2);
      return byScore != 0 ? byScore : a.$1.rank.compareTo(b.$1.rank);
    });
  return [for (var i = 0; i < scored.length; i++) RankedMission(scored[i].$1, i + 1, scored[i].$2)];
}

/// The pocket with the most people, and its share of all pocket people.
(Mission, double)? largestPocket(List<Mission> missions) {
  if (missions.isEmpty) return null;
  final total = missions.fold<int>(0, (sum, m) => sum + m.population);
  if (total == 0) return null;
  final top = missions.reduce((a, b) => b.population > a.population ? b : a);
  return (top, top.population / total);
}

/// True when two pockets have identical terms, so no weights can separate them.
bool hasTiedTerms(List<Mission> missions) {
  final seen = <(double, double, double)>{};
  for (final m in missions) {
    final t = m.priorityTerms;
    if (!seen.add((t.popNorm, t.serviceLossNorm, t.difficultyNorm))) return true;
  }
  return false;
}
