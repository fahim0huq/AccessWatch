// Timing logs for profile builds only (flutter run/build --profile). Release and
// debug builds skip all of it: kProfileMode is a compile-time constant.
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

final Stopwatch _sinceStart = Stopwatch();

/// Call first thing in main().
void perfStart() {
  if (kProfileMode) _sinceStart.start();
}

/// Logs a moment since start, such as the first frame or the bundle being ready.
void perfMark(String what) {
  if (kProfileMode) debugPrint('AW-PERF $what at ${_sinceStart.elapsedMilliseconds} ms');
}

/// Logs how long [work] takes, labelled [what].
Future<T> perfTime<T>(String what, Future<T> work) async {
  if (!kProfileMode) return work;
  final watch = Stopwatch()..start();
  final result = await work;
  debugPrint('AW-PERF $what took ${watch.elapsedMilliseconds} ms');
  return result;
}

/// Logs frame build and raster times in batches of 60 frames.
void perfWatchFrames() {
  if (!kProfileMode) return;
  final frames = <FrameTiming>[];
  SchedulerBinding.instance.addTimingsCallback((timings) {
    frames.addAll(timings);
    if (frames.length < 60) return;
    String stats(List<double> ms) {
      ms.sort();
      double at(double q) => ms[((ms.length - 1) * q).round()];
      return 'p50 ${at(0.5).toStringAsFixed(1)} p90 ${at(0.9).toStringAsFixed(1)} max ${ms.last.toStringAsFixed(1)} ms';
    }

    final build = [for (final f in frames) f.buildDuration.inMicroseconds / 1000];
    final raster = [for (final f in frames) f.rasterDuration.inMicroseconds / 1000];
    final slow = frames.where((f) => f.totalSpan.inMicroseconds > 16667).length;
    debugPrint('AW-PERF frames ${frames.length}: build ${stats(build)} | raster ${stats(raster)} | over 16.7 ms: $slow');
    frames.clear();
  });
}
