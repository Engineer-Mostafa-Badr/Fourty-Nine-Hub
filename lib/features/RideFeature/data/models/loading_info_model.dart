import 'package:fourtyninehub/features/RideFeature/domain/entities/loading_info_entity.dart';

class LoadingInfoModel extends LoadingInfoEntity{
  LoadingInfoModel({required super.isApproved,required super.status, required super.isUploadDriverId, required super.isUploadDriverLicense, required super.isUploadCarImage, required super.isUploadCarLicense});

  //fromJson
  factory LoadingInfoModel.fromJson(Map<String, dynamic> json) => LoadingInfoModel(
      isApproved: json['isApproved'] ?? false,
      status: json['status'] ?? '',
      isUploadDriverId: json['documentsStatus']!=null?json['documentsStatus']['isUploadDriverId']??false:false,
      isUploadDriverLicense: json['documentsStatus']!=null?json['documentsStatus']['isUploadDriverLicense'] ?? false:false,
      isUploadCarImage: json['documentsStatus']!=null?json['documentsStatus']['isUploadCarLicense'] ?? false:false,
      isUploadCarLicense: json['documentsStatus']!=null?json['documentsStatus']['isCarLicenseUploaded'] ?? false:false,
  );
}