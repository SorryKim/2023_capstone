import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import '../models/mountains_model.dart';

class BadgeScreen extends StatefulWidget {
  const BadgeScreen({super.key});

  @override
  State<BadgeScreen> createState() => _BadgeScreenState();
}

class _BadgeScreenState extends State<BadgeScreen> {
  //List<Mountain2> mountainList = [];
  @override
  Widget build(BuildContext context) {
    //addList();
    streamMountains();
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        // TODO :
        title: const Text(
          "명산 100 도전\n배지 (70/100)",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: StreamBuilder<List<MountainsModel>>(
          stream: streamMountains(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('ㅗㅗㅗㅗㅗㅗ'),
              );
            } else if (snapshot.hasData) {
              List<MountainsModel> mountainList = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  // TODO:
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(
                      value: 0.7,
                      color: Colors.redAccent,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: GridView.builder(
                      itemCount: mountainList.length,
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
                              Image.asset("images/mountain_gray.png"),
                              Container(
                                height: 25,
                                alignment: Alignment.center,
                                child: Text(
                                  mountainList.elementAt(index).mntnName,
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
                                '위도: ${mountainList.elementAt(index).latitude}\n경도: ${mountainList.elementAt(index).longitude}',
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
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

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //longitude = position.longitude;
    //latitude = position.latitude;
  }

  String swapImage(lot, lat) {
    // getLocation();
    // if (lot == longitude && lat == latitude) {
    //   return "image/mountain.png";
    // } else {
    //   return "image/mountain_gray.png";
    // }

    return "image/mountain_gray.png";
  }
}
