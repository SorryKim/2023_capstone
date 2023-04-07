import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityModel {
  final String id;
  final String message;
  final Timestamp sendDate;

  CommunityModel({
    this.id = '',
    this.message = '',
    Timestamp? sendDate,
  }) : sendDate = sendDate ?? Timestamp(0, 0);

  factory CommunityModel.fromMap(
      {required String id, required Map<String, dynamic> map}) {
    return CommunityModel(
      id: id,
      message: map['message'] ?? '',
      sendDate: map['sendDate'] ?? Timestamp(0, 0),
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['message'] = message;
    data['sendDate'] = sendDate;
    return data;
  }
}
