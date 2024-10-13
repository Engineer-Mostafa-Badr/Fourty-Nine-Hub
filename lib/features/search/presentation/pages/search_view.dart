import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/features/search/presentation/pages/widget/ads_search_view.dart';
import 'package:fourtyninehub/features/search/presentation/pages/widget/main_category_search_view.dart';
import 'package:fourtyninehub/features/search/presentation/pages/widget/posts_search_view.dart';
import 'package:fourtyninehub/features/search/presentation/pages/widget/profile_search_view.dart';
import 'package:fourtyninehub/features/search/presentation/pages/widget/reel_search_view.dart';
import 'package:fourtyninehub/features/search/presentation/pages/widget/subcategory_search_view.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this); // Updated length
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: BlocBuilder<SearchCubit,SearchState>(
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
                  action: (v) {
                    if (v.isNotEmpty) {
                      context.read<SearchCubit>().getSearch(
                        SearchParams(
                          search: v,
                          params: PaginationParams(page: 1),
                        ),
                      );
                    }
                  },
                  height: 70.h,
                  hint: 'Search',
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
          // Enable scrolling for the TabBar
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: AppColors.GREY_NORMAL_COLOR,
          indicatorColor: AppColors.SECONDARY_COLOR,
          dividerColor: AppColors.GREY_LIGHT_COLOR,
          labelPadding: const EdgeInsets.only(left: 20),
          labelStyle: Styles.mediumText(fontSize: 32),
          tabs: const [
            Tab(text: 'Profile'),
            Tab(text: 'Reel'),
            Tab(text: 'Post'),
            Tab(text: 'Main Category'),
            Tab(text: 'Sub Category'),
            Tab(text: 'Ads'),
            Tab(text: 'Trip'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ProfileSearchView(),
          ReelSearchView(),
          PostsSearchView(),
          MainCategorySearchView(),
          SubCategorySearchView(),
          AdsSearchView(),
          Center(child: Text('Trip')),
        ],
      ),
    );
  }
}
