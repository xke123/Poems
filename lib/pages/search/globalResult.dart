import 'package:flutter/material.dart';
import '../../models/search/GlobalSearchResult.dart';
import 'package:provider/provider.dart';
import '../../models/author_viewmodel.dart';
import '../../models/collections_viewmodel.dart';
import '../../widgets/author_horizontal_list.dart'; // 新建的作者横向列表组件
import '../../widgets/collection_horizontal_list.dart';

class GlobalResultPage extends StatelessWidget {
  final String searchQuery;
  final String dynasty;
  final List<GlobalSearchResult> results;

  GlobalResultPage({
    required this.searchQuery,
    required this.dynasty,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    // 获取屏幕的宽度和高度
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 分离不同类型的搜索结果
    List<GlobalSearchResult> authorResults =
        results.where((result) => result.type == 'author').toList();
    List<GlobalSearchResult> collectionResults =
        results.where((result) => result.type == 'collection').toList();
    List<GlobalSearchResult> otherResults = results
        .where((result) =>
            result.type != 'author' && result.type != 'collection')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('搜索 "$searchQuery" 的结果'),
      ),
      body: Center(
        child: Container(
          width: screenWidth * 0.9, // 占用90%的宽度
          height: screenHeight * 0.88, // 占用90%的高度
          decoration: BoxDecoration(
            color: Colors.white, // 白色背景
            borderRadius: BorderRadius.circular(20.0), // 圆角
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // 阴影颜色
                spreadRadius: 5, // 阴影扩散半径
                blurRadius: 7, // 阴影模糊半径
                offset: Offset(0, 3), // 阴影偏移
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0), // 内边距
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
                children: [
                  // 作者横向滚动列表
                  if (authorResults.isNotEmpty)
                    AuthorHorizontalList(authorResults: authorResults),

                  SizedBox(height: 20), // 间距

                  // 作品集横向滚动列表
                  if (collectionResults.isNotEmpty)
                    CollectionHorizontalList(collectionResults: collectionResults),

                  SizedBox(height: 20), // 间距

                  // 其余结果的竖向滚动列表
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: otherResults.length,
                    itemBuilder: (context, index) {
                      final result = otherResults[index];

                      // 根据类型构建不同的显示
                      Widget titleWidget;
                      Widget subtitleWidget;

                      switch (result.type) {
                        case 'poem':
                          titleWidget = Text(
                            result.poemData!.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                          subtitleWidget = Text(
                            '作者：${result.poemData!.author}\n内容：${result.poemData!.content}',
                            style: TextStyle(fontSize: 14),
                          );
                          break;
                        case 'sentence':
                          titleWidget = Text(
                            result.sentenceData!.content,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                          subtitleWidget = Text(
                            '出自：${result.sentenceData!.poetryName}\n作者：${result.sentenceData!.poetName}',
                            style: TextStyle(fontSize: 14),
                          );
                          break;
                        default:
                          titleWidget = Text(
                            '未知类型',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                          subtitleWidget = Text('');
                      }

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: titleWidget,
                          subtitle: subtitleWidget,
                          isThreeLine: true,
                          onTap: () {
                            // 根据类型跳转到不同的详情页面
                            if (result.type == 'poem') {
                              // 跳转到诗词详情页面
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => PoemDetailPage(poemData: result.poemData!)));
                            } else if (result.type == 'sentence') {
                              // 跳转到名句详情页面
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => SentenceDetailPage(sentenceData: result.sentenceData!)));
                            }
                          },
                        ),
                      );
                    },
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
