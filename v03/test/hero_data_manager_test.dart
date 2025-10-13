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
        id: '1',
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

    test('saveHero should add hero to the list', () async {
      await manager.saveHero(testHero);
      final heroes = await manager.getHeroList();
      expect(heroes.contains(testHero), true);
    });

    test('searchHero should find heroes by name', () async {
      await manager.saveHero(testHero);
      final results = await manager.searchHero('Test');
      expect(results.length, 1);
      expect(results.first.name, 'Test Hero');
    });

    test('getHeroById should return correct hero', () async {
      await manager.saveHero(testHero);
      final hero = await manager.getHeroById(int.parse(testHero.id));
      expect(hero?.id, testHero.id);
      expect(hero?.name, testHero.name);
    });

    test('deleteHero should remove hero from list', () async {
      await manager.saveHero(testHero);
      await manager.deleteHero(int.parse(testHero.id));
      final hero = await manager.getHeroById(int.parse(testHero.id));
      expect(hero, null);
    });

    test('updateHero should modify existing hero', () async {
      await manager.saveHero(testHero);
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
      final hero = await manager.getHeroById(int.parse(testHero.id));
      expect(hero?.name, 'Updated Hero');
    });
  });
}
