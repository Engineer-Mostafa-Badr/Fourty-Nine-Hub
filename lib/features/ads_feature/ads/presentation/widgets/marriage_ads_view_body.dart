import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/core/widget/custom_notification_badge.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/filter_button_item.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/header_button_widget.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/marriage_ads_list_view.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/sub_category_list_view_item.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/data/models/filter_model.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class MarriageAdsViewBody extends StatelessWidget {
  const MarriageAdsViewBody({
    super.key,
    required this.controller,
    required this.state,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final SubcategoriesCubit controller;
  final SubcategoriesState state;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        state.mainCategory == null
            ? Container()
            : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MainCategoryBanner(
                  fromHome: false,
                  category:
                      context.read<SubcategoriesCubit>().state.mainCategory!,
                  onFavorite: () async {
                    // var result =
                    // await controller.toggleFavoriteMedicalService(
                    //     state.data![index].id);
                    // print("result$result");
                    // return result;
                  },
                ),
            ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: CustomNotificationBadge(
                  count: 22,
                  child: HeaderButtonWidget(
                    title: LocaleKeys.requestLog.localize,
                    onPressed: () {},
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: HeaderButtonWidget(
                  title: LocaleKeys.myAds.localize,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: FilterButtonItem(
                  title: LocaleKeys.filter.localize,
                  onTap: () async {
                    dynamic data = await context.push(
                      Routes.FILTERADS,
                      extra: CategorizationEntity(
                        mainCategory: state.mainCategory!,
                        fromMarriage: true,
                        subCategory: state.subCategories![state.subCategories
                                ?.indexWhere(
                                    (element) => element.isSelected == true) ??
                            0],
                      ),
                    );
                    // if (data != null) {
                    //   print("objectsdaa");
                    //   // Future.delayed(const Duration(seconds: 1), () =>
                    //   //     controller.changeState(data, data != null));
                    //   // context.read<AdvertisementCubit>().loadFilterData(
                    //   //     model: data,
                    //   //     filter: userType);
                    //   controller.changeFilterModel(data);
                    //
                    //   controller.loadFilterData(
                    //       model: data, filter: 'user');
                    // }
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: FilterButtonItem(
                  title: LocaleKeys.city.localize,
                  onTap: () async {
                    dynamic data = await context.push(
                        Routes.GOVERNORATEFILTERADS,
                        extra: CategorizationEntity(
                            mainCategory: state.mainCategory!,
                            fromMarriage: true,
                            subCategory: state
                                .subCategories![state.subCategories?.indexWhere(
                                    (element) => element.isSelected == true) ??
                                0]));
                    if (data != null) {
                      print("data.cityId${data.cityId}");
                      print("data.governorateId${data.governorateId}");
                      print("objectsdaa");
                      controller.state.city = data.cityId;
                      controller.state.governorate = data.governorateId;
                      controller.changeFilterModel(data);
                      FilterModel model = FilterModel(
                          cityId: "state.city",
                          governorateId: "state.governorate");
                      // Future.delayed(const Duration(seconds: 1), () =>
                      //     controller.changeState(data, data != null));
                      // context.read<AdvertisementCubit>().loadFilterData(
                      //     model: data,
                      //     filter: userType);
                      await controller.loadFilterData(
                          model: data, filter: 'user');
                    }
                  },
                ),
              ),
              // Expanded(
              //   child: BadgedLabel(
              //       label: LocaleKeys.city.localize,
              //       style: Styles.mediumText(
              //         color: Colors.white,
              //         fontSize: 32,
              //       ),
              //       icon: Icons.filter_alt_rounded,
              //       padding:
              //           EdgeInsets.symmetric(vertical: 15.h, horizontal: 5.w),
              //       iconLeading: Icons.arrow_drop_down,
              //       onTap: () async {
              //         dynamic data = await context.push(
              //             Routes.GOVERNORATEFILTERADS,
              //             extra: CategorizationEntity(
              //                 mainCategory: state.mainCategory!,
              //                 fromMarriage: true,
              //                 subCategory: state.subCategories![
              //                     state.subCategories?.indexWhere((element) =>
              //                             element.isSelected == true) ??
              //                         0]));
              //         if (data != null) {
              //           print("data.cityId${data.cityId}");
              //           print("data.governorateId${data.governorateId}");
              //           print("objectsdaa");
              //           controller.state.city = data.cityId;
              //           controller.state.governorate = data.governorateId;
              //           controller.changeFilterModel(data);
              //           FilterModel model = FilterModel(
              //               cityId: "state.city",
              //               governorateId: "state.governorate");
              //           // Future.delayed(const Duration(seconds: 1), () =>
              //           //     controller.changeState(data, data != null));
              //           // context.read<AdvertisementCubit>().loadFilterData(
              //           //     model: data,
              //           //     filter: userType);
              //           await controller.loadFilterData(
              //               model: data, filter: 'user');
              //         }
              //       }),
              // ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 32,
          child: ListView.separated(
            itemCount: state.subCategories?.length ?? 0,
            // controller: _scrollController,
            scrollDirection: Axis.horizontal,
            // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 3, childAspectRatio: 1),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsetsDirectional.only(
                  start: index == 0 ? 16.0 : 0,
                    end: index==state.subCategories!.length-1? 16.0: 0,),
                child: ClickableWidget(
                onTap: () async {
                  await controller.changeSubCatIndex(index);
                },
                child: SubCategoryListViewItem(
                  subCategory: state.subCategories?[index],
                ),
                              ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
              width: 8,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: state.status == SubcategoriesStates.loadingAds
              ? const CustomLoading()
              : state.ads == null? const SizedBox() : state.ads!.isEmpty? CustomEmptyWidget(label: LocaleKeys.noAds.localize,):
          Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MarriageAdsListView(
                    scrollController: _scrollController,
                    controller: controller,
                    state: state,
                  ),
              ),
        ),
      ],
    );
  }
}
