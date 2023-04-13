import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_survey/flutter_survey.dart';
import 'package:project/screens/home_screen.dart';

import '../models/survey_model.dart';

class SurveyScreen extends StatelessWidget {
  const SurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Survey Demo',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: FutureBuilder(
        builder: (context, hassError) {
          return const SurveyWidget(title: 'Flutter Survey');
        },
      ),
    );
  }
}

class SurveyWidget extends StatefulWidget {
  const SurveyWidget({super.key, required this.title});

  final String title;

  @override
  State<SurveyWidget> createState() => _SurveyWidgetState();
}

class _SurveyWidgetState extends State<SurveyWidget> {
  final _formKey = GlobalKey<FormState>();
  List<QuestionResult> _questionResults = [];
  final List<Question> _initialData = [
    Question(
      isMandatory: true,
      question: '당신의 성별은?',
      answerChoices: const {
        "남자": null,
        "여자": null,
      },
    ),
    Question(
      question: "당신의 연령은?",
      isMandatory: true,
      answerChoices: const {
        "10대": null,
        "20대": null,
        "30대": null,
        "40대": null,
        "50대": null,
        "60대 이상": null,
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Survey(
            onNext: (questionResults) {
              _questionResults = questionResults;
            },
            initialData: _initialData),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    const Color.fromARGB(255, 18, 77, 20), // Background Color
              ),
              child: const Text("➡️"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _onPressedSendButton(_questionResults);
                }
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onPressedSendButton(List<QuestionResult> questionresult) {
    SurveyModel resultdata = SurveyModel(
        age: questionresult[1].answers[0],
        gender: questionresult[0].answers[0]);

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore
          .collection('user/NnwBkOmV81kBcue0YK7N/survey')
          .add(resultdata.toMap());
    } catch (ex) {
      log('error');
    }
  }
}
