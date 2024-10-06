class QuoteModel {
  final String id; // id 使用 String 类型
  final String poetName;
  final String content;
  final String poetryName;

  QuoteModel({
    required this.id,
    required this.poetName,
    required this.content,
    required this.poetryName,
  });

  // 从 Map 中构建对象
  factory QuoteModel.fromMap(Map<String, dynamic> map) {
    return QuoteModel(
      id: map['poetryId'].toString(), // 确保 id 为 String 类型
      poetName: map['poetName'],
      content: map['content'],
      poetryName: map['poetryName'],
    );
  }
}
