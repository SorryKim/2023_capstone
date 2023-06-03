import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/models/hiking_model.dart';

class HikingScreen extends StatefulWidget {
  String uid;
  HikingScreen({super.key, required this.uid});

  @override
  State<HikingScreen> createState() => _HikingScreenState();
}

class _HikingScreenState extends State<HikingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('등산 기록!')),
      body: StreamBuilder(
        stream: streamHiking(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<HikingModel> modelList = snapshot.data!;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ListView.separated(
                      itemCount: modelList.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8.0),
                            title: Text(
                              '${index + 1}번째 기록',
                              style: const TextStyle(fontSize: 16.5),
                            ),
                            subtitle:
                                Text(readTimestamp(modelList[index].sendDate)),
                            dense: true,
                            leading: Image.asset('images/dew.png'),
                            onTap: () {
                              AlertDialog dialog = AlertDialog(
                                content: Text(
                                  '기록날짜: ${DateFormat('yyyy년 MM월 dd일 HH:mm:ss').format(DateTime.fromMicrosecondsSinceEpoch(modelList[index].sendDate.microsecondsSinceEpoch))}\n걸음 수: ${modelList[index].steps}보\n이동 거리: ${modelList[index].distance}km\n소모 칼로리: ${modelList[index].calories.round()}cal',
                                  style: const TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              );
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => dialog);
                            },
                          ),
                        );
                      }),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            log(snapshot.error.toString());
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  // DB에서 커뮤니티 정보를 받아오는 Stream
  Stream<List<HikingModel>> streamHiking() {
    try {
      // 원하는 컬렉션의 스냅샷 가져오기
      Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance
          .collection('user/${widget.uid}/health')
          .orderBy('sendDate')
          .snapshots();

      // 스냅샷내부의 자료들을 List로 반환
      return snapshots.map((snapshot) {
        List<HikingModel> hikingList = [];
        for (var temp in snapshot.docs) {
          hikingList.add(HikingModel.fromMap(
              id: temp.id, map: temp.data() as Map<String, dynamic>));
        }
        return hikingList;
      });
    } catch (ex) {
      log('error!');
      return Stream.error(ex.toString());
    }
  }

  String readTimestamp(Timestamp timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = '${diff.inDays} 일 전';
      } else {
        time = '${diff.inDays} 일 전';
      }
    } else {
      if (diff.inDays == 7) {
        time = '${(diff.inDays / 7).floor()} 주 전';
      } else {
        time = '${(diff.inDays / 7).floor()} 주 전';
      }
    }

    return time;
  }
}
