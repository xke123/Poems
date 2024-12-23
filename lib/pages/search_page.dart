// lib/pages/search_page.dart

import 'package:flutter/material.dart';
import '../services/search_service.dart';
import 'search/authorResult.dart';
import '../models/search/author.dart';
import '../models/poemdetailmodel.dart';
import '../pages/search/pemResult.dart';
import '../pages/search/collectionResult.dart';
import '../pages/search/poemLineResult.dart';
import '../pages/search/authorResult.dart';
import '../pages/search/globalResult.dart';
import '../models/search/GlobalSearchResult.dart';
import '../models/search/SentenceData.dart';
import '../pages/search/sentenceResult.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isSearchBoxTapped = false;

  FocusNode _focusNode = FocusNode();
  TextEditingController _searchController = TextEditingController();

  // 朝代列表
  final List<String> dynasties = [
    '无',
    '商',
    '周',
    '秦',
    '汉',
    '三国',
    '晋',
    '南北朝',
    '隋',
    '唐',
    '五代十国',
    '辽',
    '宋',
    '金',
    '元',
    '明',
    '清',
    '现代',
  ];

  // 选项列表
  final List<String> searchOptions = ['无', '作者', '作品名', '诗句', '作品集', '名句'];

  // 选中的朝代和选项
  String selectedDynasty = '汉'; // 默认选中“汉”
  String selectedOption = '作品名'; // 默认选中“作品名”

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchBoxTapped() {
    setState(() {
      _isSearchBoxTapped = true;
    });
    _focusNode.requestFocus();
  }

  // 搜索方法
  void _performSearch() async {
    String query = _searchController.text.trim();
    if (query.isEmpty) {
      // 显示提示信息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请输入搜索内容')),
      );
      return;
    }
    print('搜索内容: $query');
    print('选中的朝代: $selectedDynasty');
    print('选中的选项: $selectedOption');

    try {
      // 调用搜索服务
      List<dynamic> results = await SearchService.search(
        query: query,
        dynasty: selectedDynasty,
        option: selectedOption,
        limit: 30,
        offset: 0,
      );

      // 输出搜索结果数量
      print('搜索结果数量: ${results.length}');

      // 根据搜索选项跳转到不同的结果页面
      if (selectedOption == '无') {
        List<GlobalSearchResult> globalResults =
            results.cast<GlobalSearchResult>();
        // 跳转到 GlobalResultPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GlobalResultPage(
              searchQuery: query,
              dynasty: selectedDynasty,
              results: globalResults,
            ),
          ),
        );
      } else if (selectedOption == '作者') {
        // 跳转到 AuthorResultPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AuthorResultPage(
              searchQuery: query,
              dynasty: selectedDynasty,
              // authorResults: results
              //     .where((result) =>
              //         result is AuthorPoemModel && result.authorId != null)
              //     .toList()
              //     .cast<AuthorPoemModel>(),
              // poemResults: results
              //     .where((result) =>
              //         result is AuthorPoemModel && result.poemId != null)
              //     .toList()
              //     .cast<AuthorPoemModel>(),
            ),
          ),
        );
      } else if (selectedOption == '作品名') {
        // 跳转到 PoemResultPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PoemResultPage(
              searchQuery: query,
              dynasty: selectedDynasty,
            ),
          ),
        );
      } else if (selectedOption == '诗句') {
        // 跳转到 PoemLineResultPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PoemLineResultPage(
              searchQuery: query,
              dynasty: selectedDynasty,
            ),
          ),
        );
      } else if (selectedOption == '作品集') {
        // 跳转到 CollectionResultPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CollectionResultPage(
              searchQuery: query,
              dynasty: selectedDynasty,
            ),
          ),
        );
      } else if (selectedOption == '名句') {
        // 跳转到 SentenceResultPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SentenceResultPage(
              searchQuery: query,
              dynasty: selectedDynasty,
            ),
          ),
        );
      }
    } catch (e) {
      print('搜索出现错误: $e');
      // 显示错误提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('搜索出现错误: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Center(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: _isSearchBoxTapped
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width * 0.9,
            height: _isSearchBoxTapped
                ? MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom
                : (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom) *
                    0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_isSearchBoxTapped ? 0 : 20),
              // border: Border.all(color: Colors.grey, width: 1), // 添加边框
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // 阴影位置
                ),
              ],
            ),
            alignment:
                _isSearchBoxTapped ? Alignment.topCenter : Alignment.center,
            padding: EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 搜索框
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: _onSearchBoxTapped,
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        readOnly: !_isSearchBoxTapped,
                        decoration: InputDecoration(
                          hintText: '请输入搜索内容',
                          // 将搜索图标放在右侧
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: _performSearch,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onTap: _onSearchBoxTapped,
                        onSubmitted: (_) => _performSearch(),
                      ),
                    ),
                  ),
                  if (_isSearchBoxTapped) ...[
                    // 第一行：朝代选择
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9, // 占页面90%
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: dynasties.map((dynasty) {
                            bool isSelected = selectedDynasty == dynasty;
                            int index = dynasties.indexOf(dynasty);

                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedDynasty = dynasty;
                                    });
                                  },
                                  child: Text(
                                    dynasty,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.black,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (index != dynasties.length - 1)
                                  VerticalDivider(
                                    color: Colors.grey,
                                    thickness: 1,
                                    width: 20,
                                    indent: 5,
                                    endIndent: 5,
                                  ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    // 第二行：选项选择
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8, // 占页面80%
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: searchOptions.map((option) {
                            bool isSelected = selectedOption == option;
                            int index = searchOptions.indexOf(option);

                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedOption = option;
                                    });
                                  },
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.black,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (index != searchOptions.length - 1)
                                  VerticalDivider(
                                    color: Colors.grey,
                                    thickness: 1,
                                    width: 20,
                                    indent: 5,
                                    endIndent: 5,
                                  ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
