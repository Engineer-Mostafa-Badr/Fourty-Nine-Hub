class LocationEntity {
  String? id;
  List<num?>? coordinates;
  String? address;

  LocationEntity({
    required this.id,
    required this.coordinates,
    required this.address,
  });

  @override
  String toString() =>
      'LocationEntity(id: $id, coordinates: $coordinates, address: $address)';
}
