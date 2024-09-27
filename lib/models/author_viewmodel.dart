import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/author_model.dart';

class AuthorViewModel extends ChangeNotifier {
  List<AuthorModel> authors = [];

  // 获取前30个作者
  Future<void> fetchAuthors() async {
    try {
      authors = await DbService.getAuthors();
      notifyListeners();
    } catch (e) {
      print('fetchAuthors 错误: $e');
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
}
