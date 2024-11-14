// ignore_for_file: public_member_api_docs, sort_constructors_first
class TripInfoEntity {
  final double? price;
  final double? distance;
  final double? duration;
  final String? originAddress;
  final String? destinationAddress;
  final String? polyline;
  final String? type;
  TripInfoEntity(
      {this.price,
      this.distance,
      this.duration,
      this.originAddress,
      this.destinationAddress,
      this.polyline,
      this.type});
}
