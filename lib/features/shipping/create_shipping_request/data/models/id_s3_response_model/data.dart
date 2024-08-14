import 'id_behind_data.dart';
import 'id_front_data.dart';

class Data {
  IdFrontData? idFrontData;
  IdBehindData? idBehindData;

  Data({this.idFrontData, this.idBehindData});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        idFrontData: json['idFrontData'] == null
            ? null
            : IdFrontData.fromJson(json['idFrontData'] as Map<String, dynamic>),
        idBehindData: json['idBehindData'] == null
            ? null
            : IdBehindData.fromJson(
                json['idBehindData'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'idFrontData': idFrontData?.toJson(),
        'idBehindData': idBehindData?.toJson(),
      };
}
