class DrivingLicenseBehind {
  String? type;
  int? size;

  DrivingLicenseBehind({this.type, this.size});

  factory DrivingLicenseBehind.fromJson(Map<String, dynamic> json) {
    return DrivingLicenseBehind(
      type: json['type'] as String?,
      size: json['size'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'size': size,
      };
}
