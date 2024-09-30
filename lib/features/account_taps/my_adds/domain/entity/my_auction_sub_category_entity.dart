class MyAuctionSubCategoryEntity {
  final String id;
  final bool isHidden;
  final String parent;
  final int dailyPrice;
  final int portion;
  final int providerPortion;
  final int paymentFactor;
  final int grossMoney;
  final String picture;
  final int index;
  final String createdAt;
  final String updatedAt;
  final int overHeadFactor;
  final bool hasAuction;
  final String nameAr;
  final String nameEn;
  final String nameCode;
  final String enableChatAndCallButton;
  final String paymentMethods;
  final int totalOverHead;

  MyAuctionSubCategoryEntity(
      {required this.id,
      required this.isHidden,
      required this.parent,
      required this.dailyPrice,
      required this.portion,
      required this.providerPortion,
      required this.paymentFactor,
      required this.grossMoney,
      required this.picture,
      required this.index,
      required this.createdAt,
      required this.updatedAt,
      required this.overHeadFactor,
      required this.hasAuction,
      required this.nameAr,
      required this.nameEn,
      required this.nameCode,
      required this.enableChatAndCallButton,
      required this.paymentMethods,
      required this.totalOverHead});
}
