import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../common/models/public/pagination_params.dart';
import 'build_Item_search_main_category.dart';

//MainCategorySearchView


class MainCategorySearchView extends StatefulWidget {
  const MainCategorySearchView({Key? key}) : super(key: key);


  @override
  State<MainCategorySearchView> createState() => _MainCategorySearchViewState();
}


class _MainCategorySearchViewState extends State<MainCategorySearchView> {
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
        !_cubit.loadPaginatedSearch &&
        _cubit.hasMoreAdsData) {
      final prefs = await SharedPreferences.getInstance();
      final filter = prefs.getString('filter') ?? '';
      final params = SearchParams(
        search: searchText,
        filter: filter,
        params: PaginationParams(page: _cubit.paginatedSearchPage),
      );
      _cubit.loadPaginatedSearchData(params: params);
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
      prev.search != curr.search || prev.status != curr.status,
      builder: (context, state) {
        final subCategories = _cubit.paginatedSearch;

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

          itemCount: _cubit.paginatedSearch.length +
              (_cubit.isLoadingSubCategoriesSearchMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= _cubit.paginatedSearch.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final subCategory = _cubit.paginatedSearch[index];
            return ListTile(
              title: Text(subCategory.nameEn  ?? ""),
            );
          },
        );

      },
    );
  }

}



