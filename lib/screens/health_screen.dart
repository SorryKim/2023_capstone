// ignore_for_file: non_constant_identifier_names

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

enum AppState {
  DATA_NOT_FETCHED,
  NO_DATA,
  AUTHORIZED,
  AUTH_NOT_GRANTED,
  STEPS_READY,
}

class _HealthAppState extends State<HealthApp> {
  AppState _state = AppState.DATA_NOT_FETCHED;
  int start_nofSteps = 0;
  double start_calories = 0;
  double start_min = 0;
  double start_dis = 0;
  bool s = false;
  Timer? timer;

  int _nofSteps = 0;
  double _calories = 0;
  double _min = 0;
  double _dis = 0;

  List<HealthDataPoint> callist = [];
  List<HealthDataPoint> minlist = [];
  List<HealthDataPoint> distancelist = [];

  static final types = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.MOVE_MINUTES,
    HealthDataType.DISTANCE_DELTA
  ];
  final permissions = types.map((e) => HealthDataAccess.READ_WRITE).toList();

  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  Future authorize() async {
    Permission.activityRecognition.request();
    await Permission.location.request();
    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions);
    hasPermissions = false;

    bool authorized = false;
    if (!hasPermissions) {
      try {
        authorized =
            await health.requestAuthorization(types, permissions: permissions);
      } catch (error) {
        print("Exception in authorize: $error");
      }
    }

    setState(() {
      _state = (authorized) ? AppState.STEPS_READY : AppState.AUTH_NOT_GRANTED;
      fetchStepData();
    });
  }

  double startvalue(List<HealthDataPoint> list) {
    double value = 0;
    for (var i = 0; i < list.length; i++) {
      String a = list[i].value.toString();
      value += double.parse(a);
    }
    return value;
  }

  Future fetchStepData() async {
    List<HealthDataType> cal = [HealthDataType.ACTIVE_ENERGY_BURNED];
    List<HealthDataType> min = [HealthDataType.MOVE_MINUTES];
    List<HealthDataType> distance = [HealthDataType.DISTANCE_DELTA];
    int? steps;
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requestedstep =
        await health.requestAuthorization([HealthDataType.STEPS]);
    bool requestedcal = await health
        .requestAuthorization([HealthDataType.ACTIVE_ENERGY_BURNED]);

    if (requestedstep && requestedcal) {
      try {
        steps = await health.getTotalStepsInInterval(midnight, now);
        start_nofSteps = steps!;
        callist = await health.getHealthDataFromTypes(midnight, now, cal);
        minlist = await health.getHealthDataFromTypes(midnight, now, min);
        distancelist =
            await health.getHealthDataFromTypes(midnight, now, distance);
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      setState(() {
        start_nofSteps = (steps == null) ? 0 : steps;
        // _healthDataListcal = callist;
        // _healthDataListmin = minlist;
        // _healthDataListdis = distancelist;
        start_calories = startvalue(callist);
        start_min = startvalue(minlist);
        start_dis = startvalue(distancelist);
        _state = (steps == null) ? AppState.NO_DATA : AppState.STEPS_READY;
      });
    } else {
      print("Authorization not granted - error in authorization");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  Widget _contentNoData() {
    return const Text('No Data to show');
  }

  Widget _contentNotFetched() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Press the download button to fetch data.'),
        Text('Press the plus button to insert some random data.'),
        Text('Press the walking button to get total step count.'),
      ],
    );
  }

  Widget _authorized() {
    return const Text('Authorization granted!');
  }

  Widget _authorizationNotGranted() {
    return const Text('Authorization not given. '
        'For Android please check your OAUTH2 client ID is correct in Google Developer Console. '
        'For iOS check your permissions in Apple Health.');
  }

  Widget _stepsFetched() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TimerBuilder.periodic(
              const Duration(seconds: 1),
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 50,
                        ),
                        CircularStepProgressIndicator(
                          totalSteps: 100,
                          currentStep: (0.01 * _nofSteps).floor(),
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
                              '$_nofSteps',
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
                                  Text((_dis).floor().toString()),
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
                                  Text((_calories).floor().toString()),
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
                                  Text((_min).floor().toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future cleanlist() async {
    callist.clear();
    minlist.clear();
    distancelist.clear();
  }

  Future createlist() async {
    List<HealthDataType> cal = [HealthDataType.ACTIVE_ENERGY_BURNED];
    List<HealthDataType> min = [HealthDataType.MOVE_MINUTES];
    List<HealthDataType> distance = [HealthDataType.DISTANCE_DELTA];

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    callist = await health.getHealthDataFromTypes(midnight, now, cal);
    minlist = await health.getHealthDataFromTypes(midnight, now, min);
    distancelist = await health.getHealthDataFromTypes(midnight, now, distance);

    _calories = startvalue(callist);
    _min = startvalue(minlist);
    _dis = startvalue(distancelist);
  }

  Future step() async {
    int? steps;
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    steps = await health.getTotalStepsInInterval(midnight, now);
    _nofSteps = (steps == null) ? 0 : steps;
  }

  Future<void> func() async {
    await step();
    await cleanlist();
    await createlist();
    setState(() {
      _nofSteps -= start_nofSteps;
      _calories -= start_calories;
      _min -= start_min;
      _dis -= start_dis;
    });
  }

  Widget _content() {
    if (_state == AppState.NO_DATA) {
      return _contentNoData();
    } else if (_state == AppState.AUTHORIZED)
      return _authorized();
    else if (_state == AppState.AUTH_NOT_GRANTED)
      return _authorizationNotGranted();
    else if (_state == AppState.STEPS_READY)
      return _stepsFetched();
    else
      return _contentNotFetched();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            const Divider(thickness: 3),
            Expanded(child: Center(child: _stepsFetched())),
            TextButton(
                onPressed: () {
                  authorize();
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                child:
                    const Text("start", style: TextStyle(color: Colors.white))),
            TextButton(
                onPressed: () {
                  func();
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                child:
                    const Text("stop", style: TextStyle(color: Colors.white))),
            TextButton(
                onPressed: () {
                  print('check');
                  print('step: $start_nofSteps');
                  print('cal : $start_calories');
                  print('min : $start_min');
                  print('dis : $start_dis');
                  print('check');
                  print('step: $_nofSteps');
                  print('cal : $_calories');
                  print('min : $_min');
                  print('dis : $_dis');
                },
                child: const Text("값확인")),
          ],
        ),
      ),
    );
  }
}
