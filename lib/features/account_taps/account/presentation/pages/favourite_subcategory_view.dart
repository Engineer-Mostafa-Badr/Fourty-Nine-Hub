import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/account/presentation/cubit/managers/favourite_subcategories_cubit.dart';
import 'package:fourtyninehub/features/account_taps/account/presentation/pages/widgets/favourite_sub_category_card.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/enums/base_status_enum.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';

class FavSubCategoryView extends StatelessWidget {
  const FavSubCategoryView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<FavouriteSubCategoryCubit>(
        create: (BuildContext context) => serviceLocator()..load(),
        child:
            BlocBuilder<FavouriteSubCategoryCubit, FavouriteSubCategoryState>(
          builder: (context, state) {
            final controller = context.read<FavouriteSubCategoryCubit>();
            return state.status == StateStatus.loading
                ? const Center(
                    // ignore: unnecessary_const
                    child: const CustomCircularProgressIndicator(),
                  )
                : state.data != null && state.data!.isNotEmpty
                    ? GridView.builder(
                        itemCount: state.data?.length,
                        padding: EdgeInsets.all(24.w),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: .65,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        itemBuilder: (context, index) =>
                            FavouriteSubCategoryCard(
                          item: state.data![index],
                          onFav: () async {
                            var result =
                                await controller.toggleSubCategoryToFavorites(
                                    state.data![index].id);
                            if (result == true) {
                              state.data!.removeWhere((element) =>
                                  element.id == state.data![index].id);
                            }
                          },
                          mainCategory: state.mainCategory![index],
                        ),
                      )
                    : Center(
                        child: Label(
                          style: Styles.mediumText(
                            fontSize: 60.sp,
                            color: context.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          text: LocaleKeys.noFavouriteSubCategory.localize,
                        ),
                      );
          },
        ),
      ),
    );
  }

  Widget drawerRollWidget(
      {required String label,
      required String image,
      required void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            image,
            width: 40.h,
            height: 40.h,
            fit: BoxFit.cover,
          ),
          Label(
              text: label,
              style: Styles.mediumText(
                  fontWeight: FontWeight.w400, color: Colors.black)),
        ],
      ),
    );
  }
}
