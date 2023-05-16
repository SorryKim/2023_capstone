class MountainsModel {
  final String id;
  final String difficulty;
  final String mntnName;
  final String info;
  final int distance;
  final double timeTaken;
  final double latitude;
  final double longitude;

  MountainsModel({
    this.id = '',
    this.difficulty = '',
    this.mntnName = '',
    this.info = '',
    this.timeTaken = 0,
    this.distance = 0,
    this.latitude = 0,
    this.longitude = 0,
  });

  factory MountainsModel.fromMap(
      {required String id, required Map<String, dynamic> map}) {
    return MountainsModel(
      id: id,
      difficulty: map['difficulty'] ?? '',
      mntnName: map['mntnName'] ?? '',
      info: map['info'] ?? '',
      timeTaken: map['timeTaken'] ?? 0,
      distance: map['distance'] ?? 0,
      latitude: map['latitude'] ?? 0,
      longitude: map['longitude'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['difficulty'] = difficulty;
    data['mntnName'] = mntnName;
    data['info'] = info;
    data['timeTaken'] = timeTaken;
    data['distance'] = distance;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
