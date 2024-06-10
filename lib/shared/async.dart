import 'dart:async';

import 'package:core_library/core_library.dart';

typedef AsyncFunction<T> = FutureOr<T> Function();

Future<T?> retryBlock<T>(int retries, WhenRetryCallback? whenRetry,
    AsyncFunction<T?> function) async {
  return await Future.sync(() => function())
      .withRetry(retries: retries, whenRetry: whenRetry);
}
