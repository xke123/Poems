class AuthorData {
  String dynasty;
  String name;
  String desc;
  String id;
  String birthYear;
  String deathYear;
  bool hasImage;

  AuthorData({
    required this.dynasty,
    required this.name,
    required this.desc,
    required this.id,
    required this.birthYear,
    required this.deathYear,
    required this.hasImage,
  });

  factory AuthorData.fromMap(Map<String, dynamic> map) {
    return AuthorData(
      dynasty: map['Dynasty'] ?? '',
      name: map['Name'] ?? '',
      desc: map['Desc'] ?? '',
      id: map['Id'] ?? '',
      birthYear: map['BirthYear'] ?? '',
      deathYear: map['DeathYear'] ?? '',
      hasImage: map['HasImage'] == 1 || map['HasImage'] == true,
    );
  }
}
