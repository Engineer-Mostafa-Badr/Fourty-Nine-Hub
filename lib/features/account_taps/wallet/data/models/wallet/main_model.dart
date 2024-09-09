// import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/main_entity.dart';
//
// import 'main_category_model.dart';
//
// class MainModel extends MainEntity{
//   MainModel({required super.mainCategory});
//
//   factory MainModel.fromJson(Map<String, dynamic> json) {
//     return MainModel(
//       mainCategory: json['mainCategories'] != null
//           ? (json['mainCategories'] as List)
//           .map((e) => MainCategoryWalletModel.fromJson(e as Map<String, dynamic>))
//           .toList()
//           : [],
//     );
//   }
// }