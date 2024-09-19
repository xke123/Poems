import 'package:flutter/material.dart';

class QuotesByCategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('分类'),
      ),
      body: Center(
        child: Text(
          '这是分类页',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
