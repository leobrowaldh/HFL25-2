int generateId(List<Map<String, dynamic>> heroes) {
  if (heroes.isEmpty) return 1;
  return (heroes.map((h) => h['id'] as int).reduce((a, b) => a > b ? a : b)) +
      1;
}

Map<String, dynamic> createHero({
  required int id,
  required String name,
  required int strength,
  required String gender,
  required String race,
  String? power,
  String alignment = 'neutral',
}) {
  return {
    'id': id,
    'name': name,
    'powerstats': {'strength': strength},
    'appearance': {'gender': gender, 'race': race},
    'biography': {'alignment': alignment},
    'power': power,
  };
}

void printHeroes(List<Map<String, dynamic>> heroes) {
  if (heroes.isEmpty) {
    print('\x1B[33mInga hjältar tillagda än.\x1B[0m');
    return;
  }

  print('\x1B[36m=== Hjältar ===\x1B[0m');
  for (var hero in heroes) {
    print(
      '\x1B[32mID: ${hero['id']} | '
      'Namn: ${hero['name']} | '
      'Styrka: ${hero['powerstats']['strength']} | '
      'Kön: ${hero['appearance']['gender']} | '
      'Ras: ${hero['appearance']['race']} | '
      'Kraft: ${hero['power'] ?? '-'} | '
      'Alignment: ${hero['biography']['alignment']}\x1B[0m',
    );
  }
}

void sortHeroesByStrength(List<Map<String, dynamic>> heroes) {
  heroes.sort(
    (a, b) => (b['powerstats']['strength'] as int).compareTo(
      a['powerstats']['strength'] as int,
    ),
  );
}

void sortHeroesByName(List<Map<String, dynamic>> heroes) {
  heroes.sort(
    (a, b) => (a['name'] as String).toLowerCase().compareTo(
      (b['name'] as String).toLowerCase(),
    ),
  );
}

List<Map<String, dynamic>> searchHeroes(
  List<Map<String, dynamic>> heroes,
  String query,
) {
  return heroes
      .where(
        (hero) =>
            hero['name'].toString().toLowerCase().contains(query.toLowerCase()),
      )
      .toList();
}

List<Map<String, dynamic>> topHeroes(List<Map<String, dynamic>> heroes, int n) {
  var sortedHeroes = List<Map<String, dynamic>>.from(heroes);
  sortHeroesByStrength(sortedHeroes);
  return sortedHeroes.take(n).toList();
}

void printMenu() {
  print('\n\x1B[36m=== HeroDex 3000 ===\x1B[0m');
  print('1. Lägg till hjälte');
  print('2. Visa alla hjältar');
  print('3. Sök hjälte');
  print('4. Avsluta');
  print('5. Visa topplista');
  print('\x1B[33mVälj ett alternativ (1-5):\x1B[0m');
}
