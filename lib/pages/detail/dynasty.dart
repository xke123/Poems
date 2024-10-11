import 'package:flutter/material.dart';
import 'package:poems/models/dynastydetailmodel.dart';
import 'package:poems/services/db_service.dart';
import 'poem.dart';
import 'poet.dart';
import '../../models/poemdetailmodel.dart';
import '../../models/poetdetail_model.dart';

class DynastyDetailPage extends StatefulWidget {
  final String dynasty;
  final List<DynastyDetailModel> dynastyDetails;

  const DynastyDetailPage({
    required this.dynasty,
    required this.dynastyDetails,
  });

  @override
  _DynastyDetailPageState createState() => _DynastyDetailPageState();
}

class _DynastyDetailPageState extends State<DynastyDetailPage> {
  List<DynastyDetailModel> authors = [];
  List<DynastyDetailModel> poems = [];
  int authorPage = 1;
  int poemPage = 1;
  bool isLoadingAuthors = false;
  bool isLoadingPoems = false;

  final ScrollController _authorScrollController = ScrollController();
  final ScrollController _poemScrollController = ScrollController();

 @override
void initState() {
  super.initState();
  authors = widget.dynastyDetails
      .where((detail) => detail.authorId != null)
      .toList();
  poems = widget.dynastyDetails
      .where((detail) => detail.poemId != null)
      .toList();

  // 监听滚动事件
  _authorScrollController.addListener(_loadMoreAuthors);
  _poemScrollController.addListener(_loadMorePoems);
}


  @override
  void dispose() {
    _authorScrollController.dispose();
    _poemScrollController.dispose();
    super.dispose();
  }

 Future<void> _loadMoreAuthors() async {
  if (_authorScrollController.position.pixels ==
      _authorScrollController.position.maxScrollExtent) {
    if (!isLoadingAuthors) {
      setState(() {
        isLoadingAuthors = true;
      });

      try {
        // 调用单独获取作者数据的方法
        List<DynastyDetailModel> newAuthors =
            await DbService.getDynastyAuthors(widget.dynasty, ++authorPage, 30);

        print('加载到的新的作者数据: ${newAuthors.length} 条');
        newAuthors.forEach((author) {
          print(author); // 打印每一个新获取的作者数据
        });

        setState(() {
          authors.addAll(newAuthors);
          isLoadingAuthors = false;
        });
      } catch (e) {
        print('加载作者失败: $e');
        setState(() {
          isLoadingAuthors = false;
        });
      }
    }
  }
}

Future<void> _loadMorePoems() async {
  if (_poemScrollController.position.pixels ==
      _poemScrollController.position.maxScrollExtent) {
    if (!isLoadingPoems) {
      setState(() {
        isLoadingPoems = true;
      });

      try {
        // 调用单独获取作品数据的方法
        List<DynastyDetailModel> newPoems =
            await DbService.getDynastyPoems(widget.dynasty, ++poemPage, 30);

        print('加载到的新的诗词数据: ${newPoems.length} 条');
        newPoems.forEach((poem) {
          print(poem); // 打印每一个新获取的诗词数据
        });

        setState(() {
          poems.addAll(newPoems);
          isLoadingPoems = false;
        });
      } catch (e) {
        print('加载作品失败: $e');
        setState(() {
          isLoadingPoems = false;
        });
      }
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.dynasty} 朝'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDynastyImage(),
            SizedBox(height: 20),
            _buildAuthorList(),
            Expanded(
              child: _buildPoemList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynastyImage() {
    final String imagePath = 'assets/dynasty/${widget.dynasty}-img.png';
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12.0,
            spreadRadius: 5.0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey,
              child: Center(
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAuthorList() {
    return Container(
      height: 90,
      child: ListView.builder(
        controller: _authorScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: authors.length,
        itemBuilder: (context, index) {
          final author = authors[index];
          final String imagePath = 'assets/images/${author.authorId}.jpg';
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: GestureDetector(
              onTap: () async {
                try {
                  PoetDetailModel authorDetail =
                      await DbService.getAuthorById(author.authorId!);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PoetDetailPage(poetDetail: authorDetail),
                    ),
                  );
                } catch (e) {
                  print('获取作者详情失败: $e');
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
                    // 作者图片
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: author.hasImage
                          ? Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              width: 60,
                              height: 90,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey,
                                  width: 60,
                                  height: 90,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey,
                              width: 60,
                              height: 90,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    // 作者名字
                    Positioned(
                      bottom: 5, // 距离底部的距离
                      right: 5, // 距离右侧的距离
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6), // 半透明黑色背景
                          borderRadius: BorderRadius.circular(8.0), // 圆角背景
                        ),
                        child: Text(
                          author.authorName ?? '未知作者', // 显示作者名字
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10, // 设置字体大小
                          ),
                          maxLines: 1, // 限制为单行显示
                          overflow: TextOverflow.ellipsis, // 溢出时显示省略号
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
    );
  }

  Widget _buildPoemList() {
    return ListView.builder(
      controller: _poemScrollController,
      itemCount: poems.length,
      itemBuilder: (context, index) {
        final poem = poems[index];
        return Column(
          children: [
            if (index != 0) Divider(height: 1, color: Colors.grey),
            Container(
              height: 60,
              child: ListTile(
                title: Text(poem.poemTitle ?? '未知作品'),
                subtitle: Text('作者: ${poem.poemAuthor ?? '未知'}'),
                onTap: () async {
                  try {
                    PoemDetailModel poemDetail =
                        await DbService.getQuoteById(poem.poemId!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PoemDetailPage(poemDetail: poemDetail),
                      ),
                    );
                  } catch (e) {
                    print('获取作品详情失败: $e');
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
