import 'dart:convert';

class BrandModel {
  final int? id;
  final String? name;
  final String? picture;
  BrandModel({
    this.id,
    this.name,
    this.picture,
  });

  BrandModel copyWith({
    int? id,
    String? name,
    String? picture,
  }) {
    return BrandModel(
      id: id ?? this.id,
      name: name ?? this.name,
      picture: picture ?? this.picture,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'picture': picture,
    };
  }

  factory BrandModel.fromMap(Map<String, dynamic> map) {
    return BrandModel(
      id: map['id']?.toInt(),
      name: map['name'],
      picture: map['picture'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BrandModel.fromJson(String source) =>
      BrandModel.fromMap(json.decode(source));

  @override
  String toString() => 'BrandModel(id: $id, name: $name, picture: $picture)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BrandModel &&
        other.id == id &&
        other.name == name &&
        other.picture == picture;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ picture.hashCode;
}
