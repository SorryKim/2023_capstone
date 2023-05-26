class LoginModel {
  final String id;
  final String userName;
  final String userId;
  bool isSurvey;
  late List<String> list;

  LoginModel({
    this.id = '',
    this.userName = '',
    this.userId = '',
    this.isSurvey = false,
  });

  factory LoginModel.fromMap(
      {required String id, required Map<String, dynamic> map}) {
    return LoginModel(
      id: id,
      userName: map['userName'] ?? '',
      userId: map['userId'] ?? '',
      isSurvey: map['isSurvey'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['userName'] = userName;
    data['userId'] = userId;
    data['isSurvey'] = isSurvey;
    return data;
  }
}
