import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

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
  late ScrollController _scrollController;
  late AdvertisementCubit _cubit;
  @override
  void initState() {
    super.initState();
    _adsManager.preloadAds();
    _cubit = context.read<AdvertisementCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);

  }


  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (widget.params.mainCategory.nameEn == 'Dating') {
        context.read<AdvertisementCubit>().getAds(
          subCategoryId: widget.params.subCategory.id,
          filter: 'male',
        );
      } else {
        context.read<AdvertisementCubit>().getAds(
          subCategoryId: widget.params.subCategory.id,
          filter: widget.params.subCategory.hasAuction == true
              ? 'sale'
              : 'provider',
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: context.read<AdvertisementCubit>().ads.length +
          (context.read<AdvertisementCubit>().isLoadingAdsMore ? 1 : 0),
      itemBuilder: (context, index) {
        if(context.read<AdvertisementCubit>().ads.isEmpty) {
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

        final ad =
        context.read<AdvertisementCubit>().ads[index];
        // return // if (index > 0 && index % 3 == 0) {
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
                height: MediaQuery.of(context).size.height *
                    0.5, // Reduced height
                child: const AdsManagerWidget(),
              ),
              _buildAdContent(ad), // Your content for the ad
            ],
          );
        }

        return _buildAdContent(ad);
      },
    );

  }

  Widget _buildAdContent(AdModel item) {
    return CategoriesExtension.fromId(
            widget.params.mainCategory.id ?? '')
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
