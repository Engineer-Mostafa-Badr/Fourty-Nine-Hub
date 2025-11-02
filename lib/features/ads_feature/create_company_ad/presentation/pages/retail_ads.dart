import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/create_company_ad_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class RetailAds extends StatefulWidget {
  const RetailAds({super.key});

  @override
  State<RetailAds> createState() => _RetailAdsState();
}

class _RetailAdsState extends State<RetailAds> {
  @override
  void initState() {
    context.read<CreateCompanyAdCubit>().loadMainCategories(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCompanyAdCubit, CreateCompanyAdState>(
        builder: (context, state) {
      if (state.status == StateStatus.loading) {
        return const Center(child: CustomCircularProgressIndicator());
      }
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(children: [
          SizedBox(
            width: double.infinity,
            child: DropdownButtonFormField<MainCategoryEntity>(
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.grey, // Border color
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.grey, // Border color
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.grey, // Border color
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.grey, // Border color
                  ),
                ),
              ),
              hint: Text(
                  context.isArabic ? 'اختر القسم' : 'Select Main Category'),
              initialValue: null,
              onChanged: (MainCategoryEntity? newValue) {
                context
                    .read<CreateCompanyAdCubit>()
                    .onSelectMainCategory(newValue);
              },
              dropdownColor:
                  context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.white,
              items: state.mainCategories
                  ?.map<DropdownMenuItem<MainCategoryEntity>>(
                      (MainCategoryEntity mainCategory) {
                return DropdownMenuItem<MainCategoryEntity>(
                  value: mainCategory,
                  child: Text(getLang() == 'ar'
                      ? mainCategory.name ?? ''
                      : mainCategory.nameEn ??
                          ''), // Change to city.nameAr for Arabic
                );
              }).toList(),
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          state.status == StateStatus.loadingSubCategories
              ? const Center(child: CustomCircularProgressIndicator())
              : state.subCategories == null ||
                      (state.subCategories?.isEmpty ?? false)
                  ? const SizedBox()
                  : SizedBox(
                      width: double.infinity,
                      child: DropdownButtonFormField<SubCategoryEntity>(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.grey, // Border color
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.grey, // Border color
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.grey, // Border color
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.grey, // Border color
                            ),
                          ),
                        ),
                        hint: Text(context.isArabic
                            ? 'اختر القسم'
                            : 'Select Sub Category'),
                        initialValue: null,
                        onChanged: (SubCategoryEntity? newValue) {
                          context
                              .read<CreateCompanyAdCubit>()
                              .onSelectSubCategory(newValue);
                        },
                        dropdownColor: context.isDarkMode
                            ? AppColors.QUANTITY_COLOR
                            : Colors.white,
                        items: state.subCategories
                            ?.map<DropdownMenuItem<SubCategoryEntity>>(
                                (SubCategoryEntity mainCategory) {
                          return DropdownMenuItem<SubCategoryEntity>(
                            value: mainCategory,
                            child: Text(getLang() == 'ar'
                                ? mainCategory.nameAr ?? ''
                                : mainCategory.nameEn ??
                                    ''), // Change to city.nameAr for Arabic
                          );
                        }).toList(),
                      ),
                    ),
          Spacer(),
          DefaultButton(
            onPressed: () {
              ManageVibration.vibrate();
              if (state.selectedMainCategories == null) {
                showErrorMessage(
                    context,
                    context.isArabic
                        ? 'يرجى اختيار القسم'
                        : 'Please select main category');
              } else if (state.selectedSubCategories == null) {
                showErrorMessage(
                    context,
                    context.isArabic
                        ? 'يرجى اختيار القسم'
                        : 'Please select sub category');
              } else if (state.selectedMainCategories != null &&
                  state.selectedSubCategories != null) {
                context.push(Routes.CREATEAD,
                    extra: CategorizationEntity(
                        mainCategory: state.selectedMainCategories!,
                        subCategory: state.selectedSubCategories!));
              }
            },
            label: LocaleKeys.createAd.localize,
            width: double.infinity,
          )
        ]),
      );
    });
  }
}
