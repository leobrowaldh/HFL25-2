class HeroModel {
  final String id;
  final String name;
  final String fullName;
  final String alterEgos;
  final List<String> aliases;
  final String placeOfBirth;
  final String firstAppearance;
  final String publisher;
  final String alignment;

  final String gender;
  final String race;
  final List<String> height;
  final List<String> weight;
  final String eyeColor;
  final String hairColor;

  final String groupAffiliation;
  final String relatives;

  final String imageUrl;

  HeroModel({
    required this.id,
    required this.name,
    required this.fullName,
    required this.alterEgos,
    required this.aliases,
    required this.placeOfBirth,
    required this.firstAppearance,
    required this.publisher,
    required this.alignment,
    required this.gender,
    required this.race,
    required this.height,
    required this.weight,
    required this.eyeColor,
    required this.hairColor,
    required this.groupAffiliation,
    required this.relatives,
    required this.imageUrl,
  });

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    return HeroModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      fullName: json['biography']['full-name'] ?? '',
      alterEgos: json['biography']['alter-egos'] ?? 'No alter egos found',
      aliases: List<String>.from(json['biography']['aliases'] ?? []),
      placeOfBirth: json['biography']['place-of-birth'] ?? '',
      firstAppearance: json['biography']['first-appearance'] ?? '',
      publisher: json['biography']['publisher'] ?? '',
      alignment: json['biography']['alignment'] ?? '',
      gender: json['appearance']['gender'] ?? '',
      race: json['appearance']['race'] ?? '',
      height: List<String>.from(json['appearance']['height'] ?? []),
      weight: List<String>.from(json['appearance']['weight'] ?? []),
      eyeColor: json['appearance']['eye-color'] ?? '',
      hairColor: json['appearance']['hair-color'] ?? '',
      groupAffiliation: json['connections']['group-affiliation'] ?? '',
      relatives: json['connections']['relatives'] ?? '',
      imageUrl: json['image']['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'biography': {
        'full-name': fullName,
        'alter-egos': alterEgos,
        'aliases': aliases,
        'place-of-birth': placeOfBirth,
        'first-appearance': firstAppearance,
        'publisher': publisher,
        'alignment': alignment,
      },
      'appearance': {
        'gender': gender,
        'race': race,
        'height': height,
        'weight': weight,
        'eye-color': eyeColor,
        'hair-color': hairColor,
      },
      'connections': {
        'group-affiliation': groupAffiliation,
        'relatives': relatives,
      },
      'image': {'url': imageUrl},
    };
  }
}
