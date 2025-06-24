import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/features/search/presentation/pages/widget/build_item_ads_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../common/models/public/pagination_params.dart';
import '../../../../account_taps/wallet/presentation/widgets/custom_empty_widget.dart';

class AdsSearchView extends StatefulWidget {
  const AdsSearchView({super.key});

  @override
  State<AdsSearchView> createState() => _AdsSearchViewState();
}

class _AdsSearchViewState extends State<AdsSearchView> {
  late ScrollController _scrollController;
  late SearchCubit _cubit;

  static const double _scrollThreshold = 200.0;

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
    if (searchText.isEmpty) return;

    if (current >= max - _scrollThreshold &&
        !_cubit.isLoadingAdsMore &&
        _cubit.hasMoreAdsData) {
      final prefs = await SharedPreferences.getInstance();
      final filter = prefs.getString('filter') ?? '';
      final params = SearchParams(
        search: searchText,
        filter: filter,
        params: PaginationParams(page: _cubit.adsSearchPage),
      );
      _cubit.getPaginatedAdsSearch(params: params);
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 10.w),
      child: BlocBuilder<SearchCubit, SearchState>(
        buildWhen: (prev, curr) =>
            prev.adsSearch != curr.adsSearch || prev.status != curr.status,
        builder: (context, state) {
          print('==> 0');
          // final ads = _cubit.adsSearch;
          if (_cubit.searchController.text.trim().isEmpty) {
            print('==> 1');
            return CustomEmptyWidget(
              label: LocaleKeys.noData.localize,
            );
          }
          if (state.status == SearchStates.loading) {
            print('==> 2');

            return const Center(child: CupertinoActivityIndicator());
          }

          // if (ads.isEmpty) {
          //   print('==> 3');
          //
          //   return CustomEmptyWidget(
          //     label: LocaleKeys.noResultsFound.localize,
          //   );
          // }
          print('==> 4');
          return ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount:
                _cubit.adsSearch.length + (_cubit.isLoadingAdsMore ? 1 : 0),
            itemBuilder: (context, index) {
              print('==> 5');
              if (index >= _cubit.adsSearch.length) {
                print('==> 6');
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CupertinoActivityIndicator()),
                );
              }
              print('==> 7');
              return BuildItemAdsSearch(
                item: _cubit.adsSearch[index],
                onFav: (String id) async {
                  // return await controllerAdvertise.favouriteAd(id);
                },
                onRemoveFav: (String id) async {
                  // return await controllerAdvertise.unFavouriteAd(id);
                },
              );
            },
          );
        },
      ),
    );
  }
}

// class AdsSearchView extends StatefulWidget {
//   const AdsSearchView({super.key});
//   @override
//   State<AdsSearchView> createState() => _AdsSearchViewState();
// }
//
// class _AdsSearchViewState extends State<AdsSearchView> {
//
//   late ScrollController _scrollController;
//   late SearchCubit _cubit;
//   bool isFirstSearchListenerCall = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _cubit = context.read<SearchCubit>();
//     _scrollController = ScrollController()..addListener(_onScroll);
//   }
//
//   void _onScroll() async{
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200) {
//       final prefs = await SharedPreferences.getInstance();
//       String? filter = prefs.getString('filter');
//       SearchParams searchParams = SearchParams(
//           filter: filter,
//           params: widget.params.params,
//           search: widget.params.search
//       );
//       context.read<SearchCubit>().getPaginatedAdsSearch(
//           params:searchParams);
//     }
//   }
//
//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 10.w),
//       child: BlocProvider<AdvertisementCubit>(
//         create: (BuildContext context) => serviceLocator(),
//         child: BlocBuilder<AdvertisementCubit, AdsState>(
//           builder: (BuildContext context, advertise) {
//             var controllerAdvertise = context.read<AdvertisementCubit>();
//             return BlocBuilder<SearchCubit, SearchState>(
//               builder: (context, state) {
//                 // if(state.status ==SearchStates.loading){
//                 //   return const Center(child: CustomCircularProgressIndicator());
//                 // }
//                 final controller = context.read<SearchCubit>();
//                 if (controller.searchController.text.isNotEmpty) {
//                   return ListView.builder(
//                     controller: _scrollController,
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     itemCount: controller.adsSearch.length,
//                     itemBuilder: (context, index) {
//                       return BuildItemAdsSearch(
//                         item: controller.adsSearch[index],
//                         onFav: (String id) async {
//                           var result =
//                           await controllerAdvertise.favouriteAd(id);
//                           return result;
//                         },
//                         onRemoveFav: (String id) async {
//                           var result =
//                           await controllerAdvertise.unFavouriteAd(id);
//                           return result;
//                         },
//                       );
//                     },
//                   );
//                   // return PagedListView<int, AdsSearchEntity>(
//                   //   pagingController: controller.searchPagingAdsController,
//                   //   builderDelegate: PagedChildBuilderDelegate<AdsSearchEntity>(
//                   //     noItemsFoundIndicatorBuilder: (context) {
//                   //       return Center(
//                   //         child: Text(
//                   //           LocaleKeys.noData.localize,
//                   //           style: Styles.mediumText(),
//                   //         ),
//                   //       );
//                   //     },
//                   //     itemBuilder: (context, item, index) {
//                   //       return BuildItemAdsSearch(
//                   //         item: item,
//                   //         onFav: (String id) async {
//                   //           var result =
//                   //               await controllerAdvertise.favouriteAd(id);
//                   //           return result;
//                   //         },
//                   //         onRemoveFav: (String id) async {
//                   //           var result =
//                   //               await controllerAdvertise.unFavouriteAd(id);
//                   //           return result;
//                   //         },
//                   //       );
//                   //     },
//                   //     noMoreItemsIndicatorBuilder: (context) => Container(),
//                   //     firstPageProgressIndicatorBuilder: (context) =>
//                   //         const CupertinoActivityIndicator(),
//                   //     newPageProgressIndicatorBuilder: (context) =>
//                   //         const CupertinoActivityIndicator(),
//                   //   ),
//                   // );
//                 }
//
//                 return Center(
//                   child: Text(
//                     LocaleKeys.noData.localize,
//                     style: Styles.mediumText(),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
