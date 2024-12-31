import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../ads/native_ad_card.dart';

class ProviderAds extends StatefulWidget {
  const ProviderAds(
      {super.key,
      required this.params,
      required this.userType,
      required this.controller});
  final AdsViewParams params;
  final String userType;
  final AdvertisementCubit controller;
  @override
  State<ProviderAds> createState() => _ProviderAdsState();
}

class _ProviderAdsState extends State<ProviderAds> {
  //
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   widget.controller.loadData(
  //       subCategoryId: widget.params.subCategory.id,
  //       filter:
  //       widget.params.subCategory.hasAuction == true ? 'sale' : 'provider', fromTab: false);
  //
  //   // super.initState();
  // }
  final AdsManager _adsManager = AdsManager();

  @override
  void initState() {

    super.initState();
    _adsManager.preloadAds();
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, AdModel>(
      pagingController: widget.controller.adsPagingController,
      builderDelegate: PagedChildBuilderDelegate<AdModel>(
          noItemsFoundIndicatorBuilder: (context) {
            print(widget.controller.adsPagingController.itemList?.length);
            return Center(
              child: Text(
                LocaleKeys.noAds.localize,
                style: TextStyle(
                  color: context.isDarkMode
                      ? AppColors.LIGHT_COLOR
                      : AppColors.DARK_BLUE_COLOR,
                  fontSize: 18,
                ),
              ),
            );
          },
          itemBuilder: (context, item, index) {
    // if (index > 0 && index % 3 == 0) {
/*
   if (index > nativeAdStart && index % adFrequency == adFrequency - 1) {
              return getAdIfNeeded(index, _adsManager);
            }
 */
            if (index > 0 && index % 2 == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5, // Reduced height
                    child: const AdsManagerWidget(),
                  ),
                  _buildAdContent(item), // Your content for the ad
                ],
              );
            }

            return _buildAdContent(item); // Regular content without ad
          },
          noMoreItemsIndicatorBuilder: (context) => Container(),
          firstPageProgressIndicatorBuilder: (context) => Container(
              margin: const EdgeInsets.only(top: 150),
              child: const Center(child: CircularProgressIndicator())),
          newPageProgressIndicatorBuilder: (context) =>
              const Center(child: CircularProgressIndicator())),
    );
  }
  Widget _buildAdContent(AdModel item) {
    return CategoriesExtension.fromNameEn(widget.params.mainCategory.nameEn ?? '')
        .view(
      item: item,
      onFav: (String id) async {
        var result = await widget.controller.favouriteAd(id);
        return result;
      },
      onRemoveFav: (String id) async {
        var result = await widget.controller.unFavouriteAd(id);
        return result;
      },
    );
  }
}

         