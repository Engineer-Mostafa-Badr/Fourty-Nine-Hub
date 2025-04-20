
class BookingEntity {
  final String? bookingId;
  final String? appointmentType;
  final String? day;
  final String? startTime;
  final String? endTime;
  final bool? expired;
  final DoctorEntity? doctor;

  const BookingEntity({
    this.bookingId,
    this.appointmentType,
    this.day,
    this.startTime,
    this.endTime,
    this.expired,
    this.doctor,
  });
}

class DoctorEntity {
  final String? id;
  final String? firstName;
  final String? lastName;
  final RatingEntity? rating;
  final String? profilePicture;
  final SubCategoryEntity? subCategory;
  final dynamic waitingTime;
  final AddressEntity? address;
  final dynamic clinicPrice;
  final dynamic visitHomePrice;
  final String? callsPrice;
  final bool? isPremium;

  const DoctorEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.rating,
    this.profilePicture,
    this.subCategory,
    this.waitingTime,
    this.address,
    this.clinicPrice,
    this.visitHomePrice,
    this.callsPrice,
    this.isPremium,
  });
}

class RatingEntity {
  final num? average;
  final num? total;
  final String? text;

  const RatingEntity({
    this.average,
    this.total,
    this.text,
  });
}

class SubCategoryEntity {
  final String? id;
  final String? nameAr;
  final String? nameEn;

  const SubCategoryEntity({
    this.id,
    this.nameAr,
    this.nameEn,
  });
}

class AddressEntity {
  final String? governorate;
  final String? city;
  final String? address;
  final String? id;

  const AddressEntity({
    this.governorate,
    this.city,
    this.address,
    this.id,
  });
}

