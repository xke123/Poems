import 'package:flutter/material.dart';
import 'package:poems/models/search/author.dart';
import '../../services/search_service.dart';
import '../../models/poemdetailmodel.dart';
import '../../pages/detail/poem.dart';

class CollectionResultPage extends StatefulWidget {
  final String searchQuery;
  final String dynasty;

  const CollectionResultPage({
    required this.searchQuery,
    required this.dynasty,
  });

  @override
  _CollectionResultPageState createState() => _CollectionResultPageState();
}

class _CollectionResultPageState extends State<CollectionResultPage> {
  // 数据列表
  List<PoemDetailModel> _poemResults = [];

  // 分页状态
  int _poemCurrentPage = 1;
  final int _pageSize = 30;

  bool _isPoemLoading = false;
  bool _hasMorePoems = true;

  // 滚动控制器
  ScrollController _poemScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadPoemData();

    _poemScrollController.addListener(_poemScrollListener);
  }

  @override
  void dispose() {
    _poemScrollController.removeListener(_poemScrollListener);
    _poemScrollController.dispose();

    super.dispose();
  }

  Future<void> _loadPoemData() async {
    if (_isPoemLoading || !_hasMorePoems) return;

    setState(() {
      _isPoemLoading = true;
    });

    try {
      List<dynamic> results = await SearchService.search(
        query: widget.searchQuery,
        dynasty: widget.dynasty,
        option: '作品集', // 使用作品集选项
        limit: _pageSize,
        offset: (_poemCurrentPage - 1) * _pageSize,
      );

      // 筛选作品集结果
      List<PoemDetailModel> newPoemResults = results
          .where((result) => result is PoemDetailModel)
          .cast<PoemDetailModel>()
          .toList();

      setState(() {
        _poemCurrentPage++;
        _poemResults.addAll(newPoemResults);
        _isPoemLoading = false;
        if (newPoemResults.length < _pageSize) {
          _hasMorePoems = false;
        }
      });
    } catch (e) {
      setState(() {
        _isPoemLoading = false;
        _hasMorePoems = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载作品集数据失败：${e.toString()}')),
      );
    }
  }

  void _poemScrollListener() {
    if (_poemScrollController.position.pixels >=
        _poemScrollController.position.maxScrollExtent - 200) {
      _loadPoemData();
    }
  }

  // 搜索信息部分
  Widget _buildSearchInfo() {
    if (_poemResults.isEmpty) {
      return Text('当前搜索无结果',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
    }

    return Text(
      '当前搜索信息: 朝代:${widget.dynasty} - ${widget.searchQuery}',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  // 作品集列表部分
  Widget _buildPoemList() {
    if (_poemResults.isEmpty) return SizedBox(); // 如果没有作品集结果，则返回空组件

    return Expanded(
      child: ListView.builder(
        controller: _poemScrollController,
        itemCount: _poemResults.length + 1,
        itemBuilder: (context, index) {
          if (index == _poemResults.length) {
            if (_hasMorePoems) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: Text('没有更多作品集'));
            }
          }

          final poem = _poemResults[index];

          return Column(
            children: [
              if (index != 0)
                Divider(height: 1, color: Colors.grey), // 每个项的分隔线，排除第一个项
              ListTile(
                title: Text(poem.title ?? '未知作品集'),
                subtitle: Text('作者: ${poem.author ?? '未知'}'),
                onTap: () {
                  // 跳转到作品详情页
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PoemDetailPage(id: poem.id),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('作品集搜索结果'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 第一部分：搜索信息
            _buildSearchInfo(),
            SizedBox(height: 20),

            // 第二部分：垂直滚动列表（作品集）
            _buildPoemList(),
          ],
        ),
      ),
    );
  }
}
