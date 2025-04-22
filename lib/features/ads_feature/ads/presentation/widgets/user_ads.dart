import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/ads/native_ad_card.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class UserAds extends StatefulWidget {
  const UserAds({super.key, required this.params, required this.userType});
  final AdsViewParams params;
  final String userType;

  @override
  State<UserAds> createState() => _UserAdsState();
}

class _UserAdsState extends State<UserAds> {
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   context.read<AdvertisementCubit>().loadData(
  //       subCategoryId: widget.params.subCategory.id,
  //       filter:widget.userType, fromTab: false);
  //
  //   // super.initState();
  // }
  final AdsManager _adsManager = AdsManager();
  // @override
  // void initState() {
  //   _adsManager.preloadAds();
  //   super.initState();
  // }
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (index > nativeAdStart &&
                index % adFrequency == adFrequency - 1)
              SizedBox(
                height: 50,
                child: getAdIfNeeded(index, _adsManager),
              ),
            CategoriesExtension.fromId(
                widget.params.mainCategory.id ?? '')
                .view(
              item: context.read<AdvertisementCubit>().ads[index],
              onFav: (String id) async {
                var result = await context
                    .read<AdvertisementCubit>()
                    .favouriteAd(id);
                return result;
              },
              onRemoveFav: (String id) async {
                var result = await context
                    .read<AdvertisementCubit>()
                    .unFavouriteAd(id);
                return result;
              },
            ),
          ],
        );
      },
    );

  }
}
