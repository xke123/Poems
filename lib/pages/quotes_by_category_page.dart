// quotes_by_category_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/author_viewmodel.dart';
import '../models/collections_viewmodel.dart';
import 'top_content_widget.dart';
import 'bottom_content_widget.dart';

class QuotesByCategoryPage extends StatefulWidget {
  @override
  _QuotesByCategoryPageState createState() => _QuotesByCategoryPageState();
}

class _QuotesByCategoryPageState extends State<QuotesByCategoryPage> {
  // 朝代数组
  final List<String> dynasties = [
    '商',
    '周',
    '秦',
    '汉',
    '三国',
    '晋',
    '南北朝',
    '隋',
    '唐',
    '五代十国',
    '辽',
    '宋',
    '金',
    '元',
    '明',
    '清',
    '现代'
  ];

  @override
  Widget build(BuildContext context) {
    // 获取屏幕的高度，并减去顶部和底部的安全区域高度
    final availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final topSectionHeight = availableHeight * 0.3; // 上半部分占30%
    final bottomSectionHeight = availableHeight * 0.7; // 下半部分占70%

    // 下部分的圆角矩形框高度
    final bottomContainerHeight = bottomSectionHeight * 0.8;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthorViewModel()..fetchAuthors(),
        ),
        ChangeNotifierProvider(
          create: (context) => CollectionViewModel()..fetchCollections(),
        ),
      ],
      builder: (context, child) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // 上半部分内容
                TopContentWidget(
                  topSectionHeight: topSectionHeight,
                  dynasties: dynasties,
                ),
                // 下半部分内容
                Expanded(
                  child: BottomContentWidget(
                    bottomContainerHeight: bottomContainerHeight,
                    dynasties: dynasties,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
