import 'dart:convert';

class CategoryModel {
  final int? id;
  final String? name;
  final String? picture;
  CategoryModel({
    this.id,
    this.name,
    this.picture,
  });

  CategoryModel copyWith({
    int? id,
    String? name,
    String? picture,
  }) {
    return CategoryModel(
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

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id']?.toInt(),
      name: map['name'],
      picture: map['picture'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));

  @override
  String toString() => 'CategoryModel(id: $id, name: $name, picture: $picture)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel &&
        other.id == id &&
        other.name == name &&
        other.picture == picture;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ picture.hashCode;
}
