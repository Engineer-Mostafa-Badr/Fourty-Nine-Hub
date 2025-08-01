enum RecordStatusEnum { nationalId, drivingLicense, carLicense, criminalRecord, drugAnalysis, technicalExamination }
enum DriverUpdateRequestStatusEnum { PENDING, APPROVED, REJECTED}

extension ReportsEnumExtention on RecordStatusEnum {
  String get status {
    switch (this) {
      case RecordStatusEnum.nationalId:
        return 'National_ID';
      case RecordStatusEnum.drivingLicense:
        return 'DRIVING_LICENSE';
      case RecordStatusEnum.carLicense:
        return 'CAR_LICENSE';
      case RecordStatusEnum.criminalRecord:
        return 'CRIMINAL_RECORD';
      case RecordStatusEnum.drugAnalysis:
        return 'DRUG_ANALYSIS';
      case RecordStatusEnum.technicalExamination:
        return 'TECHNICAL_EXAMINATION';
    }
  }
}