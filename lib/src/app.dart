import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/login_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // 연결 실패한 경우
        if (snapshot.hasError) {
          return const Center(
            child: Text('Firebase Load Fail!'),
          );
        }

        // 연결 성공한 경우
        if (snapshot.connectionState == ConnectionState.done) {
          return const LoginScreen();
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
