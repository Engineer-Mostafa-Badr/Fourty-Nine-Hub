import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/premium_request_button.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/request_button.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/search/domain/entity/ads_search_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../ads_feature/ads/presentation/widgets/marriage_call_message_buttons.dart';
import '../../../../subcategories/presentation/widgets/build_tag_ads_widget.dart';
import '../../../../subcategories/presentation/widgets/image_ads_widget.dart';
import '../../../domain/entity/create_ad_search_entity.dart';

class BuildItemAdsSearch extends StatefulWidget {
  final AdsSearchEntity item;

  const BuildItemAdsSearch({
    super.key,
    required this.item,
    required this.onFav,
    required this.onRemoveFav,
  });

  final Function(String) onFav;
  final Function(String) onRemoveFav;

  @override
  State<BuildItemAdsSearch> createState() => _BuildItemAdsSearchState();
}

class _BuildItemAdsSearchState extends State<BuildItemAdsSearch> {
  @override
  Widget build(BuildContext context) {
    final userId = serviceLocator<UserCubit>().state.data?.id ?? '';
    print(userId);
    print(widget.item.userId);
    List<CreateAdSearchEntity> details = widget.item.details
        .where((e) => e.value.nameAr != 'السعر' && e.value.nameAr != 'المرتب')
        .toList();
    return BlocProvider<AdvertisementCubit>(
      create: (BuildContext context) => serviceLocator(),
      child: BlocBuilder<AdvertisementCubit, AdsState>(
        builder: (BuildContext context, state) {
          return InkWell(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => context.push(Routes.ADdetails, extra: widget.item.id),
            child: IntrinsicHeight(
              child: Container(
                // width: kToolbarHeight * 2.5,
                // height: 600.h,
                // margin: EdgeInsetsDirectional.all(10.w),
                padding: const EdgeInsetsDirectional.only(bottom: 8),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: context.isDarkMode
                          ? AppColors.LIGHT_COLOR
                          : AppColors.GREY_DARK_COLOR,
                      width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (context.read<UserCubit>().isLoggedIn)
                      BuildTagAdsWidget(
                          status: 'widget.item.ownerSubscriptionStatus' ?? '',
                          views: widget.item.views ?? 0),
                    Expanded(
                      child: ImageAdsWidget(
                        images: widget.item.images.map((e) => e.mediaKey).toList(),
                        // isFavourite: widget.item.isFavourite ?? false,
                        isFavourite:  false,
                        // onPressedFavorite: () async {
                        //   if (widget.item.isFavourite == false) {
                        //     var result = await widget.onFav(widget.item.id);
                        //     if (result == true) {
                        //       widget.item.isFavourite = !widget.item.isFavourite!;
                        //     }
                        //   } else {
                        //     var result = await widget.onRemoveFav(widget.item.id);
                        //     if (result == true) {
                        //       widget.item.isFavourite = !widget.item.isFavourite!;
                        //     }
                        //   }
                        //   setState(() {});
                        // },
                        onPressedFavorite: () async{},
                        isVerified: true, // widget.item.isVerified ?? false,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        spacing: 4,
                        children: [
                          Row(
                            children: [
                              Label(
                                text: widget.item.title,
                                style: Styles.headerText(
                                  fontSize: 32,
                                  height: 1.6,
                                ),
                              ),
                              const Spacer(),
                              SvgPicture.asset(Assets.adsCashIcon),
                              const Sizer(width: 5),
                              // Label(
                              //   text:
                              //   '${FormatNumbers().formatNumberByComma(widget.item.price.toString(), isArabic: context.isArabic)} ${context.isArabic ? widget.item.currencyAr : widget.item.currencyEn}',
                              //   style: Styles.mediumText(
                              //       fontWeight: FontWeight.bold,
                              //       color: AppColors.SECONDARY_COLOR),
                              //   maxLines: 1,
                              // ),
                            ],
                          ),
                          // اذا كان الاعلان من نوع المركبات
                          if (widget.item.mainCategoryId ==
                              '62c8b5889332225799fe3316') ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: widget.item.details
                                  .where((e) =>
                              e.propId == '66ec666f12cfcdf9779dfcc5' ||
                                  e.propId == '66ec666f12cfcdf9779dfd05' ||
                                  e.propId == '66ec666f12cfcdf9779dfcc6')
                                  .map((e) {
                                return Row(
                                  children: [
                                    ImageFromInternet(
                                      image: e.image ?? '',
                                      width: 24,
                                      height: 24,
                                      defaultLogo: true,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Label(
                                      text: context.isArabic
                                          ? e.value.nameAr
                                          : e.value.nameEn,
                                      style: Styles.headerText(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        height: 1.60,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ] else
                            Column(
                              children: widget.item.details
                                  .where((e) => e.nameEn == 'experience level')
                                  .map((e) {
                                return Row(
                                  children: [
                                    ImageFromInternet(
                                      image: e.image ?? '',
                                      width: 30.w,
                                      height: 30.h,
                                      defaultLogo: true,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Label(
                                      text: context.isArabic
                                          ? e.value.nameAr
                                          : e.value.nameEn,
                                      style: Styles.headerText(
                                        fontSize: 24,
                                        height: 1.60,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
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
                                  // Label(
                                  //   text:
                                  //   '${context.isArabic ? widget.item.address.addressAr : widget.item.address?.addressEn}',
                                  //   style: Styles.headerText(
                                  //     fontSize: 24,
                                  //     height: 1.60,
                                  //   ),
                                  //   maxLines: 1,
                                  // ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                              _buildRequestsButton(
                            adId: widget.item.id,
                            userIdOfAd: widget.item.userId ?? '',
                            subcategoryId: widget.item.subCategoryId ?? '',
                            phone: widget.item.phone ?? '',
                            subscriptionStatus:
                            'widget.item.userSubscriptionStatus' ?? '',
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          /*return Container(
            width: kToolbarHeight * 2.5,
            height: 800.h,
            margin: EdgeInsetsDirectional.all(10.w),
            // padding: EdgeInsetsDirectional.symmetric(
            //   vertical: 20.h
            // ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              border: Border.all(
                  color: context.isDarkMode
                      ? AppColors.LIGHT_COLOR
                      : AppColors.GREY_DARK_COLOR,
                  width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (context.read<UserCubit>().isLoggedIn)
                  _buildTag(status: widget.item.subscriptionType),
                Expanded(
                  child: Stack(
                    alignment: AlignmentDirectional.topStart,
                    children: [
                      Swiper(
                        itemCount: widget.item.images.length > 4
                            ? 4
                            : widget.item.images.length,
                        onIndexChanged: (i) {},
                        outer: false,
                        loop: false,
                        physics: widget.item.images.length > 1
                            ? null
                            : const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(bottom: 5.h),
                          child: Stack(
                            children: [
                              ImageFromInternet(
                                width: double.infinity,
                                image: widget.item.images[index].mediaKey,
                                defaultLogo: true,
                                fit: BoxFit.fill,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.r),
                                    topRight: Radius.circular(5.r)),
                              ),
                              if (index == 3)
                                Positioned.fill(
                                    child: InkWell(
                                  onTap: () => context.push(Routes.ADdetails,
                                      extra: widget.item.id),
                                  child: Container(
                                    color: Colors.black.withOpacity(0.8),
                                    alignment: AlignmentDirectional.center,
                                    child: Label(
                                      text: LocaleKeys.seeAll.localize,
                                      style: Styles.headerText(
                                          color: Colors.white,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ))
                            ],
                          ),
                        ),
                        pagination: SwiperPagination(builder:
                            SwiperCustomPagination(builder: (context, config) {
                          return const DotSwiperPaginationBuilder(
                                  color: AppColors.GREY_DARK_COLOR,
                                  activeColor: AppColors.SECONDARY_COLOR,
                                  size: 10.0,
                                  activeSize: 10.0)
                              .build(context, config);
                        })),
                      ),
                      PositionedDirectional(
                        start: 10.w,
                        child: IconAppButton(
                            size: 18,
                            icon: widget.item.isFavorite == false
                                ? Icons.favorite_border
                                : Icons.favorite,
                            color: AppColors.SECONDARY_COLOR,
                            onPressed: () async {
                              if (widget.item.isFavorite == false) {
                                var result = await widget.onFav(widget.item.id);
                                if (result == true) {
                                  widget.item.isFavorite =
                                      !widget.item.isFavorite!;
                                }
                              } else {
                                var result =
                                    await widget.onRemoveFav(widget.item.id);
                                if (result == true) {
                                  widget.item.isFavorite =
                                      !widget.item.isFavorite!;
                                }
                              }
                            }),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => context.push(Routes.ADdetails,
                            extra: widget.item.id),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Label(
                                      text:
                                          '${NumbersHelper.formatThousands(number: widget.item.price)} ${LocaleKeys.currency.localize}',
                                      style: Styles.mediumText(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.SECONDARY_COLOR),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              Sizer(
                                height: 4.h,
                              ),
                              Row(
                                children: [
                                  Label(
                                      text: '${LocaleKeys.title.localize} : ',
                                      style: Styles.mediumText(
                                          color: AppColors.SECONDARY_COLOR)),
                                  Label(
                                    text: widget.item.title,
                                    style: Styles.mediumText(
                                      fontWeight: FontWeight.w500,
                                      color: context.isDarkMode
                                          ? AppColors.LIGHT_COLOR
                                          : AppColors.GREY_DARK_COLOR,
                                    ),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Label(
                                      text: '${LocaleKeys.desc.localize} : ',
                                      style: Styles.mediumText(
                                          color: AppColors.SECONDARY_COLOR)),
                                  Expanded(
                                    child: Label(
                                      text: widget.item.description,
                                      style: Styles.mediumText(
                                        fontWeight: FontWeight.w500,
                                        color: context.isDarkMode
                                            ? AppColors.LIGHT_COLOR
                                            : AppColors.GREY_DARK_COLOR,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              RichText(
                                  text: TextSpan(
                                      children: details.map((e) {
                                return WidgetSpan(
                                    child: Row(
                                  children: [
                                    Label(
                                        text:
                                            '${getLang() == 'ar' ? e.value.nameAr : e.value.nameEn} : ',
                                        style: Styles.mediumText(
                                            color: AppColors.SECONDARY_COLOR)),
                                    Expanded(
                                      child: Label(
                                          text: getLang() == 'ar'
                                              ? e.value.nameAr
                                              : e.value.nameEn,
                                          style: Styles.mediumText()),
                                    ),
                                  ],
                                ));
                              }).toList())),
                              Label(
                                text: widget.item.formattedRestTime,
                                style: Styles.mediumText(
                                  color: context.isDarkMode
                                      ? AppColors.LIGHT_COLOR
                                      : AppColors.GREY_DARK_COLOR,
                                ),
                                maxLines: 1,
                              ),
                            ]),
                      ),
                      Divider(
                        color: context.isDarkMode
                            ? AppColors.LIGHT_COLOR
                            : AppColors.GREY_DARK_COLOR,
                      ),
                      const Sizer(),
                      widget.item.userId != userId
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: PremiumRequestButton(
                                        adId: widget.item.id,
                                        subCategoryId:
                                            widget.item.subCategoryId,
                                        subscriptionStatus:
                                            widget.item.subscriptionType,
                                      ),
                                    ),
                                    const Sizer(width: 5),
                                    Expanded(
                                      flex: 3,
                                      child: RequestButton(
                                        adId: widget.item.id,
                                        subscriptionStatus:
                                            widget.item.subscriptionType,
                                        successRequest: () {},
                                        errorRequest: (failure) {},
                                      ),
                                    )
                                  ],
                                ),
                                const Sizer(),
                                CallMessageButtons(
                                  otherUserId: widget.item.userId ?? '',
                                  subcategoryId: widget.item.subCategoryId,
                                  phone: widget.item.phone,
                                  id: widget.item.id,
                                  hasReport: true,
                                  senderName: '',
                                  senderImage: '',
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 60.h,
                                    child: AvaialbleTripsButton(
                                      title: LocaleKeys.edit.localize,
                                      color: AppColors.SECONDARY_COLOR,
                                      onTap: () async {},
                                    ),
                                  ),
                                ),
                                const Sizer(),
                                Expanded(
                                  child: SizedBox(
                                    height: 60.h,
                                    child: AvaialbleTripsButton(
                                      title: LocaleKeys.subscription.localize,
                                      color: AppColors.SECONDARY_COLOR,
                                      onTap: () async {
                                        SubscriptionMethod().subscribe(
                                            subscribeId:
                                                widget.item.subCategoryId,
                                            title: LocaleKeys.ads.localize);
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );*/
        },
      ),
    );
  }
  Widget _buildRequestsButton({
    required String userIdOfAd,
    required String subcategoryId,
    required String phone,
    required String adId,
    required String subscriptionStatus,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        // left: 16,
        // right: 16,
        // bottom: 32,
        // top: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              label: LocaleKeys.request.localize,
              height: 30,
              backColor: AppColors.SECONDARY_COLOR_DARK2,
              onPressed: () async {
                if (!context.read<UserCubit>().isLoggedIn) {
                  return pleaseLoginDialog(context);
                  // context.push(Routes.LOGIN);
                } else {
                  bottomSheet(
                    context: context,
                    widget: BlocProvider(
                      create: (context) => serviceLocator<AdvertisementCubit>(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: IconButton(
                              iconSize: 20,
                              padding: EdgeInsets.zero,
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xffD9D9D9),
                              ),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          PremiumRequestButton(
                            adId: adId,
                            subCategoryId: subcategoryId,
                            subscriptionStatus: subscriptionStatus,
                            dontPop: true,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          RequestButton(
                            adId: adId,
                            subscriptionStatus: subscriptionStatus,
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
                              context.pop();
                              showErrorMessage(
                                  context,
                                  getFailureMessage(
                                      failure ?? UnknownFailure(''), context));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
              style: Styles.headerText(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                height: 1.60,
              ),
            ),
          ),
          SizedBox(
            width: 80.w,
          ),
          Expanded(
            child: MarriageCallMessageButtons(
              otherUserId: userIdOfAd,
              subcategoryId: subcategoryId,
              phone: phone,
              id: adId,
              hasReport: true,
            ),
          ),
        ],
      ),
    );
  }
/*  Widget _buildTag({required String status}) {
    // super premium
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      color: status == 'premium'
          ? Colors.amber
          : status == 'Regular'
              ? Colors.grey
              : Colors.grey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (status == 'premium' || status == 'Regular') ...[
            Icon(
              Icons.workspace_premium_outlined,
              size: 55.w,
              color: status == 'premium'
                  ? AppColors.SECONDARY_COLOR
                  : status == 'Regular'
                      ? AppColors.PRIMARY_COLOR
                      : null,
            ),
            const Sizer(width: 5)
          ],
          Label(
            text: status == 'premium'
                ? LocaleKeys.premiumSubscription.localize
                : status == 'Regular'
                    ? LocaleKeys.regularRequest.localize
                    : LocaleKeys.notSubscribed.localize,
            style: Styles.mediumText(
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
        ],
      ),
    );
    // premium
    // regular
  }*/
}

