class AddFavoriteAuctionEntity {
  final bool? status;
  final String? message;

  const AddFavoriteAuctionEntity({
    this.status,
    this.message,
  });
}
// ENTITY
class CreateAuctionEntity {
  final bool? status;
  final String? message;
  final AuctionSubscriptionData? data;

  const CreateAuctionEntity({
    this.status,
    this.message,
    this.data,
  });
}

class AuctionSubscriptionData {
  final bool? endPointSubscription;
  final bool? userSubscription;
  final String? subCategoryId;
  final List<String>? paymentMethod;

  const AuctionSubscriptionData({
    this.endPointSubscription,
    this.userSubscription,
    this.subCategoryId,
    this.paymentMethod,
  });
}
