import 'dart:io';
import 'package:v04/managers/hero_data_manager.dart';
import 'package:v04/managers/hero_http_client.dart';
import 'package:v04/models/hero_model.dart';
import 'package:uuid/uuid.dart';

void main(List<String> arguments) async {
  final heroManager = HeroDataManager();
  final httpClient = HeroHttpClient();
  String? selection;

  while (selection != '7') {
    printMenu();
    selection = stdin.readLineSync();

    switch (selection) {
      case '1':
        await createHero(heroManager);
        break;

      case '2':
        await showLocalHeroes(heroManager);
        break;

      case '3':
        await searchLocalHeroe(heroManager);
        break;

      case '4':
        await fetchApiHero(httpClient, heroManager);
        break;

      case '5':
        await showStrongestHeroes(heroManager);
        break;

      case '6':
        await deleteHero(heroManager);
        break;

      case '7':
        print('\x1B[36mAvslutar programmet. Hej då!\x1B[0m');
        break;

      default:
        print('\x1B[31mOgiltigt val. Välj 1-5.\x1B[0m');
    }
  }
}

Future<void> deleteHero(HeroDataManager heroManager) async {
  var heroes = await heroManager.getHeroList();
  printHeroes(heroes);
  print('\n\x1B[36mAnge index för hjälten du vill radera:\x1B[0m');
  String? indexInput = stdin.readLineSync();
  int? selectedIndex = int.tryParse(indexInput ?? '');

  if (selectedIndex != null &&
      selectedIndex >= 0 &&
      selectedIndex < heroes.length) {
    final selectedHero = heroes[selectedIndex];

    await heroManager.deleteHero(selectedHero.localId);
    print('\x1B[32m${selectedHero.name} raderad.\x1B[0m');
  } else {
    print('\x1B[31mOgiltigt index. Försök igen.\x1B[0m');
  }
}

Future<void> showStrongestHeroes(HeroDataManager heroManager) async {
  final heroes = await heroManager.getHeroList();
  if (heroes.isEmpty) {
    print('\x1B[33mInga hjältar tillagda än.\x1B[0m');
  } else {
    final sortedHeroes = List<HeroModel>.from(heroes)
      ..sort(
        (a, b) => (int.tryParse(b.strength ?? '0') ?? 0).compareTo(
          int.tryParse(a.strength ?? '0') ?? 0,
        ),
      );

    print('\x1B[36mTop 3 starkaste hjältarna:\x1B[0m');
    printHeroes(sortedHeroes.take(3).toList());
  }
}

Future<void> fetchApiHero(
  HeroHttpClient httpClient,
  HeroDataManager heroManager,
) async {
  print('\nAnge namn på hjälten du vill lägga till:');
  String? query = stdin.readLineSync();

  if (query != null && query.isNotEmpty) {
    try {
      final httpResponse = await httpClient.searchHeroes(query);

      if (httpResponse.response != 'success' || httpResponse.results.isEmpty) {
        print('\x1B[33mIngen hjälte hittades med "$query".\x1B[0m');
      } else {
        print('\x1B[36mMatchande hjältar:\x1B[0m');
        printHeroes(httpResponse.results);

        print('\n\x1B[36mAnge index för hjälten du vill spara lokalt:\x1B[0m');
        String? indexInput = stdin.readLineSync();
        int? selectedIndex = int.tryParse(indexInput ?? '');

        if (selectedIndex != null &&
            selectedIndex >= 0 &&
            selectedIndex < httpResponse.results.length) {
          final selectedHero = httpResponse.results[selectedIndex];

          await heroManager.saveHero(selectedHero);
          print('\x1B[32m${selectedHero.name} sparad lokalt!\x1B[0m');
        } else {
          print('\x1B[31mOgiltigt index. Försök igen.\x1B[0m');
        }
      }
    } catch (e) {
      print('\x1B[31mFel vid hämtning. Försök igen.\x1B[0m');
    }
  } else {
    print('\x1B[31mOgiltig sökning. Försök igen.\x1B[0m');
  }
}

