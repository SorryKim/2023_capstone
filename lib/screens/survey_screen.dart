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
    Question(
      question: "목표 걸음 수는?",
      isMandatory: true,
      answerChoices: const {
        "1000~2000": null,
        "2000~3000": null,
        "3000~4000": null,
        "4000~5000": null,
        "5000~": null,
      },
    ),
    Question(
      singleChoice: true,
      question: "설문이 종료되었습니다. 나의 등산유형검사를 받아보시겠습니까?",
      answerChoices: {
        "네": [
          Question(
            question: "등산을 가려한다! 이때 나는",
            answerChoices: const {
              "\"같이 등산가실분 구해요~!\" 커뮤니티에 글을 올려 함께 등산을 즐긴다.": null,
              "조용히 경치도 구경하고, 힘들면 잠시 쉬며 혼자만의 등산을 즐긴다.": null,
            },
          ),
          Question(
            question: "정상에 올라왔다.",
            answerChoices: const {
              "인증샷은 필수지! 다같이 모여모여~ 저희 사진 한장만 찍어주시겠어요?": null,
              "경치가 너무 아름답다! 정상을 배경으로 셀카 한장 찰칵~ 경치 사진도 찰칵~": null,
            },
          ),
          Question(
            question: "산에서 내려온 후",
            answerChoices: const {
              "운동을 하니 허기가 지네! 얼른 집에 가서 씻고 밥먹어야지!": null,
              "운동을 하니 허기가 지네! 맛집 검색해볼건데 같이 드실 분 있나요?": null,
            },
          ),
          Question(
            question: "등산을 가기 전 나의 생각은?",
            answerChoices: const {
              "산에 올라가면 다람쥐도 있고 곰도 있으려나? 근데 힘들면 어떡하지... 산불 대피요령도 찾아봐야겠다!": null,
              "힘드려나...?": null,
            },
          ),
          Question(
            question: "정상에서 내려오던 중 미끄러워 보이는 비탈길을 발견했다.",
            answerChoices: const {
              "미끄러워 보이네, 넘어지지 않게 조심하자.": null,
              "만약에 여기를 내려가다가 미끄러져서 앞에 사람과 부딪혀서 우당탕탕 넘어지면 어떡하지?": null,
            },
          ),
          Question(
            question: "등산 후 커뮤니티에서 봤던 맛집을 발견했다.",
            answerChoices: const {
              "오 그때 봤던 맛집이네. 한번 가볼까?": null,
              "오 그때 봤던 맛집이네. 저 메뉴는 이거랑 먹어야 찰떡인데! 한번 가볼까? 맛 없으면 커뮤니티 리뷰에 별 한개 빼서 줄거야!":
                  null,
            },
          ),
          Question(
            question: "등산 중 넘어진듯한 사람이 보인다.",
            answerChoices: const {
              "\"어떡해!! 괜찮으세요? 많이 놀라셨겠다... 아픈데는 없으세요?ㅠㅠ\" 넘어진 사람을 걱정해주며 진정시킨다.":
                  null,
              "\"넘어지셨나요? 혼자 일어날 수 있으세요? 상비약 있으신가요?\" 빠르게 상황파악 후 신속하게 대처한다.":
                  null,
            },
          ),
          Question(
            question: "친구와 등산 중 갈림길을 만났다. 이때 친구가 틀린길이 맞다고 우긴다면?",
            answerChoices: const {
              "(등산로 안내에서 이쪽이라는데...) 그래 거기로 가보자..!": null,
              "등산로 안내에서 이쪽이 맞다는데 왜 그쪽으로 가려하는거야? 난 이쪽으로 갈테니까 넌 그쪽으로 가.": null,
            },
          ),
          Question(
            question: "등산 중 단풍이 절경인 풍경을 봤다.",
            answerChoices: const {
              "벌써 엽록소가 파괴되는 시즌이구나. 얼른 정상에 올라가서 한눈에 봐야지": null,
              "알록달록 너무 예쁘다... 여기서 조금만 감상하다 올라가야지!": null,
            },
          ),
          Question(
            question: "친구가 같이 등산을 가자고 한다.",
            answerChoices: const {
              "좋아! 당장 고고~": null,
              "언제, 어느 산, 어느 코스로 갈거야? 내가 마운틴듀 앱으로 찾아볼게!": null,
            },
          ),
          Question(
            question: "등산에 가기 전 나는",
            answerChoices: const {
              "내가 가고싶은 산의 높이, 난이도, 위치 등을 검색하고 등산 전 유의사항 숙지, 준비물을 미리 챙긴다.": null,
              "오! 여기 산이 명산이라고? 당장 가버려!": null,
            },
          ),
          Question(
            question: "등산 후 추천 맛집을 갔는데 쉬는날이다.",
            answerChoices: const {
              "옆가게도 맛있어 보이는데 그냥 저기 갈까?": null,
              "여기서 10분 거리에 다른 가게를 알아두었으니 거기로 가야겠다.": null,
            },
          ),
        ],
        "아니오": null,
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => HomeScreen(uid: widget.uid)));
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onPressedSendButton(List<QuestionResult> questionresult, String uid) {
    SurveyModel resultdata = SurveyModel(
      gender: questionresult[0].answers[0],
      age: questionresult[1].answers[0],
      walk: questionresult[2].answers[0],
      mbti: mbtiSurvey(questionresult),
    );

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

String mbtiSurvey(List<QuestionResult> questionresult) {
  List<String> mbtiresult = [];

  // E or I
  if (questionresult[3].children[0].answers[0] ==
      "\"같이 등산가실분 구해요~!\" 커뮤니티에 글을 올려 함께 등산을 즐긴다.") {
    mbtiresult.add('E');
  } else if (questionresult[3].children[0].answers[0] ==
      "조용히 경치도 구경하고, 힘들면 잠시 쉬며 혼자만의 등산을 즐긴다.") {
    mbtiresult.add('I');
  }

  if (questionresult[3].children[1].answers[0] ==
      "인증샷은 필수지! 다같이 모여모여~ 저희 사진 한장만 찍어주시겠어요?") {
    mbtiresult.add('E');
  } else if (questionresult[3].children[1].answers[0] ==
      "경치가 너무 아름답다! 정상을 배경으로 셀카 한장 찰칵~ 경치 사진도 찰칵~") {
    mbtiresult.add('I');
  }

  if (questionresult[3].children[2].answers[0] ==
      "운동을 하니 허기가 지네! 얼른 집에 가서 씻고 밥먹어야지!") {
    mbtiresult.add('I');
  } else if (questionresult[3].children[2].answers[0] ==
      "운동을 하니 허기가 지네! 맛집 검색해볼건데 같이 드실 분 있나요?") {
    mbtiresult.add('E');
  }

  // S or N
  if (questionresult[3].children[3].answers[0] ==
      "산에 올라가면 다람쥐도 있고 곰도 있으려나? 근데 힘들면 어떡하지... 산불 대피요령도 찾아봐야겠다!") {
    mbtiresult.add('N');
  } else if (questionresult[3].children[3].answers[0] == "힘드려나...?") {
    mbtiresult.add('S');
  }

  if (questionresult[3].children[4].answers[0] == "미끄러워 보이네, 넘어지지 않게 조심하자.") {
    mbtiresult.add('S');
  } else if (questionresult[4].children[0].answers[0] ==
      "만약에 여기를 내려가다가 미끄러져서 앞에 사람과 부딪혀서 우당탕탕 넘어지면 어떡하지?") {
    mbtiresult.add('N');
  }

  if (questionresult[3].children[5].answers[0] == "오 그때 봤던 맛집이네. 한번 가볼까?") {
    mbtiresult.add('S');
  } else if (questionresult[3].children[5].answers[0] ==
      "오 그때 봤던 맛집이네. 저 메뉴는 이거랑 먹어야 찰떡인데! 한번 가볼까? 맛 없으면 커뮤니티 리뷰에 별 한개 빼서 줄거야!") {
    mbtiresult.add('N');
  }

  // T or F
  if (questionresult[3].children[6].answers[0] ==
      "\"어떡해!! 괜찮으세요? 많이 놀라셨겠다... 아픈데는 없으세요?ㅠㅠ\" 넘어진 사람을 걱정해주며 진정시킨다.") {
    mbtiresult.add('F');
  } else if (questionresult[3].children[6].answers[0] ==
      "\"넘어지셨나요? 혼자 일어날 수 있으세요? 상비약 있으신가요?\" 빠르게 상황파악 후 신속하게 대처한다.") {
    mbtiresult.add('T');
  }

  if (questionresult[3].children[7].answers[0] ==
      "(등산로 안내에서 이쪽이라는데...) 그래 거기로 가보자..!") {
    mbtiresult.add('F');
  } else if (questionresult[3].children[7].answers[0] ==
      "등산로 안내에서 이쪽이 맞다는데 왜 그쪽으로 가려하는거야? 난 이쪽으로 갈테니까 넌 그쪽으로 가.") {
    mbtiresult.add('T');
  }

  if (questionresult[3].children[8].answers[0] ==
      "벌써 엽록소가 파괴되는 시즌이구나. 얼른 정상에 올라가서 한눈에 봐야지") {
    mbtiresult.add('T');
  } else if (questionresult[3].children[8].answers[0] ==
      "알록달록 너무 예쁘다... 여기서 조금만 감상하다 올라가야지!") {
    mbtiresult.add('F');
  }

  // P or J
  if (questionresult[3].children[9].answers[0] == "좋아! 당장 고고~") {
    mbtiresult.add('P');
  } else if (questionresult[3].children[9].answers[0] ==
      "언제, 어느 산, 어느 코스로 갈거야? 내가 마운틴듀 앱으로 찾아볼게!") {
    mbtiresult.add('J');
  }

  if (questionresult[3].children[10].answers[0] ==
      "내가 가고싶은 산의 높이, 난이도, 위치 등을 검색하고 등산 전 유의사항 숙지, 준비물을 미리 챙긴다.") {
    mbtiresult.add('J');
  } else if (questionresult[3].children[10].answers[0] ==
      "오! 여기 산이 명산이라고? 당장 가버려!") {
    mbtiresult.add('P');
  }

  if (questionresult[3].children[11].answers[0] == "옆가게도 맛있어 보이는데 그냥 저기 갈까?") {
    mbtiresult.add('P');
  } else if (questionresult[3].children[11].answers[0] ==
      "여기서 10분 거리에 다른 가게를 알아두었으니 거기로 가야겠다.") {
    mbtiresult.add('J');
  }

  int sumE = 0;
  int sumN = 0;
  int sumT = 0;
  int sumP = 0;

  for (int i = 0; i < 3; i++) {
    if (mbtiresult[i] == 'E') {
      sumE++;
    }
  }

  for (int i = 3; i < 6; i++) {
    if (mbtiresult[i] == 'N') {
      sumN++;
    }
  }

  for (int i = 6; i < 9; i++) {
    if (mbtiresult[i] == 'T') {
      sumT++;
    }
  }

  for (int i = 9; i < 12; i++) {
    if (mbtiresult[i] == 'P') {
      sumP++;
    }
  }

  String mbti = '';

  if (sumE > 1) {
    mbti += 'E';
  } else {
    mbti += 'I';
  }

  if (sumN > 1) {
    mbti += 'N';
  } else {
    mbti += 'S';
  }

  if (sumT > 1) {
    mbti += 'T';
  } else {
    mbti += 'F';
  }

  if (sumP > 1) {
    mbti += 'P';
  } else {
    mbti += 'J';
  }

  return mbti;
}
