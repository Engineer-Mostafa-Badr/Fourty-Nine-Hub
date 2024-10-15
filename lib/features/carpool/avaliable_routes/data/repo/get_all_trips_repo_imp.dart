import 'package:fourtyninehub/features/carpool/avaliable_routes/data/data_source/get_all_trips_remote_data_source.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/entities/get_all_trips_entity.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/repo/get_all_trips_repo.dart';

class GetAllTripsRepoImp implements GetAllTripsRepo {
  final GetAllTripsRemoteDataSource remoteDataSource;

  GetAllTripsRepoImp(this.remoteDataSource);

  @override
  Future<List<CarpoolTripParam>> getAllCarpoolTrips() async {
    try {
      return await remoteDataSource.getAllCarpoolTrips();
    } catch (e) {
      print('Error in repository: $e');
      throw Exception('Could not fetch carpool trips');
    }
  }
}
