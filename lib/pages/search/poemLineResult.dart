import 'package:flutter/material.dart';
import '../../models/poemdetailmodel.dart';

class PoemLineResultPage extends StatelessWidget {
  final String searchQuery;
  final String dynasty;
  final List<PoemDetailModel> poemResults;

  PoemLineResultPage({
    required this.searchQuery,
    required this.dynasty,
    required this.poemResults,
  });

  // 方法：从诗词内容中提取包含查询内容的行
  String extractMatchingLines(String content, String query) {
    // 将内容按换行符分割
    List<String> lines = content.split(RegExp(r'[，。\n]'));

    // 找到包含查询内容的行的索引
    int index = lines.indexWhere((line) => line.contains(query));

    if (index != -1) {
      // 获取该行和它的前后行（构成对仗句）
      String matchingLines = '';

      // 获取前一行（如果有）
      if (index > 0) {
        matchingLines += lines[index - 1] + '，';
      }

      // 当前行
      matchingLines += lines[index];

      // 获取后一行（如果有）
      if (index < lines.length - 1) {
        matchingLines += '，' + lines[index + 1];
      }

      return matchingLines;
    } else {
      return ''; // 未找到匹配的行
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('诗句搜索结果'),
      ),
      body: ListView.builder(
        itemCount: poemResults.length,
        itemBuilder: (context, index) {
          final poem = poemResults[index];
          String content = poem.content ?? '';
          String matchingLines = extractMatchingLines(content, searchQuery);

          return Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10), // 圆角矩形
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // 阴影位置
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 第一行：作品名
                Text(
                  poem.title ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 5),
                // 第二行：匹配的诗句内容
                Text(
                  matchingLines.isNotEmpty ? matchingLines : '未找到匹配的诗句',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                // 第三行：作者名
                Text(
                  poem.author ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
