import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/localization/locales.dart';

class DropDownChance extends StatefulWidget {
  const DropDownChance({super.key});

  @override
  State<DropDownChance> createState() => _DropDownChanceState();
}

class _DropDownChanceState extends State<DropDownChance> {
  String? selectedCategory;
  String? selectedSubCategory;

  final List<Map<String, dynamic>> categories = [
    {'id': '1', 'nameEn': 'Category 1', 'nameAr': 'الفئة 1'},
    {'id': '2', 'nameEn': 'Category 2', 'nameAr': 'الفئة 2'},
  ];

  final List<Map<String, dynamic>> subCategories = [
    {'id': '1', 'nameEn': 'SubCategory 1', 'nameAr': 'الفرعية 1', 'categoryId': '1'},
    {'id': '2', 'nameEn': 'SubCategory 2', 'nameAr': 'الفرعية 2', 'categoryId': '1'},
    {'id': '3', 'nameEn': 'SubCategory 3', 'nameAr': 'الفرعية 3', 'categoryId': '2'},
    {'id': '4', 'nameEn': 'SubCategory 4', 'nameAr': 'الفرعية 4', 'categoryId': '2'},
  ];

  List<Map<String, dynamic>> filteredSubCategories = [];

  void _filterSubCategories(String categoryId) {
    setState(() {
      filteredSubCategories = subCategories
          .where((subCategory) => subCategory['categoryId'] == categoryId)
          .toList();
      selectedSubCategory = null;
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
          child: DropdownButton(
            hint: Text(
              selectedCategory ?? LocaleKeys.selectCategory.localize,
              style: TextStyle(
                fontSize: 30.sp,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            menuMaxHeight: 200,
            dropdownColor: Theme.of(context).primaryColor,
            value: selectedCategory,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            icon: Icon(Icons.arrow_drop_down,
                size: 50.sp, color: Theme.of(context).scaffoldBackgroundColor),
            items: categories.map((category) {
              return DropdownMenuItem<String>(
                value: category['id'],
                child: Text(
                  context.locale == Locales.english
                      ? category['nameEn']
                      : category['nameAr'],
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
              });
              _filterSubCategories(newCategoryId!);
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
              menuMaxHeight: 200,
              dropdownColor: Theme.of(context).primaryColor,
              value: selectedSubCategory,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down,
                  size: 50.sp,
                  color: Theme.of(context).scaffoldBackgroundColor),
              items: filteredSubCategories.map((subCategory) {
                return DropdownMenuItem<String>(
                  value: subCategory['id'],
                  child: Text(
                    context.locale == Locales.english
                        ? subCategory['nameEn']
                        : subCategory['nameAr'],
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
// import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// import 'package:fourtyninehub/core/extensions/string_extension.dart';
// import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/main_category_entity.dart';
//
// import '../../../../../common/models/public/pagination_params.dart';
// import '../../../../../core/localization/locale_keys.g.dart';
// import '../../../../../core/localization/locales.dart';
// import '../../../account_taps/wallet/presentation/cubit/wallet_cubit.dart';
//
// class DropDownChance extends StatefulWidget {
//   const DropDownChance({super.key});
//
//   @override
//   State<DropDownChance> createState() => _DropDownChanceState();
// }
//
//
// class _DropDownChanceState extends State<DropDownChance> {
//   String? selectedCategory;
//   String? selectedSubCategory;
//   List<MainCategoryWalletEntity> categories = [];
//   List<MainCategoryWalletEntity> subCategories = [];
//   bool isCategoryLoading = true;
//   bool isSubCategoryLoading = false;
//   @override
//   void initState() {
//     super.initState();
//     _fetchCategories();
//   }
//
//   void _fetchCategories() async {
//     final categories = await context.read<WalletCubit>()
//         .fetchMainCategoryWallet(paginationParams: PaginationParams(page: 1));
//     setState(() {
//       this.categories = categories;
//       isCategoryLoading = false;
//     });
//   }
//   void _fetchSubCategories(String categoryId) async {
//     setState(() {
//       isSubCategoryLoading = true;
//     });
//     final subCategories = await context
//         .read<WalletCubit>()
//         .fetchSubCategoryWallet(
//         id: categoryId, paginationParams: PaginationParams(page: 1));
//     setState(() {
//       this.subCategories = subCategories;
//       isSubCategoryLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Category Dropdown
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           decoration: BoxDecoration(
//             color: Theme.of(context).primaryColor,
//             borderRadius: BorderRadius.circular(12.r),
//             boxShadow: [
//               BoxShadow(
//                 color: Theme.of(context).scaffoldBackgroundColor,
//                 spreadRadius: 2,
//                 blurRadius: 5,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: DropdownButton<String>(
//             hint: Text(
//               selectedCategory ?? LocaleKeys.selectCategory.localize,
//               style: TextStyle(
//                 fontSize: 30.sp,
//                 color: Theme.of(context).scaffoldBackgroundColor,
//               ),
//             ),
//             // menuWidth: double.infinity,
//             menuMaxHeight: 200,
//             dropdownColor: Theme.of(context).primaryColor,
//             value: selectedCategory,
//             isExpanded: true,
//             underline: const SizedBox.shrink(),
//             icon: Icon(Icons.arrow_drop_down,
//                 size: 50.sp, color: Theme.of(context).scaffoldBackgroundColor),
//             items: isCategoryLoading
//                 ? [
//               DropdownMenuItem(
//                   value: null,
//                   child: Label(
//                     text: LocaleKeys.selectCategory.localize,
//                     color: Theme.of(context).scaffoldBackgroundColor,
//                   ))
//             ]
//                 : categories.map((category) {
//               return DropdownMenuItem<String>(
//                 value: category.id,
//                 child: Text(
//                   context.locale == Locales.english
//                       ? category.nameEn
//                       : category.nameAr,
//                   style: TextStyle(
//                     fontSize: 30.sp,
//                     color: Theme.of(context).scaffoldBackgroundColor,
//                   ),
//                 ),
//               );
//             }).toList(),
//             onChanged: (newCategoryId) {
//               setState(() {
//                 selectedCategory = newCategoryId;
//                 selectedSubCategory = null;
//               });
//               if (newCategoryId != null) {
//                 _fetchSubCategories(newCategoryId);
//               }
//             },
//           ),
//         ),
//
//         // Subcategory Dropdown (only show when a category is selected)
//         if (selectedCategory != null) ...[
//           SizedBox(height: 16.h),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//               borderRadius: BorderRadius.circular(12.r),
//               boxShadow: [
//                 BoxShadow(
//                   color: Theme.of(context).scaffoldBackgroundColor,
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: DropdownButton<String>(
//               hint: Text(
//                 selectedSubCategory ?? LocaleKeys.selectSubCategory.localize,
//                 style: TextStyle(
//                   fontSize: 30.sp,
//                   color: Theme.of(context).scaffoldBackgroundColor,
//                 ),
//               ),
//               underline: const SizedBox.shrink(),
//               // menuWidth: double.infinity,
//               menuMaxHeight: 200,
//               dropdownColor: Theme.of(context).primaryColor,
//               value: selectedSubCategory,
//               isExpanded: true,
//               icon: Icon(Icons.arrow_drop_down,
//                   size: 50.sp,
//                   color: Theme.of(context).scaffoldBackgroundColor),
//               items: isSubCategoryLoading
//                   ? [
//                 DropdownMenuItem(
//                     value: null,
//                     child: Label(
//                       text: LocaleKeys.selectSubCategory.localize,
//                       color: Theme.of(context).scaffoldBackgroundColor,
//                     ))
//               ]
//                   : subCategories.map((subCategory) {
//                 return DropdownMenuItem<String>(
//                   value: subCategory.id,
//                   child: Text(
//                     context.locale == Locales.english
//                         ? subCategory.nameEn
//                         : subCategory.nameAr,
//                     style: TextStyle(
//                       fontSize: 30.sp,
//                       color: Theme.of(context).scaffoldBackgroundColor,
//                     ),
//                   ),
//                 );
//               }).toList(),
//               onChanged: (newSubCategoryId) {
//                 setState(() {
//                   selectedSubCategory = newSubCategoryId;
//                 });
//               },
//             ),
//           ),
//         ],
//       ],
//     );
//   }
// }
//.....................................