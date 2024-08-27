class DriverCar {
  List<dynamic>? urls;

  DriverCar({this.urls});

  factory DriverCar.fromJson(Map<String, dynamic> json) => DriverCar(
        urls: json['urls'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'urls': urls,
      };
}
