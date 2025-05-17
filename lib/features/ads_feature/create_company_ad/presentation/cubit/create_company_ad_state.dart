part of 'create_company_ad_cubit.dart';

class CreateCompanyAdState {
  final StateStatus status;
  final Failure? failure;
  final PriceEntity? price;
  final UploadFileEntity? image;
  final CompanyAdOptionEntity? advertise;
  final List<CompanyAdEntity>? posts;
  final num totalPrice;
  final String? video;
  final List<String>? mediaIds;
  final List<XFile>? files;
  final List<MainCategoryEntity>? mainCategories;
  final MainCategoryEntity? selectedMainCategories;
  final SubCategoryEntity? selectedSubCategories;
  final List<SubCategoryEntity>? subCategories;

  const CreateCompanyAdState({
    this.status = StateStatus.loading,
    this.failure,
    this.price,
    this.advertise,
    this.posts,
    this.image,
    this.mediaIds,
    this.files,
    this.mainCategories,
    this.subCategories,
    this.selectedMainCategories,
    this.selectedSubCategories,
    this.video,
    this.totalPrice = 0, // Default to 0
  });
  CreateCompanyAdState copyWith({
    StateStatus? status,
    Failure? failure,
    PriceEntity? price,
    UploadFileEntity? image,
    CompanyAdOptionEntity? advertise,
    List<CompanyAdEntity>? posts,
    num? totalPrice,
    List<String>? mediaIds,
    List<XFile>? files,
    List<MainCategoryEntity>? mainCategories,
    List<SubCategoryEntity>? subCategories,
    MainCategoryEntity? selectedMainCategories,
    SubCategoryEntity? selectedSubCategories,
    String? video,
  }) {
    return CreateCompanyAdState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      price: price ?? this.price,
      advertise: advertise ?? this.advertise,
      posts: posts ?? this.posts,
      totalPrice: totalPrice ?? this.totalPrice, // Ensure totalPrice is copied
      image: image ?? this.image, // Ensure totalPrice is copied
      mediaIds: mediaIds ?? this.mediaIds, // Ensure totalPrice is copied
      files: files ?? this.files, // Ensure totalPrice is copied
      mainCategories: mainCategories ?? this.mainCategories, // Ensure totalPrice is copied
      subCategories: subCategories ?? this.subCategories, // Ensure totalPrice is copied
      selectedMainCategories: selectedMainCategories ?? this.selectedMainCategories, // Ensure totalPrice is copied
      selectedSubCategories: selectedSubCategories ?? this.selectedSubCategories, // Ensure totalPrice is copied
      video: video ?? this.video, // Ensure totalPrice is copied
    );
  }
}
