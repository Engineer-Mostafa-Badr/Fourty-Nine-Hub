// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/functions/global/button_availability.dart';
import 'package:fourtyninehub/common/functions/helper/launch_url.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/helpers/call_helpers/notifications_helper/fcm_notification_helper.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../res/assets/assets.dart';

class CallMessageButtons extends StatefulWidget {
  const CallMessageButtons(
      {super.key,
      required this.otherUserId,
      required this.subcategoryId,
      required this.phone,
      this.senderName,
      this.senderImage,
      required this.id,
      this.hasReport = false,
      this.flex,
      this.chatFlex,
      this.clientId});

  final String otherUserId;
  final String? clientId;
  final String subcategoryId;
  final String phone;
  final String id;
  final String? senderName;
  final String? senderImage;
  final bool? hasReport;
  final int? flex;
  final int? chatFlex;

  @override
  State<CallMessageButtons> createState() => _CallMessageButtonsState();
}

class _CallMessageButtonsState extends State<CallMessageButtons> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ButtonAvailability().isShowButton(
            clientId: widget.clientId,
            otherUserId: widget.otherUserId,
            subcategoryId: widget.subcategoryId),
        builder: (context, snap) {
          print(snap.data);
          return Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: widget.flex ?? 3,
                child: IconButton(
                  color: (snap.data == true &&
                          context.read<UserCubit>().isLoggedIn)
                      ? AppColors.PRIMARY_COLOR
                      : AppColors.DARK_GRAY_COLOR,
                  icon: SvgPicture.asset(
                    Assets.phoneIcon,
                    width: 50.w,
                    height: 35.h,
                    color: snap.data == true
                        ? AppColors.SECONDARY_COLOR
                        : context.isDarkMode
                            ? Colors.white
                            : null,
                  ),
                  // icon: const Icon(Icons.call),
                  onPressed: !context.read<UserCubit>().isLoggedIn
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
                                    value: serviceLocator<AdvertisementCubit>(),
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 5),
                                                onTap: () {
                                                  ManageVibration.vibrate();
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 5),
                                                onTap: () async {
                                                  ManageVibration.vibrate();
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
                                                    await Permission.microphone
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
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             SendWhatsappCallScreen(
                                                  //               isRealCall:
                                                  //                   true,
                                                  //               callType:
                                                  //                   CallType
                                                  //                       .audio,
                                                  //               receiver: UserModel(
                                                  //                   id: widget
                                                  //                       .otherUserId,
                                                  //                   firstName:
                                                  //                       widget.senderName ??
                                                  //                           '',
                                                  //                   lastName:
                                                  //                       '',
                                                  //                   firebaseToken:
                                                  //                       'f8pcALRKSje_HWSPy865gD:APA91bGFQy7NEKUePDgiMRynntFkkZdW66G7k48gfQH5GgHU70fOg_7cxDPjagL25qzT35GA1fU2zrvd5ltKyEkAb0_tYMPktfn8tmg0r8pa9D3u17lnqQQ'
                                                  //                   // chat.fcmToken
                                                  //                   ),
                                                  //               sender:
                                                  //                   UserModel(
                                                  //                 id: widget
                                                  //                     .otherUserId,
                                                  //                 firstName:
                                                  //                     widget.senderName ??
                                                  //                         '',
                                                  //                 lastName:
                                                  //                     widget.senderName ??
                                                  //                         '',
                                                  //                 firebaseToken:
                                                  //                     fcmToken,
                                                  //               ),
                                                  //             )));
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
                ),
              ),
              const Sizer(width: 5),
              Expanded(
                flex: widget.chatFlex ?? 3,
                child: IconButton(
                  color: (snap.data == true &&
                          context.read<UserCubit>().isLoggedIn)
                      ? AppColors.PRIMARY_COLOR
                      : AppColors.DARK_GRAY_COLOR,
                  icon: SvgPicture.asset(Assets.mailIcon,
                      width: 50.w,
                      height: 30.h,
                      color: snap.data == true
                          ? AppColors.SECONDARY_COLOR
                          : context.isDarkMode
                              ? Colors.white
                              : null),
                  // icon: const Icon(Icons.email),
                  onPressed: !context.read<UserCubit>().isLoggedIn
                      ? () {
                          return pleaseLoginDialog(context);
                          // context.push(Routes.LOGIN);
                        }
                      : snap.data == true
                          ? () async {
                              // ChatEntity? chat = await context
                              //     .read<UserCubit>()
                              //     .createNormalChat(
                              //       otherId: widget.otherUserId,
                              //       categoryId: widget.subcategoryId,
                              //     );
                              // context.push(
                              //   Routes.CHAT,
                              //   extra: ChatsViewParams(
                              //     isFromStartChat: true,
                              //     initialTabIndex: 1,
                              //     selectedChat: chat,
                              //   ),
                              // );
                            }
                          : () {
                              SubscriptionMethod().subscribe(
                                  subscribeId: widget.subcategoryId,
                                  title: LocaleKeys.ads.localize);
                            },
                ),
              ),
              if (widget.hasReport == true) ...[
                const Sizer(width: 5),
                IconButton(
                  color: AppColors.SECONDARY_COLOR,
                  icon: const Icon(Icons.report),
                  onPressed: !context.read<UserCubit>().isLoggedIn
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
                ),
              ]
            ],
          );
        });
  }
}
