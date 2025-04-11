import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/marriage_my_ads_list_view_item.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class MarriageMyAds extends StatelessWidget {
  const MarriageMyAds({
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.myAds!.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarriageMyAdsListViewItem(
                marriageAds: state.myAds![index],
                state: state,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 10.0),
                child: Label(
                  text: LocaleKeys.pleaseSubscribeToContactTheClient.localize,
                  style: Styles.headerText(
                    fontSize: 28,
                    color: const Color(0xFFFF3308),
                    height: 1.57,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
