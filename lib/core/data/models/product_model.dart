import 'dart:convert';

class ProductModel {
  final int? id;
  final String? name;
  final num? priceFrom;
  final num? priceTo;
  final String? picture;
  final String? rating;
  ProductModel({
    this.id,
    this.name,
    this.priceFrom,
    this.priceTo,
    this.picture,
    this.rating,
  });

  ProductModel copyWith({
    int? id,
    String? name,
    num? priceFrom,
    num? priceTo,
    String? picture,
    String? rating,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      priceFrom: priceFrom ?? this.priceFrom,
      priceTo: priceTo ?? this.priceTo,
      picture: picture ?? this.picture,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'priceFrom': priceFrom,
      'priceTo': priceTo,
      'picture': picture,
      'rating': rating,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id']?.toInt(),
      name: map['name'],
      priceFrom: map['priceFrom'],
      priceTo: map['priceTo'],
      picture: map['picture'],
      rating: map['rating'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, priceFrom: $priceFrom, priceTo: $priceTo, picture: $picture, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductModel &&
        other.id == id &&
        other.name == name &&
        other.priceFrom == priceFrom &&
        other.priceTo == priceTo &&
        other.picture == picture &&
        other.rating == rating;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        priceFrom.hashCode ^
        priceTo.hashCode ^
        picture.hashCode ^
        rating.hashCode;
  }
}
