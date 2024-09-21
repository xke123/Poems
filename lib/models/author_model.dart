class AuthorModel {
  final int id;
  final String name;

  AuthorModel({required this.id, required this.name});

  factory AuthorModel.fromMap(Map<String, dynamic> map) {
    return AuthorModel(
      id: int.parse(map['Id']),
      name: map['Name'] ?? '未知作者',
    );
  }

  @override
  String toString() {
    return 'AuthorModel(id: $id, name: $name)';
  }
}
