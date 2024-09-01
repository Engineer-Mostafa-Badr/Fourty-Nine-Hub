import 'dart:convert';

class IsRestaurantModel {
  final bool? isRestaurant;
  final bool? approved;
  IsRestaurantModel({
    this.isRestaurant,
    this.approved,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (isRestaurant != null) {
      result.addAll({'isRestaurant': isRestaurant});
    }
    if (approved != null) {
      result.addAll({'Approved': approved});
    }

    return result;
  }

  factory IsRestaurantModel.fromMap(Map<String, dynamic> map) {
    return IsRestaurantModel(
      isRestaurant: map['isRestaurant'],
      approved: map['Approved'],
    );
  }

  String toJson() => json.encode(toMap());

  factory IsRestaurantModel.fromJson(String source) =>
      IsRestaurantModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'IsRestaurantModel(isRestaurant: $isRestaurant, Approved: $approved)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IsRestaurantModel &&
        other.isRestaurant == isRestaurant &&
        other.approved == approved;
  }

  @override
  int get hashCode => isRestaurant.hashCode ^ approved.hashCode;
}
