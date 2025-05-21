class PriceEntity {
  final String? id;
  final num? photoPrice;
  final num? postPrice;
  final num? postAndPhotoPrice;
  final num? reelPrice;
  final bool? isSubscribed;

  PriceEntity(
      {required this.id,
      required this.photoPrice,
      required this.postPrice,
      required this.postAndPhotoPrice,
      required this.reelPrice,
      required this.isSubscribed,
      });
}
