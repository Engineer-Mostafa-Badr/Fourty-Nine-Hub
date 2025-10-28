import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../cubit/create_restaurant_cubit.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../restaurants_list/domain/entities/food_category_entity.dart';
import '../../../../../res/style/styles.dart';

class CreateRestaurantSubcategoryDropdown extends StatelessWidget {
  const CreateRestaurantSubcategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final createResturantCubit = context.read<CreateRestaurantCubit>();
    return BlocConsumer<CreateRestaurantCubit, CreateRestaurantState>(
      buildWhen: (previous, current) =>
          current is CreateRestaurantSubCategoriesLoaded,
      builder: (context, state) {
        if (state is CreateRestaurantSubCategoriesLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
                  builder: (context, st) {
                return DropdownButtonFormField<FoodCategoryEntity>(
                  icon:  Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: AppColors.getTextColor(context),
                  ),
                  dropdownColor: AppColors.getFillColor(context),
                  decoration: InputDecoration(
                    fillColor: AppColors.getFillColor(context),
                    isDense: true,
                    constraints: BoxConstraints.loose(
                      Size.fromHeight(90.h),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color:
                            st is ValidationState && (st.isSubCategory ?? true)
                                ? Colors.red
                                : Colors.transparent,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color:
                            st is ValidationState && (st.isSubCategory ?? true)
                                ? Colors.red
                                : Colors.transparent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color:
                            st is ValidationState && (st.isSubCategory ?? true)
                                ? Colors.red
                                : Colors.transparent,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color:
                            st is ValidationState && (st.isSubCategory ?? true)
                                ? Colors.red
                                : Colors.transparent,
                      ),
                    ),
                  ),
                  items: state.subCategories
                      .map((e) => DropdownMenuItem<FoodCategoryEntity>(
                          value: e,
                          child: Text(
                            (context.isArabic ? e.nameAr : e.nameEn) ?? "",
                            style: Styles.mediumText(
                              color:AppColors.getTextColor(context),
                                // color: Theme.of(context)
                                //     .textTheme
                                //     .bodyMedium
                                //     ?.color
                            ), // Add your desired text style here
                          )))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      createResturantCubit.selectSubcategory(value);
                    }
                  },
                  menuMaxHeight: MediaQuery.of(context).size.height / 2,
                  isExpanded: true,
                  hint: Text(
                    LocaleKeys.selecteSubcategory.tr(),
                    style: Styles
                        .mediumText(), // You can adjust this hint style as needed
                  ),
                );
              }),
              BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
                  builder: (context, st) {
                return Visibility(
                  visible: st is ValidationState && (st.isSubCategory ?? true),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5, left: 5, top: 5.0),
                    child: Text(
                      LocaleKeys.youHaveToChooseFavoriteSubcategory.localize,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              })
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
      listener: (BuildContext context, CreateRestaurantState state) {},
    );
  }
}
