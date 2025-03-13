import 'package:flutter/foundation.dart';

class HttpRequest {
  final String url;
  final String method;
  final String headers;
  final String requestBody;
  final String responseBody;
  final int? statusCode;
  final DateTime timestamp;

  HttpRequest({
    required this.url,
    required this.method,
    this.headers = '',
    this.requestBody = '',
    this.responseBody = '',
    this.statusCode,
  }) : timestamp = DateTime.now();
}

class NetworkLogger {
  static final List<HttpRequest> requests = [];

  static void logRequest({
    required String url,
    required String method,
    String headers = '',
    String requestBody = '',
    String responseBody = '',
    int? statusCode,
  }) {
    if (kDebugMode) {
      requests.add(HttpRequest(
        url: url,
        method: method,
        headers: headers,
        requestBody: requestBody,
        responseBody: responseBody,
        statusCode: statusCode,
      ));
    }
  }
}
