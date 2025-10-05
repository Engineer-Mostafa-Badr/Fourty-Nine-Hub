import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/loading_dashboard/loading_dashboard_details_screen.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/cards/available_trips_card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/cards/trip_contacts_buttons.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_card_button.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/dialog_content.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/show_dialog_trip_join.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

class GlobalCard extends StatelessWidget {
  const GlobalCard({super.key, this.views,this.onSubscribe,this.hasBottomSide, this.isView, this.subscriptionType, this.body, this.hasTopSide, this.onTap, this.onShowViewers, this.onRequest, this.clientId, required this.subcategoryId, required this.phone, required this.reportId, this.senderName, this.senderImage, this.hasReport, this.isPremium, this.isButtonEnabled, required this.otherUserId, this.subCategoryTitle});
  final num? views;
  final bool? isView;
  final String? subscriptionType;
  final String? subCategoryTitle;
  final Widget? body;
  final Function? onSubscribe;
  final bool? hasTopSide;
  final bool? hasBottomSide;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onShowViewers;
  final GestureTapCallback? onRequest;
  final String? clientId;
  final String subcategoryId;
  final String phone;
  final String reportId;
  final String? senderName;
  final String? senderImage;
  final bool? hasReport;
  final bool? isPremium;
  final bool? isButtonEnabled;
  final String otherUserId;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClickableWidget(
          onTap: onTap,
          child: CustomCard(
            radius: 20,
            color: ((isView == null||isView==true)  ? (context.isDarkMode?AppColors.GREY_DARK_COLOR:AppColors.whiteColor) : (context.isDarkMode?AppColors.GREY_DARK_COLOR:AppColors.BG_GRAY_COLOR)),
            children: [
              if(hasTopSide==true)...[
                const Sizer(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0.h),
                child: Row(
                  children: [
                    Expanded(
                      child: ClickableWidget(
                        onTap: onShowViewers,
                        child: Row(
                          children: [
                            Icon(
                              Icons.remove_red_eye_sharp,
                              color: context.isDarkMode ? AppColors.whiteColor : AppColors.DARK_GRAY_COLOR,
                            ),
                            const Sizer(),
                            Label(
                              text: '${formatPrice(formatViews(views ?? 0, context).toInt, context)} ${LocaleKeys.views.localize}',
                              style: Styles.mediumText(
                                fontSize: 24,
                                color: context.isDarkMode ? AppColors.whiteColor : AppColors.DARK_GRAY_COLOR,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      subscriptionType??'',
                      style: Styles.headerText(color: AppColors.getRedColor(context), fontSize: 32),
                    ),
                  ],
                ),
              ),
                Container(
                  height: 1.h,
                  width: double.infinity,
                  color: Colors.grey,
                )
              ],
              body??SizedBox.shrink(),
              if(hasBottomSide==true)...[
                Container(
                height: 1.h,
                width: double.infinity,
                color: Colors.grey,
              ),
                const Sizer(height: 8,),
              Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.0.h,
                  ),
                  child: Row(
                    spacing: 15,
                    children: [
                      if (onRequest!=null)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                            child: TripJoinCardButton(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              title: LocaleKeys.request.localize,
                              color: AppColors.getRedColor(context),
                              onTap: onRequest,
                              radius: 15,
                            ),
                          ),
                        ),
                      Expanded(
                        child: ContactsTripButtons(
                          subscriptionTitle:subCategoryTitle??LocaleKeys.ads.localize,
                          onSubscribe: onSubscribe,
                          // isPremium: false,
                          isPremium: isPremium,
                          isButtonEnabled: isButtonEnabled,
                          otherUserId: otherUserId,
                          subcategoryId: subcategoryId,
                          phone: phone,
                          id: reportId,
                          hasReport: hasReport,
                        ),
                      ),
                    ],
                  )

                // TripJoinButtonsSection(
                //   isContactInfo: data.isPremium == true || data.isButtonEnabled!.state == true ? true : false,
                //   isRequestButton: true,
                //   buttonTitle:LocaleKeys.requests.localize,
                //   // buttonTitle:" buttonTitle",
                //   onTap: (){},
                // ),
              ),
              ],
              const Sizer(height: 8,),
            ],
          ),
        ),
        ((isPremium==null||isPremium == true) || (isButtonEnabled==null||isButtonEnabled == true)) ? SizedBox() : tripCardSubscribeText(context),
      ],
    );
  }

  tripCardSubscribeText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.h, 10.h, 20.h, 0),
      child: InkWell(
        onTap: () => showDialogTripJoin(
            context,
            DialogContent(
              subTitle: LocaleKeys.pleaseSubscribeToContactTheClient.localize,
              leftButtonTitle: LocaleKeys.close.localize,
              rightButtonTitle: LocaleKeys.subscribe.localize,
                onRightButtonPressed:(){
                  SubscriptionMethod().subscribe(
                    subscribeId: subcategoryId,
                    title: subCategoryTitle??LocaleKeys.ads.localize,
                    onSubscribe: onSubscribe!=null?onSubscribe!():()=>context.pop(),
                  );
                }
            )),
        child: Text(
          LocaleKeys.subscribeToContactClient.localize,
          style: Styles.headerText(
            color: AppColors.getRedColor(context),
            fontSize: 30,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
