// models/sentence_model.dart
class Sentence {
  final String content;
  final String poetryName;
  final String poetId;
  final String id;
  final String poetName;
  final String poetryId;

  Sentence({
    this.content,
    this.poetryName,
    this.poetId,
    this.id,
    this.poetName,
    this.poetryId,
  });

  factory Sentence.fromMap(Map<String, dynamic> map) {
    return Sentence(
      content: map['content'],
      poetryName: map['poetryName'],
      poetId: map['poetId'],
      id: map['id'],
      poetName: map['poetName'],
      poetryId: map['poetryId'],
    );
  }
}
