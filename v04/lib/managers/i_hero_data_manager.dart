import '../models/hero_model.dart';

abstract class IHeroDataManager {
  Future<void> saveHero(HeroModel hero);
  Future<List<HeroModel>> getHeroList();
  Future<List<HeroModel>> searchHero(String query);
  Future<void> parseData(String jsonData);
  Future<void> deleteHero(int id);
  Future<HeroModel?> getHeroById(int id);
  Future<void> updateHero(HeroModel hero);
}
