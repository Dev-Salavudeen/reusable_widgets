import 'dart:convert';
import 'package:cross_file/cross_file.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../mimes.dart';

part 'endpoint.dart';

extension XFileExtension on XFile {
  /// Returns name of the file
  String get fileName => path.split('/').last;

  /// Returns extension of the file
  /// (e.g) .png, .jpg, .pdf ...etc
  String get extension => fileName.split('.').last;

  /// Returns mime type of the file
  /// (e.g) image/png, image/jpg, application/pdf ...etc
  String get mime => mimeDataMap[extension] ?? "text/plain";
}

extension HttpBaseClient on http.BaseClient {
  Uri getUri(String baseUri, Endpoint endpoint, {Map<String, String>? params}) {
    String path = endpoint
        // assigning parameters to the uri
        .getPath(params: params)
        // reduce multiple slashes to single slash
        .replaceAll(RegExp(r'\/+'), "/")
        // removes front and back slashes in the url
        .replaceAll(RegExp(r'(^\/+|\/+$)'), "");
    return Uri.parse([baseUri, path].join("/"));
  }

  T handleResponse<T>(
    http.Response response,
    T Function(dynamic source) decode,
  ) {
    /// Detecting invalid response
    if (response.body.isEmpty) {
      throw ServiceErrorResponse(
        statusCode: "internal",
        error: "Server Error",
        message: "Server Not Responding",
      );
    } else {
      /// The raw response object will be decoded as a map data.
      dynamic decodedResponse = jsonDecode(response.body);

      /// When client is has not received success response. throw an Exception
      if (httpIsError(response.statusCode)) {
        throw ServiceErrorResponse.fromJson(decodedResponse);
      } else {
        /// If client received an success response,
        return decode(decodedResponse);
      }
    }
  }

  bool _statusCodeBetween(int code, int begin, int end) {
    return code >= begin && code <= end;
  }

  bool httpIsOk(int? statusCode) {
    return _statusCodeBetween(statusCode ?? 0, 200, 299);
  }

  bool httpIsError(int? statusCode) {
    return !httpIsOk(statusCode);
  }

  Future<http.MultipartRequest> setFormFields(
      http.MultipartRequest request, Map<String, dynamic> input) async {
    for (var field in input.keys) {
      var value = input[field];
      if (value is XFile) {
        request.files.add(
          // 'image/png'
          http.MultipartFile.fromBytes(field, await value.readAsBytes(),
              contentType: MediaType.parse(value.mime),
              filename: value.fileName),
        );
      } else if (value is XFile) {
        request.files.add(
          http.MultipartFile.fromBytes(field, await value.readAsBytes(),
              contentType: MediaType.parse(value.mime),
              filename: value.fileName),
        );
      } else if (value is http.MultipartFile) {
        request.files.add(value);
      } else if (value is String || value is num) {
        request.fields.addAll({field: value.toString()});
      }
    }
    return request;
  }
}

class ServiceErrorResponse {
  String statusCode = "";
  String? message;
  dynamic error;

  ServiceErrorResponse({
    required this.statusCode,
    this.message,
    this.error,
  });

  ServiceErrorResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'].toString();
    message = json['message'].toString();
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['error'] = error;
    return data;
  }

  @override
  toString() => toJson().toString();

  bool get isNotFound => statusCode.toLowerCase() == "404";
  bool get isUnAuthorized => statusCode.toLowerCase() == "401";
  bool get isBadRequest => statusCode.toLowerCase() == "400";
}
