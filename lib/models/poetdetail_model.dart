class PoetDetailModel {
  final String dynasty;
  final String name;
  final String desc;
  final String id;
  final String birthYear;
  final String deathYear;
  final bool hasImage;

  PoetDetailModel({
    required this.dynasty,
    required this.name,
    required this.desc,
    required this.id,
    required this.birthYear,
    required this.deathYear,
    required this.hasImage,
  });

  factory PoetDetailModel.fromMap(Map<String, dynamic> map) {
    return PoetDetailModel(
      dynasty: map['Dynasty'],
      name: map['Name'],
      desc: map['Desc'],
      id: map['Id'],
      birthYear: map['BirthYear'],
      deathYear: map['DeathYear'],
      hasImage: map['HasImage'] == 1, // sqflite存储Boolean时使用1/0
    );
  }

  @override
  String toString() {
    return 'PoetDetailModel(dynasty: $dynasty, name: $name, desc: $desc, id: $id, birthYear: $birthYear, deathYear: $deathYear, hasImage: $hasImage)';
  }
}
