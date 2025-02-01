import 'package:fourtyninehub/features/ride/Authentication/data/models/part_model.dart';

class PartsSocketModel {
  PartModel? basicInfo;
  PartModel? driverLicence;
  PartModel? carLicence;
  // PartModel? vehicleInfo;
  // PartModel? referralCode;
  PartModel? dragAnalysisPart;
  PartModel? moreInfo;
  PartsSocketModel(
      {this.basicInfo,
      this.carLicence,
      this.driverLicence,
      this.moreInfo,
      this.dragAnalysisPart});
  factory PartsSocketModel.fromJson(Map<String, dynamic> json) {
    return PartsSocketModel(
        basicInfo: PartModel.fromJson(json: json['basicInfo'], type: "basicInfo"),
        carLicence: PartModel.fromJson(json: json['carLicence'], type: "carLicence"),
        dragAnalysisPart: PartModel.fromJson(json: json['dragAnalysisPart'], type: "dragAnalysisPart"),
        driverLicence: PartModel.fromJson(json: json['driverLicence'], type: "driverLicence"),
        moreInfo: PartModel.fromJson(json: json['moreInfo'], type: 'moreInfo'));
  }
  toJson() {
    return {
      "basicInfo": {
        "part": basicInfo?.part.toJson(),
        "active": basicInfo?.active ?? false
      },
      "carLicence": {
        "part": carLicence?.part.toJson(),
        "active": carLicence?.active ?? false
      },
      "driverLicence": {
        "part": driverLicence?.part.toJson(),
        "active": driverLicence?.active ?? false
      },
      "moreInfo": {
        "part": moreInfo?.part.toJson(),
        "active": moreInfo?.active ?? false
      },
      "dragAnalysisPart": {
        "part": dragAnalysisPart?.part.toJson(),
        "active": dragAnalysisPart?.active ?? false
      },
    };
  }

  PartsSocketModel copyWith({
    PartModel? basicInfo,
    PartModel? driverLicence,
    PartModel? carLicence,
    PartModel? dragAnalysisPart,
    PartModel? moreInfo,
  }) {
    return PartsSocketModel(
      basicInfo: basicInfo??this.basicInfo,
      carLicence: carLicence??this.carLicence,
      dragAnalysisPart: dragAnalysisPart??this.dragAnalysisPart,
      driverLicence: driverLicence??this.driverLicence,
      moreInfo: moreInfo??this.moreInfo
    );
  }
}
