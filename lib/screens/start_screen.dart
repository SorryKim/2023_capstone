import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/screens/login_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreen();
}

class _StartScreen extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                  '이거 start_screen 없애구 바로 login_screen으로 바꿔주세요제발내가하니까 오류남'),
              // login.dart로 넘어가는 버튼
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()));
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
