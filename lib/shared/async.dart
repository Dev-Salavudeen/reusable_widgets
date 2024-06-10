import 'dart:async';


import 'extensions.dart';

typedef AsyncFunction<T> = FutureOr<T> Function();

Future<T?> retryBlock<T>(int retries, WhenRetryCallback? whenRetry,
    AsyncFunction<T?> function) async {
  return await Future.sync(() => function())
      .withRetry(retries: retries, whenRetry: whenRetry);
}
