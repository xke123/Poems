// lib/services/db_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:poems/models/quote_model.dart';
import 'package:poems/models/author_model.dart';
import 'package:poems/models/collections_model.dart';
import 'package:poems/models/poemdetailmodel.dart';
import 'package:poems/models/poetdetail_model.dart';
import 'package:poems/models/dynastydetailmodel.dart';

class DbService {
  // 设置后端 API 基础 URL（请确保此 URL 正确无误）
  static const String baseUrl = 'https://api.logofmy.life';

  // 注：此方法仅用于兼容 search_service.dart，后续可统一调整
  static Future<dynamic> initDb() async {
    throw UnimplementedError(
        'initDb 暂未实现 API 版本，请调整 search_service.dart 或实现此方法');
  }

  // 获取随机句子示例
  static Future<List<QuoteModel>> getRandomSentence(int count) async {
    final url = Uri.parse('$baseUrl/api/random-sentence?count=$count');
    print('[DEBUG] 请求随机句子 URL: $url');
    try {
      final response = await http.get(url);
      print('[DEBUG] 随机句子响应状态码: ${response.statusCode}');
      print('[DEBUG] 随机句子响应内容: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        print('[DEBUG] 随机句子解析后数据: $data');
        return data.map((json) => QuoteModel.fromMap(json)).toList();
      } else {
        throw Exception('获取随机句子失败，状态码: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] 获取随机句子异常: $e');
      throw Exception('获取随机句子失败: $e');
    }
  }

  // 获取前30个作者
  static Future<List<AuthorModel>> getAuthors(
      {int limit = 30, int offset = 0}) async {
    final url = Uri.parse('$baseUrl/api/authors?limit=$limit&offset=$offset');
    print('[DEBUG] 请求作者列表 URL: $url');
    try {
      final response = await http.get(url);
      print('[DEBUG] 作者列表响应状态码: ${response.statusCode}');
      print('[DEBUG] 作者列表响应内容: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        print('[DEBUG] 作者列表解析后数据: $data');
        return data.map((json) => AuthorModel.fromMap(json)).toList();
      } else {
        throw Exception('获取作者失败，状态码: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] 获取作者异常: $e');
      throw Exception('获取作者失败: $e');
    }
  }

  // 获取随机的指定数量的作者（hasimage = true）
  static Future<List<AuthorModel>> getRandomAuthors(int count) async {
    final url = Uri.parse('$baseUrl/api/random-authors?count=$count');
    print('[DEBUG] 请求随机作者 URL: $url');
    try {
      final response = await http.get(url);
      print('[DEBUG] 随机作者响应状态码: ${response.statusCode}');
      print('[DEBUG] 随机作者响应内容: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        print('[DEBUG] 随机作者解析后数据: $data');
        return data.map((json) => AuthorModel.fromMap(json)).toList();
      } else {
        throw Exception('获取随机作者失败，状态码: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] 获取随机作者异常: $e');
      throw Exception('获取随机作者失败: $e');
    }
  }

  // 获取30个作品集
  static Future<List<CollectionModel>> getCollections(
      {int limit = 30, int offset = 0}) async {
    final url =
        Uri.parse('$baseUrl/api/collections?limit=$limit&offset=$offset');
    print('[DEBUG] 请求作品集 URL: $url');
    try {
      final response = await http.get(url);
      print('[DEBUG] 作品集响应状态码: ${response.statusCode}');
      print('[DEBUG] 作品集响应内容: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        print('[DEBUG] 作品集解析后数据: $data');
        return data.map((json) => CollectionModel.fromMap(json)).toList();
      } else {
        throw Exception('获取作品集失败，状态码: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] 获取作品集异常: $e');
      throw Exception('获取作品集失败: $e');
    }
  }

  // 获取诗词详情
  static Future<PoemDetailModel> getQuoteById(String id) async {
    final url = Uri.parse('$baseUrl/api/poem/$id');
    print('[DEBUG] 请求诗词详情 URL: $url');
    try {
      final response = await http.get(url);
      print('[DEBUG] 诗词详情响应状态码: ${response.statusCode}');
      print('[DEBUG] 诗词详情响应内容: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        print('[DEBUG] 诗词详情解析后数据: $data');
        return PoemDetailModel.fromMap(data);
      } else {
        throw Exception('获取诗词详情失败，状态码: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] 获取诗词详情异常: $e');
      throw Exception('获取诗词详情失败: $e');
    }
  }

  // 根据作者ID获取作者详情
  static Future<PoetDetailModel> getAuthorById(String id) async {
    final url = Uri.parse('$baseUrl/api/author/$id');
    print('[DEBUG] 请求作者详情 URL: $url');
    try {
      final response = await http.get(url);
      print('[DEBUG] 作者详情响应状态码: ${response.statusCode}');
      print('[DEBUG] 作者详情响应内容: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        print('[DEBUG] 作者详情解析后数据: $data');
        return PoetDetailModel.fromMap(data);
      } else {
        throw Exception('获取作者详情失败，状态码: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] 获取作者详情异常: $e');
      throw Exception('获取作者详情失败: $e');
    }
  }

  // 获取指定朝代数据（诗词和作者）
  static Future<List<DynastyDetailModel>> getDynastyData(
      String dynasty, int page, int pageSize) async {
    final url = Uri.parse(
        '$baseUrl/api/dynasty-data?dynasty=$dynasty&page=$page&pageSize=$pageSize');
    print('[DEBUG] 请求朝代数据 URL: $url');
    try {
      final response = await http.get(url);
      print('[DEBUG] 朝代数据响应状态码: ${response.statusCode}');
      print('[DEBUG] 朝代数据响应内容: ${response.body}');
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<dynamic> poems = jsonResponse['poems'];
        List<dynamic> authors = jsonResponse['authors'];
        print('[DEBUG] 诗词数据: $poems');
        print('[DEBUG] 作者数据: $authors');
        List<dynamic> combined = []
          ..addAll(poems)
          ..addAll(authors);
        return combined.map((e) => DynastyDetailModel.fromPoemMap(e)).toList();
      } else {
        throw Exception('获取朝代数据失败，状态码: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] 获取朝代数据异常: $e');
      throw Exception('获取朝代数据失败: $e');
    }
  }

  // 根据作品集标题查询诗词
  static Future<List<PoemDetailModel>> getPoemsByCollectionTitle(
      String collectionTitle) async {
    final url = Uri.parse(
        '$baseUrl/api/poems-by-collection?collectionTitle=${Uri.encodeComponent(collectionTitle)}');
    print('[DEBUG] 请求作品集标题查询 URL: $url');
    try {
      final response = await http.get(url);
      print('[DEBUG] 作品集标题查询响应状态码: ${response.statusCode}');
      print('[DEBUG] 作品集标题查询响应内容: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        print('[DEBUG] 作品集标题查询解析后数据: $data');
        return data.map((json) => PoemDetailModel.fromMap(json)).toList();
      } else {
        throw Exception('查询诗词失败，状态码: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] 查询诗词异常: $e');
      throw Exception('查询诗词失败: $e');
    }
  }

  // 获取指定朝代的作者（分页）
  static Future<List<DynastyDetailModel>> getDynastyAuthors(
      String dynasty, int page, int pageSize) async {
    final url = Uri.parse(
        '$baseUrl/api/dynasty-authors?dynasty=$dynasty&page=$page&pageSize=$pageSize');
    print('[DEBUG] 请求朝代作者 URL: $url');
    try {
      final response = await http.get(url);
      print('[DEBUG] 朝代作者响应状态码: ${response.statusCode}');
      print('[DEBUG] 朝代作者响应内容: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        print('[DEBUG] 朝代作者解析后数据: $data');
        return data
            .map((json) => DynastyDetailModel.fromAuthorMap(json))
            .toList();
      } else {
        throw Exception('获取朝代作者数据失败，状态码: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] 获取朝代作者数据异常: $e');
      throw Exception('获取朝代作者数据失败: $e');
    }
  }

  // 获取指定朝代的诗词（分页）
  static Future<List<DynastyDetailModel>> getDynastyPoems(
      String dynasty, int page, int pageSize) async {
    final url = Uri.parse(
        '$baseUrl/api/dynasty-poems?dynasty=$dynasty&page=$page&pageSize=$pageSize');
    print('[DEBUG] 请求朝代诗词 URL: $url');
    try {
      final response = await http.get(url);
      print('[DEBUG] 朝代诗词响应状态码: ${response.statusCode}');
      print('[DEBUG] 朝代诗词响应内容: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        print('[DEBUG] 朝代诗词解析后数据: $data');
        return data
            .map((json) => DynastyDetailModel.fromPoemMap(json))
            .toList();
      } else {
        throw Exception('获取朝代作品数据失败，状态码: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] 获取朝代诗词异常: $e');
      throw Exception('获取朝代作品数据失败: $e');
    }
  }

  // 获取随机作品集
  static Future<List<CollectionModel>> getRandomCollections(int limit) async {
    final url = Uri.parse('$baseUrl/api/random-collections?count=$limit');
    print('[DEBUG] 请求随机作品集 URL: $url');
    try {
      final response = await http.get(url);
      print('[DEBUG] 随机作品集响应状态码: ${response.statusCode}');
      print('[DEBUG] 随机作品集响应内容: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        print('[DEBUG] 随机作品集解析后数据: $data');
        return data.map((json) => CollectionModel.fromMap(json)).toList();
      } else {
        throw Exception('获取随机作品集失败，状态码: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] 获取随机作品集异常: $e');
      throw Exception('获取随机作品集失败: $e');
    }
  }
}
