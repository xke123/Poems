import 'package:flutter/services.dart' show rootBundle, ByteData;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' show Platform;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/quote_model.dart';
import 'dart:io' as io;

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
          List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
          
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
      final db = await initDb();  // 初始化数据库
      print('正在查询随机句子...');
      
      // 执行 SQL 查询
      List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM sentence ORDER BY RANDOM() LIMIT 1'
      );
      
      if (result.isNotEmpty) {
        print('查询成功，结果: ${result.first}');  // 打印查询结果
        return QuoteModel.fromMap(result.first);
      } else {
        print('数据库中没有句子');  // 查询结果为空
        throw Exception('没有找到句子');
      }
    } catch (e) {
      print('查询失败: $e');  // 捕捉并输出查询异常
      throw Exception('获取随机句子失败');
    }
  }
}
