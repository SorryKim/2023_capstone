import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'src/app.dart';

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
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: const Color.fromARGB(255, 10, 68, 12),
      ),
      home: const App(),
    );
  }
}
