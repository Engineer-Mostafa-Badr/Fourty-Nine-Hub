import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';

import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/ad_card.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class AdsView extends StatefulWidget {
  final AdsViewParams params;

  const AdsView({
    super.key,
    required this.params,
  });

  @override
  State<AdsView> createState() => _AdsViewState();
}

class _AdsViewState extends State<AdsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<AdsCubit>().loadData(
          subCategoryId: widget.params.subCategory.id,
        );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppbar(),
      body: Column(
        children: [
          const Sizer(),
          MainCategoryBanner(category: widget.params.mainCategory),
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
              Tab(text: Labels.serviceProvider),
              Tab(text: Labels.user),
            ],
          ),
          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                BlocBuilder<AdsCubit, AdsState>(
                  builder: (context, state) {
                    if (state.ads != null) {
                      return ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8.0),
                        separatorBuilder: (context, index) => const Sizer(),
                        itemCount: state.ads?.length ?? 0,
                        itemBuilder: (context, index) {
                          return AdCard(
                            item: state.ads![index],
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                BlocBuilder<AdsCubit, AdsState>(
                  builder: (context, state) {
                    if (state.ads != null) {
                      return ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8.0),
                        separatorBuilder: (context, index) => const Sizer(),
                        itemCount: state.ads?.length ?? 0,
                        itemBuilder: (context, index) {
                          return AdCard(
                            item: state.ads![index],
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdsViewParams {
  final MainCategoryEntity mainCategory;
  final SubCategoryEntity subCategory;

  AdsViewParams({required this.mainCategory, required this.subCategory});
}
