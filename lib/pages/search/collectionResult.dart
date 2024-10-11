import 'package:flutter/material.dart';
import '../../models/poemdetailmodel.dart';

class CollectionResultPage extends StatelessWidget {
  final String searchQuery;
  final String dynasty;
  final List<PoemDetailModel> poemResults;

  CollectionResultPage({
    required this.searchQuery,
    required this.dynasty,
    required this.poemResults,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('作品集搜索结果'),
      ),
      body: ListView.builder(
        itemCount: poemResults.length,
        itemBuilder: (context, index) {
          final poem = poemResults[index];
          return ListTile(
            title: Text(poem.title ?? ''),
            subtitle: Text(poem.author ?? ''),
            onTap: () {
              // 点击后跳转到诗词详情页
              // 您可以在这里实现导航到诗词详情页面的逻辑
            },
          );
        },
      ),
    );
  }
}
