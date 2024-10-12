class SentenceData {
  String content;
  String poetryName;
  String poetId;
  String id;
  String poetName;
  String poetryId;
  String dynasty;

  SentenceData({
    required this.content,
    required this.poetryName,
    required this.poetId,
    required this.id,
    required this.poetName,
    required this.poetryId,
    required this.dynasty,
  });

  factory SentenceData.fromMap(Map<String, dynamic> map) {
    return SentenceData(
      content: map['content'] ?? '',
      poetryName: map['poetryName'] ?? '',
      poetId: map['poetId'] ?? '',
      id: map['id'] ?? '',
      poetName: map['poetName'] ?? '',
      poetryId: map['poetryId'] ?? '',
      dynasty: map['Dynasty'] ?? '',
    );
  }
}
