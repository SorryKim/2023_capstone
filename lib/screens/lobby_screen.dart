import 'package:flutter/material.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
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
                              color: const Color.fromARGB(255, 53, 53, 53),
                              style: BorderStyle.solid,
                              width: 5,
                            ),
                          ),
                          child: const Icon(
                            Icons.face,
                            size: 80,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        const Center(
                          child: Column(
                            children: [
                              Text(
                                '등산천재 김재성',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
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
                        Column(
                          children: [
                            const Text('사용자 맞춤 등산로 추천 1'),
                            Container(
                              height: 90,
                              width: 520,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 236, 83, 18),
                                  style: BorderStyle.solid,
                                  width: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Column(
                          children: [
                            const Text('사용자 맞춤 등산로 추천 2'),
                            Container(
                              height: 90,
                              width: 520,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 255, 208, 66),
                                  style: BorderStyle.solid,
                                  width: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Column(
                          children: [
                            const Text('사용자 맞춤 등산로 추천 3'),
                            Container(
                              height: 90,
                              width: 520,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.green,
                                  style: BorderStyle.solid,
                                  width: 2,
                                ),
                              ),
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
}
