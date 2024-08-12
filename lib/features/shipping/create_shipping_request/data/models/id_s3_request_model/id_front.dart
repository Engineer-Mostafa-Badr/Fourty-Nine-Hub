class IdFront {
  String? type;
  int? size;

  IdFront({this.type, this.size});

  factory IdFront.fromJson(Map<String, dynamic> json) => IdFront(
        type: json['type'] as String?,
        size: json['size'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'size': size,
      };
}
