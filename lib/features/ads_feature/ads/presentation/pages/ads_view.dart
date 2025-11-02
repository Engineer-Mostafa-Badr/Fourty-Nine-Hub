import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/common/widgets/stateless/loaders/default_loader.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/provider_ads_view.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/user_ads_view.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../core/widget/custom_floating_action_button.dart';
import '../../../../../core/widget/custom_scaffold.dart';

class AdsView extends StatefulWidget {
  final AdsViewParams params;

  const AdsView({
    super.key,
    required this.params,
  });

  @override
  State<AdsView> createState() => _AdsViewState();
}

class _AdsViewState extends State<AdsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool isFloatingButtonVisible = true;

  @override
  void initState() {
    // scrollController.addListener(() {
    //   if (scrollController.position.userScrollDirection ==
    //       ScrollDirection.reverse) {
    //     isFloatingButtonVisible = false;
    //   } else {
    //     isFloatingButtonVisible = true;
    //   }
    //   setState(() {});
    // });
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    if (widget.params.mainCategory.nameEn == 'Dating') {
      context.read<AdvertisementCubit>().loadAdsData(
            subCategoryId: widget.params.subCategory.id,
            filter: 'male',
          );
    } else {
      context.read<AdvertisementCubit>().loadAdsData(
            subCategoryId: widget.params.subCategory.id,
            filter: widget.params.subCategory.hasAuction == true
                ? 'sale'
                : 'provider',
          );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String userType = '';
    if (_tabController.index == 0 &&
        widget.params.mainCategory.nameEn == 'Dating') {
      userType = 'male';
    } else if (_tabController.index == 1 &&
        widget.params.mainCategory.nameEn == 'Dating') {
      userType = 'female';
    } else if (_tabController.index == 0 &&
        widget.params.subCategory.hasAuction == true) {
      userType = 'sale';
    } else if (_tabController.index == 1 &&
        widget.params.subCategory.hasAuction == true) {
      userType = 'rent';
      debugPrint('provider');
    } else if (_tabController.index == 0 &&
        widget.params.subCategory.hasAuction == false) {
      userType = 'provider';
      debugPrint('provider');
    } else {
      userType = 'user';
      debugPrint('user');
    }
    debugPrint('userType index ${_tabController.index}');
    debugPrint('userType hasAuction ${widget.params.subCategory.hasAuction}');
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: HomeAppbar(
          isWithBackArrow: true,
          onBackPressed: () => context.pop(),
        ),
      ),

      body: BlocConsumer<AdvertisementCubit, AdsState>(
          listener: (context, state) {
        if (state.status == AdsStates.loading) {
          debugPrint("state.status${state.status}");
        } else if (state.status == AdsStates.error) {
          debugPrint("state.status${state.status}");
        } else if (state.status == AdsStates.success) {
          debugPrint("state.status${state.status}");
        }
      }, builder: (context, state) {
        final controller = context.read<AdvertisementCubit>();
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Column(
                children: [
                  const Sizer(),
                  SizedBox(
                      width: double.infinity,
                      child: MainCategoryBanner(
                        category: widget.params.mainCategory,
                        onFavorite: () async {
                          // Check if this is a health category and call the appropriate toggle method
                          if (widget.params.mainCategory.nameEn == 'Health') {
                            return await context
                                .read<HealthCubit>()
                                .toggleFavoriteCategory(
                                    widget.params.mainCategory.id);
                          }
                          return false;
                        },
                        isFavorite: widget.params.mainCategory.isFavorite,
                      )),
                  const Sizer(),
                  Label(
                    text: context.isArabic
                        ? widget.params.subCategory.nameAr
                        : widget.params.subCategory.nameEn,
                    style: Styles.headerText(),
                  ),
                  const Sizer(),
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.getRedColor(context),
                    unselectedLabelColor: Theme.of(context).primaryColor,
                    indicatorColor: AppColors.getRedColor(context),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: Styles.headerText(),
                    onTap: (i) {
                      ManageVibration.vibrate();
                      if (i == 1) {
                        state.city = '';
                        state.governorate = '';
                        if (widget.params.mainCategory.nameEn == 'Dating') {
                          controller.loadAdsData(
                            subCategoryId: widget.params.subCategory.id,
                            filter: 'female',
                          );
                          userType = 'female';
                        } else {
                          controller.loadAdsData(
                            subCategoryId: widget.params.subCategory.id,
                            filter: widget.params.subCategory.hasAuction == true
                                ? 'rent'
                                : 'user',
                          );
                          userType =
                              widget.params.subCategory.hasAuction == true
                                  ? 'rent'
                                  : 'user';
                        }
                      } else {
                        if (widget.params.mainCategory.nameEn == 'Dating') {
                          controller.loadAdsData(
                            subCategoryId: widget.params.subCategory.id,
                            filter: 'male',
                          );
                          userType = 'male';
                        } else {
                          controller.loadAdsData(
                            subCategoryId: widget.params.subCategory.id,
                            filter: widget.params.subCategory.hasAuction == true
                                ? 'sale'
                                : 'provider',
                          );
                          userType =
                              widget.params.subCategory.hasAuction == true
                                  ? 'sale'
                                  : 'provider';
                        }
                      }
                    },
                    tabs: [
                      Tab(
                        text: widget.params.mainCategory.nameEn == 'Dating'
                            ? LocaleKeys.maleUser.localize
                            : widget.params.subCategory.hasAuction == true
                                ? LocaleKeys.sale.localize
                                : LocaleKeys.provider.localize,
                      ),
                      Tab(
                        text: widget.params.mainCategory.nameEn == 'Dating'
                            ? LocaleKeys.femaleUser.localize
                            : widget.params.subCategory.hasAuction == true
                                ? LocaleKeys.rent.localize
                                : LocaleKeys.user.localize,
                      ),
                    ],
                  ),

                  /// Provider Ads and User Ads
                  state.status == AdsStates.loading
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child: const DLoader(),
                          ),
                        )
                      : Expanded(
                          child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _tabController,
                          children: [
                            /// provider Ads view
                            ProviderAdsView(
                              params: widget.params,
                              userType: userType,
                              controller: controller,
                              onScrollChanged: (isVisible) {
                                setState(() {
                                  isFloatingButtonVisible = isVisible;
                                });
                              },
                            ),

                            /// user ads View
                            UserAdsView(
                              params: widget.params,
                              userType: userType,
                              onScrollChanged: (isVisible) {
                                setState(() {
                                  isFloatingButtonVisible = isVisible;
                                });
                              },
                            ),
                          ],
                        ))
                ],
              ),
              if (state.isFilterLoading)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CustomCircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
            ],
          ),
        );
      }),
      // floatingActionButton:buildFloatingAction(context),
      floatingActionButton: isFloatingButtonVisible
          ? CustomFloatingActionButton(
              onPressed: () {
                ManageVibration.vibrate();
                if (context.isUserLoggedIn) {
                  context.push(Routes.CREATEAD,
                      extra: CategorizationEntity(
                          mainCategory: widget.params.mainCategory,
                          subCategory: widget.params.subCategory));
                } else {
                  return pleaseLoginDialog(context);
                  // context.push(Routes.LOGIN);
                }
              },
              iconSize: 18,
              // icon: Icons.add,
              text: '${LocaleKeys.addAde.localize} +',
            )
          : null,
    );
  }

  Widget buildFloatingAction(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        ManageVibration.vibrate();
        if (context.isUserLoggedIn) {
          context.push(Routes.CREATEAD,
              extra: CategorizationEntity(
                  mainCategory: widget.params.mainCategory,
                  subCategory: widget.params.subCategory));
        } else {
          return pleaseLoginDialog(context);

          // context.push(Routes.LOGIN);
        }
      },
      backgroundColor: AppColors.getButtonPrimaryColor(context),
      icon: Icon(
        Icons.add,
        color: AppColors.getReversedTextColor(context),
      ),
      label: Label(
        text: LocaleKeys.addAde.localize,
        style: Styles.mediumText(
            fontWeight: FontWeight.bold,
            color: AppColors.getReversedTextColor(context)),
      ),
    );
  }
}

class AdsViewParams {
  final MainCategoryEntity mainCategory;
  final SubCategoryEntity subCategory;

  AdsViewParams({required this.mainCategory, required this.subCategory});
}

enum Categories {
  craft,
  talent,
  homeService,
  homeEssentials,
  healthyTools,
  industry,
  scenery,
  realEstate,
  cars,
  vehicles,
  spareParts,
  fashionBeauty,
  accessories,
  jewelryWatches,
  collectiblesGifts,
  animals,
  computersCameras,
  mobilesTablets,
  musicalInstruments,
  fitness,
  education,
  libraries,
  packaging,
  equipment,
  rawMaterials,
  remnants,
  marketingSales,
  jobs,
  tourism,
  technology,
  accountantJob,
  doctorJob,
  engineerJob,
  otherJob,
  events,
  projects,
  health,
  dating,
  smooking,
  farming,
  governmentCharity
}
