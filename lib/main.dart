import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/src/app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  permit() async {
    await Permission.activityRecognition.request();
  }

  @override
  Widget build(BuildContext context) {
    permit();
    return MaterialApp(
      title: 'MountainDew',
      theme: ThemeData(
        fontFamily: 'SCDream4',
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.red,
      ),
      home: const App(),
    );
  }
}
