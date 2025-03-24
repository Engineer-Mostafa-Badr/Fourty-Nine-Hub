import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/constants/subscription_status.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/cubit/ad_details_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/pages/image_gallary_viewer.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/pages/widgets/lable_and_text_marriage_details.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/presentation/pages/ad_requests_view.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_details_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_details_prop_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/ad_card.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/marriage_call_message_buttons.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/premium_request_button.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/request_button.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/widget/custom_scaffold.dart';
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
    print("userId#{$userId");

    return CustomScaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        body: BlocConsumer<AdDetailsCubit, AdDetailsState>(
            listener: (contex, state) {
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
        }, builder: (context, state) {
          if (state.ad == null) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          List<AdDetailsPropEntity>? details = state.ad?.details
              .where((e) => e.nameAr != 'الراتب' && e.nameAr != 'السعر')
              .toList();
          print(
              "state.ad?.user${context.read<AdDetailsCubit>().state.ad?.user?.id}");

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView(
                        children: [
                          _buildAdInfoWidget(ad: state.ad!),
                          const SizedBox(
                            height: 16,
                          ),
                          if (details!.isNotEmpty)
                            _buildDetailsWidget(ad: state.ad!),
                          const SizedBox(
                            height: 16,
                          ),
                          _buildRelevantAdsWidget(),
                        ],
                      ),
                    ),
                  ),
                  userId == state.ad?.userId
                      ? _buildRequestsButton()
                      : _buildActionsWidget(),
                ],
              ),
              if (context.read<UserCubit>().isLoggedIn)
                _buildTag(status: state.ad?.subscriptionStatus ?? ''),
            ],
          );
        }));
  }

  Widget _buildRelevantAdsWidget() {
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
  }

  Widget _buildRequestsButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 8),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              height: 38,
              backColor: AppColors.SECONDARY_COLOR_DARK2,
              onPressed: () async {
                context.push(Routes.ADRequests,
                    extra: AdRequestParams(id: widget.id, userName: ''));
              },
              label: LocaleKeys.deleteRequest.localize,
              style: Styles.headerText(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: AppButton(
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
          ),
        ],
      ),
    );
  }

  Widget _buildActionsWidget() {
    return BlocBuilder<AdDetailsCubit, AdDetailsState>(
        builder: (context, state) {
      return Container(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 8),
        child: Column(
          children: [
            if (state.ad?.userSubscriptionStatus ==
                SubscriptionStatus.notSubscribed.status)
              BlocProvider.value(
                value: serviceLocator<AdvertisementCubit>(),
                child: Row(
                  children: [
                    Expanded(
                      child: PremiumRequestButton(
                        adId: state.ad?.id ?? '',
                        subCategoryId: state.ad?.subCategoryId ?? '',
                        subscriptionStatus: state.ad?.subscriptionStatus ?? '',
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: RequestButton(
                        adId: state.ad?.id ?? '',
                        subscriptionStatus: state.ad?.subscriptionStatus ?? '',
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
            //           ? AppColors.DARK_BLUE_COLOR.withOpacity(0.95)
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
      );
    });
  }

  Widget _buildTag({required String status}) {
    // super premium
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      color: status == 'premium'
          ? Colors.amber.withOpacity(.8)
          : status == 'regular'
              ? Colors.grey.withOpacity(.8)
              : Colors.grey.withOpacity(.8),
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
                color: Colors.white.withOpacity(.8),
                fontSize: 35,
                fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
        ],
      ),
    );
    // premium
    // Regular
  }

  Widget _buildAdInfoWidget({required AddDetailsModel ad}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            // height: 150,
            // decoration: const BoxDecoration(
            //     borderRadius: BorderRadius.circular(20)),
            child: Swiper(
              itemCount: ad.images.length,
              onIndexChanged: (i) {},
              outer: false,
              physics: ad.images.length > 1
                  ? null
                  : const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageGalleryPage(
                        images: ad.images,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: ImageFromInternet(
                    image: ad.images[index],
                    defaultLogo: true,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              pagination: SwiperPagination(
                  builder: SwiperCustomPagination(builder: (context, config) {
                return const DotSwiperPaginationBuilder(
                        color: AppColors.GREY_DARK_COLOR,
                        activeColor: AppColors.SECONDARY_COLOR,
                        size: 10.0,
                        activeSize: 10.0)
                    .build(context, config);
              })),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ad.price == 0
                    ? const Spacer()
                    : Label(
                        text:
                            '${NumbersHelper.formatThousands(number: ad.price ?? 0)} ${LocaleKeys.currency.localize}',
                        style: Styles.headerText(
                          fontWeight: FontWeight.bold,
                          color: AppColors.SECONDARY_COLOR_DARK2,
                        ),
                        maxLines: 1,
                      ),
                Label(
                  text: ad.formatedDate,
                  style: Styles.headerText(
                    fontSize: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            LableAndTextMarriageDetails(
              lable: LocaleKeys.title.localize,
              text: ad.title,
            ),
            const SizedBox(
              height: 4,
            ),
            LableAndTextMarriageDetails(
              lable: LocaleKeys.governorate.localize,
              text: context.isArabic
                  ? ad.governorateAr ?? ''
                  : ad.governorateEn ?? '',
            ),
            const SizedBox(
              height: 4,
            ),
            LableAndTextMarriageDetails(
              lable: LocaleKeys.city.localize,
              text: context.isArabic ? ad.cityAr ?? '' : ad.cityEn ?? '',
            ),
            const SizedBox(
              height: 4,
            ),
            LableAndTextMarriageDetails(
              lable: LocaleKeys.desc.localize,
              text: ad.description,
            ),
            // Label(
            //   text: "${LocaleKeys.desc.localize}: ",
            //   style: Styles.mediumText(
            //       fontWeight: FontWeight.bold,
            //       color: AppColors.SECONDARY_COLOR),
            // ),
            // Label(text: ad.description),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsWidget({required AddDetailsModel ad}) {
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
  }
}
