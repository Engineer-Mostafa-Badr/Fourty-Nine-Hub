import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class MessageButton extends StatelessWidget {
  final UserProfileEntity user;
  final Function() anonymousPress;
  final Function() normalPress;
  final double? width;
  final double? height;
  final bool? fromFacebook;

  const MessageButton(
      {super.key,
      required this.user,
        this.fromFacebook=false,
      required this.anonymousPress,
      required this.normalPress, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final dialogWidth = MediaQuery.of(context).size.width * 0.75;
    final dialogHeight = screenHeight / 4;
    final titleFontSize = screenHeight * 0.05;

    return SizedBox(
      height:height,
      width:width ,
      child: fromFacebook==true?_buildReactionPlaceHolder(
          image: Assets.newChat,
          label: LocaleKeys.comment.localize,
          // image: Assets.comment,
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (_) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  height: dialogHeight,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenHeight * 0.02),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50.r),
                              topRight: Radius.circular(50.r)),
                          color: AppColors.GREY_NORMAL_COLOR,
                        ),
                        child: Text(
                          LocaleKeys.chat_alert_dialog_pick_chat_type.tr(),
                          style: Styles.headerText(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(screenHeight * 0.02),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildChatOptionCard(
                                context,
                                icon: Icons.visibility_off,
                                label: LocaleKeys
                                    .chat_alert_dialog_anonymous
                                    .tr(),
                                cardUser: user,
                                onPressed: () {
                                  anonymousPress();
                                },
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              _buildChatOptionCard(context,
                                  icon: Icons.visibility,
                                  label: LocaleKeys
                                      .chat_alert_dialog_regular
                                      .tr(),
                                  cardUser: user, onPressed: () {
                                    normalPress();
                                  }),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ));
          },):AppButton(
          // height: 120.h,
          width: kToolbarHeight * 1.5,
          label: LocaleKeys.send.localize,
          style: Styles.mediumText(color: Colors.white, fontSize: 24),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (_) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      height: dialogHeight,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(screenHeight * 0.02),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50.r),
                                  topRight: Radius.circular(50.r)),
                              color: AppColors.GREY_NORMAL_COLOR,
                            ),
                            child: Text(
                              LocaleKeys.chat_alert_dialog_pick_chat_type.tr(),
                              style: Styles.headerText(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(screenHeight * 0.02),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildChatOptionCard(
                                    context,
                                    icon: Icons.visibility_off,
                                    label: LocaleKeys
                                        .chat_alert_dialog_anonymous
                                        .tr(),
                                    cardUser: user,
                                    onPressed: () {
                                      anonymousPress();
                                    },
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  _buildChatOptionCard(context,
                                      icon: Icons.visibility,
                                      label: LocaleKeys
                                          .chat_alert_dialog_regular
                                          .tr(),
                                      cardUser: user, onPressed: () {
                                    normalPress();
                                  }),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ));
          },
          ),
    );
  }


  Widget _buildReactionPlaceHolder({
    IconData? icon,
    required String label,
    String? image,
    bool? isImage = false,
    Function? onTap,
  }) {
    if (onTap == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Image.asset(
              Assets.newChat,
              width: 10.w,
              height: 10.h,
              color: Colors.grey,
            ),

          Label(text: "label", style: Styles.mediumText(color: Colors.grey,fontSize: 12.sp))
        ],
      );
    } else {
      return ClickableWidget(
        onTap: () => onTap(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Image.asset(
                Assets.newChat,
                width: 25.w,
                height: 25.h,
                color: Colors.grey,
              ),

            // Sizer(),
            Label(text: LocaleKeys.send.localize, style: Styles.mediumText(color: Colors.grey))
          ],
        ),
      );
    }
  }

  Widget _buildChatOptionCard(BuildContext context,
      {required IconData icon,
      required String label,
      required Function() onPressed,
      required UserProfileEntity cardUser}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final iconSize = screenWidth * 0.1;
    final fontSize = screenHeight * 0.04;
    final padding = screenHeight * 0.01;

    return SizedBox(
      height: 150.h,
      child: ElevatedButton(
          onPressed: () {
            onPressed();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: label == "Anonymous"
                    ? AppColors.SECONDARY_COLOR
                    : AppColors.PRIMARY_COLOR,
              ),
              SizedBox(height: padding),
              Text(
                label,
                style: Styles.headerText(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: padding / 2),
            ],
          )),
    );
  }

  void _startChat(
      BuildContext context, String label, UserProfileEntity cardUser) {
    if (label == "Anonymous") {
      print("Anonymous");
    } else {
      print("objectReg");
    }
  }
}
