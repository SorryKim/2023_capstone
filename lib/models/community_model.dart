import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityModel {
  final String id;
  final String message;
  final Timestamp sendDate;
  final String userName;
  final String userId;
  final int like;
  final int dislike;
  late List<String> list;

  CommunityModel({
    this.id = '',
    this.message = '',
    this.userName = '',
    this.userId = '',
    this.like = 0,
    this.dislike = 0,
    Timestamp? sendDate,
  }) : sendDate = sendDate ?? Timestamp(0, 0);

  factory CommunityModel.fromMap(
      {required String id, required Map<String, dynamic> map}) {
    return CommunityModel(
      id: id,
      message: map['message'] ?? '',
      sendDate: map['sendDate'] ?? Timestamp(0, 0),
      userName: map['userName'] ?? '',
      userId: map['userId'] ?? '',
      like: map['like'] ?? 0,
      dislike: map['dislike'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['message'] = message;
    data['sendDate'] = sendDate;
    data['userName'] = userName;
    data['userId'] = userId;
    data['like'] = like;
    data['dislike'] = dislike;
    return data;
  }
}
