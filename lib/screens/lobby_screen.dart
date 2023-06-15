import 'dart:math';

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
  "images/deogyusan.png",
  "images/hallasan.png",
  "images/jirisan.png",
  "images/naejangsan.png",
  "images/namsan.png",
  "images/olleTrail.png",
  "images/seolarksan.png",
  "images/songnisan.png",
  "images/taebaeksan.png",
  "images/bukhansan.png"
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
  final List<bool> _selections = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: StreamBuilder(
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
                      fontSize: 19,
                      color: Colors.black,
                      fontFamily: 'ClimateCrisisKR'),
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
                    color: Colors.black45,
                    iconSize: 40,
                  )
                ],
              ),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.search,
                              color: Colors.black, size: 30),
                          const SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            flex: 1,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                fixedSize: const Size(400, 25),
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white,
                                elevation: 0.0,
                                side: const BorderSide(
                                  width: 2,
                                  color: Colors.black12,
                                ),
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
                                    fontFamily: 'SCDream4'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        color: Colors.white,
                        height: 200,
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
                        '${user!.displayName}님을 위한 추천 등산로',
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'SCDream4'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FutureBuilder(
                          future: recommendMountain(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<MountainsModel> recommendList =
                                  snapshot.data!;

                              var index =
                                  Random().nextInt(recommendList.length);

                              // 추천리스트가 비어있을 경우 첫번쨰 등산로 추천
                              var recommendedMountain = recommendList.isEmpty
                                  ? widget.mountains[0]
                                  : recommendList[index];

                              return Container(
                                height: 120,
                                width: 520,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black26,
                                    style: BorderStyle.solid,
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          "images/dew.png",
                                          width: 120,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      Text(
                                        '\n✔   ${recommendedMountain.mntnName}\n\n높이:  ${recommendedMountain.height}m\n거리:  ${recommendedMountain.distance}m\n난이도: ${recommendedMountain.difficulty}\n',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'SCDream4'),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        '난이도별 등산로',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'SCDream4'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ToggleButtons(
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
                            selectedColor: Colors.white,
                            fillColor: const Color.fromARGB(255, 10, 11, 70),
                            borderRadius: BorderRadius.circular(10),
                            borderColor: Colors.black26,
                            selectedBorderColor: Colors.black87,
                            children: const [
                              Text('            상            ',
                                  style: TextStyle(
                                      fontFamily: 'SCDream4', fontSize: 16)),
                              Text('            중            ',
                                  style: TextStyle(
                                      fontFamily: 'SCDream4', fontSize: 16)),
                              Text('            하            ',
                                  style: TextStyle(
                                      fontFamily: 'SCDream4', fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                      Flexible(child: selectedList()),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
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
        controller: ScrollController(),
        shrinkWrap: true,
        itemCount: result.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(8.0),
              title: Text(
                result[index].mntnName,
                style: const TextStyle(fontSize: 16, fontFamily: 'SCDream4'),
              ),
              subtitle: Text(
                  "${result[index].timeTaken}시간 소요 / ${result[index].distance}m",
                  style: const TextStyle(fontFamily: 'SCDream4', fontSize: 15)),
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

  // 등산로 추천 기능
  Future<List<MountainsModel>> recommendMountain() async {
    // 추천할 등산로 리스트
    List<MountainsModel> resultList = [];

    // 사용자의 설문조사 결과를 파이어베이스에서 가져 옴
    var data = await FirebaseFirestore.instance
        .collection('user/${widget.uid}/survey/')
        .get();
    List<dynamic> surveyList = data.docs.toList();
    String path = surveyList[0].id;
    var result = await FirebaseFirestore.instance
        .collection('user/${widget.uid}/survey/')
        .doc(path)
        .get();

    print(result.data()!['distance']);

    // 추천에 쓰일 변수들
    List<String> distance = result.data()!['distance'].split('~');
    List<String> height = result.data()!['height'].split('~');
    List<String> time = result.data()!['time'].split('~');
    int minDis = 0;
    int maxDis = 0;
    int minHeight = 0;
    int maxHeight = 0;
    double minTime = 0;
    double maxTime = 0;

    minDis = int.parse(distance[0][0]);
    if (distance[1].isNotEmpty) maxDis = int.parse(distance[1][0]);
    minHeight = int.parse(height[0][0]);
    if (height[1].isNotEmpty) maxHeight = int.parse(height[1][0]);
    minTime = double.parse(time[0][0]);
    if (time[1].isNotEmpty) maxTime = double.parse(time[1][0]);

    for (var temp in widget.mountains) {
      int nowDis = temp.distance;
      int nowHeight = temp.height;
      var nowTime = temp.timeTaken;

      // 조건에 맞을 경우 결과 리스트에 push
      if (maxDis >= nowDis) resultList.add(temp);

      if (minDis <= nowDis) resultList.add(temp);

      if (maxHeight >= nowHeight) resultList.add(temp);

      if (minHeight <= nowHeight) resultList.add(temp);

      if (maxTime >= nowTime) resultList.add(temp);

      if (minTime <= nowTime) resultList.add(temp);
    }

    return resultList;
  }
}
