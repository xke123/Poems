import 'package:flutter/material.dart';
import '../../models/search/SentenceData.dart';
import '../detail/poem.dart';
import '../../models/poemdetailmodel.dart';
import '../../services/db_service.dart';
import '../../services/search_service.dart';

class SentenceResultPage extends StatefulWidget {
  final String searchQuery;
  final String dynasty;

  SentenceResultPage({
    required this.searchQuery,
    required this.dynasty,
  });

  @override
  _SentenceResultPageState createState() => _SentenceResultPageState();
}

class _SentenceResultPageState extends State<SentenceResultPage> {
  List<SentenceData> _sentenceResults = [];
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
        option: '名句',
        limit: _pageSize,
        offset: (_currentPage - 1) * _pageSize,
      );

      List<SentenceData> newResults = results.cast<SentenceData>();

      setState(() {
        _currentPage++;
        _sentenceResults.addAll(newResults);
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
        title: Text('名句搜索结果'),
      ),
      body: _sentenceResults.isEmpty && !_hasMoreData
          ? Center(
              child: Text(
                '未找到与 "${widget.searchQuery}" 相关的名句',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: _sentenceResults.length + 1,
              itemBuilder: (context, index) {
                if (index == _sentenceResults.length) {
                  if (_hasMoreData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(child: Text('没有更多数据了'));
                  }
                }

                SentenceData sentence = _sentenceResults[index];
                return GestureDetector(
                  onTap: () async {
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
                          builder: (context) => PoemDetailPage(
                            poemDetail: poemDetail,
                          ),
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
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          sentence.poetryName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 5),
                        Text(
                          sentence.content,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
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
            ),
    );
  }
}
