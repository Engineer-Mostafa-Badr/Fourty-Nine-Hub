class UserData {
  String? id;
  String? userPicture;
  String? socketId;

  UserData({this.id, this.userPicture, this.socketId});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json['id'] as String?,
        userPicture: json['userPicture'] as String?,
        socketId: json['socketId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userPicture': userPicture,
        'socketId': socketId,
      };
}
