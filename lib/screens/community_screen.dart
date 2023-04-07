import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/models/community_model.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final user = FirebaseAuth.instance.currentUser;
  List<int> arr = [1, 2, 3, 4, 5];
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(messages[index].message),
                          subtitle: Text(messages[index].userName),
                          dense: true,
                          leading: const Icon(Icons.people_alt_rounded),
                          // TODO: 클릭 시 기능 구현해야 함
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  content: Text(messages[index].message),
                                  icon: const Icon(Icons.assist_walker_rounded),
                                  insetPadding: const EdgeInsets.all(2.0),
                                  actions: [
                                    // TODO: 댓글 달기 구현해야함!
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('댓글 달기'),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          '닫기',
                                          style: TextStyle(color: Colors.black),
                                        )),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }),
                ),
                getInputWidget(),
              ],
            );
          }
        },
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

  void _onPressedSendButton() {
    try {
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
    } catch (ex) {
      log('error');
    }
  }

  void onDialog() {}

  Widget getInputWidget() {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(color: Colors.black12, offset: Offset(0, -2), blurRadius: 3)
      ], color: Theme.of(context).bottomAppBarColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(fontSize: 15),
                  labelText: "커뮤니티에 하고싶은 말을 남겨보세요!",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.blue,
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
              width: 10,
            ),
            RawMaterialButton(
              onPressed: _onPressedSendButton, //전송버튼을 누를때 동작시킬 메소드
              constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
              elevation: 2,
              fillColor: Theme.of(context).colorScheme.primary,
              shape: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.send),
              ),
            )
          ],
        ),
      ),
    );
  }
}
