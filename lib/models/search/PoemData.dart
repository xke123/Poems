class PoemData {
  String authorId;
  String intro;
  String id;
  String comment;
  String author;
  String title;
  String kind;
  String translation;
  String content;
  String dynasty;
  String postsCount;
  String annotation;

  PoemData({
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

  factory PoemData.fromMap(Map<String, dynamic> map) {
    return PoemData(
      authorId: map['AuthorId'] ?? '',
      intro: map['Intro'] ?? '',
      id: map['Id'] ?? '',
      comment: map['Comment'] ?? '',
      author: map['Author'] ?? '',
      title: map['Title'] ?? '',
      kind: map['Kind'] ?? '',
      translation: map['Translation'] ?? '',
      content: map['Content'] ?? '',
      dynasty: map['Dynasty'] ?? '',
      postsCount: map['PostsCount'] ?? '',
      annotation: map['Annotation'] ?? '',
    );
  }
}
