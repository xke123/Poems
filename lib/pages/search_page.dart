// lib/pages/search_page.dart

import 'package:flutter/material.dart';

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
  final List<String> searchOptions = ['无', '作者', '作品', '作品集'];

  // 选中的朝代和选项
  String selectedDynasty = '唐'; // 默认选中“唐”
  String selectedOption = '作品'; // 默认选中“作品”

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
  void _performSearch() {
    String query = _searchController.text.trim();
    print('搜索内容: $query');
    print('选中的朝代: $selectedDynasty');
    print('选中的选项: $selectedOption');

    // 这里可以调用搜索服务执行实际的搜索逻辑
    // 例如：
    // SearchService.search(query, selectedDynasty, selectedOption);
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
                    0.9,
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