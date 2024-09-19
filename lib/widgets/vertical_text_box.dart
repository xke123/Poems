// widgets/vertical_text_box.dart
import 'package:flutter/material.dart';
import '../models/sentence_model.dart';

class VerticalTextBox extends StatelessWidget {
  final Sentence sentence;

  VerticalTextBox({@required this.sentence});

  // 将字符串拆分为单个字符的列表
  List<String> _splitToChars(String text) {
    return text.split('');
  }

  // 创建垂直排列的文字组件
  Widget _buildVerticalText(String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _splitToChars(text).map((char) {
        return Text(
          char,
          style: TextStyle(fontSize: 16.0),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    double boxWidth = MediaQuery.of(context).size.width * 0.8;
    double boxHeight = MediaQuery.of(context).size.height * 0.618;

    return Container(
      width: boxWidth,
      height: boxHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          // poetName 占用 15%
          Container(
            width: boxWidth * 0.15,
            alignment: Alignment.center,
            child: _buildVerticalText(sentence.poetName),
          ),
          // content 占用 70%
          Container(
            width: boxWidth * 0.7,
            alignment: Alignment.center,
            child: _buildVerticalText(sentence.content),
          ),
          // poetryName 占用 15%
          Container(
            width: boxWidth * 0.15,
            alignment: Alignment.center,
            child: _buildVerticalText(sentence.poetryName),
          ),
        ],
      ),
    );
  }
}
