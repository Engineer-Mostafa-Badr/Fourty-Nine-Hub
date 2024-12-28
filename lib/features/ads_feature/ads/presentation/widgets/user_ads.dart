import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/ads/native_ad_card.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
  @override
  void initState() {

    _adsManager.preloadAds();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return PagedListView<int, AdModel>(
      pagingController: context.read<AdvertisementCubit>().adsPagingController,
      builderDelegate: PagedChildBuilderDelegate<AdModel>(
          noItemsFoundIndicatorBuilder: (context) {
            print(
                "controller.adsPagingController.itemList?.length${context.read<AdvertisementCubit>().adsPagingController.itemList?.length}");
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
            print("item $index");

            // Calculate the actual item index in the data list
            // int actualItemIndex = index - ((index - nativeAdStart) ~/ adFrequency);
            //
            // // Insert ads at the specified frequency
            // if (index > nativeAdStart && index % adFrequency == adFrequency - 1) {
            //   return getAdIfNeeded(index, _adsManager);
            // }
            //
            // // Retrieve the item using the corrected index
            // final correctedItem =
            // context.read<AdvertisementCubit>().adsPagingController.itemList?[
            // actualItemIndex];
            //
            // // Render the item widget
            // return CategoriesExtension.fromNameEn(
            //     widget.params.mainCategory.nameEn ?? '')
            //     .view(
            //   item: correctedItem ?? item,
            //   onFav: (String id) async {
            //     var result =
            //     await context.read<AdvertisementCubit>().favouriteAd(id);
            //     return result;
            //   },
            //   onRemoveFav: (String id) async {
            //     var result =
            //     await context.read<AdvertisementCubit>().unFavouriteAd(id);
            //     return result;
            //   },
            // );
            // if (index > nativeAdStart && index % adFrequency == adFrequency - 1) {
            //   return  SizedBox(height: 50,child: getAdIfNeeded(index, _adsManager),);
            // }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            if (index > nativeAdStart && index % adFrequency == adFrequency - 1)
              SizedBox(height: 50,child: getAdIfNeeded(index, _adsManager),),

                CategoriesExtension.fromNameEn(
                        widget.params.mainCategory.nameEn ?? '')
                    .view(
                  item: item,
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
