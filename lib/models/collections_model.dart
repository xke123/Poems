// lib/models/collections_model.dart

class CollectionModel {
  final int id;
  final String title;
  final String kind;

  CollectionModel({
    required this.id,
    required this.title,
    required this.kind,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      id: json['id'],
      title: json['title'],
      kind: json['kind'],
    );
  }

  factory CollectionModel.fromMap(Map<String, dynamic> map) {
    return CollectionModel(
      id: map['id'],
      title: map['title'],
      kind: map['kind'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'kind': kind,
    };
  }
}
