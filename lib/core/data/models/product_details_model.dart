import 'dart:convert';

import 'package:flutter/foundation.dart';

class ProductDetailsModel {
  final int? id;
  final int? categoryId;
  final int? brandId;
  final String? categoryName;
  final String? brandName;
  final String? name;
  final num? priceFrom;
  final num? priceTo;
  final String? picture;
  final String? rating;
  final String? hint;
  final String? content;
  final bool? isFav;
  final List<PictureModel>? relatedPictures;
  final List<ProductRate>? productRates;
  final List<ProductProviders>? productProviders;
  ProductDetailsModel({
    this.id,
    this.categoryId,
    this.brandId,
    this.categoryName,
    this.brandName,
    this.name,
    this.priceFrom,
    this.priceTo,
    this.picture,
    this.rating,
    this.hint,
    this.content,
    this.isFav,
    this.relatedPictures,
    this.productRates,
    this.productProviders,
  });

  ProductDetailsModel copyWith({
    int? id,
    int? categoryId,
    int? brandId,
    String? categoryName,
    String? brandName,
    String? name,
    num? priceFrom,
    num? priceTo,
    String? picture,
    String? rating,
    String? hint,
    String? content,
    bool? isFav,
    List<PictureModel>? relatedPictures,
    List<ProductRate>? productRates,
    List<ProductProviders>? productProviders,
  }) {
    return ProductDetailsModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      brandId: brandId ?? this.brandId,
      categoryName: categoryName ?? this.categoryName,
      brandName: brandName ?? this.brandName,
      name: name ?? this.name,
      priceFrom: priceFrom ?? this.priceFrom,
      priceTo: priceTo ?? this.priceTo,
      picture: picture ?? this.picture,
      rating: rating ?? this.rating,
      hint: hint ?? this.hint,
      content: content ?? this.content,
      isFav: isFav ?? this.isFav,
      relatedPictures: relatedPictures ?? this.relatedPictures,
      productRates: productRates ?? this.productRates,
      productProviders: productProviders ?? this.productProviders,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'brandId': brandId,
      'categoryName': categoryName,
      'brandName': brandName,
      'name': name,
      'priceFrom': priceFrom,
      'priceTo': priceTo,
      'picture': picture,
      'rating': rating,
      'hint': hint,
      'content': content,
      'isFav': isFav,
      'relatedPictures': relatedPictures?.map((x) => x.toMap()).toList(),
      'productRates': productRates?.map((x) => x.toMap()).toList(),
      'productProviders': productProviders?.map((x) => x.toMap()).toList(),
    };
  }

  factory ProductDetailsModel.fromMap(Map<String, dynamic> map) {
    return ProductDetailsModel(
      id: map['id']?.toInt(),
      categoryId: map['categoryId']?.toInt(),
      brandId: map['brandId']?.toInt(),
      categoryName: map['categoryName'],
      brandName: map['brandName'],
      name: map['name'],
      priceFrom: map['priceFrom'],
      priceTo: map['priceTo'],
      picture: map['picture'],
      rating: map['rating'],
      hint: map['hint'],
      content: map['content'],
      isFav: map['isFav'],
      relatedPictures: map['relatedPictures'] != null
          ? List<PictureModel>.from(
              map['relatedPictures']?.map((x) => PictureModel.fromMap(x)))
          : null,
      productRates: map['productRates'] != null
          ? List<ProductRate>.from(
              map['productRates']?.map((x) => ProductRate.fromMap(x)))
          : null,
      productProviders: map['productProviders'] != null
          ? List<ProductProviders>.from(
              map['productProviders']?.map((x) => ProductProviders.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductDetailsModel.fromJson(String source) =>
      ProductDetailsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductDetailsModel(id: $id, categoryId: $categoryId, brandId: $brandId, categoryName: $categoryName, brandName: $brandName, name: $name, priceFrom: $priceFrom, priceTo: $priceTo, picture: $picture, rating: $rating, hint: $hint, content: $content, isFav: $isFav, relatedPictures: $relatedPictures, productRates: $productRates, productProviders: $productProviders)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductDetailsModel &&
        other.id == id &&
        other.categoryId == categoryId &&
        other.brandId == brandId &&
        other.categoryName == categoryName &&
        other.brandName == brandName &&
        other.name == name &&
        other.priceFrom == priceFrom &&
        other.priceTo == priceTo &&
        other.picture == picture &&
        other.rating == rating &&
        other.hint == hint &&
        other.content == content &&
        other.isFav == isFav &&
        listEquals(other.relatedPictures, relatedPictures) &&
        listEquals(other.productRates, productRates) &&
        listEquals(other.productProviders, productProviders);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        categoryId.hashCode ^
        brandId.hashCode ^
        categoryName.hashCode ^
        brandName.hashCode ^
        name.hashCode ^
        priceFrom.hashCode ^
        priceTo.hashCode ^
        picture.hashCode ^
        rating.hashCode ^
        hint.hashCode ^
        content.hashCode ^
        isFav.hashCode ^
        relatedPictures.hashCode ^
        productRates.hashCode ^
        productProviders.hashCode;
  }
}

class PictureModel {
  final String? picture;
  PictureModel({
    this.picture,
  });

  PictureModel copyWith({
    String? picture,
  }) {
    return PictureModel(
      picture: picture ?? this.picture,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'picture': picture,
    };
  }

  factory PictureModel.fromMap(Map<String, dynamic> map) {
    return PictureModel(
      picture: map['picture'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PictureModel.fromJson(String source) =>
      PictureModel.fromMap(json.decode(source));

  @override
  String toString() => 'PictureModel(picture: $picture)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PictureModel && other.picture == picture;
  }

  @override
  int get hashCode => picture.hashCode;
}

class ProductRate {
  final String? name;
  final int? rating;
  final int? productId;
  final String? message;
  ProductRate({
    this.name,
    this.rating,
    this.productId,
    this.message,
  });

  ProductRate copyWith({
    String? name,
    int? rating,
    int? productId,
    String? message,
  }) {
    return ProductRate(
      name: name ?? this.name,
      rating: rating ?? this.rating,
      productId: productId ?? this.productId,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rating': rating,
      'productId': productId,
      'message': message,
    };
  }

  factory ProductRate.fromMap(Map<String, dynamic> map) {
    return ProductRate(
      name: map['name'],
      rating: map['rating']?.toInt(),
      productId: map['productId']?.toInt(),
      message: map['message'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductRate.fromJson(String source) =>
      ProductRate.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductRate(name: $name, rating: $rating, productId: $productId, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductRate &&
        other.name == name &&
        other.rating == rating &&
        other.productId == productId &&
        other.message == message;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        rating.hashCode ^
        productId.hashCode ^
        message.hashCode;
  }
}

class ProductProviders {
  final int? id;
  final String? name;
  final String? description;
  final String? logo;
  final num? price;
  final String? url;
  ProductProviders({
    this.id,
    this.name,
    this.description,
    this.logo,
    this.price,
    this.url,
  });

  ProductProviders copyWith({
    int? id,
    String? name,
    String? description,
    String? logo,
    num? price,
    String? url,
  }) {
    return ProductProviders(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      price: price ?? this.price,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logo': logo,
      'price': price,
      'url': url,
    };
  }

  factory ProductProviders.fromMap(Map<String, dynamic> map) {
    return ProductProviders(
      id: map['id']?.toInt(),
      name: map['name'],
      description: map['description'],
      logo: map['logo'],
      price: map['price'],
      url: map['url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductProviders.fromJson(String source) =>
      ProductProviders.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductProviders(id: $id, name: $name, description: $description, logo: $logo, price: $price, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductProviders &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.logo == logo &&
        other.price == price &&
        other.url == url;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        logo.hashCode ^
        price.hashCode ^
        url.hashCode;
  }
}