Future<void> searchLocalHeroe(HeroDataManager heroManager) async {
  print('\nAnge namn att söka efter:');
  String? query = stdin.readLineSync();
  if (query != null && query.isNotEmpty) {
    final found = await heroManager.searchHero(query);
    if (found.isEmpty) {
      print('\x1B[33mIngen hjälte hittades med "$query".\x1B[0m');
    } else {
      print('\x1B[36mMatchande hjältar:\x1B[0m');
      printHeroes(found);
    }
  } else {
    print('\x1B[31mOgiltig sökning. Försök igen.\x1B[0m');
  }
}

Future<void> showLocalHeroes(HeroDataManager heroManager) async {
  final heroes = await heroManager.getHeroList();
  if (heroes.isEmpty) {
    print('\x1B[33mInga hjältar tillagda än.\x1B[0m');
  } else {
    print('\x1B[33mVälj ett alternativ (1-3):\x1B[0m');
    print('\n1. Visa alla hjältar');
    print('2. Visa goda hjältar');
    print('3. visa onda hjältar');
    String? filterChoice = stdin.readLineSync();

    List<HeroModel> filteredHeroes = List<HeroModel>.from(heroes);

    switch (filterChoice) {
      case '2':
        filteredHeroes = filteredHeroes
            .where((hero) => (hero.alignment ?? '').toLowerCase() == 'good')
            .toList();
        break;
      case '3':
        filteredHeroes = filteredHeroes
            .where((hero) => (hero.alignment ?? '').toLowerCase() == 'evil')
            .toList();
        break;
    }

    filteredHeroes.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    printHeroes(filteredHeroes);
  }
}

Future<void> createHero(HeroDataManager heroManager) async {
  print('\nAnge hjältens namn:');
  String? name = stdin.readLineSync();
  print('Ange styrka (1 - 100):');
  int? strength = int.tryParse(stdin.readLineSync() ?? '0');
  print('Ange kön:');
  String? gender = stdin.readLineSync();
  print('Ange ras:');
  String? race = stdin.readLineSync();
  print('Ange alignment (god/ond/neutral):');
  String? alignment = stdin.readLineSync();

  if (name != null && strength != null && gender != null && race != null) {
    final newHero = HeroModel(
      localId: Uuid().v4(),
      name: name,
      fullName: name,
      alterEgos: 'No alter egos found',
      aliases: [],
      placeOfBirth: 'Unknown',
      firstAppearance: 'Unknown',
      publisher: 'HeroDex',
      alignment: alignment ?? 'neutral',
      gender: gender,
      race: race,
      height: ['Unknown'],
      weight: ['Unknown'],
      eyeColor: 'Unknown',
      hairColor: 'Unknown',
      groupAffiliation: 'None',
      relatives: 'None',
      imageUrl: '',
      strength: strength.toString(),
    );

    await heroManager.saveHero(newHero);
    print('\x1B[32mHjälte tillagd!\x1B[0m');
  } else {
    print('\x1B[31mOgiltig inmatning. Försök igen.\x1B[0m');
  }
}

void printMenu() {
  print('\n\x1B[36m=== HeroDex 3000 ===\x1B[0m');
  print('1. Skapa egen hjälte');
  print('2. Visa sparade hjältar');
  print('3. Sök sparad hjälte');
  print('4. Hämta en hjälte från HjälteLand');
  print('5. Visa topplista');
  print('6. Radera en hjälte');
  print('7. Avsluta');
  print('\x1B[33mVälj ett alternativ (1-7):\x1B[0m');
}

void printHeroes(List<HeroModel> heroes) {
  if (heroes.isEmpty) {
    print('\x1B[33mInga hjältar tillagda än.\x1B[0m');
    return;
  }

  print('\x1B[36m=== Hjältar ===\x1B[0m');
  for (int i = 0; i < heroes.length; i++) {
    final hero = heroes[i];

    print(
      '\x1B[32m[$i]\x1B[0m '
      'Namn: ${hero.name} | '
      'Kön: ${hero.gender ?? 'Okänd'} | '
      'Ras: ${hero.race ?? 'Okänd'} | '
      'Styrka: ${hero.strength ?? '0'} | '
      'Alignment: ${hero.alignment ?? 'neutral'}',
    );
  }
}
