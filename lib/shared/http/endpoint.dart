part of 'http.dart';

enum ReqMethod { post, get, delete, put, patch }

class Endpoint {
  String path = "/";

  Map<String, String> queries = {};

  String getPath({Map<String, String>? params}) {
    String location = path;

    if (params != null && params.isNotEmpty) {
      final exp = RegExp(r':\w+\-*\w*\B.');
      location = path.replaceAllMapped(exp, (Match m) {
        String key = path.substring(m.start + 1, m.end);
        return params[key] ?? key;
      });
    }

    if (queries.isNotEmpty) {
      String query = queries.entries
          .map((entry) => "${entry.key}=${entry.value}")
          .join("&");

      location += location.contains("?") ? "&$query" : "?$query";
    }

    return location;
  }

  void addQuery(String key, String value) {
    queries[key] = value;
  }

  Endpoint(this.path);
}
