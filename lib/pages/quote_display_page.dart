import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/quote_model.dart';
import '../widgets/quote_card.dart';

class QuoteDisplayPage extends StatefulWidget {
  @override
  _QuoteDisplayPageState createState() => _QuoteDisplayPageState();
}

class _QuoteDisplayPageState extends State<QuoteDisplayPage> {
  late Future<QuoteModel> _quote;

  @override
  void initState() {
    super.initState();
    _quote = DbService.getRandomSentence(); // 获取随机句子
  }

  // 刷新数据的函数
  void _refreshQuote() {
    setState(() {
      _quote = DbService.getRandomSentence(); // 重新获取随机句子
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('名句展示'),
      ),
      body: FutureBuilder<QuoteModel>(
        future: _quote,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 打印错误信息
            print('Error: ${snapshot.error}');
            return Center(child: Text('加载失败，请重试！'));
          } else if (snapshot.hasData) {
            return Stack(
              children: [
                QuoteCard(quote: snapshot.data!),
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: FloatingActionButton(
                    onPressed: _refreshQuote,  // 刷新按钮点击事件
                    child: Icon(Icons.refresh),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('没有找到数据'));
          }
        },
      ),
    );
  }
}
