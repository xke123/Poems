// lib/services/db_service.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle, ByteData;
import 'package:poems/models/collections_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' show Platform;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/quote_model.dart';
import 'dart:io' as io;
import '../models/author_model.dart';
import '../models/poemdetailmodel.dart';
import '../models/poetdetail_model.dart';
import '../models/dynastydetailmodel.dart';

class DbService {
  static Database? _db;
  static Future<Database>? _initDbFuture; // 新增静态 Future 变量

  // 初始化数据库
  static Future<Database> initDb() {
    if (_db != null) {
      return Future.value(_db);
    }

    if (_initDbFuture != null) {
      return _initDbFuture!;
    }

    _initDbFuture = _initializeDb();
    return _initDbFuture!;
  }

  static Future<Database> _initializeDb() async {
    try {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }

      // 获取数据库路径
      String dbPath = await getDatabasesPath();
      String path = join(dbPath, 'poems.db'); // 数据库存放路径
      print('数据库路径: $path');

      // 检查数据库文件是否存在
      bool exists = await io.File(path).exists();

      if (!exists) {
        // 数据库文件不存在，从 assets 复制
        print('数据库文件不存在，从 assets 复制');
        ByteData data = await rootBundle.load('assets/database/poems.db');
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

        // 将 assets 中的数据库文件复制到应用数据库路径
        await io.File(path).writeAsBytes(bytes);
        print('数据库文件复制完成');
      } else {
        print('数据库文件已存在，无需复制');
      }

      // 打开数据库
      _db = await openDatabase(path, version: 1);
      print('数据库连接成功');
      return _db!;
    } catch (e) {
      print('数据库初始化失败: $e');
      _initDbFuture = null; // 重置 Future，以便下次尝试
      throw Exception('数据库初始化失败');
    }
  }

  // 获取随机句子
  // static Future<QuoteModel> getRandomSentence() async {
  //   try {
  //     final db = await initDb(); // 初始化数据库
  //     print('正在查询随机句子...');

  //     // 执行 SQL 查询
  //     List<Map<String, dynamic>> result =
  //         await db.rawQuery('SELECT * FROM sentence ORDER BY RANDOM() LIMIT 1');

  //     if (result.isNotEmpty) {
  //       print('查询成功，结果: ${result.first}'); // 打印查询结果
  //       return QuoteModel.fromMap(result.first);
  //     } else {
  //       print('数据库中没有句子'); // 查询结果为空
  //       throw Exception('没有找到句子');
  //     }
  //   } catch (e) {
  //     print('查询失败: $e'); // 捕捉并输出查询异常
  //     throw Exception('获取随机句子失败');
  //   }
  // }

  // 获取多个随机句子
  static Future<List<QuoteModel>> getRandomSentence(int count) async {
    try {
      final db = await initDb(); // 初始化数据库
      print('正在查询随机句子...');

      // 执行 SQL 查询，获取指定数量的随机句子
      List<Map<String, dynamic>> results = await db.rawQuery(
          'SELECT * FROM sentence ORDER BY RANDOM() LIMIT ?', [count]);

      if (results.isNotEmpty) {
        print('查询成功，结果: $results'); // 打印查询结果
        // 将查询结果转换为 List<QuoteModel>
        return results.map((result) => QuoteModel.fromMap(result)).toList();
      } else {
        print('数据库中没有句子'); // 查询结果为空
        throw Exception('没有找到句子');
      }
    } catch (e) {
      print('查询失败: $e'); // 捕捉并输出查询异常
      throw Exception('获取随机句子失败');
    }
  }

  // 获取前30个作者
  static Future<List<AuthorModel>> getAuthors(
      {int limit = 30, int offset = 0}) async {
    try {
      final db = await initDb(); // 初始化数据库
      List<Map<String, dynamic>> result = await db.rawQuery(
          'SELECT Id, Name FROM author ORDER BY id ASC LIMIT ? OFFSET ?',
          [limit, offset]);
      // print('获取到的作者记录: $result');
      return result.map((map) => AuthorModel.fromMap(map)).toList();
    } catch (e) {
      print('获取作者失败: $e');
      throw Exception('获取作者失败');
    }
  }

  // 获取随机的指定数量的作者，HasImage 为 1
  static Future<List<AuthorModel>> getRandomAuthors(int count) async {
    try {
      final db = await initDb(); // 初始化数据库
      List<Map<String, dynamic>> result = await db.rawQuery(
          'SELECT Id, Name FROM author WHERE HasImage = 1 ORDER BY RANDOM() LIMIT ?',
          [count]);
      return result.map((map) => AuthorModel.fromMap(map)).toList();
    } catch (e) {
      print('获取随机作者失败: $e');
      throw Exception('获取随机作者失败');
    }
  }

  // 获取30个作品集
  static Future<List<CollectionModel>> getCollections(
      {int limit = 30, int offset = 0}) async {
    try {
      final db = await initDb(); // 初始化数据库
      List<Map<String, dynamic>> result = await db.rawQuery(
          'SELECT * FROM collection ORDER BY id ASC LIMIT ? OFFSET ?',
          [limit, offset]);

      // 显式指定映射类型
      return result
          .map<CollectionModel>((map) => CollectionModel.fromMap(map))
          .toList();
    } catch (e) {
      print('获取诗集数据失败: $e');
      throw Exception('获取诗集数据失败');
    }
  }

  // 添加获取随机 Collection 数据的静态方法
  static Future<List<CollectionModel>> getRandomCollections(int limit) async {
    final db = await initDb(); // 确保调用的是 initDb()
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT * FROM collection
      ORDER BY RANDOM()
      LIMIT ?
    ''', [limit]);

    return List.generate(maps.length, (i) {
      return CollectionModel.fromMap(maps[i]);
    });
  }

  //获取诗词详情
  static Future<PoemDetailModel> getQuoteById(String id) async {
    try {
      final db = await initDb(); // 初始化数据库
      print('数据库已连接，正在执行查询语句: SELECT * FROM poem WHERE Id = $id');

      List<Map<String, dynamic>> result =
          await db.rawQuery('SELECT * FROM poem WHERE Id = ?', [id]);

      if (result.isNotEmpty) {
        print('查询成功，返回的结果: $result');
        return PoemDetailModel.fromMap(result.first);
      } else {
        throw Exception('没有找到诗词');
      }
    } catch (e) {
      print('获取诗词详情失败，id: $id，错误信息: $e');
      throw Exception('获取诗词数据失败: $e');
    }
  }

  // 根据作者ID获取作者详情
  static Future<PoetDetailModel> getAuthorById(String id) async {
    try {
      final db = await initDb();
      print('数据库已连接，正在查询作者详情，ID: $id');

      List<Map<String, dynamic>> result =
          await db.rawQuery('SELECT * FROM author WHERE Id = ?', [id]);

      if (result.isNotEmpty) {
        print('查询成功，返回的作者详情: $result');
        return PoetDetailModel.fromMap(result.first);
      } else {
        throw Exception('没有找到该作者');
      }
    } catch (e) {
      print('获取作者详情失败，ID: $id，错误信息: $e');
      throw Exception('获取作者数据失败: $e');
    }
  }

  // 获取指定朝代的作品和作者数据，并支持分页
  static Future<List<DynastyDetailModel>> getDynastyData(
      String dynasty, int page, int pageSize) async {
    try {
      final db = await initDb(); // 初始化数据库
      final offset = (page - 1) * pageSize; // 计算偏移量

      // 从 poem 表获取指定朝代的作品数据，支持分页
      List<Map<String, dynamic>> poemsResult = await db.rawQuery(
        'SELECT * FROM poem WHERE Dynasty = ? LIMIT ? OFFSET ?',
        [dynasty, pageSize, offset],
      );

      // 从 author 表获取指定朝代的作者数据，支持分页
      List<Map<String, dynamic>> authorsResult = await db.rawQuery(
        'SELECT * FROM author WHERE Dynasty = ? LIMIT ? OFFSET ?',
        [dynasty, pageSize, offset],
      );

      // 打印获取到的作品和作者数量
      print('获取到的诗词数量: ${poemsResult.length}');
      print('获取到的作者数量: ${authorsResult.length}');

      // 组合数据并返回
      List<DynastyDetailModel> dynastyDetails = [];

      // 处理诗词数据
      for (var poem in poemsResult) {
        dynastyDetails.add(DynastyDetailModel.fromPoemMap(poem));
      }

      // 处理作者数据
      for (var author in authorsResult) {
        dynastyDetails.add(DynastyDetailModel.fromAuthorMap(author));
      }

      return dynastyDetails;
    } catch (e) {
      print('获取朝代数据失败: $e');
      throw Exception('获取朝代数据失败');
    }
  }

  // 根据作品集标题查询诗词
  // 查询 poem 表中 Title 包含指定作品集名称的所有作品
  static Future<List<PoemDetailModel>> getPoemsByCollectionTitle(
      String collectionTitle) async {
    try {
      final db = await initDb(); // 确保数据库已经初始化
      String symbol = '·'; // 定义特殊符号

      // 查询包含特定作品集名称的诗词，确保作品标题中包含 'collectionTitle' 和 '·'
      List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM poem WHERE Title LIKE ? AND Title LIKE ?',
        ['$collectionTitle ·%', '%$symbol%'], // 查询条件：Title以指定作品集名称开头，并且包含 "·"
      );

      // 打印结果数量
      print('查询到的作品数量: ${result.length}');

      // 将查询结果转换为 PoemDetailModel 列表并返回
      return result.map((map) => PoemDetailModel.fromMap(map)).toList();
    } catch (e) {
      print('查询诗词失败: $e');
      throw Exception('查询诗词失败');
    }
  }

  // 获取指定朝代的作者数据，支持分页
  static Future<List<DynastyDetailModel>> getDynastyAuthors(
      String dynasty, int page, int pageSize) async {
    try {
      final db = await initDb(); // 初始化数据库
      final offset = (page - 1) * pageSize; // 计算偏移量

      // 从 author 表获取指定朝代的作者数据，支持分页
      List<Map<String, dynamic>> authorsResult = await db.rawQuery(
        'SELECT * FROM author WHERE Dynasty = ? LIMIT ? OFFSET ?',
        [dynasty, pageSize, offset],
      );

      print('获取到的作者数量: ${authorsResult.length}');
      print('作者数据详情:');
      authorsResult.forEach((author) {
        print(author); // 打印每一位作者的详细信息
      });

      // 处理作者数据并返回
      return authorsResult
          .map((author) => DynastyDetailModel.fromAuthorMap(author))
          .toList();
    } catch (e) {
      print('获取朝代作者数据失败: $e');
      throw Exception('获取朝代作者数据失败');
    }
  }

// 获取指定朝代的作品数据，支持分页
  static Future<List<DynastyDetailModel>> getDynastyPoems(
      String dynasty, int page, int pageSize) async {
    try {
      final db = await initDb(); // 初始化数据库
      final offset = (page - 1) * pageSize; // 计算偏移量

      // 从 poem 表获取指定朝代的作品数据，支持分页
      List<Map<String, dynamic>> poemsResult = await db.rawQuery(
        'SELECT * FROM poem WHERE Dynasty = ? LIMIT ? OFFSET ?',
        [dynasty, pageSize, offset],
      );

      print('获取到的诗词数量: ${poemsResult.length}');
      print('诗词数据详情:');
      poemsResult.forEach((poem) {
        print(poem); // 打印每一首诗词的详细信息
      });

      // 处理诗词数据并返回
      return poemsResult
          .map((poem) => DynastyDetailModel.fromPoemMap(poem))
          .toList();
    } catch (e) {
      print('获取朝代作品数据失败: $e');
      throw Exception('获取朝代作品数据失败');
    }
  }
}
