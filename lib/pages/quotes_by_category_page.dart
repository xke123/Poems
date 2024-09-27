import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poems/models/collections_viewmodel.dart';
import 'package:provider/provider.dart'; // 导入provider包
import '../models/author_viewmodel.dart';
import '../models/author_model.dart';
import '../models/collections_model.dart';
import '../models/quote_model.dart';

class QuotesByCategoryPage extends StatefulWidget {
  @override
  _QuotesByCategoryPageState createState() => _QuotesByCategoryPageState();
}

class _QuotesByCategoryPageState extends State<QuotesByCategoryPage> {
  // 朝代数组
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

  // 随机数生成器
  final Random _random = Random();

  // 存储两组数据
  List<dynamic>? group1;
  List<dynamic>? group2;

  // 数据获取处理函数（页面加载时调用）
  void _handleDataFetch(BuildContext context) async {
    try {
      // 1. 随机获取四个朝代
      List<String> selectedDynasties = _getRandomItems(dynasties, 4);

      // 2. 获取8个随机作者数据
      List<AuthorModel> selectedAuthors =
          await Provider.of<AuthorViewModel>(context, listen: false)
              .fetchRandomAuthors(8);
      if (selectedAuthors.length < 8) {
        print('作者数量不足8个');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('作者数量不足8个')),
        );
        return;
      }

      // 3. 从collections.json中随机获取4组数据
      List<CollectionModel> allCollections =
          Provider.of<CollectionViewModel>(context, listen: false).collections;
      if (allCollections.length < 4) {
        print('收藏数量不足4个');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('收藏数量不足4个')),
        );
        return;
      }
      List<CollectionModel> selectedCollections =
          _getRandomItemsFromList(allCollections, 4);

      // 4. 将所有数据分为两组，每组包含2个朝代，4个作者，2个收藏
      List<dynamic> newGroup1 = [
        selectedDynasties[0],
        selectedDynasties[1],
        selectedAuthors[0],
        selectedAuthors[1],
        selectedAuthors[2],
        selectedAuthors[3],
        selectedCollections[0],
        selectedCollections[1],
      ];

      List<dynamic> newGroup2 = [
        selectedDynasties[2],
        selectedDynasties[3],
        selectedAuthors[4],
        selectedAuthors[5],
        selectedAuthors[6],
        selectedAuthors[7],
        selectedCollections[2],
        selectedCollections[3],
      ];

      // 5. 随机排序每组数据
      newGroup1.shuffle(_random);
      newGroup2.shuffle(_random);

      // 6. 更新状态以渲染数据
      setState(() {
        group1 = newGroup1;
        group2 = newGroup2;
      });

      // 7. 打印所有数据到控制台
      print('--- Group 1 ---');
      newGroup1.forEach((item) {
        if (item is String) {
          print('朝代: $item');
        } else if (item is AuthorModel) {
          print('作者: ${item.name} (ID: ${item.id})');
        } else if (item is CollectionModel) {
          print('收藏: ${item.title}');
        }
      });

      print('--- Group 2 ---');
      newGroup2.forEach((item) {
        if (item is String) {
          print('朝代: $item');
        } else if (item is AuthorModel) {
          print('作者: ${item.name} (ID: ${item.id})');
        } else if (item is CollectionModel) {
          print('收藏: ${item.title}');
        }
      });
    } catch (e) {
      print('数据获取过程中出现错误: $e');
    }
  }

  // 从列表中随机获取指定数量的字符串
  List<String> _getRandomItems(List<String> list, int count) {
    List<String> tempList = List.from(list);
    tempList.shuffle(_random);
    return tempList.take(count).toList();
  }

  // 从列表中随机获取指定数量的对象
  List<T> _getRandomItemsFromList<T>(List<T> list, int count) {
    List<T> tempList = List.from(list);
    tempList.shuffle(_random);
    return tempList.take(count).toList();
  }

  @override
  Widget build(BuildContext context) {
    // 获取屏幕的高度，并减去底部导航栏的高度
    final availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom;
    final topSectionHeight = availableHeight * 0.3; // 上半部分占30%
    final bottomSectionHeight = availableHeight * 0.7; // 下半部分占70%

    // 下部分的圆角矩形框高度
    final bottomContainerHeight = bottomSectionHeight * 0.8;

    // 每个部分的高度应为圆角矩形框高度的五分之一
    final sectionHeight = bottomContainerHeight / 5;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthorViewModel()..fetchAuthors(),
        ),
        ChangeNotifierProvider(
          create: (context) => CollectionViewModel()..fetchCollections(),
        ),
      ],
      builder: (context, child) {
        return Scaffold(
          body: Column(
            children: [
              // 上半部分占30%，显示两个横向滚动的列表
              Container(
                height: topSectionHeight,
                width: double.infinity,
                color: Colors.transparent, // 保留30%的高度留空
                child: group1 != null && group2 != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 第一个横向滚动列表（Group 1）
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: group1!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: CategoryItemWidget(
                                      item: group1![index],
                                      height: topSectionHeight * 0.8 / 3),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 8.0),
                          // 第二个横向滚动列表（Group 2）
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: group2!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: CategoryItemWidget(
                                      item: group2![index],
                                      height: topSectionHeight * 0.8 / 3),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
              // 下半部分占70%，放置圆角矩形框
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9, // 宽度占90%
                    height: bottomContainerHeight, // 高度占下部分的85%
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
                          // 每个部分的高度均为圆角矩形高度的五分之一
                          Expanded(
                            child: CategorySection(
                              title: "朝代",
                              items: dynasties, // 使用定义的朝代数组
                              sectionHeight: sectionHeight, // 自动高度
                            ),
                          ),
                          Expanded(
                            child: AuthorSection(
                              sectionHeight: sectionHeight, // 传入计算的高度
                            ),
                          ),
                          Expanded(
                            child: CollectionSection(
                              sectionHeight: sectionHeight, // 传入计算的高度
                            ),
                          ),
                          Expanded(
                            child: WenTiSection(
                              sectionHeight: sectionHeight, // 传入计算的高度
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // 添加一个透明的子组件，用于在MultiProvider下执行数据获取
              DataFetchWidget(
                onDataFetched: _handleDataFetch,
              ),
            ],
          ),
        );
      },
    );
  }
}

