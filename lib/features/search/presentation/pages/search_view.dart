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
import 'package:shared_preferences/shared_preferences.dart';

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
                  action: (v) async{
                    if (v.isNotEmpty) {
                      final prefs = await SharedPreferences.getInstance();
                      String? filter =  prefs.getString('filter');
                      print('context.read<SearchCubit>().state.filter??''${filter??''}');
                      context.read<SearchCubit>().loadData(
                        SearchParams(
                          search: v,
                          filter: filter??'',
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
          onTap: (i)async{
            final prefs = await SharedPreferences.getInstance();

            if(i==0){
              await prefs.setString('filter', 'totalUsers');
            }else if(i==1){
              await prefs.setString('filter', 'reels');
            }else if(i==2){
              await prefs.setString('filter', 'posts');
            }else if(i==3){
              await prefs.setString('filter', 'mainCategories');
            }else if(i==4){
              await prefs.setString('filter', 'subCategories');
            }else if(i==5){
              await prefs.setString('filter', 'ads');
            }else if(i==6){
              await prefs.setString('filter', 'trip');
            }
            String? filter =  prefs.getString('filter');

            print('context.read<SearchCubit>().state.filter??''${filter??''}');
              context.read<SearchCubit>().loadData(SearchParams(
                search: context.read<SearchCubit>().searchController.text,
                filter: filter??'',
                params: PaginationParams(page: 1),
              ));
            print('context.read<SearchCubit>().state.filter1??''${filter??''}');
          },
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: AppColors.GREY_NORMAL_COLOR,
          indicatorColor: AppColors.SECONDARY_COLOR,
          dividerColor: AppColors.GREY_LIGHT_COLOR,
          padding: EdgeInsets.only(right: 40.w),
          labelPadding:  EdgeInsets.only(left: 20.w),
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
        physics: const NeverScrollableScrollPhysics(),
        children:  const [
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
