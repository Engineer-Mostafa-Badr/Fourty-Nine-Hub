class Document {
  String? name;
  String? type;
  int? size;

  Document({this.name, this.type, this.size});

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        name: json['name'] as String?,
        type: json['type'] as String?,
        size: json['size'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'size': size,
      };
}
