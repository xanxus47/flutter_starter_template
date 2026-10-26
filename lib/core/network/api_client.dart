import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:template_kit/core/config/api_config.dart';
import 'package:template_kit/core/network/api_exception.dart';

class ApiClient {
  ApiClient({http.Client? httpClient, this.baseUrl = ApiConfig.baseUrl})
    : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;
  final String baseUrl;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String?> query = const {},
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: {
        for (final entry in query.entries)
          if (entry.value != null && entry.value!.isNotEmpty)
            entry.key: entry.value!,
      },
    );

    try {
      final response = await _httpClient
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(ApiConfig.timeout);
      return _decode(response);
    } on TimeoutException {
      throw const ApiException('Request timed out. Please try again.');
    } on http.ClientException {
      throw const ApiException('Unable to reach the server.');
    }
  }

  Map<String, dynamic> _decode(http.Response response) {
    final Object? body = response.body.isEmpty
        ? const <String, dynamic>{}
        : jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (body is Map<String, dynamic>) return body;
      throw const ApiException('Unexpected response from the server.');
    }

    final message = body is Map && body['error'] is String
        ? body['error'] as String
        : 'Request failed (${response.statusCode}).';
    throw ApiException(message, statusCode: response.statusCode);
  }
}
