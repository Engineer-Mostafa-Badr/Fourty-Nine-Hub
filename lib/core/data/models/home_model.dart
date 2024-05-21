import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'brand_model.dart';
import 'category_model.dart';
import 'product_model.dart';

class HomeModel {
  final List<CategoryModel>? categories;
  final List<BrandModel>? brands;
  final List<ProductModel>? products;
  HomeModel({
    this.categories,
    this.brands,
    this.products,
  });

  HomeModel copyWith({
    List<CategoryModel>? categories,
    List<BrandModel>? brands,
    List<ProductModel>? products,
  }) {
    return HomeModel(
      categories: categories ?? this.categories,
      brands: brands ?? this.brands,
      products: products ?? this.products,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categories': categories?.map((x) => x.toMap()).toList(),
      'brands': brands?.map((x) => x.toMap()).toList(),
      'products': products?.map((x) => x.toMap()).toList(),
    };
  }

  factory HomeModel.fromMap(Map<String, dynamic> map) {
    return HomeModel(
      categories: map['categories'] != null
          ? List<CategoryModel>.from(
              map['categories']?.map((x) => CategoryModel.fromMap(x)))
          : null,
      brands: map['brands'] != null
          ? List<BrandModel>.from(
              map['brands']?.map((x) => BrandModel.fromMap(x)))
          : null,
      products: map['products'] != null
          ? List<ProductModel>.from(
              map['products']?.map((x) => ProductModel.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeModel.fromJson(String source) =>
      HomeModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'HomeModel(categories: $categories, brands: $brands, products: $products)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeModel &&
        listEquals(other.categories, categories) &&
        listEquals(other.brands, brands) &&
        listEquals(other.products, products);
  }

  @override
  int get hashCode => categories.hashCode ^ brands.hashCode ^ products.hashCode;
}
