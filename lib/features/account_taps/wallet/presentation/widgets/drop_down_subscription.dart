import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/main_category_entity.dart';

import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/localization/locales.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../subscripe/presentation/controllers/subscription_controller.dart';
import '../cubit/wallet_cubit.dart';

class DropDownSubscription extends StatefulWidget {
  const DropDownSubscription({super.key});

  @override
  _DropDownSubscriptionState createState() => _DropDownSubscriptionState();
}

class _DropDownSubscriptionState extends State<DropDownSubscription> {
  String? selectedCategory;
  String? selectedSubCategory;
  List<MainCategoryWalletEntity> categories = [];
  List<MainCategoryWalletEntity> subCategories = [];
  bool isCategoryLoading = true;
  bool isSubCategoryLoading = false;
  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() async {
    final categories = await context
        .read<WalletCubit>()
        .fetchMainCategoryWallet(paginationParams: PaginationParams(page: 1));
    setState(() {
      this.categories = categories;
      isCategoryLoading = false;
    });
  }

  void _fetchSubCategories(String categoryId) async {
    setState(() {
      isSubCategoryLoading = true;
    });
    final subCategories = await context
        .read<WalletCubit>()
        .fetchSubCategoryWallet(
            id: categoryId, paginationParams: PaginationParams(page: 1));
    setState(() {
      this.subCategories = subCategories;
      isSubCategoryLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Category Dropdown
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).scaffoldBackgroundColor,
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButton<String>(
            hint: Text(
              selectedCategory ?? LocaleKeys.selectCategory.localize,
              style: TextStyle(
                fontSize: 30.sp,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            // menuWidth: double.infinity,
            menuMaxHeight: 200,
            dropdownColor: Theme.of(context).primaryColor,
            value: selectedCategory,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            icon: Icon(Icons.arrow_drop_down,
                size: 50.sp, color: Theme.of(context).scaffoldBackgroundColor),
            items: isCategoryLoading
                ? [
                    DropdownMenuItem(
                        value: null,
                        child: Label(
                          text: LocaleKeys.selectCategory.localize,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ))
                  ]
                : categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category.id,
                      child: Text(
                        context.locale == Locales.english
                            ? category.nameEn
                            : category.nameAr,
                        style: TextStyle(
                          fontSize: 30.sp,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    );
                  }).toList(),
            onChanged: (newCategoryId) {
              setState(() {
                selectedCategory = newCategoryId;
                selectedSubCategory = null;
              });
              if (newCategoryId != null) {
                _fetchSubCategories(newCategoryId);
              }
            },
          ),
        ),

        // Subcategory Dropdown (only show when a category is selected)
        if (selectedCategory != null) ...[
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButton<String>(
              hint: Text(
                selectedSubCategory ?? LocaleKeys.selectSubCategory.localize,
                style: TextStyle(
                  fontSize: 30.sp,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
              underline: const SizedBox.shrink(),
              // menuWidth: double.infinity,
              menuMaxHeight: 200,
              dropdownColor: Theme.of(context).primaryColor,
              value: selectedSubCategory,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down,
                  size: 50.sp,
                  color: Theme.of(context).scaffoldBackgroundColor),
              items: isSubCategoryLoading
                  ? [
                      DropdownMenuItem(
                          value: null,
                          child: Label(
                            text: LocaleKeys.selectSubCategory.localize,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ))
                    ]
                  : subCategories.map((subCategory) {
                      return DropdownMenuItem<String>(
                        value: subCategory.id,
                        child: Text(
                          context.locale == Locales.english
                              ? subCategory.nameEn
                              : subCategory.nameAr,
                          style: TextStyle(
                            fontSize: 30.sp,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                      );
                    }).toList(),
              onChanged: (newSubCategoryId) {
                setState(() {
                  selectedSubCategory = newSubCategoryId;
                });
                if (newSubCategoryId != null) {
                  print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                  print(newSubCategoryId);
                  print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                  serviceLocator<SubscriptionController>()
                      .showSubscriptionPlans(
                    wallets: [
                      WalletTypes.mainWallet,
                      WalletTypes.giftWallet,
                      WalletTypes.balance,
                    ],
                    subCategoryId: newSubCategoryId,
                    title: LocaleKeys.ads.localize,
                  );
                }
              },
            ),
          ),
        ],
      ],
    );
  }
}

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fourtyninehub/core/extensions/string_extension.dart';
// import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/main_category_entity.dart';
//
// import '../../../../../common/models/public/pagination_params.dart';
// import '../../../../../common/widgets/stateful/dynamic/pagination_view.dart';
// import '../../../../../core/localization/locale_keys.g.dart';
// import '../../../../../core/localization/locales.dart';
// import '../../../../../service_locator/service_locator.dart';
// import '../../../../subscripe/presentation/controllers/subscription_controller.dart';
// import '../cubit/wallet_cubit.dart';
//
// class DropDownSubscription extends StatefulWidget {
//   @override
//   _DropDownSubscriptionState createState() => _DropDownSubscriptionState();
// }
//
// class _DropDownSubscriptionState extends State<DropDownSubscription> {
//   String? selectedCategory;
//   String? selectedSubCategory;
//   int? selectedIndex; // Track the selected index
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: GestureDetector(
//         onTap: () {
//           _showCategoryDialog();
//         },
//         child: Container(
//           padding:  EdgeInsets.symmetric(vertical: 22.h),
//           decoration: BoxDecoration(
//             color: Theme.of(context).primaryColor,
//             borderRadius: BorderRadius.circular(20.r),
//           ),
//           child: Center(
//             child: Text(
//               LocaleKeys.addSubcategoryToSubscribe.localize,
//               style: TextStyle(
//                 fontSize: 25.sp,
//                 color: Theme.of(context).scaffoldBackgroundColor,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showCategoryDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(LocaleKeys.selectCategory.localize),
//           content: ConstrainedBox(
//             constraints:  BoxConstraints(
//               maxHeight: 400.0.h, // Limits height to show only 4 items
//             ),
//             child: SizedBox(
//               height: 300.h,
//               child: PaginationView<MainCategoryWalletEntity>(
//                 build: (ScrollController scrollController,
//                     List<MainCategoryWalletEntity> data) {
//                   return SingleChildScrollView(
//                     controller: scrollController,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: data.isNotEmpty
//                           ? data.map((category) {
//                               String categoryName =
//                                   context.locale == Locales.english
//                                       ? category.nameEn
//                                       : category.nameAr;
//                               return ListTile(
//                                 title: Text(categoryName),
//                                 onTap: () {
//                                   Navigator.pop(
//                                     context,
//                                   ); // Close category dialog
//                                   _showSubCategoryDialog(category.id);
//                                 },
//                               );
//                             }).toList()
//                           : [Text(LocaleKeys.noCategoriesAvailable.localize)],
//                     ),
//                   );
//                 },
//                 fetchData: (PaginationParams paginationParams) {
//                   return context.read<WalletCubit>().fetchMainCategoryWallet(
//                       paginationParams: paginationParams);
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void _showSubCategoryDialog(String id) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(LocaleKeys.selecteSubcategory.localize),
//           content: ConstrainedBox(
//             constraints:  BoxConstraints(
//               maxHeight: 400.0.h, // Limits height to show only 4 items
//             ),
//             child: SizedBox(
//               height: 300.h,
//               child: PaginationView<MainCategoryWalletEntity>(
//                 build: (ScrollController scrollController,
//                     List<MainCategoryWalletEntity> data) {
//                   return SingleChildScrollView(
//                     controller: scrollController,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: data.isNotEmpty
//                           ? data.map((category) {
//                               String categoryName =
//                                   context.locale == Locales.english
//                                       ? category.nameEn
//                                       : category.nameAr;
//                               return ListTile(
//                                 title: Text(categoryName),
//                                 onTap: () {
//                                   Navigator.pop(
//                                     context,
//                                   ); // Close category dialog
//                                   serviceLocator<SubscriptionController>()
//                                       .showSubscriptionPlans(
//                                     subCategoryId: category.id,
//                                     wallets: [],
//                                   );
//                                 },
//                               );
//                             }).toList()
//                           : [Text(LocaleKeys.noCategoriesAvailable.localize)],
//                     ),
//                   );
//                 },
//                 fetchData: (PaginationParams paginationParams) {
//                   return context.read<WalletCubit>().fetchSubCategoryWallet(
//                       id: id, paginationParams: paginationParams);
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
