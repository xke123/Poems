// lib/pages/quote_display_page.dart

import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/quote_model.dart';
import '../widgets/quote_card.dart';

class QuoteDisplayPage extends StatefulWidget {
  @override
  _QuoteDisplayPageState createState() => _QuoteDisplayPageState();
}

class _QuoteDisplayPageState extends State<QuoteDisplayPage> {
  List<QuoteModel> _quotes = [];
  double _swipeProgress = 0.0; // 跟踪顶层卡片的滑动进度

  @override
  void initState() {
    super.initState();
    _loadInitialQuotes();
  }

  // 初始加载3个卡片
  Future<void> _loadInitialQuotes() async {
    try {
      List<QuoteModel> initialQuotes = await Future.wait([
        DbService.getRandomSentence(),
        DbService.getRandomSentence(),
        DbService.getRandomSentence(),
      ]);
      setState(() {
        _quotes = initialQuotes;
      });
    } catch (e) {
      print('获取随机句子失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载数据失败，请重试！')),
      );
    }
  }

  // 加载一个新的卡片
  Future<void> _loadNewQuote() async {
    try {
      QuoteModel newQuote = await DbService.getRandomSentence();
      setState(() {
        _quotes.add(newQuote);
      });
    } catch (e) {
      print('获取随机句子失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载数据失败，请重试！')),
      );
    }
  }

  // 当顶层卡片被滑动时调用
  void _onCardSwiped() {
    setState(() {
      if (_quotes.isNotEmpty) {
        _quotes.removeAt(0);
      }
      _swipeProgress = 0.0; // 重置滑动进度
    });
    _loadNewQuote();
  }

  // 处理滑动进度更新
  void _handleSwipeProgress(double progress) {
    setState(() {
      _swipeProgress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _quotes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: _quotes
                  .asMap()
                  .entries
                  .map((entry) {
                    int index = entry.key;
                    QuoteModel quote = entry.value;

                    // 基础缩放和偏移量
                    double baseScale = 1 - (index * 0.05);
                    double baseOffset = index * 8.0;

                    // 动态调整缩放和偏移量
                    double scale = baseScale;
                    double offset = baseOffset;

                    if (index == 1) {
                      // 第二层卡片
                      scale += 0.05 * _swipeProgress; // 放大
                      offset -= 8.0 * _swipeProgress; // 向前移动
                    } else if (index == 2) {
                      // 第三层卡片
                      scale += 0.025 * _swipeProgress; // 少量放大
                      offset -= 4.0 * _swipeProgress; // 少量向前移动
                    }

                    return Positioned(
                      top: offset,
                      left: offset,
                      right: offset,
                      bottom: offset,
                      child: Transform.scale(
                        scale: scale,
                        child: QuoteCard(
                          key: ValueKey(quote.id),
                          quote: quote,
                          onRefresh: _onCardSwiped,
                          isTop: index == 0, // 只有顶层卡片可滑动
                          onSwipeProgress: index == 0
                              ? _handleSwipeProgress
                              : null, // 只有顶层卡片传递滑动进度
                        ),
                      ),
                    );
                  })
                  .toList()
                  .reversed
                  .toList(), // 逆序确保顶层卡片在Stack的最后
            ),
    );
  }
}
