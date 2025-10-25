import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/launch_url.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/helpers/call_helpers/notifications_helper/fcm_notification_helper.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:permission_handler/permission_handler.dart';

class BottomSheetHelper {
  static void showCallOptionsBottomSheet({
    required BuildContext context,
    required String senderId,
    required String phoneNumber,
    required String senderFirstName,
    required String senderLastName,
    required String receiverId,
    required String receiverName,
  }) {
    showModalBottomSheet(
      backgroundColor: context.isDarkMode
          ? AppColors.DARK_BLUE_COLOR.withOpacity(0.95)
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
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 50),
          child: Container(
            height: 150.h,
            padding: EdgeInsets.symmetric(
              vertical: 10.h,
              horizontal: 10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: AvaialbleTripsButton(
                    title: context.isArabic ? "خدمة الاتصال" : "Service Call",
                    color: AppColors.SECONDARY_COLOR,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    onTap: () {
                      ManageVibration.vibrate();
                      Navigator.pop(context);
                      LaunchURLHelper().call(phone: phoneNumber);
                    },
                  ),
                ),
                const Sizer(width: 5),
                Expanded(
                  flex: 3,
                  child: AvaialbleTripsButton(
                    title: context.isArabic ? "اتصال مميز" : "Premium Call",
                    color: AppColors.SECONDARY_COLOR,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    onTap: () async {
                      ManageVibration.vibrate();
                      Navigator.pop(context);

                      if (await Permission.microphone.request() !=
                              PermissionStatus.granted ||
                          await Permission.camera.request() !=
                              PermissionStatus.granted) {
                        await Permission.microphone.request();
                        await Permission.camera.request();
                      }

                      final fcmToken =
                          await serviceLocator<FcmNotificationHelper>()
                              .getFcmUserToken();

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => SendWhatsappCallScreen(
                      //       isRealCall: true,
                      //       callType: CallType.audio,
                      //       receiver: UserModel(
                      //         id: receiverId,
                      //         firstName: receiverName,
                      //         lastName: '',
                      //         firebaseToken:
                      //             'f8pcALRKSje_HWSPy865gD:APA91bGFQy7NEKUePDgiMRynntFkkZdW66G7k48gfQH5GgHU70fOg_7cxDPjagL25qzT35GA1fU2zrvd5ltKyEkAb0_tYMPktfn8tmg0r8pa9D3u17lnqQQ',
                      //       ),
                      //       sender: UserModel(
                      //         id: senderId,
                      //         firstName: senderFirstName,
                      //         lastName: senderLastName,
                      //         firebaseToken: fcmToken,
                      //       ),
                      //     ),
                      //   ),
                      // );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> startChatAndNavigate({
    required BuildContext context,
    required String otherUserId,
    required String categoryId,
  }) async {
    // final chat = await context.read<UserCubit>().createNormalChat(
    //       otherId: otherUserId,
    //       categoryId: categoryId,
    //     );
    //
    // if (chat != null) {
    //   context.push(
    //     Routes.CHAT,
    //     extra: ChatsViewParams(
    //       isFromStartChat: true,
    //       initialTabIndex: 1,
    //       selectedChat: chat,
    //     ),
    //   );
    // } else {
    //   // Optional: handle null chat (e.g. show error/snackbar)
    //   showErrorMessage(
    //       context,
    //       context.isArabic
    //           ? 'حدث حطأ حاول مرة آخري.'
    //           : 'Unable to start chat.');
    // }
  }
}
