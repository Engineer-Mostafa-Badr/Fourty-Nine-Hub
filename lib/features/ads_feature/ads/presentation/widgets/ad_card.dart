import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/widget/call_message_buttons.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/create_ad_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';

class AdCard extends StatefulWidget {
  final AdEntity item;
  const AdCard(
      {super.key,
      required this.item,
      required this.onFav,
      required this.onRemoveFav});
  final Function(String) onFav;
  final Function(String) onRemoveFav;

  @override
  State<AdCard> createState() => _AdCardState();
}

class _AdCardState extends State<AdCard> {
  @override
  Widget build(BuildContext context) {
    List<CreateAdEntity> details = widget.item.details
        .where((e) => e.value.nameAr != 'السعر' && e.value.nameAr != 'المرتب')
        .toList();
    return BlocBuilder<AdvertisementCubit,AdsState>(
      builder: (context,state) {
        final controller = context.read<AdvertisementCubit>();
        return Container(
          width: kToolbarHeight * 2.5,
          height: 600.h,
          margin: EdgeInsetsDirectional.all(10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(color: AppColors.DARK_GRAY_COLOR, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [
                    SizedBox(
                      height: kToolbarHeight * 4,
                      width: double.infinity,
                      child: Swiper(
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
                                image: widget.item.images[index],
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
                                      text: 'See More',
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
                    ),
                    PositionedDirectional(
                      start: 10.w,
                      child: IconAppButton(
                          size: 18,
                          icon: widget.item.isFavourite == false
                              ? Icons.favorite_border
                              : Icons.favorite,
                          color: AppColors.SECONDARY_COLOR,
                          onPressed: () async {
                            if (widget.item.isFavourite == false) {
                              var result = await widget.onFav(widget.item.id);
                              if (result == true) {
                                widget.item.isFavourite =
                                    !widget.item.isFavourite!;
                              }
                            } else {
                              var result =
                                  await widget.onRemoveFav(widget.item.id);
                              if (result == true) {
                                widget.item.isFavourite =
                                    !widget.item.isFavourite!;
                              }
                            }
                          }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () =>
                          context.push(Routes.ADdetails, extra: widget.item.id),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Label(
                                    text:
                                        '${NumbersHelper.formatThousands(number: widget.item.price ?? 0)} ${LocaleKeys.currency.localize}',
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
                                      color: Colors.grey),
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
                                        color: Colors.grey),
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
                                  Label(
                                      text: getLang() == 'ar'
                                          ? e.value.nameAr
                                          : e.value.nameEn,
                                      style: Styles.mediumText(
                                          color: AppColors.PRIMARY_COLOR)),
                                ],
                              ));
                            }).toList())),
                            Label(
                              text: widget.item.formattedRestTime,
                              style: Styles.mediumText(color: Colors.grey),
                              maxLines: 1,
                            ),
                          ]),
                    ),
                    const Divider(),
                    const Sizer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: AvaialbleTripsButton(
                            title: 'Premium Request',
                            color: AppColors.SECONDARY_COLOR,
                            onTap: () {
                              SubscriptionMethod().subscribe(subscribeId: widget.item.subCategoryId??'', title: LocaleKeys.premiumRequest.localize);
                            },
                          ),
                        ),
                        const Sizer(width: 5),
                        Expanded(
                          flex: 3,
                          child: AvaialbleTripsButton(
                            title: 'Request',
                            color: AppColors.PRIMARY_COLOR,
                            onTap: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.white,
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(32.0),
                                    topRight: Radius.circular(32.0),
                                  ),
                                ),
                                isDismissible: true,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return AnimatedPadding(
                                    padding: MediaQuery.of(context).viewInsets,
                                    duration: const Duration(milliseconds: 50),
                                    child: Container(
                                      height: 400.h,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10.h,
                                        horizontal: 10,
                                      ),
                                      child: Column(
                                        children: [
                                          Label(
                                            text: LocaleKeys
                                                .enterPhoneNumber.localize,
                                            style: Styles.headerText(),
                                          ),
                                          Sizer(
                                            height: 30.h,
                                          ),
                                          Container(
                                            constraints:
                                                BoxConstraints(maxHeight: 180.h),
                                            child: Form(
                                              key: controller.formKey,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if ((value == null || value.isEmpty)) {
                                                    return LocaleKeys.required.localize;
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                // focusNode: focusNode,
                                                maxLines: null,
                                                maxLength: 150,
                                                onChanged: (c) =>controller.changePhone(v: c),
                                                // controller: controller,
                                                decoration: InputDecoration(
                                                    hintText: LocaleKeys
                                                        .phoneNumber.localize,
                                                    fillColor: Colors.white,
                                                    hintStyle: Styles.mediumText(
                                                        color: AppColors
                                                            .DARK_GRAY_COLOR)),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () async {

                                                        if(controller.formKey.currentState!.validate()){
                                                          await controller.makeAdRequest(id: widget.item.id).then((value) {
                                                              if(value==true){
                                                                context.pop();
                                                                showSuccessMessage(context, 'Request Sent Successfully');
                                                                controller.resetRequest();
                                                              }else{
                                                                context.pop();
                                                                if(state.failure!=null){
                                                                  showErrorMessage(context, getFailureMessage(state.failure!, context));

                                                                }else{
                                                                  showErrorMessage(context, 'Please Try Again!');

                                                                }
                                                              }

                                                          }
                                                          );
                                                        }

                                                    },
                                                    child: Container(
                                                      width: 100,
                                                      height: 80.h,
                                                      padding:
                                                          const EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .PRIMARY_COLOR,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15)),
                                                      alignment: Alignment.center,
                                                      child: Label(
                                                        text: LocaleKeys
                                                            .send.localize,
                                                        style: Styles.headerText(
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                    },
                                                    child: Label(
                                                      text: LocaleKeys
                                                          .cancel.localize,
                                                      style: Styles.headerText(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        )
                      ],
                    ),
                    const Sizer(),
                    CallMessageButtons(
                      otherUserId: widget.item.userId ?? '',
                      subcategoryId: widget.item.subCategoryId ?? '',
                      phone: widget.item.phone ?? '',
                      id: widget.item.id,
                      hasReport: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildTag() {
    // super premium
    return const Icon(
      Icons.workspace_premium_outlined,
      size: 20,
      color: AppColors.SECONDARY_COLOR,
    );
    // premium
    // regular
  }
}
