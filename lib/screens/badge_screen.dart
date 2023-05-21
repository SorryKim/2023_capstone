import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import '../models/mountains_model.dart';

class BadgeScreen extends StatefulWidget {
  List<MountainsModel> mountains;
  BadgeScreen({super.key, required this.mountains});

  @override
  State<BadgeScreen> createState() => _BadgeScreenState();
}

class _BadgeScreenState extends State<BadgeScreen> {
  @override
  Widget build(BuildContext context) {
    streamMountains();
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
      body: StreamBuilder<List<MountainsModel>>(
          stream: streamMountains(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('에러발생~'),
              );
            } else if (snapshot.hasData) {
              List<MountainsModel> mountainList = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10),
                  ),
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
                                '${mountainList.elementAt(index).mntnName} - ${mountainList.elementAt(index).info}\n${mountainList.elementAt(index).reason}',
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
