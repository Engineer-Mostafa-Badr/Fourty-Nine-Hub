import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/marriage_request_list_view_item.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../core/widget/olx_pagination/banner.dart';
import '../../../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/data/models/filter_model.dart';

class MarriageRequest extends StatelessWidget {
  const MarriageRequest({
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
    return OlxPaginationWidget(
      itemsPerPage: 2,
      loadPage: (page) {
        print('==> page ${page}');
        print('==> filterModel ${state.filterModel}');
        return controller.filterAds(
            model: state.filterModel ?? FilterModel(), filter: '');
      },
      banners: bannersList,
      items: List.generate(
        state.adsRequestsLog!.length,
            (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarriageRequestListViewItem(
                marriageAds: state.adsRequestsLog![index],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.adsRequestsLog!.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarriageRequestListViewItem(
                marriageAds: state.adsRequestsLog![index],
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
