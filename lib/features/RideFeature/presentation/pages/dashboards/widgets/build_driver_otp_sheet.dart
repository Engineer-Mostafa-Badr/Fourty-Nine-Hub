import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/service/bottom_sheet_helper.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/running_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/cancel_trip_by_rider.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/dashboards_cubit/dashboards_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/ride_mode_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_status_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/dialog_widget/show_custom_dialog_trip.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/location_info_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class BuildDriverOtpSheet extends StatefulWidget {
  const BuildDriverOtpSheet({super.key, required this.onPressed,required this.onCancelTrip,required this.params,required this.onReport, this.activeTrip, this.remainingTime, required this.onSafety, required this.onFinalizeTrip, this.onTick});
  final Function(String) onPressed;
  final RunningTripEntity? activeTrip;
  final VoidCallback onSafety;
  final Function onFinalizeTrip;
  final Function(Duration)? onTick;
  final DateTime? remainingTime;
  final VoidCallback onReport;
  final RideModeParams params;
  final Function(CancelTripByRiderUseCaseParams params) onCancelTrip;

  @override
  State<BuildDriverOtpSheet> createState() => _BuildDriverOtpSheetState();
}

class _BuildDriverOtpSheetState extends State<BuildDriverOtpSheet> {
  final TextEditingController otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isOtherReason = false;
  bool _isChangedMindReason = false;
  bool _isClientNotShownReason = false;
  bool _showButtons = true;
  DateTime? futureTime;
  TextEditingController otherController = TextEditingController();

