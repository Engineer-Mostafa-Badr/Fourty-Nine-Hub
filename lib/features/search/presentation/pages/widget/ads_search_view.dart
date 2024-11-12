import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/search/domain/entity/ads_search_entity.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/features/search/presentation/pages/widget/build_item_ads_search.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';

class AdsSearchView extends StatefulWidget {
  const AdsSearchView({super.key});


  @override
  State<AdsSearchView> createState() => _AdsSearchViewState();
}

class _AdsSearchViewState extends State<AdsSearchView> {
  // late ScrollController _scrollController;
  // late SearchCubit _cubit;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _cubit = context.read<SearchCubit>();
  //   _scrollController = ScrollController()..addListener(_onScroll);
  //   _cubit.loadInitialData(widget.search);
  // }
  //
  // void _onScroll() {
  //   if (_scrollController.position.pixels >=
  //       _scrollController.position.maxScrollExtent - 200) {
  //     _cubit.fetchAdsSearch(widget.search);
  //   }
  // }
  //
  // @override
  // void dispose() {
  //   _scrollController.removeListener(_onScroll);
  //   _scrollController.dispose();
  //   super.dispose();
  // }

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
            return PagedListView<int, AdsSearchEntity>(
              pagingController: controller.searchPagingAdsController,
              builderDelegate: PagedChildBuilderDelegate<AdsSearchEntity>(
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
                  return BuildItemAdsSearch(
                    item: item,
                    onFav: (String id) async {
                      // var result = await widget.controller.favouriteAd(id);
                      // return result;
                    },
                    onRemoveFav: (String id) async {
                      // var result = await widget.controller.unFavouriteAd(id);
                      // return result;
                    },
                  );
                  // return InkWell(
                  //   onTap: () {
                  //     context.push(Routes.SUBCATEGORIES, extra: state.search![index]);
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(bottom: 8.0),
                  //     child: BuildItemSearchMainCategory(
                  //       category: item,
                  //       onFavorite: () async {
                  //         var result =
                  //         await controller.toggleFavoriteMedicalService(
                  //             item.id);
                  //         print("result$result");
                  //         return result;
                  //       },
                  //     ),
                  //   ),
                  // );
                },
                noMoreItemsIndicatorBuilder: (context) => Container(),
                firstPageProgressIndicatorBuilder: (context) =>
                const CupertinoActivityIndicator(),
                newPageProgressIndicatorBuilder: (context) =>
                const CupertinoActivityIndicator(),
              ),
            );
          }

          // If no search results or initial state
          return const Center(
            child: Text('No results found.'),
          );
        },
      ),
    );
    // return BlocBuilder<SearchCubit, SearchState>(
    //   builder: (BuildContext context, state) {
    //     if (state.status == SearchStates.loading) {
    //       return const CustomLoading();
    //     }
    //     return ListView.separated(
    //       controller: _scrollController,
    //       physics: const AlwaysScrollableScrollPhysics(),
    //       itemBuilder: (context, index) {
    //         if (index == _cubit.ads.length) {
    //           return const Center(child: CircularProgressIndicator());
    //         }
    //         return BuildItemAdsSearch(
    //           item: state.adsSearch![index],
    //           onFav: (String id) async {
    //             // var result = await widget.controller.favouriteAd(id);
    //             // return result;
    //           },
    //           onRemoveFav: (String id) async {
    //             // var result = await widget.controller.unFavouriteAd(id);
    //             // return result;
    //           },
    //         );
    //       },
    //       separatorBuilder: (context, index) => const Sizer(),
    //       itemCount: state.adsSearch?.length ??0,
    //     );
    //   },
    // );
  }

// Widget _buildTag() {
//   // super premium
//   return const Icon(
//     Icons.workspace_premium_outlined,
//     size: 20,
//     color: AppColors.SECONDARY_COLOR,
//   );
//   // premium
//   // regular
// }
//
// Widget buildItem() => InkWell(
//       onTap: () {
//         // context.push(Routes.ADdetails, extra: item.id);
//       },
//       child: Container(
//         width: kToolbarHeight * 2.5,
//         height: 500.h,
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: AppColors.BACKGROUND_COLOR, width: 2),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//                 child: SizedBox(
//               width: double.infinity,
//               child: Stack(
//                 children: [
//                   const Positioned.fill(
//                     child: SquareImage(
//                       fit: BoxFit.fill,
//                       radius: 5,
//                       url:
//                           'https://gratisography.com/wp-content/uploads/2024/01/gratisography-cyber-kitty-800x525.jpg',
//                     ),
//                   ),
//                   Positioned(
//                     top: 5,
//                     right: 5,
//                     child: _buildTag(),
//                   )
//                 ],
//               ),
//             )),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 // Expanded(
//                 //   child: Label(
//                 //     text:
//                 //         '${NumbersHelper.formatThousands(number: item.price??0)} L.E',
//                 //     style: Styles.mediumText(
//                 //         fontWeight: FontWeight.bold,
//                 //         color: AppColors.SECONDARY_COLOR),
//                 //     maxLines: 1,
//                 //   ),
//                 // ),
//                 const Sizer(),
//                 IconAppButton(
//                     size: 18, icon: Icons.favorite_border, onPressed: () {}),
//               ],
//             ),
//             Row(
//               children: [
//                 Label(
//                     text: '${LocaleKeys.title.localize} : ',
//                     style:
//                         Styles.mediumText(color: AppColors.SECONDARY_COLOR)),
//                 Label(
//                   text: 'Craft Job',
//                   style: Styles.mediumText(
//                       fontWeight: FontWeight.w500, color: Colors.grey),
//                   maxLines: 1,
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Label(
//                     text: '${LocaleKeys.desc.localize} : ',
//                     style:
//                         Styles.mediumText(color: AppColors.SECONDARY_COLOR)),
//                 Label(
//                   text: 'This is full time job',
//                   style: Styles.mediumText(
//                       fontWeight: FontWeight.w500, color: Colors.grey),
//                   maxLines: 1,
//                 ),
//               ],
//             ),
//             RichText(
//                 text: TextSpan(children: [
//               WidgetSpan(
//                   child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 0),
//                 margin: const EdgeInsets.all(1),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: Row(
//                   children: [
//                     Label(
//                         text: 'label :',
//                         //  text: '${e.label} : ',
//                         style: Styles.mediumText(
//                             color: AppColors.SECONDARY_COLOR)),
//                     Label(
//                         text: 'value',
//                         // text: '${e.value}',
//                         style: Styles.mediumText(
//                             color: AppColors.PRIMARY_COLOR)),
//                   ],
//                 ),
//               )),
//             ])),
//             Label(
//               text: 'Street hamza gaber manshia elbkary, haram giza',
//               // text: 'item.address?.street',
//               style: Styles.mediumText(color: Colors.grey),
//               maxLines: 1,
//             ),
//             Label(
//               text: 'Monday',
//               // text: 'item.formattedRestTime',
//               style: Styles.mediumText(color: Colors.grey),
//               maxLines: 1,
//             ),
//           ],
//         ),
//       ),
//     );
}
