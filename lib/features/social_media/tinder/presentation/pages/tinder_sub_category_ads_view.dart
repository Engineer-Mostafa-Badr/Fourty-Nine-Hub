import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';

import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/ad_card.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TinderSubCategoryAdsView extends StatefulWidget {
  final TinderSubAdsViewParams params;

  const TinderSubCategoryAdsView({
    super.key,
    required this.params,
  });

  @override
  State<TinderSubCategoryAdsView> createState() =>
      _TinderSubCategoryAdsViewState();
}

class _TinderSubCategoryAdsViewState extends State<TinderSubCategoryAdsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // context.read<AdsCubit>().loadData(
    //       subCategoryId: widget.params.subCategory.id,
    //     );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TinderViewCubit(),
      child: Scaffold(
        appBar: const HomeAppbar(),
        body: Column(
          children: [
            const Sizer(),
            // MainCategoryBanner(category: widget.params.mainCategory),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.yellow,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.params.subCategory.image),
                  )),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            // final result = widget.onFavorite?.call();
                            // if (result != null && result != _isFavorite) {
                            //   setState(() {
                            //     _isFavorite = result;
                            //   });
                            // }
                          },
                          child: Icon(
                            Icons.favorite,
                            color: widget.params.subCategory.isFavorite
                                ? AppColors.SECONDARY_COLOR
                                : AppColors.GREY_DARK_COLOR,
                          ),
                        ),
                        const Sizer(),
                        OutlineText(
                          text: '${2} ${Labels.ads}',
                          textStyle: Styles.mediumText(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    child: FittedBox(
                      child: OutlineText(
                        text: widget.params.subCategory.name,
                        textStyle: Styles.headerText(
                            color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Expanded(child: _buildRegisterButton())
                ],
              ),
            ),
            const Sizer(),
            Label(
              text: widget.params.subCategory.name,
              style: Styles.headerText(),
            ),
            const Sizer(),
            TabBar(
              controller: _tabController,
              labelColor: AppColors.SECONDARY_COLOR,
              unselectedLabelColor: AppColors.PRIMARY_COLOR,
              indicatorColor: AppColors.SECONDARY_COLOR,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: Labels.male),
                Tab(text: Labels.female),
              ],
            ),
            // TabBarView
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // BlocBuilder<AdsCubit, AdsState>(
                  //   builder: (context, state) {
                  //     if (state.ads != null) {
                  //       return ListView.separated(
                  //         shrinkWrap: true,
                  //         padding: const EdgeInsets.all(8.0),
                  //         separatorBuilder: (context, index) => const Sizer(),
                  //         itemCount: state.ads?.length ?? 0,
                  //         itemBuilder: (context, index) {
                  //           return AdCard(
                  //             item: state.ads![index],
                  //           );
                  //         },
                  //       );
                  //     } else {
                  //       return const Center(child: CircularProgressIndicator());
                  //     }
                  //   },
                  // ),
                  // BlocBuilder<AdsCubit, AdsState>(
                  //   builder: (context, state) {
                  //     if (state.ads != null) {
                  //       return ListView.separated(
                  //         shrinkWrap: true,
                  //         padding: const EdgeInsets.all(8.0),
                  //         separatorBuilder: (context, index) => const Sizer(),
                  //         itemCount: state.ads?.length ?? 0,
                  //         itemBuilder: (context, index) {
                  //           return AdCard(
                  //             item: state.ads![index],
                  //           );
                  //         },
                  //       );
                  //     } else {
                  //       return const Center(child: CircularProgressIndicator());
                  //     }
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TinderSubAdsViewParams {
  final MainCategoryEntity mainCategory;
  final SubCategoryEntity subCategory;

  TinderSubAdsViewParams(
      {required this.mainCategory, required this.subCategory});
}
