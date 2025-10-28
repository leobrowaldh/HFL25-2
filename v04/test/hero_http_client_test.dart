import 'package:test/test.dart';
import 'package:v04/managers/hero_http_client.dart';

void main() {
  group('HeroHttpClient Tests', () {
    late HeroHttpClient client;

    setUp(() {
      client = HeroHttpClient();
    });

    tearDown(() {
      client.dispose();
    });

    test('searchHeroes should return results for valid query', () async {
      final response = await client.searchHeroes('Superman');

      expect(response.response, isNotEmpty);
      expect(response.resultsFor, isNotEmpty);
      expect(response.results, isNotEmpty);
    });
  });
}
