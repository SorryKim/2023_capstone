import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  String difficulty = "하";
  final String baseUrl =
      "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_L_FRSTCLIMB&key=FD8BE812-DB52-328F-828B-712A51614E8A&emdCd=11620103&crs=EPSG:3857&geomFilter=LINESTRING(13133057.313802%204496529.073264,14133023.872602%204496514.7413212)&geometry=false&attrFilter=cat_nam:like:하";

  void getMountains() async {
    try {
      final url = Uri.parse(baseUrl);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);

        final List<dynamic> mountains = jsonDecode(responseBody)['response']
            ['result']['featureCollection']['features'];

        for (var mountain in mountains) {
          print(mountain['properties']);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void setDifficulty(String diff) {
    difficulty = diff;
  }
}
