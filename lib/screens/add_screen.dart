import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/mountains_model.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController controller1 = TextEditingController();

  TextEditingController controller2 = TextEditingController();

  TextEditingController controller3 = TextEditingController();

  TextEditingController controller4 = TextEditingController();

  TextEditingController controller5 = TextEditingController();

  TextEditingController controller6 = TextEditingController();

  TextEditingController controller7 = TextEditingController();

  TextEditingController controller8 = TextEditingController();

  TextEditingController controller9 = TextEditingController();

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
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.white,
              icon: const Icon(Icons.arrow_back_ios),
            ),
            backgroundColor: Colors.blueAccent,
            elevation: 0.0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text('등산로 데이터 추가',
                      style: TextStyle(fontFamily: 'SCDream4', fontSize: 20)),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: controller1,
                      decoration: const InputDecoration(
                          labelText: '산이름 :', hintText: 'mntnName'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: controller2,
                      decoration: const InputDecoration(
                          labelText: '난이도 :', hintText: 'difficulty'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: controller3,
                      decoration: const InputDecoration(
                          labelText: '거리 :', hintText: 'distance'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: controller4,
                      decoration: const InputDecoration(
                          labelText: '높이 :', hintText: 'height'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: controller5,
                      decoration: const InputDecoration(
                          labelText: '설명 :', hintText: 'info'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: controller6,
                      decoration: const InputDecoration(
                          labelText: '위도 :', hintText: 'latitude'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: controller7,
                      decoration: const InputDecoration(
                          labelText: '경도 :', hintText: 'longitude'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: controller8,
                      decoration: const InputDecoration(
                          labelText: '이유 :', hintText: 'reason'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: controller9,
                      decoration: const InputDecoration(
                          labelText: '시간 :', hintText: 'timeTaken'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ElevatedButton(
                      onPressed: sendButton,
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.blueGrey),
                      ),
                      child: const Text('추가',
                          style:
                              TextStyle(fontSize: 20, fontFamily: 'SCDream4')),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void sendButton() {
    try {
      String mntnName = controller1.text;
      String difficulty = controller2.text;
      int distance = int.parse(controller3.text);
      int height = int.parse(controller4.text);
      String info = controller5.text;
      double latitude = double.parse(controller6.text);
      double longitude = double.parse(controller7.text);
      String reason = controller8.text;
      double timeTaken = double.parse(controller9.text);

      MountainsModel mountainsModel = MountainsModel(
        mntnName: mntnName,
        difficulty: difficulty,
        distance: distance,
        height: height,
        info: info,
        latitude: latitude,
        longitude: longitude,
        reason: reason,
        timeTaken: timeTaken,
      );
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore.collection('mountains/').add(mountainsModel.toMap());
      controller1.text = '';
      controller2.text = '';
      controller3.text = '';
      controller4.text = '';
      controller5.text = '';
      controller6.text = '';
      controller7.text = '';
      controller8.text = '';
      controller9.text = '';
    } catch (ex) {
      log(ex.toString());
    }
  }
}
