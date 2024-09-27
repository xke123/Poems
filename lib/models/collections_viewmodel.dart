import 'package:flutter/material.dart';
import '../models/collections_model.dart';
import '../services/db_service.dart';

class CollectionViewModel extends ChangeNotifier {
  List<CollectionModel> _collections = [];

  List<CollectionModel> get collections => _collections;

  Future<void> fetchCollections() async {
    try {
      _collections = await DbService.getCollections();
      notifyListeners();
    } catch (e) {
      print('获取诗集数据失败: $e');
    }
  }
}
