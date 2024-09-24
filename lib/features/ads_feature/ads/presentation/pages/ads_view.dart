import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';

import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/ad_card.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
    context.read<AdvertisementCubit>().loadData(
        subCategoryId: widget.params.subCategory.id, filter: 'provider');

    _tabController.addListener(() {
      if (_tabController.index == 0) {
        context.read<AdvertisementCubit>().loadData(
            subCategoryId: widget.params.subCategory.id, filter: 'provider');
      } else {
        context.read<AdvertisementCubit>().loadData(
            subCategoryId: widget.params.subCategory.id, filter: 'user');
      }
    });
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
      body:
          BlocBuilder<AdvertisementCubit, AdsState>(builder: (context, state) {
        final controller = context.read<AdvertisementCubit>();
        return Column(
          children: [
            const Sizer(),
            SizedBox(
                width: double.infinity,
                child: MainCategoryBanner(
                  category: widget.params.mainCategory,
                  onFavorite: () {},
                  isFavorite: widget.params.mainCategory.isFavorite,
                )),
            const Sizer(),
            Label(
              text: widget.params.subCategory.name,
              style: Styles.headerText(),
            ),
            const Sizer(),
            TabBar(
              controller: _tabController,
              labelColor: AppColors.SECONDARY_COLOR,
              unselectedLabelColor: Theme.of(context).primaryColor,
              indicatorColor: AppColors.SECONDARY_COLOR,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: Styles.headerText(),
              onTap: (i) {
                if (i == 1) {
                  controller.loadData(
                      subCategoryId: widget.params.subCategory.id,
                      filter: 'user');
                } else {
                  controller.loadData(
                      subCategoryId: widget.params.subCategory.id,
                      filter: 'provider');
                }
              },
              tabs: [
                Tab(text: LocaleKeys.provider.localize),
                Tab(text: LocaleKeys.user.localize),
              ],
            ),
            state.status == AdsStates.success
                ? Expanded(
                    child: PagedListView<int, AdModel>(
                    pagingController: controller.adsPagingController,
                    builderDelegate: PagedChildBuilderDelegate<AdModel>(
                        noItemsFoundIndicatorBuilder: (context) {
                          print(
                              controller.adsPagingController.itemList?.length);
                          return Center(
                            child: Text(
                              LocaleKeys.noAds.localize,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          );
                        },
                        itemBuilder: (context, item, index) {
                          return AdCard(item: item);
                        },
                        noMoreItemsIndicatorBuilder: (context) => Container(),
                        firstPageProgressIndicatorBuilder: (context) =>
                            Container(
                                margin: const EdgeInsets.only(top: 150),
                                child: const CupertinoActivityIndicator()),
                        newPageProgressIndicatorBuilder: (context) =>
                            const CupertinoActivityIndicator()),
                  ))
                : const SizedBox.shrink()
          ],
        );
      }),
    );
  }
}

class AdsViewParams {
  final MainCategoryEntity mainCategory;
  final SubCategoryEntity subCategory;

  AdsViewParams({required this.mainCategory, required this.subCategory});
}
