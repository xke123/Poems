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
      // appBar: AppBar(
      //   title: Text('名句展示'),
      //   centerTitle: true,
      // ),
      body: FutureBuilder<QuoteModel>(
        future: _quote,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('加载失败，请重试！'));
          } else if (snapshot.hasData) {
            return QuoteCard(
              quote: snapshot.data!,
              onRefresh: _refreshQuote, // 传递刷新回调
            );
          } else {
            return Center(child: Text('没有找到数据'));
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _refreshQuote,
      //   child: Icon(Icons.refresh),
      //   tooltip: '刷新',
      // ),
    );
  }
}
