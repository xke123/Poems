import 'package:flutter/material.dart';
import '../../models/poemdetailmodel.dart';

class PoemDetailPage extends StatelessWidget {
  final PoemDetailModel poemDetail; // 接收PoemDetailModel数据

  PoemDetailPage({required this.poemDetail});

  // 创建通用的圆角白色容器，添加宽度限制为页面宽度的90%
  Widget buildField(BuildContext context, String title, String content) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9, // 宽度为页面的90%
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // 检查字段是否为null或空字符串
  bool isValidField(String? field) {
    return field != null && field.isNotEmpty && field != 'None';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(poemDetail.title), // 使用诗词标题作为标题
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 作者和朝代
            buildField(
                context, '作者', '${poemDetail.author} (${poemDetail.dynasty})'),

            // 诗词内容
            if (isValidField(poemDetail.content))
              buildField(context, '内容', poemDetail.content),

            // 注释
            if (isValidField(poemDetail.annotation))
              buildField(context, '注释', poemDetail.annotation!),

            // 译文
            if (isValidField(poemDetail.translation))
              buildField(context, '译文', poemDetail.translation!),

            // 简介
            if (isValidField(poemDetail.intro))
              buildField(context, '简介', poemDetail.intro!),

            // 评论
            if (isValidField(poemDetail.comment))
              buildField(context, '评论', poemDetail.comment!),
          ],
        ),
      ),
    );
  }
}
