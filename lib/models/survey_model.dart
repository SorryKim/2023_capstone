class SurveyModel {
  final String id;
  final String gender;
  final String age;
  final String walk;
  final String mbti;

  SurveyModel({
    this.id = ' ',
    this.gender = ' ',
    this.age = ' ',
    this.walk = ' ',
    this.mbti = ' ',
  });

  factory SurveyModel.fromMap({
    required String id,
    required Map<String, dynamic> map,
  }) {
    return SurveyModel(
      id: id,
      gender: map['gender'] ?? ' ',
      age: map['age'] ?? ' ',
      walk: map['walk'] ?? ' ',
      mbti: map['mbti'] ?? ' ',
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data["age"] = age;
    data["gender"] = gender;
    data["walk"] = walk;
    data["mbti"] = mbti;
    return data;
  }
}
