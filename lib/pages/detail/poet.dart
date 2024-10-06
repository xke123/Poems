import 'package:flutter/material.dart';
import '../../models/poetdetail_model.dart';
import 'detail_widget.dart'; // 导入封装的 buildField 方法

class PoetDetailPage extends StatelessWidget {
  final PoetDetailModel poetDetail; // 接收PoetDetailModel数据

  PoetDetailPage({required this.poetDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(poetDetail.name), // 显示作者姓名作为标题
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // 移除外层 Padding，直接在这里设置
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 朝代
            buildField(context, '朝代', poetDetail.dynasty), // 调用 buildField 方法
            // SizedBox(height: 10),
            // 出生年份和去世年份
            if (poetDetail.birthYear != null && poetDetail.deathYear != null)
              buildField(
                context,
                '生卒年份',
                '${poetDetail.birthYear} - ${poetDetail.deathYear}',
              ),
            // SizedBox(height: 10),
            // 简介
            if (poetDetail.desc != null)
              buildField(context, '简介', poetDetail.desc!),
            // SizedBox(height: 20),
            // 图片（如果有）
            if (poetDetail.hasImage)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0), // 保持外边距
                width: MediaQuery.of(context).size.width * 0.9, // 宽度为页面的90%
                padding: const EdgeInsets.all(16.0), // 保持内部填充
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/${poetDetail.id}.jpg', // 根据作者ID加载图片
                    width: 200,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey,
                        child: Icon(
                          Icons.person,
                          size: 100,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
