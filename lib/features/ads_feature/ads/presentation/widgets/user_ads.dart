import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
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
                style: const TextStyle(
                  color: Colors.black,
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
                var result = await context.read<AdvertisementCubit>().favouriteAd(id);
                return result;
              },
              onRemoveFav: (String id) async {
                var result = await context.read<AdvertisementCubit>().unFavouriteAd(id);
                return result;
              },
            );
          },
          noMoreItemsIndicatorBuilder: (context) => Container(),
          firstPageProgressIndicatorBuilder: (context) =>
              Container(
                  margin: const EdgeInsets.only(top: 150),
                  child: const Center(child: CircularProgressIndicator())),
          newPageProgressIndicatorBuilder: (context) =>
          const Center(child: CircularProgressIndicator())),
    );
  }
}
