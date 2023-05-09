import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/information_screen.dart';
import 'package:project/screens/login_screen.dart';

class LobbyScreen extends StatefulWidget {
  final String uid;
  const LobbyScreen({super.key, required this.uid});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final user = FirebaseAuth.instance.currentUser;
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoginScreen();
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'MOUNTAINDEW',
                  style: TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 10, 68, 12),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              InformationScreen(uid: widget.uid)));
                    },
                    color: const Color.fromARGB(255, 10, 68, 12),
                    iconSize: 40,
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 500),
                        firstChild: Image.asset('images/6249016.jpg'),
                        secondChild: Image.asset('images/6229893.jpg'),
                        crossFadeState: selected
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('사용자 맞춤 등산로 추천 1'),
                      Container(
                        height: 100,
                        width: 520,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color.fromARGB(255, 10, 68, 12),
                            style: BorderStyle.solid,
                            width: 2,
                          ),
                        ),
                      ),
                      const Text('사용자 맞춤 등산로 추천 2'),
                      Container(
                        height: 100,
                        width: 520,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color.fromARGB(255, 10, 68, 12),
                            style: BorderStyle.solid,
                            width: 2,
                          ),
                        ),
                      ),
                      const Text('사용자 맞춤 등산로 추천 3'),
                      Container(
                        height: 100,
                        width: 520,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color.fromARGB(255, 10, 68, 12),
                            style: BorderStyle.solid,
                            width: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
