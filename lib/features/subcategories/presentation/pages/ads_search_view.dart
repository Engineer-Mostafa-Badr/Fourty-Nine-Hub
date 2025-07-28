import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/features/subcategories/presentation/pages/my_ad_card.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../core/widget/olx_pagination/banner.dart';
import '../../../../core/widget/olx_pagination/olx_pagination_widget.dart';

class AdsSearchView extends StatefulWidget {
  const AdsSearchView({
    super.key,
    required this.mainCategoryNameAr,
    required this.mainCategoryNameEn,
    required this.isFloatingButtonVisible,
  });

  final String mainCategoryNameAr;
  final String mainCategoryNameEn;
  final void Function(bool) isFloatingButtonVisible;

  @override
  State<AdsSearchView> createState() => _AdsSearchViewState();
}

class _AdsSearchViewState extends State<AdsSearchView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        widget.isFloatingButtonVisible(false);
      } else {
        widget.isFloatingButtonVisible(true);
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubcategoriesCubit, SubcategoriesState>(
        builder: (context, state) {
      final controller = context.read<SubcategoriesCubit>();
      if (state.isLoadingAds) {
        return const CustomLoadingSearchWidget();
      }
      if (controller.initalSearchAds) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 100,
              color: context.isDarkMode
                  ? Colors.white.withValues(alpha: 178)
                  : Colors.black.withValues(alpha: 178),
            ),
            Label(
                text: context.isArabic
                    ? 'ابحث عن اي اعلان داخل ${widget.mainCategoryNameAr}'
                    : 'Search for any ad inside ${widget.mainCategoryNameEn}',
                style: Styles.headerText(
                  fontSize: 40,
                  color: context.isDarkMode
                      ? Colors.white.withValues(alpha: 178)
                      : Colors.black.withValues(alpha: 178),
                  height: 1.60,
                )),
          ],
        );
      }
      if (controller.searchAdsList.isEmpty) {
        return Center(
          child: Label(
            text: LocaleKeys.youHaveNoAds.localize,
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
        loadPage: (page) async {
          if (_scrollController.position.userScrollDirection ==
              ScrollDirection.reverse) {
            widget.isFloatingButtonVisible(false);
          } else {
            widget.isFloatingButtonVisible(true);
          }
        },
        banners: bannersList,
        items: List.generate(
          controller.searchAdsList.length,
          (i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: MyAdCard(
              item: controller.searchAdsList[i],
              showSubCategory: true,
              onFav: (id) async {
                bool result = await context
                    .read<AdvertisementCubit>()
                    .favouriteAd(controller.searchAdsList[i].id);
                return result;
              },
              onRemoveFav: (id) async {
                bool result = await context
                    .read<AdvertisementCubit>()
                    .unFavouriteAd(controller.searchAdsList[i].id);
                return result;
              },
            ),
          ),
        ),
      );
      /*return ListView.separated(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: controller.searchAdsList.length,
        itemBuilder: (context, i) => MyAdCard(
          item: controller.searchAdsList[i],
          showSubCategory: true,
          onFav: (id) async {
            bool result = await context
                .read<AdvertisementCubit>()
                .favouriteAd(controller.searchAdsList[i].id);
            return result;
          },
          onRemoveFav: (id) async {
            bool result = await context
                .read<AdvertisementCubit>()
                .unFavouriteAd(controller.searchAdsList[i].id);
            return result;
          },
        ),
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 16),
      );*/
    });
  }
}
