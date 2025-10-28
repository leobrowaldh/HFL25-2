import 'package:uuid/uuid.dart';

class HeroModel {
  final String localId;
  final String? id;
  final String name;
  final String? fullName;
  final String? alterEgos;
  final List<String>? aliases;
  final String? placeOfBirth;
  final String? firstAppearance;
  final String? publisher;
  final String? alignment;

  final String? gender;
  final String? race;
  final List<String>? height;
  final List<String>? weight;
  final String? eyeColor;
  final String? hairColor;

  final String? groupAffiliation;
  final String? relatives;

  final String? imageUrl;

  final String? intelligence;
  final String? strength;
  final String? speed;
  final String? durability;
  final String? power;
  final String? combat;

  final String? occupation;
  final String? base;

  HeroModel({
    required this.localId,
    this.id,
    required this.name,
    this.fullName,
    this.alterEgos,
    this.aliases,
    this.placeOfBirth,
    this.firstAppearance,
    this.publisher,
    this.alignment,
    this.gender,
    this.race,
    this.height,
    this.weight,
    this.eyeColor,
    this.hairColor,
    this.groupAffiliation,
    this.relatives,
    this.imageUrl,
    this.intelligence,
    this.strength,
    this.speed,
    this.durability,
    this.power,
    this.combat,
    this.occupation,
    this.base,
  });

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    return HeroModel(
      localId: json['localId'] ?? Uuid().v4(),
      id: json['id'],
      name: json['name'] ?? '',
      fullName: json['biography']?['full-name'],
      alterEgos: json['biography']?['alter-egos'],
      aliases: (json['biography']?['aliases'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      placeOfBirth: json['biography']?['place-of-birth'],
      firstAppearance: json['biography']?['first-appearance'],
      publisher: json['biography']?['publisher'],
      alignment: json['biography']?['alignment'],
      gender: json['appearance']?['gender'],
      race: json['appearance']?['race'],
      height: (json['appearance']?['height'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      weight: (json['appearance']?['weight'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      eyeColor: json['appearance']?['eye-color'],
      hairColor: json['appearance']?['hair-color'],
      groupAffiliation: json['connections']?['group-affiliation'],
      relatives: json['connections']?['relatives'],
      imageUrl: json['image']?['url'],
      intelligence: json['powerstats']?['intelligence'],
      strength: json['powerstats']?['strength'],
      speed: json['powerstats']?['speed'],
      durability: json['powerstats']?['durability'],
      power: json['powerstats']?['power'],
      combat: json['powerstats']?['combat'],
      occupation: json['work']?['occupation'],
      base: json['work']?['base'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'id': id,
      'name': name,
      'powerstats': {
        'intelligence': intelligence,
        'strength': strength,
        'speed': speed,
        'durability': durability,
        'power': power,
        'combat': combat,
      },
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
      'work': {'occupation': occupation, 'base': base},
      'image': {'url': imageUrl},
    };
  }
}
