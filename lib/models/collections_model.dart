class CollectionModel {
  final String title;
  final String kind;

  CollectionModel({required this.title, required this.kind});

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      title: json['Title'] as String,
      kind: json['Kind'] as String,
    );
  }
}
