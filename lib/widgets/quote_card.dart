import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/quote_model.dart';

class QuoteCard extends StatelessWidget {
  final QuoteModel quote;
  final VoidCallback onRefresh;

  QuoteCard({required this.quote, required this.onRefresh});

  // 删除所有符号并根据符号换行的方法
  String formatContent(String content) {
    // 根据标点符号（如逗号、句号等）进行换行，并删除符号
    String formattedContent = content.replaceAllMapped(
      RegExp(r'[，。！？；]'),
      (Match match) => '\n', // 替换为换行符
    );
    return formattedContent;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.618,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.white, // 卡片背景颜色
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.8), // 阴影颜色，增加透明度
                spreadRadius: 20, // 扩展范围，值越大阴影越大
                blurRadius: 15, // 模糊程度，值越大阴影越柔和
                offset: Offset(0, 10), // Y轴偏移，使阴影下沉
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // 辅助的更浅阴影
                spreadRadius: 10,
                blurRadius: 10,
                offset: Offset(0, 5), // 更小的偏移，增加层次感
              ),
            ],
          ),
          child: Column(
            children: [
              // 上部分占90%，显示名句、作者和诗名
              Expanded(
                flex: 9, // 上部分占垂直方向的90%
                child: Row(
                  children: [
                    // 左边 15% 显示作者名，竖排显示
                    Expanded(
                      flex: 15,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center, // 竖直居中
                          crossAxisAlignment: CrossAxisAlignment.center, // 水平居中
                          children: quote.poetName.split('').map((char) {
                            return Text(
                              char,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center, // 每个字符居中对齐
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    // 中间 70% 显示内容，处理符号并从右向左换行
                    Expanded(
                      flex: 70,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Row 根据内容宽度自适应
                          mainAxisAlignment: MainAxisAlignment.center, // 水平居中
                          crossAxisAlignment: CrossAxisAlignment.center, // 垂直居中
                          children: formatContent(quote.content)
                              .split('\n')
                              .reversed
                              .map((line) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisSize:
                                    MainAxisSize.min, // Column 根据内容高度自适应
                                mainAxisAlignment:
                                    MainAxisAlignment.center, // 垂直居中
                                crossAxisAlignment:
                                    CrossAxisAlignment.center, // 水平居中
                                children: line.split('').map((char) {
                                  return Text(
                                    char,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center, // 每个字符居中显示
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
                          mainAxisAlignment: MainAxisAlignment.center, // 竖直居中
                          crossAxisAlignment: CrossAxisAlignment.center, // 水平居中
                          children: quote.poetryName.split('').map((char) {
                            return Text(
                              char,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center, // 每个字符居中对齐
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
                flex: 1, // 下部分占垂直方向的10%
                child: Align(
                  alignment: Alignment.centerRight, // 刷新按钮靠右显示
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0), // 右侧间距
                    child: CupertinoButton(
                      padding: EdgeInsets.all(10), // 按钮内部的间距
                      onPressed: onRefresh, // 调用传入的刷新方法
                      child: Icon(
                        CupertinoIcons.refresh, // 仅显示刷新图标
                        size: 24, // 设置图标大小
                        color: Colors.black, // 设置图标颜色
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
