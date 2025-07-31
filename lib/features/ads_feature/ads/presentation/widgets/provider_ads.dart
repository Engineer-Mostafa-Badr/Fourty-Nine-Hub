import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../ads/native_ad_card.dart';
import '../../../../../core/widget/olx_pagination/banner.dart';
import '../../../../../core/widget/olx_pagination/olx_pagination_widget.dart';

class ProviderAds extends StatefulWidget {
  const ProviderAds({
    super.key,
    required this.params,
    required this.userType,
    required this.controller,
    required this.onScrollChanged,
  });

  final AdsViewParams params;
  final String userType;
  final AdvertisementCubit controller;
  final Function(bool) onScrollChanged;

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
  // late ScrollController _scrollController;
  late AdvertisementCubit _cubit;

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
    _adsManager.preloadAds();
    _cubit = context.read<AdvertisementCubit>();
    // _scrollController = ScrollController()..addListener(_onScroll);
  }

  // void _onScroll() {
  //   if (_scrollController.position.userScrollDirection ==
  //       ScrollDirection.reverse) {
  //     widget.onScrollChanged(false);
  //   } else {
  //     widget.onScrollChanged(true);
  //   }
  //   // setState(() {});
  //
  //   if (_scrollController.position.pixels >=
  //       _scrollController.position.maxScrollExtent - 200) {
  //     if (widget.params.mainCategory.nameEn == 'Dating') {
  //       context.read<AdvertisementCubit>().getAds(
  //             subCategoryId: widget.params.subCategory.id,
  //             filter: 'male',
  //           );
  //     } else {
  //       context.read<AdvertisementCubit>().getAds(
  //             subCategoryId: widget.params.subCategory.id,
  //             filter: widget.params.subCategory.hasAuction == true
  //                 ? 'sale'
  //                 : 'provider',
  //           );
  //     }
  //   }
  // }

  @override
  void dispose() {
    // _scrollController.removeListener(_onScroll);
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.ads.isEmpty) {
      return Center(
        child: Label(
          text: LocaleKeys.noAds.localize,
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
      itemsPerPage: 2,
      loadPage: (page) {
        if (widget.params.mainCategory.nameEn == 'Dating') {
          return context.read<AdvertisementCubit>().getAds(
                subCategoryId: widget.params.subCategory.id,
                filter: 'male',
              );
        } else {
          return context.read<AdvertisementCubit>().getAds(
                subCategoryId: widget.params.subCategory.id,
                filter: widget.params.subCategory.hasAuction == true
                    ? 'sale'
                    : 'provider',
              );
        }
      },
      banners: bannersList,
      items: List.generate(
          context.read<AdvertisementCubit>().ads.length +
              (context.read<AdvertisementCubit>().isLoadingAdsMore ? 1 : 0),
          (index) {
        final ad = context.read<AdvertisementCubit>().ads[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
          child: _buildAdContent(ad),
        );
      }),
    );
    /*return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: context.read<AdvertisementCubit>().ads.length +
          (context.read<AdvertisementCubit>().isLoadingAdsMore ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(
        height: 16,
      ),
      itemBuilder: (context, index) {
        if (context.read<AdvertisementCubit>().ads.isEmpty) {
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

        final ad = context.read<AdvertisementCubit>().ads[index];
        // return // if (index > 0 && index % 3 == 0) {
*//*
   if (index > nativeAdStart && index % adFrequency == adFrequency - 1) {
              return getAdIfNeeded(index, _adsManager);
            }
 */
    /*
        // return MyAdCard(
        //   item: ad,
        //   onFav: (id) {},
        //   onRemoveFav: (id) {},
        // );
        //TODO: Montaser add google ads
        *//*if (index > 0 && index % 2 == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height:
                    MediaQuery.of(context).size.height * 0.5, // Reduced height
                child: const AdsManagerWidget(),
              ),
              _buildAdContent(ad), // Your content for the ad
            ],
          );
        }*/
    /*

        return _buildAdContent(ad);
      },
    );*/
  }

  Widget _buildAdContent(AdEntity item) {
    return CategoriesExtension.fromId(widget.params.mainCategory.id ?? '').view(
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
