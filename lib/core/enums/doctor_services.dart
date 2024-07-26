enum DoctorServices { HOMEVISIT, CLINICVIST, CALL, EMERGENCY }

extension DoctorServicesExtension on DoctorServices {
  String get translatedName {
    switch (this) {
      case DoctorServices.HOMEVISIT:
        return 'Home Visit';
      case DoctorServices.CLINICVIST:
        return 'Clinic Visit';
      case DoctorServices.CALL:
        return 'Call';
      case DoctorServices.EMERGENCY:
        return 'Emergency';
    }
  }
}
