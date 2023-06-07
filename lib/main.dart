import 'package:flutter/material.dart';
import 'package:project/src/app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MountainDew',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: child!,
        );
      },
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
