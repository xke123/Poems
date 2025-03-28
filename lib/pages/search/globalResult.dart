import 'package:flutter/material.dart';
import '../../models/search/GlobalSearchResult.dart';
import 'package:provider/provider.dart';
import '../../models/author_viewmodel.dart';
import '../../models/collections_viewmodel.dart';
import '../../widgets/author_horizontal_list.dart'; // 新建的作者横向列表组件
import '../../widgets/collection_horizontal_list.dart';
import '../../models/search/PoemData.dart';
import '../../models/search/SentenceData.dart';
import '../../models/poemdetailmodel.dart';
import '../../services/db_service.dart';
import '../../pages/detail/poem.dart';
import '../../widgets/PoemTab.dart';
import '../../widgets/SentenceTab.dart';
import '../../widgets/Collection1Tab.dart';
import '../../widgets/FamousSentenceTab.dart';

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
        results.where((result) => result.type == 'collection2').toList();
    List<GlobalSearchResult> poemResults =
        results.where((result) => result.type == 'poem').toList();
    List<GlobalSearchResult> sentenceResults =
        results.where((result) => result.type == 'sentence').toList();
    List<GlobalSearchResult> collection1Results =
        results.where((result) => result.type == 'collection1').toList();
    List<GlobalSearchResult> famousSentenceResults =
        results.where((result) => result.type == 'famous_sentence').toList();
    // 可以根据需要添加更多类型

    return Scaffold(
      appBar: AppBar(
        title: Text('搜索 "$searchQuery" 的结果'),
      ),
      body: Center(
        child: Container(
          width: screenWidth * 0.9, // 占用90%的宽度
          height: screenHeight * 0.87, // 占用90%的高度
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
              children: [
                // 作者横向滚动列表
                if (authorResults.isNotEmpty)
                  AuthorHorizontalList(
                    searchQuery: searchQuery,
                    dynasty: dynasty,
                    initialResults: authorResults,
                  ),

                SizedBox(height: 20), // 间距

                // 作品集横向滚动列表
                if (collectionResults.isNotEmpty)
                  CollectionHorizontalList(
                    searchQuery: searchQuery,
                    dynasty: dynasty,
                    initialResults: collectionResults,
                  ),

                SizedBox(height: 20), // 间距

                // 其余结果的圆角矩形内的TabBar和TabBarView
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white, // 白色背景
                      borderRadius: BorderRadius.circular(15.0), // 圆角
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3), // 阴影颜色
                          spreadRadius: 2, // 阴影扩散半径
                          blurRadius: 5, // 阴影模糊半径
                          offset: Offset(0, 2), // 阴影偏移
                        ),
                      ],
                    ),
                    child: DefaultTabController(
                      length: 4, // 根据类型数量设置Tab数量
                      child: Column(
                        children: [
                          TabBar(
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Colors.blue,
                            isScrollable: true, // 允许滚动以适应多个标签
                            tabs: [
                              Tab(text: '作品'),
                              Tab(text: '诗句'),
                              Tab(text: '作品集1'),
                              Tab(text: '名句'),
                              // 如果有更多类型，可以继续添加Tab
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                // 作品列表
                                // buildListView(poemResults, context),
                                PoemTabContent(
                                  searchQuery: searchQuery,
                                  dynasty: dynasty,
                                ),
                                // 诗句列表
                                // buildListView(sentenceResults, context),

                                // 诗句列表
                                SentenceTabContent(
                                  searchQuery: searchQuery,
                                  dynasty: dynasty,
                                ),

                                // 作品集1列表
                                // buildListView(collection1Results, context),
                                Collection1TabContent(
                                  searchQuery: searchQuery,
                                  dynasty: dynasty,
                                ),
                                // 名句列表
                                // buildListView(famousSentenceResults, context),
                                FamousSentenceTabContent(
                                  searchQuery: searchQuery,
                                  dynasty: dynasty,
                                ),
                                // 如果有更多类型，可以继续添加ListView
                              ],
                            ),
                          ),
                        ],
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

  /// 构建ListView的方法，根据结果类型显示不同内容
  Widget buildListView(List<GlobalSearchResult> results, BuildContext context) {
    if (results.isEmpty) {
      return Center(child: Text('暂无数据'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];

        switch (result.type) {
          case 'poem':
          case 'sentence':
          case 'collection1':
            // 这三种类型的数据都来自 poem 表
            return GestureDetector(
              onTap: () async {
                String poemId = result.poemData!.id;
                try {
                  // 从数据库获取诗词详情
                  PoemDetailModel poemDetail =
                      await DbService.getQuoteById(poemId);
                  // 跳转到诗词详情页面
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PoemDetailPage(id: poemDetail.id),
                    ),
                  );
                } catch (e) {
                  print('获取诗词详情失败: $e');
                }
              },
              child: result.type == 'sentence'
                  ? buildSentenceListItem(result.poemData!, searchQuery)
                  : buildPoemListItem(result.poemData!),
            );
          case 'famous_sentence':
            // 名句类型的数据需要从 sentenceData 中获取 poetryId
            return GestureDetector(
              onTap: () async {
                String poemId = result.sentenceData!.poetryId;
                try {
                  // 从数据库获取诗词详情
                  PoemDetailModel poemDetail =
                      await DbService.getQuoteById(poemId);
                  // 跳转到诗词详情页面
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PoemDetailPage(id: poemDetail.id),
                    ),
                  );
                } catch (e) {
                  print('获取诗词详情失败: $e');
                }
              },
              child: buildFamousSentenceListItem(result.sentenceData!),
            );
          default:
            return ListTile(
              title: Text('未知类型'),
              subtitle: Text(''),
            );
        }
      },
    );
  }

  Widget buildPoemListItem(PoemData poem) {
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
            poem.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 5),
          Text(
            poem.author,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget buildSentenceListItem(PoemData poem, String query) {
    // 方法：从诗词内容中提取包含查询内容的行
    String extractMatchingLines(String content, String query) {
      // 将内容按换行符、逗号、句号分割
      List<String> lines = content.split(RegExp(r'[，。；！？\n]'));

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
        return '未找到匹配的诗句'; // 未找到匹配的行
      }
    }

    String content = poem.content;
    String matchingLines = extractMatchingLines(content, query);

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
            poem.title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 5),
          // 第二行：匹配的诗句内容
          Text(
            matchingLines,
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          // 第三行：作者名
          Text(
            poem.author,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget buildFamousSentenceListItem(SentenceData sentence) {
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
            sentence.poetryName,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 5),
          // 第二行：名句内容
          Text(
            sentence.content,
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          // 第三行：作者名
          Text(
            sentence.poetName,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
