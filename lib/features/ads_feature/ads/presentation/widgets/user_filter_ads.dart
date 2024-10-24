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
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class UserFilterAds extends StatefulWidget {
  const UserFilterAds(
      {super.key,
      required this.userType,
      required this.params,
      required this.model});
  final AdsViewParams params;
  final String userType;
  final FilterModel model;

  @override
  State<UserFilterAds> createState() => _UserFilterAdsState();
}

class _UserFilterAdsState extends State<UserFilterAds> {
  @override
  void initState() {
    context
        .read<AdvertisementCubit>()
        .loadFilterData(model: widget.model, filter: widget.userType);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvertisementCubit, AdsState>(builder: (context, state) {
      final controller = context.read<AdvertisementCubit>();
      return PagedListView<int, AdModel>(
        pagingController: controller.adsPagingController,
        builderDelegate: PagedChildBuilderDelegate<AdModel>(
            noItemsFoundIndicatorBuilder: (context) {
              print(controller.adsPagingController.itemList?.length);
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
                  var result = await controller.favouriteAd(id);
                  return result;
                },
                onRemoveFav: (String id) async {
                  var result = await controller.unFavouriteAd(id);
                  return result;
                },
              );
            },
            noMoreItemsIndicatorBuilder: (context) => Container(),
            firstPageProgressIndicatorBuilder: (context) => Container(
                margin: const EdgeInsets.only(top: 150),
                child: const CupertinoActivityIndicator(
                    color: AppColors.PRIMARY_COLOR)),
            newPageProgressIndicatorBuilder: (context) =>
                const CupertinoActivityIndicator(
                  color: AppColors.PRIMARY_COLOR,
                )),
      );
    });
  }
}
