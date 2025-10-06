import 'package:test/test.dart';
import 'package:v02/heroe.dart';

void main() {
  group('Hero Management Tests', () {
    late List<Map<String, dynamic>> heroes;

    setUp(() {
      // Reset heroes list before each test
      heroes = [];
    });

    test('generateId should start from 1 and increment', () {
      expect(generateId(heroes), equals(1));

      heroes.add(
        createHero(
          id: 1,
          name: 'Test Hero',
          strength: 10,
          gender: 'Male',
          race: 'Human',
        ),
      );

      expect(generateId(heroes), equals(2));
    });

    test('createHero should create hero with correct structure', () {
      final hero = createHero(
        id: 1,
        name: 'Superman',
        strength: 100,
        gender: 'Male',
        race: 'Kryptonian',
        power: 'Flight',
        alignment: 'god',
      );

      expect(hero['id'], equals(1));
      expect(hero['name'], equals('Superman'));
      expect(hero['powerstats']['strength'], equals(100));
      expect(hero['appearance']['gender'], equals('Male'));
      expect(hero['appearance']['race'], equals('Kryptonian'));
      expect(hero['power'], equals('Flight'));
      expect(hero['biography']['alignment'], equals('god'));
    });

    test('sortHeroesByStrength should sort heroes by strength', () {
      heroes.addAll([
        createHero(
          id: 1,
          name: 'Weak Hero',
          strength: 5,
          gender: 'Male',
          race: 'Human',
        ),
        createHero(
          id: 2,
          name: 'Strong Hero',
          strength: 15,
          gender: 'Female',
          race: 'Human',
        ),
        createHero(
          id: 3,
          name: 'Medium Hero',
          strength: 10,
          gender: 'Male',
          race: 'Human',
        ),
      ]);

      sortHeroesByStrength(heroes);

      expect(heroes[0]['name'], equals('Strong Hero'));
      expect(heroes[1]['name'], equals('Medium Hero'));
      expect(heroes[2]['name'], equals('Weak Hero'));
    });

    test('searchHeroes should find heroes by partial name match', () {
      heroes.addAll([
        createHero(
          id: 1,
          name: 'Batman',
          strength: 10,
          gender: 'Male',
          race: 'Human',
        ),
        createHero(
          id: 2,
          name: 'Superman',
          strength: 20,
          gender: 'Male',
          race: 'Kryptonian',
        ),
        createHero(
          id: 3,
          name: 'Batgirl',
          strength: 8,
          gender: 'Female',
          race: 'Human',
        ),
      ]);

      final results = searchHeroes(heroes, 'bat');
      expect(results.length, equals(2));
      expect(
        results.map((h) => h['name']).toList(),
        containsAll(['Batman', 'Batgirl']),
      );
    });

    test('searchHeroes should be case insensitive', () {
      heroes.add(
        createHero(
          id: 1,
          name: 'Batman',
          strength: 10,
          gender: 'Male',
          race: 'Human',
        ),
      );

      expect(searchHeroes(heroes, 'BATMAN').length, equals(1));
      expect(searchHeroes(heroes, 'batman').length, equals(1));
      expect(searchHeroes(heroes, 'BaT').length, equals(1));
    });

    test('topHeroes should return N strongest heroes', () {
      heroes.addAll([
        createHero(
          id: 1,
          name: 'Weak Hero',
          strength: 5,
          gender: 'Male',
          race: 'Human',
        ),
        createHero(
          id: 2,
          name: 'Strong Hero',
          strength: 15,
          gender: 'Female',
          race: 'Human',
        ),
        createHero(
          id: 3,
          name: 'Medium Hero',
          strength: 10,
          gender: 'Male',
          race: 'Human',
        ),
        createHero(
          id: 4,
          name: 'Strongest Hero',
          strength: 20,
          gender: 'Female',
          race: 'Human',
        ),
      ]);

      final top2 = topHeroes(heroes, 2);
      expect(top2.length, equals(2));
      expect(top2[0]['name'], equals('Strongest Hero'));
      expect(top2[1]['name'], equals('Strong Hero'));
    });

    test(
      'createHero should use default neutral alignment when not specified',
      () {
        final hero = createHero(
          id: 1,
          name: 'Test Hero',
          strength: 10,
          gender: 'Male',
          race: 'Human',
        );

        expect(hero['biography']['alignment'], equals('neutral'));
      },
    );
  });
}
