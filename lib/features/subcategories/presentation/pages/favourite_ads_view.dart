import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/ad_card.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/features/subcategories/presentation/pages/my_ad_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

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
  late SubcategoriesCubit _cubit;
  bool isFirstSearchListenerCall = true;

  @override
  void initState() {
    print("FavouriteAdsView initState");
    super.initState();
    _cubit = context.read<SubcategoriesCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SubcategoriesCubit>().getMyFavouriteAds(widget.id);
    }

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
        return const CustomLoading();
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
      return ListView.separated(
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
                .unFavouriteAd(controller.myFavouriteAds[i].id);
            return result;
          },

        ),
      );
    });
  }
}
