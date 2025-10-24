import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../../core/widget/olx_pagination/banner.dart';
import '../../../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import '../../domain/entities/restaurant.dart';
import '../cubit/restaurants_list_cubit.dart';
import '../widgets/subcatigories_restaurant_card.dart';

class RestaurantFavAdsScreen extends StatefulWidget {
  const RestaurantFavAdsScreen({super.key, this.onClose});

  final VoidCallback? onClose;

  @override
  State<RestaurantFavAdsScreen> createState() => _RestaurantFavAdsScreenState();
}

class _RestaurantFavAdsScreenState extends State<RestaurantFavAdsScreen> {
  late ScrollController _scrollController;
  bool isFirstSearchListenerCall = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    // if (_scrollController.position.pixels >=
    //     _scrollController.position.maxScrollExtent - 200) {
    //   context.read<RestaurantsCubit>().getFoodAds();
    // }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // String formatViews(int views) {
  //   if (views >= 1000000) {
  //     return "${(views / 1000000).toStringAsFixed(1)}M";
  //   } else if (views >= 1000) {
  //     return "${(views / 1000).toStringAsFixed(1)}K";
  //   } else {
  //     return views.toString();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsCubit, RestaurantsListState>(
        builder: (context, state) {
      if (!state.isLoading) {
        return context.read<RestaurantsCubit>().foodAdData.isNotEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .7,
                  child: OlxPaginationWidget(
                    scrollController: _scrollController,
                    itemsPerPage: 2,
                    loadPage: (page) async {},
                    banners: bannersList,
                    items: List.generate(
                      context.read<RestaurantsCubit>().foodAdData.length,
                      (index) {
                        var data =
                            context.read<RestaurantsCubit>().foodAdData[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FavFoodCard(
                            data: data,
                            index: index,
                          ),
                        );
                      },
                    ),
                  ),
                  /*ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:  context
                    .read<RestaurantsCubit>()
                    .foodAdData
                    .length,
                  itemBuilder: (context,index){
                    var data =  context.read<RestaurantsCubit>().foodAdData[index];
                    return  FavFoodCard(data: data,index: index,);
                  }, separatorBuilder: (BuildContext context, int index) =>const Sizer(),

                ),*/
                ),
              )
            : Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height *
                      .65, // Make sure it takes up full height
                  child: Center(
                    // This will center it vertically and horizontally
                    child: CustomEmptyWidget(
                      label: LocaleKeys.noResultsFound.tr(),
                    ),
                  ),
                ),
              );
      } else {
        return const CustomLoadingSearchWidget();
        // SizedBox(
        //   height: MediaQuery.of(context).size.height * .65, // Make sure it takes up full height
        //   child: const Center(
        //     child: CustomCircularProgressIndicator(),
        //   ),
        // );
      }
    });
  }
}

class FavFoodCard extends StatefulWidget {
  const FavFoodCard({super.key, required this.data, required this.index});

  final GetAllRestaurantEntity data;
  final int index;

  @override
  State<FavFoodCard> createState() => _FavFoodCardState();
}

class _FavFoodCardState extends State<FavFoodCard> {
  @override
  Widget build(BuildContext context) {
    return PropertyCard(
      item: widget.data,
      mealId: "",
      myRestaurant: false,
      favouriteRestaurant: (String id) async {
        await context.read<RestaurantsCubit>().toggleFavoriteRestaurant(id);
      },
    );
  }
}
