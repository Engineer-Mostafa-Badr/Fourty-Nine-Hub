import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/features/subcategories/presentation/pages/my_ad_card.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widget/olx_pagination/banner.dart';
import '../../../../core/widget/olx_pagination/olx_pagination_widget.dart';

class MyAdsView extends StatefulWidget {
  const MyAdsView(
      {super.key, required this.id, required this.isFloatingButtonVisible});

  final String id;
  final void Function(bool) isFloatingButtonVisible;

  @override
  State<MyAdsView> createState() => _MyAdsViewState();
}

class _MyAdsViewState extends State<MyAdsView> {
  late ScrollController _scrollController;
  late SubcategoriesCubit _cubit;
  bool isFirstSearchListenerCall = true;

  @override
  void initState() {
    print("MyAdsView initState");
    super.initState();
    _cubit = context.read<SubcategoriesCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SubcategoriesCubit>().getMyAds(widget.id);
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
        //     listener: (context, state) {
        //   if (state.deleteAdStatus == SubcategoriesStates.adsSuccess) {
        //     context.read<SubcategoriesCubit>().getMyAds(widget.id);
        //     showSuccessMessage(context,
        //         context.isArabic ? 'تم حذف الاعلانك' : 'Your ad has been deleted');
        //   }
        //   if (state.deleteAdStatus == SubcategoriesStates.error) {
        //     showErrorMessage(context,
        //         getFailureMessage(state.failure ?? UnknownFailure(''), context));
        //   }
        // },
        builder: (context, state) {
      final controller = context.read<SubcategoriesCubit>();
      if (controller.isLoadingMyAds == true) {
        return const CustomLoading();
      }
      if (controller.myAds.isEmpty) {
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
        loadPage: (page) =>
            context.read<SubcategoriesCubit>().getMyAds(widget.id),
        banners: bannersList,
        items: List.generate(
          controller.myAds.length,
          (i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            child: MyAdCard(
              showSubCategory: true,
              item: controller.myAds[i],
              onFav: (id) async {
                bool result = await context
                    .read<AdvertisementCubit>()
                    .favouriteAd(controller.myAds[i].id);
                return result;
              },
              onRemoveFav: (id) async {
                bool result = await context
                    .read<AdvertisementCubit>()
                    .unFavouriteAd(controller.myAds[i].id);
                return result;
              },
              deleteAd: (adId) async {
                showLoadingDialog(context);
                await context.read<SubcategoriesCubit>().deleteAd(adId);
                if (!context.mounted) return;
                context.pop();
                context.pop();
                if (controller.state.deleteAdStatus ==
                    SubcategoriesStates.adsSuccess) {
                  context.read<SubcategoriesCubit>().loadMyAds(id: widget.id);
                  showSuccessMessage(
                      context,
                      context.isArabic
                          ? 'تم حذف اعلانك'
                          : 'Your ad has been deleted');
                }
                if (controller.state.deleteAdStatus ==
                    SubcategoriesStates.error) {
                  showErrorMessage(
                      context,
                      getFailureMessage(
                          controller.state.failure ?? UnknownFailure(''),
                          context));
                }
              },
            ),
          ),
        ),

      );
      /*return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: controller.myAds.length,
        itemBuilder: (context, i) => MyAdCard(
          showSubCategory: true,
          item: controller.myAds[i],
          onFav: (id) async {
            bool result = await context
                .read<AdvertisementCubit>()
                .favouriteAd(controller.myAds[i].id);
            return result;

          },
          onRemoveFav: (id) async {
            bool result = await context
                .read<AdvertisementCubit>()
                .unFavouriteAd(controller.myAds[i].id);
            return result;
          },
          deleteAd: (adId) async {
            showLoadingDialog(context);
            await context.read<SubcategoriesCubit>().deleteAd(adId);
            if (!context.mounted) return;
            context.pop();
            context.pop();
            if (controller.state.deleteAdStatus ==
                SubcategoriesStates.adsSuccess) {
              context.read<SubcategoriesCubit>().loadMyAds(id: widget.id);
              showSuccessMessage(
                  context,
                  context.isArabic
                      ? 'تم حذف اعلانك'
                      : 'Your ad has been deleted');
            }
            if (controller.state.deleteAdStatus == SubcategoriesStates.error) {
              showErrorMessage(
                  context,
                  getFailureMessage(
                      controller.state.failure ?? UnknownFailure(''), context));
            }
          },
        ),
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 16),
      );*/
    });
  }
}
