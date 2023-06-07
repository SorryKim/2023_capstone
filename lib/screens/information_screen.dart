import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project/screens/add_screen.dart';
import 'package:project/screens/login_screen.dart';

class InformationScreen extends StatefulWidget {
  final String uid;
  const InformationScreen({super.key, required this.uid});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> logout() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut().then((value) => Navigator.of(context)
        .pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: Colors.redAccent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: getUserSurveyData(widget.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data;

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: getFace(data['gender']),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                            height: 1.0,
                            width: 500.0,
                            color: Colors.black26,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: <Widget>[
                              Card(
                                child: ListTile(
                                  leading: const Text(
                                    '이름',
                                    style: TextStyle(
                                        fontSize: 15, fontFamily: 'SCDream4'),
                                  ),
                                  trailing: Text(
                                    '${user!.displayName}',
                                    style: const TextStyle(
                                        fontSize: 15, fontFamily: 'SCDream4'),
                                  ),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading: const Text(
                                    '이메일',
                                    style: TextStyle(
                                        fontSize: 15, fontFamily: 'SCDream4'),
                                  ),
                                  trailing: Text(
                                    user!.email.toString(),
                                    style: const TextStyle(
                                        fontSize: 15, fontFamily: 'SCDream4'),
                                  ),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading: const Text(
                                    '등산 성향(MBTI)',
                                    style: TextStyle(
                                        fontSize: 15, fontFamily: 'SCDream4'),
                                  ),
                                  trailing: Text(
                                    data['mbti'],
                                    style: const TextStyle(
                                        fontSize: 15, fontFamily: 'SCDream4'),
                                  ),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading: const Text(
                                    '배지',
                                    style: TextStyle(
                                        fontSize: 15, fontFamily: 'SCDream4'),
                                  ),
                                  trailing: FutureBuilder(
                                      future: getbadgeScore(widget.uid),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(snapshot.data);
                                        }
                                        return const Text(
                                          '',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'SCDream4'),
                                        );
                                      }),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading: const Text(
                                    '개발전용',
                                    style: TextStyle(
                                        fontSize: 15, fontFamily: 'SCDream4'),
                                  ),
                                  trailing: const Text(
                                    '등산로 데이터 추가',
                                    style: TextStyle(
                                        fontSize: 15, fontFamily: 'SCDream4'),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => const AddScreen()));
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 100,
                              ),
                              Card(
                                child: ListTile(
                                  leading: const Text(
                                    '로그아웃',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'SCDream4',
                                        color: Colors.red),
                                  ),
                                  onTap: () async {
                                    logout();
                                  },
                                  trailing: const Icon(Icons.navigate_next),
                                  iconColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget getFace(String gender) {
    if (gender == '남자') {
      return const Icon(
        Icons.face,
        size: 80,
        color: Color.fromARGB(255, 0, 0, 0),
      );
    } else {
      return const Icon(
        Icons.face_4,
        size: 80,
        color: Color.fromARGB(255, 0, 0, 0),
      );
    }
  }

  // DB에서 사용자의 성별 가져오기
  Future<dynamic> getUserSurveyData(String uid) async {
    var data =
        await FirebaseFirestore.instance.collection('user/$uid/survey').get();

    List<dynamic> details = data.docs.toList();
    String temp = details[0].id;

    var result = await FirebaseFirestore.instance
        .collection('user/$uid/survey/')
        .doc(temp)
        .get();
    var gender = result.data();
    return gender;
  }

  Future<dynamic> getbadgeScore(String uid) async {
    var data = await FirebaseFirestore.instance.doc('user/$uid').get();

    var score = data.data();
    return score!['badgeScore'];
  }
}
