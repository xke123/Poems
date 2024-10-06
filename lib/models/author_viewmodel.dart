import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/author_model.dart';

class AuthorViewModel extends ChangeNotifier {
  List<AuthorModel> authors = [];
  bool isLoading = false;
  bool hasMore = true;
  int _limit = 30;
  int _offset = 0;

  AuthorViewModel() {
    fetchAuthors();
  }

  // 获取作者，支持分页
  Future<void> fetchAuthors() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    notifyListeners();

    try {
      List<AuthorModel> fetchedAuthors =
          await DbService.getAuthors(limit: _limit, offset: _offset);
      if (fetchedAuthors.length < _limit) {
        hasMore = false;
      }
      authors.addAll(fetchedAuthors);
      _offset += _limit;
      notifyListeners();
    } catch (e) {
      print('fetchAuthors 错误: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 获取指定数量的随机作者
  Future<List<AuthorModel>> fetchRandomAuthors(int count) async {
    try {
      List<AuthorModel> randomAuthors = await DbService.getRandomAuthors(count);
      return randomAuthors;
    } catch (e) {
      print('fetchRandomAuthors 错误: $e');
      return [];
    }
  }

  // 重置分页
  void reset() {
    authors.clear();
    isLoading = false;
    hasMore = true;
    _offset = 0;
    fetchAuthors();
  }
}
