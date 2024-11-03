import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/quote_model.dart';
import '../widgets/quote_card.dart';
import '../widgets/marquee_quote_page.dart'; // 新的页面引用

class QuoteDisplayPage extends StatefulWidget {
  @override
  _QuoteDisplayPageState createState() => _QuoteDisplayPageState();
}

class _QuoteDisplayPageState extends State<QuoteDisplayPage> {
  List<QuoteModel> _quotes = [];
  double _swipeProgress = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialQuotes();
  }

  Future<void> _loadInitialQuotes() async {
    try {
      List<QuoteModel> initialQuotes = await DbService.getRandomSentence(3);
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

  Future<void> _loadMoreQuote() async {
    try {
      List<QuoteModel> newQuote = await DbService.getRandomSentence(1);
      setState(() {
        _quotes.addAll(newQuote);
      });
    } catch (e) {
      print('加载更多句子失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载数据失败，请重试！')),
      );
    }
  }

  void _onCardSwiped() {
    setState(() {
      if (_quotes.isNotEmpty) {
        _quotes.removeAt(0);
      }
      _swipeProgress = 0.0;
    });
    _loadMoreQuote();
  }

  void _handleSwipeProgress(double progress) {
    setState(() {
      _swipeProgress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _quotes.isEmpty
                  ? Center(child: Text('没有可显示的句子'))
                  : Center(
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: _quotes
                            .asMap()
                            .entries
                            .map((entry) {
                              int index = entry.key;
                              QuoteModel quote = entry.value;

                              double baseScale = 1 - (index * 0.07);
                              double baseOffset = index * 30.0;

                              double horizontalOffset = index * 3.0;
                              double rotation = (index - 1) * 0.02;

                              double scale = baseScale;
                              double verticalOffset = baseOffset;

                              if (index == 1) {
                                scale += 0.05 * _swipeProgress;
                                verticalOffset -= 15.0 * _swipeProgress;
                              } else if (index == 2) {
                                scale += 0.025 * _swipeProgress;
                                verticalOffset -= 7.5 * _swipeProgress;
                              }

                              return Transform.translate(
                                offset: Offset(0, verticalOffset),
                                child: Transform.scale(
                                  scale: scale,
                                  child: QuoteCard(
                                    key: ValueKey(quote.id),
                                    quote: quote,
                                    onRefresh: _onCardSwiped,
                                    isTop: index == 0,
                                    onSwipeProgress: index == 0
                                        ? _handleSwipeProgress
                                        : null,
                                  ),
                                ),
                              );
                            })
                            .toList()
                            .reversed
                            .toList(),
                      ),
                    ),
        ),
      ],
    );
  }
}
