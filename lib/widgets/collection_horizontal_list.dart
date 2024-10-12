// lib/pages/search/collection_horizontal_list.dart

import 'package:flutter/material.dart';
import '../models/search/GlobalSearchResult.dart';

class CollectionHorizontalList extends StatelessWidget {
  final List<GlobalSearchResult> collectionResults;

  CollectionHorizontalList({required this.collectionResults});

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
    double sectionHeight = 150; // 可根据需要调整高度

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题栏部分
        Container(
          height: sectionHeight * 0.2,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "作品集",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        // 内容栏部分，水平滑动的列表
        Container(
          height: sectionHeight * 0.7,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: collectionResults.length,
            itemBuilder: (context, index) {
              final result = collectionResults[index];
              final collection = result.collectionData!;
              final Color color = _getBackgroundColor(collection.kind);

              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 10.0),
                child: GestureDetector(
                  onTap: () {
                    // 点击作品集后，跳转到详情页面
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => CollectionDetailPage(collectionTitle: collection.title)));
                  },
                  child: Stack(
                    children: [
                      // 背景颜色的容器
                      Container(
                        width: sectionHeight * 0.4,
                        decoration: BoxDecoration(
                          color: color,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                      // 竖排文字显示在右上角，带有白色底色
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(1.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: collection.title
                                .split('')
                                .map((char) => Text(
                                      char,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        height: 1.1,
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
