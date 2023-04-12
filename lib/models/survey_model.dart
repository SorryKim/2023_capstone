class SurveyModel {
  final String id;
  final String gender;
  final String age;

 SurveyModel({this.id = ' ', this.gender = ' ', this.age = ' '});

  factory SurveyModel.fromMap({
    required String id,
    required Map<String, dynamic> map,
  }) {
    return SurveyModel(
      id: id,
      gender: map['gender'] ?? ' ',
      age: map['age'] ?? ' ',
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data["age"] = age;
    data["gender"] = gender;
    return data;
  }
}
