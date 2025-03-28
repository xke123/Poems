// 导入必要的包
import 'package:flutter/material.dart';
import 'package:poems/models/search/author.dart';
import '../../services/search_service.dart';
import '../../models/poemdetailmodel.dart'; // 导入 PoetDetailModel
import '../../pages/detail/poet.dart'; // 导入 PoetDetailPage
import '../../services/db_service.dart'; // 导入 DbService
import '../../models/poetdetail_model.dart';
import '../detail/poem.dart';

class AuthorResultPage extends StatefulWidget {
  final String searchQuery;
  final String dynasty;

  const AuthorResultPage({
    required this.searchQuery,
    required this.dynasty,
  });

  @override
  _AuthorResultPageState createState() => _AuthorResultPageState();
}

class _AuthorResultPageState extends State<AuthorResultPage> {
  // 数据列表
  List<AuthorPoemModel> _authorResults = [];
  List<AuthorPoemModel> _poemResults = [];

  // 分页状态
  int _authorCurrentPage = 1;
  int _poemCurrentPage = 1;
  final int _pageSize = 20;

  bool _isAuthorLoading = false;
  bool _hasMoreAuthors = true;

  bool _isPoemLoading = false;
  bool _hasMorePoems = true;

  // 滚动控制器
  ScrollController _authorScrollController = ScrollController();
  ScrollController _poemScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadAuthorData();
    _loadPoemData();

    _authorScrollController.addListener(_authorScrollListener);
    _poemScrollController.addListener(_poemScrollListener);
  }

  @override
  void dispose() {
    _authorScrollController.removeListener(_authorScrollListener);
    _authorScrollController.dispose();

    _poemScrollController.removeListener(_poemScrollListener);
    _poemScrollController.dispose();

    super.dispose();
  }

  Future<void> _loadAuthorData() async {
    if (_isAuthorLoading || !_hasMoreAuthors) return;

    setState(() {
      _isAuthorLoading = true;
    });

    try {
      List<dynamic> results = await SearchService.search(
        query: widget.searchQuery,
        dynasty: widget.dynasty,
        option: '作者',
        limit: _pageSize,
        offset: (_authorCurrentPage - 1) * _pageSize,
      );

      // 筛选作者结果
      List<AuthorPoemModel> newAuthorResults = results
          .where(
              (result) => result is AuthorPoemModel && result.authorId != null)
          .cast<AuthorPoemModel>()
          .toList();

      setState(() {
        _authorCurrentPage++;
        _authorResults.addAll(newAuthorResults);
        _isAuthorLoading = false;
        if (newAuthorResults.length < _pageSize) {
          _hasMoreAuthors = false;
        }
      });
    } catch (e) {
      setState(() {
        _isAuthorLoading = false;
        _hasMoreAuthors = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载作者数据失败：${e.toString()}')),
      );
    }
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
        option: '作者',
        limit: _pageSize,
        offset: (_poemCurrentPage - 1) * _pageSize,
      );

      // 筛选作品结果
      List<AuthorPoemModel> newPoemResults = results
          .where((result) => result is AuthorPoemModel && result.poemId != null)
          .cast<AuthorPoemModel>()
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
        SnackBar(content: Text('加载作品数据失败：${e.toString()}')),
      );
    }
  }

  void _authorScrollListener() {
    if (_authorScrollController.position.pixels >=
        _authorScrollController.position.maxScrollExtent - 200) {
      _loadAuthorData();
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
    if (_authorResults.isEmpty && _poemResults.isEmpty) {
      return Text('当前搜索无结果',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
    }

    return Text(
      '当前搜索信息: 朝代:${widget.dynasty} - ${widget.searchQuery}',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  // 作者列表部分
  Widget _buildAuthorList() {
    if (_authorResults.isEmpty) return SizedBox(); // 如果没有作者结果，则返回空组件

    return Container(
      height: 110, // 调整高度以容纳加载指示器
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _authorScrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _authorResults.length + 1,
              itemBuilder: (context, index) {
                if (index == _authorResults.length) {
                  if (_hasMoreAuthors) {
                    return Center(
                      child: SizedBox(
                        width: 60,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  } else {
                    return Center(
                      child: SizedBox(
                        width: 60,
                        child: Text('没有更多作者'),
                      ),
                    );
                  }
                }

                final author = _authorResults[index];

                // 获取图片路径
                final String imagePath = 'assets/images/${author.authorId}.jpg';

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 10.0),
                  child: GestureDetector(
                    onTap: () async {
                      // 点击作者时的逻辑，导航到作者详情页
                      try {
                        // 显示加载指示器
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              Center(child: CircularProgressIndicator()),
                        );

                        // 获取作者详细信息
                        PoetDetailModel poetDetail =
                            await DbService.getAuthorById(author.authorId!);

                        // 关闭加载指示器
                        Navigator.pop(context);

                        // 导航到 PoetDetailPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PoetDetailPage(poetDetail: poetDetail),
                          ),
                        );
                      } catch (e) {
                        // 关闭加载指示器
                        Navigator.pop(context);

                        // 显示错误信息
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('获取作者详情失败：${e.toString()}')),
                        );
                      }
                    },
                    child: Container(
                      width: 60,
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
                          // 图片部分
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              width: 60,
                              height: 90,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                    color: Colors.grey,
                                    width: 60, // 宽度
                                    height: 90, // 高度
                                    child: FittedBox(
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ));
                              },
                            ),
                          ),
                          // 名字部分
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
                                author.authorName ?? '未知作者',
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
      ),
    );
  }

  // 作品列表部分
  Widget _buildPoemList() {
    if (_poemResults.isEmpty) return SizedBox(); // 如果没有作品结果，则返回空组件

    return Expanded(
      child: ListView.builder(
        controller: _poemScrollController,
        itemCount: _poemResults.length + 1,
        itemBuilder: (context, index) {
          if (index == _poemResults.length) {
            if (_hasMorePoems) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: Text('没有更多作品'));
            }
          }

          final poem = _poemResults[index];

          return Column(
            children: [
              if (index != 0)
                Divider(height: 1, color: Colors.grey), // 每个项的分隔线，排除第一个项
              Container(
                height: 60, // 设置每个列表项的高度
                child: ListTile(
                  title: Text(poem.poemTitle ?? '未知作品'),
                  subtitle: Text('作者: ${poem.poemAuthor ?? '未知'}'),
                  onTap: () async {
                    // 点击作品时的逻辑，导航到作品详情页
                    try {
                      // 显示加载指示器
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            Center(child: CircularProgressIndicator()),
                      );

                      // 获取作品详细信息
                      PoemDetailModel poemDetail =
                          await DbService.getQuoteById(poem.poemId!);

                      // 关闭加载指示器
                      Navigator.pop(context);

                      // 导航到 PoemDetailPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PoemDetailPage(id: poemDetail.id),
                        ),
                      );
                    } catch (e) {
                      // 关闭加载指示器
                      Navigator.pop(context);

                      // 显示错误信息
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('获取作品详情失败：${e.toString()}')),
                      );
                    }
                  },
                ),
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
        title: Text('搜索结果'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 第一部分：搜索信息
            _buildSearchInfo(),
            SizedBox(height: 20),

            // 第二部分：横向滚动列表（作者）
            _buildAuthorList(),
            SizedBox(height: 0),

            // 第三部分：垂直滚动列表（作品）
            _buildPoemList(),
          ],
        ),
      ),
    );
  }
}
