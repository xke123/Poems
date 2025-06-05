// lib/services/search_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:poems/models/poemdetailmodel.dart';
import '../models/search/GlobalSearchResult.dart';
import '../models/search/AuthorData.dart';
import '../models/search/CollectionData.dart';
import '../models/search/PoemData.dart';
import '../models/search/SentenceData.dart';
import '../models/author_model.dart';

class SearchService {
  // 请根据实际情况修改后端服务地址
  static const String baseUrl = 'https://api.logofmy.life';

  /// 全局搜索接口，根据指定类型查询（对应后端 /api/search/global 接口）
  static Future<List<GlobalSearchResult>> searchGlobalByType({
    required String query,
    required String dynasty,
    required String
        type, // 可选 'poem'、'sentence'、'famous_sentence'、'collection1' 等
    int limit = 30,
    int offset = 0,
  }) async {
    final url = Uri.parse(
        '$baseUrl/api/search/global?query=$query&dynasty=$dynasty&type=$type&limit=$limit&offset=$offset');
    print('[DEBUG] 请求 URL: $url');
    try {
      final response = await http.get(url);
      print('[DEBUG] 全局搜索响应状态码: ${response.statusCode}');
      print('[DEBUG] 全局搜索响应内容: ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> resultsJson = jsonData['results'];
        List<GlobalSearchResult> results = [];
        if (type == 'poem') {
          results = resultsJson
              .map((json) => GlobalSearchResult.poem(PoemData.fromMap(json)))
              .toList();
        } else if (type == 'sentence') {
          results = resultsJson
              .map((json) => GlobalSearchResult.sentence(PoemData.fromMap(json)))
              .toList();
        } else if (type == 'famous_sentence') {
          results = resultsJson
              .map((json) => GlobalSearchResult.famousSentence(
                    SentenceData.fromMap(json),
                  ))
              .toList();
        } else if (type == 'collection1') {
          results = resultsJson
              .map((json) =>
                  GlobalSearchResult.collection1(PoemData.fromMap(json)))
              .toList();
        } else {
          // 默认按全局搜索处理，尝试自动判断类型（这里仅作简单处理）
          results = resultsJson.map((json) {
            if (json.containsKey('title') && json.containsKey('kind')) {
              return GlobalSearchResult.collection2(
                  CollectionData.fromMap(json));
            } else if (json.containsKey('Name')) {
              return GlobalSearchResult.author(AuthorData.fromMap(json));
            } else if (json.containsKey('Title')) {
              return GlobalSearchResult.poem(PoemData.fromMap(json));
            } else if (json.containsKey('Content')) {
              return GlobalSearchResult.sentence(PoemData.fromMap(json));
            } else if (json.containsKey('content')) {
              return GlobalSearchResult.famousSentence(
                  SentenceData.fromMap(json));
            }
            return GlobalSearchResult.poem(PoemData.fromMap(json));
          }).toList();
        }
        return results;
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] 全局搜索异常: $e');
      throw Exception('全局搜索失败: $e');
    }
  }

  /// 搜索作品集（对应后端 /api/search/collections 接口）
  static Future<List<GlobalSearchResult>> searchCollectionsGlobal({
    required String query,
    required String dynasty,
    int limit = 20,
    int offset = 0,
  }) async {
    final url = Uri.parse(
        '$baseUrl/api/search/collections?query=$query&dynasty=$dynasty&limit=$limit&offset=$offset');
    print('[DEBUG] 请求作品集 URL: $url');
    try {
      final response = await http.get(url);
      print('[DEBUG] 作品集响应状态码: ${response.statusCode}');
      print('[DEBUG] 作品集响应内容: ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> resultsJson = jsonData['results'];
        List<GlobalSearchResult> results = resultsJson
            .map((json) =>
                GlobalSearchResult.collection2(CollectionData.fromMap(json)))
            .toList();
        return results;
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] 搜索作品集异常: $e');
      throw Exception('搜索作品集失败: $e');
    }
  }

  /// 搜索作者（对应后端 /api/search/authors 接口）
  static Future<List<GlobalSearchResult>> searchAuthorsGlobal({
    required String query,
    required String dynasty,
    int limit = 20,
    int offset = 0,
  }) async {
    final url = Uri.parse(
        '$baseUrl/api/search/authors?query=$query&dynasty=$dynasty&limit=$limit&offset=$offset');
    print('[DEBUG] 请求作者 URL: $url');
    try {
      final response = await http.get(url);
      print('[DEBUG] 作者响应状态码: ${response.statusCode}');
      print('[DEBUG] 作者响应内容: ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> resultsJson = jsonData['results'];
        List<GlobalSearchResult> results = resultsJson
            .map((json) => GlobalSearchResult.author(AuthorData.fromMap(json)))
            .toList();
        return results;
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] 搜索作者异常: $e');
      throw Exception('搜索作者失败: $e');
    }
  }

  /// 搜索作品（对应后端 /api/search/poems 接口）
  static Future<List<PoemDetailModel>> searchPoems({
    required String query,
    required String dynasty,
    int limit = 20,
    int offset = 0,
  }) async {
    final url = Uri.parse(
        '$baseUrl/api/search/poems?query=$query&dynasty=$dynasty&limit=$limit&offset=$offset');
    print('[DEBUG] 请求作品 URL: $url');
    try {
      final response = await http.get(url);
      print('[DEBUG] 作品响应状态码: ${response.statusCode}');
      print('[DEBUG] 作品响应内容: ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> resultsJson = jsonData['results'];
        List<PoemDetailModel> results =
            resultsJson.map((json) => PoemDetailModel.fromMap(json)).toList();
        return results;
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] 搜索作品异常: $e');
      throw Exception('搜索作品失败: $e');
    }
  }

  /// 全局搜索（根据 option 参数搜索，option 例如：'作者'、'作品名'、'诗句'、'作品集'、'名句'）
  static Future<List<dynamic>> search({
    required String query,
    required String dynasty,
    required String option,
    int limit = 30,
    int offset = 0,
  }) async {
    // 统一使用 /api/search/global 接口，通过 type 参数传递 option
    final url = Uri.parse(
        '$baseUrl/api/search/global?query=$query&dynasty=$dynasty&type=$option&limit=$limit&offset=$offset');
    print('[DEBUG] 全局搜索（option）请求 URL: $url');
    try {
      final response = await http.get(url);
      print('[DEBUG] 全局搜索（option）响应状态码: ${response.statusCode}');
      print('[DEBUG] 全局搜索（option）响应内容: ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> resultsJson = jsonData['results'];
        // 根据 option 返回对应类型
        if (option == '作者') {
          return resultsJson
              .map((json) => GlobalSearchResult.author(AuthorData.fromMap(json)))
              .toList();
        } else if (option == '作品名') {
          return resultsJson
              .map((json) => PoemDetailModel.fromMap(json))
              .toList();
        } else if (option == '诗句') {
          return resultsJson
              .map((json) => PoemDetailModel.fromMap(json))
              .toList();
        } else if (option == '作品集') {
          return resultsJson
              .map((json) => PoemDetailModel.fromMap(json))
              .toList();
        } else if (option == '名句') {
          return resultsJson.map((json) => SentenceData.fromMap(json)).toList();
        } else {
          return resultsJson;
        }
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] 全局搜索（option）异常: $e');
      throw Exception('全局搜索失败: $e');
    }
  }
}
