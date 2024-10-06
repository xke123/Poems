// lib/services/search_service.dart

import 'package:poems/models/author_model.dart';
import 'package:poems/models/quote_model.dart';
import 'package:poems/models/poemdetailmodel.dart';
import 'db_service.dart';
import '../models/search/author.dart';

class SearchService {
  // 搜索方法
  static Future<List<dynamic>> search({
    required String query,
    required String dynasty,
    required String option,
    int limit = 30,
    int offset = 0,
  }) async {
    final db = await DbService.initDb();

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
      // 查询 author 表中的 Id 和 Name
      sql =
          'SELECT Id, Name , HasImage FROM author WHERE Name LIKE ?$dynastyCondition LIMIT ? OFFSET ?';
      params.insert(0, '%$query%');
      params.addAll([limit, offset]);

      result = await db.rawQuery(sql, params);
      print('搜索作者，SQL：$sql，参数：$params');
      print('搜索结果：$result');

      // 查询结果保存到 AuthorPoemModel 列表
      List<AuthorPoemModel> authorResults =
          result.map((map) => AuthorPoemModel.fromAuthorMap(map)).toList();

      // 查询 poem 表中的 Author, Title, Kind, PostsCount
      sql =
          'SELECT Id, AuthorId, Author, Title, Kind, PostsCount FROM poem WHERE Author LIKE ?$dynastyCondition LIMIT ? OFFSET ?';
      params[0] = '%$query%'; // 替换参数中的查询内容
      result = await db.rawQuery(sql, params);
      print('搜索诗词，SQL：$sql，参数：$params');
      print('搜索诗词结果：$result');

      // 将 poem 查询结果也保存到 AuthorPoemModel 列表
      List<AuthorPoemModel> poemResults =
          result.map((map) => AuthorPoemModel.fromPoemMap(map)).toList();

      // 合并两个结果
      return [...authorResults, ...poemResults];
    } else if (option == '作品') {
      // 查询 poem 表的 Title 和 Content 字段
      sql =
          'SELECT * FROM poem WHERE (Title LIKE ? OR Content LIKE ?)$dynastyCondition LIMIT ? OFFSET ?';
      params.insert(0, '%$query%');
      params.insert(1, '%$query%');
      params.addAll([limit, offset]);

      result = await db.rawQuery(sql, params);
      print('搜索作品，SQL：$sql，参数：$params');
      print('搜索结果：$result');

      // 返回 PoemDetailModel 列表
      return result.map((map) => PoemDetailModel.fromMap(map)).toList();
    } else if (option == '作品集') {
      // 查询 poem 表的 Content 字段
      sql =
          'SELECT * FROM poem WHERE Content LIKE ?$dynastyCondition LIMIT ? OFFSET ?';
      params.insert(0, '%$query%');
      params.addAll([limit, offset]);

      result = await db.rawQuery(sql, params);
      print('搜索作品集，SQL：$sql，参数：$params');
      print('搜索结果：$result');

      // 返回 PoemDetailModel 列表
      return result.map((map) => PoemDetailModel.fromMap(map)).toList();
    } else if (option == '名句') {
      // 查询 sentence 表的 content 字段
      sql = 'SELECT * FROM sentence WHERE content LIKE ? LIMIT ? OFFSET ?';
      params.insert(0, '%$query%');
      params.addAll([limit, offset]);

      result = await db.rawQuery(sql, params);
      print('搜索名句，SQL：$sql，参数：$params');
      print('搜索结果：$result');

      // 返回 QuoteModel 列表
      return result.map((map) => QuoteModel.fromMap(map)).toList();
    } else {
      // 如果选项为 '无'，则默认查询 poem 表的 Title 和 Content
      sql =
          'SELECT * FROM poem WHERE (Title LIKE ? OR Content LIKE ?)$dynastyCondition LIMIT ? OFFSET ?';
      params.insert(0, '%$query%');
      params.insert(1, '%$query%');
      params.addAll([limit, offset]);

      result = await db.rawQuery(sql, params);
      print('默认搜索，SQL：$sql，参数：$params');
      print('搜索结果：$result');

      // 返回 PoemDetailModel 列表
      return result.map((map) => PoemDetailModel.fromMap(map)).toList();
    }
  }
}
