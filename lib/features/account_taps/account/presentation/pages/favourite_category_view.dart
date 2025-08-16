import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/style/styles.dart';
import '../cubit/managers/favourite_categories_cubit.dart';

class FavouriteCategoryView extends StatefulWidget {
  const FavouriteCategoryView({super.key});

  @override
  State<FavouriteCategoryView> createState() => _FavouriteCategoryViewState();
}

class _FavouriteCategoryViewState extends State<FavouriteCategoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FavouriteCategoryCubit, FavouriteCategoryState>(
        builder: (context, state) {
          final controller = context.read<FavouriteCategoryCubit>();
          if (state.status == StateStatus.loading) {
            return const Center(
              child: CustomCircularProgressIndicator(),
            );
          }
          // if (state.status == StateStatus.error) {
          //   return Center(child: Text(state.failure!.toString()));
          // }
          if (state.data!.isNotEmpty && state.data != null) {
            return GlowingOverscrollIndicator(
              color: AppColors.SECONDARY_COLOR,
              axisDirection: AxisDirection.down,
              child: GridView.builder(
                padding: EdgeInsets.all(24.w),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .65,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: state.data?.length ?? 0,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: InkWell(
                      onTap: () {
                        ManageVibration.vibrate();
                        if (state.data![i].categoryEntity.id ==
                            '62c8b5b09332225799fe335e') {
                          context.pushNamed(
                            Routes.MARRIAGESUBCATEGORIES,
                            extra: state.data![i].categoryEntity,
                          );
                        } else {
                          context.pushNamed(
                            Routes.SUBCATEGORIES,
                            extra: state.data![i].categoryEntity,
                          );
                        }

                        print(
                            'state.data![i]: ${state.data![i].categoryEntity.id}');
                      },
                      child: MainCategoryBanner(
                        category: state.data![i].categoryEntity,
                        canRegister: false,
                        onFavorite: () async {
                          var result = await controller.removeFavoriteCategory(
                              state.data![i].categoryEntity.id);
                          if (result == true) {
                            state.data?.removeWhere((element) =>
                                element.id == state.data![i].categoryEntity.id);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: Label(
                style: Styles.mediumText(
                  fontSize: 60.sp,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
                maxLines: 3,
                textAlign: TextAlign.center,
                text: LocaleKeys.noFavouriteCategory.localize,
              ),
            );
          }
        },
      ),
    );
  }
}
