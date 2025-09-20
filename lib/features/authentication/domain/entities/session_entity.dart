class SessionEntity {
  String? refreshToken;
  String? deviceId;
  String? deviceName;
  String? platform;
  double? loginLat;
  double? loginLng;
  String? loginAddress;
  DateTime? createdAt;

  SessionEntity({this.refreshToken, this.deviceId, this.deviceName, this.platform, this.loginLat, this.loginLng, this.loginAddress, this.createdAt});
}