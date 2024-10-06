// lib/services/collection_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/collections_model.dart';

class CollectionService {
  Future<List<CollectionModel>> loadCollectionsFromJson() async {
    try {
      // 读取 assets/database/collections.json 文件
      final String response =
          await rootBundle.loadString('assets/database/collections.json');
      final List<dynamic> data = json.decode(response);

      // 将 JSON 数据转换为 List<CollectionModel>
      return data.map((json) => CollectionModel.fromJson(json)).toList();
    } catch (e) {
      print('加载 collections.json 失败: $e');
      return [];
    }
  }
}
