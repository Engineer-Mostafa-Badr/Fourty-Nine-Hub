import 'package:card_swiper/card_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/duration_helper.dart';
import 'package:fourtyninehub/core/widget/call_message_buttons.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_ad_drawer_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/premium_request_button.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/request_button.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../service_locator/service_locator.dart';

class AdCardDrawerFavourite extends StatefulWidget {
  final FavouriteAdDrawerEntity item;

  const AdCardDrawerFavourite(
      {super.key,
      required this.item,
      required this.onFav,
      required this.onRemoveFav});

  final Function(String) onFav;
  final Function onRemoveFav;

  @override
  State<AdCardDrawerFavourite> createState() => _AdCardState();
}

class _AdCardState extends State<AdCardDrawerFavourite> {
  String get formatedDate =>
      DateFormat('yyyy-MM-dd').format(widget.item.createdAt);
  Duration get restTimeDuration =>
      DateTime.now().difference(widget.item.createdAt);

  String get formattedRestTime =>
      DurationHelper().sinceTime(duration: restTimeDuration);
  @override
  Widget build(BuildContext context) {
    // List<CreateAdEntity> details = widget.item.details
    //     .where((e) => e.value.nameAr != 'السعر' && e.value.nameAr != 'المرتب')
    //     .toList();
    return BlocProvider<AdvertisementCubit>(
      create: (BuildContext context) => serviceLocator(),
      child:
          BlocBuilder<AdvertisementCubit, AdsState>(builder: (context, state) {
        final controller = context.read<AdvertisementCubit>();
        return InkWell(
          onTap: () {
            context.push(Routes.ADdetails, extra: widget.item.id);
          },
          child: Container(
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
                                        text: LocaleKeys.showMore.localize,
                                        style: Styles.headerText(
                                            color: Colors.white,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                  ))
                              ],
                            ),
                          ),
                          pagination: SwiperPagination(builder:
                              SwiperCustomPagination(
                                  builder: (context, config) {
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
                            icon: Icons.favorite,
                            // icon: widget.item.isFavourite == false
                            //     ? Icons.favorite_border
                            //     : Icons.favorite,
                            color: AppColors.SECONDARY_COLOR,
                            onPressed: () {
                              widget.onRemoveFav();
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
                                      text: widget.item.desc,
                                      style: Styles.mediumText(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              // RichText(
                              //     text: TextSpan(
                              //         children: details.map((e) {
                              //           return WidgetSpan(
                              //               child: Row(
                              //                 children: [
                              //                   Label(
                              //                       text:
                              //                       '${getLang() == 'ar' ? e.value.nameAr : e.value.nameEn} : ',
                              //                       style: Styles.mediumText(
                              //                           color: AppColors.SECONDARY_COLOR)),
                              //                   Label(
                              //                       text: getLang() == 'ar'
                              //                           ? e.value.nameAr
                              //                           : e.value.nameEn,
                              //                       style: Styles.mediumText(
                              //                           color: AppColors.PRIMARY_COLOR)),
                              //                 ],
                              //               ));
                              //         }).toList())),
                              Label(
                                text: formattedRestTime,
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
                            child: PremiumRequestButton(
                              adId: widget.item.id,
                              subCategoryId: widget.item.subCategoryId,
                              subscriptionStatus:
                                  widget.item.subscriptionStatus,
                              //  subscriptionStatus: widget.item.subscriptionStatus??'',
                            ),
                          ),
                          const Sizer(width: 5),
                          Expanded(
                            flex: 3,
                            child: RequestButton(
                              adId: widget.item.id,
                              subscriptionStatus:
                                  widget.item.subscriptionStatus,
                              //subscriptionStatus: widget.item.subscriptionStatus??'',
                            ),
                          )
                        ],
                      ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Expanded(
                      //       flex: 3,
                      //       child: AvaialbleTripsButton(
                      //         title: 'Premium Request',
                      //         color: AppColors.SECONDARY_COLOR,
                      //         onTap: () {
                      //           SubscriptionMethod().subscribe(
                      //               subscribeId: widget.item.subCategoryId,
                      //               title: LocaleKeys.premiumRequest.localize);
                      //         },
                      //       ),
                      //     ),
                      //     const Sizer(width: 5),
                      //     Expanded(
                      //       flex: 3,
                      //       child: AvaialbleTripsButton(
                      //         title: 'Request',
                      //         color: AppColors.PRIMARY_COLOR,
                      //         onTap: () {
                      //           showModalBottomSheet(
                      //             backgroundColor: Colors.white,
                      //             context: context,
                      //             shape: const RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.only(
                      //                 topLeft: Radius.circular(32.0),
                      //                 topRight: Radius.circular(32.0),
                      //               ),
                      //             ),
                      //             isDismissible: true,
                      //             isScrollControlled: true,
                      //             builder: (BuildContext context) {
                      //               return AnimatedPadding(
                      //                 padding:
                      //                     MediaQuery.of(context).viewInsets,
                      //                 duration:
                      //                     const Duration(milliseconds: 50),
                      //                 child: Container(
                      //                   height: 400.h,
                      //                   padding: EdgeInsets.symmetric(
                      //                     vertical: 10.h,
                      //                     horizontal: 10,
                      //                   ),
                      //                   child: Column(
                      //                     children: [
                      //                       Label(
                      //                         text: LocaleKeys
                      //                             .enterPhoneNumber.localize,
                      //                         style: Styles.headerText(),
                      //                       ),
                      //                       Sizer(
                      //                         height: 30.h,
                      //                       ),
                      //                       Container(
                      //                         constraints: BoxConstraints(
                      //                             maxHeight: 180.h),
                      //                         child: Form(
                      //                           key: controller.formKey,
                      //                           child: TextFormField(
                      //                             validator: (value) {
                      //                               if ((value == null ||
                      //                                   value.isEmpty)) {
                      //                                 return LocaleKeys
                      //                                     .required.localize;
                      //                               } else {
                      //                                 return null;
                      //                               }
                      //                             },
                      //                             // focusNode: focusNode,
                      //                             maxLines: null,
                      //                             maxLength: 150,
                      //                             onChanged: (c) => controller
                      //                                 .changePhone(v: c),
                      //                             // controller: controller,
                      //                             decoration: InputDecoration(
                      //                                 hintText: LocaleKeys
                      //                                     .phoneNumber.localize,
                      //                                 fillColor: Colors.white,
                      //                                 hintStyle: Styles.mediumText(
                      //                                     color: AppColors
                      //                                         .DARK_GRAY_COLOR)),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                       Expanded(
                      //                         child: Row(
                      //                           children: [
                      //                             Expanded(
                      //                               child: InkWell(
                      //                                 onTap: () async {
                      //                                   if (controller.formKey
                      //                                       .currentState!
                      //                                       .validate()) {
                      //                                     await controller
                      //                                         .makeAdRequest(
                      //                                             id: widget
                      //                                                 .item.id)
                      //                                         .then((value) {
                      //                                       if (value == true) {
                      //                                         context.pop();
                      //                                         showSuccessMessage(
                      //                                             context,
                      //                                             'Request Sent Successfully');
                      //                                         controller
                      //                                             .resetRequest();
                      //                                       } else {
                      //                                         context.pop();
                      //                                         if (state
                      //                                                 .failure !=
                      //                                             null) {
                      //                                           showErrorMessage(
                      //                                               context,
                      //                                               getFailureMessage(
                      //                                                   state
                      //                                                       .failure!,
                      //                                                   context));
                      //                                         } else {
                      //                                           showErrorMessage(
                      //                                               context,
                      //                                               'Please Try Again!');
                      //                                         }
                      //                                       }
                      //                                     });
                      //                                   }
                      //                                 },
                      //                                 child: Container(
                      //                                   width: 100,
                      //                                   height: 80.h,
                      //                                   padding:
                      //                                       const EdgeInsets
                      //                                           .all(5),
                      //                                   decoration: BoxDecoration(
                      //                                       color: AppColors
                      //                                           .PRIMARY_COLOR,
                      //                                       borderRadius:
                      //                                           BorderRadius
                      //                                               .circular(
                      //                                                   15)),
                      //                                   alignment:
                      //                                       Alignment.center,
                      //                                   child: Label(
                      //                                     text: LocaleKeys
                      //                                         .send.localize,
                      //                                     style:
                      //                                         Styles.headerText(
                      //                                             color: Colors
                      //                                                 .white),
                      //                                   ),
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                             Expanded(
                      //                               child: TextButton(
                      //                                 onPressed: () {
                      //                                   Navigator.of(context)
                      //                                       .pop(); // Close the dialog
                      //                                 },
                      //                                 child: Label(
                      //                                   text: LocaleKeys
                      //                                       .cancel.localize,
                      //                                   style:
                      //                                       Styles.headerText(),
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           ],
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               );
                      //             },
                      //           );
                      //         },
                      //       ),
                      //     )
                      //   ],
                      // ),
                      const Sizer(),
                      CallMessageButtons(
                        otherUserId: widget.item.userId,
                        subcategoryId: widget.item.subCategoryId,
                        phone: widget.item.phone,
                        id: widget.item.id,
                        hasReport: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

// Widget _buildTag() {
//   // super premium
//   return const Icon(
//     Icons.workspace_premium_outlined,
//     size: 20,
//     color: AppColors.SECONDARY_COLOR,
//   );
//   // premium
//   // regular
// }
}
