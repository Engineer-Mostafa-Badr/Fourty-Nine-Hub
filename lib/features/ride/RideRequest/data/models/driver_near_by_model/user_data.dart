class UserData {
  String? id;
  String? userPicture;
  String? socketId;
  bool? isReady;

  UserData({this.id, this.userPicture, this.socketId, this.isReady});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json['id'] as String?,
        userPicture: json['userPicture'] as String?,
        socketId: json['socketId'] as String?,
        isReady: json['isReady'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userPicture': userPicture,
        'socketId': socketId,
        'isReady': isReady,
      };
}
