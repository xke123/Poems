import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // 确保导入了scheduler包
import 'package:provider/provider.dart';
import '../models/author_model.dart';
import '../models/author_viewmodel.dart';
import '../models/collections_model.dart';
import '../models/collections_viewmodel.dart';

// 定义滚动方向枚举
enum ScrollDirection {
  left, // 从右向左滚动
  right, // 从左向右滚动
}

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
  final Random _random = Random();

  List<dynamic>? group1;
  List<dynamic>? group2;

  bool _isDataFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataFetched) {
      _handleDataFetch(context);
      _isDataFetched = true;
    }
  }

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

      // 6. 为了实现无缝滚动，重复数据
      List<dynamic> loopGroup1 = [...newGroup1, ...newGroup1];
      List<dynamic> loopGroup2 = [...newGroup2, ...newGroup2];

      setState(() {
        group1 = loopGroup1;
        group2 = loopGroup2;
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
    double itemHeight = partHeight; // item 的高度为部分高度
    double itemWidth = partHeight * 0.8; // 宽度等于高度的0.8倍

    return Column(
      children: [
        // 第一部分 - 从右向左滚动
        Container(
          height: partHeight,
          child: AutoScrollWidget(
            items: group1!,
            itemHeight: itemHeight,
            itemWidth: itemWidth,
            itemsPerCopy: group1!.length ~/ 2, // 原始组的长度
            scrollDirection: ScrollDirection.left, // 设置滚动方向
          ),
        ),
        // 第二部分 - 从左向右滚动
        Container(
          height: partHeight,
          child: AutoScrollWidget(
            items: group2!,
            itemHeight: itemHeight,
            itemWidth: itemWidth,
            itemsPerCopy: group2!.length ~/ 2, // 原始组的长度
            scrollDirection: ScrollDirection.right, // 设置滚动方向
          ),
        ),
      ],
    );
  }
}

// 自定义的自动滚动组件
class AutoScrollWidget extends StatefulWidget {
  final List<dynamic> items;
  final double itemHeight;
  final double itemWidth;
  final double paddingHorizontal;
  final double paddingVertical;
  final int itemsPerCopy;
  final ScrollDirection scrollDirection; // 新增的滚动方向参数

  AutoScrollWidget({
    required this.items,
    required this.itemHeight,
    required this.itemWidth,
    this.paddingHorizontal = 8.0,
    this.paddingVertical = 10.0,
    required this.itemsPerCopy,
    required this.scrollDirection, // 接收滚动方向
  });

  @override
  _AutoScrollWidgetState createState() => _AutoScrollWidgetState();
}

