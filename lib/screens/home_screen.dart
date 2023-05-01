import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/badge_screen.dart';
import 'package:project/screens/community_screen.dart';
import 'package:project/screens/lobby_screen.dart';
import 'package:project/screens/login_screen.dart';
import 'package:project/screens/information_screen.dart';
import 'package:project/screens/walk_screen.dart';

class HomeScreen extends StatelessWidget {
  final String uid;

  const HomeScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const LoginScreen();
              } else {
                return MaterialApp(
                  home: DefaultTabController(
                    length: 5,
                    child: Scaffold(
                      body: TabBarView(
                        children: <Widget>[
                          const LobbyScreen(),
                          const WalkWidget(),
                          const BadgeScreen(),
                          const CommunityScreen(),
                          InformationScreen(uid: uid),
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
                            indicatorColor: Colors.green,
                            indicatorWeight: 2,
                            labelColor: Colors.green,
                            unselectedLabelColor: Colors.black87,
                            labelStyle: TextStyle(
                              fontSize: 13,
                            ),
                            tabs: [
                              Tab(
                                icon: Icon(
                                  Icons.home,
                                ),
                                text: '홈',
                              ),
                              Tab(
                                icon: Icon(Icons.directions_walk),
                                text: '만보기',
                              ),
                              Tab(
                                icon: Icon(
                                  Icons.military_tech,
                                ),
                                text: '배지',
                              ),
                              Tab(
                                icon: Icon(
                                  Icons.connect_without_contact,
                                ),
                                text: '커뮤니티',
                              ),
                              Tab(
                                icon: Icon(
                                  Icons.person,
                                ),
                                text: 'My 듀',
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }));
  }
}
