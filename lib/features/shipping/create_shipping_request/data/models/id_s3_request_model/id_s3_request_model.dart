import 'id_behind.dart';
import 'id_front.dart';

class IdS3RequestModel {
  String? expireDate;
  IdFront? idFront;
  IdBehind? idBehind;

  IdS3RequestModel({this.expireDate, this.idFront, this.idBehind});

  factory IdS3RequestModel.fromJson(Map<String, dynamic> json) {
    return IdS3RequestModel(
      expireDate: json['expireDate'] as String?,
      idFront: json['idFront'] == null
          ? null
          : IdFront.fromJson(json['idFront'] as Map<String, dynamic>),
      idBehind: json['idBehind'] == null
          ? null
          : IdBehind.fromJson(json['idBehind'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'expireDate': expireDate,
        'idFront': idFront?.toJson(),
        'idBehind': idBehind?.toJson(),
      };
}
