import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    FutureBuilder(
                      future: getGender(widget.uid),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(fontSize: 15),
                            ),
                          );
                        } else {
                          return Center(
                            child: getFace(snapshot.data.toString()),
                          );
                        }
                      },
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
                        const Card(
                          child: ListTile(
                            leading: Text(
                              '이메일',
                              style: TextStyle(
                                  fontSize: 15, fontFamily: 'SCDream4'),
                            ),
                            trailing: Text(
                              '김재성씨 이메일좀 넣어주세요',
                              style: TextStyle(
                                  fontSize: 15, fontFamily: 'SCDream4'),
                            ),
                          ),
                        ),
                        const Card(
                          child: ListTile(
                            leading: Text(
                              'MBTI',
                              style: TextStyle(
                                  fontSize: 15, fontFamily: 'SCDream4'),
                            ),
                            trailing: Text(
                              '최덕봉씨 엠비티아이 넣어줘용',
                              style: TextStyle(
                                  fontSize: 15, fontFamily: 'SCDream4'),
                            ),
                          ),
                        ),
                        const Card(
                          child: ListTile(
                            leading: Text(
                              '배지',
                              style: TextStyle(
                                  fontSize: 15, fontFamily: 'SCDream4'),
                            ),
                            trailing: Text(
                              '7/10처럼 표시해쥬 누군가가',
                              style: TextStyle(
                                  fontSize: 15, fontFamily: 'SCDream4'),
                            ),
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
              ),
            ),
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
  Future<String> getGender(String uid) async {
    var data =
        await FirebaseFirestore.instance.collection('user/$uid/survey').get();

    List<dynamic> details = data.docs.toList();
    print(details);
    print(widget.uid);
    String temp = details[0].id;

    var result = await FirebaseFirestore.instance
        .collection('user/$uid/survey/')
        .doc(temp)
        .get();
    var gender = result.data();
    return gender!['gender'];
  }
}
