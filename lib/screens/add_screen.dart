import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
          appBar: AppBar(title: const Text('등산로 데이터 추가!')),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('mntnName  '),
                    const SizedBox(
                      width: 20,
                    ),
                    myInput(controller: controller1),
                  ],
                ),
                Row(
                  children: [
                    const Text('difficulty  '),
                    const SizedBox(
                      width: 20,
                    ),
                    myInput(controller: controller2),
                  ],
                ),
                Row(
                  children: [
                    const Text('distance  '),
                    const SizedBox(
                      width: 20,
                    ),
                    myInput(controller: controller3),
                  ],
                ),
                Row(
                  children: [
                    const Text('height  '),
                    const SizedBox(
                      width: 20,
                    ),
                    myInput(controller: controller4),
                  ],
                ),
                Row(
                  children: [
                    const Text('info  '),
                    const SizedBox(
                      width: 20,
                    ),
                    myInput(controller: controller5),
                  ],
                ),
                Row(
                  children: [
                    const Text('latitude  '),
                    const SizedBox(
                      width: 20,
                    ),
                    myInput(controller: controller6),
                  ],
                ),
                Row(
                  children: [
                    const Text('longitude  '),
                    const SizedBox(
                      width: 20,
                    ),
                    myInput(controller: controller7),
                  ],
                ),
                Row(
                  children: [
                    const Text('reason  '),
                    const SizedBox(
                      width: 20,
                    ),
                    myInput(controller: controller8),
                  ],
                ),
                Row(
                  children: [
                    const Text('timeTaken  '),
                    const SizedBox(
                      width: 20,
                    ),
                    myInput(controller: controller9),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(onPressed: sendButton, child: const Text('전송')),
              ],
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

class myInput extends StatelessWidget {
  const myInput({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelStyle: const TextStyle(fontSize: 15),
          hintText: "등산로 이름",
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
              color: Colors.black,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
              color: Colors.black26,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
