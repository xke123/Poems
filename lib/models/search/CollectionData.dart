class CollectionData {
  int id;
  String title;
  String kind;
  String dynasty;

  CollectionData({
    required this.id,
    required this.title,
    required this.kind,
    required this.dynasty,
  });

  factory CollectionData.fromMap(Map<String, dynamic> map) {
    return CollectionData(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      kind: map['kind'] ?? '',
      dynasty: map['dynasty'] ?? '',
    );
  }
}
