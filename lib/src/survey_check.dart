import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/models/login_model.dart';
import 'package:project/screens/home_screen.dart';

import '../screens/survey_screen.dart';

class SurveyCheck extends StatelessWidget {
  final String uid;
  const SurveyCheck({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamLogin(),
      builder: (context, snapshot) {
        // 데이터 가져올 동안 로딩화면
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          List<LoginModel> users = snapshot.data!;
          final user = FirebaseAuth.instance.currentUser;

          // 만약 이미 데이터베이스에 해당 유저가 존재하면 바로 넘김
          for (int i = 0; i < users.length; i++) {
            if (users[i].userId == user!.uid) {
              if (users[i].isSurvey) {
                return HomeScreen(uid: users[i].id);
              } else {
                return SurveyScreen(uid: users[i].id);
              }
            }
          }

          // 데이터베이스에 존재하지 않는 신규유저이면 데이터베이스에 저장 후 넘김
          LoginModel loginModel = LoginModel(
            isSurvey: false,
            userId: user!.uid,
            userName: user.displayName!,
          );

          // 파이어베이스에 유저정보 저장
          FirebaseFirestore.instance.collection('user').add(loginModel.toMap());

          // 설문조사로 넘김
          return SurveyScreen(uid: user.uid);
        }
      },
    );
  }

  // 파이어베이스의 저장된 유저목록 스트림
  Stream<List<LoginModel>> streamLogin() {
    try {
      // 원하는 컬렉션의 스냅샷 가져오기
      Stream<QuerySnapshot> snapshots =
          FirebaseFirestore.instance.collection('user/').snapshots();

      // 스냅샷내부의 자료들을 List로 반환
      return snapshots.map((snapshot) {
        List<LoginModel> users = [];
        for (var temp in snapshot.docs) {
          users.add(LoginModel.fromMap(
              id: temp.id, map: temp.data() as Map<String, dynamic>));
        }
        return users;
      });
    } catch (ex) {
      log('error!');
      return Stream.error(ex.toString());
    }
  }
}
