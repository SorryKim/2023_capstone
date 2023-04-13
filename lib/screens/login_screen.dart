import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project/screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 구글 로그 이미지 삽입
                Image.asset(
                  'images/google_logo.png',
                  height: 100,
                ),
                const Text(
                  "로그인",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Google 계정 사용',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  'ID',
                ),
                // ID
                Container(
                  height: 40,
                  width: 500,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color.fromARGB(255, 61, 122, 243),
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'PASSWORD',
                ),
                // PASSWORD
                Container(
                  height: 40,
                  width: 500,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color.fromARGB(255, 61, 122, 243),
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                // 구글 로그인하는 버튼
                ElevatedButton(
                  onPressed: () {
                    signInWithGoogle();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()));
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      left: 150,
                      right: 150,
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 61, 122, 243),
                  ),
                  child: const Text(
                    "➡️",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
