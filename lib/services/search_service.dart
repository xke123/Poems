// lib/services/search_service.dart

import 'package:poems/models/poemdetailmodel.dart';
import 'db_service.dart';
import '../models/search/author.dart';
import '../models/search/GlobalSearchResult.dart';
import '../models/search/AuthorData.dart';
import '../models/search/CollectionData.dart';
import '../models/search/PoemData.dart';
import '../models/search/SentenceData.dart';
import '../models/author_model.dart';

class SearchService {
  // 在 SearchService 中添加以下方法
  static Future<List<GlobalSearchResult>> searchGlobalByType({
    required String query,
    required String dynasty,
    required String type, // 新增参数，用于指定类型
    int limit = 30,
    int offset = 0,
  }) async {
    final db = await DbService.initDb();
    // 根据类型构建查询
    // 这里只展示针对 'poem' 类型的查询，其他类型可以类似地实现
    if (type == 'poem') {
      // 查询诗词标题
      String poemTitleSql = 'SELECT * FROM poem WHERE Title LIKE ?';
      List<dynamic> poemTitleParams = ['%$query%'];

      if (dynasty != '无') {
        poemTitleSql += ' AND Dynasty = ?';
        poemTitleParams.add(dynasty);
      }

      poemTitleSql += ' LIMIT ? OFFSET ?';
      poemTitleParams.addAll([limit, offset]);

      List<Map<String, dynamic>> poemTitleResult =
          await db.rawQuery(poemTitleSql, poemTitleParams);
      print('诗词标题查询结果：$poemTitleResult');

      List<GlobalSearchResult> results = [];

      for (var map in poemTitleResult) {
        PoemData poemData = PoemData.fromMap(map);
        results.add(GlobalSearchResult.poem(poemData));
      }

      return results;
    }
    if (type == 'sentence') {
      // 查询诗词内容包含查询词的记录
      String poemContentSql = 'SELECT * FROM poem WHERE Content LIKE ?';
      List<dynamic> poemContentParams = ['%$query%'];

      if (dynasty != '无') {
        poemContentSql += ' AND Dynasty = ?';
        poemContentParams.add(dynasty);
      }

      poemContentSql += ' LIMIT ? OFFSET ?';
      poemContentParams.addAll([limit, offset]);

      List<Map<String, dynamic>> poemContentResult =
          await db.rawQuery(poemContentSql, poemContentParams);
      print('诗句查询结果：$poemContentResult');

      List<GlobalSearchResult> results = [];

      for (var map in poemContentResult) {
        PoemData poemData = PoemData.fromMap(map);
        results.add(GlobalSearchResult.sentence(poemData));
      }

      return results;
    }
    if (type == 'famous_sentence') {
      // 查询名句（sentence表）
      String sentenceSql = 'SELECT * FROM sentence WHERE content LIKE ?';
      List<dynamic> sentenceParams = ['%$query%'];

      if (dynasty != '无') {
        sentenceSql += ' AND Dynasty = ?';
        sentenceParams.add(dynasty);
      }

      sentenceSql += ' LIMIT ? OFFSET ?';
      sentenceParams.addAll([limit, offset]);

      List<Map<String, dynamic>> sentenceResult =
          await db.rawQuery(sentenceSql, sentenceParams);
      print('名句查询结果：$sentenceResult');

      List<GlobalSearchResult> results = [];

      for (var map in sentenceResult) {
        SentenceData sentenceData = SentenceData.fromMap(map);
        results.add(GlobalSearchResult.famousSentence(sentenceData));
      }

      return results;
    }
    if (type == 'collection1') {
      // 查询作品集1（poem表Title字段中第一个 '·' 之前的内容）
      String collection1Sql = '''
    SELECT * FROM poem 
    WHERE SUBSTR(Title, 1, INSTR(Title, '·') - 1) LIKE ? 
      AND Title LIKE '%·%'
  ''';
      List<dynamic> collection1Params = ['%${query}%'];

      if (dynasty != '无') {
        collection1Sql += ' AND Dynasty = ?';
        collection1Params.add(dynasty);
      }

      collection1Sql += ' LIMIT ? OFFSET ?';
      collection1Params.addAll([limit, offset]);

      List<Map<String, dynamic>> collection1Result =
          await db.rawQuery(collection1Sql, collection1Params);
      print('作品集1查询结果：$collection1Result');

      List<GlobalSearchResult> results = [];

      for (var map in collection1Result) {
        PoemData poemData = PoemData.fromMap(map);
        results.add(GlobalSearchResult.collection1(poemData));
      }

      return results;
    }
    if (type == 'famous_sentence') {
      // 查询名句（sentence表）
      String sentenceSql = 'SELECT * FROM sentence WHERE content LIKE ?';
      List<dynamic> sentenceParams = ['%$query%'];

      if (dynasty != '无') {
        sentenceSql += ' AND Dynasty = ?';
        sentenceParams.add(dynasty);
      }

      sentenceSql += ' LIMIT ? OFFSET ?';
      sentenceParams.addAll([limit, offset]);

      List<Map<String, dynamic>> sentenceResult =
          await db.rawQuery(sentenceSql, sentenceParams);
      print('名句查询结果：$sentenceResult');

      List<GlobalSearchResult> results = [];

      for (var map in sentenceResult) {
        SentenceData sentenceData = SentenceData.fromMap(map);
        results.add(GlobalSearchResult.famousSentence(sentenceData));
      }

      return results;
    }

    // 如果类型不匹配，返回空列表
    return [];
  }

