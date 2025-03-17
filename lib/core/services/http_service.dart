import 'package:http/http.dart' as http;
import 'package:inventory_platform/core/debug/network_logger.dart';
import 'dart:convert';

class HttpService {
  final http.Client _client = http.Client();

  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    try {
      final response = await _client.get(Uri.parse(url), headers: headers);
      _logRequest(url, 'GET', headers, '', response);
      return response;
    } catch (e) {
      _logError(url, 'GET', headers, '', e);
      rethrow;
    }
  }

  Future<http.Response> post(String url,
      {Map<String, String>? headers, Object? body}) async {
    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      _logRequest(url, 'POST', headers, body.toString(), response);
      return response;
    } catch (e) {
      _logError(url, 'POST', headers, body.toString(), e);
      rethrow;
    }
  }

  // Add other methods like put, delete, etc.

  void _logRequest(String url, String method, Map<String, String>? headers,
      String body, http.Response response) {
    NetworkLogger.logRequest(
      url: url,
      method: method,
      headers: headers != null ? json.encode(headers) : '',
      requestBody: body,
      responseBody: response.body,
      statusCode: response.statusCode,
    );
  }

  void _logError(String url, String method, Map<String, String>? headers,
      String body, Object error) {
    NetworkLogger.logRequest(
      url: url,
      method: method,
      headers: headers != null ? json.encode(headers) : '',
      requestBody: body,
      responseBody: 'Error: $error',
    );
  }
}
