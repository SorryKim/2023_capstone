import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:project/models/mountains_model.dart';
import 'package:project/screens/information_screen.dart';
import 'package:project/screens/login_screen.dart';
import 'package:project/screens/search_screen.dart';

final List<String> imgList = [
  'images/6249016.jpg',
  'images/6229893.jpg',
  'images/bukhansan.jpg'
];

class LobbyScreen extends StatefulWidget {
  final String uid;
  final List<MountainsModel> mountains;
  const LobbyScreen({super.key, required this.uid, required this.mountains});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final user = FirebaseAuth.instance.currentUser;
  bool selected = false;
  final List<bool> _selections = List.generate(3, (_) => false);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoginScreen();
        } else {
          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                // Status bar color
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
              ),
              title: const Text(
                'MOUNTAINDEW',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0.0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.account_circle),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            InformationScreen(uid: widget.uid)));
                  },
                  color: const Color.fromARGB(255, 10, 68, 12),
                  iconSize: 40,
                )
              ],
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.search, color: Colors.black, size: 30),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          flex: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(400, 25),
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SearchScreen(
                                            mountains: widget.mountains,
                                          )));
                            },
                            child: const Text(
                              '등산로 검색 바로가기',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.white,
                      height: 250,
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: Swiper(
                          autoplay: true,
                          scale: 0.9,
                          viewportFraction: 0.8,
                          itemCount: imgList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Image.asset(
                              imgList[index],
                              fit: BoxFit.contain,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      '${user!.displayName} 님을 위한 추천 등산로',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 100,
                      width: 520,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color.fromARGB(255, 10, 68, 12),
                          style: BorderStyle.solid,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Text(
                            '산이름: ${widget.mountains[0].mntnName}\n거리: ${widget.mountains[0].latitude}\n경도: ${widget.mountains[0].longitude}\n'),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      '난이도별 등산로',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: ToggleButtons(
                        isSelected: _selections,
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < 3; i++) {
                              if (i == index) {
                                _selections[i] = true;
                              } else {
                                _selections[i] = false;
                              }
                            }
                            selected = true;
                          });
                        },
                        color: Colors.black54,
                        selectedColor: Colors.black,
                        fillColor: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        borderColor: const Color.fromARGB(255, 10, 68, 12),
                        selectedBorderColor:
                            const Color.fromARGB(255, 10, 68, 12),
                        children: const [
                          Text('상'),
                          Text('중'),
                          Text('하'),
                        ],
                      ),
                    ),
                    selected ? selectedList() : Container(),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  // 난이도별 등산로 List출력
  Widget selectedList() {
    String target;
    List<MountainsModel> result = [];

    _selections[0]
        ? target = '상'
        : (_selections[1] ? target = '중' : target = '하');

    for (var temp in widget.mountains) {
      if (temp.difficulty == target) {
        result.add(temp);
      }
    }
    return ListView.separated(
        itemCount: result.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(8.0),
              title: Text(
                result[index].mntnName,
                style: const TextStyle(fontSize: 16.5),
              ),
              subtitle: Text(result[index].difficulty),
              dense: true,
              leading: const Icon(
                Icons.filter_frames,
                color: Colors.black26,
              ),
              onTap: () {},
            ),
          );
        });
  }
}
