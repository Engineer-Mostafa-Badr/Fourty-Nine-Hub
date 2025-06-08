class LoadingInfoEntity{
  bool? isApproved;
  String? status;
  bool? isUploadDriverId;
  bool? isUploadDriverLicense;
  bool? isUploadCarImage;
  bool? isUploadCarLicense;
  bool? isUploadDriverImage;

  LoadingInfoEntity({
    this.isApproved=false,
    this.status='',
    this.isUploadDriverId=false,
    this.isUploadDriverLicense=false,
    this.isUploadCarImage=false,
    this.isUploadCarLicense=false,
    this.isUploadDriverImage=false,
  });

  //toJson
  Map<String, dynamic> toJson() => {
    'isApproved': isApproved,
    'status': status,
    'isUploadDriverId': isUploadDriverId,
    'isUploadDriverLicense': isUploadDriverLicense,
    'isUploadCarImage': isUploadCarImage,
    'isUploadCarLicense': isUploadCarLicense,
    'isUploadDriverImage': isUploadDriverImage,
  };
}