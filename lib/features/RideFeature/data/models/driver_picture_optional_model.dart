import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_picture_optional_entity.dart';

class DriverPictureOptionalModel extends DriverPictureOptionalEntity{
  DriverPictureOptionalModel({required super.openDrugAnalysis,required super.openCriminalRecord,required super.openTechnicalExamination, required super.drugAnalysisAddress, required super.drugAnalysisPhone, required super.technicalExaminationAddress, required super.technicalExaminationPhone});

  //fromJson
  factory DriverPictureOptionalModel.fromJson(Map<String,dynamic> json){
    return DriverPictureOptionalModel(
        openDrugAnalysis: json["DragAnalytics"]!=null?json["DragAnalytics"]['open']:false,
        drugAnalysisAddress: json["DragAnalytics"]!=null?json["DragAnalytics"]['address']:'',
        drugAnalysisPhone: json["DragAnalytics"]!=null?json["DragAnalytics"]['phone']:'',
        openCriminalRecord: json["CriminalRecord"]!=null?json["CriminalRecord"]['open']:false,
        openTechnicalExamination: json["TechnicalExamination"]!=null?json["TechnicalExamination"]['open']:false,
        technicalExaminationAddress: json["TechnicalExamination"]!=null?json["TechnicalExamination"]['address']:'',
        technicalExaminationPhone: json["TechnicalExamination"]!=null?json["TechnicalExamination"]['phone']:''
    );
  }

}