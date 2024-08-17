class CarLicenseBehind {
  String? type;
  int? size;

  CarLicenseBehind({this.type, this.size});

  factory CarLicenseBehind.fromJson(Map<String, dynamic> json) {
    return CarLicenseBehind(
      type: json['type'] as String?,
      size: json['size'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'size': size,
      };
}
