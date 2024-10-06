import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/author_viewmodel.dart';
import '../models/author_model.dart';

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

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
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
              height: widget.sectionHeight * 0.8,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount:
                    viewModel.authors.length + (viewModel.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == viewModel.authors.length) {
                    // 显示加载指示器
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final AuthorModel author = viewModel.authors[index];
                  final String imagePath =
                      'assets/images/${author.id}.jpg'; // 根据ID动态加载图片

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10.0),
                    child: Container(
                      width: widget.sectionHeight * 0.8, // 保持正方形
                      decoration: BoxDecoration(
                        color: Colors.grey, // 背景色
                        borderRadius: BorderRadius.circular(16.0), // 圆角
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            spreadRadius: 2,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            imagePath,
                            width: widget.sectionHeight * 0.48, // 图片大小为内容高度的60%
                            height: widget.sectionHeight * 0.48,
                            errorBuilder: (context, error, stackTrace) {
                              // 如果图片加载失败，显示占位符
                              return Icon(Icons.person,
                                  size: widget.sectionHeight * 0.48,
                                  color: Colors.white);
                            },
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            author.name, // 显示作者名
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
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
      },
    );
  }
}
