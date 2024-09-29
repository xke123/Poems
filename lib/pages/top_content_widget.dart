import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/author_model.dart';
import '../models/author_viewmodel.dart';
import '../models/collections_model.dart';
import '../models/collections_viewmodel.dart';

class TopContentWidget extends StatefulWidget {
  final double topSectionHeight;
  final List<String> dynasties;

  TopContentWidget({
    required this.topSectionHeight,
    required this.dynasties,
  });

  @override
  _TopContentWidgetState createState() => _TopContentWidgetState();
}

class _TopContentWidgetState extends State<TopContentWidget> {
  // 随机数生成器
  final Random _random = Random();

  // 存储两组数据
  List<dynamic>? group1;
  List<dynamic>? group2;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _handleDataFetch(context);
  }

  // 数据获取处理函数
  void _handleDataFetch(BuildContext context) async {
    try {
      // 1. 随机获取四个朝代
      List<String> selectedDynasties = _getRandomItems(widget.dynasties, 4);

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
    return Container(
      height: widget.topSectionHeight,
      width: double.infinity,
      color: Colors.transparent,
      child: group1 != null && group2 != null
          ? Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: widget.topSectionHeight * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildTopContent(),
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildTopContent() {
    double contentHeight = widget.topSectionHeight * 0.7; // 内容区域的总高度
    double partHeight = contentHeight / 2; // 每个部分的高度
    double itemHeight = partHeight; // item 的高度为部分高度的80%
    double itemWidth = partHeight * 0.8; // 宽度等于高度

    return Column(
      children: [
        // 第一部分
        Container(
          height: partHeight,
          child: Center(
            child: Container(
              height: itemHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: group1!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10.0),
                    child: CategoryItemWidget(
                      item: group1![index],
                      height: itemHeight,
                      width: itemWidth,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        // 第二部分
        Container(
          height: partHeight,
          child: Center(
            child: Container(
              height: itemHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: group2!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10.0),
                    child: CategoryItemWidget(
                      item: group2![index],
                      height: itemHeight,
                      width: itemWidth,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 定义一个新的 Widget 来展示每个分类项
class CategoryItemWidget extends StatelessWidget {
  final dynamic item;
  final double height;
  final double width;

  CategoryItemWidget({
    required this.item,
    required this.height,
    required this.width,
  });

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
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.0), // 圆角
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 2,
            offset: Offset(3, 3),
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
