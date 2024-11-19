import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/search/domain/entity/main_category_search_entity.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'build_Item_search_main_category.dart';

class MainCategorySearchView extends StatelessWidget {
  const MainCategorySearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 10.w),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          final controller = context.read<SearchCubit>();
          // Listen for changes in the search text and trigger search
          // controller.searchController.addListener(() {
          //   if (controller.searchController.text.isNotEmpty) {
          //     controller.getSearch(SearchParams(
          //       search: controller.searchController.text,
          //       params: PaginationParams(page: 1),
          //     ));
          //   }
          // });

          // Display a loading shimmer when the search is loading
          // if (state.status==SearchStates.loading) {
          //   return Shimmer.fromColors(
          //     baseColor: Colors.grey[100]!,
          //     highlightColor: Colors.white24,
          //     child: Column(
          //       children: List.generate(
          //           6,
          //               (index) => Padding(
          //             padding: EdgeInsets.only(bottom: 15.h),
          //             child: Container(
          //               height: MediaQuery.of(context).size.height * .15.h,
          //               width: double.infinity,
          //               margin: EdgeInsets.symmetric(horizontal: 10.w),
          //               padding: EdgeInsets.symmetric(horizontal: 10.w),
          //               decoration: BoxDecoration(
          //                 color: AppColors.AUTH_CONTAINER_COLOR,
          //                 borderRadius: BorderRadius.circular(20.r),
          //                 border: Border.all(color: Colors.grey),
          //               ),
          //             ),
          //           )),
          //     ),
          //   );
          // }

          // Check if search results exist
          if (controller.searchController.text.isNotEmpty) {
            return PagedListView<int, MainSubCategorySearchEntity>(
              pagingController: controller.searchPagingController,
              builderDelegate:
                  PagedChildBuilderDelegate<MainSubCategorySearchEntity>(
                noItemsFoundIndicatorBuilder: (context) {
                  return Center(
                    child: Text(
                      LocaleKeys.noData.localize,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  );
                },
                itemBuilder: (context, item, index) {
                  return InkWell(
                    onTap: () {
                      context.push(Routes.SUBCATEGORIES,
                          extra: state.search![index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: BuildItemSearchMainCategory(
                        category: item,
                        onFavorite: () async {
                          var result = await controller
                              .toggleFavoriteMedicalService(item.id);
                          print("result$result");
                          return result;
                        },
                      ),
                    ),
                  );
                },
                noMoreItemsIndicatorBuilder: (context) => Container(),
                firstPageProgressIndicatorBuilder: (context) =>
                    const CupertinoActivityIndicator(),
                newPageProgressIndicatorBuilder: (context) =>
                    const CupertinoActivityIndicator(),
              ),
            );
            // return ListView.separated(
            //   itemCount: state.search?.length ??0,
            //   // physics: const NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
            //   itemBuilder: (context, index) {
            //     return InkWell(
            //       onTap: () {
            //         context.push(Routes.SUBCATEGORIES, extra: state.search![index]);
            //       },
            //       child: BuildItemSearchMainCategory(
            //         category: state.search![index],
            //         onFavorite: () async {
            //           var result =
            //           await controller.toggleFavoriteMedicalService(
            //               state.search![index].id);
            //           print("result$result");
            //           return result;
            //         },
            //       ),
            //     );
            //   },
            //   separatorBuilder: (BuildContext context, int index) =>
            //   const Sizer(),
            // );
          }

          // If no search results or initial state
          return const Center(
            child: Text('No results found.'),
          );
        },
      ),
    );
  }
}
