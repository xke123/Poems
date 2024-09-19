class QuoteModel {
  final String content;
  final String poetryName;
  final String poetName;

  QuoteModel({required this.content, required this.poetryName, required this.poetName});

  factory QuoteModel.fromMap(Map<String, dynamic> map) {
    return QuoteModel(
      content: map['content'],
      poetryName: map['poetryName'],
      poetName: map['poetName'],
    );
  }
}
