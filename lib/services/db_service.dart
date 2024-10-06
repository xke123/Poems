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

class DbService {
  static Database? _db;

  // 初始化数据库
  static Future<Database> initDb() async {
    try {
      if (_db == null) {
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
        }

        // 打开数据库
        _db = await openDatabase(path, version: 1);
        print('数据库连接成功');
      }
      return _db!;
    } catch (e) {
      print('数据库初始化失败: $e');
      throw Exception('数据库初始化失败');
    }
  }

  // 获取随机句子
  static Future<QuoteModel> getRandomSentence() async {
    try {
      final db = await initDb(); // 初始化数据库
      print('正在查询随机句子...');

      // 执行 SQL 查询
      List<Map<String, dynamic>> result =
          await db.rawQuery('SELECT * FROM sentence ORDER BY RANDOM() LIMIT 1');

      if (result.isNotEmpty) {
        print('查询成功，结果: ${result.first}'); // 打印查询结果
        return QuoteModel.fromMap(result.first);
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
}
