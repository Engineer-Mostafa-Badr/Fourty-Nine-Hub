class SetRequestSeenEntity {
  final String? id;
  final String? userId;
  final String? restaurantId;
  final List<OrderItemEntity>? orders;
  final num? total;
  final bool? isPremium;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final OrderSeenEntity? order;
  final bool? seen;

  const SetRequestSeenEntity({
    this.id,
    this.userId,
    this.restaurantId,
    this.orders,
    this.total,
    this.isPremium,
    this.createdAt,
    this.updatedAt,
    this.order,
    this.seen,
  });
}

class OrderItemEntity {
  final String? foodId;
  final int? quantity;
  final num? price;
  final num? totalPriceOfItem;
  final String? id;
  final bool? seen;

  const OrderItemEntity({
    this.foodId,
    this.quantity,
    this.price,
    this.totalPriceOfItem,
    this.id,
    this.seen,
  });
}

class OrderSeenEntity {
  final bool? seen;

  const OrderSeenEntity({this.seen});
}
