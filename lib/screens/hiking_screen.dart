import 'package:flutter/material.dart';

class HikingScreen extends StatefulWidget {
  const HikingScreen({super.key});

  @override
  State<HikingScreen> createState() => _HikingScreenState();
}

class _HikingScreenState extends State<HikingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('등산 기록!')),
      body: const Column(),
    );
  }
}
