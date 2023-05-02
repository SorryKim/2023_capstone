import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project/models/mountain_model.dart';

class ApiService {
  static const String baseUrl =
      "https://apis.data.go.kr/B553662/sghtngPoiInfoService/getSghtngPoiInfoList?serviceKey=Sb7G4O4pB2rhu5whM8wWWzT28nQqHRuLodDkvYFeSP0vTZTRDqgvquO00DLyYmYq0Ql0n%2BGI7j7ZyP0LqGzjKw%3D%3D&type=json&numOfRows=500&srchFrtrlNm=";
  static String mntnName = "관악산";

  void setMntn(String s) {
    mntnName = s;
  }

  static Future<Item> getItem(String mntnName, String goal) async {
    final url = Uri.parse('$baseUrl$mntnName');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final items =
          jsonDecode(response.body)['response']['body']['items']['item'];
      late Item result;

      for (var item in items) {
        final instance = Item.fromJson(item);
        if (instance.placeNm == goal) {
          result = instance;
        }
      }

      return result;
    }

    throw Error();
  }
}
