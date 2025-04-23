import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/data/models/filter_model.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

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
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

  }


  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context
          .read<AdvertisementCubit>()
          .loadFilterAdsData(model: widget.model, filter: widget.userType);

    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvertisementCubit, AdsState>(
      builder: (context, state) {
        return ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: context
              .read<AdvertisementCubit>()
            .ads.length +
              (context
                  .read<AdvertisementCubit>()
                .isLoadingAdsMore ? 1 : 0),
          itemBuilder: (context, index) {
            if(context
                .read<AdvertisementCubit>()
                .ads.isEmpty) {
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

            final ad =
            context
                .read<AdvertisementCubit>()
                .ads[index];
            return CategoriesExtension.fromId(
                widget.params.mainCategory.id ?? '')
                .view(
              item: ad,
              onFav: (String id) async {
                var result = await context
                    .read<AdvertisementCubit>().favouriteAd(id);
                return result;
              },
              onRemoveFav: (String id) async {
                var result = await context
                    .read<AdvertisementCubit>().unFavouriteAd(id);
                return result;
              },
            );
          },
        );
      }
    );
  }
}
