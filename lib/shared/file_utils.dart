import 'dart:convert';

import 'package:core_library/core_library.dart';
import 'package:core_library/shared/mimes.dart';
import 'package:flutter/rendering.dart';

const _kDataUriPrefix = "data:";

bool isDataUri(String source) {
  return source.startsWith(_kDataUriPrefix);
}

String getDataUrlMimeType(String dataUrl) {
  final mimeTypeStartIndex = dataUrl.indexOf(':') + 1;
  final mimeTypeEndIndex = dataUrl.indexOf(';');

  if (mimeTypeStartIndex == -1 || mimeTypeEndIndex == -1) {
    throw Exception('Failed to determine MIME type for data URL: $dataUrl');
  }

  final mimeType = dataUrl.substring(mimeTypeStartIndex, mimeTypeEndIndex);
  return mimeType;
}

String getImageKind(String src) {
  if (isDataUri(src)) {
    var index =
        mimeDataMap.values.toList().lastIndexOf(getDataUrlMimeType(src));
    if (index.isValid) {
      return mimeDataMap.keys.toList().elementAt(index);
    } else {
      return 'unknown';
    }
  } else {
    var pieces = src.split(".");
    return pieces.length > 1 ? pieces.last : 'unknown';
  }
}

ImageProvider getImageProviderFromDataUrl(String value, double scale) {
  final encode = value.split(',').last;
  final bytes = const Base64Decoder().convert(encode);
  return ResizeImage.resizeIfNeeded(
    null,
    null,
    MemoryImage(bytes, scale: scale),
  );
}
