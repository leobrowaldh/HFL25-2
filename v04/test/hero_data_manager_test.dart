import 'package:test/test.dart';
import 'package:v04/models/hero_model.dart';
import 'package:v04/managers/hero_data_manager.dart';

void main() {
  group('HeroDataManager Tests', () {
    late HeroDataManager manager;
    late HeroModel testHero1;
    late HeroModel testHero2;

    setUp(() {
      manager = HeroDataManager();
      testHero1 = HeroModel(
        localId: 'test1',
        name: 'Test Hero 1',
        fullName: 'Test Hero One',
        alignment: 'good',
        gender: 'Male',
        race: 'Human',
      );
      testHero2 = HeroModel(
        localId: 'test2',
        name: 'Test Hero 2',
        fullName: 'Test Hero Two',
        alignment: 'bad',
        gender: 'Female',
        race: 'Human',
      );
    });

    tearDown(() async {
      await manager.deleteHero(testHero1.localId);
      await manager.deleteHero(testHero2.localId);
    });

    test('save and read hero should work correctly', () async {
      await manager.saveHero(testHero1);
      final savedHero = await manager.getHeroById(testHero1.localId);

      expect(savedHero?.localId, testHero1.localId);
      expect(savedHero?.name, testHero1.name);
    });

    test('concurrent read/write operations should be handled safely', () async {
      final futures = Future.wait([
        manager.saveHero(testHero1),
        manager.saveHero(testHero1),
        manager.getHeroById(testHero1.localId),
        manager.saveHero(testHero2),
        manager.getHeroById(testHero2.localId),
      ]);

      await expectLater(futures, completes);

      final hero1 = await manager.getHeroById(testHero1.localId);
      final hero2 = await manager.getHeroById(testHero2.localId);

      expect(hero1?.name, testHero1.name);
      expect(hero2?.name, testHero2.name);
    });

    test('delete hero should remove file', () async {
      await manager.saveHero(testHero1);
      await manager.deleteHero(testHero1.localId);

      final hero = await manager.getHeroById(testHero1.localId);
      expect(hero, isNull);
    });

    test('search hero should find partial matches', () async {
      await manager.saveHero(testHero1);
      await manager.saveHero(testHero2);

      final results = await manager.searchHero('Test');
      expect(results.length, 2);

      final partialResults = await manager.searchHero('1');
      expect(partialResults.length, 1);
      expect(partialResults.first.name, contains('1'));
    });

    test('concurrent delete and read should be handled safely', () async {
      await manager.saveHero(testHero1);

      final futures = Future.wait([
        manager.deleteHero(testHero1.localId),
        manager.getHeroById(testHero1.localId),
      ]);

      await expectLater(futures, completes);
    });
  });
}
