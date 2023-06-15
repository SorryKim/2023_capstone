import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/models/community_model.dart';
import 'package:project/screens/comment_screen.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final user = FirebaseAuth.instance.currentUser;
  TextEditingController controller = TextEditingController();

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
              fontSize: 19, color: Colors.black, fontFamily: 'ClimateCrisisKR'),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              myDialog(context);
            },
            color: const Color.fromARGB(255, 10, 11, 70),
            iconSize: 40,
          )
        ],
      ),
      body: StreamBuilder<List<CommunityModel>>(
        stream: streamCommunity(),
        builder: (context, snapshot) {
          // snapshot의 데이터가 존재하지 않는 경우
          if (!snapshot.hasData) {
            // 로딩화면 송출
            return const Center(child: CircularProgressIndicator());
          }
          // 스냅샷의 에러가 발생한 경우
          else if (snapshot.hasError) {
            return const Center(
              child: Text('오류 발생 !!'),
            );
          } else {
            List<CommunityModel> messages = snapshot.data!;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ListView.separated(
                      itemCount: messages.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            title: Text(
                              messages[index].message,
                              style: const TextStyle(
                                  fontSize: 17, fontFamily: 'SCDream4'),
                            ),
                            subtitle: Text(
                              messages[index].userName,
                              style: const TextStyle(
                                  fontSize: 16, fontFamily: 'SCDream4'),
                            ),
                            dense: true,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CommentScreen(
                                            description:
                                                messages[index].message,
                                            descriptionId: messages[index].id,
                                            date: messages[index].sendDate,
                                            writerName:
                                                messages[index].userName,
                                            like: messages[index].like,
                                            dislike: messages[index].dislike,
                                          )));
                            },
                          ),
                        );
                      }),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  // 글쓰기 알람상자 기능
  Future<dynamic> myDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          icon: const Icon(Icons.assist_walker_rounded),
          insetPadding: const EdgeInsets.all(2.0),
          actions: [
            SizedBox(
              width: double.maxFinite,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(fontSize: 15),
                  hintText: "커뮤니티에 하고싶은 말을 남겨보세요",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.black26,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () {
                      _onPressedSendButton();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 10, 11, 70),
                    ),
                    child: const Text(
                      '글 게시하기',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SCDream4',
                          fontSize: 17),
                    )),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                    ),
                    child: const Text(
                      '닫기',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SCDream4',
                          fontSize: 17),
                    )),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> _showdialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(''),
        content: const Text('내용을 입력해주세요',
            style: TextStyle(fontFamily: 'SCDream4', fontSize: 17)),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 10, 11, 70),
            ),
            child: const Text('닫기',
                style: TextStyle(fontFamily: 'SCDream4', fontSize: 14)),
          ),
        ],
      ),
    );
  }

  // DB에서 커뮤니티 정보를 받아오는 Stream
  Stream<List<CommunityModel>> streamCommunity() {
    try {
      // 원하는 컬렉션의 스냅샷 가져오기
      Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance
          .collection('community/dkKeHkBBOTap6hZE9tG2/messages')
          .orderBy('sendDate')
          .snapshots();

      // 스냅샷내부의 자료들을 List로 반환
      return snapshots.map((snapshot) {
        List<CommunityModel> messages = [];
        for (var temp in snapshot.docs) {
          messages.add(CommunityModel.fromMap(
              id: temp.id, map: temp.data() as Map<String, dynamic>));
        }
        return messages;
      });
    } catch (ex) {
      log('error!');
      return Stream.error(ex.toString());
    }
  }

  // 파이어베이스에 데이터 전송
  void _onPressedSendButton() {
    try {
      if (controller.text.replaceAll(' ', '') == '') {
        _showdialog(context);
      } else {
        CommunityModel messageModel = CommunityModel(
          sendDate: Timestamp.now(),
          message: controller.text,
          userName: user!.displayName!,
          userId: user!.uid,
        );

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        firestore
            .collection('community/dkKeHkBBOTap6hZE9tG2/messages')
            .add(messageModel.toMap());
        controller.text = '';
      }
    } catch (ex) {
      log('error');
    }
  }
}
