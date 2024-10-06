import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/author_viewmodel.dart';
import '../models/collections_viewmodel.dart';
import '../widgets/author_section_pagination.dart';
import '../widgets/collection_section_pagination.dart';
import 'package:poems/services/db_service.dart'; // 导入数据库服务
import '../models/dynastydetailmodel.dart';
import '../pages/detail/dynasty.dart';

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
    final sectionHeight = bottomContainerHeight / 4;

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
              // 作者部分（使用分页组件）
              Expanded(
                child: AuthorSectionPagination(
                  sectionHeight: sectionHeight,
                ),
              ),
              // 作品集部分（使用分页组件）
              Expanded(
                child: CollectionSectionPagination(
                  sectionHeight: sectionHeight,
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

// 朝代部分组件保持不变
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
    final contentHeight = sectionHeight * 0.7; // 内容占80%高度

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
              final String dynasty = items[index]; // 当前朝代

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: GestureDetector(
                  onTap: () async {
                    int page = 1;
                    int pageSize = 30;

                    // 获取分页数据
                    List<DynastyDetailModel> dynastyDetails =
                        await DbService.getDynastyData(dynasty, page, pageSize);

                    // 跳转到 DynastyDetailPage 并传递数据
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DynastyDetailPage(
                          dynasty: dynasty,
                          dynastyDetails: dynastyDetails,
                        ),
                      ),
                    );

                    // 下一页数据
                    page++;
                  },
                  child: Container(
                    width: contentHeight * 0.8, // 高度和宽度一致，保持正方形
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/image/dynasty_icon.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
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
                        dynasty,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class WenTiSection extends StatelessWidget {
  final List<String> wenTiItems = ['诗', '词', '曲', '赋', '文'];
  final double sectionHeight;

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
          height: contentHeight * 0.9,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: wenTiItems.length,
            itemBuilder: (context, index) {
              final String wenTi = wenTiItems[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Container(
                  width: contentHeight * 0.55, // 宽度设为内容高度的70%
                  decoration: BoxDecoration(
                    color: Colors.white, // 白色背景
                    borderRadius: BorderRadius.circular(16.0), // 圆角矩形
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        spreadRadius: 2,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: _buildWenTiImages(wenTi), // 根据文体类型生成图片
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildWenTiImages(String wenTi) {
    List<Widget> images = [];

    switch (wenTi) {
      case '诗':
        images.addAll([
          Positioned(
            top: 1,
            left: 1,
            child: Image.asset(
              'assets/image/yan.png',
              width: 30,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: 1,
            right: 1,
            child: Image.asset(
              'assets/image/shi.png',
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
        ]);
        break;
      case '词':
        images.addAll([
          Positioned(
            top: 1,
            left: 1,
            child: Image.asset(
              'assets/image/yan.png',
              width: 30,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: 1,
            right: 1,
            child: Image.asset(
              'assets/image/si.png',
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
        ]);
        break;
      case '文':
        images.add(
          Center(
            child: Image.asset(
              'assets/image/wen.png',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
        );
        break;
      case '赋':
        images.addAll([
          Positioned(
            top: 1,
            left: 1,
            child: Image.asset(
              'assets/image/bei.png',
              width: 30,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: 1,
            right: 1,
            child: Image.asset(
              'assets/image/wu.png',
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
        ]);
        break;
      case '曲':
        images.add(
          Center(
            child: Image.asset(
              'assets/image/qu.png',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
        );
        break;
      default:
        break;
    }

    return images;
  }
}
