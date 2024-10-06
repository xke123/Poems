// lib/models/collections_viewmodel.dart

import 'package:flutter/material.dart';
import '../services/db_service.dart';
import 'collections_model.dart';

class CollectionViewModel extends ChangeNotifier {
  List<CollectionModel> _collections = []; // 分页数据
  List<CollectionModel> _randomCollections = []; // 随机数据
  bool isLoading = false;
  bool hasMore = true;
  int _limit = 30;
  int _offset = 0;
  String? errorMessage; // 错误信息

  List<CollectionModel> get collections => _collections; // 分页数据 getter
  List<CollectionModel> get randomCollections => _randomCollections; // 随机数据 getter

  CollectionViewModel() {
    fetchCollections(); // 初始化加载分页数据
  }

  // 分页获取 Collection 数据
  Future<void> fetchCollections() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    notifyListeners();

    try {
      List<CollectionModel> fetchedCollections =
          await DbService.getCollections(limit: _limit, offset: _offset);
      if (fetchedCollections.length < _limit) {
        hasMore = false;
      }
      _collections.addAll(fetchedCollections);
      _offset += _limit;
      errorMessage = null;
    } catch (e) {
      errorMessage = '获取诗集数据失败: $e';
      print(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 随机获取 Collection 数据
  Future<void> fetchRandomCollections(int limit) async {
    isLoading = true;
    notifyListeners();
    try {
      _randomCollections = await DbService.getRandomCollections(limit);
      errorMessage = null;
    } catch (e) {
      errorMessage = '获取收藏数据失败: $e';
      print(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 重置分页数据
  void reset() {
    _collections.clear();
    isLoading = false;
    hasMore = true;
    _offset = 0;
    fetchCollections();
  }
}
