import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/ads/native_ad_card.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/features/subcategories/presentation/pages/my_ad_card.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../core/widget/olx_pagination/banner.dart';
import '../../../../../core/widget/olx_pagination/olx_pagination_widget.dart';

class UserAds extends StatefulWidget {
  const UserAds({
    super.key,
    required this.params,
    required this.userType,
    required this.onScrollChanged,
  });

  final AdsViewParams params;
  final String userType;
  final Function(bool) onScrollChanged;

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
    print('widget.params.mainCategory.id ${widget.params.mainCategory.id}');
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      widget.onScrollChanged(false);
    } else {
      widget.onScrollChanged(true);
    }
    // if (_scrollController.position.pixels >=
    //     _scrollController.position.maxScrollExtent - 200) {
    //   if (widget.params.mainCategory.nameEn == 'Dating') {
    //     context.read<AdvertisementCubit>().getAds(
    //           subCategoryId: widget.params.subCategory.id,
    //           filter: 'male',
    //         );
    //   } else {
    //     context.read<AdvertisementCubit>().getAds(
    //           subCategoryId: widget.params.subCategory.id,
    //           filter: widget.params.subCategory.hasAuction == true
    //               ? 'sale'
    //               : 'provider',
    //         );
    //   }
    // }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (context.read<AdvertisementCubit>().ads.isEmpty) {
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
      scrollController: _scrollController,
      itemsPerPage: 3,
      loadPage: (page) {
        print('sale ${widget.params.subCategory.hasAuction}');
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
                    : 'user',
              );
        }
      },
      banners: bannersList,
      items: List.generate(
        context.read<AdvertisementCubit>().ads.length,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
          child: MyAdCard(
            item: context.read<AdvertisementCubit>().ads[index],
            onFav: (id) async {
              bool result = await context
                  .read<AdvertisementCubit>()
                  .favouriteAd(context.read<AdvertisementCubit>().ads[index].id);
              return result;
            },
            onRemoveFav: (id) async {
              bool result = await context
                  .read<AdvertisementCubit>()
                  .unFavouriteAd(
                      context.read<AdvertisementCubit>().ads[index].id);
              return result;
            },
          ),
        ),
      ),
    );
    /*return ListView.separated(
      // controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: context.read<AdvertisementCubit>().ads.length +
          (context.read<AdvertisementCubit>().isLoadingAdsMore ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(
        height: 16,
      ),
      itemBuilder: (context, index) {
        if (context.read<AdvertisementCubit>().ads.isEmpty) {
          return SizedBox(
            height: 100,
            child: Center(
              child: Text(
                LocaleKeys.noAds.localize,
                style: TextStyle(
                  color: context.isDarkMode
                      ? AppColors.LIGHT_COLOR
                      : AppColors.DARK_BLUE_COLOR,
                  fontSize: 18,
                ),
              ),
            ),
          );
        }
        return MyAdCard(
          item: context.read<AdvertisementCubit>().ads[index],
          onFav: (id) async {
            bool result = await context
                .read<AdvertisementCubit>()
                .favouriteAd(context.read<AdvertisementCubit>().ads[index].id);
            return result;
          },
          onRemoveFav: (id) async {
            bool result = await context
                .read<AdvertisementCubit>()
                .unFavouriteAd(
                    context.read<AdvertisementCubit>().ads[index].id);
            return result;
          },
        );
        */
    /*return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (index > nativeAdStart && index % adFrequency == adFrequency - 1)
              SizedBox(
                height: 50,
                child: getAdIfNeeded(index, _adsManager),
              ),
            CategoriesExtension.fromId(widget.params.mainCategory.id ?? '')
                .view(
              item: context.read<AdvertisementCubit>().ads[index],
              onFav: (String id) async {
                var result =
                    await context.read<AdvertisementCubit>().favouriteAd(id);
                return result;
              },
              onRemoveFav: (String id) async {
                var result =
                    await context.read<AdvertisementCubit>().unFavouriteAd(id);
                return result;
              },
            ),
          ],
        );*/
    /*
      },
    );*/
  }
}
