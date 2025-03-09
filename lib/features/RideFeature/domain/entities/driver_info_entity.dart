class DriverInfoEntity{
  bool? isApproved;
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
}