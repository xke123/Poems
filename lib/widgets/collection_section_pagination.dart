import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/collections_viewmodel.dart';
import '../models/collections_model.dart';

class CollectionSectionPagination extends StatefulWidget {
  final double sectionHeight;

  CollectionSectionPagination({required this.sectionHeight});

  @override
  _CollectionSectionPaginationState createState() =>
      _CollectionSectionPaginationState();
}

class _CollectionSectionPaginationState
    extends State<CollectionSectionPagination> {
  late ScrollController _scrollController;
  late CollectionViewModel _collectionViewModel;

  @override
  void initState() {
    super.initState();
    _collectionViewModel =
        Provider.of<CollectionViewModel>(context, listen: false);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_collectionViewModel.isLoading &&
        _collectionViewModel.hasMore) {
      _collectionViewModel.fetchCollections();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionViewModel>(
      builder: (context, CollectionViewModel viewModel, child) {
        if (viewModel.collections.isEmpty && viewModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (viewModel.errorMessage != null && viewModel.collections.isEmpty) {
          return Center(child: Text(viewModel.errorMessage!));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题栏部分
            Container(
              height: widget.sectionHeight * 0.2,
              alignment: Alignment.centerLeft,
              // padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: RichText(
                text: TextSpan(
                  text: "作品集: ", // 前面的文字
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black), // 设置默认颜色为黑色
                  children: <TextSpan>[
                    TextSpan(
                      text: "诗集", // 诗集部分
                      style: TextStyle(color: _getBackgroundColor('诗')),
                    ),
                    TextSpan(
                      text: " / ",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: "文集", // 文集部分
                      style: TextStyle(color: _getBackgroundColor('文')),
                    ),
                    TextSpan(
                      text: " / ",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: "词集", // 词集部分
                      style: TextStyle(color: _getBackgroundColor('词')),
                    ),
                    TextSpan(
                      text: " / ",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: "曲集", // 曲集部分
                      style: TextStyle(color: _getBackgroundColor('曲')),
                    ),
                    TextSpan(
                      text: " / ",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: "赋集", // 赋集部分
                      style: TextStyle(
                          color: _getBackgroundColor('赋')), // 赋集颜色为默认颜色
                    ),
                  ],
                ),
              ),
            ),

            // 内容栏部分，水平滑动的圆角矩形列表
            Container(
              height: widget.sectionHeight * 0.7,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount:
                    viewModel.collections.length + (viewModel.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == viewModel.collections.length) {
                    // 显示加载指示器
                    if (viewModel.errorMessage != null) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Center(child: Text('加载失败')),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  }

                  final CollectionModel collection =
                      viewModel.collections[index];
                  final Color color = _getBackgroundColor(collection.kind);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10.0),
                    child: Stack(
                      children: [
                        // 背景颜色的容器
                        Container(
                          width: widget.sectionHeight * 0.4, // 宽度设为高度的48%
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
                            color: Colors.white, // 白色背景
                            padding: EdgeInsets.all(1.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min, // 根据内容高度最小化
                              children: collection.title
                                  .split('') // 将标题逐字分割
                                  .map((char) => Text(
                                        char,
                                        style: TextStyle(
                                          color: Colors.black, // 黑色字体
                                          fontSize: 10,
                                          height: 1.1, // 调整字符间距，值越小间距越紧凑
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
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
