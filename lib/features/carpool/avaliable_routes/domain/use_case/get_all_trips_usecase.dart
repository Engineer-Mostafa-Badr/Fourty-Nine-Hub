import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/entities/get_all_trips_entity.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/repo/get_all_trips_repo.dart';

class GetAllTripsUseCase {
  final GetAllTripsRepo repository;

  GetAllTripsUseCase(this.repository);

  Future<List<CarpoolTripParam>> call() async {
    return await repository.getAllCarpoolTrips();
  }
}
