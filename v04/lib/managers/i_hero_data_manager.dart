import '../models/hero_model.dart';

abstract class IHeroDataManager {
  Future<void> saveHero(HeroModel hero);
  Future<List<HeroModel>> getHeroList();
  Future<List<HeroModel>> searchHero(String query);
  Future<void> parseData(String jsonData);
  Future<void> deleteHero(String id);
  Future<HeroModel?> getHeroById(String id);
  Future<void> updateHero(HeroModel hero);
}