// 新增的子组件，用于在MultiProvider内部执行数据获取
class DataFetchWidget extends StatefulWidget {
  final Function(BuildContext) onDataFetched;

  DataFetchWidget({required this.onDataFetched});

  @override
  _DataFetchWidgetState createState() => _DataFetchWidgetState();
}

class _DataFetchWidgetState extends State<DataFetchWidget> {
  bool _isFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isFetched) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onDataFetched(context);
      });
      _isFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink(); // 不占用任何空间
  }
}

// 定义一个新的 Widget 来展示每个分类项
class CategoryItemWidget extends StatelessWidget {
  final dynamic item;
  final double height;

  CategoryItemWidget({required this.item, required this.height});

  @override
  Widget build(BuildContext context) {
    String displayText = '';
    Color bgColor = Colors.blueAccent; // 默认颜色

    if (item is String) {
      // 朝代
      displayText = item;
      bgColor = Colors.orangeAccent;
    } else if (item is AuthorModel) {
      // 作者
      displayText = item.name;
      bgColor = Colors.greenAccent;
    } else if (item is CollectionModel) {
      // 作品集
      displayText = item.title;
      bgColor = Colors.purpleAccent;
    }

    return Container(
      width: height * 1.5, // 宽度可以根据需求调整，这里设为高度的1.5倍
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.0), // 圆角
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
          displayText,
          textAlign: TextAlign.center,
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
    );
  }
}

// 每个部分的分类组件保持不变
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

// 作者部分组件保持不变
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

// 文集部分组件保持不变
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

// 文体部分组件保持不变
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
