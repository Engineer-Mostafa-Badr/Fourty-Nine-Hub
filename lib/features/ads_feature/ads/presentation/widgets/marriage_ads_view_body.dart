import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/common/tab_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/marriage_ads_list_view.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/marriage_my_ads_list_view.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/marriage_request.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/sub_category_list_view_item.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../filter_ads/presentation/pages/filter_ads.dart';
import '../../../../subcategories/presentation/widgets/search_bar_widget.dart';
import '../../../../subcategories/presentation/pages/ads_search_view.dart';
import '../../../../subcategories/presentation/pages/favourite_ads_view.dart';
import '../../../../../../service_locator/service_locator.dart';
import '../../presentation/cubit/ads_cubit.dart';

class MarriageAdsViewBody extends StatefulWidget {
  final SubcategoriesCubit controller;

  final SubcategoriesState state;
  final ScrollController _scrollController;

  const MarriageAdsViewBody({
    super.key,
    required this.controller,
    required this.state,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  @override
  State<MarriageAdsViewBody> createState() => _MarriageAdsViewBodyState();
}

class _MarriageAdsViewBodyState extends State<MarriageAdsViewBody>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  late FocusNode _searchFocusNode;

  void animateTaps() {
    _tabController = TabController(
      length: widget.state.subCategories?.length ?? 0,
      vsync: this,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _scrollToSelectedTab(_tabController.index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    animateTaps();
    return Column(
      children: [
        if (widget.state.mainCategory != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HomeMainCategoryBanner(
              fromHome: false,
              category: context.read<SubcategoriesCubit>().state.mainCategory!,
              onFavorite: () async {
                var result = await widget.controller
                    .toggleFavoriteMedicalService(context
                            .read<SubcategoriesCubit>()
                            .state
                            .mainCategory
                            ?.id ??
                        '');
                return result;
              },
              isFavorite: context
                      .read<SubcategoriesCubit>()
                      .state
                      .mainCategory
                      ?.isFavorite ??
                  false,
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  ManageVibration.vibrate();
                  context
                      .read<SubcategoriesCubit>()
                      .toggleMyAds('isSearchAdsOpen');
                },
                child: Icon(
                  Icons.search,
                  color: context.read<SubcategoriesCubit>().isSearchAdsOpen
                      ? AppColors.SECONDARY_COLOR
                      : (context.isDarkMode
                          ? Colors.white
                          : AppColors.PRIMARY_COLOR),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: TabWidget(
                  title: context.isArabic ? 'مفضلة' : 'Favourites',
                  selected:
                      context.read<SubcategoriesCubit>().isFavouriteAdsOpen,
                  onTap: () {
                    ManageVibration.vibrate();
                    if (!context.isUserLoggedIn) {
                      return pleaseLoginDialog(context);
                    } else {
                      final mainCategoryId =
                          widget.state.mainCategory?.id ?? '';
                      context
                          .read<SubcategoriesCubit>()
                          .loadMyFavouriteAds(id: mainCategoryId);
                      context
                          .read<SubcategoriesCubit>()
                          .toggleMyAds('isFavouriteAdsOpen');
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: TabWidget(
                  title: LocaleKeys.requestLog.localize,
                  selected: context.read<SubcategoriesCubit>().isRequestLogOpen,
                  onTap: () {
                    ManageVibration.vibrate();
                    if (!context.isUserLoggedIn) {
                      return pleaseLoginDialog(context);
                    } else {
                      final mainCategoryId =
                          widget.state.mainCategory?.id ?? '';
                      if (mainCategoryId.isNotEmpty) {
                        context
                            .read<SubcategoriesCubit>()
                            .loadRequestsLogByMainCategory(
                                mainCategoryId: mainCategoryId);
                      }
                      context
                          .read<SubcategoriesCubit>()
                          .toggleMyAds('isRequestLogOpen');
                    }

                    // context.read<SubcategoriesCubit>().toggleRequestLog();
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: TabWidget(
                  title: LocaleKeys.myAds.localize,
                  selected: context.read<SubcategoriesCubit>().isMyAdsOpen,
                  onTap: () {
                    ManageVibration.vibrate();
                    final mainCategoryId = widget.state.mainCategory?.id ?? '';
                    if (mainCategoryId.isNotEmpty) {
                      context
                          .read<SubcategoriesCubit>()
                          .loadMyAds(id: mainCategoryId);
                    }
                    context
                        .read<SubcategoriesCubit>()
                        .toggleMyAds('isMyAdsOpen');
                    // context.push(Routes.MYADDS);
                  },
                ),
              ),
            ],
          ),
        ),
        const Sizer(),
        if (context.read<SubcategoriesCubit>().isSearchAdsOpen)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SearchBarWidget(
              focusNode: _searchFocusNode,
              onChanged: (value) {
                context.read<SubcategoriesCubit>().searchAds(
                      value: value,
                      mainCategoryId: widget.state.mainCategory?.id ?? '',
                    );
              },
            ),
          ),
        if (context.read<SubcategoriesCubit>().isSearchAdsOpen) const Sizer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    if (widget.state.subCategories == null ||
                        widget.state.subCategories!.isEmpty) {
                      return;
                    }
                    ManageVibration.vibrate();
                    dynamic data = await context.push(
                      Routes.FILTERADS,
                      extra: FilterAdsParams(
                        categorization: CategorizationEntity(
                          mainCategory: widget.state.mainCategory!,
                          fromMarriage: true,
                          subCategory: widget.state.subCategories![widget
                                  .state.subCategories
                                  ?.indexWhere((element) =>
                                      element.isSelected == true) ??
                              0],
                        ),
                        userType: '',
                      ),
                    );

                    if (data != null) {
                      debugPrint("objectsdaa");
                      widget.controller.changeFilterModel(data);
                      widget.controller.loadFilterData(
                        model: data,
                        filter: 'user',
                      );
                    }
                  },
                  child: Container(
                    height: 42,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: AppColors.getButtonPrimaryColor(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Label(
                            text: LocaleKeys.filter.localize,
                            style: Styles.mediumText(
                              color: AppColors.getReversedTextColor(context),
                            ),
                          ),
                        ),
                        Spacer(),
                        SvgPicture.asset(
                          Assets.arrowIcon,
                          width: 12.w,
                          height: 12.h,
                          colorFilter: ColorFilter.mode(
                            AppColors.getReversedTextColor(context),
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    if (widget.state.subCategories == null ||
                        widget.state.subCategories!.isEmpty) {
                      return;
                    }
                    ManageVibration.vibrate();
                    dynamic data = await context.push(
                        Routes.GOVERNORATEFILTERADS,
                        extra: CategorizationEntity(
                            mainCategory: widget.state.mainCategory!,
                            fromMarriage: true,
                            subCategory: widget.state.subCategories![widget
                                    .state.subCategories
                                    ?.indexWhere((element) =>
                                        element.isSelected == true) ??
                                0]));
                    if (data != null) {
                      debugPrint("data.cityId${data.cityId}");
                      debugPrint("data.governorateId${data.governorateId}");
                      debugPrint("objectsdaa");
                      widget.controller.state.city = data.cityId;
                      widget.controller.state.governorate = data.governorateId;
                      widget.controller.changeFilterModel(data);
                      await widget.controller
                          .loadFilterData(model: data, filter: 'user');
                    }
                  },
                  child: Container(
                    height: 42,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: AppColors.getButtonPrimaryColor(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Label(
                            text: LocaleKeys.city.localize,
                            style: Styles.mediumText(
                              color: AppColors.getReversedTextColor(context),
                            ),
                          ),
                        ),
                        Spacer(),
                        SvgPicture.asset(
                          Assets.arrowIcon,
                          width: 12.w,
                          height: 12.h,
                          colorFilter: ColorFilter.mode(
                            AppColors.getReversedTextColor(context),
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Sizer(),
        if (widget.state.subCategories != null)
          SizedBox(
            height: 70.h,
            child: TabBar(
              isScrollable: true,
              controller: _tabController,
              onTap: (index) async {
                await widget.controller.changeSubCatIndex(index);
              },
              padding: const EdgeInsets.symmetric(horizontal: 16),
              labelPadding: const EdgeInsetsDirectional.only(end: 10),
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              tabAlignment: TabAlignment.start,
              tabs: List.generate(
                widget.state.subCategories?.length ?? 0,
                (index) {
                  return Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: 0,
                      end: index == widget.state.subCategories!.length - 1
                          ? 16.0
                          : 0,
                    ),
                    child: SubCategoryListViewItem(
                      subCategory: widget.state.subCategories?[index],
                    ),
                  );
                },
              ),
            ),
          ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: _selectWidget(context),
        ),
      ],
    );
  }

  bool _isFloatVisible = true;
  @override
  void initState() {
    debugPrint('state:: ${widget.state.subCategories?.length}');
    _tabController = TabController(
        length: widget.state.subCategories?.length ?? 0, vsync: this);
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isFloatVisible) {
            setState(() => _isFloatVisible = false);
          }
        } else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!_isFloatVisible) {
            setState(() => _isFloatVisible = true);
          }
        }
      });
    _searchFocusNode = FocusNode();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _scrollToSelectedTab(_tabController.index);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _scrollToSelectedTab(int index) {
    // Assuming each tab has a width of 140.w
    double tabWidth = 235.w;
    double targetScrollPosition = index * tabWidth;
    _scrollController.animateTo(
      targetScrollPosition + 200,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Widget _selectWidget(BuildContext context) {
    if (widget.state.status == SubcategoriesStates.loadingAds) {
      return const CustomLoadingSearchWidget();
    }
    if (widget.state.status == SubcategoriesStates.loadingAds) {
      return const CustomLoadingSearchWidget();
    }

    // Search Ads
    if (context.read<SubcategoriesCubit>().isSearchAdsOpen) {
      return AdsSearchView(
        mainCategoryNameAr: widget.state.mainCategory?.name ?? '',
        mainCategoryNameEn: widget.state.mainCategory?.nameEn ?? '',
        isFloatingButtonVisible: (bool isVisible) {
          // Handle floating button visibility if needed
        },
      );
    }
    // My Ads
    if (context.read<SubcategoriesCubit>().isMyAdsOpen) {
      if (widget.state.myAds == null) {
        return CustomEmptyWidget(label: LocaleKeys.noAds.localize);
        //   SizedBox(
        //   child: Label(
        //     text: LocaleKeys.noAds.localize,
        //     style: Styles.headerText(),
        //   ),
        // );
      }

      if (widget.state.myAds!.isEmpty) {
        return CustomEmptyWidget(label: LocaleKeys.noAds.localize);
      }

      return MarriageMyAds(
        scrollController: widget._scrollController,
        controller: widget.controller,
        state: widget.state,
        selectedSubCategoryId: widget.state.selectedSubCatId,
      );
    }

    // Requests Log
    if (context.read<SubcategoriesCubit>().isRequestLogOpen) {
      debugPrint(
          'state.requestsLogByMainCategory ${widget.state.requestsLogByMainCategory?.length}');
      if (widget.state.requestsLogByMainCategory == null) {
        return CustomEmptyWidget(label: LocaleKeys.noAds.localize);
        //   SizedBox(
        //   child: Label(
        //     text: LocaleKeys.noAds.localize,
        //     style: Styles.headerText(),
        //   ),
        // );
      }

      if (widget.state.requestsLogByMainCategory!.isEmpty) {
        return CustomEmptyWidget(label: LocaleKeys.noRequests.localize);
      }

      return MarriageRequest(
        scrollController: widget._scrollController,
        controller: widget.controller,
        state: widget.state,
        selectedSubCategoryId: widget.state.selectedSubCatId,
      );
    }

    // Favourite Ads
    if (context.read<SubcategoriesCubit>().isFavouriteAdsOpen) {
      return BlocProvider(
        create: (context) => serviceLocator<AdvertisementCubit>(),
        child: FavouriteAdsView(
          id: widget.state.mainCategory?.id ?? '',
          isFloatingButtonVisible: (_) {},
          selectedSubCategoryId: widget.state.selectedSubCatId,
        ),
      );
    }

    // Ads
    debugPrint('state.adds ${widget.state.ads}');
    if (widget.state.ads == null) {
      return CustomEmptyWidget(label: LocaleKeys.noAds.localize);
      // const SizedBox();
    }
    if (widget.state.ads!.isEmpty) {
      return CustomEmptyWidget(
        label: LocaleKeys.noAds.localize,
      );
    }

    return MarriageAdsListView(
      scrollController: widget._scrollController,
      controller: widget.controller,
      state: widget.state,
    );
  }
}
