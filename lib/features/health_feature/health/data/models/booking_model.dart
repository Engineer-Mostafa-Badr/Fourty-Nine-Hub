



import '../../domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    super.bookingId,
    super.appointmentType,
    super.day,
    super.startTime,
    super.endTime,
    super.expired,
    super.doctor,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json['bookingId'],
      appointmentType: json['appointmentType'],
      day: json['day'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      expired: json['expired'],
      doctor: json['doctor'] != null
          ? DoctorModel.fromJson(json['doctor'])
          : null,
    );
  }


}

class DoctorModel extends DoctorEntity {
  const DoctorModel({
    super.id,
    super.firstName,
    super.lastName,
    super.rating,
    super.profilePicture,
    super.subCategory,
    super.waitingTime,
    super.address,
    super.clinicPrice,
    super.visitHomePrice,
    super.callsPrice,
    super.isPremium,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      rating: json['rating'] != null
          ? RatingModel.fromJson(json['rating'])
          : null,
      profilePicture: json['profilePicture'],
      subCategory: json['subCategory'] != null
          ? SubCategoryModel.fromJson(json['subCategory'])
          : null,
      waitingTime: json['waitingTime'],
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'])
          : null,
      clinicPrice: json['clinicPrice'],
      visitHomePrice: json['visitHomePrice'],
      callsPrice: json['callsPrice'],
      isPremium: json['isPremium'],
    );
  }


}

class RatingModel extends RatingEntity {
  const RatingModel({
    super.average,
    super.total,
    super.text,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      average: json['average'],
      total: json['total'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average': average,
      'total': total,
      'text': text,
    };
  }
}

class SubCategoryModel extends SubCategoryEntity {
  const SubCategoryModel({
    super.id,
    super.nameAr,
    super.nameEn,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
    };
  }
}

class AddressModel extends AddressEntity {
  const AddressModel({
    super.governorate,
    super.city,
    super.address,
    super.id,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      governorate: json['governorate'],
      city: json['city'],
      address: json['address'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'governorate': governorate,
      'city': city,
      'address': address,
      'id': id,
    };
  }
}

