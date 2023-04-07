import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/community_screen.dart';
import 'package:project/screens/login.dart';

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
              return Center(
                  child: Column(
                children: [
                  const SizedBox(
                    height: 200,
                  ),
                  Text('${snapshot.data!.displayName}님 환영합니다!.'),

                  // 커뮤니티 페이지로 가는 버튼
                  TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor:
                            const Color.fromARGB(242, 255, 255, 255),
                        backgroundColor: Colors.lightGreen,
                        fixedSize: const Size(100, 40),
                        side: const BorderSide(width: 1.0),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CommunityScreen()));
                      },
                      child: const Text('Community')),

                  // 로그아웃 버튼
                  TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.grey.withOpacity(0.5),
                        fixedSize: const Size(100, 40),
                        side: const BorderSide(width: 1.0),
                      ),
                      onPressed: FirebaseAuth.instance.signOut,
                      child: const Text('Google Logout')),
                ],
              ));
            }
          }),
    );
  }
}
