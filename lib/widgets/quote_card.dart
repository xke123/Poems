import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../services/db_service.dart'; // 引入数据库服务
import '../models/poemdetailmodel.dart';
import '../pages/detail/poem.dart';

class QuoteCard extends StatelessWidget {
  final QuoteModel quote;
  final VoidCallback onRefresh;

  QuoteCard({required this.quote, required this.onRefresh});

  // 删除所有符号并根据符号换行的方法
  String formatContent(String content) {
    String formattedContent = content.replaceAllMapped(
      RegExp(r'[，。！？；]'),
      (Match match) => '\n', // 替换为换行符
    );
    return formattedContent;
  }

  // 点击时获取诗词详情并跳转页面
  Future<void> _fetchPoetryDetails(BuildContext context, String id) async {
    try {
      final poemDetail = await DbService.getQuoteById(id); // 获取诗词详情
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PoemDetailPage(poemDetail: poemDetail),
        ),
      );
    } catch (e) {
      print('获取诗词详情失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          _fetchPoetryDetails(context, quote.id), // 确保quote.id是String类型
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
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: quote.poetName.split('').map((char) {
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
                      // 中间 70% 显示内容
                      Expanded(
                        flex: 70,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: formatContent(quote.content)
                                .split('\n')
                                .reversed
                                .map((line) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: line.split('').map((char) {
                                    return Text(
                                      char,
                                      style: TextStyle(
                                        fontSize: 18,
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
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: quote.poetryName.split('').map((char) {
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
                        onPressed: onRefresh,
                        child: Icon(
                          CupertinoIcons.refresh,
                          size: 24,
                          color: Colors.black,
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
    );
  }
}
