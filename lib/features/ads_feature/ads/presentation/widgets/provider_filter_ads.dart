import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/ad_card.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/data/models/filter_model.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widget/olx_pagination/banner.dart';
import '../../../../../core/widget/olx_pagination/olx_pagination_widget.dart';

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
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   widget.controller
  //       .loadFilterAdsData(model: widget.model, filter: widget.userType);
  //
  //   // super.initState();
  // }

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    // if (_scrollController.position.pixels >=
    //     _scrollController.position.maxScrollExtent - 200) {
    //   widget.controller
    //       .loadFilterAdsData(model: widget.model, filter: widget.userType);
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.ads.isEmpty) {
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
    }
    return OlxPaginationWidget(
      scrollController: _scrollController,
      itemsPerPage: 2,
      loadPage: (page) => widget.controller
          .loadFilterAdsData(model: widget.model, filter: widget.userType),
      banners: bannersList,
      items: List.generate(
          widget.controller.ads.length +
              (widget.controller.isLoadingAdsMore ? 1 : 0), (index) {
        final ad = widget.controller.ads[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
          child: AdCard(
            item: ad,
            onFav: (String id) async {
              var result = await widget.controller.favouriteAd(id);
              return result;
            },
            onRemoveFav: (String id) async {
              var result = await widget.controller.unFavouriteAd(id);
              return result;
            },
            onDeleteAd: (String id) {
              context.pop();
              widget.controller.deleteAd(id);
            },
          ),
        );
      }),

    );
    /*return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: widget.controller.ads.length +
          (widget.controller.isLoadingAdsMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (widget.controller.ads.isEmpty) {
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
        }

        final ad = widget.controller.ads[index];
        return CategoriesExtension.fromId(widget.params.mainCategory.id ?? '')
            .view(
          item: ad,
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
    );*/
  }
}
