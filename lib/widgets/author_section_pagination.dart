import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/author_viewmodel.dart';
import '../models/author_model.dart';
import '../services/db_service.dart'; // 引入数据库服务
import '../pages/detail/poet.dart'; // 引入作者详情页面
import '../models/poetdetail_model.dart';

class AuthorSectionPagination extends StatefulWidget {
  final double sectionHeight;

  AuthorSectionPagination({required this.sectionHeight});

  @override
  _AuthorSectionPaginationState createState() =>
      _AuthorSectionPaginationState();
}

class _AuthorSectionPaginationState extends State<AuthorSectionPagination> {
  late ScrollController _scrollController;
  late AuthorViewModel _authorViewModel;

  @override
  void initState() {
    super.initState();
    _authorViewModel = Provider.of<AuthorViewModel>(context, listen: false);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_authorViewModel.isLoading &&
        _authorViewModel.hasMore) {
      _authorViewModel.fetchAuthors();
    }
  }

  Future<void> _fetchAuthorDetails(
      BuildContext context, String authorId) async {
    try {
      print('开始获取作者详情，ID: $authorId');
      final poetDetail = await DbService.getAuthorById(authorId); // 查询数据库
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PoetDetailPage(poetDetail: poetDetail),
        ),
      );
    } catch (e) {
      print('获取作者详情失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthorViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.authors.isEmpty && viewModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题栏部分
            Container(
              height: widget.sectionHeight * 0.2,
              alignment: Alignment.centerLeft,
              child: Text(
                "作者",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ),
            // 内容栏部分，水平滑动的圆角矩形列表
            Container(
              height: widget.sectionHeight * 0.7,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount:
                    viewModel.authors.length + (viewModel.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == viewModel.authors.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final AuthorModel author = viewModel.authors[index];
                  final String imagePath =
                      'assets/images/${author.id}.jpg'; // 根据ID动态加载图片

                  return GestureDetector(
                    onTap: () => _fetchAuthorDetails(
                        context, author.id.toString()), // 转换为String
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10.0),
                      child: Container(
                        width: widget.sectionHeight * 0.4,
                        height: widget.sectionHeight * 0.8,
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
                                fit: BoxFit.fitWidth,
                                width: widget.sectionHeight * 0.4,
                                height: widget.sectionHeight * 0.8,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey,
                                    child: Icon(
                                      Icons.person,
                                      size: widget.sectionHeight * 0.4,
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
      },
    );
  }
}
