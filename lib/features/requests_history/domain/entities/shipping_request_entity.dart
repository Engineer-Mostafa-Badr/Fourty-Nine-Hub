import '../../../subcategories/data/models/sub_category_model.dart';
import '../../data/models/call_model.dart';
import '../../data/models/driver_model.dart';
import '../../data/models/offer_model.dart';

class ShippingRequestEntity {
  int id;
  List<double> fromCoordinates;
  List<double> toCoordinates;
  String fromAddress;
  String toAddress;
  String moreFromAddressDetails;
  String moreToAddressDetails;
  String senderPhone;
  String receiverPhone;
  num price;
  String time;
  String distance;
  bool started;
  bool ended;
  bool canceled;
  List<CallModel> calls;
  List<OfferModel> offers;
  DriverModel? driver;
  SubCategoryModel category;

  bool get showOffers => !started && !ended && !canceled;

  ShippingRequestEntity({
    required this.id,
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
    required this.driver,
    required this.category,
    required this.moreFromAddressDetails,
    required this.moreToAddressDetails,
    required this.receiverPhone,
    required this.senderPhone,
  });
}
