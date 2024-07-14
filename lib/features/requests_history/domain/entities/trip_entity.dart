import '../../../subcategories/data/models/sub_category_model.dart';
import '../../data/models/call_model.dart';
import '../../data/models/driver_model.dart';
import '../../data/models/offer_model.dart';

class TripEntity {
  String id;
  List<double> fromCoordinates;
  List<double> toCoordinates;
  String fromAddress;
  String toAddress;
  num price;
  num time;
  num distance;
  bool started;
  bool ended;
  bool canceled;
  int passengers;
  List<CallModel> calls;
  List<OfferModel> offers;
  DriverModel? driver;
  SubCategoryModel? category;

  bool get showOffers => !started && !ended && !canceled;

  TripEntity(
      {required this.id,
      required this.fromCoordinates,
      required this.toCoordinates,
      required this.fromAddress,
      required this.toAddress,
      required this.price,
      required this.time,
      required this.distance,
      required this.started,
      required this.ended,
      required this.canceled,
      required this.calls,
      required this.offers,
      required this.passengers,
      required this.driver,
      required this.category});
}
