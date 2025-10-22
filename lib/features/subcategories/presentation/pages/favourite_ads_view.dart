import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../ads_feature/ads/presentation/cubit/ads_cubit.dart';
import '../cubit/subcategories_cubit.dart';
import 'my_ad_card.dart';
import '../../../../res/style/styles.dart';

import '../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../core/widget/olx_pagination/banner.dart';
import '../../../../core/widget/olx_pagination/olx_pagination_widget.dart';

class FavouriteAdsView extends StatefulWidget {
  const FavouriteAdsView({
    super.key,
    required this.id,
    required this.isFloatingButtonVisible,
  });

  final String id;
  final void Function(bool) isFloatingButtonVisible;

  @override
  State<FavouriteAdsView> createState() => _FavouriteAdsViewState();
}

class _FavouriteAdsViewState extends State<FavouriteAdsView> {
  late ScrollController _scrollController;
  bool isFirstSearchListenerCall = true;

  @override
  void initState() {
    print("FavouriteAdsView initState");
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    // if (_scrollController.position.pixels >=
    //     _scrollController.position.maxScrollExtent - 200) {
    //   context.read<SubcategoriesCubit>().getMyFavouriteAds(widget.id);
    // }

    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      widget.isFloatingButtonVisible(false);
    } else {
      widget.isFloatingButtonVisible(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubcategoriesCubit, SubcategoriesState>(
        builder: (context, state) {
      final controller = context.read<SubcategoriesCubit>();
      if (controller.isLoadingMyFavouriteAds == true) {
        return const CustomLoadingSearchWidget();
      }
      if (controller.myFavouriteAds.isEmpty) {
        return Center(
          child: Label(
            text: LocaleKeys.noFavouriteAds.localize,
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
        itemsPerPage: 2,
        loadPage: (page) =>
            context.read<SubcategoriesCubit>().getMyFavouriteAds(widget.id),
        banners: bannersList,
        items: List.generate(
            controller.myFavouriteAds.length,
            (i) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: MyAdCard(
                    item: controller.myFavouriteAds[i]
                      ..isFavourite = true, // Force isFavourite to true
                    showSubCategory: true,
                    onFav: (id) async {
                      // This should not be called in favorite view since all items are favorited
                      return false;
                    },
                    onRemoveFav: (id) async {
                      // When user clicks favorite icon in favorite view, remove from favorites
                      bool result = await context
                          .read<AdvertisementCubit>()
                          .unFavouriteAd(controller.myFavouriteAds[i].id);
                      if (result) {
                        // Update the favorite status in the main ads list
                        controller.updateAdFavoriteStatus(
                            controller.myFavouriteAds[i].id, false);
                        controller.myFavouriteAds
                            .remove(controller.myFavouriteAds[i]);
                        setState(() {});
                      }
                      return result;
                    },
                  ),
                )),
      );
      /* return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: controller.myFavouriteAds.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, i) => MyAdCard(
          item: controller.myFavouriteAds[i],
          showSubCategory: true,
          onFav: (id) async {
            bool result = await context
                .read<AdvertisementCubit>()
                .unFavouriteAd(controller.myFavouriteAds[i].id);
            controller.myFavouriteAds.remove(controller.myFavouriteAds[i]);
            setState(() {});
            return result;
            // bool result = await context
            //     .read<AdvertisementCubit>()
            //     .favouriteAd(controller.myFavouriteAds[i].id);
            // return result;
          },
          onRemoveFav: (id) async {
            bool result = await context
                .read<AdvertisementCubit>()
                .favouriteAd(controller.myFavouriteAds[i].id);
            return result;
          },

        ),
      );*/
    });
  }
}
