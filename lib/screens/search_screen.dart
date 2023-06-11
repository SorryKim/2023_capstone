import 'package:flutter/material.dart';
import 'package:project/models/mountains_model.dart';

class SearchScreen extends StatefulWidget {
  final List<MountainsModel> mountains;
  const SearchScreen({super.key, required this.mountains});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String strResult = '';

  final TextEditingController _tecStrSearchQuery = TextEditingController();
  final ScrollController _scrollController = ScrollController();

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
            Flexible(
              flex: 1,
              child: TextField(
                controller: _tecStrSearchQuery,
                decoration: const InputDecoration(
                  // 사용자가 선택했을 경우
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 10, 11, 70),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),

                  // 사용가능한 경우
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 10, 11, 70),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  hintText: '산이름을 입력해주세요',
                ),
              ),
            ),
            const SizedBox(
              width: 2,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  strResult = _tecStrSearchQuery.text;
                });
              },
              child: const Text(
                '검색',
                style: TextStyle(
                    color: Colors.black, fontFamily: 'SCDream4', fontSize: 17),
              ),
            ),
          ],
        ),
        elevation: 0.0,
      ),
      body: searchWidget(),
    );
  }

  Widget searchWidget() {
    if (strResult.isEmpty) {
      return const Center(
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
                  fontSize: 20, color: Colors.black54, fontFamily: 'SCDream4'),
            ),
          ],
        ),
      );
    } else {
      List<MountainsModel> searchResult = [];
      var target = RegExp(strResult);
      for (var temp in widget.mountains) {
        if (strResult == temp.mntnName) {
          searchResult.add(temp);
        }
      }

      return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset(
              "images/seolarksan.png",
              height: 100,
              width: 100,
            ),
            title: Text(searchResult[index].mntnName.toString(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(searchResult[index].info.toString(),
                    style: const TextStyle(fontSize: 16)),
                Text("등산 난이도 : ${searchResult[index].difficulty}",
                    style:
                        const TextStyle(fontSize: 16, color: Colors.redAccent)),
              ],
            ),
          );
        },
        separatorBuilder: ((context, index) {
          return const Divider(height: 1, color: Colors.black);
        }),
        itemCount: searchResult.length,
        controller: _scrollController,
      );
    }
  }
}
