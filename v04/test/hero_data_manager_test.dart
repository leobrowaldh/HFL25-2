import 'package:test/test.dart';
import 'package:v03/models/hero_model.dart';
import 'package:v03/managers/hero_data_manager.dart';

void main() {
  group('HeroDataManager Tests', () {
    late HeroDataManager manager;
    late HeroModel testHero;

    setUp(() {
      manager = HeroDataManager();
      testHero = HeroModel(
        id: '999', // Using a high number to avoid conflicts
        name: 'Test Hero',
        fullName: 'Test Hero Full Name',
        alterEgos: 'No alter egos',
        aliases: ['Test', 'Hero'],
        placeOfBirth: 'Test City',
        firstAppearance: 'Test Comic #1',
        publisher: 'Test Comics',
        alignment: 'good',
        gender: 'Male',
        race: 'Human',
        height: ['6\'0"', '183 cm'],
        weight: ['180 lb', '82 kg'],
        eyeColor: 'Blue',
        hairColor: 'Black',
        groupAffiliation: 'Test Team',
        relatives: 'None',
        imageUrl: 'https://test.com/image.jpg',
      );
    });

    test('saveHero and deleteHero should work with files', () async {
      // Save the hero
      await manager.saveHero(testHero);

      // Verify it was saved
      final hero = await manager.getHeroById(int.parse(testHero.id));
      expect(hero?.id, testHero.id);
      expect(hero?.name, testHero.name);

      // Delete the hero
      await manager.deleteHero(int.parse(testHero.id));

      // Verify it was deleted
      final deletedHero = await manager.getHeroById(int.parse(testHero.id));
      expect(deletedHero, null);
    });

    test('searchHero should find heroes by name', () async {
      try {
        // Save the hero first
        await manager.saveHero(testHero);

        // Search for the hero
        final results = await manager.searchHero('Test');
        expect(results.length, greaterThan(0));
        expect(results.first.name, 'Test Hero');
      } finally {
        // Clean up
        await manager.deleteHero(int.parse(testHero.id));
      }
    });

    test('updateHero should modify existing hero', () async {
      try {
        // Save initial hero
        await manager.saveHero(testHero);

        // Create and save updated version
        final updatedHero = HeroModel(
          id: testHero.id,
          name: 'Updated Hero',
          fullName: testHero.fullName,
          alterEgos: testHero.alterEgos,
          aliases: testHero.aliases,
          placeOfBirth: testHero.placeOfBirth,
          firstAppearance: testHero.firstAppearance,
          publisher: testHero.publisher,
          alignment: testHero.alignment,
          gender: testHero.gender,
          race: testHero.race,
          height: testHero.height,
          weight: testHero.weight,
          eyeColor: testHero.eyeColor,
          hairColor: testHero.hairColor,
          groupAffiliation: testHero.groupAffiliation,
          relatives: testHero.relatives,
          imageUrl: testHero.imageUrl,
        );
        await manager.updateHero(updatedHero);

        // Verify update
        final hero = await manager.getHeroById(int.parse(testHero.id));
        expect(hero?.name, 'Updated Hero');
      } finally {
        // Clean up
        await manager.deleteHero(int.parse(testHero.id));
      }
    });
  });
}
