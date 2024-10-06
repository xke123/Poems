class DynastyDetailModel {
  // 作者相关字段
  final String? authorId;
  final String? authorName;
  final String? dynasty;
  final String? authorDesc;
  final String? birthYear;
  final String? deathYear;
  final bool hasImage;

  // 作品相关字段
  final String? poemId;
  final String? poemTitle;
  final String? poemAuthor;
  final String? poemKind;
  final String? poemContent;
  final String? poemIntro;
  final String? poemComment;
  final String? poemTranslation;
  final String? poemAnnotation;
  final String? poemPostsCount;

  // 构造函数，初始化所有字段
  DynastyDetailModel({
    this.authorId,
    this.authorName,
    this.dynasty,
    this.authorDesc,
    this.birthYear,
    this.deathYear,
    this.hasImage = false, // 默认没有图片

    this.poemId,
    this.poemTitle,
    this.poemAuthor,
    this.poemKind,
    this.poemContent,
    this.poemIntro,
    this.poemComment,
    this.poemTranslation,
    this.poemAnnotation,
    this.poemPostsCount,
  });

  // 从数据库的作者查询结果生成 DynastyDetailModel 实例
  factory DynastyDetailModel.fromAuthorMap(Map<String, dynamic> map) {
    return DynastyDetailModel(
      authorId: map['Id']?.toString(),
      authorName: map['Name'] ?? '未知作者',
      dynasty: map['Dynasty'] ?? '未知朝代',
      authorDesc: map['Desc'] ?? '',
      birthYear: map['BirthYear'] ?? '未知',
      deathYear: map['DeathYear'] ?? '未知',
      hasImage: map['HasImage'] == 1,
    );
  }

  // 从数据库的诗词查询结果生成 DynastyDetailModel 实例
  factory DynastyDetailModel.fromPoemMap(Map<String, dynamic> map) {
    return DynastyDetailModel(
      poemId: map['Id']?.toString(),
      poemTitle: map['Title'] ?? '未知作品',
      poemAuthor: map['Author'] ?? '未知作者',
      poemKind: map['Kind'] ?? '未知类型',
      poemContent: map['Content'] ?? '',
      poemIntro: map['Intro'] ?? '',
      poemComment: map['Comment'] ?? '',
      poemTranslation: map['Translation'] ?? '',
      poemAnnotation: map['Annotation'] ?? '',
      dynasty: map['Dynasty'] ?? '未知朝代',
      poemPostsCount: map['PostsCount']?.toString() ?? '0',
    );
  }

  // 将实例转换为 Map (用于调试或插入数据库等操作)
  Map<String, dynamic> toMap() {
    return {
      // 作者相关字段
      'authorId': authorId,
      'authorName': authorName,
      'dynasty': dynasty,
      'authorDesc': authorDesc,
      'birthYear': birthYear,
      'deathYear': deathYear,
      'hasImage': hasImage ? 1 : 0,

      // 作品相关字段
      'poemId': poemId,
      'poemTitle': poemTitle,
      'poemAuthor': poemAuthor,
      'poemKind': poemKind,
      'poemContent': poemContent,
      'poemIntro': poemIntro,
      'poemComment': poemComment,
      'poemTranslation': poemTranslation,
      'poemAnnotation': poemAnnotation,
      'poemPostsCount': poemPostsCount,
    };
  }
}
