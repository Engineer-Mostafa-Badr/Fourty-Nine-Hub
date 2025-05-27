import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/features/search/presentation/pages/widget/ads_search_view.dart';
import 'package:fourtyninehub/features/search/presentation/pages/widget/come_with_me_search_view.dart';
import 'package:fourtyninehub/features/search/presentation/pages/widget/main_category_search_view.dart';
import 'package:fourtyninehub/features/search/presentation/pages/widget/posts_search_view.dart';
import 'package:fourtyninehub/features/search/presentation/pages/widget/profile_search_view.dart';
import 'package:fourtyninehub/features/search/presentation/pages/widget/reel_search_view.dart';
import 'package:fourtyninehub/features/search/presentation/pages/widget/subcategory_search_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/widget/custom_scaffold.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _searchController;
  Timer? _searchDebounce;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    print('✅ INIT SEARCH VIEW');
    context.read<SearchCubit>().initPref();
    _tabController = TabController(length: 6, vsync: this);
    _searchController = context.read<SearchCubit>().searchController;
    _searchController.addListener(_onSearchChanged);
  }
  String _lastSearchText = '';
  void _onSearchChanged() {
    final currentText = _searchController.text.trim();
    print('🔄 Search text changed: $currentText');

    if (_lastSearchText == currentText) {
      print('🟡 Duplicate search ignored: $currentText');
      return;
    }

    // Cancel any pending search
    if (_searchDebounce?.isActive ?? false) {
      print('⏸ Cancelling previous debounce');
      _searchDebounce?.cancel();
    }

    _searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      if (!mounted) return;

      if (_isSearching) {
        print('⌛ Search already in progress, queuing next');
        await Future.delayed(const Duration(milliseconds: 100));
        if (!mounted) return;
      }

      _lastSearchText = currentText;
      await _performSearch();
    });
  }

  void _onSearchChanged1() {
    print('🔄 Search text changed: ${_searchController.text}');

    // Cancel any pending search
    if (_searchDebounce?.isActive ?? false) {
      print('⏸ Cancelling previous debounce');
      _searchDebounce?.cancel();
    }

    // Start new debounce timer
    _searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      if (!mounted) {
        print('🚫 Widget disposed, skipping search');
        return;
      }

      if (_isSearching) {
        print('⌛ Search already in progress, queuing next');
        await Future.delayed(const Duration(milliseconds: 100));
        if (!mounted) return;
      }

      await _performSearch();
    });
  }

  Future<void> _performSearch() async {
    try {
      _isSearching = true;
      final text = _searchController.text.trim();
      print('🔍 Performing search for: "$text"');

      final prefs = await SharedPreferences.getInstance();
      final filter = prefs.getString('filter') ?? '';
      final cubit = context.read<SearchCubit>();

      if (text.isEmpty) {
        print('🧹 Clearing search results');
        cubit.clearSearchResults();
        return;
      }

      final params = SearchParams(
        search: text,
        filter: filter,
        params: PaginationParams(page: 1),
      );

      print('⚡ Executing search with filter: $filter');
      switch (filter) {
        case 'totalUsers':
          await cubit.loadUsersSearchData(params: params);
          break;
        case 'reels':
          await cubit.loadReelsSearchData(params: params);
          break;
        case 'posts':
          await cubit.loadPostsSearchData(params: params);
          break;
        case 'mainCategories':
          await cubit.loadPaginatedSearchData(params: params);
          break;
        case 'subCategories':
          await cubit.loadSubCategoriesSearchData(params: params);
          break;
        case 'ads':
          await cubit.loadAdsData(params: params);
          break;
        case 'comeWithYouTrips':
          await cubit.loadTripComeSearchData(params: params);
          break;
      }
      print('✅ Search completed for: "$text"');
    } catch (e) {
      print('❌ Search error: $e');
    } finally {
      _isSearching = false;
    }
  }

  @override
  void dispose() {
    print('♻️ Disposing search view');
    _searchController.removeListener(_onSearchChanged);
    _searchDebounce?.cancel();
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // Build method remains the same as your original,
    // just be sure to use `_searchController` in `FormTextField`
    // and remove the onSubmitted/action block since we now listen to changes.

    return CustomScaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Card(
          elevation: 0,
          color: Colors.white,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.r),
            borderSide: BorderSide.none,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: FormTextField(
              controller: _searchController,
              height: 70.h,
              hint: LocaleKeys.search.localize,
              borderRadius: BorderRadius.circular(40.r),
              style: Styles.mediumText(color: context.isDarkMode?Colors.black:AppColors.GREY_NORMAL_COLOR),
              prefix: Icon(
                Icons.search,
                size: 30.h,
                color:context.isDarkMode?Colors.black:AppColors.GREY_NORMAL_COLOR,
              ),
              noBorder: true,
              action: (_) {}, // no-op now
            ),
          ),
        ),
        // bottom: TabBar(
        //   tabAlignment: TabAlignment.start,
        //   isScrollable: true,
        //   controller: _tabController,
        //   onTap: (i) async {
        //     final prefs = await SharedPreferences.getInstance();
        //     switch (i) {
        //       case 0:
        //         await prefs.setString('filter', 'totalUsers');
        //         break;
        //       case 1:
        //         await prefs.setString('filter', 'reels');
        //         break;
        //       case 2:
        //         await prefs.setString('filter', 'posts');
        //         break;
        //       case 3:
        //         await prefs.setString('filter', 'mainCategories');
        //         break;
        //       case 4:
        //         await prefs.setString('filter', 'subCategories');
        //         break;
        //       case 5:
        //         await prefs.setString('filter', 'ads');
        //         break;
        //     }
        //
        //     final searchText = _searchController.text.trim();
        //     final cubit = context.read<SearchCubit>();
        //     String? filter = prefs.getString('filter');
        //
        //     if (searchText.isEmpty) return;
        //
        //     final params = SearchParams(
        //       search: searchText,
        //       filter: filter ?? '',
        //       params: PaginationParams(page: 1),
        //     );
        //
        //     switch (filter) {
        //       case 'totalUsers':
        //         cubit.loadUsersSearchData(params: params);
        //         break;
        //       case 'reels':
        //         cubit.loadReelsSearchData(params: params);
        //         break;
        //       case 'posts':
        //         cubit.loadPostsSearchData(params: params);
        //         break;
        //       case 'mainCategories':
        //         cubit.loadPaginatedSearchData(params: params);
        //         break;
        //       case 'subCategories':
        //         cubit.loadSubCategoriesSearchData(params: params);
        //         break;
        //       case 'ads':
        //         cubit.loadAdsData(params: params);
        //         break;
        //       case 'comeWithYouTrips':
        //         cubit.loadTripComeSearchData(params: params);
        //         break;
        //     }
        //   },
        //   labelColor: Colors.white,
        //   unselectedLabelColor: AppColors.GREY_NORMAL_COLOR,
        //   indicator: BoxDecoration(
        //     color: Theme.of(context).primaryColor,
        //     borderRadius: BorderRadius.circular(15.r),
        //   ),
        //   indicatorSize: TabBarIndicatorSize.label,
        //   indicatorPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
        //   padding: EdgeInsets.only(right: 40.w),
        //   labelPadding: EdgeInsets.only(left: 20.w),
        //   labelStyle: Styles.mediumText(fontSize: 32),
        //   tabs: [
        //     CustomTapWidget(text: LocaleKeys.profile.localize),
        //     CustomTapWidget(text: LocaleKeys.reel.localize),
        //     CustomTapWidget(text: LocaleKeys.post.localize),
        //     CustomTapWidget(text: LocaleKeys.mainCategory.localize),
        //     CustomTapWidget(text: LocaleKeys.subCategory.localize),
        //     CustomTapWidget(text: LocaleKeys.ads.localize),
        //   ],
        // ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(45.h),
          child: StatefulBuilder(
            builder: (context, setState) {
              return TabBar(
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                controller: _tabController,
                onTap: (i) async {
                  setState(() {}); // Update selection visuals

                  final prefs = await SharedPreferences.getInstance();
                  final filters = [
                    'totalUsers', 'reels', 'posts',
                    'mainCategories', 'subCategories', 'ads'
                  ];
                  await prefs.setString('filter', filters[i]);

                  final searchText = _searchController.text.trim();
                  final cubit = context.read<SearchCubit>();
                  String? filter = prefs.getString('filter');

                  if (searchText.isEmpty) return;

                  final params = SearchParams(
                    search: searchText,
                    filter: filter ?? '',
                    params: PaginationParams(page: 1),
                  );

                  switch (filter) {
                    case 'totalUsers': cubit.loadUsersSearchData(params: params); break;
                    case 'reels': cubit.loadReelsSearchData(params: params); break;
                    case 'posts': cubit.loadPostsSearchData(params: params); break;
                    case 'mainCategories': cubit.loadPaginatedSearchData(params: params); break;
                    case 'subCategories': cubit.loadSubCategoriesSearchData(params: params); break;
                    case 'ads': cubit.loadAdsData(params: params); break;
                    case 'comeWithYouTrips': cubit.loadTripComeSearchData(params: params); break;
                  }
                },
                indicator: const BoxDecoration(
                  color: Colors.transparent,
                ),
                dividerHeight: 0,
                indicatorPadding: EdgeInsets.zero,
                labelPadding: EdgeInsets.only(left: 20.w),
                padding: EdgeInsets.only(right: 40.w),
                tabs: List.generate(6, (index) {
                  final texts = [
                    LocaleKeys.profile.localize,
                    LocaleKeys.reel.localize,
                    LocaleKeys.post2.localize,
                    LocaleKeys.mainCategory.localize,
                    LocaleKeys.subCategory.localize,
                    LocaleKeys.ads.localize,
                  ];
                  return CustomTapWidget(
                    text: texts[index],
                    isSelected: _tabController.index == index,
                  );
                }),
              );
            },
          ),
        ),

      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          ProfileSearchView(),
          ReelSearchView(),
          PostsSearchView(
            // params: SearchParams(
            //   search: _searchController.text,
            //   params: PaginationParams(page: 1),
            // ),
          ),
          MainCategorySearchView(
            // params: SearchParams(
            //   search: _searchController.text,
            //   params: PaginationParams(page: 1),
            // ),
          ),
          SubCategorySearchView(),
          AdsSearchView(

          ),
          // ComeWithMeSearchView(
          //   params: SearchParams(
          //     search: _searchController.text,
          //     params: PaginationParams(page: 1),
          //   ),
          // ),
          // const Center(child: Text('Trip')),
          // const Center(child: Text('Trip')),
        ],
      ),
    );
  }
}




