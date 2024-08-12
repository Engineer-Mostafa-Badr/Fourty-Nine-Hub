class DrivingLicenseFront {
  String? type;
  int? size;

  DrivingLicenseFront({this.type, this.size});

  factory DrivingLicenseFront.fromJson(Map<String, dynamic> json) {
    return DrivingLicenseFront(
      type: json['type'] as String?,
      size: json['size'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'size': size,
      };
}
