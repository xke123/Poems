import 'package:flutter/material.dart';
import '../models/quote_model.dart';

class QuoteCard extends StatelessWidget {
  final QuoteModel quote;

  QuoteCard({required this.quote});

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
                offset: Offset(0, 10), // Y轴偏移，使阴影下沉，让卡片看起来像凸出来
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // 辅助的更浅阴影
                spreadRadius: 10,
                blurRadius: 10,
                offset: Offset(0, 5), // 更小的偏移，增加层次感
              ),
            ],
          ),
          child: Row(
            children: [
              // 左边 15% 显示作者名
              Expanded(
                flex: 15,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    quote.poetName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // 中间 70% 显示内容，处理符号并从右向左换行
              Expanded(
                flex: 70,
                child: Center(
                  // 使用 Center 确保整体内容在页面中居中
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Row 根据内容宽度自适应
                    mainAxisAlignment: MainAxisAlignment.center, // 水平居中
                    crossAxisAlignment: CrossAxisAlignment.center, // 垂直居中
                    children: formatContent(quote.content)
                        .split('\n')
                        .reversed
                        .map((line) {
                      // 从右到左显示
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Column 根据内容高度自适应
                          mainAxisAlignment: MainAxisAlignment.center, // 垂直居中
                          crossAxisAlignment: CrossAxisAlignment.center, // 水平居中
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    quote.poetryName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
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
