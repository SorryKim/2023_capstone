import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/badge_screen.dart';
import 'package:project/screens/community_screen.dart';
import 'package:project/screens/health_screen.dart';
import 'package:project/screens/lobby_screen.dart';

import '../models/mountains_model.dart';

class HomeScreen extends StatelessWidget {
  final String uid;

  const HomeScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: StreamBuilder(
            stream: streamMountains(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text('오류 발생'));
              } else {
                List<MountainsModel> mountains = snapshot.data!;
                return Scaffold(
                  body: TabBarView(
                    children: <Widget>[
                      LobbyScreen(
                        uid: uid,
                        mountains: mountains,
                      ),
                      const HealthApp(),
                      BadgeScreen(
                        mountains: mountains,
                      ),
                      const CommunityScreen(),
                    ],
                  ),
                  extendBodyBehindAppBar: true,
                  bottomNavigationBar: Container(
                    color: Colors.white,
                    child: Container(
                      height: 70,
                      padding: const EdgeInsets.only(bottom: 5, top: 3),
                      child: const TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Color.fromARGB(255, 10, 68, 12),
                        indicatorWeight: 2,
                        labelColor: Color.fromARGB(255, 10, 68, 12),
                        unselectedLabelColor: Colors.black54,
                        labelStyle: TextStyle(
                          fontSize: 13,
                        ),
                        tabs: [
                          Tab(
                            icon: Icon(Icons.home, size: 30),
                            text: '홈',
                          ),
                          Tab(
                            icon: Icon(Icons.favorite, size: 30),
                            text: '건강',
                          ),
                          Tab(
                            icon: Icon(Icons.verified, size: 30),
                            text: '미션',
                          ),
                          Tab(
                            icon: Icon(Icons.image, size: 30),
                            text: '커뮤니티',
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }),
      ),
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
}
