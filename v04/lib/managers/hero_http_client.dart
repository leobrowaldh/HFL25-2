import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:dotenv/dotenv.dart';

import 'i_hero_http_client.dart';
import '../models/http_response_model.dart';

class HeroHttpClient implements IHeroHttpClient {
  // Singleton instance
  static final HeroHttpClient _instance = HeroHttpClient._internal();

  // Factory constructor returns the same instance
  factory HeroHttpClient() => _instance;

  // Private constructor
  HeroHttpClient._internal() {
    _env.load();
  }

  final DotEnv _env = DotEnv(includePlatformEnvironment: true);
  final RetryClient _client = RetryClient(http.Client());

  Uri _buildUrl(String query) =>
      Uri.https('superheroapi.com', '/api/${_env['API_KEY']}/search/$query');

  @override
  Future<HttpResponseSearchModel> searchHeroes(String query) async {
    final url = _buildUrl(query);

    try {
      final response = await _client.get(url).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.contains('application/json') ??
            false) {
          final json = jsonDecode(response.body);
          return HttpResponseSearchModel.fromJson(json);
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to fetch heroes: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Request timed out');
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  void dispose() {
    _client.close();
  }
}
