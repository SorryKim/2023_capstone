import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/comment_model.dart';

class CommentScreen extends StatefulWidget {
  final String description;
  final String descriptionId;
  final Timestamp date;
  final String writerName;
  final int like, dislike;

  const CommentScreen({
    super.key,
    required this.writerName,
    required this.date,
    required this.description,
    required this.descriptionId,
    required this.like,
    required this.dislike,
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final user = FirebaseAuth.instance.currentUser;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int likeCnt = widget.like;
    int dislikeCnt = widget.dislike;
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.white,
            icon: const Icon(Icons.arrow_back_ios),
          ),
          backgroundColor: Colors.amber,
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
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          bottom: 0, top: 8, left: 8, right: 8),
                      padding: const EdgeInsets.all(8.0),
                      height: 70,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 6, right: 10),
                                child: Icon(
                                  Icons.face,
                                  size: 25,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                      '${widget.writerName}\n${readTimestamp(widget.date)}'),
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
                      height: 100,
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
                            onPressed: _onPressedLikeButton,
                            iconSize: 25,
                          ),
                          Text(widget.like.toString()),
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
                              onPressed: _onPressedDislikeButton,
                              iconSize: 25,
                            ),
                          ),
                          Text(widget.dislike.toString()),
                        ],
                      ),
                    ),
                    Flexible(
                        child: ListView.builder(
                      itemCount: comments.length,
                      shrinkWrap: true,
                      controller: ScrollController(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: const BorderSide(
                                    color: Colors.black12, width: 1)),
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
                ),
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

  // 댓글 전송 메소드
  void _onPressedSendButton() {
    try {
      if (controller.text.replaceAll(' ', '') == '') {
        _showdialog(context);
      } else {
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
      }
    } catch (ex) {
      log('error');
    }
  }

  // 좋아요 전송 메소드
  void _onPressedLikeButton() {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore
          .collection('community/dkKeHkBBOTap6hZE9tG2/messages/')
          .doc(widget.descriptionId)
          .update({"like": widget.like + 1});
    } catch (ex) {
      log('error');
    }
  }

  void _onPressedDislikeButton() {
    try {
      setState(() {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        firestore
            .collection('community/dkKeHkBBOTap6hZE9tG2/messages/')
            .doc(widget.descriptionId)
            .update({"dislike": widget.dislike + 1});
      });
    } catch (ex) {
      log('error');
    }
  }

  // Timestamp를 이쁘게 출력하는 메소드
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
                  fillColor: Colors.white,
                  hintText: '댓글을 남겨보세요',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 0, 132, 4),
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
              fillColor: const Color.fromARGB(255, 0, 132, 4),
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

  Future<dynamic> _showdialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(''),
        content: const Text('내용을 입력해주세요!'),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기')),
        ],
      ),
    );
  }
}
