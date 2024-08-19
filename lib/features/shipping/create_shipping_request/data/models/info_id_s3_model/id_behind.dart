class IdBehind {
  String? type;
  int? size;

  IdBehind({this.type, this.size});

  factory IdBehind.fromJson(Map<String, dynamic> json) => IdBehind(
        type: json['type'] as String?,
        size: json['size'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'size': size,
      };
}