class CustomTapWidget extends StatelessWidget {
  final String text;
  final bool isSelected;

  const CustomTapWidget({
    super.key,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        width: 120,
        height: 35,
        // padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.getButtonPrimaryColor(context):AppColors.getFillColor(context),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            text,
            style: Styles.mediumText(
              // fontSize: 15,
              color: isSelected ? AppColors.getReversedTextColor(context) : AppColors.GREY_NORMAL_COLOR,
            ),
          ),
        ),
      ),
    );
  }
}


/*
class _SearchViewState extends State<SearchView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _searchController;
  Timer? _searchDebounce;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    print('✅ INIT SEARCH VIEW');
    context.read<SearchCubit>().initPref();
    _tabController = TabController(length: 9, vsync: this);
    _searchController = context.read<SearchCubit>().searchController;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    print('🔄 Search text changed: ${_searchController.text}');

    // Cancel any pending search
    if (_searchDebounce?.isActive ?? false) {
      print('⏸ Cancelling previous debounce');
      _searchDebounce?.cancel();
    }

    // Start new debounce timer
    _searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      if (!mounted) {
        print('🚫 Widget disposed, skipping search');
        return;
      }

      if (_isSearching) {
        print('⌛ Search already in progress, queuing next');
        await Future.delayed(const Duration(milliseconds: 100));
        if (!mounted) return;
      }

      await _performSearch();
    });
  }

  Future<void> _performSearch() async {
    try {
      _isSearching = true;
      final text = _searchController.text.trim();
      print('🔍 Performing search for: "$text"');

      final prefs = await SharedPreferences.getInstance();
      final filter = prefs.getString('filter') ?? '';
      final cubit = context.read<SearchCubit>();

      if (text.isEmpty) {
        print('🧹 Clearing search results');
        cubit.clearSearchResults();
        return;
      }

      final params = SearchParams(
        search: text,
        filter: filter,
        params: PaginationParams(page: 1),
      );

      print('⚡ Executing search with filter: $filter');
      switch (filter) {
        case 'totalUsers':
          await cubit.loadUsersSearchData(params: params);
          break;
        case 'reels':
          await cubit.loadReelsSearchData(params: params);
          break;
        case 'posts':
          await cubit.loadPostsSearchData(params: params);
          break;
        case 'mainCategories':
          await cubit.loadPaginatedSearchData(params: params);
          break;
        case 'subCategories':
          await cubit.loadSubCategoriesSearchData(params: params);
          break;
        case 'ads':
          await cubit.loadAdsData(params: params);
          break;
        case 'comeWithYouTrips':
          await cubit.loadTripComeSearchData(params: params);
          break;
      }
      print('✅ Search completed for: "$text"');
    } catch (e) {
      print('❌ Search error: $e');
    } finally {
      _isSearching = false;
    }
  }

  @override
  void dispose() {
    print('♻️ Disposing search view');
    _searchController.removeListener(_onSearchChanged);
    _searchDebounce?.cancel();
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // Build method remains the same as your original,
    // just be sure to use `_searchController` in `FormTextField`
    // and remove the onSubmitted/action block since we now listen to changes.

    return CustomScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Card(
          color: Colors.white,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.r),
            borderSide: BorderSide.none,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: FormTextField(
              controller: _searchController,
              height: 70.h,
              hint: LocaleKeys.search.localize,
              borderRadius: BorderRadius.circular(40.r),
              style: Styles.mediumText(color: AppColors.GREY_NORMAL_COLOR),
              prefix: Icon(
                Icons.search,
                size: 30.h,
                color: AppColors.GREY_NORMAL_COLOR,
              ),
              noBorder: true,
              action: (_) {}, // no-op now
            ),
          ),
        ),
        bottom: TabBar(
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          controller: _tabController,
          onTap: (i) async {
            final prefs = await SharedPreferences.getInstance();
            switch (i) {
              case 0:
                await prefs.setString('filter', 'totalUsers');
                break;
              case 1:
                await prefs.setString('filter', 'reels');
                break;
              case 2:
                await prefs.setString('filter', 'posts');
                break;
              case 3:
                await prefs.setString('filter', 'mainCategories');
                break;
              case 4:
                await prefs.setString('filter', 'subCategories');
                break;
              case 5:
                await prefs.setString('filter', 'ads');
                break;
              case 6:
                await prefs.setString('filter', 'comeWithYouTrips');
                break;
              case 7:
                await prefs.setString('filter', 'carpoolTrips');
                break;
              case 8:
                await prefs.setString('filter', 'rideTrips');
                break;
            }

            final searchText = _searchController.text.trim();
            final cubit = context.read<SearchCubit>();
            String? filter = prefs.getString('filter');

            if (searchText.isEmpty) return;

            final params = SearchParams(
              search: searchText,
              filter: filter ?? '',
              params: PaginationParams(page: 1),
            );

            switch (filter) {
              case 'totalUsers':
                cubit.loadUsersSearchData(params: params);
                break;
              case 'reels':
                cubit.loadReelsSearchData(params: params);
                break;
              case 'posts':
                cubit.loadPostsSearchData(params: params);
                break;
              case 'mainCategories':
                cubit.loadPaginatedSearchData(params: params);
                break;
              case 'subCategories':
                cubit.loadSubCategoriesSearchData(params: params);
                break;
              case 'ads':
                cubit.loadAdsData(params: params);
                break;
              case 'comeWithYouTrips':
                cubit.loadTripComeSearchData(params: params);
                break;
            }
          },
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: AppColors.GREY_NORMAL_COLOR,
          indicatorColor: AppColors.SECONDARY_COLOR,
          dividerColor: AppColors.GREY_LIGHT_COLOR,
          padding: EdgeInsets.only(right: 40.w),
          labelPadding: EdgeInsets.only(left: 20.w),
          labelStyle: Styles.mediumText(fontSize: 32),
          tabs: [
            CustomTapWidget(text: LocaleKeys.profile.localize),
            CustomTapWidget(text: LocaleKeys.reel.localize),
            CustomTapWidget(text: LocaleKeys.post.localize),
            CustomTapWidget(text: LocaleKeys.mainCategory.localize),
            CustomTapWidget(text: LocaleKeys.subCategory.localize),
            CustomTapWidget(text: LocaleKeys.ads.localize),
            CustomTapWidget(text: LocaleKeys.tripJoin.localize),
            CustomTapWidget(text: LocaleKeys.carpool.localize),
            CustomTapWidget(text: LocaleKeys.ride.localize),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ProfileSearchView(
            params: SearchParams(
              search: _searchController.text,
              params: PaginationParams(page: 1),
            ),
          ),
          const ReelSearchView(),
          PostsSearchView(
            params: SearchParams(
              search: _searchController.text,
              params: PaginationParams(page: 1),
            ),
          ),
          MainCategorySearchView(
            params: SearchParams(
              search: _searchController.text,
              params: PaginationParams(page: 1),
            ),
          ),
          const SubCategorySearchView(),
          AdsSearchView(
            params: SearchParams(
              search: _searchController.text,
              params: PaginationParams(page: 1),
            ),
          ),
          ComeWithMeSearchView(
            params: SearchParams(
              search: _searchController.text,
              params: PaginationParams(page: 1),
            ),
          ),
          const Center(child: Text('Trip')),
          const Center(child: Text('Trip')),
        ],
      ),
    );
  }
}
*/
