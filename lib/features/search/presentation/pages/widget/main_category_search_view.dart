import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/dynamic/pagination_view.dart';
import 'package:fourtyninehub/features/search/domain/entity/main_category_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
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
            return ListView.separated(
              itemCount: state.search?.length ??0,
              // physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    context.push(Routes.SUBCATEGORIES, extra: state.search![index]);
                  },
                  child: BuildItemSearchMainCategory(
                    category: state.search![index],
                    onFavorite: () async {
                      var result =
                      await controller.toggleFavoriteMedicalService(
                          state.search![index].id);
                      print("result$result");
                      return result;
                    },
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
              const Sizer(),
            );
            // return PaginationView<MainSubCategorySearchEntity>(
            //   build: (ScrollController scrollController, data) {
            //     return ListView.separated(
            //       itemCount: data.length,
            //       // physics: const NeverScrollableScrollPhysics(),
            //       shrinkWrap: true,
            //       itemBuilder: (context, index) {
            //         return InkWell(
            //           onTap: () {
            //             context.push(Routes.SUBCATEGORIES, extra: data[index]);
            //           },
            //           child: BuildItemSearchMainCategory(
            //             category: data[index],
            //             onFavorite: () async {
            //               var result =
            //               await controller.toggleFavoriteMedicalService(
            //                   state.search![index].id);
            //               print("result$result");
            //               return result;
            //             },
            //           ),
            //         );
            //       },
            //       separatorBuilder: (BuildContext context, int index) =>
            //       const Sizer(),
            //     );
            //   },
            //   fetchData: (PaginationParams paginationParams) {
            //     return controller.getSearch(
            //       SearchParams(
            //         search: controller.searchController.text,
            //         filter: 'mainCategories',
            //         params: paginationParams,
            //       ),
            //     );
            //   },
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

