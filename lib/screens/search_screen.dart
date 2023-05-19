import 'package:flutter/material.dart';
import 'package:project/models/mountain_model.dart';

import '../src/api_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String strResult = '';

  List<Item> itemList = [];

  final TextEditingController _tecStrSearchQuery = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        _getItemList();
      }
      if (_scrollController.offset <=
              _scrollController.position.minScrollExtent &&
          !_scrollController.position.outOfRange) {
        _getItemList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //색변경
        ),
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Icon(
              Icons.search,
              color: Colors.black,
            ),
            const SizedBox(
              width: 8,
            ),
            const Flexible(
              flex: 1,
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  hintText: '입력해주세요',
                ),
              ),
            ),
            const SizedBox(
              width: 2,
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                '검색',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        elevation: 0.0,
      ),
      body: const Center(
        child: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            Icon(
              Icons.search,
              size: 100,
              color: Colors.black38,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '검색 키워드를 입력해주세요',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
      /* Container(
        child: itemList.isEmpty
            ? const Text("")
            : ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 80,
                        minWidth: 80,
                      ),
                    ),
                    title: Text(itemList[index].frtrlNm.toString()),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(itemList[index].lot.toString()),
                        Text(itemList[index].aslAltide.toString()),
                        Text(itemList[index].lat.toString()),
                      ],
                    ),
                  );
                },
                separatorBuilder: ((context, index) {
                  return const Divider(height: 1, color: Colors.white);
                }),
                itemCount: itemList.length,
                controller: _scrollController,
              ),
      ),
      */
    );
  }

  void _getItemList() async {
    String tempName = _tecStrSearchQuery.value.text;
    if (tempName.isEmpty) {
      Item goal = await ApiService.getItem("감악산", "보리암과 돌탑");
      itemList.add(goal);
      goal = await ApiService.getItem("관악산", "연주대");
      itemList.add(goal);
    } else {
      Item goal = await ApiService.getItem(tempName, "보리암과 돌탑");

      itemList.add(goal);
    }
  }
}
