// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/models/hiking_model.dart';
import 'package:project/screens/hiking_screen.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:timer_builder/timer_builder.dart';

class HealthApp extends StatefulWidget {
  String uid;
  HealthApp({
    super.key,
    required this.uid,
  });

  @override
  _HealthAppState createState() => _HealthAppState();
}

class _HealthAppState extends State<HealthApp> {
  Timer? timer;
  var start; //운동시작시점
  var now;
  bool isStart = false;

  List<HealthDataPoint> caldatalist = [];
  List<HealthDataPoint> mindatalist = [];
  List<HealthDataPoint> disdatalist = [];

  int steps = 0; //걸음
  double cal = 0; //칼로리
  double min = 0; //운동시간
  double dis = 0; //운동거리

  static final types = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.MOVE_MINUTES,
    HealthDataType.DISTANCE_DELTA
  ];
  final permissions = types.map((e) => HealthDataAccess.READ_WRITE).toList();

  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  Future authorize() async {
    start = DateTime.now();

    await Permission.activityRecognition.request();
    await Permission.location.request();
    await health.hasPermissions(types, permissions: permissions);
    await health.requestAuthorization(types, permissions: permissions);

    setState(() {});
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2, 7);
  }

  Future fetchdata() async {
    now = DateTime.now();
    int? walk;

    List<HealthDataType> callist = [HealthDataType.ACTIVE_ENERGY_BURNED];
    List<HealthDataType> minlist = [HealthDataType.MOVE_MINUTES];
    List<HealthDataType> dislist = [HealthDataType.DISTANCE_DELTA];

    caldatalist = await health.getHealthDataFromTypes(start, now, callist);
    mindatalist = await health.getHealthDataFromTypes(start, now, minlist);
    disdatalist = await health.getHealthDataFromTypes(start, now, dislist);

    walk = await health.getTotalStepsInInterval(start, now);

    steps = walk ?? 0;

    cal = totalvalue(caldatalist);
    //min = totalvalue(mindatalist);
    dis = totalvalue(disdatalist);
  }

  double totalvalue(List<HealthDataPoint> list) {
    double value = 0;
    for (var i = 0; i < list.length; i++) {
      String a = list[i].value.toString();
      value += double.parse(a);
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              // Status bar color
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
            title: const Text(
              'MOUNTAINDEW',
              style: TextStyle(
                  fontSize: 19,
                  color: Colors.black,
                  fontFamily: 'ClimateCrisisKR'),
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
          ),
          body: SingleChildScrollView(
              child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 50,
                    ),
                    CircularStepProgressIndicator(
                      totalSteps: 100,
                      currentStep: (0.01 * steps).floor(),
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
                          '$steps',
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
                          Column(
                            children: [
                              const Icon(
                                Icons.timeline,
                                size: 60,
                                color: Colors.blue,
                              ),
                              const Text('거리'),
                              Text("${(dis).floor().toString()}km"),
                            ],
                          ),
                          const SizedBox(width: 50),
                          Column(
                            children: [
                              const Icon(
                                Icons.local_fire_department,
                                size: 60,
                                color: Color.fromARGB(255, 236, 58, 18),
                              ),
                              const Text('칼로리'),
                              Text("${(cal).floor().toString()}cal"),
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
                              Text(format((min).floor())),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 300,
                            child: TextButton(
                              onPressed: () async {
                                if (isStart) {
                                  isStart = false;
                                  pressedStop(context);
                                } else {
                                  isStart = true;
                                  await authorize();
                                  timer =
                                      Timer.periodic(const Duration(seconds: 1),
                                          (timer) async {
                                    await fetchdata();
                                    setState(() {
                                      min++;
                                    });
                                  });
                                }
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                isStart
                                    ? Colors.redAccent
                                    : const Color.fromARGB(255, 10, 11, 70),
                              )),
                              child: Text(isStart ? "종료" : "시작",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'SCDream4',
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 300,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          HikingScreen(uid: widget.uid)));
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blueGrey)),
                            child: const Text("등산기록 확인",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'SCDream4',
                                    fontSize: 16)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ]))),
    );
  }

  Future<dynamic> pressedStop(BuildContext context) {
    timer!.cancel();
    print("$steps");
    print("$dis");
    print("$cal");
    print("$min");

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Column(
              children: [
                const Text(
                  "오늘의 등산",
                  style: TextStyle(fontFamily: 'SCDream4', fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "걸음  수 : $steps",
                  style: const TextStyle(
                    fontFamily: 'SCDream4',
                  ),
                ),
                Text(
                  "소모 칼로리 : ${cal.round()}",
                  style: const TextStyle(
                    fontFamily: 'SCDream4',
                  ),
                ),
                Text(
                  "이동거리 : $dis",
                  style: const TextStyle(
                    fontFamily: 'SCDream4',
                  ),
                ),
                Text(
                  "이동시간: $min",
                  style: const TextStyle(
                    fontFamily: 'SCDream4',
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    pressedSaveButton();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  child: const Text(
                    "저장",
                    style: TextStyle(
                      fontFamily: 'SCDream4',
                    ),
                  )),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text(
                    "닫기",
                    style: TextStyle(
                      fontFamily: 'SCDream4',
                    ),
                  )),
            ],
          );
        });
  }

  // 이미 시작되어 있을 경우 알람상자
  Future<dynamic> alreadyStart(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            content: const Column(
              children: [
                Text(
                  "이미 시작중입니다!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'SCDream4',
                  ),
                )
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text(
                    '닫기',
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'SCDream4'),
                  )),
            ],
          );
        });
  }

  // 파이어베이스에 등산기록 데이터 전송
  void pressedSaveButton() {
    try {
      // 파이어베이스에 저장할 객체
      HikingModel hikingModel = HikingModel(
        steps: steps,
        distance: dis,
        calories: cal,
        time: min,
        sendDate: Timestamp.now(),
      );
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore
          .collection('user/${widget.uid}/health')
          .add(hikingModel.toMap());
    } catch (ex) {
      log(ex.toString());
    }
  }
}
