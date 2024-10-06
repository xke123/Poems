import 'package:flutter/material.dart';
import 'package:poems/models/search/author.dart';

class AuthorResultPage extends StatelessWidget {
  final String searchQuery;
  final String dynasty;
  final List<AuthorPoemModel> authorResults;
  final List<AuthorPoemModel> poemResults;

  const AuthorResultPage({
    required this.searchQuery,
    required this.dynasty,
    required this.authorResults,
    required this.poemResults,
  });

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

  // 搜索信息部分
  Widget _buildSearchInfo() {
    if (authorResults.isEmpty && poemResults.isEmpty) {
      return Text('当前搜索无结果',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
    }

    return Text(
      '当前搜索信息: 朝代:$dynasty - $searchQuery',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  // 作者列表部分
  Widget _buildAuthorList() {
    if (authorResults.isEmpty) return SizedBox(); // 如果没有作者结果，则返回空组件

    return Container(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: authorResults.length,
        itemBuilder: (context, index) {
          final author = authorResults[index];

          // 获取图片路径
          final String imagePath = 'assets/images/${author.authorId}.jpg';

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: GestureDetector(
              onTap: () {
                // 点击作者时的逻辑，可以跳转到详情页
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
    );
  }

  // 作品列表部分
  Widget _buildPoemList() {
    if (poemResults.isEmpty) return SizedBox(); // 如果没有作品结果，则返回空组件

    return Expanded(
      child: ListView.builder(
        itemCount: poemResults.length,
        itemBuilder: (context, index) {
          final poem = poemResults[index];

          return Column(
            children: [
              if (index != 0)
                Divider(height: 1, color: Colors.grey), // 每个项的分隔线，排除第一个项
              Container(
                height: 60, // 设置每个列表项的高度
                // padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(poem.poemTitle ?? '未知作品'),
                  subtitle: Text('作者: ${poem.poemAuthor ?? '未知'}'),
                  onTap: () {
                    // 点击事件逻辑
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
