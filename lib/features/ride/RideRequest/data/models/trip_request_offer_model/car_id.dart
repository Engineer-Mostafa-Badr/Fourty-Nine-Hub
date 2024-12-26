class CarId {
  String? id;
  String? brand;
  String? model;

  CarId({this.id, this.brand, this.model});

  factory CarId.fromJson(Map<String, dynamic> json) => CarId(
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