  // 全局搜索，搜索作品集
  static Future<List<GlobalSearchResult>> searchCollectionsGlobal({
    required String query,
    required String dynasty,
    int limit = 20,
    int offset = 0,
  }) async {
    final db = await DbService.initDb();

    query = query.trim();
    if (query.isEmpty) {
      throw Exception('查询内容不能为空');
    }

    String sql = 'SELECT * FROM collection WHERE title LIKE ?';
    List<dynamic> params = ['%$query%'];

    sql += ' ORDER BY id ASC LIMIT ? OFFSET ?';
    params.addAll([limit, offset]);

    List<Map<String, dynamic>> result = await db.rawQuery(sql, params);
    print('分页搜索作品集，SQL：$sql，参数：$params');
    print('搜索结果：$result');

    List<GlobalSearchResult> collectionResults = result.map((map) {
      CollectionData collectionData = CollectionData.fromMap(map);
      return GlobalSearchResult.collection2(collectionData);
    }).toList();

    return collectionResults;
  }

  // 全局搜索，搜索作者
  static Future<List<GlobalSearchResult>> searchAuthorsGlobal({
    required String query,
    required String dynasty,
    int limit = 20,
    int offset = 0,
  }) async {
    final db = await DbService.initDb();

    query = query.trim();
    if (query.isEmpty) {
      throw Exception('查询内容不能为空');
    }

    String sql = 'SELECT * FROM author WHERE Name LIKE ?';
    List<dynamic> params = ['%$query%'];

    if (dynasty != '无') {
      sql += ' AND Dynasty = ?';
      params.add(dynasty);
    }

    sql += ' ORDER BY id ASC LIMIT ? OFFSET ?';
    params.addAll([limit, offset]);

    List<Map<String, dynamic>> result = await db.rawQuery(sql, params);
    print('分页搜索作者，SQL：$sql，参数：$params');
    print('搜索结果：$result');

    List<GlobalSearchResult> authorResults = result.map((map) {
      AuthorData authorData = AuthorData.fromMap(map);
      return GlobalSearchResult.author(authorData);
    }).toList();

    return authorResults;
  }

  /// 分页搜索作者
  static Future<List<AuthorModel>> searchAuthors({
    required String query,
    required String dynasty,
    int limit = 20,
    int offset = 0,
  }) async {
    final db = await DbService.initDb();

    query = query.trim();
    if (query.isEmpty) {
      throw Exception('查询内容不能为空');
    }

    String sql = 'SELECT * FROM author WHERE Name LIKE ?';
    List<dynamic> params = ['%$query%'];

    if (dynasty != '无') {
      sql += ' AND Dynasty = ?';
      params.add(dynasty);
    }

    sql += ' ORDER BY id ASC LIMIT ? OFFSET ?';
    params.addAll([limit, offset]);

    List<Map<String, dynamic>> result = await db.rawQuery(sql, params);
    print('分页搜索作者，SQL：$sql，参数：$params');
    print('搜索结果：$result');

    return result.map((map) => AuthorModel.fromMap(map)).toList();
  }

  /// 分页搜索作品（按查询内容）
  static Future<List<PoemDetailModel>> searchPoems({
    required String query,
    required String dynasty,
    int limit = 20,
    int offset = 0,
  }) async {
    final db = await DbService.initDb();

    query = query.trim();
    if (query.isEmpty) {
      throw Exception('查询内容不能为空');
    }

    String sql = 'SELECT * FROM poem WHERE Title LIKE ? OR Content LIKE ?';
    List<dynamic> params = ['%$query%', '%$query%'];

    if (dynasty != '无') {
      sql += ' AND Dynasty = ?';
      params.add(dynasty);
    }

    sql += ' ORDER BY id ASC LIMIT ? OFFSET ?';
    params.addAll([limit, offset]);

    List<Map<String, dynamic>> result = await db.rawQuery(sql, params);
    print('分页搜索作品，SQL：$sql，参数：$params');
    print('搜索结果：$result');

    return result.map((map) => PoemDetailModel.fromMap(map)).toList();
  }

