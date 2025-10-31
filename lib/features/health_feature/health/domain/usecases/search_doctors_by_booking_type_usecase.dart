import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/most_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/repositories/health_repo.dart';

class SearchDoctorsByBookingTypeUseCase
    extends UseCase<List<MostBookingEntity>, SearchDoctorsByBookingTypeParams> {
  final HealthRepo _repo;

  SearchDoctorsByBookingTypeUseCase(this._repo);

  @override
  Future<Either<Failure, List<MostBookingEntity>>> call(
      SearchDoctorsByBookingTypeParams params) {
    return _repo.searchDoctorsByBookingType(params);
  }
}

class SearchDoctorsByBookingTypeParams {
  final BookingTypes bookingType;
  final String specialtyId;
  final String? governorateId;
  final String? cityId;
  final int page;
  final int limit;

  SearchDoctorsByBookingTypeParams({
    required this.bookingType,
    required this.specialtyId,
    this.governorateId,
    this.cityId,
    required this.page,
    required this.limit,
  });

  Map<String, dynamic> toJson() => {
        'specialityId': specialtyId,
        if (governorateId != null && governorateId!.isNotEmpty)
          'governorateId': governorateId,
        if (cityId != null && cityId!.isNotEmpty) 'cityId': cityId,
        'page': page,
        'limit': limit,
      };

  // Debug method to verify params
  void debugPrint() {
    print('📋 [DEBUG] SearchDoctorsByBookingTypeParams:');
    print('   - Booking Type: ${bookingType.name}');
    print('   - Specialty ID: "$specialtyId" (length: ${specialtyId.length})');
    print('   - Governorate ID: ${governorateId ?? "null"}');
    print('   - City ID: ${cityId ?? "null"}');
    print('   - Page: $page');
    print('   - Limit: $limit');
    print('   - JSON: ${toJson()}');
  }
}
