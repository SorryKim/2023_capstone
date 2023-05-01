import 'package:flutter/material.dart';
import 'package:project/models/mountain_model.dart';
import 'package:project/src/api_service.dart';

class BadgeScreen extends StatelessWidget {
  BadgeScreen({super.key});

  Future<List<Item>> items = ApiService.getItems();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('뱃지')),
      body: FutureBuilder(
          future: items,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  for (var temp in snapshot.data!) Text(temp.lot!.toString()),
                ],
              );
            } else if (snapshot.hasError) {
              throw Error();
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
