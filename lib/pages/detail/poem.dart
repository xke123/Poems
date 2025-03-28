import 'package:flutter/material.dart';
import '../../models/poemdetailmodel.dart';
import '../../services/db_service.dart';
import 'detail_widget.dart';

class PoemDetailPage extends StatefulWidget {
  final String id;

  const PoemDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _PoemDetailPageState createState() => _PoemDetailPageState();
}

class _PoemDetailPageState extends State<PoemDetailPage> {
  PoemDetailModel? _poemDetail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPoem();
  }

  Future<void> _loadPoem() async {
    try {
      final data = await DbService.getQuoteById(widget.id);
      setState(() {
        _poemDetail = data;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败，请返回重试')),
        );
        Navigator.pop(context);
      }
    }
  }

  bool isValidField(String? field) {
    return field != null && field.isNotEmpty && field != 'None';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_poemDetail?.title ?? '加载中...'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildField(
                    context,
                    '作者',
                    '${_poemDetail!.author} (${_poemDetail!.dynasty})',
                  ),
                  if (isValidField(_poemDetail!.content))
                    buildField(context, '内容', _poemDetail!.content),
                  if (isValidField(_poemDetail!.annotation))
                    buildField(context, '注释', _poemDetail!.annotation!),
                  if (isValidField(_poemDetail!.translation))
                    buildField(context, '译文', _poemDetail!.translation!),
                  if (isValidField(_poemDetail!.intro))
                    buildField(context, '简介', _poemDetail!.intro!),
                  if (isValidField(_poemDetail!.comment))
                    buildField(context, '评论', _poemDetail!.comment!),
                ],
              ),
            ),
    );
  }
}
