import 'dart:io';
import 'dart:math' show max;
import 'package:v03/managers/hero_data_manager.dart';
import 'package:v03/models/hero_model.dart';

void printMenu() {
  print('\n\x1B[36m=== HeroDex 3000 ===\x1B[0m');
  print('1. Lägg till hjälte');
  print('2. Visa alla hjältar');
  print('3. Sök hjälte');
  print('4. Avsluta');
  print('5. Visa topplista');
  print('\x1B[33mVälj ett alternativ (1-5):\x1B[0m');
}

void printHeroes(List<HeroModel> heroes) {
  if (heroes.isEmpty) {
    print('\x1B[33mInga hjältar tillagda än.\x1B[0m');
    return;
  }

  print('\x1B[36m=== Hjältar ===\x1B[0m');
  for (var hero in heroes) {
    print(
      '\x1B[32mID: ${hero.id} | '
      'Namn: ${hero.name} | '
      'Kön: ${hero.gender} | '
      'Ras: ${hero.race} | '
      'Alignment: ${hero.alignment}\x1B[0m',
    );
  }
}

void main(List<String> arguments) async {
  final heroManager = HeroDataManager();
  String? selection;

  while (selection != '4') {
    printMenu();
    selection = stdin.readLineSync();

    switch (selection) {
      case '1':
        print('\nAnge hjältens namn:');
        String? name = stdin.readLineSync();
        print('Ange styrka (heltal):');
        int? strength = int.tryParse(stdin.readLineSync() ?? '');
        print('Ange kön:');
        String? gender = stdin.readLineSync();
        print('Ange ras:');
        String? race = stdin.readLineSync();
        print('Ange alignment (god/ond/neutral):');
        String? alignment = stdin.readLineSync();

        if (name != null &&
            strength != null &&
            gender != null &&
            race != null) {
          final heroes = await heroManager.getHeroList();
          final id =
              (heroes.isEmpty
                  ? 0
                  : heroes.map((h) => int.parse(h.id)).reduce(max)) +
              1;

          final newHero = HeroModel(
            id: id.toString(),
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
          );

          await heroManager.saveHero(newHero);
          print('\x1B[32mHjälte tillagd!\x1B[0m');
        } else {
          print('\x1B[31mOgiltig inmatning. Försök igen.\x1B[0m');
        }
        break;

      case '2':
        final heroes = await heroManager.getHeroList();
        if (heroes.isEmpty) {
          print('\x1B[33mInga hjältar tillagda än.\x1B[0m');
        } else {
          final sortedHeroes = List<HeroModel>.from(heroes)
            ..sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
            );
          printHeroes(sortedHeroes);
        }
        break;

      case '3':
        print('\nAnge namn eller bokstav att söka efter:');
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
        break;

      case '4':
        print('\x1B[36mAvslutar programmet. Hej då!\x1B[0m');
        break;

      case '5':
        final heroes = await heroManager.getHeroList();
        if (heroes.isEmpty) {
          print('\x1B[33mInga hjältar tillagda än.\x1B[0m');
        } else {
          final sortedHeroes = List<HeroModel>.from(heroes)
            ..sort((a, b) => b.id.compareTo(a.id));
          print('\x1B[36mTop 3 starkaste hjältarna:\x1B[0m');
          printHeroes(sortedHeroes.take(3).toList());
        }
        break;

      default:
        print('\x1B[31mOgiltigt val. Välj 1-5.\x1B[0m');
    }
  }
}
