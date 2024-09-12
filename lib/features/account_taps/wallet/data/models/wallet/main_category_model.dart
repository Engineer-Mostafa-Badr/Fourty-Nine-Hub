import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/main_category_entity.dart';

class MainCategoryWalletModel extends MainCategoryWalletEntity {
  MainCategoryWalletModel(
      {required super.id, required super.nameAr, required super.nameEn});

  factory MainCategoryWalletModel.fromJson(Map<String, dynamic> json) {
    return MainCategoryWalletModel(
      id: json['_id'] ??'',
      nameAr: json['nameAr'] ??'',
      nameEn: json['nameEn'] ??'',
    );
  }
}
