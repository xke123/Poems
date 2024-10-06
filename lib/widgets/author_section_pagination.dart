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
              height: widget.sectionHeight * 0.7,
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
                      width: widget.sectionHeight * 0.4,
                      height: widget.sectionHeight * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0), // 圆角
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // 阴影颜色
                            blurRadius: 6.0, // 模糊半径
                            spreadRadius: 2.0, // 阴影扩散半径
                            offset: Offset(0, 3), // 阴影偏移量
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // 图片部分，放在ClipRRect里确保图片有圆角
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(6.0), // 确保图片与容器圆角一致
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.fitWidth, // 保持图片的原始比例
                              width: widget.sectionHeight * 0.4,
                              height: widget.sectionHeight * 0.8,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey, // 如果图片加载失败，显示灰色背景
                                  child: Icon(
                                    Icons.person,
                                    size: widget.sectionHeight * 0.4,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                          // 作者名字显示在图片右下角
                          Positioned(
                            bottom: 5,
                            right: -2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2.0, vertical: 2.0), // 设置内边距
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5), // 黑色背景
                                borderRadius:
                                    BorderRadius.circular(6.0), // 圆角矩形
                              ),
                              child: Text(
                                author.name,
                                style: TextStyle(
                                  color: Colors.white, // 白色文字
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis, // 超出显示省略号
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
      },
    );
  }
}
