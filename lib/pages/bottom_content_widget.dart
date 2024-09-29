// bottom_content_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/author_viewmodel.dart';
import '../models/collections_viewmodel.dart';

class BottomContentWidget extends StatelessWidget {
  final double bottomContainerHeight;
  final List<String> dynasties;

  BottomContentWidget({
    required this.bottomContainerHeight,
    required this.dynasties,
  });

  @override
  Widget build(BuildContext context) {
    // 每个部分的高度应为圆角矩形框高度的五分之一
    final sectionHeight = bottomContainerHeight / 5;

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9, // 宽度占90%
        height: bottomContainerHeight, // 高度占下部分的80%
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0), // 圆角
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
              offset: Offset(0, 5), // 阴影偏移
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 朝代部分
              Expanded(
                child: CategorySection(
                  title: "朝代",
                  items: dynasties, // 使用定义的朝代数组
                  sectionHeight: sectionHeight, // 自动高度
                ),
              ),
              // 作者部分
              Expanded(
                child: AuthorSection(
                  sectionHeight: sectionHeight, // 传入计算的高度
                ),
              ),
              // 作品集部分
              Expanded(
                child: CollectionSection(
                  sectionHeight: sectionHeight, // 传入计算的高度
                ),
              ),
              // 文体部分
              Expanded(
                child: WenTiSection(
                  sectionHeight: sectionHeight, // 传入计算的高度
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 以下是各个部分的组件代码，您可以将它们放在单独的文件中，或者保持在此文件内。

// 朝代部分组件
class CategorySection extends StatelessWidget {
  final String title;
  final List<String> items;
  final double sectionHeight; // 动态传入的可用高度

  CategorySection({
    required this.title,
    required this.items,
    required this.sectionHeight,
  });

  @override
  Widget build(BuildContext context) {
    // 计算每个部分的标题和内容的高度
    final titleHeight = sectionHeight * 0.2; // 标题占20%高度
    final contentHeight = sectionHeight * 0.8; // 内容占80%高度

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题栏部分
        Container(
          height: titleHeight,
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        // 内容栏部分，水平滑动的圆角矩形列表
        Container(
          height: contentHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final imagePath = 'assets/image/dynasty_icon.png'; // 示例图片路径
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: contentHeight, // 高度和宽度一致，保持正方形
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        spreadRadius: 2,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      items[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 3,
                            color: Colors.black.withOpacity(0.7),
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
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

// 作者部分组件
class AuthorSection extends StatelessWidget {
  final double sectionHeight; // 添加 sectionHeight 参数

  AuthorSection({required this.sectionHeight});

  @override
  Widget build(BuildContext context) {
    // 计算每个部分的标题和内容的高度
    final titleHeight = sectionHeight * 0.2; // 标题占20%高度
    final contentHeight = sectionHeight * 0.8; // 内容占80%高度

    return Consumer<AuthorViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.authors.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题栏部分
            Container(
              height: titleHeight,
              alignment: Alignment.centerLeft,
              child: Text(
                "作者",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ),
            // 内容栏部分，水平滑动的圆角矩形列表
            Container(
              height: contentHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: viewModel.authors.length,
                itemBuilder: (context, index) {
                  final author = viewModel.authors[index];
                  final imagePath =
                      'assets/images/${author.id}.jpg'; // 根据ID动态加载图片

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: contentHeight, // 让宽度与内容高度一致，保持正方形
                      decoration: BoxDecoration(
                        color: Colors.grey, // 背景色
                        borderRadius: BorderRadius.circular(16.0), // 圆角
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            imagePath,
                            width: contentHeight * 0.6, // 图片大小为内容高度的60%
                            height: contentHeight * 0.6, // 高度和宽度一致
                            errorBuilder: (context, error, stackTrace) {
                              // 如果图片加载失败，显示占位符
                              return Icon(Icons.person,
                                  size: contentHeight * 0.6,
                                  color: Colors.white);
                            },
                          ),
                          Text(
                            author.name, // 显示作者名
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
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
      },
    );
  }
}

// 作品集部分组件
class CollectionSection extends StatelessWidget {
  final double sectionHeight; // 添加 sectionHeight 参数

  CollectionSection({required this.sectionHeight});

  @override
  Widget build(BuildContext context) {
    // 计算每个部分的标题和内容的高度
    final titleHeight = sectionHeight * 0.2; // 标题占20%高度
    final contentHeight = sectionHeight * 0.8; // 内容占80%高度

    return Consumer<CollectionViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.collections.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题栏部分
            Container(
              height: titleHeight,
              alignment: Alignment.centerLeft,
              child: Text(
                "作品集",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ),
            // 内容栏部分，水平滑动的圆角矩形列表
            Container(
              height: contentHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: viewModel.collections.length,
                itemBuilder: (context, index) {
                  final collection = viewModel.collections[index];
                  final color = _getBackgroundColor(collection.kind);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: contentHeight * 0.6, // 宽度设为高度的60%
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Center(
                        child: Text(
                          collection.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // 根据 Kind 设置不同的背景颜色
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
}

// 文体部分组件
class WenTiSection extends StatelessWidget {
  final List<String> wenTiItems = ['诗', '词', '曲', '赋', '文'];
  final double sectionHeight; // 添加 sectionHeight 参数

  WenTiSection({required this.sectionHeight});

  @override
  Widget build(BuildContext context) {
    // 计算每个部分的标题和内容的高度
    final titleHeight = sectionHeight * 0.2; // 标题占20%高度
    final contentHeight = sectionHeight * 0.8; // 内容占80%高度

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题栏部分
        Container(
          height: titleHeight,
          alignment: Alignment.centerLeft,
          child: Text(
            "文体",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          ),
        ),
        // 内容栏部分，水平滑动的圆角矩形列表
        Container(
          height: contentHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: wenTiItems.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: contentHeight * 0.6, // 宽度设为内容高度的60%
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Center(
                    child: Text(
                      wenTiItems[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
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
