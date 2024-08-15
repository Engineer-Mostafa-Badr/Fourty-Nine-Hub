class CarLicenseFront {
  String? type;
  int? size;

  CarLicenseFront({this.type, this.size});

  factory CarLicenseFront.fromJson(Map<String, dynamic> json) {
    return CarLicenseFront(
      type: json['type'] as String?,
      size: json['size'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'size': size,
      };
}
