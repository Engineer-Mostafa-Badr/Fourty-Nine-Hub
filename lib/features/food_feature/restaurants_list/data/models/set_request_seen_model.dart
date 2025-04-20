import '../../domain/entities/set_request_seen_entity.dart';

class SetRequestSeenModel extends SetRequestSeenEntity {
  SetRequestSeenModel({
    super.id,
    super.userId,
    super.restaurantId,
    super.orders,
    super.total,
    super.isPremium,
    super.createdAt,
    super.updatedAt,
    super.order,
    super.seen,
  });

  factory SetRequestSeenModel.fromJson(Map<String, dynamic> json) {
    return SetRequestSeenModel(
      id: json['_id'],
      userId: json['userId'],
      restaurantId: json['restaurantId'],
      orders: (json['orders'] as List<dynamic>?)
          ?.map((e) => OrderItemModel.fromJson(e))
          .toList(),
      total: json['total'],
      isPremium: json['isPremium'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      order: json['order'] != null ? OrderSeenModel.fromJson(json['order']) : null,
      seen: json['seen'],
    );
  }
}

class OrderItemModel extends OrderItemEntity {
  OrderItemModel({
    super.foodId,
    super.quantity,
    super.price,
    super.totalPriceOfItem,
    super.id,
    super.seen,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      foodId: json['foodId'],
      quantity: json['quantity'],
      price: json['price'],
      totalPriceOfItem: json['totalPriceOfItem'],
      id: json['_id'],
      seen: json['seen'],
    );
  }
}

class OrderSeenModel extends OrderSeenEntity {
  OrderSeenModel({super.seen});

  factory OrderSeenModel.fromJson(Map<String, dynamic> json) {
    return OrderSeenModel(seen: json['seen']);
  }
}
