// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:timer_builder/timer_builder.dart';

void main() => runApp(const HealthApp());

class HealthApp extends StatefulWidget {
  const HealthApp({super.key});

  @override
  _HealthAppState createState() => _HealthAppState();
}

class _HealthAppState extends State<HealthApp> {
  Timer? timer;
  var start; //운동시작시점
  var now;

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
                            color: Color.fromARGB(255, 48, 158, 248),
                          ),
                          const Text('거리'),
                          Text((dis).floor().toString()),
                        ],
                      ),
                      const SizedBox(width: 50),
                      Column(
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            size: 60,
                            color: Color.fromARGB(255, 236, 83, 18),
                          ),
                          const Text('칼로리'),
                          Text((cal).floor().toString()),
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
                Center(
                  child: Row(
                    children: <Widget>[
                      TextButton(
                        onPressed: () async {
                          await authorize();
                          timer = Timer.periodic(const Duration(seconds: 1),
                              (timer) async {
                            await fetchdata();
                            setState(() {
                              min++;
                            });
                          });
                        },
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue)),
                        child: const Text("시작",
                            style: TextStyle(color: Colors.white)),
                      ),
                      TextButton(
                        onPressed: () {
                          timer!.cancel();
                          print("$steps");
                          print("$dis");
                          print("$cal");
                          print("$min");

                          // showDialog(
                          //     context: context,
                          //     barrierDismissible: true,
                          //     builder: (BuildContext context) => AlertDialog(
                          //           content: Column(
                          //             children: [
                          //               const Text("오늘의 등산",
                          //                   textAlign: TextAlign.center),
                          //               Text("걸음 수 : $steps"),
                          //               Text("소모 칼로리 : $cal"),
                          //               Text("이동거리 : $dis"),
                          //               Text("이동시간: $min"),
                          //               // FloatingActionButton(
                          //               //     child: const Text("저장"),
                          //               //     onPressed: () {})
                          //             ],
                          //           ),
                          //           actions: [
                          //             FloatingActionButton(
                          //                 child: const Text("저장"),
                          //                 onPressed: () {})
                          //           ],
                          //         ));
                        },
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue)),
                        child: const Text("종료",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ]))),
    );
  }
}
