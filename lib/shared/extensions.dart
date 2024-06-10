import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

typedef JSON = Map<String, dynamic>;
typedef ValueReturn = T Function<T>();

extension MapExtension on Map {
  bool hasProp(Object key) {
    return containsKey(key) && this[key] != null;
  }
}

extension ContextExtension on BuildContext {
  TimeOfDay get timeOfDay => TimeOfDay.now();

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  MediaQueryData get screen => MediaQuery.of(this);

  double get longestSize => screen.size.longestSide;

  double get width => screen.size.width;

  double get height => screen.size.height;

  Orientation get orientation => screen.orientation;

  bool get isPortrait => screen.orientation == Orientation.portrait;

  bool get isLandscape => screen.orientation == Orientation.landscape;

  Future<T?> goto<T extends Object?>(
    Widget Function() builder,
  ) {
    Route<T> route = MaterialPageRoute<T>(builder: (_) => builder());
    return Navigator.push(this, route);
  }

  Future<T?> toReplace<T extends Object?, TO extends Object?>(
      Widget Function() builder,
      {TO? result}) {
    var route = MaterialPageRoute<T>(builder: (_) => builder());
    return Navigator.pushReplacement(this, route, result: result);
  }

  Future<T?> restartWith<T extends Object?, TO extends Object?>(
      Widget Function() builder,
      {RoutePredicate? predicate}) {
    var route = MaterialPageRoute<T>(builder: (_) => builder());
    return Navigator.pushAndRemoveUntil(
        this, route, predicate ?? (Route<dynamic> route) => false);
  }

  void back<T extends Object?>([T? result]) {
    return Navigator.pop<T>(this, result);
  }
}

extension NavStateExtension on NavigatorState {
  Future<T?> goto<T extends Object?>(
    Widget Function() builder,
  ) {
    Route<T> route = MaterialPageRoute<T>(builder: (_) => builder());
    return push(route);
  }

  Future<T?> toReplace<T extends Object?, TO extends Object?>(
      Widget Function() builder,
      {TO? result}) {
    var route = MaterialPageRoute<T>(builder: (_) => builder());
    return pushReplacement(route, result: result);
  }

  Future<T?> restartWith<T extends Object?, TO extends Object?>(
      Widget Function() builder,
      {RoutePredicate? predicate}) {
    var route = MaterialPageRoute<T>(builder: (_) => builder());
    return pushAndRemoveUntil(
        route, predicate ?? (Route<dynamic> route) => false);
  }

  void back<T extends Object?>([T? result]) {
    return pop<T>(result);
  }
}

extension DoubleExtension on double {
  double x(num v) => v * this;
}

extension IntExtension on int {
  int x(num v) => (v * this).toInt();
}

extension NumberExtension on num {
  bool get isZero => this == 0;
  bool get isValid => !isNaN && !isInfinite;
}

extension DateExtension on DateTime {
  TimeOfDay get tod => TimeOfDay.fromDateTime(this);

  bool get isToday {
    var today = DateTime.now();
    return day == today.day && month == today.month && year == today.year;
  }

  bool get isPast {
    var today = DateTime.now();
    return difference(today) <= Duration.zero;
  }

  bool isSameOrBefore(DateTime other) {
    return isBefore(other) || isAtSameMomentAs(other);
  }

  bool isSameOrAfter(DateTime other) {
    return isAfter(other) || isAtSameMomentAs(other);
  }

  // set the time of the date with the given [hour] and [minute].
  DateTime concatTime([int hour = 0, int minute = 0]) {
    return DateTime(
      year,
      month,
      day,
      hour,
      minute,
    );
  }
}

extension TextEditingControllerExtension on TextEditingController {
  void moveCursorEnd() {
    selection = TextSelection.fromPosition(TextPosition(offset: text.length));
  }

  void moveCursorStart() {
    selection = TextSelection.fromPosition(const TextPosition(offset: 0));
  }
}

extension WidgetsBindingExtension on WidgetsBinding {
  bool isPaused() => lifecycleState == AppLifecycleState.paused;

  bool isDetached() => lifecycleState == AppLifecycleState.detached;

  bool isInactive() => lifecycleState == AppLifecycleState.inactive;

  bool isResumed() => lifecycleState == AppLifecycleState.resumed;

  bool isActive() => isPaused() || isResumed();
}

typedef WhenRetryCallback = Future<bool> Function(Object e);

extension FutureExtension<T> on Future<T> {
  Future<T> withRetry({int retries = 1, WhenRetryCallback? whenRetry}) async {
    try {
      return await this;
    } catch (e) {
      bool canRetry = e is TimeoutException || e is SocketException;
      if (whenRetry != null) canRetry = canRetry || await whenRetry(e);
      if (canRetry && retries > 0) {
        debugPrint("($retries) - Retrying $runtimeType");
        return await withRetry(retries: retries - 1);
      }
      rethrow;
    }
  }
}

Future<void> copyToClipboard(String content) async {
  var copyData = ClipboardData(text: content);
  await Clipboard.setData(copyData);
}

extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  Color highlightBw() {
    final hsl = HSLColor.fromColor(this);
    return hsl.lightness < .5
        ? const Color(0xFFFFFFFF)
        : const Color(0xFF000000);
  }
}

extension DurationExtension on Duration {
  String format(String pattern) {
    int h = inHours;
    int m = inMinutes.remainder(60);
    int s = inSeconds.remainder(60);
    var dateTime = DateTime(1, 1, 1, h, m, s);
    return DateFormat(pattern).format(dateTime);
  }
}
