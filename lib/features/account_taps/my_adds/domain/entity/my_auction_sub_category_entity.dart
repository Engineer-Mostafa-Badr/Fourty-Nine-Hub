class MyAuctionSubCategoryEntity {
  final String id;
  final bool isHidden;
  final String parent;
  final num dailyPrice;
  final num portion;
  final num providerPortion;
  final num paymentFactor;
  final num grossMoney;
  final String picture;
  final num index;
  final String createdAt;
  final String updatedAt;
  final num overHeadFactor;
  final bool hasAuction;
  final String nameAr;
  final String nameEn;
  final String nameCode;
  final String enableChatAndCallButton;
  final String paymentMethods;
  final num totalOverHead;

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
