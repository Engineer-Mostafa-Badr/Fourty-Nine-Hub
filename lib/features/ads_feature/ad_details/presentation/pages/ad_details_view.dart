import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/constants/subscription_status.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/cubit/ad_details_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/presentation/pages/ad_requests_view.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_details_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_details_prop_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/marriage_call_message_buttons.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/premium_request_button.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/request_button.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/are_you_sure_delete_ad_widget.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/utils/format_numbers.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class AdDetailsView extends StatefulWidget {
  var id;

  AdDetailsView({super.key, payload}) {
    print("objectitemId$payload");
    if (payload is String) {
      id = payload;
    } else {
      print("payloadpayloadpayload $payload");
      // print(id);
      // print('itemId${payload['itemId']}');
      id = payload['itemId'];
    }
  }

  @override
  State<AdDetailsView> createState() => _AdDetailsViewState();
}

class _AdDetailsViewState extends State<AdDetailsView> {
  @override
  void initState() {
    context.read<AdDetailsCubit>().loadData(adId: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userId = serviceLocator<UserCubit>().state.data?.id ?? '';
    print("userId#{$userId}");

    return BlocBuilder<AdDetailsCubit, AdDetailsState>(
      builder: (context, state) {
        if (state.ad == null) {
          return const Center(
            child: CustomCircularProgressIndicator(),
          );
        }
        return CustomScaffold(
          bottomSheet: Container(
            // height: 300.h,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.getReversedTextColor(context),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Label(
                      text: state.ad!.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      color: AppColors.getTextColor(context),
                    ),
                    Label(
                        text: '${FormatNumbers().formatNumberByComma(state.ad!.price.toString(), isArabic: context.isArabic)} ${context.isArabic ? state.ad!.currencyAr : state.ad!.currencyEn}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      color: AppColors.getTextColor(context),),
                    Label(
                        text: state.ad!.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      color: AppColors.getTextColor(context),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(Assets.adsLocationIcon),
                            const SizedBox(
                              width: 4,
                            ),
                            Label(
                              text:
                              context.isArabic ? '${state.ad!.cityAr}, ${state.ad!.governorateAr}' : '${state.ad!.cityEn}, ${state.ad!.governorateEn}',
                              style: Styles.headerText(
                                fontSize: 24,
                                height: 1.60,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),

                      /*    Label(
                            text: (context.isArabic
                                ? state.ad!.subCategoryNameAr
                                : widget.item.subCategoryNameEn) ??
                                'N/A',
                            style: Styles.smallText(
                              color: const Color(0xFFF33D49),
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              height: 1.60,
                            ),
                          ),*/
                      ],
                    ),
                  ],
                ),
                userId == state.ad?.userId
                    ? _buildRequestsButton(state.ad?.id ?? '')
                    : _buildActionsWidget(),
              ],
            ),
          ),
          body: BlocConsumer<AdDetailsCubit, AdDetailsState>(
            listener: (context, state) {
              if (state.isError) {
                showErrorMessage(
                  context,
                  getFailureMessage(
                    state.failure!,
                    context,
                  ),
                );
              } else if (state.isSuccess) {
                showSuccessMessage(context, Labels.success);
              }
            },
            builder: (context, state) {
              if (state.ad == null) {
                return const Center(
                  child: CustomCircularProgressIndicator(),
                );
              }
              List<AdDetailsPropEntity>? details = state.ad?.details
                  .where((e) => e.nameAr != 'الراتب' && e.nameAr != 'السعر')
                  .toList();
              print(
                  "state.ad?.user${context.read<AdDetailsCubit>().state.ad?.user?.id}");
              print("state.ad!.images.length ${state.ad!.images.length}");

              return Stack(
                children: [
                  ListView.separated(
                    itemBuilder: (context, index) => ImageFromInternet(
                      width: double.infinity,
                      height: 300.h,
                      image: state.ad!.images[index],
                      defaultLogo: true,
                      fit: BoxFit.cover,
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 8,
                    ),
                    itemCount: state.ad!.images.length ?? 0,
                    padding: EdgeInsets.zero,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top+8,
                      left: 16,
                      right: 16,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            context.pop();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.getReversedTextColor(context),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.arrow_back,
                              size: 24,
                            ),
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            if (state.ad!.isFavourite == true) {
                              context.read<AdvertisementCubit>().unFavouriteAd(state.ad!.id);
                            } else {
                              context.read<AdvertisementCubit>().favouriteAd(state.ad!.id);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.getReversedTextColor(context),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              state.ad!.isFavourite == true?
                              Icons.favorite:Icons.favorite_border,
                              color: state.ad!.isFavourite == true?
                                  Colors.red:AppColors.getTextColor(context),
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 16),
                  //     child: SizedBox(
                  //       height: 300.h,
                  //       child: ListView(
                  //         children: [
                  //           BuildTagAdsWidget(
                  //             status: state.ad?.subscriptionStatus ?? '',
                  //             views: state.ad?.views ?? 0,
                  //           ),
                  //           // _buildAdInfoWidget(ad: state.ad!),
                  //           const SizedBox(
                  //             height: 16,
                  //           ),
                  //           // اذا كانت الاعلان من نوع زواج
                  //           if (details!.isNotEmpty &&
                  //               state.ad?.mainCategoryId ==
                  //                   '62c8b5b09332225799fe335e')
                  //             _buildDetailsWidget(ad: state.ad!),
                  //           const SizedBox(
                  //             height: 16,
                  //           ),
                  //           _buildRelevantAdsWidget(),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              );
            },
          ),
        );
      },
    );
  }

