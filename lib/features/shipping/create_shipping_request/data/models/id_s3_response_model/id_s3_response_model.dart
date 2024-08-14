import 'data.dart';

class IdS3ResponseModel {
  bool? status;
  Data? data;

  IdS3ResponseModel({this.status, this.data});

  factory IdS3ResponseModel.fromJson(Map<String, dynamic> json) {
    return IdS3ResponseModel(
      status: json['status'] as bool?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data?.toJson(),
      };
}
