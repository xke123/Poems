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
  bool _isLoading = true; // 标记是否在加载

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
        _isLoading = false;
      });
    } catch (e) {
      print('获取随机句子失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载数据失败，请重试！')),
      );
      setState(() {
        _isLoading = false;
      });
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _quotes.isEmpty
              ? Center(child: Text('没有可显示的句子'))
              : Center(
                  // 确保 Stack 在屏幕中心
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none, // 防止卡片被裁剪
                    children: _quotes
                        .asMap()
                        .entries
                        .map((entry) {
                          int index = entry.key;
                          QuoteModel quote = entry.value;

                          // 增加缩放和偏移量
                          double baseScale =
                              1 - (index * 0.07); // 1.0, 0.93, 0.86
                          double baseOffset = index * 30.0; // 0, 30, 60

                          // 可选：添加轻微的水平偏移和旋转
                          double horizontalOffset = index * 3.0; // 每层卡片稍微水平偏移
                          double rotation = (index - 1) * 0.02; // 每层卡片稍微旋转

                          // 动态调整缩放和偏移量
                          double scale = baseScale;
                          double verticalOffset = baseOffset;

                          if (index == 1) {
                            // 第二层卡片
                            scale += 0.05 * _swipeProgress; // 放大
                            verticalOffset -= 15.0 * _swipeProgress; // 向前移动
                          } else if (index == 2) {
                            // 第三层卡片
                            scale += 0.025 * _swipeProgress; // 少量放大
                            verticalOffset -= 7.5 * _swipeProgress; // 少量向前移动
                          }

                          // 打印调试信息
                          print(
                              '卡片索引: $index, scale: $scale, verticalOffset: $verticalOffset');

                          return Transform.translate(
                            offset: Offset(0, verticalOffset),
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
                ),
    );
  }
}
