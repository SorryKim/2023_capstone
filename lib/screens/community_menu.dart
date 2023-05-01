import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/models/community_model.dart';
import 'package:project/screens/comment_screen.dart';

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
