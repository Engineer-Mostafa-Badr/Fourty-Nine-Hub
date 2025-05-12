// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/functions/global/button_availability.dart';
import 'package:fourtyninehub/common/functions/helper/launch_url.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/enums/call_enums_manager.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/authentication/data/models/user_model.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/call/presentation/pages/send_whatsapp_call.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/pages/chats_view.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/helpers/call_helpers/notifications_helper/fcm_notification_helper.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';

class MarriageCallMessageButtons extends StatefulWidget {
  const MarriageCallMessageButtons({
    super.key,
    required this.otherUserId,
    required this.subcategoryId,
    required this.phone,
    this.senderName,
    this.senderImage,
    required this.id,
    this.hasReport = false,
    this.clientId,
    this.startPadding = 0,
  });
  final String otherUserId;
  final String? clientId;
  final String subcategoryId;
  final String phone;
  final String id;
  final String? senderName;
  final String? senderImage;
  final bool? hasReport;
  final double startPadding;

  @override
  State<MarriageCallMessageButtons> createState() =>
      _MarriageCallMessageButtonsState();
}

class _MarriageCallMessageButtonsState
    extends State<MarriageCallMessageButtons> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ButtonAvailability().isShowButton(
            clientId: widget.clientId,
            otherUserId: widget.otherUserId,
            subcategoryId: widget.subcategoryId),
        builder: (context, snap) {
          print(snap.data);
          return SizedBox(
            height: 30,
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      EdgeInsetsDirectional.only(start: widget.startPadding),
                  child: InkWell(
                    onTap: !context.read<UserCubit>().isLoggedIn
                        ? () {
                      return pleaseLoginDialog(context);
              // context.push(Routes.LOGIN);
          }
                        : snap.data == true
                            ? () {
                                showModalBottomSheet(
                                  backgroundColor: context.isDarkMode
                                      ? AppColors.DARK_BLUE_COLOR
                                          .withOpacity(0.95)
                                      : AppColors.LIGHT_COLOR,
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
                                    return BlocProvider.value(
                                      value:
                                          serviceLocator<AdvertisementCubit>(),
                                      child: AnimatedPadding(
                                        padding:
                                            MediaQuery.of(context).viewInsets,
                                        duration:
                                            const Duration(milliseconds: 50),
                                        child: Container(
                                          height: 150.h,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10.h,
                                            horizontal: 10,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: AvaialbleTripsButton(
                                                  title: context.isArabic
                                                      ? "خدمة الاتصال"
                                                      : "Service Call",
                                                  color:
                                                      AppColors.SECONDARY_COLOR,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15,
                                                      vertical: 5),
                                                  onTap: () {
                                                    context.pop();
                                                    LaunchURLHelper().call(
                                                        phone: widget.phone);
                                                  },
                                                ),
                                              ),
                                              const Sizer(width: 5),
                                              Expanded(
                                                flex: 3,
                                                child: AvaialbleTripsButton(
                                                  title: context.isArabic
                                                      ? "اتصال مميز"
                                                      : "Premium Call",
                                                  color:
                                                      AppColors.SECONDARY_COLOR,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15,
                                                      vertical: 5),
                                                  onTap: () async {
                                                    context.pop();
                                                    if (await Permission
                                                                .microphone
                                                                .request() !=
                                                            PermissionStatus
                                                                .granted ||
                                                        await Permission.camera
                                                                .request() !=
                                                            PermissionStatus
                                                                .granted) {
                                                      await Permission
                                                          .microphone
                                                          .request();
                                                      await Permission.camera
                                                          .request();
                                                    }
                                                    print(
                                                        'sender data is ${widget.otherUserId}, ${widget.senderName}, ${widget.senderImage}, ');
                                                    final fcmToken =
                                                        await serviceLocator<
                                                                FcmNotificationHelper>()
                                                            .getFcmUserToken();
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                SendWhatsappCallScreen(
                                                                  callType:
                                                                      CallType
                                                                          .audio,
                                                                  receiver: UserModel(
                                                                      id: widget
                                                                          .otherUserId,
                                                                      firstName:
                                                                          widget.senderName ??
                                                                              '',
                                                                      lastName:
                                                                          '',
                                                                      firebaseToken:
                                                                          "eVbbeN09TSa8oSMH4xEgki:APA91bEiZraT2zh96KMj-EUBaUQVuoFSk2WNCC3yU7CDOOXtspeHH5CtauPZatt7ghxS7Em-4pv7xbkM8rI7WcIPHWHQVtiScl2OLK04BTm4bGS6LxFJyo0"
                                                                      // chat.fcmToken
                                                                      ),
                                                                  sender:
                                                                      UserModel(
                                                                    id: widget
                                                                        .otherUserId,
                                                                    firstName:
                                                                        widget.senderName ??
                                                                            '',
                                                                    lastName:
                                                                        widget.senderName ??
                                                                            '',
                                                                    firebaseToken:
                                                                        fcmToken,
                                                                  ),
                                                                )));
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            : () async {
                                SubscriptionMethod().subscribe(
                                    subscribeId: widget.subcategoryId,
                                    title: LocaleKeys.ads.localize);
                              },
                    child: SvgPicture.asset(
                      (snap.data == true &&
                              context.read<UserCubit>().isLoggedIn)
                          ? Assets.phoneIconRed
                          : Assets.phoneIcon,
                      color:!(snap.data == true &&
                          context.read<UserCubit>().isLoggedIn)?
                      context.isDarkMode ? Colors.white : null: null,height: 37.h,
                      // color: (snap.data == true &&
                      //         context.read<UserCubit>().isLoggedIn)
                      //     ? AppColors.PRIMARY_COLOR
                      //     : AppColors.DARK_GRAY_COLOR,
                    ),
                  ),
                ),
                // const Sizer(width: 5),
                InkWell(
                  // color:
                  //     (snap.data == true && context.read<UserCubit>().isLoggedIn)
                  //         ? AppColors.PRIMARY_COLOR
                  //         : AppColors.DARK_GRAY_COLOR,
                  onTap: !context.read<UserCubit>().isLoggedIn
                      ? () {
          return pleaseLoginDialog(context);
          // context.push(Routes.LOGIN);
          }
                      : snap.data == true
                          ? () async {
                              ChatEntity? chat = await context
                                  .read<UserCubit>()
                                  .createNormalChat(
                                    otherId: widget.otherUserId,
                                    categoryId: widget.subcategoryId,
                                  );
                              context.push(
                                Routes.CHAT,
                                extra: ChatsViewParams(
                                  isFromStartChat: true,
                                  initialTabIndex: 1,
                                  selectedChat: chat,
                                ),
                              );
                            }
                          : () {
                              SubscriptionMethod().subscribe(
                                  subscribeId: widget.subcategoryId,
                                  title: LocaleKeys.ads.localize);
                            },
                  // color:
                  //     (snap.data == true && context.read<UserCubit>().isLoggedIn)
                  //         ? AppColors.PRIMARY_COLOR
                  //         : AppColors.DARK_GRAY_COLOR,
                  child: SvgPicture.asset(
                    (snap.data == true && context.read<UserCubit>().isLoggedIn)
                        ? Assets.mailIconRed
                        : Assets.mailIcon,
                    color:!(snap.data == true &&
                        context.read<UserCubit>().isLoggedIn)?
                    context.isDarkMode ? Colors.white : null: null,height: 30.h,
                  ),
                ),
                if (widget.hasReport == true) ...[
                  InkWell(
                    // color: AppColors.SECONDARY_COLOR,
                    onTap: !context.read<UserCubit>().isLoggedIn
                        ? () {
          return pleaseLoginDialog(context);
          // context.push(Routes.LOGIN);
          }
                        : () {
                            bottomSheet(
                                context: context,
                                widget: ReportView(
                                  id: widget.id,
                                  categoryId: widget.subcategoryId,
                                ));
                          },
                    // color: AppColors.SECONDARY_COLOR,
                    child: Icon(
                      Icons.report,
                      color: AppColors.SECONDARY_COLOR_DARK2,
                      size:50.h,
                    ),
                  ),
                ]
              ],
            ),
          );
        });
  }
}
