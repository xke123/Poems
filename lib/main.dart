// main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/quote_display_page.dart';
import 'pages/quotes_by_category_page.dart';
import 'pages/search_page.dart'; // 引入搜索页面
import 'models/author_viewmodel.dart';
import 'models/collections_viewmodel.dart';
import 'widgets/marquee_quote_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthorViewModel>(
          create: (_) => AuthorViewModel(),
        ),
        ChangeNotifierProvider<CollectionViewModel>(
          create: (_) => CollectionViewModel(),
        ),
        // 其他视图模型可以在这里添加
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '名句展示',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: MainPage(), // 主页面包含导航栏
      home: MarqueeQuotePage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // 底部导航栏对应的页面列表
  static List<Widget> _pages = <Widget>[
    QuoteDisplayPage(), // 名句页面
    QuotesByCategoryPage(), // 分类页面
    SearchPage(), // 搜索页面
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('名句展示'),
      // ),
      body: _pages[_selectedIndex], // 显示选中的页面
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.format_quote),
            label: '名句',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: '分类',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '搜索',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped, // 切换页面
      ),
    );
  }
}
