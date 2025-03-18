import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/marriage_ads_list_view_item.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';

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
    return ListView.builder(
      controller: _scrollController,
      itemCount: controller.marriageAds.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: MarriageAdsListViewItem(
          marriageAds: controller.marriageAds[index],
          state: state,
        ),
      ),
    );
  }
}
