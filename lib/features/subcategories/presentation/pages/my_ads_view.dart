import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/ad_card.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/features/subcategories/presentation/pages/my_ad_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class MyAdsView extends StatefulWidget {
  const MyAdsView({super.key, required this.id});
  final String id;
  @override
  State<MyAdsView> createState() => _MyAdsViewState();
}

class _MyAdsViewState extends State<MyAdsView> {
  late ScrollController _scrollController;
  late SubcategoriesCubit _cubit;
  bool isFirstSearchListenerCall = true;

  @override
  void initState() {
    print("MyAdsView initState");
    super.initState();
    _cubit = context.read<SubcategoriesCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SubcategoriesCubit>().getMyAds(widget.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubcategoriesCubit, SubcategoriesState>(
      builder: (context,state) {
        final controller = context.read<SubcategoriesCubit>();
        if(controller.isLoadingMyAds==true){
          return const Center(child: CircularProgressIndicator(),);
        }
        if(controller.myAds.isEmpty){return Center(child: Label(text: "No Favourite Ads",style: Styles.mediumText(color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR),),);}
        return ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: controller.myAds.length,
          itemBuilder: (context,i)=>MyAdCard(item: controller.myAds[i], onFav: (id){}, onRemoveFav: (id){}),
        );
      }
    );
  }
}
