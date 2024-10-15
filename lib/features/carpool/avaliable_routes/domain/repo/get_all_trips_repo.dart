import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/entities/get_all_trips_entity.dart';

abstract class GetAllTripsRepo {
  Future<List<CarpoolTripParam>> getAllCarpoolTrips();
}
