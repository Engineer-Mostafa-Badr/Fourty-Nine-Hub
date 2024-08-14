class CarImage {
  String? type;
  int? size;

  CarImage({this.type, this.size});

  factory CarImage.fromJson(Map<String, dynamic> json) => CarImage(
        type: json['type'] as String?,
        size: json['size'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'size': size,
      };
}
