import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/entities/get_all_trips_entity.dart';

abstract class GetAllTripsRemoteDataSource {
  Future<List<CarpoolTripParam>> getAllCarpoolTrips();
}

// This class is now a placeholder for potential future changes, where we might want to
// change the data-fetching implementation, for instance, to use an HTTP client or other API.
class GetAllTripsRemoteDataSourceImpl implements GetAllTripsRemoteDataSource {
  @override
  Future<List<CarpoolTripParam>> getAllCarpoolTrips() async {
    // Since socket logic is handled inside the Cubit, we can remove socket logic here.
    // This method can be left as a placeholder or used for future adjustments.
    throw UnimplementedError(
        'Data fetching is handled by the socket in the Cubit.');
  }
}
