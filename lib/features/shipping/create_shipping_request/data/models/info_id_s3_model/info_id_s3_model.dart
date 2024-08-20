import 'id_behind.dart';
import 'id_front.dart';

class InfoIdS3Model {
  String? expireDate;
  IdFront? idFront;
  IdBehind? idBehind;

  InfoIdS3Model({this.expireDate, this.idFront, this.idBehind});

  factory InfoIdS3Model.fromJson(Map<String, dynamic> json) => InfoIdS3Model(
        expireDate: json['expireDate'] as String?,
        idFront: json['idFront'] == null
            ? null
            : IdFront.fromJson(json['idFront'] as Map<String, dynamic>),
        idBehind: json['idBehind'] == null
            ? null
            : IdBehind.fromJson(json['idBehind'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'expireDate': expireDate,
        'idFront': idFront?.toJson(),
        'idBehind': idBehind?.toJson(),
      };
}
