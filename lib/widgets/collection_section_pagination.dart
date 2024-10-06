// lib/widgets/collection_section_pagination.dart

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
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "作品集",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ),
            // 内容栏部分，水平滑动的圆角矩形列表
            Container(
              height: widget.sectionHeight * 0.88,
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
                    child: Container(
                      width: widget.sectionHeight * 0.48, // 宽度设为高度的48%
                      decoration: BoxDecoration(
                        color: color,
                        // borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            spreadRadius: 2,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          collection.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 14),
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
