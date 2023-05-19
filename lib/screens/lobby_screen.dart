import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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
];

class LobbyScreen extends StatefulWidget {
  final String uid;
  const LobbyScreen({super.key, required this.uid});

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
                  fontSize: 30,
                  color: Color.fromARGB(255, 10, 68, 12),
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.person),
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
                                      builder: (_) => const SearchScreen()));
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
                          pagination: const SwiperPagination(
                              alignment: Alignment.bottomRight),
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
                    // TODO: 이름 넣어줭
                    const Text(
                      ' 000 님을 위한 추천 등산로',
                      style: TextStyle(
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
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color.fromARGB(255, 10, 68, 12),
                          style: BorderStyle.solid,
                          width: 1,
                        ),
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
                            _selections[index] = !_selections[index];
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
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Stream<List<MountainsModel>> streamMountains() {
    try {
      // 원하는 컬렉션의 스냅샷 가져오기
      Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance
          .collection('mountains')
          .orderBy('mntnName')
          .snapshots();

      // 스냅샷내부의 자료들을 List로 반환
      return snapshots.map((snapshot) {
        List<MountainsModel> mountains = [];
        for (var temp in snapshot.docs) {
          mountains.add(MountainsModel.fromMap(
              id: temp.id, map: temp.data() as Map<String, dynamic>));
        }
        return mountains;
      });
    } catch (ex) {
      log('error!');
      return Stream.error(ex.toString());
    }
  }
}
