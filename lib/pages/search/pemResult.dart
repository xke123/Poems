import 'package:flutter/material.dart';
import '../../models/poemdetailmodel.dart';

class PoemResultPage extends StatelessWidget {
  final String searchQuery;
  final String dynasty;
  final List<PoemDetailModel> poemResults;

  PoemResultPage({
    required this.searchQuery,
    required this.dynasty,
    required this.poemResults,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('作品名搜索结果'),
      ),
      body: ListView.builder(
        itemCount: poemResults.length,
        itemBuilder: (context, index) {
          final poem = poemResults[index];
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
              crossAxisAlignment: CrossAxisAlignment.stretch, // 左对齐
              children: [
                Text(
                  poem.title ?? '',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 5),
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
