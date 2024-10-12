// lib/pages/search/author_horizontal_list.dart

import 'package:flutter/material.dart';
import '../models/search/GlobalSearchResult.dart';

class AuthorHorizontalList extends StatelessWidget {
  final List<GlobalSearchResult> authorResults;

  AuthorHorizontalList({required this.authorResults});

  @override
  Widget build(BuildContext context) {
    double sectionHeight = 130; // 可根据需要调整高度

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题栏部分
        Container(
          height: sectionHeight * 0.2,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "作者",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        // 内容栏部分，水平滑动的圆角矩形列表
        Container(
          height: sectionHeight * 0.7,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: authorResults.length,
            itemBuilder: (context, index) {
              final result = authorResults[index];
              final author = result.authorData!;
              final String imagePath = 'assets/images/${author.id}.jpg';

              return GestureDetector(
                onTap: () {
                  // 跳转到作者详情页面
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => AuthorDetailPage(authorData: author)));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 10.0),
                  child: Container(
                    width: sectionHeight * 0.4,
                    height: sectionHeight * 0.8,
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            width: sectionHeight * 0.4,
                            height: sectionHeight * 0.8,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey,
                                child: Icon(
                                  Icons.person,
                                  size: sectionHeight * 0.4,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
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
                              author.name,
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
    );
  }
}
