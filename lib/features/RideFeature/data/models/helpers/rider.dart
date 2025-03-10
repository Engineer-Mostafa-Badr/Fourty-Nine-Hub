class Rider {
  final String? id;
  final String? phone;
  final String? carModel;

  Rider({this.id, this.phone, this.carModel});

  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(
      id: json['_id'],
      phone: json['phone'],
      carModel: json['carModel'],
    );
  }
}
