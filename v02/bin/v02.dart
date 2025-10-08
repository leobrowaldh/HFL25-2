import 'dart:io';
import 'package:v02/heroe.dart' as hero;

void main(List<String> arguments) {
  List<Map<String, dynamic>> heroes = [];
  String? selection;

  while (selection != '4') {
    hero.printMenu();
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
        print('Ange specialkraft (valfritt):');
        String? power = stdin.readLineSync();
        print('Ange alignment (god/ond/neutral):');
        String? alignment = stdin.readLineSync();

        if (name != null &&
            strength != null &&
            gender != null &&
            race != null) {
          int id = hero.generateId(heroes);
          var newHero = hero.createHero(
            id: id,
            name: name,
            strength: strength,
            gender: gender,
            race: race,
            power: power,
            alignment: alignment ?? 'neutral',
          );
          heroes.add(newHero);
          print('\x1B[32mHjälte tillagd!\x1B[0m');
        } else {
          print('\x1B[31mOgiltig inmatning. Försök igen.\x1B[0m');
        }
        break;

      case '2':
        hero.sortHeroesByName(heroes);
        hero.printHeroes(heroes);
        break;

      case '3':
        print('\nAnge namn eller bokstav att söka efter:');
        String? query = stdin.readLineSync();
        if (query != null && query.isNotEmpty) {
          var found = hero.searchHeroes(heroes, query);
          if (found.isEmpty) {
            print('\x1B[33mIngen hjälte hittades med "$query".\x1B[0m');
          } else {
            print('\x1B[36mMatchande hjältar:\x1B[0m');
            hero.printHeroes(found);
          }
        } else {
          print('\x1B[31mOgiltig sökning. Försök igen.\x1B[0m');
        }
        break;

      case '4':
        print('\x1B[36mAvslutar programmet. Hej då!\x1B[0m');
        break;

      case '5':
        var topp = hero.topHeroes(heroes, 3);
        print('\x1B[36mTop 3 starkaste hjältarna:\x1B[0m');
        hero.printHeroes(topp);
        break;

      default:
        print('\x1B[31mOgiltigt val. Välj 1-5.\x1B[0m');
    }
  }
}
