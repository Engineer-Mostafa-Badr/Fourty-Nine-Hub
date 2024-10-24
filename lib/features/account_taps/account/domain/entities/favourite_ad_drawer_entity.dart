class FavouriteAdDrawerEntity {
  final String id;
  final String userId;
  final String mainCategoryId;
  final String nameEn;
  final String nameAr;
  final String title;
  final String desc;
  final String subscriptionStatus;
  final List<FavouriteAdDrawerImages> images;
  final num price;
  final String phone;
  final String subCategoryId;
  final String subCategoryNameAr;
  final String subCategoryNameEn;
  final DateTime createdAt;

  FavouriteAdDrawerEntity(
      {required this.id,
      required this.userId,
      required this.mainCategoryId,
      required this.nameEn,
      required this.nameAr,
      required this.title,
      required this.desc,
      required this.subscriptionStatus,
      required this.images,
      required this.price,
      required this.phone,
      required this.subCategoryId,
      required this.subCategoryNameAr,
      required this.subCategoryNameEn,
      required this.createdAt});
}

class FavouriteAdDrawerImages{
  final String id;
  final String mediaKey;

  FavouriteAdDrawerImages({required this.id, required this.mediaKey});
}