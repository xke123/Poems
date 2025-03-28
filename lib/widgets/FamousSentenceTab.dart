// lib/pages/search/famous_sentence_tab_content.dart

import 'package:flutter/material.dart';
import '../../models/search/GlobalSearchResult.dart';
import '../../models/search/SentenceData.dart';
import '../../services/search_service.dart';
import '../../services/db_service.dart';
import '../../pages/detail/poem.dart';
import '../models/poemdetailmodel.dart';

class FamousSentenceTabContent extends StatefulWidget {
  final String searchQuery;
  final String dynasty;

  FamousSentenceTabContent({
    required this.searchQuery,
    required this.dynasty,
  });

  @override
  _FamousSentenceTabContentState createState() =>
      _FamousSentenceTabContentState();
}

class _FamousSentenceTabContentState extends State<FamousSentenceTabContent> {
  List<SentenceData> _famousSentenceResults = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;
  final int _pageSize = 20;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadData();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // 调用搜索服务获取更多数据
      List<GlobalSearchResult> results = await SearchService.searchGlobalByType(
        query: widget.searchQuery,
        dynasty: widget.dynasty,
        type: 'famous_sentence',
        limit: _pageSize,
        offset: (_currentPage - 1) * _pageSize,
      );

      // 提取 SentenceData
      List<SentenceData> newResults = results
          .where((result) => result.type == 'famous_sentence')
          .map((result) => result.sentenceData!)
          .toList();

      setState(() {
        _currentPage++;
        _famousSentenceResults.addAll(newResults);
        _isLoading = false;
        if (newResults.length < _pageSize) {
          _hasMoreData = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasMoreData = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载数据失败：${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_famousSentenceResults.isEmpty && !_hasMoreData) {
      return Center(
        child: Text(
          '未找到与 "${widget.searchQuery}" 相关的名句',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _famousSentenceResults.length + 1,
      itemBuilder: (context, index) {
        if (index == _famousSentenceResults.length) {
          if (_hasMoreData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(child: Text('没有更多数据了'));
          }
        }

        final sentence = _famousSentenceResults[index];

        return GestureDetector(
          onTap: () async {
            // 点击事件，跳转到诗词详情页面
            try {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    Center(child: CircularProgressIndicator()),
              );

              PoemDetailModel poemDetail =
                  await DbService.getQuoteById(sentence.poetryId);

              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PoemDetailPage(id: poemDetail.id),
                ),
              );
            } catch (e) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('加载诗词详情出错：${e.toString()}')),
              );
            }
          },
          child: Container(
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
          ),
        );
      },
    );
  }
}
