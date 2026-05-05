class WatchDeviceData {
  final String id;
  final String deviceName;
  final bool isNearby;

  WatchDeviceData({
    required this.id,
    required this.deviceName,
    this.isNearby = false,
  });

  factory WatchDeviceData.fromJson(Map<String, dynamic> json) {
    return WatchDeviceData(
      id: json['id'],
      deviceName: json['displayName'],
      isNearby: json['isNearby'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'displayName': deviceName,
    'isNearby': isNearby,
  };
}
