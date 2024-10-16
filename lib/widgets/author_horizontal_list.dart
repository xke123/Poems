import 'package:flutter/material.dart';
import '../models/search/GlobalSearchResult.dart';
import '../services/search_service.dart';
import '../models/search/AuthorData.dart';
import '../../models/poetdetail_model.dart';
import '../../services/db_service.dart';
import '../../pages/detail/poet.dart'; // 导入作者详情页

class AuthorHorizontalList extends StatefulWidget {
  final String searchQuery;
  final String dynasty;
  final List<GlobalSearchResult> initialResults;

  AuthorHorizontalList({
    required this.searchQuery,
    required this.dynasty,
    required this.initialResults,
  });

  @override
  _AuthorHorizontalListState createState() => _AuthorHorizontalListState();
}

class _AuthorHorizontalListState extends State<AuthorHorizontalList> {
  List<GlobalSearchResult> authorResults = [];
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  int page = 1; // 当前页码
  int limit = 20; // 每页数量

  @override
  void initState() {
    super.initState();
    authorResults = widget.initialResults; // 初始化数据
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchAuthors() async {
    if (isLoading) return; // 防止重复请求
    setState(() {
      isLoading = true;
    });

    try {
      List<GlobalSearchResult> newResults =
          await SearchService.searchAuthorsGlobal(
        query: widget.searchQuery,
        dynasty: widget.dynasty,
        limit: limit,
        offset: page * limit,
      );

      setState(() {
        page++;
        authorResults.addAll(newResults);
        isLoading = false;
      });
    } catch (e) {
      print('获取作者数据失败: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < 200) {
      _fetchAuthors();
    }
  }

  @override
  Widget build(BuildContext context) {
    double sectionHeight = 130; // 可根据需要调整高度

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题栏部分
        Container(
          height: sectionHeight * 0.2,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "作者",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        // 内容栏部分，水平滑动的圆角矩形列表
        Container(
          height: sectionHeight * 0.7,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: authorResults.length + 1, // 加1用于加载指示器
            itemBuilder: (context, index) {
              if (index == authorResults.length) {
                return isLoading
                    ? Container(
                        width: 50,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : SizedBox();
              }
              final result = authorResults[index];
              final author = result.authorData!;
              final String imagePath = 'assets/images/${author.id}.jpg';

              return GestureDetector(
                onTap: () async {
                  // 跳转到作者详情页面
                  try {
                    // 从数据库获取作者详情
                    PoetDetailModel poetDetail =
                        await DbService.getAuthorById(author.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PoetDetailPage(poetDetail: poetDetail),
                      ),
                    );
                  } catch (e) {
                    print('获取作者详情失败: $e');
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 10.0),
                  child: Container(
                    width: sectionHeight * 0.4,
                    height: sectionHeight * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6.0,
                          spreadRadius: 2.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            width: sectionHeight * 0.4,
                            height: sectionHeight * 0.8,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey,
                                child: Icon(
                                  Icons.person,
                                  size: sectionHeight * 0.4,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: -2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2.0, vertical: 2.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Text(
                              author.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
