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
        backgroundColor: const Color.fromARGB(255, 10, 68, 12),
        elevation: 0,
        title: TextField(
          controller: _tecStrSearchQuery,
          keyboardType: TextInputType.text,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: "검색",
            labelStyle: TextStyle(color: Colors.white),
            hintText: "검색어를 입력하세요",
            hintStyle: TextStyle(color: Colors.white),
            prefixIcon: Icon(
              Icons.input,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Container(
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.file_download),
        onPressed: () {
          setState(() {
            _getItemList();
          });
        },
      ),
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
