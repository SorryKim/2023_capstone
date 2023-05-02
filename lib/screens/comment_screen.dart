import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/comment_model.dart';

import 'dart:math' as math;

class CommentScreen extends StatefulWidget {
  final String description;
  final String descriptionId;

  const CommentScreen({
    super.key,
    required this.description,
    required this.descriptionId,
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final user = FirebaseAuth.instance.currentUser;
  TextEditingController controller = TextEditingController();
  double radians = 90 * math.pi / 180;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '댓글 달기',
            style: TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 10, 68, 12),
          elevation: 0.0,
        ),
        body: StreamBuilder<List<CommentModel>>(
          stream: streamComment(),
          builder: (context, snapshot) {
            // 데이터가 없을 경우 로딩화면
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('오류 발생 !!'),
              );
            } else {
              List<CommentModel> comments = snapshot.data!;
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        bottom: 0, top: 8, left: 8, right: 8),
                    padding: const EdgeInsets.all(8.0),
                    height: 50,
                    width: double.infinity,
                    child: const Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 6, right: 3),
                              child: Icon(
                                Icons.face,
                                size: 25,
                              ),
                            ),
                            Column(
                              children: [
                                Text('김재성'),
                                Text('           04/30 23:52'),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        bottom: 8, top: 0, left: 8, right: 8),
                    padding: const EdgeInsets.all(8.0),
                    height: 200,
                    width: double.infinity,
                    child: Text(
                      widget.description,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 100,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.recommend_rounded,
                            color: Colors.red,
                          ),
                          onPressed: () {},
                          iconSize: 25,
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 17,
                            ),
                            Transform.rotate(
                              angle: 3.14,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.recommend,
                                  color: Colors.blue,
                                ),
                                onPressed: () {},
                                iconSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 10, 68, 12),
                                  width: 1)),
                          title: Text(comments[index].message),
                          subtitle: Text(
                            comments[index].userName,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      );
                    },
                  )),
                  getInputWidget(),
                ],
              );
            }
          },
        ));
  }

  Stream<List<CommentModel>> streamComment() {
    try {
      // 원하는 컬렉션의 스냅샷 가져오기
      Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance
          .collection(
              'community/dkKeHkBBOTap6hZE9tG2/messages/${widget.descriptionId}/comment/')
          .orderBy('sendDate')
          .snapshots();

      // 스냅샷내부의 자료들을 List로 반환
      return snapshots.map((snapshot) {
        List<CommentModel> comments = [];
        for (var temp in snapshot.docs) {
          comments.add(CommentModel.fromMap(
              id: temp.id, map: temp.data() as Map<String, dynamic>));
        }
        return comments;
      });
    } catch (ex) {
      log('error!');
      return Stream.error(ex.toString());
    }
  }

  void _onPressedSendButton() {
    try {
      CommentModel messageModel = CommentModel(
        sendDate: Timestamp.now(),
        message: controller.text,
        userName: user!.displayName!,
        userId: user!.uid,
      );

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore
          .collection(
              'community/dkKeHkBBOTap6hZE9tG2/messages/${widget.descriptionId}/comment/')
          .add(messageModel.toMap());
      controller.text = '';
    } catch (ex) {
      log('error');
    }
  }

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
                  labelText: "댓글을 남겨보세요!",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 10, 68, 12),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.black45,
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
              fillColor: const Color.fromARGB(255, 10, 68, 12),
              shape: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
