import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/community_screen.dart';
import 'package:project/screens/login.dart';
import 'package:project/screens/pedometer_screen.dart';
import 'package:project/screens/survey_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const LoginWidget();
            } else {
              return Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${snapshot.data!.displayName}님 환영합니다!.',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),

                  // 커뮤니티 페이지로 가는 버튼
                  Center(
                    child: Column(
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(242, 255, 255, 255),
                              backgroundColor: Colors.lightGreen,
                              minimumSize: const Size(100, 40),
                              side: const BorderSide(width: 1.0),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CommunityScreen()));
                            },
                            child: const Text('Community')),

                        // 설문조사 버튼
                        TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.black,
                              minimumSize: const Size(100, 40),
                              side: const BorderSide(width: 1.0),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SurveyScreen()));
                            },
                            child: const Text('Survey')),
                        // 만보기 버튼
                        TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5),
                              foregroundColor: Colors.black,
                              minimumSize: const Size(100, 40),
                              side: const BorderSide(width: 1.0),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PedometerScreen()));
                            },
                            child: const Text('Pedometer')),
                        // 로그아웃 버튼
                        TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.grey.withOpacity(0.5),
                              minimumSize: const Size(100, 40),
                              side: const BorderSide(width: 1.0),
                            ),
                            onPressed: FirebaseAuth.instance.signOut,
                            child: const Text('Google Logout')),
                      ],
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
