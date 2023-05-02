import 'package:flutter/material.dart';
import 'package:project/models/mountain_model.dart';
import 'package:project/src/api_service.dart';

class BadgeScreen extends StatelessWidget {
  const BadgeScreen({super.key});

  //List<Mountain2> mountainList = [];
  @override
  Widget build(BuildContext context) {
    //addList();
    startBadge();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'BADGE',
            style: TextStyle(
              fontSize: 30,
              color: Color.fromARGB(255, 10, 68, 12),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
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
                              Image.asset(
                                "images/mountain_gray.png",
                              ),
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
    Item goal = await ApiService.getItem("관악산", "연주대");
    result.add(goal);
    goal = await ApiService.getItem("소요산", "자재암");
    result.add(goal);
    goal = await ApiService.getItem("감악산", "보리암과 돌탑");
    result.add(goal);

    return result;
  }

  // void addList() {
  //   mountainList.add(Mountain2(
  //       name: "감악산",
  //       explanation: "감악산 - 의적 임꺽정이 쉬어 가던 산",
  //       location: "소재지 : 경기도 양주시 남면, 연천군 전곡읍, 파주시 적성면",
  //       height: "산높이 : 674.9m",
  //       image: "images/mountain_gray.png"));
  //   mountainList.add(Mountain2(
  //       name: "관악산",
  //       explanation: "관악산 - 수차례 화마가 쓸고 갔던 불의 산",
  //       location: "소재지 : 서울특별시 관악구ㆍ금천구, 경기도 안양시ㆍ과천시",
  //       height: "산높이 : 632.2m",
  //       image: "images/mountain_gray.png"));
  //   mountainList.add(Mountain2(
  //       name: "도봉산",
  //       explanation: "도봉산 - 거미줄처럼 얽힌 미로의 산",
  //       location: "소재지 : 서울특별시 도봉구, 경기도 의정부시 호원동ㆍ양주시 장흥면",
  //       height: "산높이 : 740.2m",
  //       image: "images/mountain_gray.png"));
  //   mountainList.add(Mountain2(
  //       name: "마니산",
  //       explanation: "마니산 - 역대 왕들이 하늘제를 올리던 산",
  //       location: "소재지 : 인천광역시 강화군 화도면",
  //       height: "산높이 : 472.1m",
  //       image: "images/mountain_gray.png"));
  //   mountainList.add(Mountain2(
  //       name: "명지산",
  //       explanation: "명지산 - 사방으로 산자락을 펼친 명지산",
  //       location: "소재지 : 경기도 가평군 북면ㆍ하면",
  //       height: "산높이 : 1252.3m",
  //       image: "images/mountain_gray.png"));
  //   mountainList.add(Mountain2(
  //       name: "백운산",
  //       explanation: "백운산 - 경기도와 강원도의 경계, 카라멜고개",
  //       location: "소재지 : 경기도 포천시 이동면, 강원도 화천군 사내면",
  //       height: "산높이 : 903.1m",
  //       image: "images/mountain_gray.png"));
  //   mountainList.add(Mountain2(
  //       name: "북한산",
  //       explanation: "북한산 - 가거라 삼각산아, 다시 보자 한강수야",
  //       location: "소재지 : 서울특별시 강북구ㆍ성북구ㆍ종로구ㆍ은평구, 경기도 고양시ㆍ양주시",
  //       height: "산높이 : 835.6",
  //       image: "images/mountain_gray.png"));
  //   mountainList.add(Mountain2(
  //       name: "소요산",
  //       explanation: "소요산 - 말발굽 모양을 한 경기도의 소금강",
  //       location: "소재지 : 경기도 동두천시, 포천시 신북면",
  //       height: "산높이 : 587.5m",
  //       image: "images/mountain_gray.png"));
  //   mountainList.add(Mountain2(
  //       name: "용문산",
  //       explanation: "용문산 - 조선 개국으로 다시 태어난 미지산",
  //       location: "소재지 : 경기도 양평군 용문면ㆍ옥천면",
  //       height: "산높이 : 1157.1m",
  //       image: "images/mountain_gray.png"));
  //   mountainList.add(Mountain2(
  //       name: "운악산",
  //       explanation: "운악산 - 구름을 뚫고 솟은 경기의 소금강",
  //       location: "소재지 : 경기도 가평군 하면, 포천시 화현면",
  //       height: "산높이 : 934.7m",
  //       image: "images/mountain_gray.png"));
  //   mountainList.add(Mountain2(
  //       name: "유명산",
  //       explanation: "유명산 - 기암괴석과 하늘을 덮는 수풀림의 조화",
  //       location: "소재지 : 경기도 가평군 설악면, 양평군 옥천면",
  //       height: "산높이 : 864m",
  //       image: "images/mountain_gray.png"));
  //   mountainList.add(Mountain2(
  //       name: "천마산",
  //       explanation: "천마산 - 스키장으로, 청소년 심신수련장으로",
  //       location: "소재지 : 경기도 남양주시 오남읍, 화도읍",
  //       height: "산높이 : 810.3m",
  //       image: "images/mountain_gray.png"));
  //   mountainList.add(Mountain2(
  //       name: "축령산",
  //       explanation: "축령산 - 남이장이 심신을 닦던 남이 바위",
  //       location: "소재지 : 경기도 남양주시 수동면, 가평군 상면",
  //       height: "산높이 : 887.1m",
  //       image: "images/mountain_gray.png"));
  //   mountainList.add(Mountain2(
  //       name: "화악산",
  //       explanation: "화악산 - 강원도와 경기도를 가르는 경기도 제 1 고봉",
  //       location: "소재지 : 경기도 가평군 북면, 강원도 화천군 사내면",
  //       height: "산높이 : 1468.3m",
  //       image: "images/mountain_gray.png"));
  // }
}
