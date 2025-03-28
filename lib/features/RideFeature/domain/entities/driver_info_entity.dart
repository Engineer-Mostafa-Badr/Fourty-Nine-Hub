class DriverInfoEntity{
  bool? isApproved;
  String? status;
  String? driverType;
  bool? isUploadDriverId;
  bool? isUploadDriverImage;
  bool? isUploadDriverLicense;
  bool? isUploadConfirmIdentifier;
  bool? isUploadCarImage;
  bool? isUploadCarLicense;
  bool? isUploadDrugAnalysis;
  bool? isUploadCriminalRecord;
  bool? isUploadTechnicalExamination;

  DriverInfoEntity({
    this.isApproved=false,
    this.status='',
    this.driverType='non-socket',
    this.isUploadDriverId=false,
    this.isUploadDriverImage=false,
    this.isUploadDriverLicense=false,
    this.isUploadConfirmIdentifier=false,
    this.isUploadCarImage=false,
    this.isUploadCarLicense=false,
    this.isUploadDrugAnalysis=false,
    this.isUploadCriminalRecord=false,
    this.isUploadTechnicalExamination=false,
  });

  //toJson
  Map<String, dynamic> toJson() => {
    'isApproved': isApproved,
    'status': status,
    'driverType': driverType,
    'isUploadDriverId': isUploadDriverId,
    'isUploadDriverImage': isUploadDriverImage,
    'isUploadDriverLicense': isUploadDriverLicense,
    'isUploadConfirmIdentifier': isUploadConfirmIdentifier,
    'isUploadCarImage': isUploadCarImage,
    'isUploadCarLicense': isUploadCarLicense,
    'isUploadDrugAnalysis': isUploadDrugAnalysis,
    'isUploadCriminalRecord': isUploadCriminalRecord,
    'isUploadTechnicalExamination': isUploadTechnicalExamination,
  };
}