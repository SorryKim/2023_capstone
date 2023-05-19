import 'package:flutter/material.dart';
import 'package:project/screens/badge_screen.dart';
import 'package:project/screens/community_screen.dart';
import 'package:project/screens/health_screen.dart';
import 'package:project/screens/lobby_screen.dart';

class HomeScreen extends StatelessWidget {
  final String uid;

  const HomeScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          body: TabBarView(
            children: <Widget>[
              LobbyScreen(
                uid: uid,
              ),
              const HealthApp(),
              const BadgeScreen(),
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
        ),
      ),
    );
  }
}
