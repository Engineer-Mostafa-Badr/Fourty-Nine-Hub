import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/account_taps/account/presentation/cubit/managers/favourite_subcategories_cubit.dart';
import 'package:fourtyninehub/features/account_taps/account/presentation/pages/widgets/favourite_sub_category_card.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/enums/base_status_enum.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';

class FavSubCategoryView extends StatelessWidget {
  const FavSubCategoryView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: BackAppBar(
        label: LocaleKeys.favouriteSubCategories.localize,
        textColor: Colors.white,
        iconColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(50.r),
            ),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: BlocProvider<FavouriteSubCategoryCubit>(
            create: (BuildContext context) => serviceLocator()..load(),
            child: BlocBuilder<FavouriteSubCategoryCubit,
                FavouriteSubCategoryState>(
              builder: (context, state) {
                final controller = context.read<FavouriteSubCategoryCubit>();
                return state.status == StateStatus.loading
                    ? const Center(
                        // ignore: unnecessary_const
                        child: const CircularProgressIndicator(),
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
                                var result = await controller
                                    .toggleSubCategoryToFavorites(
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
                                style: Styles.mediumText(fontSize: 60.sp),
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                text: LocaleKeys
                                    .noFavouriteSubCategory.localize));
              },
            ),
          ),
        ),
      ),
    );
    /*return Stack(
      alignment: Alignment.centerLeft,
      children: [
        CustomScaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: BackAppBar(
            label: LocaleKeys.favouriteSubCategories.localize,
            textColor: Colors.white,
            iconColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(50.r),
                ),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: BlocProvider<FavouriteSubCategoryCubit>(
                create: (BuildContext context) => serviceLocator()..load(),
                child: BlocBuilder<FavouriteSubCategoryCubit,
                    FavouriteSubCategoryState>(
                  builder: (context, state) {
                    final controller =
                        context.read<FavouriteSubCategoryCubit>();
                    return state.status == StateStatus.loading
                        ? const Center(
                            // ignore: unnecessary_const
                            child: const CircularProgressIndicator(),
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
                                    var result = await controller
                                        .toggleSubCategoryToFavorites(
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
                                    style: Styles.mediumText(fontSize: 60.sp),
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    text: LocaleKeys
                                        .noFavouriteSubCategory.localize));
                  },
                ),
              ),
            ),
          ),
        ),
        PositionedDirectional(
          start: 0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              false
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.horizontal(
                          end: Radius.circular(60.r),
                        ),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 10)
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        child: Column(
                          spacing: 16.h,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            drawerRollWidget(
                              label: LocaleKeys.ride.localize,
                              image: Assets.rideIcon,
                              onTap: () => context.push(Routes.RIDE),
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.loading.localize,
                              image: Assets.loading,
                              onTap: () {},
                              // onTap: () => context.push(Routes.RIDE),
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.health.localize,
                              image: Assets.healthIcon,
                              onTap: () {},
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.meal.localize,
                              image: Assets.meal,
                              onTap: () {},
                              // onTap: () => context.push(Routes.RIDE),
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.find.localize,
                              image: Assets.find,
                              onTap: () {},
                              // onTap: () => context.push(Routes.),
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.reel.localize,
                              image: Assets.reel,
                              // onTap: () {},
                              onTap: () => context.push(Routes.REELS),
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.spotlight.localize,
                              image: Assets.spotlight,
                              // onTap: () {},
                              onTap: () => context.push(Routes.SPOTLIGHT),
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.meet.localize,
                              image: Assets.meet,
                              // onTap: () {},
                              onTap: () => context.push(Routes.MEETINGROOM),
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.live.localize,
                              image: Assets.liveIcon,
                              // onTap: () {},
                              onTap: () => context.push(Routes.LIVE),
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.snap.localize,
                              image: Assets.snap,
                              // onTap: () {},
                              onTap: () => context.push(Routes.SNAP),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 100,
                  width: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadiusDirectional.horizontal(
                      end: Radius.circular(20.r),
                    ),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 10)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );*/
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
