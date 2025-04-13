import 'dashboards/pagination_entity.dart';
import 'dashboards/trip_entity.dart';

class GetOffersResponseEntity {
  final bool status;
  final GetOffersDataEntity data;

  GetOffersResponseEntity({required this.status, required this.data});
}
class GetOffersDataEntity {
  final List<TripEntity> offers;
  final PaginationEntity pagination;

  GetOffersDataEntity({required this.offers, required this.pagination});
}