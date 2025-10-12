
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/auth_helper.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/custom_floating_button_ads.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/marriage_ads_view_body.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/floating_add_button.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../../core/widget/custom_scaffold.dart';

class MarriageSubCategoriesView extends StatefulWidget {
  // final MainCategoryEntity mainCategory;
  final bool inGridView;

  const MarriageSubCategoriesView({
    super.key,
    // required this.mainCategory,
    this.inGridView = false,
  });

  @override
  State<MarriageSubCategoriesView> createState() =>
      _MarriageSubCategoriesViewState();
}

class _MarriageSubCategoriesViewState extends State<MarriageSubCategoriesView> {
  late ScrollController _scrollController;
  bool _isFabVisible = true;

  @override
  void initState() {
    context
        .read<SubcategoriesCubit>()
        .loadInitialData(subCategoryId: '62c8b5b09332225799fe335e');
    _scrollController = ScrollController()..addListener(_onScroll);

    super.initState();
  }

  void _onScroll() {
    // if (_scrollController.position.pixels >=
    //     _scrollController.position.maxScrollExtent) {
    //   context.read<SubcategoriesCubit>().filterAds(
    //       model: context.read<SubcategoriesCubit>().state.filterModel!,
    //       filter: '');
    // }
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isFabVisible) {
        setState(() => _isFabVisible = false);
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isFabVisible) {
        setState(() => _isFabVisible = true);
      }
    }
  }

  // bool _isFilterApplied = false;
  //
  // Future<void> _applyFilter(
  //     BuildContext context, SubcategoriesCubit controller) async {
  //   if (_isFilterApplied) return; // Prevent duplicate execution
  //   _isFilterApplied = true;
  //
  //   dynamic data = await context.push(
  //     Routes.GOVERNORATEFILTERADS,
  //     extra: CategorizationEntity(
  //       mainCategory: controller.state.mainCategory!,
  //       subCategory: controller.state.subCategories![controller
  //               .state.subCategories!
  //               .indexWhere((element) => element.isSelected == true) ??
  //           0],
  //     ),
  //   );
  //
  //   if (data != null) {
  //     controller.state.city = data.cityId;
  //     controller.state.governorate = data.governorateId;
  //     controller.changeFilterModel(data);
  //     await controller.loadFilterData(model: data, filter: 'user');
  //   }
  //
  //   _isFilterApplied = false; // Reset the flag
  // }
  bool _showFloatingButton = true;
  void _onScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo is UserScrollNotification) {
      if (scrollInfo.direction == ScrollDirection.reverse) {
        if (_showFloatingButton) {
          setState(() {
            _showFloatingButton = false;
          });
        }
      } else if (scrollInfo.direction == ScrollDirection.forward) {
        if (!_showFloatingButton) {
          setState(() {
            _showFloatingButton = true;
          });
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubcategoriesCubit, SubcategoriesState>(
        builder: (context, state) {
      var controller = context.read<SubcategoriesCubit>();
      // if (state.isLoadingAds) {
      //   return Container(
      //     color: Theme.of(context).scaffoldBackgroundColor,
      //     width: double.infinity,
      //     height: double.infinity,
      //     child: const CustomLoading(),
      //   );
      // }

      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          _onScrollNotification(scrollInfo);
          return false;
        },
        child: CustomScaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: BackAppBar(
              label: context.isArabic ? 'زواج' : 'Marriage',
            ),
          ),
          floatingActionButton: _showFloatingButton && state.subCategories != null && state.subCategories!.isNotEmpty
              ? buildFloatingAction(context,title:
          "${LocaleKeys.add.localize} ${LocaleKeys.ad.localize} ${context.isArabic ? (context.read<SubcategoriesCubit>().state.subCategories?[context.read<SubcategoriesCubit>().state.subCategories?.indexWhere((element) => element.isSelected == true) ?? 0].nameAr ?? '') : context.read<SubcategoriesCubit>().state.subCategories?[context.read<SubcategoriesCubit>().state.subCategories?.indexWhere((element) => element.isSelected == true) ?? 0].nameEn ?? ''}",
                  () {
                    ManageVibration.vibrate();
                    if (AuthHelper().isLoggedIn()) {
                      context.push(
                        Routes.CREATEAD,
                        extra: CategorizationEntity(
                          mainCategory: state.mainCategory!,
                          // mainCategory: widget.mainCategory,
                          subCategory: state.subCategories![
                          state.subCategories?.indexWhere((element) =>
                          element.isSelected == true) ??
                              0],
                          fromMarriage: true,
                        ),
                      );
                    } else {
                      return pleaseLoginDialog(context);
                      // context.push(Routes.LOGIN);
                    }
          })
              : null,
          // floatingActionButton: AnimatedSlide(
          //   duration: const Duration(milliseconds: 300),
          //   offset: _isFabVisible ? Offset.zero : const Offset(0, 2),
          //   child: AnimatedOpacity(
          //       duration: const Duration(milliseconds: 300),
          //       opacity: _isFabVisible ? 1 : 0,
          //       child: state.isLoading
          //           ? null
          //           : CustomFloatingButtonAds(
          //               title:
          //                   "${LocaleKeys.add.localize} ${LocaleKeys.ad.localize} ${context.isArabic ? (context.read<SubcategoriesCubit>().state.subCategories?[context.read<SubcategoriesCubit>().state.subCategories?.indexWhere((element) => element.isSelected == true) ?? 0].nameAr ?? '') : context.read<SubcategoriesCubit>().state.subCategories?[context.read<SubcategoriesCubit>().state.subCategories?.indexWhere((element) => element.isSelected == true) ?? 0].nameEn ?? ''}",
          //               onPressed: () {
          //                 ManageVibration.vibrate();
          //                 if (AuthHelper().isLoggedIn()) {
          //                   context.push(
          //                     Routes.CREATEAD,
          //                     extra: CategorizationEntity(
          //                       mainCategory: state.mainCategory!,
          //                       // mainCategory: widget.mainCategory,
          //                       subCategory: state.subCategories![
          //                           state.subCategories?.indexWhere((element) =>
          //                                   element.isSelected == true) ??
          //                               0],
          //                       fromMarriage: true,
          //                     ),
          //                   );
          //                 } else {
          //                   return pleaseLoginDialog(context);
          //                   // context.push(Routes.LOGIN);
          //                 }
          //               },
          //             )),
          // ),
          body: state.isLoading || state.subCategories == null || state.subCategories!.isEmpty
              ? CustomLoadingSearchWidget()
              : MarriageAdsViewBody(
                  controller: controller,
                  state: state,
                  scrollController: _scrollController,
                ),
        ),
      );
      // if (widget.inGridView) {
      //   return Scaffold(
      //     floatingActionButton: CustomFloatingActionButton(
      //       onPressed: () {
      //         if (AuthHelper().isLoggedIn()) {
      //           context.push(Routes.CREATEAD,
      //               extra: CategorizationEntity(
      //                   mainCategory: state.mainCategory!,
      //                   // mainCategory: widget.mainCategory,
      //                   subCategory: state.subCategories![state.subCategories
      //                           ?.indexWhere(
      //                               (element) => element.isSelected == true) ??
      //                       0],
      //                   fromMarriage: true));
      //         } else {
      //           context.push(Routes.LOGIN);
      //         }
      //       },
      //       text:
      //           "${LocaleKeys.add.localize} ${LocaleKeys.ad.localize} ${context.isArabic ? "${context.read<SubcategoriesCubit>().state.subCategories?[context.read<SubcategoriesCubit>().state.subCategories?.indexWhere((element) => element.isSelected == true) ?? 0].nameAr}" : "${context.read<SubcategoriesCubit>().state.subCategories?[context.read<SubcategoriesCubit>().state.subCategories?.indexWhere((element) => element.isSelected == true) ?? 0].nameEn}"}",
      //     ),
      //     body: Padding(
      //       padding: EdgeInsets.all(16.0.w),
      //       child: Column(
      //         children: [
      //           Container(
      //               margin: EdgeInsetsDirectional.all(10.w),
      //               child: Row(
      //                 children: [
      //                   Expanded(
      //                     child: BadgedLabel(
      //                         label: LocaleKeys.filter.localize,
      //                         width: 170.h,
      //                         padding: EdgeInsets.symmetric(
      //                             vertical: 15.h, horizontal: 5.w),
      //                         icon: Icons.filter_alt_rounded,
      //                         iconLeading: Icons.arrow_drop_down,
      //                         onTap: () async {
      //                           dynamic data = await context.push(
      //                               Routes.FILTERADS,
      //                               extra: CategorizationEntity(
      //                                 mainCategory: state.mainCategory!,
      //                                 fromMarriage: true,
      //                                 subCategory: state.subCategories![state
      //                                         .subCategories
      //                                         ?.indexWhere((element) =>
      //                                             element.isSelected == true) ??
      //                                     0],
      //                               ));
      //                           print("data::: $data");
      //                           if (data != null) {
      //                             print("objectsdaa");
      //                             controller.changeFilterModel(data);
      //                             controller.loadFilterData(
      //                                 model: data, filter: 'user');
      //                           }
      //                         }),
      //                   ),
      //                   const Sizer(
      //                     width: 5,
      //                   ),
      //                   Expanded(
      //                     child: BadgedLabel(
      //                         label: LocaleKeys.city.localize,
      //                         width: 170.h,
      //                         icon: Icons.filter_alt_rounded,
      //                         padding: EdgeInsets.symmetric(
      //                             vertical: 15.h, horizontal: 5.w),
      //                         iconLeading: Icons.arrow_drop_down,
      //                         onTap: () async {
      //                           dynamic data = await context.push(
      //                               Routes.GOVERNORATEFILTERADS,
      //                               extra: CategorizationEntity(
      //                                   mainCategory: state.mainCategory!,
      //                                   fromMarriage: true,
      //                                   subCategory: state.subCategories![state
      //                                           .subCategories
      //                                           ?.indexWhere((element) =>
      //                                               element.isSelected ==
      //                                               true) ??
      //                                       0]));
      //                           if (data != null) {
      //                             print("data.cityId${data.cityId}");
      //                             print(
      //                                 "data.governorateId${data.governorateId}");
      //                             print("objectsdaa");
      //                             controller.state.city = data.cityId;
      //                             controller.state.governorate =
      //                                 data.governorateId;
      //                             controller.changeFilterModel(data);
      //                             // FilterModel model = FilterModel(
      //                             //     cityId: "state.city",
      //                             //     governorateId: "state.governorate");
      //                             // Future.delayed(const Duration(seconds: 1), () =>
      //                             //     controller.changeState(data, data != null));
      //                             // context.read<AdvertisementCubit>().loadFilterData(
      //                             //     model: data,
      //                             //     filter: userType);
      //                             await controller.loadFilterData(
      //                                 model: data, filter: 'user');
      //                           }
      //                         }),
      //                   ),
      //                 ],
      //               )),
      //           const Sizer(
      //             height: 40,
      //           ),
      //           SizedBox(
      //             height: 50.h,
      //             child: ListView.separated(
      //               itemCount: state.subCategories?.length ?? 0,
      //               // controller: _scrollController,
      //               scrollDirection: Axis.horizontal,
      //               // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //               //     crossAxisCount: 3, childAspectRatio: 1),
      //               itemBuilder: (context, index) => ClickableWidget(
      //                 onTap: () async {
      //                   await controller.changeSubCatIndex(index);
      //                 },
      //                 child: Container(
      //                   alignment: AlignmentDirectional.center,
      //                   padding: EdgeInsets.all(6.w),
      //                   margin: EdgeInsets.all(2.w),
      //                   width: 280.w,
      //                   decoration: BoxDecoration(
      //                     color: state.subCategories?[index].isSelected == true
      //                         ? AppColors.PRIMARY_COLOR
      //                         : Theme.of(context).scaffoldBackgroundColor,
      //                     borderRadius: BorderRadius.circular(15.r),
      //                     boxShadow: const [
      //                       BoxShadow(
      //                         color: Color.fromARGB(255, 249, 159, 162),
      //                         spreadRadius: 1,
      //                         blurRadius: 1,
      //                         offset: Offset(1, 1),
      //                       )
      //                     ],
      //                   ),
      //                   child: Label(
      //                     text: context.isArabic
      //                         ? (state.subCategories?[index].nameAr ?? '')
      //                         : (state.subCategories?[index].nameEn ?? ''),
      //                     color: state.subCategories?[index].isSelected == true
      //                         ? Colors.white
      //                         : null,
      //                   ),
      //                 ),
      //               ),
      //               separatorBuilder: (BuildContext context, int index) =>
      //                   const Sizer(
      //                 width: 30,
      //               ),
      //             ),
      //           ),
      //           const Sizer(
      //             height: 40,
      //           ),
      //           Expanded(
      //             child: state.status == SubcategoriesStates.loadingAds
      //                 ? const Center(
      //                     child: CustomCircularProgressIndicator(),
      //                   )
      //                 : ListView.builder(
      //                     controller: _scrollController,
      //                     itemCount: state.ads?.length??0,
      //                     physics: const BouncingScrollPhysics(),
      //                     itemBuilder: (context, index) => ClickableWidget(
      //                           onTap: () {
      //                             context.push(Routes.ADdetails,
      //                                 extra: state.ads?[index].id);
      //                           },
      //                           child: Container(
      //                             margin: EdgeInsets.only(bottom: 20.h),
      //                             padding: EdgeInsets.all(16.w),
      //                             decoration: BoxDecoration(
      //                               color: Theme.of(context)
      //                                   .scaffoldBackgroundColor,
      //                               borderRadius: BorderRadius.circular(20.r),
      //                               // border: Border.all(color: AppColors.PRIMARY_COLOR),
      //                             ),
      //                             child: Column(
      //                                 crossAxisAlignment:
      //                                     CrossAxisAlignment.start,
      //                                 children: [
      //                                   Row(
      //                                     children: [
      //                                       ImageFromInternet(
      //                                         image: state.ads![index]
      //                                             .images
      //                                             .first,
      //                                         height: 80.h,
      //                                         width: 80.w,
      //                                         isCircle: true,
      //                                       ),
      //                                       const Sizer(
      //                                         width: 15,
      //                                       ),
      //                                       Label(
      //                                           text: state.ads![index].title)
      //                                     ],
      //                                   ),
      //                                   const Sizer(),
      //                                   Label(
      //                                       text: state.ads![index]
      //                                           .description),
      //                                   const Sizer(),
      //                                   Row(
      //                                     crossAxisAlignment:
      //                                         CrossAxisAlignment.center,
      //                                     children: [
      //                                       // Expanded(
      //                                       //   flex: 3,
      //                                       //   child: BlocProvider(
      //                                       //     create: (BuildContext context) =>serviceLocator<AdvertisementCubit>(),
      //                                       //     child: PremiumRequestButton(
      //                                       //       adId: controller.marriageAds[index].id,
      //                                       //       subCategoryId:
      //                                       //       controller.marriageAds[index].subCategoryId ?? '',
      //                                       //       subscriptionStatus:
      //                                       //       controller.marriageAds[index].subscriptionStatus ?? '',
      //                                       //     ),
      //                                       //   ),
      //                                       // ),
      //
      //                                       AvaialbleTripsButton(
      //                                         title:
      //                                             LocaleKeys.request.localize,
      //                                         color: AppColors.SECONDARY_COLOR,
      //                                         padding:
      //                                             const EdgeInsets.symmetric(
      //                                                 horizontal: 15,
      //                                                 vertical: 5),
      //                                         onTap: () {
      //                                           showModalBottomSheet(
      //                                             backgroundColor: context
      //                                                     .isDarkMode
      //                                                 ? AppColors
      //                                                     .DARK_BLUE_COLOR
      //                                                     .withValues(
      //                                                         alpha: 0.95)
      //                                                 : AppColors.LIGHT_COLOR,
      //                                             context: context,
      //                                             shape:
      //                                                 const RoundedRectangleBorder(
      //                                               borderRadius:
      //                                                   BorderRadius.only(
      //                                                 topLeft:
      //                                                     Radius.circular(32.0),
      //                                                 topRight:
      //                                                     Radius.circular(32.0),
      //                                               ),
      //                                             ),
      //                                             isDismissible: true,
      //                                             isScrollControlled: true,
      //                                             builder:
      //                                                 (BuildContext context) {
      //                                               return BlocProvider.value(
      //                                                 value: serviceLocator<
      //                                                     AdvertisementCubit>(),
      //                                                 child: AnimatedPadding(
      //                                                   padding: MediaQuery.of(
      //                                                           context)
      //                                                       .viewInsets,
      //                                                   duration:
      //                                                       const Duration(
      //                                                           milliseconds:
      //                                                               50),
      //                                                   child: Container(
      //                                                     height: 150.h,
      //                                                     padding: EdgeInsets
      //                                                         .symmetric(
      //                                                       vertical: 10.h,
      //                                                       horizontal: 10,
      //                                                     ),
      //                                                     child: Row(
      //                                                       crossAxisAlignment:
      //                                                           CrossAxisAlignment
      //                                                               .center,
      //                                                       children: [
      //                                                         Expanded(
      //                                                           flex: 3,
      //                                                           child:
      //                                                               PremiumRequestButton(
      //                                                             adId: state.ads![
      //                                                                     index]
      //                                                                 .id,
      //                                                             subCategoryId:
      //                                                             state.ads![index]
      //                                                                         .subCategoryId ??
      //                                                                     '',
      //                                                             subscriptionStatus:
      //                                                             state.ads![index]
      //                                                                         .subscriptionStatus ??
      //                                                                     '',
      //                                                           ),
      //                                                         ),
      //                                                         const Sizer(
      //                                                             width: 5),
      //                                                         Expanded(
      //                                                           flex: 3,
      //                                                           child:
      //                                                               RequestButton(
      //                                                             adId: state.ads![
      //                                                                     index]
      //                                                                 .id,
      //                                                             subscriptionStatus:
      //                                                             state.ads![index]
      //                                                                         .subscriptionStatus ??
      //                                                                     '',
      //                                                           ),
      //                                                         )
      //                                                       ],
      //                                                     ),
      //                                                   ),
      //                                                 ),
      //                                               );
      //                                             },
      //                                           );
      //                                         },
      //                                       ),
      //
      //                                       Expanded(
      //                                         child: CallMessageButtons(
      //                                           otherUserId: state.ads![index]
      //                                                   .userId ??
      //                                               '',
      //                                           subcategoryId: state
      //                                                   .subCategories?[state
      //                                                           .subCategories
      //                                                           ?.indexWhere(
      //                                                               (element) =>
      //                                                                   element
      //                                                                       .isSelected ==
      //                                                                   true) ??
      //                                                       0]
      //                                                   .id ??
      //                                               '',
      //                                           phone: state.ads![index]
      //                                                   .phone ??
      //                                               '',
      //                                           id: state.ads![index].id,
      //                                           hasReport: true,
      //                                         ),
      //                                       ),
      //                                     ],
      //                                   ),
      //                                   const Sizer(),
      //                                 ]),
      //                           ),
      //                         )),
      //           )
      //         ],
      //       ),
      //     ),
      //   );
      // }
      // else {
    });
  }
}
