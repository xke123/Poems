import 'package:flutter/material.dart';
import '../models/quote_model.dart';

class QuoteCard extends StatelessWidget {
  final QuoteModel quote;

  QuoteCard({required this.quote});

  // 删除所有符号并根据符号换行的方法
  String formatContent(String content) {
    // 根据标点符号（如逗号、句号等）进行换行
    String formattedContent = content.replaceAll(RegExp(r'[，。！？；]'), '\n');

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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    formatContent(quote.content), // 调用处理后的内容
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.right, // 从右到左对齐
                    overflow: TextOverflow.visible,
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
