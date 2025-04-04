// lib/pages/search/poemResult.dart

import 'package:flutter/material.dart';
import '../../models/poemdetailmodel.dart';
import '../../services/search_service.dart';
import '../../services/db_service.dart';
import '../detail/poem.dart';

class PoemResultPage extends StatefulWidget {
  final String searchQuery;
  final String dynasty;

  PoemResultPage({
    required this.searchQuery,
    required this.dynasty,
  });

  @override
  _PoemResultPageState createState() => _PoemResultPageState();
}

class _PoemResultPageState extends State<PoemResultPage> {
  List<PoemDetailModel> _poemResults = [];
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
      List<dynamic> results = await SearchService.search(
        query: widget.searchQuery,
        dynasty: widget.dynasty,
        option: '作品名',
        limit: _pageSize,
        offset: (_currentPage - 1) * _pageSize,
      );

      List<PoemDetailModel> newResults = results.cast<PoemDetailModel>();

      setState(() {
        _currentPage++;
        _poemResults.addAll(newResults);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('作品名搜索结果'),
      ),
      body: _poemResults.isEmpty && !_hasMoreData
          ? Center(
              child: Text(
                '未找到与 "${widget.searchQuery}" 相关的作品',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: _poemResults.length + 1,
              itemBuilder: (context, index) {
                if (index == _poemResults.length) {
                  if (_hasMoreData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(child: Text('没有更多数据了'));
                  }
                }

                final poem = _poemResults[index];

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
                          await DbService.getQuoteById(poem.id);

                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PoemDetailPage(id: poemDetail.id),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch, // 左对齐
                      children: [
                        Text(
                          poem.title ?? '',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 5),
                        Text(
                          poem.author ?? '',
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
            ),
    );
  }
}
