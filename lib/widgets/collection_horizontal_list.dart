import 'package:flutter/material.dart';
import '../models/search/GlobalSearchResult.dart';
import '../services/search_service.dart';
import '../models/search/CollectionData.dart';
import '../../models/poemdetailmodel.dart';
import '../../services/db_service.dart';
import '../../pages/detail/collection.dart'; // 导入作品集详情页

class CollectionHorizontalList extends StatefulWidget {
  final String searchQuery;
  final String dynasty;
  final List<GlobalSearchResult> initialResults;

  CollectionHorizontalList({
    required this.searchQuery,
    required this.dynasty,
    required this.initialResults,
  });

  @override
  _CollectionHorizontalListState createState() =>
      _CollectionHorizontalListState();
}

class _CollectionHorizontalListState extends State<CollectionHorizontalList> {
  List<GlobalSearchResult> collectionResults = [];
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  int page = 1; // 当前页码
  int limit = 20; // 每页数量

  @override
  void initState() {
    super.initState();
    collectionResults = widget.initialResults; // 初始化数据
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchCollections() async {
    if (isLoading) return; // 防止重复请求
    setState(() {
      isLoading = true;
    });

    try {
      List<GlobalSearchResult> newResults =
          await SearchService.searchCollectionsGlobal(
        query: widget.searchQuery,
        dynasty: widget.dynasty,
        limit: limit,
        offset: page * limit,
      );

      setState(() {
        page++;
        collectionResults.addAll(newResults);
        isLoading = false;
      });
    } catch (e) {
      print('获取作品集数据失败: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < 200) {
      _fetchCollections();
    }
  }

  @override
  Widget build(BuildContext context) {
    double sectionHeight = 150; // 可根据需要调整高度

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题栏部分
        Container(
          height: sectionHeight * 0.2,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "作品集",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        // 内容栏部分，水平滑动的列表
        Container(
          height: sectionHeight * 0.7,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: collectionResults.length + 1, // 加1用于加载指示器
            itemBuilder: (context, index) {
              if (index == collectionResults.length) {
                return isLoading
                    ? Container(
                        width: 50,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : SizedBox();
              }
              final result = collectionResults[index];
              final collection = result.collectionData!;
              final Color color = _getBackgroundColor(collection.kind);

              return GestureDetector(
                onTap: () async {
                  // 跳转到作品集详情页
                  try {
                    // 通过作品集标题获取作品列表
                    List<PoemDetailModel> poems =
                        await DbService.getPoemsByCollectionTitle(
                            collection.title);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CollectionDetailPage(
                          collectionTitle: collection.title,
                          poems: poems,
                        ),
                      ),
                    );
                  } catch (e) {
                    print('获取作品集详情失败: $e');
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 10.0),
                  child: Stack(
                    children: [
                      // 背景颜色的容器
                      Container(
                        width: sectionHeight * 0.4,
                        decoration: BoxDecoration(
                          color: color,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                      // 竖排文字显示在右上角，带有白色底色
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(1.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: collection.title
                                .split('')
                                .map((char) => Text(
                                      char,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        height: 1.1,
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getBackgroundColor(String kind) {
    switch (kind) {
      case '诗':
        return Colors.blueAccent;
      case '词':
        return Colors.green;
      case '文':
        return Colors.redAccent;
      case '曲':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
