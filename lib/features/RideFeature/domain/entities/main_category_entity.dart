class MainCategoryEntityUpdated {
  final String mainCategoryId;
  final String nameAr;
  final String nameEn;
  final String banner;
  final String cover;
  final bool isFavorite;
  final String? registeredSubcategory;
  final bool isDriver;
  final bool? isSocketCategory;
  final bool isDriverApproved;
  final int driverLength;

  MainCategoryEntityUpdated({
    required this.mainCategoryId,
    required this.nameAr,
    required this.nameEn,
    required this.banner,
    required this.cover,
    required this.isFavorite,
    this.registeredSubcategory,
    required this.isDriver,
    this.isSocketCategory,
    required this.isDriverApproved,
    required this.driverLength,
  });
}