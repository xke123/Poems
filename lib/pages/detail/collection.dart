import 'package:flutter/material.dart';
import '../../models/poemdetailmodel.dart';
import '../../services/db_service.dart'; // 引入服务
import 'poem.dart'; // 引入PoemDetailPage

class CollectionDetailPage extends StatelessWidget {
  final String collectionTitle;
  final List<PoemDetailModel> poems; // 传递的作品数据

  CollectionDetailPage({required this.collectionTitle, required this.poems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('作品集: $collectionTitle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildPoemList(context), // 传递context
      ),
    );
  }

  // 作品滚动列表
  Widget _buildPoemList(BuildContext context) {
    if (poems.isEmpty) {
      return Center(child: Text('当前作品集中无作品'));
    }

    return ListView.builder(
      itemCount: poems.length,
      itemBuilder: (context, index) {
        final poem = poems[index];

        return Column(
          children: [
            if (index != 0)
              Divider(height: 1, color: Colors.grey), // 分隔线，排除第一个项
            Container(
              height: 60, // 设置每个列表项的高度
              child: ListTile(
                title: Text(poem.title ?? '未知作品'),
                subtitle: Text('作者: ${poem.author ?? '未知'}'),
                onTap: () async {
                  try {
                    // 通过 ID 获取详细信息
                    PoemDetailModel poemDetail =
                        await DbService.getQuoteById(poem.id);

                    // 跳转到作品详情页
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PoemDetailPage(poemDetail: poemDetail),
                      ),
                    );
                  } catch (e) {
                    // 如果查询失败，显示错误提示
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('获取作品详情失败: $e')),
                    );
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
