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
        if (snapshot.hasError) {
          return const Center(
            child: Text('Firebase Load Fail!'),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return const Home();
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
