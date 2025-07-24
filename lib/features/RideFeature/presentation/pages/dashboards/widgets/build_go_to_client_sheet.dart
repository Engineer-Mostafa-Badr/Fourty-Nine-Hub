import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/launch_url.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/enums/call_enums_manager.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/service/bottom_sheet_helper.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/running_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/cancel_trip_by_rider.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/dashboards_cubit/dashboards_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/ride_mode_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_status_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/dialog_widget/show_custom_dialog_trip.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/call/presentation/pages/send_whatsapp_call.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/pages/chats_view.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/helpers/call_helpers/notifications_helper/fcm_notification_helper.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../authentication/data/models/user_model.dart';

class BuildGoToClientSheet extends StatefulWidget {
  const BuildGoToClientSheet({super.key, this.onGoingToClient,required this.params, this.activeTrip, required this.onSafety, required this.onReport, required this.onCancelTrip});
  final GestureTapCallback? onGoingToClient;
  final RunningTripEntity? activeTrip;
  final VoidCallback onSafety;
  final VoidCallback onReport;
  final RideModeParams params;
  final Function(CancelTripByRiderUseCaseParams params) onCancelTrip;

  @override
  State<BuildGoToClientSheet> createState() => _BuildGoToClientSheetState();
}

class _BuildGoToClientSheetState extends State<BuildGoToClientSheet> {
  bool _isOtherReason = false;
  bool _isChangedMindReason = false;
  bool _isClientNotShownReason = false;

  TextEditingController otherController = TextEditingController();

