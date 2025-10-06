// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/functions/global/button_availability.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/pages/chats_view.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_bottom_sheet/show_bottom_sheet.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../helpers/manage_vibration.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class ContactsTripButtons extends StatefulWidget {
  final String otherUserId;

  final String? clientId;
  final String subcategoryId;
  final String subscriptionTitle;
  final String phone;
  final String id;
  final String? senderName;
  final String? senderImage;
  final bool? hasReport;
  final bool? isPremium;
  final bool? isButtonEnabled;
  final Function? onSubscribe;
  const ContactsTripButtons(
      {super.key,
      required this.otherUserId,
      required this.subcategoryId,
      required this.subscriptionTitle,
      required this.phone,
      this.senderName,
      this.senderImage,
      this.onSubscribe,
      required this.id,
      this.hasReport = false,
      this.isPremium = false, // ✅ Add this
      this.isButtonEnabled = false, // ✅ Add this

      this.clientId});

  @override
  State<ContactsTripButtons> createState() => _ContactsTripButtonsState();
}

class _ContactsTripButtonsState extends State<ContactsTripButtons> {
  @override
  Widget build(BuildContext context) {
    bool isEnabled = (widget.isButtonEnabled==true)||(widget.isPremium==true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          visualDensity:
          const VisualDensity(horizontal: -4, vertical: -4),
          color:
          (isEnabled && context.read<UserCubit>().isLoggedIn)
              ? AppColors.PRIMARY_COLOR
              : AppColors.DARK_GRAY_COLOR,
          icon: Icon(
            size: 20,
            Icons.call,
            color: widget.isPremium==true
                ? Colors.red
                : (context.isDarkMode ? (isEnabled && context.read<UserCubit>().isLoggedIn)
                ? AppColors.grey
                : AppColors.grey : (isEnabled && context.read<UserCubit>().isLoggedIn)
                ? AppColors.PRIMARY_COLOR
                : AppColors.DARK_GRAY_COLOR),
          ),
          onPressed: (isEnabled == true && context.read<UserCubit>().isLoggedIn)
              ? () {
            ManageVibration.vibrate();
            JoinTripBottomSheet(
              phone: widget.phone,
              context,
              topButtonColor:
              AppColors.getButtonPrimaryColor(context),
              topButtonTitle: LocaleKeys.freeCall.localize,
              bottomButtonColor: context.isDarkMode
                  ? AppColors.fill_Color_DARK
                  : const Color(0xFFD9D9D9),
              bottomButtonTitle: LocaleKeys.regularCall.localize,
              onTap: () => Navigator.of(context).pop(),
              topTextColor:
              context.isDarkMode ? Colors.black : Colors.white,
              bottomTextColor: AppColors.getTextColor(context),
            );
          }
              :  (isEnabled == false && context.read<UserCubit>().isLoggedIn)?(){
            ManageVibration.vibrate();
            SubscriptionMethod().subscribe(
              subscribeId: widget.subcategoryId,
              title: widget.subscriptionTitle,
              onSubscribe: (){

              }
            );
          }:(){
            ManageVibration.vibrate();
            pleaseLoginDialog(context);
          },
        ),
        IconButton(
          visualDensity:
          const VisualDensity(horizontal: -4, vertical: -4),
          color:
          (isEnabled == true && context.read<UserCubit>().isLoggedIn)
              ? AppColors.PRIMARY_COLOR
              : AppColors.DARK_GRAY_COLOR,
          icon: SvgPicture.asset(
            Assets.mailRed,
            color: widget.isPremium==true
                ? Colors.red
                : (context.isDarkMode ? (isEnabled && context.read<UserCubit>().isLoggedIn)
                ? AppColors.grey
                : AppColors.grey : (isEnabled && context.read<UserCubit>().isLoggedIn)
                ? AppColors.PRIMARY_COLOR
                : AppColors.DARK_GRAY_COLOR),
          ),
          onPressed: !context.read<UserCubit>().isLoggedIn?
              () {
            ManageVibration.vibrate();

            return pleaseLoginDialog(context);
          }:isEnabled == true?()async {
            ManageVibration.vibrate();
            //
            // ChatEntity? chat = await context
            //     .read<UserCubit>()
            //     .createNormalChat(
            //   otherId: widget.otherUserId,
            //   categoryId: widget.subcategoryId,
            // );
            // context.push(
            //   Routes.CHAT,
            //   extra: ChatsViewParams(
            //     isFromStartChat: true,
            //     initialTabIndex: 1,
            //     selectedChat: chat,
            //   ),
            // );
          }:() {
            ManageVibration.vibrate();

            SubscriptionMethod().subscribe(
              subscribeId: widget.subcategoryId,
              title: widget.subscriptionTitle,
              onSubscribe: (){},
            );
          },
        ),
        IconButton(
          visualDensity:
          const VisualDensity(horizontal: -4, vertical: -4),
          padding: EdgeInsets.zero,
          color: AppColors.getRedColor(context),
          icon: const Icon(
            Icons.report,
          ),
          onPressed: !context.read<UserCubit>().isLoggedIn
              ? () {
            ManageVibration.vibrate();

            return pleaseLoginDialog(context);
            // context.push(Routes.LOGIN);
          }
              : () {
            ManageVibration.vibrate();

            bottomSheet(
                context: context,
                widget: ReportView(
                  id: widget.id,
                  categoryId: widget.subcategoryId,
                ));
          },
        ),
      ],
    );
  }
}
