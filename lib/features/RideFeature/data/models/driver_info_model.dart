import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_info_entity.dart';

class DriverInfoModel extends DriverInfoEntity{
  DriverInfoModel({required super.isApproved,required super.status, required super.isUploadDriverId, required super.isUploadDriverImage, required super.isUploadDriverLicense, required super.isUploadConfirmIdentifier, required super.isUploadCarImage, required super.isUploadCarLicense, required super.isUploadDrugAnalysis, required super.isUploadCriminalRecord, required super.isUploadTechnicalExamination,required super.driverType});

  //fromJson
  factory DriverInfoModel.fromJson(Map<String, dynamic> json) {
    return DriverInfoModel(
        isApproved: json['isApproved'] ?? false,
        status: json['status'] ?? '',
        driverType: json['driverType'] ?? '',
        isUploadDriverId: json['isDriverIdentityUploaded'] ?? false,
        isUploadDriverImage: json['driverPictureKey'] ?? false,
        isUploadDriverLicense: json['isDrivingLicenseUploaded'] ?? false,
        isUploadConfirmIdentifier: json['confirmIdentityKey'] ?? false,
        isUploadCarImage: json['isUploadedCarPictures'] ?? false,
        isUploadCarLicense: json['isCarLicenseUploaded'] ?? false,
        isUploadDrugAnalysis: json['isDrugAnalysisUploaded'] ?? false,
        isUploadCriminalRecord: json['isCriminalRecordUploaded'] ?? false,
        isUploadTechnicalExamination: json['isTechnicalExaminationUploaded'] ?? false);
  }
}