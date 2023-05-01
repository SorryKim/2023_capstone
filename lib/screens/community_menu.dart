import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommunityMenu extends StatefulWidget {
  const CommunityMenu({super.key});

  @override
  State<CommunityMenu> createState() => _CommunityMenuState();
}

class _CommunityMenuState extends State<CommunityMenu> {
  final user = FirebaseAuth.instance.currentUser;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Center(
          child: Text('메뉴'),
        ),
      ),
    );
  }
}
