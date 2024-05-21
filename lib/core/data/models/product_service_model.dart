import 'dart:convert';

import 'package:flutter/foundation.dart';

class ProductServiceModel {
  final ProductServiceData? data;
  final int? statusCode;
  final String? message;
  final bool? isSuccess;
  final List<String>? errors;
  ProductServiceModel({
    this.data,
    this.statusCode,
    this.message,
    this.isSuccess,
    this.errors,
  });

  ProductServiceModel copyWith({
    ProductServiceData? data,
    int? statusCode,
    String? message,
    bool? isSuccess,
    List<String>? errors,
  }) {
    return ProductServiceModel(
      data: data ?? this.data,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      isSuccess: isSuccess ?? this.isSuccess,
      errors: errors ?? this.errors,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Data': data?.toMap(),
      'StatusCode': statusCode,
      'Message': message,
      'IsSuccess': isSuccess,
      'Errors': errors,
    };
  }

  factory ProductServiceModel.fromMap(Map<String, dynamic> map) {
    return ProductServiceModel(
      data:
          map['Data'] != null ? ProductServiceData.fromMap(map['Data']) : null,
      statusCode: map['StatusCode']?.toInt(),
      message: map['Message'],
      isSuccess: map['IsSuccess'],
      errors: List<String>.from(map['Errors']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductServiceModel.fromJson(String source) =>
      ProductServiceModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategorySpecificationAttributeModel(data: $data, statusCode: $statusCode, message: $message, isSuccess: $isSuccess, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductServiceModel &&
        other.data == data &&
        other.statusCode == statusCode &&
        other.message == message &&
        other.isSuccess == isSuccess &&
        listEquals(other.errors, errors);
  }

  @override
  int get hashCode {
    return data.hashCode ^
        statusCode.hashCode ^
        message.hashCode ^
        isSuccess.hashCode ^
        errors.hashCode;
  }
}

class ProductServiceData {
  final int? pageIndex;
  final int? pageSize;
  final int? totalCount;
  final int? totalPages;
  final bool? hasPreviousPage;
  final bool? hasNextPage;
  final List<ProductServiceItems>? items;

  ProductServiceData(
      {this.hasNextPage,
      this.totalPages,
      this.pageIndex,
      this.pageSize,
      this.totalCount,
      this.hasPreviousPage,
      this.items});

  ProductServiceData copyWith({
    int? pageIndex,
    int? pageSize,
    int? totalCount,
    int? totalPages,
    bool? hasPreviousPage,
    bool? hasNextPage,
    List<ProductServiceItems>? items,
  }) {
    return ProductServiceData(
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pageIndex': pageIndex,
      'pageSize': pageSize,
      'totalCount': totalCount,
      'hasPreviousPage': hasPreviousPage,
      'totalPages': totalPages,
      'hasNextPage': hasNextPage,
      'items': items,
    };
  }

  factory ProductServiceData.fromMap(Map<String, dynamic> map) {
    return ProductServiceData(
      pageIndex: map['pageIndex'],
      pageSize: map['pageSize'],
      totalCount: map['fileUrl'],
      hasPreviousPage: map['hasPreviousPage'],
      totalPages: map['totalPages'],
      hasNextPage: map['hasNextPage'],
      items: map['items'] != null
          ? List<ProductServiceItems>.from(
              map['items']?.map((x) => ProductServiceItems.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductServiceData.fromJson(String source) =>
      ProductServiceData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategoryServiceData(pageIndex: $pageIndex, pageSize: $pageSize, totalCount: $totalCount, hasNextPage: $hasNextPage, totalPages: $totalPages,items: $items,hasPreviousPage: $hasPreviousPage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductServiceData &&
        other.pageIndex == pageIndex &&
        other.pageSize == pageSize &&
        other.totalCount == totalCount &&
        other.hasPreviousPage == hasPreviousPage &&
        other.hasNextPage == hasNextPage &&
        other.totalPages == totalPages &&
        other.items == items;
  }

  @override
  int get hashCode {
    return pageIndex.hashCode ^
        pageSize.hashCode ^
        totalCount.hashCode ^
        hasNextPage.hashCode ^
        totalPages.hashCode ^
        items.hashCode ^
        hasPreviousPage.hashCode;
  }
}

class ProductServiceItems {
  final int? id;
  final String? name;
  final String? iconUrl;

  ProductServiceItems({
    this.id,
    this.name,
    this.iconUrl,
  });

  ProductServiceItems copyWith({
    int? id,
    String? name,
    String? iconUrl,
  }) {
    return ProductServiceItems(
      id: id ?? this.id,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconUrl': iconUrl,
    };
  }

  factory ProductServiceItems.fromMap(Map<String, dynamic> map) {
    return ProductServiceItems(
      id: map['id'],
      name: map['name'],
      iconUrl: map['iconUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductServiceItems.fromJson(String source) =>
      ProductServiceItems.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategoryServiceItems(id: $id, name: $name, iconUrl: $iconUrl,)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductServiceItems &&
        other.id == id &&
        other.name == name &&
        other.iconUrl == iconUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ iconUrl.hashCode;
  }
}
