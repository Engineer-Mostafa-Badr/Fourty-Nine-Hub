import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
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

class _SearchViewState extends State<SearchView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    context.read<SearchCubit>().initPref();
    super.initState();
    _tabController = TabController(length: 9, vsync: this); // Updated length
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  getFilterName()async{
    final prefs = await SharedPreferences.getInstance();
    String? filter = prefs.getString('filter');
    return filter??'';
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: BlocBuilder<SearchCubit, SearchState>(
          builder: (BuildContext context, state) {
            return Card(
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
                  controller: context.read<SearchCubit>().searchController,
                  action: (v) async {
                    if (v.isNotEmpty) {
                      final prefs = await SharedPreferences.getInstance();
                      String? filter = prefs.getString('filter');
                      if (filter == 'totalUsers') {
                        context.read<SearchCubit>().loadUsersSearchData(
                              params:SearchParams(
                                search: v,
                                filter: filter ?? '',
                                params: PaginationParams(page: 1),
                              ),
                            );
                      }
                      if (filter == 'reels') {
                        context.read<SearchCubit>().loadReelsSearchData(
                              params:SearchParams(
                                search: v,
                                filter: filter ?? '',
                                params: PaginationParams(page: 1),
                              ),
                            );
                      }
                      if (filter == 'posts') {
                        context.read<SearchCubit>().loadPostsSearchData(
                              params:SearchParams(
                                search: v,
                                filter: filter ?? '',
                                params: PaginationParams(page: 1),
                              ),
                            );
                      }
                      if (filter == 'mainCategories') {
                        context.read<SearchCubit>().loadPaginatedSearchData(
                              params:SearchParams(
                                search: v,
                                filter: filter ?? '',
                                params: PaginationParams(page: 1),
                              ),
                            );
                      }
                      if (filter == 'subCategories') {
                        context.read<SearchCubit>().loadSubCategoriesSearchData(
                              params:SearchParams(
                                search: v,
                                filter: filter ?? '',
                                params: PaginationParams(page: 1),
                              ),
                            );
                      }
                      if (filter == 'ads') {
                        context.read<SearchCubit>().loadAdsData(
                              params:SearchParams(
                                search: v,
                                filter: filter ?? '',
                                params: PaginationParams(page: 1),
                              ),
                            );
                      }
                      if (filter == 'comeWithYouTrips') {
                        context.read<SearchCubit>().loadTripComeSearchData(
                              params:SearchParams(
                                search: v,
                                filter: filter ?? '',
                                params: PaginationParams(page: 1),
                              ),
                            );
                      }
                    }
                  },
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
                ),
              ),
            );
          },
        ),
        bottom: TabBar(
          tabAlignment: TabAlignment.start,
          isScrollable: true,
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

            // Fetch data for the selected tab
            String? filter = prefs.getString('filter');
            if (filter == 'totalUsers') {
              context.read<SearchCubit>().loadUsersSearchData(
                    params:SearchParams(
                      search: context.read<SearchCubit>().searchController.text,
                      filter: filter ?? '',
                      params: PaginationParams(page: 1),
                    ),
                  );
            }
            if (filter == 'reels') {
              context.read<SearchCubit>().loadReelsSearchData(
                    params:SearchParams(
                      search: context.read<SearchCubit>().searchController.text,
                      filter: filter ?? '',
                      params: PaginationParams(page: 1),
                    ),
                  );
            }
            if (filter == 'posts') {
              context.read<SearchCubit>().loadPostsSearchData(
                    params:SearchParams(
                      search: context.read<SearchCubit>().searchController.text,
                      filter: filter ?? '',
                      params: PaginationParams(page: 1),
                    ),
                  );
            }
            if (filter == 'mainCategories') {
              context.read<SearchCubit>().loadPaginatedSearchData(
                    params:SearchParams(
                      search: context.read<SearchCubit>().searchController.text,
                      filter: filter ?? '',
                      params: PaginationParams(page: 1),
                    ),
                  );
            }
            if (filter == 'subCategories') {
              context.read<SearchCubit>().loadSubCategoriesSearchData(
                    params:SearchParams(
                      search: context.read<SearchCubit>().searchController.text,
                      filter: filter ?? '',
                      params: PaginationParams(page: 1),
                    ),
                  );
            }
            if (filter == 'ads') {
              context.read<SearchCubit>().loadAdsData(
                    params: SearchParams(
                      search: context.read<SearchCubit>().searchController.text,
                      filter: filter ?? '',
                      params: PaginationParams(page: 1),
                    ),
                  );
            }
            if (filter == 'comeWithYouTrips') {
              context.read<SearchCubit>().loadTripComeSearchData(
                    params:SearchParams(
                      search: context.read<SearchCubit>().searchController.text,
                      filter: filter ?? '',
                      params: PaginationParams(page: 1),
                    ),
                  );
            }
          },
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: AppColors.GREY_NORMAL_COLOR,
          indicatorColor: AppColors.SECONDARY_COLOR,
          dividerColor: AppColors.GREY_LIGHT_COLOR,
          padding: EdgeInsets.only(right: 40.w),
          labelPadding: EdgeInsets.only(left: 20.w),
          labelStyle: Styles.mediumText(fontSize: 32),
          tabs: [
            CustomTapWidget(
              text: LocaleKeys.profile.localize,
            ),
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
               search: context.read<SearchCubit>().searchController.text,
               // filter: getFilterName(),
               params: PaginationParams(page: 1),
             ),),
          const ReelSearchView(),
          PostsSearchView(
            params: SearchParams(
              search: context.read<SearchCubit>().searchController.text,
              // filter: getFilterName(),
              params: PaginationParams(page: 1),
            ),
          ),
          MainCategorySearchView(
            params: SearchParams(
              search: context.read<SearchCubit>().searchController.text,
              // filter: getFilterName(),
              params: PaginationParams(page: 1),
            ),
          ),
          const SubCategorySearchView(),
          AdsSearchView(
            params: SearchParams(
              search: context.read<SearchCubit>().searchController.text,
              // filter: getFilterName(),
              params: PaginationParams(page: 1),
            ),
          ),
          ComeWithMeSearchView(
            params: SearchParams(
              search: context.read<SearchCubit>().searchController.text,
              // filter: getFilterName(),
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

class CustomTapWidget extends StatelessWidget {
  const CustomTapWidget({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Tab(
      child: SizedBox(
        width: 120,
        child: Center(child: Text(text)),
      ),
    );
  }
}
