import 'package:flutter/material.dart';
import 'package:project/models/mountain_model.dart';
import 'package:project/src/api_service.dart';
import 'package:geolocator/geolocator.dart';

class BadgeScreen extends StatefulWidget {
  const BadgeScreen({super.key});

  @override
  State<BadgeScreen> createState() => _BadgeScreenState();
}

class _BadgeScreenState extends State<BadgeScreen> {
  late double longitude;

  late double latitude;

  //List<Mountain2> mountainList = [];
  @override
  Widget build(BuildContext context) {
    //addList();
    startBadge();
    return Scaffold(
      appBar: AppBar(title: const Text('뱃지')),
      body: FutureBuilder(
          future: startBadge(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Item> mountainList = snapshot.data!;
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      "100대 명산",
                      style: TextStyle(
                        fontSize: 27,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      itemCount: mountainList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 0.65,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          child: Column(
                            children: [
                              Image.asset(swapImage(
                                  mountainList.elementAt(index).lot,
                                  mountainList.elementAt(index).lat)),
                              Container(
                                height: 25,
                                alignment: Alignment.center,
                                child: Text(
                                  mountainList.elementAt(index).frtrlNm!,
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            AlertDialog dialog = AlertDialog(
                              content: Text(
                                '설명: ${mountainList.elementAt(index).dscrtCn}\n위도: ${mountainList.elementAt(index).lat}\n경도: ${mountainList.elementAt(index).lot}\n해발고도: ${mountainList.elementAt(index).aslAltide}',
                                style: const TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            );
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => dialog);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Future<List<Item>> startBadge() async {
    List<Item> result = [];
    Item goal = await ApiService.getItem("감악산", "보리암과 돌탑");
    result.add(goal);
    goal = await ApiService.getItem("관악산", "연주대");
    result.add(goal);
    goal = await ApiService.getItem("도봉산", "명수대(明水臺)");
    result.add(goal);
    goal = await ApiService.getItem("마니산", "참성단 중수비");
    result.add(goal);
    goal = await ApiService.getItem("명성산", "평화의쉼터");
    result.add(goal);
    goal = await ApiService.getItem("명지산", "포천으로 가는 강씨봉고개(오뚜기고개)");
    result.add(goal);
    goal = await ApiService.getItem("백운산", "자재암");
    result.add(goal);
    goal = await ApiService.getItem("북한산", "자재암");
    result.add(goal);
    goal = await ApiService.getItem("소요산", "자재암");
    result.add(goal);
    goal = await ApiService.getItem("용문산", "자재암");
    result.add(goal);
    goal = await ApiService.getItem("운악산", "자재암");
    result.add(goal);
    goal = await ApiService.getItem("유명산", "자재암");
    result.add(goal);
    goal = await ApiService.getItem("천마산", "자재암");
    result.add(goal);
    goal = await ApiService.getItem("축령산", "자재암");
    result.add(goal);
    goal = await ApiService.getItem("화악산", "자재암");
    result.add(goal);

    return result;
  }

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    longitude = position.longitude;
    latitude = position.latitude;
  }

  String swapImage(lot, lat) {
    getLocation();
    if (lot == longitude && lat == latitude) {
      return "image/mountain.png";
    } else {
      return "image/mountain_gray.png";
    }
  }
}
