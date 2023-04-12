import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class WalkApp extends StatelessWidget {
  const WalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'pedometer', // 만보기
      home: WalkWidget(),
    );
  }
}

class WalkWidget extends StatefulWidget {
  const WalkWidget({super.key});

  @override
  State<WalkWidget> createState() => _WalkWidgetState();
}

class _WalkWidgetState extends State<WalkWidget> {
  int walk = 0;
  ShakeDetector? shakeDetector;
  late Timer timer;
  int totaltime = 0;

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2, 7);
  }

  void Time(Timer timer) {
    setState(() {
      totaltime = totaltime + 1;
    });
  }

  void onPhoneShake() {
    setState(() {
      walk = walk + 1;
    });
  }

  void startWalk() {
    setState(() {
      timer = Timer.periodic(
        const Duration(seconds: 1),
        Time,
      );
    });
  }

  void stopWalk() {
    setState(() {
      timer.cancel();
    });
  }

  @override
  void initState() {
    super.initState();

    shakeDetector = ShakeDetector.autoStart(
      // 흔들기 감지 즉시 시작
      shakeSlopTimeMS: 1, // 감지 주기
      shakeThresholdGravity: 2.7, // 감지 민감도
      onPhoneShake: onPhoneShake, // 감지 후 실행할 함수
    );
    shakeDetector = ShakeDetector.autoStart(
      shakeThresholdGravity: 2.7, // 감지 민감도
      onPhoneShake: startWalk, // 감지 후 실행할 함수
    );
  }

  @override
  void dispose() {
    shakeDetector!.stopListening(); // 흔들기 감지 중지
    stopWalk();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // 스크롤뷰
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0), // 왼쪽, 오른쪽: 30
              child: Container(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 85,
                    ),
                    CircularStepProgressIndicator(
                      totalSteps: 100,
                      currentStep: (0.01 * walk).floor(),
                      stepSize: 30,
                      selectedColor: Colors.green[200],
                      unselectedColor: Colors.grey[200],
                      padding: 0,
                      width: 250,
                      height: 250,
                      selectedStepSize: 30,
                      roundedCap: (_, __) => false,
                      child: Center(
                        child: Text(
                          '$walk',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Column(
                            children: [
                              Icon(
                                Icons.timeline,
                                size: 60,
                                color: Color.fromARGB(255, 48, 158, 248),
                              ),
                              Text('거리'),
                              Text('0.0KM'),
                            ],
                          ),
                          const SizedBox(width: 50),
                          const Column(
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                size: 60,
                                color: Color.fromARGB(255, 236, 83, 18),
                              ),
                              Text('칼로리'),
                              Text('0KCAL'),
                            ],
                          ),
                          const SizedBox(width: 50),
                          Column(
                            children: [
                              const Icon(
                                Icons.timer,
                                size: 60,
                                color: Color.fromARGB(255, 255, 208, 66),
                              ),
                              const Text('시간'),
                              Text(
                                format(totaltime),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