  Future<DateTime?> getSavedDateTime() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTimeString = prefs.getString('remaining_time');
    if (savedTimeString != null) {
      return DateTime.parse(savedTimeString);
    }
    return null;
  }

  Duration _remainingTime = Duration.zero;
  Timer? _timer;
  DateTime? _savedDateTime;
  bool _isFinished = true;
  @override
  void initState() {
    super.initState();
    // _loadSavedDateTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadSavedDateTime() async {
    _savedDateTime = await getSavedDateTime();
    if (_savedDateTime != null) {
      _startTimer();
    }
  }

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

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final now = DateTime.now();

      // Fetch latest saved time every second
      final prefs = await SharedPreferences.getInstance();
      final savedTimeString = prefs.getString('remaining_time');

      if (savedTimeString == null) {
        timer.cancel();
        setState(() {
          _remainingTime = Duration.zero;
          _isFinished = true;
        });
        return;
      }

      final latestSavedTime = DateTime.tryParse(savedTimeString);

      if (latestSavedTime == null) return;

      // If time has changed externally, restart the timer
      if (_savedDateTime == null || _savedDateTime!.toIso8601String() != latestSavedTime.toIso8601String()) {
        _savedDateTime = latestSavedTime;
        timer.cancel(); // Stop current timer
        _startTimer();  // Start a new one with updated time
        return;
      }

      // Normal countdown logic
      if (_savedDateTime!.isAfter(now)) {
        setState(() {
          _remainingTime = _savedDateTime!.difference(now);
          _isFinished = false; // Reset finished state when new valid time is found
        });
      } else {
        // Instead of just canceling, keep checking for new saved time
        setState(() {
          _remainingTime = Duration.zero;
          _isFinished = true;
        });
        // Don't cancel the timer here - keep it running to detect new saved times
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {


    return DraggableScrollableSheet(
      initialChildSize: 0.80,
      minChildSize: 0.2,
      maxChildSize: 0.80,
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
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    ActionButtonsWidget(
                      driverImageUrl: widget.activeTrip?.clientPicture??'',
                      driverRating: (widget.activeTrip?.clientRaiting??0).toDouble(),
                      driverName: widget.activeTrip?.clientName??'',
                      onSafety: widget.onSafety,
                      is_show_message: true,
                      onMessage: () async {
                        BottomSheetHelper.startChatAndNavigate(
                          context: context,
                          otherUserId: widget.activeTrip?.clientId??'',
                          categoryId: widget.activeTrip?.subCategoryId??'',
                        );
                      },
                      onContactDriver: () {
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
                    if(!_isFinished)...[
                      Row(
                     children: [
                       Expanded(
                         child: Text(
                           context.isArabic ? "الوقت المتبقي" : "Remaining Time",
                           style: TextStyle(
                             fontSize: FontSize.s16,
                             fontWeight: FontWeight.bold,
                             color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR,
                           ),
                         ),
                       ),
                       Text(
                             _formatDuration(_remainingTime),
                             style: TextStyle(
                               fontSize: FontSize.s16,
                               fontWeight: FontWeight.bold,
                               color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR,
                             ),
                           )
                     ],
                   ),
                      SizedBox(
                        height: 8,
                      ),],
                    if(_isFinished&&_showButtons)Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.isArabic ? "اختر أدناه :" : "Choose below :",
                          style: TextStyle(
                            fontSize: FontSize.s16,
                            fontWeight: FontWeight.bold,
                            color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ClickableWidget(
                                onTap: (){
                                  setState(() {
                                    _showButtons = false;
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 45,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: AppColors.PRIMARY_COLOR,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: AppColors.PRIMARY_COLOR)
                                  ),
                                  child: Text(
                                    context.isArabic ? "الاستمرار في الانتظار" : "Still await",
                                    style: const TextStyle(
                                      fontSize: FontSize.s16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ClickableWidget(
                                onTap: (){
                                  showFinalizeTripDialog(context: context,onComplete: (){
                                    widget.onFinalizeTrip();
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 45,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: AppColors.SECONDARY_COLOR,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: AppColors.SECONDARY_COLOR)
                                  ),
                                  child: Text(
                                    context.isArabic ? "إنهاء" : "Complete",
                                    style: const TextStyle(
                                      fontSize: FontSize.s16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                      ],
                    ),

                    GestureDetector(
                      onTap: ()=>widget.onReport(),
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: context.isDarkMode?AppColors.GREY_DARK_COLOR:Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: context.isDarkMode?AppColors.GREY_DARK_COLOR:AppColors.PRIMARY_COLOR)
                        ),
                        child: Text(
                          context.isArabic ? "تقرير العميل" : "Report Client",
                          style: TextStyle(
                            fontSize: FontSize.s16,
                            fontWeight: FontWeight.bold,
                            color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR_DARK,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                        context.isArabic ? "رحلتك الحالية" : "Your Current Ride",
                        style: TextStyle(
                          fontSize: FontSize.s16,
                          fontWeight: FontWeight.bold,
                          color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    LocationInfoWidget(
                      from: widget.activeTrip?.from??'',
                      to: widget.activeTrip?.to??'',
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      context.isArabic ? "أدخل رمز التحقيق" : "Enter OTP Code",
                      style: TextStyle(
                        fontSize: FontSize.s16,
                        fontWeight: FontWeight.bold,
                        color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR,
                      ),
                    ),
                    Text(
                      context.isArabic ? "سوف تحصل على الرمز من العميل" : "You will get it from the client",
                      style: const TextStyle(
                        fontSize: FontSize.s12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.SECONDARY_COLOR,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    PinCodeTextField(
                      // onTap: () => _showOtpBottomSheet(context),
                      // readOnly: true,
                      appContext: context,
                      length: 6,
                      controller: otpController,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeColor: context.isDarkMode
                            ? Colors.white
                            : AppColors.PRIMARY_COLOR,
                        inactiveColor: Colors.grey,
                        selectedColor: context.isDarkMode
                            ? Colors.white
                            : AppColors.PRIMARY_COLOR,
                      ),
                      animationDuration:
                      const Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: false,
                      onCompleted: (value) {
                        widget.onPressed(otpController.text);
                      },
                      onChanged: (value) {},
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return context.isArabic?'يرجى إدخال رمز التحقيق المكون من 6 أرقام':'Please enter a 6-digit code';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: ()=>openGoogleMapsWithDirections(
                              startLat: widget.activeTrip?.startCoordinates?[1]??0.0,
                              startLng: widget.activeTrip?.startCoordinates?[0]??0.0,
                              targetLat: widget.activeTrip?.targetCoordinates?[1]??0.0,
                              targetLng: widget.activeTrip?.targetCoordinates?[0]??0.0,
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: AppColors.PRIMARY_COLOR,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.PRIMARY_COLOR)
                              ),
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
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClickableWidget(
                            onTap: (){
                              if(formKey.currentState!.validate()){
                                widget.onPressed(otpController.text);
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: AppColors.SECONDARY_COLOR,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.SECONDARY_COLOR)
                              ),
                              child: Text(
                                context.isArabic ? "بدء" : "Start",
                                style: const TextStyle(
                                  fontSize: FontSize.s16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: context.isDarkMode?AppColors.GREY_DARK_COLOR:Colors.grey[100],
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline,
                                color:context.isDarkMode?AppColors.whiteColor: Colors.black54),
                            SizedBox(width: 5),
                            Text(
                              "${context.isArabic?'وقت الرحلة':"Travel time"}: ~${widget.activeTrip?.duration??''} ${context.isArabic?"دقيقة":"min"}. ${context.isArabic?"مسافة":"Distance"}: ${((widget.activeTrip?.distance??0) / 1000).toStringAsFixed(1)} ${LocaleKeys.KM.tr()}.",
                              style: TextStyle(
                                  color: context.isDarkMode?AppColors.whiteColor:Colors.black54, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClickableWidget(
                        onTap: (){
                          showCancelTripDialog(
                              context: context,
                              isChangedMindReason: _isChangedMindReason,
                              onSelectChangedMindReason: () {
                                setState(() {
                                  _isClientNotShownReason = false;
                                  _isChangedMindReason = !_isChangedMindReason;
                                  _isOtherReason = false;
                                });
                              },
                              isClientNotShownReason: _isClientNotShownReason,
                              onSelectClientNotShownReason: () {
                                setState(() {
                                  _isClientNotShownReason = !_isClientNotShownReason;
                                  _isChangedMindReason = false;
                                  _isOtherReason = false;
                                });
                              },
                              isOtherReason: _isOtherReason,
                              onSelectOtherReason: () {
                                setState(() {
                                  _isClientNotShownReason = false;
                                  _isChangedMindReason = false;
                                  _isOtherReason = !_isOtherReason;
                                });
                              },
                              onCancelTrip: (CancelTripByRiderUseCaseParams params)=>widget.onCancelTrip(params)
                          );
                        },
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: context.isDarkMode?AppColors.GREY_DARK_COLOR:Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          LocaleKeys.cancelTheRide.localize,
                          style: TextStyle(
                            fontSize: FontSize.s16,
                            fontWeight: FontWeight.w500,
                            color: context.isDarkMode?AppColors.whiteColor:AppColors.SECONDARY_COLOR,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                Text(
                    context.isArabic?'لماذا تريد الغاء الرحلة':'Why do you want to cancel ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: FontSize.s16,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                    )),
                const SizedBox(height: 20),
                ClickableWidget(
                  onTap: () {
                    cubit.changeReasonSelection(isClientNotShown: true);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: context.isDarkMode?AppColors.GREY_DARK_COLOR:Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: state.isClientNotShownReason == true ? Border.all(color: AppColors.SECONDARY_COLOR_DARK2) : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: context.isDarkMode?AppColors.whiteColor:Colors.black54),
                        SizedBox(width: 5),
                        Text(
                          context.isArabic ? "لم يظهر العميل" : "The client did not show up",
                          style: TextStyle(color: context.isDarkMode?AppColors.whiteColor:Colors.black54, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ClickableWidget(
                  onTap: () {
                    cubit.changeReasonSelection(isChangedMind: true);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: context.isDarkMode?AppColors.GREY_DARK_COLOR:Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: state.isChangedMindReason == true ? Border.all(color: AppColors.SECONDARY_COLOR_DARK2) : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: context.isDarkMode?AppColors.whiteColor:Colors.black54),
                        SizedBox(width: 5),
                        Text(
                          context.isArabic ? "لقد قمت بتغيير رأيي" : "I changed my mind",
                          style: TextStyle(color:context.isDarkMode?AppColors.whiteColor: Colors.black54, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ClickableWidget(
                  onTap: () {
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
                        Icon(Icons.info_outline, color:context.isDarkMode?AppColors.whiteColor: Colors.black54),
                        SizedBox(width: 5),
                        Text(
                          context.isArabic ? "أخري" : "Other",
                          style: TextStyle(color: context.isDarkMode?AppColors.whiteColor:Colors.black54, fontSize: 14),
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
                          context.pop();
                          // cubit
                        }),
                    const SizedBox(width: 16),
                    AppButton(
                        width: context.screenWidth / 3.4,
                        label: context.isArabic ? 'تأكيد' : 'Confirm',
                        backColor: AppColors.PRIMARY_COLOR,
                        onPressed: () async {
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

  showFinalizeTripDialog({
    required BuildContext context,
    required Function onComplete,
  }) {
    showCustomDialogTrip(
        context,
        Column(
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
            const SizedBox(height: 12),
            Text(
              context.isArabic?'سوف تكمل الرحلة':'You will complete the trip',
              style: TextStyle(
                fontSize: 16,
                color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                      context.pop();
                      // cubit
                    }),
                const SizedBox(width: 16),
                AppButton(
                    width: context.screenWidth / 3.4,
                    label: context.isArabic ? 'تأكيد' : 'Confirm',
                    backColor: AppColors.PRIMARY_COLOR,
                    onPressed: () {
                      context.pop();
                      onComplete();
                    }),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ));
  }
}
