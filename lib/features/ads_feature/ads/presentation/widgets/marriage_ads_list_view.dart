import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/marriage_ads_list_view_item.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';

import '../../../../../common/functions/global/button_availability.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class MarriageAdsListView extends StatelessWidget {
  const MarriageAdsListView({
    super.key,
    required ScrollController scrollController,
    required this.controller,
    required this.state,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final SubcategoriesCubit controller;
  final SubcategoriesState state;

  @override
  Widget build(BuildContext context) {
    print('state.ads! ${state.ads!.length}');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.ads!.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarriageAdsListViewItem(
                marriageAds: state.ads![index],
                state: state,
              ),
              FutureBuilder(
                  future: ButtonAvailability().isShowButton(
                    otherUserId: state.ads![index].userId ?? '',
                    subcategoryId: state
                            .subCategories?[state.subCategories?.indexWhere(
                                    (element) => element.isSelected == true) ??
                                0]
                            .id ??
                        '',
                  ),
                  builder: (context, snap) {
                    print('==> snap.data ${snap.data}');
                    if (snap.data == false) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.only(start: 10.0),
                        child: Label(
                          text: LocaleKeys
                              .pleaseSubscribeToContactTheClient.localize,
                          style: Styles.headerText(
                            fontSize: 28,
                            color: AppColors.SECONDARY_COLOR_DARK2,
                            height: 1.57,
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
