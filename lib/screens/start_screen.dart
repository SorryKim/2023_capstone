import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreen();
}

class _StartScreen extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 36, 45, 36), // 상단바 색 : 진한 초록
    ));

    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 2, 95, 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 5월에 바꿀겅미 이쁜걸루!
              Image.asset(
                'images/mount-removebg-preview.png',
                height: 250,
              ),
              // MountainDew 글씨체 바꿀거양
              const Center(
                child: Text(
                  'MOUNTAINDEW',
                  style: TextStyle(
                    fontSize: 45,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // login.dart로 넘어가는 버튼
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const Home()));
                },
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(
                      top: 14,
                      bottom: 14,
                      left: 150,
                      right: 150,
                    ),
                    backgroundColor: Colors.white),
                child: const Icon(
                  Icons.login,
                  size: 30,
                  color: Color.fromARGB(255, 2, 70, 4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
