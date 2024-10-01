class VehicleId {
  String? id;
  String? brand;
  String? model;

  VehicleId({this.id, this.brand, this.model});

  @override
  String toString() => 'VehicleId(id: $id, brand: $brand, model: $model)';

  factory VehicleId.fromJson(Map<String, dynamic> json) => VehicleId(
        id: json['_id'] as String?,
        brand: json['Brand'] as String?,
        model: json['Model'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'Brand': brand,
        'Model': model,
      };
}
