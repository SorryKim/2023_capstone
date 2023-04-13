import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/badge_screen.dart';
import 'package:project/screens/community_screen.dart';
import 'package:project/screens/lobby_screen.dart';
import 'package:project/screens/login_screen.dart';
import 'package:project/screens/walk_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                    length: 4,
                    child: Scaffold(
                      body: const TabBarView(
                        children: <Widget>[
                          LobbyScreen(),
                          WalkWidget(),
                          BadgeScreen(),
                          CommunityScreen()
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
                                  Icons.person,
                                ),
                                text: 'My듀',
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
