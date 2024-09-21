import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/author_model.dart';

class AuthorViewModel extends ChangeNotifier {
  List<AuthorModel> _authors = [];

  List<AuthorModel> get authors => _authors;

  Future<void> fetchAuthors() async {
    try {
      print('AuthorViewModel:开始获取作者数据...');
      _authors = await DbService.getAuthors();
      print('AuthorViewModel:获取到的作者数据: ${_authors}');
      notifyListeners();
    } catch (e) {
      print('AuthorViewModel:获取作者数据失败: $e');
    }
  }
}
