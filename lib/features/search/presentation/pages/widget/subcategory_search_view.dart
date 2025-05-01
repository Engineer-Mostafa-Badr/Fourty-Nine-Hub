import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/auth_helper.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/subcategory_card.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../domain/use_case/fetch_search_use_case.dart';

class SubCategorySearchView extends StatefulWidget {
  const SubCategorySearchView({super.key});

  @override
  State<SubCategorySearchView> createState() => _SubCategorySearchViewState();
}

class _SubCategorySearchViewState extends State<SubCategorySearchView> {
  late final ScrollController _scrollController;
  late final SearchCubit _cubit;
  static const _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<SearchCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
  }
  void _onScroll() async {
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;

    final searchText = _cubit.searchController.text.trim();
    if (searchText.isEmpty) return; // 🚫 Don't call API with empty search

    if (current >= max - _scrollThreshold &&
        !_cubit.isLoadingSubCategoriesSearchMore &&
        _cubit.hasMoreSubCategoriesSearchData) {
      final prefs = await SharedPreferences.getInstance();
      final filter = prefs.getString('filter') ?? '';
      final params = SearchParams(
        search: searchText,
        filter: filter,
        params: PaginationParams(page: _cubit.subCategoriesSearchPage),
      );
      _cubit.getPaginatedSubCategorySearch(params: params);
    }
  }

  void _onScroll1() async {
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= max - _scrollThreshold &&
        !_cubit.isLoadingSubCategoriesSearchMore &&
        _cubit.hasMoreSubCategoriesSearchData) {
      final prefs = await SharedPreferences.getInstance();
      final filter = prefs.getString('filter') ?? '';
      final params = SearchParams(
        search: _cubit.searchController.text.trim(),
        filter: filter,
        params: PaginationParams(page: _cubit.subCategoriesSearchPage),
      );
      _cubit.getPaginatedSubCategorySearch(params: params);
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      buildWhen: (prev, curr) =>
      prev.searchSubCategory != curr.searchSubCategory || prev.status != curr.status,
      builder: (context, state) {
        final subCategories = _cubit.subCategoriesSearch;

        // Loading first page
        if (state.status == SearchStates.loading && subCategories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // No results
        if (subCategories.isEmpty) {
          return const Center(child: Text('No subcategories found.'));
        }

        // List view with loader at bottom
        return ListView.builder(
          controller: _scrollController,
          physics: _cubit.searchController.text.trim().isEmpty
              ? const NeverScrollableScrollPhysics()
              : const AlwaysScrollableScrollPhysics(),

          itemCount: _cubit.subCategoriesSearch.length +
              (_cubit.isLoadingSubCategoriesSearchMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= _cubit.subCategoriesSearch.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final subCategory = _cubit.subCategoriesSearch[index];
            return ListTile(
              title: Text(subCategory.nameEn),
            );
          },
        );

      },
    );
  }

}
