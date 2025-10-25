import 'dart:convert';
import 'dart:io';
import '../models/hero_model.dart';
import 'hero_data_managing.dart';

class HeroDataManager implements HeroDataManaging {
  static final HeroDataManager _instance = HeroDataManager._internal();
  final String _dataPath = 'lib/data/heroes';

  factory HeroDataManager() {
    return _instance;
  }

  HeroDataManager._internal() {
    _createDataDirectoryIfNeeded();
  }

  void _createDataDirectoryIfNeeded() {
    final dir = Directory(_dataPath);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }

  String _getHeroFilePath(String id) => '$_dataPath/hero_$id.json';

  Future<void> _writeHeroToFile(HeroModel hero) async {
    final file = File(_getHeroFilePath(hero.localId));
    await file.writeAsString(json.encode(hero.toJson()));
  }

  Future<HeroModel?> _readHeroFromFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!file.existsSync()) return null;
      final content = await file.readAsString();
      return HeroModel.fromJson(json.decode(content));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveHero(HeroModel hero) async {
    await _writeHeroToFile(hero);
  }

  @override
  Future<List<HeroModel>> getHeroList() async {
    final dir = Directory(_dataPath);
    if (!dir.existsSync()) return [];

    final heroFiles = dir.listSync().whereType<File>().where(
      (file) => file.path.endsWith('.json'),
    );

    final heroes = <HeroModel>[];
    for (var file in heroFiles) {
      final hero = await _readHeroFromFile(file.path);
      if (hero != null) heroes.add(hero);
    }

    return heroes;
  }

  @override
  Future<List<HeroModel>> searchHero(String query) async {
    final allHeroes = await getHeroList();
    return allHeroes
        .where((hero) => hero.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<void> parseData(String jsonData) async {
    final List<dynamic> jsonList = json.decode(jsonData);
    for (var json in jsonList) {
      final hero = HeroModel.fromJson(json);
      await saveHero(hero);
    }
  }

  @override
  Future<void> deleteHero(int id) async {
    final file = File(_getHeroFilePath(id.toString()));
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<HeroModel?> getHeroById(int id) async {
    return await _readHeroFromFile(_getHeroFilePath(id.toString()));
  }

  @override
  Future<void> updateHero(HeroModel hero) async {
    await _writeHeroToFile(hero);
  }
}