class _AutoScrollWidgetState extends State<AutoScrollWidget>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late Ticker _ticker;
  double _scrollSpeed = 10.0; // 每秒滚动像素数
  double _copyWidth = 0.0;
  double _currentScroll = 0.0;
  double _lastTick = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateCopyWidth();
      _startScrolling();
    });
  }

  void _calculateCopyWidth() {
    // 计算一组数据的总宽度
    // 每个item的宽度加上左右的padding
    _copyWidth =
        widget.itemsPerCopy * (widget.itemWidth + 2 * widget.paddingHorizontal);
    // 根据滚动方向设置初始滚动位置
    if (widget.scrollDirection == ScrollDirection.right) {
      _currentScroll = _copyWidth;
      _scrollController.jumpTo(_currentScroll);
    } else {
      _currentScroll = 0.0;
      _scrollController.jumpTo(_currentScroll);
    }
  }

  void _startScrolling() {
    _ticker = this.createTicker((Duration elapsed) {
      double currentTick = elapsed.inMicroseconds / 1e6; // 转换为秒
      if (_lastTick == 0.0) {
        _lastTick = currentTick;
        return;
      }
      double deltaTime = currentTick - _lastTick;
      _lastTick = currentTick;

      double deltaPixels = _scrollSpeed * deltaTime;
      if (widget.scrollDirection == ScrollDirection.left) {
        _currentScroll += deltaPixels;
        if (_currentScroll >= _copyWidth) {
          // 重置到第一组数据的起始位置
          _currentScroll -= _copyWidth;
          _scrollController.jumpTo(_currentScroll);
        }
      } else {
        _currentScroll -= deltaPixels;
        if (_currentScroll <= 0.0) {
          // 重置到第二组数据的起始位置
          _currentScroll += _copyWidth;
          _scrollController.jumpTo(_currentScroll);
        }
      }

      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_currentScroll);
      }
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.stop();
    _ticker.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.items.isEmpty
        ? Container()
        : ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(), // 禁止手动滚动
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              var item = widget.items[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widget.paddingHorizontal,
                    vertical: widget.paddingVertical),
                child: CategoryItemWidget(
                  item: item,
                  height: widget.itemHeight,
                  width: widget.itemWidth,
                ),
              );
            },
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
    String? imagePath; // 图片路径

    // 判断 item 类型并处理
    if (item is String) {
      // 朝代
      displayText = item;
      bgColor = Colors.orangeAccent;
      imagePath = 'assets/image/dynasty_icon.png'; // 朝代图标路径
    } else if (item is AuthorModel) {
      // 作者
      displayText = item.name;
      bgColor = Colors.greenAccent;
      imagePath = 'assets/images/${item.id}.jpg'; // 根据 Id 获取图片路径
    } else if (item is CollectionModel) {
      // 作品集
      displayText = item.title;
      bgColor = const Color.fromARGB(255, 131, 132, 80);
    }

    // 处理作者的样式
    if (item is AuthorModel && imagePath != null) {
      return Material(
        color: Colors.transparent, // 透明背景以避免覆盖父背景
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {
            // 输出作者信息
            print('类型为: 作者');
            print('作者名: ${item.name}');
            print('作者id: ${item.id}');
          },
          child: Container(
            width: this.width,
            height: this.height,
            decoration: BoxDecoration(
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0), // 确保图片和内容有圆角效果
              child: Stack(
                children: [
                  // 背景图片
                  Positioned.fill(
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover, // 图片充满整个容器
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey, // 如果图片加载失败，显示灰色背景
                          child: Icon(
                            Icons.person,
                            size: this.height * 0.3,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                  // 作者名字显示在右下角圆角矩形内
                  Positioned(
                    bottom: 5, // 距离底部 5 像素
                    right: -6, // 距离右边 -6 像素
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0), // 适当的内边距
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6), // 半透明背景，提升可读性
                        borderRadius: BorderRadius.circular(12.0), // 圆角
                      ),
                      child: Text(
                        displayText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // 超出一行显示省略号
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // 处理朝代的样式，显示dynasty_icon.png，并调整文字大小为16
    if (item is String && imagePath != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {
            // 输出朝代信息
            print('类型为: 朝代');
            print('朝代名: $item');
          },
          child: Container(
            width: this.width,
            height: this.height,
            decoration: BoxDecoration(
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0), // 确保图片和内容有圆角效果
              child: Stack(
                children: [
                  // 背景图片填充整个圆角矩形
                  Positioned.fill(
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover, // 确保图片充满容器
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey, // 图片加载失败时的灰色背景
                          child: Icon(
                            Icons.image, // 显示默认图片图标
                            size: this.height * 0.3,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                  // 中心浮动的文字
                  Center(
                    child: Text(
                      displayText,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 240, 240, 240), // 白色字体
                        fontSize: 16, // 字体大小设为16
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 5,
                            color: Colors.black.withOpacity(0.5), // 阴影提升可读性
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // 超出一行显示省略号
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (item is CollectionModel) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {
            // 输出作品集信息
            print('类型为: 作品集');
            print('作品集名: ${item.title}');
            print('作品集id: ${item.id}');
          },
          child: Container(
            width: this.width,
            height: this.height,
            decoration: BoxDecoration(
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0), // 确保内容有圆角效果
              child: Stack(
                children: [
                  // 背景颜色
                  Positioned.fill(
                    child: Container(
                      color: Colors.grey[200], // 灰色背景用于作品集
                    ),
                  ),
                  // 竖排文字显示在一个白色矩形中，位于右上角
                  Positioned(
                    top: 6.0, // 调整文字顶部位置
                    right: 12.0, // 调整文字右侧位置
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.0, vertical: 2.0), // 内边距
                      decoration: BoxDecoration(
                        color: Colors.white, // 白色背景
                        borderRadius: BorderRadius.circular(0.0), // 圆角效果
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: Offset(0, 2), // 轻微阴影
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // 内容高度根据最小化排列
                        crossAxisAlignment: CrossAxisAlignment.center, // 文字居中对齐
                        children: displayText
                            .split('') // 将文字拆分成单个字符
                            .map((char) => Text(
                                  char,
                                  style: TextStyle(
                                    color: Colors.black, // 黑色字体
                                    fontSize: 14, // 字体大小可以调整
                                    fontWeight: FontWeight.normal,
                                    height: 1.0, // 设置最小行高，文字间距最小
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Collection 和 朝代的默认样式
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          // 默认的点击处理
          print('点击了未知类型的项');
        },
        child: Container(
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
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              displayText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // 超出一行显示省略号
            ),
          ),
        ),
      ),
    );
  }
}
