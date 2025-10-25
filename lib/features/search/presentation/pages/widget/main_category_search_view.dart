import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../ads/interstitial_ad_model.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../common/widgets/stateful/banners/main_category_banner.dart';
import '../../../../../core/utils/handle_cashback.dart';
import '../../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

//MainCategorySearchView

class MainCategorySearchView extends StatefulWidget {
  const MainCategorySearchView({super.key});

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
      print('mainCategory length ${_cubit.paginatedSearch.length}');
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
        if (_cubit.searchController.text.trim().isEmpty) {
          return CustomEmptyWidget.searchInitial(context: context);
        }
        // Loading first page
        if (state.status == SearchStates.loading && subCategories.isEmpty) {
          return const Center(
            child: CustomLoadingSearchWidget(),
          );
        }

        // No results
        if (subCategories.isEmpty) {
          return CustomEmptyWidget(
            label: LocaleKeys.noResultsFound.localize,
          );
        }
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10, crossAxisCount: 2, childAspectRatio: .9),
          itemCount: _cubit.paginatedSearch.length +
              (_cubit.isLoadingSubCategoriesSearchMore ? 1 : 0),
          physics: _cubit.searchController.text.trim().isEmpty
              ? const NeverScrollableScrollPhysics()
              : const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index >= _cubit.paginatedSearch.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CustomLoadingSearchWidget()),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () {
                  ManageVibration.vibrate();
                  AdInterstitialTop.loadIntersitialAd();
                  AdInterstitialTop.showInterstitialAd();
                  HandleCashback.setCount('mainCategoriesCount', context);
                  if (_cubit.paginatedSearch[index].id ==
                      '62c8b5b09332225799fe335e') {
                    context.push(Routes.MARRIAGESUBCATEGORIES,
                        extra: _cubit.paginatedSearch[index]);
                  } else {
                    context.push(Routes.SUBCATEGORIES,
                        extra: _cubit.paginatedSearch[index]);
                  }
                },
                child: MainCategoryBanner(
                  category: _cubit.paginatedSearch[index],
                  onFavorite: () async {
                    // var result = await controller
                    //     .toggleFavoriteMedicalService(
                    //     _cubit.paginatedSearch[index].id);
                    // print("result$result");
                    // return result;
                  },
                ),
              ),
            );
          },
        );
        // List view with loader at bottom
        /*  return ListView.builder(
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
                child: Center(child: CustomCircularProgressIndicator()),
              );
            }
            final subCategory = _cubit.paginatedSearch[index];
            return ListTile(
              title: Text(subCategory.nameEn  ?? ""),
            );
          },
        );*/
      },
    );
  }
}
