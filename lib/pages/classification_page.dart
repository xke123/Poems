import 'package:flutter/material.dart';

import '../services/db_service.dart';
import 'quotes_by_category_page.dart';

class ClassificationPage extends StatefulWidget {
  @override
  _ClassificationPageState createState() => _ClassificationPageState();
}

class _ClassificationPageState extends State<ClassificationPage> {
  Future<List<String>> _categories;

  @override
  void initState() {
    super.initState();
    _categories = DBService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _categories,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: snapshot.data.map((category) {
              return ListTile(
                title: Text(category),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuotesByCategoryPage(category: category),
                    ),
                  );
                },
              );
            }).toList(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('加载失败'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
