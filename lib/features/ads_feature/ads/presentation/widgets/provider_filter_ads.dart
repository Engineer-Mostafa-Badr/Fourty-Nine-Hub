import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/data/models/filter_model.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ProviderFilterAds extends StatefulWidget {
  const ProviderFilterAds(
      {super.key,
      required this.userType,
      required this.params,
      required this.model,
      required this.controller});
  final AdsViewParams params;
  final String userType;
  final FilterModel model;
  final AdvertisementCubit controller;

  @override
  State<ProviderFilterAds> createState() => _ProviderFilterAdsState();
}

class _ProviderFilterAdsState extends State<ProviderFilterAds> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller
        .loadFilterData(model: widget.model, filter: widget.userType);

    // super.initState();
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
            return CategoriesExtension.fromNameEn(
                    widget.params.mainCategory.nameEn ?? '')
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
          },
          noMoreItemsIndicatorBuilder: (context) => Container(),
          firstPageProgressIndicatorBuilder: (context) => Container(
              margin: const EdgeInsets.only(top: 150),
              child: const Center(child: CircularProgressIndicator())),
          newPageProgressIndicatorBuilder: (context) =>
              const Center(child: CircularProgressIndicator())),
    );
  }
}
