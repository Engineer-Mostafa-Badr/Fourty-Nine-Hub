import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/create_no_track_trip_entity.dart';
import '../repositories/ride_repository.dart';

class CreateNonTrackTripUseCase
    extends UseCase<CreateNonTrackTripEntity, CreateNonTrackTripParams> {
  final RideRepository _repo;

  CreateNonTrackTripUseCase(this._repo);

  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> call(CreateNonTrackTripParams params) {
    return _repo.createNonTrackTrip(params);
  }
}
class CreateNonTrackTripParams {
  final String subcategoryId;
  final String fromTitle;
  final String toTitle;
  final num price;
  final DateTime date;
  final String phone;
  final num passengers;
  final bool isPremium;
  final String description;
  final String desc;


  CreateNonTrackTripParams({
    required this.subcategoryId,
    required this.fromTitle,
    required this.toTitle,
    required this.price,
    required this.date,
    required this.phone,
    required this.passengers,
    required this.isPremium,
    required this.description,
    required this.desc,

  });

  Map<String, dynamic> toJson() {
    var json = {
    'subcategoryId': subcategoryId,
    'fromTitle': fromTitle,
    'toTitle': toTitle,
    'price': price,
    'date': date.toIso8601String(),  // Convert DateTime to ISO 8601 string
    'phone': phone,
    'passengers': passengers,
    'isPremium': isPremium,
    'description': description,
    'desc': desc,
  };
    json.removeWhere((key, value) => value == '');
    return json;
  }
}

