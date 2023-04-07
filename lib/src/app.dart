import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

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
          return const Home();
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
