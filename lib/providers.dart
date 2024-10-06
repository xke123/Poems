import 'package:flutter/material.dart';
import 'models/author_viewmodel.dart';
import 'models/collections_viewmodel.dart';
import 'package:provider/provider.dart';

class Providers {
  static MultiProvider getProviders() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthorViewModel()),
        ChangeNotifierProvider(create: (_) => CollectionViewModel()),
        // 其他视图模型可以在这里添加
      ],
      child: Container(), // 这个 child 会被 MultiProvider 替换
    );
  }
}
