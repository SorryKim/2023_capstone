import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_survey/flutter_survey.dart';
import 'package:project/screens/home_screen.dart';

import '../models/login_model.dart';
import '../models/survey_model.dart';

class SurveyScreen extends StatelessWidget {
  late String uid;

  SurveyScreen({
    super.key,
    required this.uid,
  });

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
          return SurveyWidget(title: 'Flutter Survey', uid: uid);
        },
      ),
    );
  }
}

class SurveyWidget extends StatefulWidget {
  final String uid;
  final String title;

  const SurveyWidget({super.key, required this.title, required this.uid});

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
                  _onPressedSendButton(_questionResults, widget.uid);
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

  void _onPressedSendButton(List<QuestionResult> questionresult, String uid) {
    SurveyModel resultdata = SurveyModel(
        age: questionresult[1].answers[0],
        gender: questionresult[0].answers[0]);

    try {
      // 파이어베이스에 설문결과를 유저 테이블에 저장
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore.collection('user/$uid/survey').add(resultdata.toMap());
      firestore.doc('user/$uid').update({'isSurvey': true});
    } catch (ex) {
      log('error');
    }
  }

  // 파이어베이스의 저장된 유저목록 스트림
  Stream<List<LoginModel>> streamUser() {
    try {
      // 원하는 컬렉션의 스냅샷 가져오기
      Stream<QuerySnapshot> snapshots =
          FirebaseFirestore.instance.collection('user/').snapshots();

      // 스냅샷내부의 자료들을 List로 반환
      return snapshots.map((snapshot) {
        List<LoginModel> users = [];
        for (var temp in snapshot.docs) {
          users.add(LoginModel.fromMap(
              id: temp.id, map: temp.data() as Map<String, dynamic>));
        }
        return users;
      });
    } catch (ex) {
      log('error!');
      return Stream.error(ex.toString());
    }
  }
}
