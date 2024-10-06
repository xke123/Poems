import 'package:flutter/material.dart';
import 'package:poems/models/dynastydetailmodel.dart';
import 'package:poems/services/db_service.dart';

class DynastyDetailPage extends StatelessWidget {
  final String dynasty;
  final List<DynastyDetailModel> dynastyDetails;

  const DynastyDetailPage({
    required this.dynasty,
    required this.dynastyDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$dynasty 朝'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 第一部分：显示图片
            _buildDynastyImage(),
            SizedBox(height: 20),

            // 第二部分：作者横向滚动列表
            _buildAuthorList(),

            // 第三部分：作品滚动列表
            Expanded(
              child: _buildPoemList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynastyImage() {
    final String imagePath = 'assets/dynasty/$dynasty-img.png';

    return Container(
      height: 200, // 你可以根据需要调整高度
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
        borderRadius: BorderRadius.circular(12.0), // 确保图片圆角
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0), // 圆角
          ),
          child: Center(
            // 使用 Center 确保 Image 居中显示
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover, // 使图片按照原比例显示
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
        ),
      ),
    );
  }

  // 第二部分：作者横向滚动列表
  Widget _buildAuthorList() {
    final List<DynastyDetailModel> authors =
        dynastyDetails.where((detail) => detail.authorId != null).toList();

    if (authors.isEmpty) {
      print('没有作者数据');
      return SizedBox(); // 如果没有作者结果，则返回空组件
    }

    return Container(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: authors.length,
        itemBuilder: (context, index) {
          final author = authors[index];

          // 打印作者详细信息进行调试
          print(
              '++++页面显示作者: ${author.authorName}, Id: ${author.authorId}, HasImage: ${author.hasImage}');

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
                    // 根据hasImage字段决定显示图片还是图标
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

  // 第三部分：作品滚动列表
  Widget _buildPoemList() {
    final List<DynastyDetailModel> poems =
        dynastyDetails.where((detail) => detail.poemId != null).toList();
    if (poems.isEmpty) return SizedBox(); // 如果没有作品结果，则返回空组件

    return ListView.builder(
      itemCount: poems.length,
      itemBuilder: (context, index) {
        final poem = poems[index];

        return Column(
          children: [
            if (index != 0)
              Divider(height: 1, color: Colors.grey), // 每个项的分隔线，排除第一个项
            Container(
              height: 60, // 设置每个列表项的高度
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
    );
  }
}
