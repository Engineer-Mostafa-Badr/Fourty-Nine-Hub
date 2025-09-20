import 'package:fourtyninehub/features/authentication/domain/entities/session_entity.dart';

class SessionModel extends SessionEntity{
  /*
  {
                "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0eXBlIjoicmVmcmVzaCIsImp0aSI6IjJiNTBiZTAyLTczMjQtNDQyMy1iZWZkLTA3MTFhODEwYWNlYiIsImlhdCI6MTc1ODI4OTM3MiwiZXhwIjoxNzU4ODk0MTcyLCJzdWIiOiI2NzBiZmRmYjhkMTA0MWYzMTZjYTNlN2MifQ.lZ2AclGie3cCPfAsmvq2J1Od2hFUMCqh8jE83EVV2hY",
                "deviceId": "1f81c7b3-50a2-41cc-92cd-ce15f95cbcfe",
                "deviceName": "Postman",
                "platform": "ios",
                "loginLat": 30.028169278706844,
                "loginLng": 31.23734716541825,
                "loginAddress": "korba",
                "createdAt": "2025-09-19T13:42:52.197Z"
            },
  */

  SessionModel({
    required super.refreshToken,
    required super.deviceId,
    required super.deviceName,
    required super.platform,
    required super.loginLat,
    required super.loginLng,
    required super.loginAddress,
    required super.createdAt,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      refreshToken: json['refreshToken'],
      deviceId: json['deviceId'],
      deviceName: json['deviceName'],
      platform: json['platform'],
      loginLat: json['loginLat'],
      loginLng: json['loginLng'],
      loginAddress: json['loginAddress'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']).toLocal() : null,
    );
  }
}