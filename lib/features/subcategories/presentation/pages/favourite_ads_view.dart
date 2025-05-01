import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/ad_card.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/features/subcategories/presentation/pages/my_ad_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class FavouriteAdsView extends StatefulWidget {
  const FavouriteAdsView({super.key, required this.id});
  final String id;
  @override
  State<FavouriteAdsView> createState() => _FavouriteAdsViewState();
}

class _FavouriteAdsViewState extends State<FavouriteAdsView> {
  late ScrollController _scrollController;
  late SubcategoriesCubit _cubit;
  bool isFirstSearchListenerCall = true;

  @override
  void initState() {
    print("FavouriteAdsView initState");
    super.initState();
    _cubit = context.read<SubcategoriesCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SubcategoriesCubit>().getMyFavouriteAds(widget.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubcategoriesCubit, SubcategoriesState>(
      builder: (context,state) {
        final controller = context.read<SubcategoriesCubit>();
        if(controller.isLoadingMyFavouriteAds==true){
          return const Center(child: CircularProgressIndicator(),);
        }
        if(controller.myFavouriteAds.isEmpty){return Center(child: Label(text: "No Favourite Ads",style: Styles.mediumText(color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR),),);}
        return ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: controller.myFavouriteAds.length,
          itemBuilder: (context,i)=>MyAdCard(item: controller.myFavouriteAds[i], onFav: (id){}, onRemoveFav: (id){}),
        );
      }
    );
  }
}