  // 搜索方法
  static Future<List<dynamic>> search({
    required String query,
    required String dynasty,
    required String option,
    int limit = 30,
    int offset = 0,
  }) async {
    final db = await DbService.initDb();

    // 去除查询内容的首尾空格
    query = query.trim();
    if (query.isEmpty) {
      throw Exception('查询内容不能为空');
    }

    // 构建查询语句和参数
    String sql = '';
    List<dynamic> params = [];
    List<Map<String, dynamic>> result = [];

    // 处理朝代条件
    String dynastyCondition = '';
    if (dynasty != '无') {
      dynastyCondition = ' AND Dynasty = ?';
      params.add(dynasty);
    }

    // 根据选项选择查询的表和字段
    if (option == '作者') {
      // 查询作者
      sql =
          'SELECT Id, Name, HasImage FROM author WHERE Name LIKE ?$dynastyCondition LIMIT ? OFFSET ?';
      params.insert(0, '%$query%');
      params.addAll([limit, offset]);

      result = await db.rawQuery(sql, params);
      print('搜索作者，SQL：$sql，参数：$params');
      print('搜索结果：$result');

      // 将结果映射为 AuthorPoemModel 列表
      List<AuthorPoemModel> authorResults =
          result.map((map) => AuthorPoemModel.fromAuthorMap(map)).toList();

      // 查询诗词（作者字段匹配）
      sql =
          'SELECT Id, AuthorId, Author, Title, Kind, PostsCount FROM poem WHERE Author LIKE ?$dynastyCondition LIMIT ? OFFSET ?';
      params[0] = '%$query%'; // 更新查询内容
      result = await db.rawQuery(sql, params);
      print('搜索诗词，SQL：$sql，参数：$params');
      print('搜索诗词结果：$result');

      // 将结果映射为 AuthorPoemModel 列表
      List<AuthorPoemModel> poemResults =
          result.map((map) => AuthorPoemModel.fromPoemMap(map)).toList();

      // 合并两个结果
      return [...authorResults, ...poemResults];
    } else if (option == '作品名') {
      // 查询作品名
      sql =
          'SELECT * FROM poem WHERE Title LIKE ?$dynastyCondition LIMIT ? OFFSET ?';
      params.clear();
      params.insert(0, '%$query%');
      if (dynasty != '无') {
        params.add(dynasty);
      }
      params.addAll([limit, offset]);

      result = await db.rawQuery(sql, params);
      print('搜索作品名，SQL：$sql，参数：$params');
      print('搜索结果：$result');

      // 返回 PoemDetailModel 列表
      return result.map((map) => PoemDetailModel.fromMap(map)).toList();
    } else if (option == '诗句') {
      // 查询诗句
      sql =
          'SELECT * FROM poem WHERE Content LIKE ?$dynastyCondition LIMIT ? OFFSET ?';
      params.clear();
      params.insert(0, '%$query%');
      if (dynasty != '无') {
        params.add(dynasty);
      }
      params.addAll([limit, offset]);
      result = await db.rawQuery(sql, params);
      print('搜索诗句，SQL：$sql，参数：$params');
      print('搜索结果：$result');

      // 返回 PoemDetailModel 列表
      return result.map((map) => PoemDetailModel.fromMap(map)).toList();
    } else if (option == '作品集') {
      print('执行作品集搜索');
      // 作品集搜索逻辑
      // 确保 dynastyCondition 已经被处理
      // 构建 SQL 查询
      sql = '''
        SELECT * FROM poem 
        WHERE SUBSTR(Title, 1, INSTR(Title, '·') - 1) LIKE ? 
          AND Title LIKE '%·%'
          $dynastyCondition
        LIMIT ? OFFSET ?
      ''';

      // 设置参数，确保查询内容在 '·' 前面
      params.insert(0, '%$query%');
      params.addAll([limit, offset]);

      print('搜索作品集，SQL：$sql，参数：$params');

      // 执行查询
      try {
        result = await db.rawQuery(sql, params);
        print('搜索作品集结果：$result');
      } catch (e) {
        print('搜索作品集出现错误: $e');
        throw e; // 重新抛出异常以便在调用处捕获
      }

      // 返回 PoemDetailModel 列表
      return result.map((map) => PoemDetailModel.fromMap(map)).toList();
    } else if (option == '名句') {
      // 查询名句（sentence 表）
      sql =
          'SELECT * FROM sentence WHERE content LIKE ?$dynastyCondition LIMIT ? OFFSET ?';
      params.clear();
      params.insert(0, '%$query%');
      if (dynasty != '无') {
        params.add(dynasty);
      }
      params.addAll([limit, offset]);

      result = await db.rawQuery(sql, params);
      print('搜索名句，SQL：$sql，参数：$params');
      print('搜索结果：$result');

      // 返回 SentenceData 列表
      return result.map((map) => SentenceData.fromMap(map)).toList();
    } else {
      // 全局搜索
      List<GlobalSearchResult> results = [];

// 搜索作者表
      String authorSql =
          'SELECT * FROM author WHERE Name LIKE ? LIMIT ? OFFSET ?';
      List<dynamic> authorParams = ['%$query%', limit, offset];
      List<Map<String, dynamic>> authorResult =
          await db.rawQuery(authorSql, authorParams);
      print('作者查询结果：$authorResult');

      for (var map in authorResult) {
        AuthorData authorData = AuthorData.fromMap(map);
        results.add(GlobalSearchResult.author(authorData));
      }

// 搜索诗词标题
      String poemTitleSql =
          'SELECT * FROM poem WHERE Title LIKE ?$dynastyCondition LIMIT ? OFFSET ?';
      List<dynamic> poemTitleParams = ['%$query%', ...params, limit, offset];
      List<Map<String, dynamic>> poemTitleResult =
          await db.rawQuery(poemTitleSql, poemTitleParams);
      print('诗词标题查询结果：$poemTitleResult');

      for (var map in poemTitleResult) {
        PoemData poemData = PoemData.fromMap(map);
        results.add(GlobalSearchResult.poem(poemData));
      }

// 搜索诗句
      String poemContentSql =
          'SELECT * FROM poem WHERE Content LIKE ?$dynastyCondition LIMIT ? OFFSET ?';
      List<dynamic> poemContentParams = ['%$query%', ...params, limit, offset];
      List<Map<String, dynamic>> poemContentResult =
          await db.rawQuery(poemContentSql, poemContentParams);
      print('诗句查询结果：$poemContentResult');

      for (var map in poemContentResult) {
        PoemData poemData = PoemData.fromMap(map);
        results.add(GlobalSearchResult.sentence(poemData));
      }

// 搜索作品集1（poem表Title字段中第一个 '·' 之前的内容）
      String collection1Sql = '''
  SELECT * FROM poem 
  WHERE SUBSTR(Title, 1, INSTR(Title, '·') - 1) LIKE ? 
  AND Title LIKE '%·%'
  $dynastyCondition
  LIMIT ? OFFSET ?
''';
      List<dynamic> collection1Params = ['%$query%', ...params, limit, offset];
      List<Map<String, dynamic>> collection1Result =
          await db.rawQuery(collection1Sql, collection1Params);
      print('作品集1查询结果：$collection1Result');

      for (var map in collection1Result) {
        PoemData poemData = PoemData.fromMap(map);
        results.add(GlobalSearchResult.collection1(poemData)); // 使用不同的类型标识
      }

// 搜索作品集2（collection表）
      String collection2Sql =
          'SELECT * FROM collection WHERE title LIKE ? LIMIT ? OFFSET ?';
      List<dynamic> collection2Params = ['%$query%', limit, offset];
      List<Map<String, dynamic>> collection2Result =
          await db.rawQuery(collection2Sql, collection2Params);
      print('作品集2查询结果：$collection2Result');

      for (var map in collection2Result) {
        CollectionData collectionData = CollectionData.fromMap(map);
        results
            .add(GlobalSearchResult.collection2(collectionData)); // 使用不同的类型标识
      }

// 搜索名句（sentence表）
      String sentenceSql =
          'SELECT * FROM sentence WHERE content LIKE ? LIMIT ? OFFSET ?';
      List<dynamic> sentenceParams = ['%$query%', limit, offset];
      List<Map<String, dynamic>> sentenceResult =
          await db.rawQuery(sentenceSql, sentenceParams);
      print('名句查询结果：$sentenceResult');

      for (var map in sentenceResult) {
        SentenceData sentenceData = SentenceData.fromMap(map);
        results
            .add(GlobalSearchResult.famousSentence(sentenceData)); // 使用不同的类型标识
      }

// 返回合并的结果列表
      return results;
    }
  }
}
