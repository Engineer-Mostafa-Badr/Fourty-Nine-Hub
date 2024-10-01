class DriverInfoId {
  String? carPicturesKey;

  DriverInfoId({this.carPicturesKey});

  factory DriverInfoId.fromJson(Map<String, dynamic> json) => DriverInfoId(
        carPicturesKey: json['carPicturesKey'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'carPicturesKey': carPicturesKey,
      };
}
