import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/marriage_my_ads_list_view_item.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/data/models/filter_model.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../core/widget/olx_pagination/banner.dart';
import '../../../../../core/widget/olx_pagination/olx_pagination_widget.dart';

class MarriageMyAds extends StatelessWidget {
  const MarriageMyAds({
    super.key,
    required ScrollController scrollController,
    required this.controller,
    required this.state,
    this.selectedSubCategoryId,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final SubcategoriesCubit controller;
  final SubcategoriesState state;
  final String? selectedSubCategoryId;

  @override
  Widget build(BuildContext context) {
    // Filter my ads by selected subcategory if provided
    List<AdModel> filteredMyAds = state.myAds ?? [];
    if (selectedSubCategoryId != null && selectedSubCategoryId!.isNotEmpty) {
      filteredMyAds = (state.myAds ?? [])
          .where((ad) => ad.subCategoryId == selectedSubCategoryId)
          .toList();
    }

    // Show empty state if filtered list is empty
    if (filteredMyAds.isEmpty &&
        selectedSubCategoryId != null &&
        selectedSubCategoryId!.isNotEmpty) {
      return Center(
        child: Label(
          text: LocaleKeys.youHaveNoAds.localize,
          style: Styles.headerText(
            fontSize: 40,
            color: context.isDarkMode
                ? Colors.white.withValues(alpha: 178)
                : Colors.black.withValues(alpha: 178),
            height: 1.60,
          ),
        ),
      );
    }

    return OlxPaginationWidget(
      scrollController: _scrollController,
      itemsPerPage: 2,
      loadPage: (page) => controller.filterAds(
          model: state.filterModel ?? FilterModel(), filter: ''),
      banners: bannersList,
      items: List.generate(
        filteredMyAds.length,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarriageMyAdsListViewItem(
                marriageAds: filteredMyAds[index],
                state: state,
              ),
              // Only show subscription message if user is not subscribed
              if (filteredMyAds[index].userSubscriptionStatus ==
                      'not subscribed' &&
                  filteredMyAds[index].ownerSubscriptionStatus ==
                      'not subscribed')
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10.0),
                  child: Label(
                    text: LocaleKeys.pleaseSubscribeToContactTheClient.localize,
                    style: Styles.headerText(
                      fontSize: 28,
                      color: AppColors.getRedColor(context),
                      height: 1.57,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    /* return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.myAds!.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarriageMyAdsListViewItem(
                marriageAds: state.myAds![index],
                state: state,
              ),
              // Only show subscription message if user is not subscribed
              if (state.myAds![index].userSubscriptionStatus == 'not subscribed' &&
                  state.myAds![index].ownerSubscriptionStatus == 'not subscribed')
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10.0),
                  child: Label(
                    text: LocaleKeys.pleaseSubscribeToContactTheClient.localize,
                    style: Styles.headerText(
                      fontSize: 28,
                      color: AppColors.getRedColor(context),
                      height: 1.57,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );*/
  }
}
