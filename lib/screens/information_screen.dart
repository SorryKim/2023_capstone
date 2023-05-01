import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/models/survey_model.dart';
import 'package:project/screens/login_screen.dart';

class InformationScreen extends StatefulWidget {
  final String uid;
  const InformationScreen({super.key, required this.uid});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoginScreen();
          } else {
            getGender(widget.uid);
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  '내 정보',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: const Color.fromARGB(255, 10, 68, 12),
                elevation: 0.0,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Container(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  clipBehavior: Clip.hardEdge,
                                  height: 120,
                                  width: 120,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          const Color.fromARGB(255, 53, 53, 53),
                                      style: BorderStyle.solid,
                                      width: 5,
                                    ),
                                  ),
                                  // TODO: 성별에 따라 ~~~~~
                                  child: getFace("남자"),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        '등산천재! ${user!.displayName}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'Lv1. 초보 등산러 😊',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 3.0,
                              width: 500.0,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 6,
                                ),
                                Column(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.logout),
                                      iconColor: Colors.black,
                                      focusColor: Colors.black,
                                      title: const Text(
                                        '로그아웃',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      onTap: () {},
                                      trailing: const Icon(Icons.navigate_next),
                                    ),
                                  ],
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
        });
  }

  Widget getFace(gender) {
    switch (gender) {
      case '남자':
        return const Icon(
          Icons.face,
          size: 80,
          color: Color.fromARGB(255, 0, 0, 0),
        );
      default:
        return const Icon(
          Icons.face_4,
          size: 80,
          color: Color.fromARGB(255, 0, 0, 0),
        );
    }
  }

  // TODO: 구현해줘~~~~~~
  Stream getGender(String uid) {
    Stream<QuerySnapshot> snapshots =
        FirebaseFirestore.instance.collection('user/$uid/survey').snapshots();

    List<SurveyModel> gender = [];

    return snapshots.map((querySnapshot) {
      for (var element in querySnapshot.docs) {
        gender.add(SurveyModel.fromMap(
            id: element.id, map: element.data() as Map<String, dynamic>));
      }
      return gender;
    });
  }
}
