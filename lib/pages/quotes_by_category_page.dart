import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuotesByCategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // 上面部分，暂时留空，占页面30%
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.3,
              color: Colors.transparent, // 留空
            ),
            // 下面部分，占页面70%，顶部对齐，水平方向居中
            Expanded(
              child: Align(
                alignment: Alignment.topCenter, // 顶部对齐，水平方向居中
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9, // 宽度占页面90%
                  height: MediaQuery.of(context).size.height *
                      0.7 *
                      0.88, // 高度占页面下部分的90%
                  decoration: BoxDecoration(
                    color: Colors.white, // 圆角矩形背景色
                    borderRadius: BorderRadius.circular(16.0), // 圆角
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: Offset(0, 5), // 阴影位置
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // 朝代部分
                        CategorySection(
                          title: "朝代",
                          itemCount: 30, // 占位符个数
                        ),
                        // 作者部分
                        CategorySection(
                          title: "作者",
                          itemCount: 30, // 占位符个数
                        ),
                        // 诗集部分
                        CategorySection(
                          title: "诗集",
                          itemCount: 30, // 占位符个数
                        ),
                        // 文体部分
                        CategorySection(
                          title: "文体",
                          itemCount: 30, // 占位符个数
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 每个分类部分的组件
class CategorySection extends StatelessWidget {
  final String title;
  final int itemCount;

  CategorySection({required this.title, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0), // 每个部分底部的间距改为 10
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // 水平滑动的圆角矩形列表
          Container(
            height: 75, // 每个部分中圆角矩形的高度
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 75, // 圆角矩形的宽度
                    decoration: BoxDecoration(
                      color: Colors.grey, // 占位符颜色
                      borderRadius: BorderRadius.circular(16.0), // 圆角
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
}
