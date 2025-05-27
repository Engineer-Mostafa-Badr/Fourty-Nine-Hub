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
          return state.data!.isNotEmpty && state.data != null
              ? GridView.builder(
                  padding: EdgeInsets.all(24.w),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .65,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemCount: state.data?.length ?? 0,
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: InkWell(
                      onTap: () {
                        if (state.data![i].id == '62c8b5b09332225799fe335e') {
                          context.push(
                            Routes.MARRIAGESUBCATEGORIES,
                            extra: state.data![i],
                          );
                        } else {
                          context.push(
                            Routes.SUBCATEGORIES,
                            extra: state.data![i],
                          );
                        }

                        print('state.data![i]: ${state.data![i].id}');
                      },
                      child: MainCategoryBanner(
                        fromFavorite: true,
                        category: state.data![i],
                        canRegister: false,
                        onFavorite: () async {
                          var result = await controller
                              .removeFavorite(state.data![i].id);
                          if (result == true) {
                            state.data?.removeWhere(
                                (element) => element.id == state.data![i].id);
                          }
                        },
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Label(
                      style: Styles.mediumText(
                        fontSize: 60.sp,
                        color: context.isDarkMode ? Colors.white : Colors.black,
                      ),
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      text: LocaleKeys.noFavouriteCategory.localize));
        },
      ),
    );
  }
}