  Future<void> openGoogleMapsWithDirections({
    required double startLat,
    required double startLng,
    required double targetLat,
    required double targetLng,
  }) async {
    final googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&origin=$startLat,$startLng&destination=$targetLat,$targetLng&travelmode=driving';

    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.2,
      maxChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ActionButtonsWidget(
                    driverImageUrl: widget.activeTrip?.clientPicture ?? '',
                    driverRating: (widget.activeTrip?.clientRaiting??0).toDouble(),
                    driverName: widget.activeTrip?.clientName ?? '',
                    onSafety: widget.onSafety,
                    is_show_message: true,
                    onMessage: () async {
                      ManageVibration.vibrate();
                      BottomSheetHelper.startChatAndNavigate(
                          context: context,
                        otherUserId: widget.activeTrip?.clientId??'',
                        categoryId: widget.activeTrip?.subCategoryId??'',
                      );
                    },
                    onContactDriver: () {
                      ManageVibration.vibrate();
                      BottomSheetHelper.showCallOptionsBottomSheet(
                          context: context,
                          senderId: widget.activeTrip?.driverId ?? '',
                          senderFirstName: UserCubit.to.state.data?.firstName ?? '',
                          senderLastName: UserCubit.to.state.data?.lastName ?? '',
                          receiverId: widget.activeTrip?.clientId ?? '',
                          receiverName: widget.activeTrip?.clientName ?? '',
                          phoneNumber: '01145152315'
                      );
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () => widget.onReport(),
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: context.isDarkMode ? AppColors.GREY_DARK_COLOR : Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.PRIMARY_COLOR)),
                      child: Text(
                        context.isArabic ? "تقرير العميل" : "Report Client",
                        style: TextStyle(
                          fontSize: FontSize.s16,
                          fontWeight: FontWeight.bold,
                          color: context.isDarkMode ? AppColors.whiteColor : AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ClickableWidget(
                    onTap: ()
                    {
                      ManageVibration.vibrate();
                      openGoogleMapsWithDirections(
                        startLat: widget.activeTrip?.startCoordinates?[1] ?? 0.0,
                        startLng: widget.activeTrip?.startCoordinates?[0] ?? 0.0,
                        targetLat: widget.activeTrip?.targetCoordinates?[1] ?? 0.0,
                        targetLng: widget.activeTrip?.targetCoordinates?[0] ?? 0.0,
                      );},
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: AppColors.PRIMARY_COLOR, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.PRIMARY_COLOR)),
                      child: Text(
                        context.isArabic ? "افتح خرائط جوجل" : "Open Google Map",
                        style: const TextStyle(
                          fontSize: FontSize.s16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(color: context.isDarkMode ? AppColors.GREY_DARK_COLOR : Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, color: context.isDarkMode ? AppColors.whiteColor : Colors.black54),
                          SizedBox(width: 5),
                          Text(
                            "${context.isArabic?'وقت الرحلة':"Travel time"}: ~${FormatNumbers().convertNumberToLocalizedString('${widget.activeTrip?.duration??''}', isArabic: context.isArabic)} ${context.isArabic?"دقيقة":"min"}. ${context.isArabic?"مسافة":"Distance"}: ${FormatNumbers().convertNumberToLocalizedString(((widget.activeTrip?.distance??0) / 1000).toStringAsFixed(1), isArabic: context.isArabic)} ${LocaleKeys.KM.tr()}.",
                            style: TextStyle(color: context.isDarkMode ? AppColors.whiteColor : Colors.black54, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClickableWidget(
                    onTap: widget.onGoingToClient,
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: AppColors.PRIMARY_COLOR, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.PRIMARY_COLOR)),
                      child: Text(
                        context.isArabic ? "الذهاب إلى العميل" : "Go To The Client",
                        style: const TextStyle(
                          fontSize: FontSize.s16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClickableWidget(
                    onTap: () {
                      ManageVibration.vibrate();
                      showCancelTripDialog(
                          context: context,
                          isChangedMindReason: _isChangedMindReason,
                          onSelectChangedMindReason: () {
                            ManageVibration.vibrate();
                            setState(() {
                              _isClientNotShownReason = false;
                              _isChangedMindReason = !_isChangedMindReason;
                              _isOtherReason = false;
                            });
                          },
                          isClientNotShownReason: _isClientNotShownReason,
                          onSelectClientNotShownReason: () {
                            ManageVibration.vibrate();
                            setState(() {
                              _isClientNotShownReason = !_isClientNotShownReason;
                              _isChangedMindReason = false;
                              _isOtherReason = false;
                            });
                          },
                          isOtherReason: _isOtherReason,
                          onSelectOtherReason: () {
                            ManageVibration.vibrate();
                            setState(() {
                              _isClientNotShownReason = false;
                              _isChangedMindReason = false;
                              _isOtherReason = !_isOtherReason;
                            });
                          },
                          onCancelTrip: (CancelTripByRiderUseCaseParams params)=>widget.onCancelTrip(params));
                    },
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: context.isDarkMode ? AppColors.GREY_DARK_COLOR : Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        LocaleKeys.cancelTheRide.localize,
                        style: TextStyle(
                          fontSize: FontSize.s16,
                          fontWeight: FontWeight.w500,
                          color: context.isDarkMode ? AppColors.whiteColor :AppColors.PRIMARY_COLOR_DARK,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  showCancelTripDialog({
    required BuildContext context,
    required bool isOtherReason,
    required bool isChangedMindReason,
    required bool isClientNotShownReason,
    required Function onSelectOtherReason,
    required Function onSelectChangedMindReason,
    required Function onSelectClientNotShownReason,
    required Function(CancelTripByRiderUseCaseParams params) onCancelTrip,
  }) {
    showCustomDialogTrip(
        context,
        BlocProvider.value(
          value: serviceLocator<DashboardsCubit>(),
          child: BlocBuilder<DashboardsCubit, DashboardsState>(builder: (context, state) {
            var cubit = context.read<DashboardsCubit>();
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LocaleKeys.alert.localize,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(context.isArabic ? 'لماذا تريد الغاء الرحلة' : 'Why do you want to cancel ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: FontSize.s16,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                    )),
                const SizedBox(height: 20),
                ClickableWidget(
                  onTap: () {
                    ManageVibration.vibrate();
                    cubit.changeReasonSelection(isClientNotShown: true);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? AppColors.GREY_DARK_COLOR : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: state.isClientNotShownReason == true ? Border.all(color: AppColors.SECONDARY_COLOR_DARK2) : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: context.isDarkMode ? AppColors.whiteColor : Colors.black54),
                        SizedBox(width: 5),
                        Text(
                          context.isArabic ? "لم يظهر العميل" : "The client did not show up",
                          style: TextStyle(color: context.isDarkMode ? AppColors.whiteColor : Colors.black54, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ClickableWidget(
                  onTap: () {
                    ManageVibration.vibrate();
                    cubit.changeReasonSelection(isChangedMind: true);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? AppColors.GREY_DARK_COLOR : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: state.isChangedMindReason == true ? Border.all(color: AppColors.SECONDARY_COLOR_DARK2) : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: context.isDarkMode ? AppColors.whiteColor : Colors.black54),
                        SizedBox(width: 5),
                        Text(
                          context.isArabic ? "لقد قمت بتغيير رأيي" : "I changed my mind",
                          style: TextStyle(color: context.isDarkMode ? AppColors.whiteColor : Colors.black54, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ClickableWidget(
                  onTap: () {
                    ManageVibration.vibrate();
                    cubit.changeReasonSelection(isOther: true);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: state.isOtherReason == true
                          ? context.isDarkMode
                              ? AppColors.GREY_DARK_COLOR
                              : Colors.transparent
                          : context.isDarkMode
                              ? AppColors.GREY_DARK_COLOR
                              : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: state.isOtherReason == true ? Border.all(color: AppColors.SECONDARY_COLOR_DARK2) : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: context.isDarkMode ? AppColors.whiteColor : Colors.black54),
                        SizedBox(width: 5),
                        Text(
                          context.isArabic ? "أخري" : "Other",
                          style: TextStyle(color: context.isDarkMode ? AppColors.whiteColor : Colors.black54, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.isOtherReason == true) ...[
                  const SizedBox(height: 20),
                  DefaultTextFormField(
                    currentController: cubit.reasonController,
                    fillColor: context.isDarkMode ? AppColors.GREY_DARK_COLOR : AppColors.GREYBG,
                    borderColor: Colors.transparent,
                    hint: context.isArabic ? 'اكتب السبب هنا' : 'Write the reason here',
                    // label: LocaleKeys.firstName.localize,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return LocaleKeys.required.localize;
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton(
                        width: context.screenWidth / 3.4,
                        label: context.isArabic ? 'الغاء' : 'Close',
                        backColor: AppColors.SECONDARY_COLOR_DARK2,
                        onPressed: () {
                          ManageVibration.vibrate();
                          context.pop();
                          // cubit
                        }),
                    const SizedBox(width: 16),
                    AppButton(
                        width: context.screenWidth / 3.4,
                        label: context.isArabic ? 'تأكيد' : 'Confirm',
                        backColor: AppColors.PRIMARY_COLOR,
                        onPressed: () async {
                          ManageVibration.vibrate();
                          context.pop();
                          if (state.isOtherReason == true || state.isChangedMindReason == true || state.isClientNotShownReason == true) {
                            onCancelTrip(CancelTripByRiderUseCaseParams(
                              reasonId: state.isOtherReason == true
                                  ? '6693d4723aa4a25077cdbc7b'
                                  : state.isClientNotShownReason == true
                                  ? '665eec12ce3725d6bc6f40ca'
                                  : state.isChangedMindReason == true
                                  ? '665ef7118e67e46ce6498fef'
                                  : '',
                              note: state.isOtherReason == true
                                  ? cubit.reasonController.text
                                  : state.isClientNotShownReason == true
                                  ? 'client-no-show'
                                  : state.isChangedMindReason == true
                                  ? 'change-my-mind'
                                  : '',
                              tripId: widget.activeTrip?.tripId ?? '',
                            ));
                          } else {
                            showErrorMessage(context, context.isArabic ? "يرجى تحديد سبب" : 'Please select a reason');
                          }
                        }),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
        ));
  }
}
