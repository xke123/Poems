class PoemDetailModel {
  final String authorId;
  final String intro;
  final String id;
  final String comment;
  final String author;
  final String title;
  final String kind;
  final String translation;
  final String content;
  final String dynasty;
  final String postsCount;
  final String annotation;

  PoemDetailModel({
    required this.authorId,
    required this.intro,
    required this.id,
    required this.comment,
    required this.author,
    required this.title,
    required this.kind,
    required this.translation,
    required this.content,
    required this.dynasty,
    required this.postsCount,
    required this.annotation,
  });

  // 从 Map 构建对象
  factory PoemDetailModel.fromMap(Map<String, dynamic> map) {
    return PoemDetailModel(
      authorId: map['AuthorId'] ?? '无',
      intro: map['Intro'] ?? '无',
      id: map['Id'].toString(),
      comment: map['Comment'] ?? '无',
      author: map['Author'] ?? '未知作者',
      title: map['Title'] ?? '无标题',
      kind: map['Kind'] ?? '未知类型',
      translation: map['Translation'] ?? '无翻译',
      content: map['Content'] ?? '无内容',
      dynasty: map['Dynasty'] ?? '未知朝代',
      postsCount: map['PostsCount'] ?? '0',
      annotation: map['Annotation'] ?? '无注释',
    );
  }

  // 转换为 Map 以便存储到数据库或调试
  Map<String, dynamic> toMap() {
    return {
      'AuthorId': authorId,
      'Intro': intro,
      'Id': id,
      'Comment': comment,
      'Author': author,
      'Title': title,
      'Kind': kind,
      'Translation': translation,
      'Content': content,
      'Dynasty': dynasty,
      'PostsCount': postsCount,
      'Annotation': annotation,
    };
  }
}
