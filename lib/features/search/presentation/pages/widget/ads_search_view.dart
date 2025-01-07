import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/search/domain/entity/ads_search_entity.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/features/search/presentation/pages/widget/build_item_ads_search.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AdsSearchView extends StatefulWidget {
  const AdsSearchView({super.key});

  @override
  State<AdsSearchView> createState() => _AdsSearchViewState();
}

class _AdsSearchViewState extends State<AdsSearchView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 10.w),
      child: BlocProvider<AdvertisementCubit>(
        create: (BuildContext context) => serviceLocator(),
        child: BlocBuilder<AdvertisementCubit, AdsState>(
          builder: (BuildContext context, advertise) {
            var controllerAdvertise = context.read<AdvertisementCubit>();
            return BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                // if(state.status ==SearchStates.loading){
                //   return const Center(child: CircularProgressIndicator());
                // }
                final controller = context.read<SearchCubit>();
                if (controller.searchController.text.isNotEmpty) {
                  return PagedListView<int, AdsSearchEntity>(
                    pagingController: controller.searchPagingAdsController,
                    builderDelegate: PagedChildBuilderDelegate<AdsSearchEntity>(
                      noItemsFoundIndicatorBuilder: (context) {
                        return Center(
                          child: Text(
                            LocaleKeys.noData.localize,
                            style: Styles.mediumText(),
                          ),
                        );
                      },
                      itemBuilder: (context, item, index) {
                        return BuildItemAdsSearch(
                          item: item,
                          onFav: (String id) async {
                            var result =
                                await controllerAdvertise.favouriteAd(id);
                            return result;
                          },
                          onRemoveFav: (String id) async {
                            var result =
                                await controllerAdvertise.unFavouriteAd(id);
                            return result;
                          },
                        );
                      },
                      noMoreItemsIndicatorBuilder: (context) => Container(),
                      firstPageProgressIndicatorBuilder: (context) =>
                          const CupertinoActivityIndicator(),
                      newPageProgressIndicatorBuilder: (context) =>
                          const CupertinoActivityIndicator(),
                    ),
                  );
                }

                return Center(
                  child: Text(LocaleKeys.noResultsFound.localize),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
