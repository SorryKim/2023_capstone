import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import '../models/mountains_model.dart';

class BadgeScreen extends StatefulWidget {
  List<MountainsModel> mountains;
  String uid;
  BadgeScreen({super.key, required this.mountains, required this.uid});

  @override
  State<BadgeScreen> createState() => _BadgeScreenState();
}

class _BadgeScreenState extends State<BadgeScreen> {
  @override
  Widget build(BuildContext context) {
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
      ),
      body: FutureBuilder(
          future: checkMountainList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Map<String, dynamic>> checkList = snapshot.data!;
              //print(checkList);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: LinearProgressIndicator(
                      value: 0.7,
                      color: Colors.greenAccent, //<-- SEE HERE
                      backgroundColor: Colors.grey, //<-- SEE HERE
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _onPressedSendButton,
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.lightGreen),
                        child: const Text('뱃지 갱신!'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Expanded(
                    child: GridView.builder(
                      itemCount: checkList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 0.65,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          child: Column(
                            children: [
                              checkList.elementAt(index)['check']
                                  ? Image.asset("images/mountain.png")
                                  : Image.asset("images/mountain_gray.png"),
                              Container(
                                height: 25,
                                alignment: Alignment.center,
                                child: Text(
                                  checkList.elementAt(index)['mntnName'],
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            AlertDialog dialog = AlertDialog(
                              content: Text(
                                '${checkList.elementAt(index)['mntnName']} - ${checkList.elementAt(index)['info']}\n${checkList.elementAt(index)['reason']}',
                                style: const TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            );
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => dialog);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  void _onPressedSendButton() async {
    await checkPosition();
    setState(() {});
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

  // 현재 유저의 위치를 가져오는 메소드
  Future<Position> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
    //longitude = position.longitude;
    //latitude = position.latitude;
  }

  // 현재 위도 반환
  Future<int> getLat() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return (position.latitude * 100).toInt();
  }

  // 현재 경도 반환
  Future<int> getLot() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return (position.longitude * 100).toInt();
  }

  // String swapImage(Function() getLat, Function() getLot) {
  //   double myLat = getLat();
  //   double myLot = getLot();

  //   if (myLat == checkList.elementAt(index)['mntnName']) {
  //     return "image/mountain_gray.png";
  //   }
  // }

  Future<void> checkPosition() async {
    int nowLat = await getLat();
    int nowLot = await getLot();

    var data = await FirebaseFirestore.instance
        .collection('user/${widget.uid}/mountains')
        .get();
    List<dynamic> dataList = data.docs.toList();

    // 현재위치와 DB의 저장된 위도경도를 비교하고 해당하는 경우
    // check항목 true로 update
    for (var i = 0; i < dataList.length; i++) {
      double thisLat = dataList[i]['latitude'];
      double thisLot = dataList[i]['longitude'];

      if (nowLat == (thisLat * 100).toInt() &&
          nowLot == (thisLot * 100).toInt()) {
        await FirebaseFirestore.instance
            .doc('user/${widget.uid}/mountains/${data.docs[i].reference.id}')
            .update({
          'check': true,
        });
      }
    }
  }

  // 현재 유저의 등산업적목록을 가져오는 메소드,
  // 업적목록이 없는 경우 새로 생성
  Future<List<Map<String, dynamic>>> checkMountainList() async {
    var data = await FirebaseFirestore.instance
        .collection('user/${widget.uid}/mountains')
        .get();

    List<dynamic> dataList = data.docs.toList();
    // mountains가 없을 경우
    if (dataList.isEmpty) {
      for (var temp in widget.mountains) {
        await FirebaseFirestore.instance
            .collection('user/${widget.uid}/mountains')
            .add({
          'difficulty': temp.difficulty,
          'mntnName': temp.mntnName,
          'info': temp.info,
          'reason': temp.reason,
          'timeTaken': temp.timeTaken,
          'distance': temp.distance,
          'height': temp.height,
          'latitude': temp.latitude,
          'longitude': temp.longitude,
          'check': false,
        });
      }
    }

    // mountains가 있는 경우
    List<Map<String, dynamic>> result = [];
    for (var temp in dataList) {
      result.add({
        'difficulty': temp['difficulty'],
        'mntnName': temp['mntnName'],
        'info': temp['info'],
        'reason': temp['reason'],
        'timeTaken': temp['timeTaken'],
        'distance': temp['distance'],
        'height': temp['height'],
        'latitude': temp['latitude'],
        'longitude': temp['longitude'],
        'check': temp['check'],
      });
    }

    return result;
  }
}