/*  Widget _buildRelevantAdsWidget() {
    return BlocBuilder<AdDetailsCubit, AdDetailsState>(
        builder: (context, state) {
      if (state.relevantAds?.isEmpty ?? true) {
        return const SizedBox();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            // TODO: translate
            text: 'Relevant Ads', // LocaleKeys.relevantAds.localize,
            style: Styles.headerText(
              fontWeight: FontWeight.w500,
              fontSize: 32,
              color: AppColors.SECONDARY_COLOR_DARK2,
              height: 1.60,
            ),
          ),
          SizedBox(
            height: kToolbarHeight * 3.5,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => AdCard(
                      item: state.relevantAds![index],
                      onFav: (String) {},
                      onRemoveFav: (String) {},
                    ),
                separatorBuilder: (context, index) => const Sizer(),
                itemCount: state.relevantAds?.length ?? 0),
          ),
        ],
      );
    });
  }*/

  Widget _buildRequestsButton(String adId) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 8),
      child: Column(
        children: [
          AppButton(
            height: 38,
            backColor: AppColors.c0B1035,
            onPressed: () async {
              context.push(Routes.ADRequests,
                  extra: AdRequestParams(id: widget.id, userName: ''));
            },
            label: LocaleKeys.showAdRequests.localize,
            style: Styles.headerText(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          AppButton(
            label: LocaleKeys.deleteRequest.localize,
            height: 38,
            backColor: AppColors.SECONDARY_COLOR_DARK2,
            onPressed: () {
              bottomSheet(
                  context: context,
                  isFloating: true,
                  asAlertDialog: true,
                  widget: AreYouSureDeleteAdWidget(
                    title: LocaleKeys.alert.localize,
                    subTitle:
                    LocaleKeys.areYouSureAboutDeletingTheAD.localize,
                    action: () async {
                      showLoadingDialog(context);
                      await context.read<SubcategoriesCubit>().deleteAd(adId);
                      if (!mounted) return;
                      context.pop();
                      context.pop();
                      if (context
                          .read<SubcategoriesCubit>()
                          .state
                          .deleteAdStatus ==
                          SubcategoriesStates.adsSuccess) {
                        context
                            .read<SubcategoriesCubit>()
                            .loadMyAds(id: widget.id);
                        showSuccessMessage(
                            context,
                            context.isArabic
                                ? 'تم حذف اعلانك'
                                : 'Your ad has been deleted');
                        context.pop();
                      }
                      if (context
                          .read<SubcategoriesCubit>()
                          .state
                          .deleteAdStatus ==
                          SubcategoriesStates.error) {
                        showErrorMessage(
                            context,
                            getFailureMessage(
                                context
                                    .read<SubcategoriesCubit>()
                                    .state
                                    .failure ??
                                    UnknownFailure(''),
                                context));
                      }
                    },
                  ));
            },
            style: Styles.headerText(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsWidget() {
    return BlocBuilder<AdDetailsCubit, AdDetailsState>(
        builder: (context, state) {
      return Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: AppButton(
          //           label: LocaleKeys.premiumRequest.localize,
          //           height: 38,
          //           backColor: AppColors.SECONDARY_COLOR_DARK2,
          //           style: Styles.headerText(
          //             fontWeight: FontWeight.w500,
          //             color: Colors.white,
          //             height: 1.60,
          //           ),
          //           onPressed: () {},
          //         ),
          //       ),
          //       SizedBox(
          //         width: 8,
          //       ),
          //       Expanded(
          //         child: AppButton(
          //           label: LocaleKeys.request.localize,
          //           height: 38,
          //           backColor: AppColors.c0B1035,
          //           style: Styles.headerText(
          //             fontWeight: FontWeight.w500,
          //             color: Colors.white,
          //             height: 1.60,
          //           ),
          //           onPressed: () {},
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 8),
            child: Column(
              children: [
                // if (state.ad?.userSubscriptionStatus ==
                //     SubscriptionStatus.notSubscribed.status)
                BlocProvider.value(
                  value: serviceLocator<AdvertisementCubit>(),
                  child: Row(
                    children: [
                      Expanded(
                        child: PremiumRequestButton(
                          adId: state.ad?.id ?? '',
                          subCategoryId: state.ad?.subCategoryId ?? '',
                          subscriptionStatus:
                              state.ad?.userSubscriptionStatus ?? '',
                          dontPop: true,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: RequestButton(
                          adId: state.ad?.id ?? '',
                          subscriptionStatus:
                              state.ad?.userSubscriptionStatus ?? '',
                          dontPop: true,
                          successRequest: () {
                            context.pop();
                            showSuccessMessage(
                                context,
                                context.isArabic
                                    ? 'تم ارسال طلب التواصل'
                                    : 'Request Sent Successfully');
                            context.read<AdvertisementCubit>().resetRequest();
                          },
                          errorRequest: (failure) {
                            context.pop();
                            showSuccessMessage(
                                context,
                                context.isArabic
                                    ? 'تم ارسال طلب التواصل'
                                    : 'Request Sent Successfully');
                            context.read<AdvertisementCubit>().resetRequest();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // AvaialbleTripsButton(
                //   title: LocaleKeys.request.localize,
                //   color: AppColors.SECONDARY_COLOR,
                //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                //   onTap: () {
                //     showModalBottomSheet(
                //       backgroundColor: context.isDarkMode
                //           ? AppColors.DARK_BLUE_COLOR.withValues(alpha:0.95)
                //           : AppColors.LIGHT_COLOR,
                //       context: context,
                //       shape: const RoundedRectangleBorder(
                //         borderRadius: BorderRadius.only(
                //           topLeft: Radius.circular(32.0),
                //           topRight: Radius.circular(32.0),
                //         ),
                //       ),
                //       isDismissible: true,
                //       isScrollControlled: true,
                //       builder: (BuildContext context) {
                //         return BlocProvider.value(
                //           value: serviceLocator<AdvertisementCubit>(),
                //           child: AnimatedPadding(
                //             padding: MediaQuery.of(context).viewInsets,
                //             duration: const Duration(milliseconds: 50),
                //             child: Container(
                //               height: 150.h,
                //               padding: EdgeInsets.symmetric(
                //                 vertical: 10.h,
                //                 horizontal: 10,
                //               ),
                //               child: Row(
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 children: [
                //                   Expanded(
                //                     flex: 3,
                //                     child: PremiumRequestButton(
                //                       adId: state.ad?.id ?? '',
                //                       subCategoryId: state.ad?.subCategoryId ?? '',
                //                       subscriptionStatus:
                //                           state.ad?.subscriptionStatus ?? '',
                //                     ),
                //                   ),
                //                   const Sizer(width: 5),
                //                   Expanded(
                //                     flex: 3,
                //                     child: RequestButton(
                //                         adId: state.ad?.id ?? '',
                //                         subscriptionStatus:
                //                             state.ad?.subscriptionStatus ?? ''),
                //                   )
                //                 ],
                //               ),
                //             ),
                //           ),
                //         );
                //       },
                //     );
                //   },
                // ),
                const SizedBox(
                  height: 8,
                ),
                if (state.ad?.userSubscriptionStatus ==
                    SubscriptionStatus.notSubscribed.status)
                  const SizedBox(
                    height: 16,
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: MarriageCallMessageButtons(
                    otherUserId: state.ad?.userId ?? '',
                    subcategoryId: state.ad?.subCategoryId ?? '',
                    phone: state.ad?.phone ?? '',
                    id: state.ad?.id ?? '',
                    hasReport: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

/*  Widget _buildTag({required String status}) {
    // super premium
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      color: status == 'premium'
          ? Colors.amber.withValues(alpha: .8)
          : status == 'regular'
              ? Colors.grey.withValues(alpha:.8)
              : Colors.grey.withValues(alpha:.8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (status == 'premium' || status == 'regular') ...[
            Icon(
              Icons.workspace_premium_outlined,
              size: 55.w,
              color: status == 'premium'
                  ? AppColors.SECONDARY_COLOR
                  : status == 'regular'
                      ? AppColors.PRIMARY_COLOR
                      : null,
            ),
            const Sizer(width: 5)
          ],
          Label(
            text: status == 'premium'
                ? LocaleKeys.premiumSubscription.localize
                : status == 'regular'
                    ? LocaleKeys.regularRequest.localize
                    : LocaleKeys.notSubscribed.localize,
            style: Styles.mediumText(
                color: Colors.white.withValues(alpha:.8),
                fontSize: 35,
                fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
        ],
      ),
    );
    // premium
    // Regular
  }*/

 /* Widget _buildAdInfoWidget({required AddDetailsModel ad}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(
        //   height: 150,
        //   child: ClipRRect(
        //     borderRadius: BorderRadius.circular(20),
        //     // height: 150,
        //     // decoration: const BoxDecoration(
        //     //     borderRadius: BorderRadius.circular(20)),
        //     child: Swiper(
        //       itemCount: ad.images.length,
        //       onIndexChanged: (i) {},
        //       outer: false,
        //       physics: ad.images.length > 1
        //           ? null
        //           : const NeverScrollableScrollPhysics(),
        //       itemBuilder: (context, index) => InkWell(
        //         onTap: () {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => ImageGalleryPage(
        //                 images: ad.images,
        //                 initialIndex: index,
        //               ),
        //             ),
        //           );
        //         },
        //         child: Padding(
        //           padding: EdgeInsets.only(bottom: 5.h),
        //           child: ImageFromInternet(
        //             image: ad.images[index],
        //             defaultLogo: true,
        //             fit: BoxFit.cover,
        //           ),
        //         ),
        //       ),
        //       pagination: SwiperPagination(
        //           builder: SwiperCustomPagination(builder: (context, config) {
        //         return const DotSwiperPaginationBuilder(
        //                 color: AppColors.GREY_DARK_COLOR,
        //                 activeColor: AppColors.SECONDARY_COLOR,
        //                 size: 10.0,
        //                 activeSize: 10.0)
        //             .build(context, config);
        //       })),
        //     ),
        //   ),
        // ),
        ImageAdsWidget(
          images: ad.images,
          isFavourite: ad.isFavourite ?? false,
          isVerified: true, // ad.isVerified ?? false,
          onPressedFavorite: () async {
            if (ad.isFavourite == false) {
              bool result =
                  await context.read<AdvertisementCubit>().favouriteAd(ad.id);
              if (result == true) {
                ad.isFavourite = true;
              }
            } else if (ad.isFavourite == true) {
              bool result =
                  await context.read<AdvertisementCubit>().unFavouriteAd(ad.id);
              if (result == true) {
                ad.isFavourite = false;
              }
            }
            setState(() {});
            // if (ad.isFavourite == false) {
            //   var result = await widget.onFav(ad.id);
            //   if (result == true) {
            //     ad.isFavourite = !ad.isFavourite!;
            //   }
            // } else {
            //   var result = await widget.onRemoveFav(ad.id);
            //   if (result == true) {
            //     ad.isFavourite = !ad.isFavourite!;
            //   }
            // }
          },
        ),
        // اذا كان الاعلان ليس من نوع زواج
        if (ad.mainCategoryId != '62c8b5b09332225799fe335e')
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     ad.price == 0
              //         ? const Spacer()
              //         : Label(
              //             text:
              //                 '${NumbersHelper.formatThousands(number: ad.price ?? 0)} ${LocaleKeys.currency.localize}',
              //             style: Styles.headerText(
              //               fontWeight: FontWeight.bold,
              //               color: AppColors.SECONDARY_COLOR_DARK2,
              //             ),
              //             maxLines: 1,
              //           ),
              //     Label(
              //       text: ad.formatedDate,
              //       style: Styles.headerText(
              //         fontSize: 32,
              //       ),
              //     ),
              //   ],
              // ),
              Label(
                text: FormatDate().formatDate(
                  ad.createdAt.toString(),
                  isArabic: context.isArabic,
                ),
                style: Styles.mediumText(
                  fontWeight: FontWeight.w600,
                  height: 1.60,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: ShapeDecoration(
                  color: const Color(0x66D9D9D9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Assets.adsCashIcon,
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Label(
                      text:
                          '${FormatNumbers().formatNumberByComma(ad.price.toString(), isArabic: context.isArabic)} ${context.isArabic ? ad.currencyAr : ad.currencyEn}',
                      style: Styles.mediumText(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        height: 1.60,
                        color: const Color(0xFFF33D49),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: ShapeDecoration(
                  color: const Color(0xCCD9D9D9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    Label(
                      text: '${LocaleKeys.title.localize}: ',
                      style: Styles.mediumText(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        height: 1.60,
                        color: const Color(0xFFF33D49),
                      ),
                    ),
                    Label(
                      text: ad.title,
                      style: Styles.mediumText(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        height: 1.60,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              // Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //   decoration: ShapeDecoration(
              //     color: const Color(0x66D9D9D9),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              //   child: Row(
              //     children: [
              //       SvgPicture.asset(
              //         Assets.adsTimeIcon,
              //         height: 24,
              //         width: 24,
              //         colorFilter: ColorFilter.mode(
              //           AppColors.SECONDARY_COLOR_DARK2,
              //           BlendMode.srcIn,
              //         ),
              //       ),
              //       SizedBox(
              //         width: 8,
              //       ),
              //       Label(
              //         text: 'Part Time/on site',
              //         style: Styles.mediumText(
              //           fontSize: 32,
              //           fontWeight: FontWeight.w700,
              //           height: 1.60,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 8,
              // ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: ShapeDecoration(
                  color: const Color(0x66D9D9D9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Assets.adsLocationIcon,
                      height: 24,
                      width: 24,
                      colorFilter: const ColorFilter.mode(
                        AppColors.SECONDARY_COLOR_DARK2,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Label(
                      text:
                          '${context.isArabic ? ad.governorateAr : ad.governorateEn}, ${context.isArabic ? ad.cityAr : ad.cityEn}',
                      style: Styles.mediumText(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        height: 1.60,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: ShapeDecoration(
                  color: const Color(0xCCD9D9D9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                      text: '${LocaleKeys.desc.localize}:',
                      style: Styles.mediumText(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        height: 1.60,
                        color: const Color(0xFFF33D49),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Label(
                      text: ad.description,
                      style: Styles.mediumText(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        height: 1.60,
                      ),
                      overflow: null,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              // اذا كان الاعلان ليس من نوع الزواج
              if (ad.mainCategoryId != '62c8b5b09332225799fe335e') ...[
                // اذا كان الاعلان من نوع عقارات
                if (ad.mainCategoryId == '62c8b5849332225799fe3310') ...[
                  realStatePropsSection(ad),
                  // اذا كان الاعلان من نوع السيارات
                ] else if (ad.mainCategoryId == '62c8b5889332225799fe3316') ...[
                  carsPropsSection(ad)
                  // اذا كان الاعلان من نوع الآلات الموسيقية
                ] else if (ad.mainCategoryId == '62c8b59f9332225799fe333e') ...[
                  Column(
                    children: ad.details.map(
                      (e) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: ShapeDecoration(
                            color: ad.details.indexOf(e) % 2 == 0
                                ? const Color(0x66D9D9D9)
                                : const Color(0xCCD9D9D9),
                            //  const Color(0xCCD9D9D9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Label(
                                text:
                                    '${context.isArabic ? e.nameAr : e.nameEn}: ',
                                style: Styles.mediumText(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                  height: 1.60,
                                ),
                              ),
                              Label(
                                text: context.isArabic ? e.valueAr : e.valueEn,
                                style: Styles.mediumText(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  height: 1.60,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ] else if (ad.mainCategoryId == '62c8b5949332225799fe3328') ...[
                  Column(
                    children: ad.details.map(
                      (e) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: ShapeDecoration(
                            color: ad.details.indexOf(e) % 2 == 0
                                ? const Color(0x66D9D9D9)
                                : const Color(0xCCD9D9D9),
                            //  const Color(0xCCD9D9D9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Label(
                                text:
                                    '${context.isArabic ? e.nameAr : e.nameEn}: ',
                                style: Styles.mediumText(
                                  color: const Color(0xffF33D49),
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                  height: 1.60,
                                ),
                              ),
                              Label(
                                text: context.isArabic ? e.valueAr : e.valueEn,
                                style: Styles.mediumText(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  height: 1.60,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ] else
                  Column(
                    children: ad.details.map(
                      (e) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: ShapeDecoration(
                            color: ad.details.indexOf(e) % 2 == 0
                                ? const Color(0x66D9D9D9)
                                : const Color(0xCCD9D9D9),
                            //  const Color(0xCCD9D9D9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            children: [
                              // اذا كان الاعلان ليس من نوع كمبيوتر\محمول
                              // او يحوانات
                              // او صناعة
                              // او لياقة
                              if (ad.mainCategoryId != '62c8b5979332225799fe3330' &&
                                  ad.mainCategoryId !=
                                      '62c8b5af9332225799fe335a' &&
                                  ad.mainCategoryId !=
                                      '62c8b5879332225799fe3312' &&
                                  ad.mainCategoryId !=
                                      '62c8b5a29332225799fe3348') ...[
                                ImageFromInternet(
                                    image: e.imageUrl, width: 24, height: 24),
                                const SizedBox(
                                  width: 8,
                                ),
                              ],

                              Row(
                                children: [
                                  Label(
                                    text:
                                        '${context.isArabic ? e.nameAr : e.nameEn}: ',
                                    style: Styles.mediumText(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w500,
                                      height: 1.60,
                                      color: AppColors.SECONDARY_COLOR_DARK2,
                                    ),
                                  ),
                                  Label(
                                    text: context.isArabic
                                        ? e.valueAr
                                        : e.valueEn,
                                    style: Styles.mediumText(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                      height: 1.60,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  ),
              ]
              // Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //   decoration: ShapeDecoration(
              //     color: const Color(0xCCD9D9D9),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              //   child: Row(
              //     children: [
              //       SvgPicture.asset(
              //         Assets.adsBagIcon,
              //         height: 24,
              //         width: 24,
              //         colorFilter: ColorFilter.mode(
              //           AppColors.SECONDARY_COLOR_DARK2,
              //           BlendMode.srcIn,
              //         ),
              //       ),
              //       SizedBox(
              //         width: 8,
              //       ),
              //       Row(
              //         children: [
              //           Label(
              //             text: 'Exp level: ',
              //             style: Styles.mediumText(
              //               fontSize: 32,
              //               fontWeight: FontWeight.w500,
              //               height: 1.60,
              //               color: AppColors.SECONDARY_COLOR_DARK2,
              //             ),
              //           ),
              //           Label(
              //             text: '1 Year',
              //             style: Styles.mediumText(
              //               fontSize: 32,
              //               fontWeight: FontWeight.w600,
              //               height: 1.60,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 8,
              // ),
              // Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //   decoration: ShapeDecoration(
              //     color: const Color(0x66D9D9D9),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              //   child: Row(
              //     children: [
              //       SvgPicture.asset(
              //         Assets.adsEducationIcon,
              //         height: 24,
              //         width: 24,
              //         colorFilter: ColorFilter.mode(
              //           AppColors.SECONDARY_COLOR_DARK2,
              //           BlendMode.srcIn,
              //         ),
              //       ),
              //       SizedBox(
              //         width: 8,
              //       ),
              //       Row(
              //         children: [
              //           Label(
              //             text: 'Edu level: ',
              //             style: Styles.mediumText(
              //               fontSize: 32,
              //               fontWeight: FontWeight.w500,
              //               height: 1.60,
              //               color: AppColors.SECONDARY_COLOR_DARK2,
              //             ),
              //           ),
              //           Label(
              //             text: 'Diploma',
              //             style: Styles.mediumText(
              //               fontSize: 32,
              //               fontWeight: FontWeight.w600,
              //               height: 1.60,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // // LableAndTextMarriageDetails(
              //   lable: LocaleKeys.title.localize,
              //   text: ad.title,
              // ),
              // const SizedBox(
              //   height: 4,
              // ),
              // LableAndTextMarriageDetails(
              //   lable: LocaleKeys.governorate.localize,
              //   text: context.isArabic
              //       ? ad.governorateAr ?? ''
              //       : ad.governorateEn ?? '',
              // ),
              // const SizedBox(
              //   height: 4,
              // ),
              // LableAndTextMarriageDetails(
              //   lable: LocaleKeys.city.localize,
              //   text: context.isArabic ? ad.cityAr ?? '' : ad.cityEn ?? '',
              // ),
              // const SizedBox(
              //   height: 4,
              // ),
              // LableAndTextMarriageDetails(
              //   lable: LocaleKeys.desc.localize,
              //   text: ad.description,
              // ),
              // Label(
              //   text: "${LocaleKeys.desc.localize}: ",
              //   style: Styles.mediumText(
              //       fontWeight: FontWeight.bold,
              //       color: AppColors.SECONDARY_COLOR),
              // ),
              // Label(text: ad.description),
            ],
          )
        else
          Column(
            spacing: 4,
            children: [
              Row(
                children: [
                  Label(
                    text: '${LocaleKeys.name.localize}: ',
                    style: Styles.headerText(
                      color: const Color(0xFFF33D49),
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      height: 1.60,
                    ),
                  ),
                  Label(
                    text: ad.title,
                    style: Styles.headerText(
                      fontSize: 32,
                      height: 1.60,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Label(
                    text: '${LocaleKeys.governorate.localize}: ',
                    style: Styles.headerText(
                      color: const Color(0xFFF33D49),
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      height: 1.60,
                    ),
                  ),
                  Label(
                    text: context.isArabic
                        ? ad.governorateAr ?? ''
                        : ad.governorateEn ?? '',
                    style: Styles.headerText(
                      fontSize: 32,
                      height: 1.60,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Label(
                    text: '${LocaleKeys.city.localize}: ',
                    style: Styles.headerText(
                      color: const Color(0xFFF33D49),
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      height: 1.60,
                    ),
                  ),
                  Label(
                    text: context.isArabic ? ad.cityAr ?? '' : ad.cityEn ?? '',
                    style: Styles.headerText(
                      fontSize: 32,
                      height: 1.60,
                    ),
                  ),
                ],
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${LocaleKeys.desc.localize}: ',
                      style: Styles.headerText(
                        color: const Color(0xFFF33D49),
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        height: 1.60,
                      ),
                    ),
                    TextSpan(
                      text: ad.description,
                      style: Styles.headerText(
                        fontSize: 32,
                        height: 1.60,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }*/

  Widget carsPropsSection(AddDetailsModel ad) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: ShapeDecoration(
            color: const Color(0x66D9D9D9),
            //  const Color(0xCCD9D9D9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ad.details
                .where((p) =>
                    p.id ==
                        '66ec666f12cfcdf9779dfcc6' /* ده بتاع نوع الوقود*/ ||
                    p.id ==
                        '66ec666f12cfcdf9779dfd05' /* ده بتاع الكيلومترات*/ ||
                    p.id == '66ec666f12cfcdf9779dfcc5' /* ده بتاع السنة*/)
                .map((p) {
              return Expanded(
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageFromInternet(
                      image: p.imageUrl,
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    SizedBox(
                      width: (MediaQuery.sizeOf(context).width - 132) / 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Label(
                              text: context.isArabic ? p.nameAr : p.nameEn,
                              style: Styles.mediumText(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                height: 1.60,
                              ),
                            ),
                          ),
                          Label(
                            text: context.isArabic ? p.valueAr : p.valueEn,
                            style: Styles.mediumText(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              height: 1.60,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: ShapeDecoration(
            color: const Color(0xCCD9D9D9),
            //  const Color(0x66D9D9D9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ad.details
                .where((p) =>
                    p.id ==
                        '66ec666f12cfcdf9779dfccc' /* ده بتاع نوع ناقل الحركة*/ ||
                    p.id == '66ec666f12cfcdf9779dfcc1' /* ده بتاع الحالة*/ ||
                    p.id == '66ec666f12cfcdf9779dfcc0' /* ده بتاع الاصدار*/)
                .map((p) {
              return Expanded(
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageFromInternet(
                      image: p.imageUrl,
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    SizedBox(
                      width: (MediaQuery.sizeOf(context).width - 132) / 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Label(
                              text: context.isArabic ? p.nameAr : p.nameEn,
                              style: Styles.mediumText(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                height: 1.60,
                              ),
                            ),
                          ),
                          Label(
                            text: context.isArabic ? p.valueAr : p.valueEn,
                            style: Styles.mediumText(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              height: 1.60,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        Column(
          children: ad.details
              .where((p) => ![
                    '66ec666f12cfcdf9779dfcc6',
                    '66ec666f12cfcdf9779dfd05',
                    '66ec666f12cfcdf9779dfcc5',
                    '66ec666f12cfcdf9779dfccc',
                    '66ec666f12cfcdf9779dfcc1',
                    '66ec666f12cfcdf9779dfcc0',
                  ].contains(p.id))
              .toList()
              .asMap()
              .entries
              .map((entry) {
            final i = entry.key;
            final e = entry.value;
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: ShapeDecoration(
                color: i % 2 == 0
                    ? const Color(0x66D9D9D9)
                    : const Color(0xCCD9D9D9),
                //  const Color(0xCCD9D9D9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Label(
                    text: '${context.isArabic ? e.nameAr : e.nameEn}: ',
                    style: Styles.mediumText(
                      fontWeight: FontWeight.w500,
                      height: 1.60,
                    ),
                  ),
                  Spacer(),
                  Label(
                    text: context.isArabic ? e.valueAr : e.valueEn,
                    style: Styles.mediumText(
                      fontWeight: FontWeight.w600,
                      height: 1.60,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Column realStatePropsSection(AddDetailsModel ad) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: ShapeDecoration(
            color: const Color(0x66D9D9D9),
            //  const Color(0xCCD9D9D9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ad.details
                .where((p) =>
                    p.id == '62c8b5849332225799fe3310' /* ده بتاع المساحة*/)
                .map((p) {
              return Expanded(
                child: Row(
                  children: [
                    ImageFromInternet(
                      image: p.imageUrl,
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Label(
                              text: context.isArabic ? p.nameAr : p.nameEn,
                              style: Styles.mediumText(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                height: 1.60,
                              ),
                            ),
                          ),
                          Label(
                            text: context.isArabic ? p.valueAr : p.valueEn,
                            style: Styles.mediumText(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              height: 1.60,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: ShapeDecoration(
            color: const Color(0xCCD9D9D9),
            //  const Color(0xCCD9D9D9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ad.details
                .where((p) =>
                    p.id == '62c8b5849332225799fe3311' /* ده بتاع الملكية*/)
                .map((p) {
              return Expanded(
                child: Row(
                  children: [
                    ImageFromInternet(
                      image: p.imageUrl,
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Label(
                              text: context.isArabic ? p.nameAr : p.nameEn,
                              style: Styles.mediumText(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                height: 1.60,
                              ),
                            ),
                          ),
                          Label(
                            text: context.isArabic ? p.valueAr : p.valueEn,
                            style: Styles.mediumText(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              height: 1.60,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        Column(
          children: ad.details
              .where((p) => ![
                    '62c8b5849332225799fe3310',
                    '62c8b5849332225799fe3311'
                  ].contains(p.id))
              .map((e) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: ShapeDecoration(
                color: ad.details.indexOf(e) % 2 == 0
                    ? const Color(0x66D9D9D9)
                    : const Color(0xCCD9D9D9),
                //  const Color(0xCCD9D9D9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Label(
                    text: '${context.isArabic ? e.nameAr : e.nameEn}: ',
                    style: Styles.mediumText(
                      fontWeight: FontWeight.w500,
                      height: 1.60,
                    ),
                  ),
                  Spacer(),
                  Label(
                    text: context.isArabic ? e.valueAr : e.valueEn,
                    style: Styles.mediumText(
                      fontWeight: FontWeight.w600,
                      height: 1.60,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /*Widget _buildDetailsWidget({required AddDetailsModel ad}) {
    List<AdDetailsPropEntity>? details = ad.details
        .where((e) => e.nameAr != 'الراتب' && e.nameAr != 'السعر')
        .toList();

    // List<DetailEntiy> details = ad.details.where((e) => e.label!='المرتب'&&e.label!='Salary'&&e.label!='price'&&e.label!='Price '&&e.label!='السعر ').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
        //   child: Label(
        //     text: LocaleKeys.details.localize,
        //     style: Styles.mediumText(fontWeight: FontWeight.bold),
        //   ),
        // ),
        Row(
          children: details.take(3).map((e) {
            return Padding(
              padding: const EdgeInsetsDirectional.only(end: 16),
              child: LableAndTextMarriageDetails(
                lable: context.isArabic ? e.nameAr : e.nameEn,
                text: context.isArabic ? e.valueAr : e.valueEn,
              ),
            );
          }).toList(),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: details.skip(3).take(2).map((e) {
            return Padding(
              padding: const EdgeInsetsDirectional.only(end: 24),
              child: LableAndTextMarriageDetails(
                lable: context.isArabic ? e.nameAr : e.nameEn,
                text: context.isArabic ? e.valueAr : e.valueEn,
              ),
            );
          }).toList(),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: details.skip(5).take(2).map((e) {
            return Padding(
              padding: const EdgeInsetsDirectional.only(end: 24),
              child: LableAndTextMarriageDetails(
                lable: context.isArabic ? e.nameAr : e.nameEn,
                text: context.isArabic ? e.valueAr : e.valueEn,
              ),
            );
          }).toList(),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: details.skip(7).take(2).map((e) {
            return Padding(
              padding: const EdgeInsetsDirectional.only(end: 24),
              child: LableAndTextMarriageDetails(
                lable: context.isArabic ? e.nameAr : e.nameEn,
                text: context.isArabic ? e.valueAr : e.valueEn,
              ),
            );
          }).toList(),
        ),
        const SizedBox(
          height: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: details.skip(9).map((e) {
            return LableAndTextMarriageDetails(
              lable: context.isArabic ? e.nameAr : e.nameEn,
              text: context.isArabic ? e.valueAr : e.valueEn,
            );
          }).toList(),
        ),
        // GridView.builder(
        //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 2,
        //     childAspectRatio: 2,
        //     crossAxisSpacing: 10,
        //     mainAxisSpacing: 10,
        //     mainAxisExtent: 25,
        //   ),
        //   shrinkWrap: true,
        //   physics: const NeverScrollableScrollPhysics(),
        //   itemCount: details.length - 3,
        //   itemBuilder: (context, index) {
        //     final detail = details[index + 3];
        //     return LableAndTextMarriageDetails(
        //       lable: context.isArabic ? detail.nameAr : detail.nameEn,
        //       text: context.isArabic ? detail.valueAr : detail.valueEn,
        //     );
        //   },
        // ),
        // ListView.builder(
        //     itemCount: details.length,
        //     shrinkWrap: true,
        //     physics: const NeverScrollableScrollPhysics(),
        //     itemBuilder: (context, index) {
        //       final detail = details[index];
        //       return Container(
        //         padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
        //         decoration: BoxDecoration(
        //             color: index.isEven
        //                 ? AppColors.LIGHT_GRAY_COLOR
        //                 : Colors.white),
        //         child: Row(
        //           children: [
        //             Expanded(
        //                 child: Label(
        //                     text:
        //                         "${getLang() == 'ar' ? detail.nameAr : detail.nameEn} : ",
        //                     style: Styles.mediumText(
        //                         fontWeight: FontWeight.bold,
        //                         color: AppColors.SECONDARY_COLOR))),
        //             Expanded(
        //                 child: Label(
        //               text: getLang() == 'ar' ? detail.valueAr : detail.valueEn,
        //               style: const TextStyle(
        //                 color: AppColors.DARK_BLUE_COLOR,
        //               ),
        //             )),
        //           ],
        //         ),
        //       );
        //     }),
      ],
    );
  }*/
}
