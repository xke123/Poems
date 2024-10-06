// lib/models/author_poem_model.dart

class AuthorPoemModel {
  final String? authorId;
  final String? authorName;
  final bool? hasImage; // 添加 HasImage 字段
  final String? poemId;
  final String? poemTitle;
  final String? poemAuthorId;
  final String? poemAuthor;
  final String? kind;
  final String? postsCount;

  AuthorPoemModel({
    this.authorId,
    this.authorName,
    this.hasImage,
    this.poemId,
    this.poemTitle,
    this.poemAuthorId,
    this.poemAuthor,
    this.kind,
    this.postsCount,
  });

  factory AuthorPoemModel.fromAuthorMap(Map<String, dynamic> map) {
    return AuthorPoemModel(
      authorId: map['Id'],
      authorName: map['Name'],
      hasImage: map['HasImage'] == 1, // 根据数据库值设置 HasImage
    );
  }

  factory AuthorPoemModel.fromPoemMap(Map<String, dynamic> map) {
    return AuthorPoemModel(
      poemId: map['Id'],
      poemAuthorId: map['AuthorId'],
      poemAuthor: map['Author'],
      poemTitle: map['Title'],
      kind: map['Kind'],
      postsCount: map['PostsCount'],
    );
  }

  @override
  String toString() {
    return 'AuthorPoemModel(authorId: $authorId, authorName: $authorName, hasImage: $hasImage, poemId: $poemId, poemTitle: $poemTitle, poemAuthorId: $poemAuthorId, poemAuthor: $poemAuthor, kind: $kind, postsCount: $postsCount)';
  }
}
