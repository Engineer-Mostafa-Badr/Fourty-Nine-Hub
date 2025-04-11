import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/core/widget/custom_notification_badge.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/filter_button_item.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/header_button_widget.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/marriage_ads_list_view.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/marriage_my_ads_list_view.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/marriage_request.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/sub_category_list_view_item.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/style/app_colors.dart';

class MarriageAdsViewBody extends StatelessWidget {
  const MarriageAdsViewBody({
    super.key,
    required this.controller,
    required this.state,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final SubcategoriesCubit controller;
  final SubcategoriesState state;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        state.mainCategory == null
            ? Container()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MainCategoryBanner(
                  fromHome: false,
                  category:
                      context.read<SubcategoriesCubit>().state.mainCategory!,
                  onFavorite: () async {
                    // var result =
                    // await controller.toggleFavoriteMedicalService(
                    //     state.data![index].id);
                    // print("result$result");
                    // return result;
                  },
                ),
              ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(
                Icons.search,
                color: AppColors.PRIMARY_COLOR,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: CustomNotificationBadge(
                  count: 0,
                  child: HeaderButtonWidget(
                    title: LocaleKeys.favouriteAds.localize,
                    isOpened:
                        context.read<SubcategoriesCubit>().isFavouriteAdsOpen,
                    onPressed: () {
                      context
                          .read<SubcategoriesCubit>()
                          .getRequestsLog('62c8b5b09332225799fe335e');

                      context
                          .read<SubcategoriesCubit>()
                          .toggleMyAds('isFavouriteAdsOpen');
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: CustomNotificationBadge(
                  count: 0,
                  child: HeaderButtonWidget(
                    title: LocaleKeys.requestLog.localize,
                    isOpened:
                        context.read<SubcategoriesCubit>().isRequestLogOpen,
                    onPressed: () {
                      context
                          .read<SubcategoriesCubit>()
                          .getRequestsLog('62c8b5b09332225799fe335e');
                      context
                          .read<SubcategoriesCubit>()
                          .toggleMyAds('isRequestLogOpen');

                      // context.read<SubcategoriesCubit>().toggleRequestLog();
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: HeaderButtonWidget(
                  title: LocaleKeys.myAds.localize,
                  isOpened: context.read<SubcategoriesCubit>().isMyAdsOpen,
                  onPressed: () {
                    // TODO: EDIT THIS
                    context.read<SubcategoriesCubit>().getMarriageMyAds();
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
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: FilterButtonItem(
                  title: LocaleKeys.filter.localize,
                  onTap: () async {
                    dynamic data = await context.push(
                      Routes.FILTERADS,
                      extra: CategorizationEntity(
                        mainCategory: state.mainCategory!,
                        fromMarriage: true,
                        subCategory: state.subCategories![state.subCategories
                                ?.indexWhere(
                                    (element) => element.isSelected == true) ??
                            0],
                      ),
                    );
                    if (data != null) {
                      print("objectsdaa");
                      controller.changeFilterModel(data);
                      controller.loadFilterData(
                        model: data,
                        filter: 'user',
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: FilterButtonItem(
                  title: LocaleKeys.city.localize,
                  onTap: () async {
                    dynamic data = await context.push(
                        Routes.GOVERNORATEFILTERADS,
                        extra: CategorizationEntity(
                            mainCategory: state.mainCategory!,
                            fromMarriage: true,
                            subCategory: state
                                .subCategories![state.subCategories?.indexWhere(
                                    (element) => element.isSelected == true) ??
                                0]));
                    if (data != null) {
                      print("data.cityId${data.cityId}");
                      print("data.governorateId${data.governorateId}");
                      print("objectsdaa");
                      controller.state.city = data.cityId;
                      controller.state.governorate = data.governorateId;
                      controller.changeFilterModel(data);
                      await controller.loadFilterData(
                          model: data, filter: 'user');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 32,
          child: ListView.separated(
            itemCount: state.subCategories?.length ?? 0,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsetsDirectional.only(
                  start: index == 0 ? 16.0 : 0,
                  end: index == state.subCategories!.length - 1 ? 16.0 : 0,
                ),
                child: ClickableWidget(
                  onTap: () async {
                    await controller.changeSubCatIndex(index);
                  },
                  child: SubCategoryListViewItem(
                    subCategory: state.subCategories?[index],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
              width: 8,
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

  Widget _selectWidget(BuildContext context) {
    if (state.status == SubcategoriesStates.loadingAds) {
      return const CustomLoading();
    }

    // My Ads
    if (context.read<SubcategoriesCubit>().isMyAdsOpen) {
      if (state.myAds == null) {
        return SizedBox(
          child: Label(
            text: 'My Ads is Null',
            style: Styles.headerText(),
          ),
        );
      }

      if (state.myAds!.isEmpty) {
        return CustomEmptyWidget(label: LocaleKeys.noAds.localize);
      }

      return MarriageMyAds(
        scrollController: _scrollController,
        controller: controller,
        state: state,
      );
    }

    // Requests Log
    if (context.read<SubcategoriesCubit>().isRequestLogOpen) {
      print('state.adsRequestsLog ${state.adsRequestsLog?.length}');
      if (state.adsRequestsLog == null) {
        return SizedBox(
          child: Label(
            text: 'My Ads is Null',
            style: Styles.headerText(),
          ),
        );
      }

      if (state.adsRequestsLog!.isEmpty) {
        return CustomEmptyWidget(label: LocaleKeys.noRequests.localize);
      }
      return MarriageRequest(
        scrollController: _scrollController,
        controller: controller,
        state: state,
      );
    }

    // Favourite Ads
    if (context.read<SubcategoriesCubit>().isFavouriteAdsOpen) {
      print('state.adsRequestsLog ${state.adsRequestsLog?.length}');
      if (state.adsRequestsLog == null) {
        return SizedBox(
          child: Label(
            text: 'My Ads is Null',
            style: Styles.headerText(),
          ),
        );
      }

      if (state.adsRequestsLog!.isEmpty) {
        return CustomEmptyWidget(label: LocaleKeys.noRequests.localize);
      }
      return MarriageRequest(
        scrollController: _scrollController,
        controller: controller,
        state: state,
      );
    }

    // Ads
    print('state.adds ${state.ads}');
    if (state.ads == null) {
      return const SizedBox();
    }
    if (state.ads!.isEmpty) {
      return CustomEmptyWidget(
        label: LocaleKeys.noAds.localize,
      );
    }

    return MarriageAdsListView(
      scrollController: _scrollController,
      controller: controller,
      state: state,
    );
  }
}
