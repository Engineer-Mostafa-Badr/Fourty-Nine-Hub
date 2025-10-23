import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/requests_log_by_main_category_entity.dart';
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
    this.selectedSubCategoryId,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final SubcategoriesCubit controller;
  final SubcategoriesState state;
  final String? selectedSubCategoryId;

  @override
  Widget build(BuildContext context) {
    // Filter request logs by selected subcategory if provided
    List<RequestsLogByMainCategoryEntity> filteredRequestLogs =
        state.requestsLogByMainCategory ?? [];
    if (selectedSubCategoryId != null && selectedSubCategoryId!.isNotEmpty) {
      filteredRequestLogs = (state.requestsLogByMainCategory ?? [])
          .where(
              (requestLog) => requestLog.subCategoryId == selectedSubCategoryId)
          .toList();
    }

    // Show empty state if filtered list is empty
    if (filteredRequestLogs.isEmpty &&
        selectedSubCategoryId != null &&
        selectedSubCategoryId!.isNotEmpty) {
      return Center(
        child: Label(
          text: LocaleKeys.noRequests.localize,
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
      loadPage: (page) {
        print('==> page $page');
        print('==> filterModel ${state.filterModel}');
        return controller.filterAds(
            model: state.filterModel ?? FilterModel(), filter: '');
      },
      banners: bannersList,
      items: List.generate(
        filteredRequestLogs.length,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarriageRequestListViewItem(
                marriageAds: filteredRequestLogs[index],
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
