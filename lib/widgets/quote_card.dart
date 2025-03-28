// lib/widgets/quote_card.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../services/db_service.dart'; // 引入数据库服务
import '../models/poemdetailmodel.dart';
import '../pages/detail/poem.dart';

class QuoteCard extends StatefulWidget {
  final QuoteModel quote;
  final VoidCallback onRefresh;
  final bool isTop; // 标识是否为顶层卡片
  final ValueChanged<double>? onSwipeProgress; // 新增回调

  QuoteCard({
    Key? key,
    required this.quote,
    required this.onRefresh,
    this.isTop = false,
    this.onSwipeProgress, // 初始化回调
  }) : super(key: key);

  @override
  _QuoteCardState createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard>
    with SingleTickerProviderStateMixin {
  double _offsetX = 0.0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isAnimating = false; // 防止多次滑动

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animationController.addListener(() {
      setState(() {
        _offsetX = _animation.value;
      });
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_offsetX.abs() > MediaQuery.of(context).size.width / 4) {
          widget.onRefresh();
        }
        _animationController.reset();
        setState(() {
          _offsetX = 0.0;
          _isAnimating = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // 格式化内容，替换符号为换行符
  String formatContent(String content) {
    String formattedContent = content.replaceAllMapped(
      RegExp(r'[，、。！？；]'),
      (Match match) => '\n', // 替换为换行符
    );
    return formattedContent;
  }

  // 辅助函数：移除符号
  String removeSymbols(String input) {
    return input
        .replaceAll(RegExp(r'[·/，。！？；：、“”‘’（）《》〈〉【】「」『』]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ') // 合并多个空格为一个
        .trim(); // 去除首尾空格
  }

  // 点击时获取诗词详情并跳转页面
  Future<void> _fetchPoetryDetails(BuildContext context, String id) async {
    try {
      final poemDetail = await DbService.getQuoteById(id); // 获取诗词详情
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PoemDetailPage(id: poemDetail.id),
        ),
      );
    } catch (e) {
      print('获取诗词详情失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载诗词详情失败，请重试！')),
      );
    }
  }

  // 处理拖动更新
  void _onPanUpdate(DragUpdateDetails details) {
    if (_isAnimating || !widget.isTop) return;
    setState(() {
      _offsetX += details.delta.dx;
    });
    double screenWidth = MediaQuery.of(context).size.width;
    double progress = (_offsetX / screenWidth).clamp(-1.0, 1.0);
    if (widget.onSwipeProgress != null) {
      widget.onSwipeProgress!(progress.abs()); // 传递绝对值进度
    }
  }

  // 处理拖动结束
  void _onPanEnd(DragEndDetails details) {
    if (_isAnimating || !widget.isTop) return;
    double screenWidth = MediaQuery.of(context).size.width;
    if (_offsetX.abs() > screenWidth / 4) {
      // 滑动距离超过阈值，滑出屏幕
      double endX = _offsetX > 0 ? screenWidth : -screenWidth;
      _animation = Tween<double>(begin: _offsetX, end: endX)
          .animate(_animationController);
      _animationController.forward();
      _isAnimating = true;
    } else {
      // 滑动距离不足，滑回原位
      _animation = Tween<double>(begin: _offsetX, end: 0.0)
          .animate(_animationController);
      _animationController.forward();
      _isAnimating = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isTop
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PoemDetailPage(id: widget.quote.id),
                ),
              );
            }
          : null,
      onPanUpdate: widget.isTop ? _onPanUpdate : null,
      onPanEnd: widget.isTop ? _onPanEnd : null,
      child: Transform.translate(
        offset: Offset(_offsetX, 0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.618,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 上部分占90%，显示名句、作者和诗名
                  Expanded(
                    flex: 9,
                    child: Row(
                      children: [
                        // 左边 15% 显示作者名，竖排显示
                        Expanded(
                          flex: 15,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0), // 增加左侧内边距
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Column(
                                  children: [
                                    SizedBox(
                                        height: constraints.maxHeight *
                                            0.7), // 70% 空间
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: widget.quote.poetName
                                          .split('')
                                          .map((char) {
                                        return Text(
                                          char,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          textAlign: TextAlign.center,
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        // 中间 70% 显示内容
                        Expanded(
                          flex: 70,
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: formatContent(widget.quote.content)
                                  .split('\n')
                                  .reversed
                                  .map((line) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: line.split('').map((char) {
                                      return Text(
                                        char,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.center,
                                      );
                                    }).toList(),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        // 右边 15% 显示诗名
                        Expanded(
                          flex: 15,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 16.0), // 增加右侧内边距
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Column(
                                  children: [
                                    SizedBox(
                                        height: constraints.maxHeight *
                                            0.2), // 20% 空间
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: removeSymbols(
                                                  widget.quote.poetryName)
                                              .split('')
                                              .map((char) {
                                            return Text(
                                              char,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              textAlign: TextAlign.center,
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 下部分占10%，显示刷新按钮
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: CupertinoButton(
                          padding: EdgeInsets.all(10),
                          onPressed: widget.isTop
                              ? widget.onRefresh
                              : null, // 只有顶层卡片的刷新按钮有效
                          child: Icon(
                            CupertinoIcons.refresh,
                            size: 24,
                            color: widget.isTop ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
