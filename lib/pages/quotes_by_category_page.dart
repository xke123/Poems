import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 导入provider包
import '../models/author_viewmodel.dart';
import '../models/author_model.dart';
import 'dart:io';

class QuotesByCategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 朝代列表
    final List<String> dynasties = [
      '商',
      '周',
      '秦',
      '汉',
      '三国',
      '晋',
      '南北朝',
      '隋',
      '唐',
      '五代十国',
      '辽',
      '宋',
      '金',
      '元',
      '明',
      '清',
      '现代'
    ];

    return ChangeNotifierProvider(
      create: (context) =>
          AuthorViewModel()..fetchAuthors(), // 提供 AuthorViewModel
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              // 上面部分，暂时留空，占页面30%
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.3,
                color: Colors.transparent, // 留空
                // child: Center(
                //   child: Builder(
                //     builder: (BuildContext newContext) {
                //       return ElevatedButton(
                //         onPressed: () {
                //           // 在新的 BuildContext 中访问 Provider
                //           Provider.of<AuthorViewModel>(newContext,
                //                   listen: false)
                //               .fetchAuthors();
                //         },
                //         child: Text("获取作者数据"),
                //       );
                //     },
                //   ),
                // ),
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
                            items: dynasties, // 将朝代列表传递进去
                          ),
                          // 作者部分
                          AuthorSection(), // 使用作者部分
                          // 诗集部分（暂时使用占位符）
                          CategorySection(
                            title: "诗集",
                            items: List.generate(30, (index) => '诗集 $index'),
                          ),
                          // 文体部分（暂时使用占位符）
                          CategorySection(
                            title: "文体",
                            items: List.generate(30, (index) => '文体 $index'),
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
      ),
    );
  }
}

// 每个分类部分的组件
class CategorySection extends StatelessWidget {
  final String title;
  final List<String> items; // 修改为传递字符串列表

  CategorySection({required this.title, required this.items});

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
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          // 水平滑动的圆角矩形列表
          Container(
            height: 80, // 每个部分中圆角矩形的高度
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length, // 使用传递的值填充
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 80, // 圆角矩形的宽度
                    decoration: BoxDecoration(
                      color: Colors.grey, // 占位符颜色
                      borderRadius: BorderRadius.circular(16.0), // 圆角
                    ),
                    child: Center(
                      child: Text(
                        items[index], // 显示朝代或其他分类的值
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
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
}

//作者部分
class AuthorSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthorViewModel>(
      builder: (context, viewModel, child) {
        // 调试信息：查看是否成功获取到了作者数据
        print("当前作者数量: ${viewModel.authors.length}");

        if (viewModel.authors.isEmpty) {
          print("作者数据为空，显示加载中...");
          return Center(child: CircularProgressIndicator());
        }

        // 如果有作者数据，输出作者名到控制台
        print("显示作者列表:");
        viewModel.authors.forEach((author) {
          print("作者: ${author.name}, ID: ${author.id}");
        });

        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0), // 每个部分底部的间距
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "作者",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // 水平滑动的圆角矩形列表
              Container(
                height: 80, // 每个部分中圆角矩形的高度
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.authors.length, // 使用作者列表长度
                  itemBuilder: (context, index) {
                    final author = viewModel.authors[index];
                    final imagePath =
                        'assets/images/${author.id}.jpg'; // 根据id生成图片路径

                    // 调试信息：显示每个作者的数据
                    print("显示作者: ${author.name}");

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: 80, // 圆角矩形的宽度
                        decoration: BoxDecoration(
                          color: Colors.grey, // 背景色
                          borderRadius: BorderRadius.circular(16.0), // 圆角
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              imagePath,
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) {
                                // 如果图片加载失败，显示占位符
                                return Icon(Icons.person,
                                    size: 50, color: Colors.white);
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
          ),
        );
      },
    );
  }
}
