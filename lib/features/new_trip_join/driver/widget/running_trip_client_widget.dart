import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/enums/route_client_enum.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/widget/call_message_buttons.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/controllers/captain_share_dashboard_cubit/captain_share_dashboard_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:url_launcher/url_launcher.dart';

class RunningTripClientWidget extends StatefulWidget {
  const RunningTripClientWidget({
    super.key,
    required this.client,
    this.index,
    required this.onPickClient,
    required this.onDropOffClient,
    required this.onDriverArrived,
    required this.onClientNotShown,
  });

  final BookingClientEntity? client;
  final int? index;
  final Function(String otp) onPickClient;
  final Function() onDropOffClient;
  final Function() onDriverArrived;
  final Function() onClientNotShown;

  @override
  State<RunningTripClientWidget> createState() => _RunningTripClientWidgetState();
}

class _RunningTripClientWidgetState extends State<RunningTripClientWidget> {
  Timer? _countdownTimer;
  Duration? remainingTime;
  String otp = '';
  bool isLoadingRunningTrip = false;
  bool isGoingToClient = false;
  bool showArrived = false;
  bool showClientNotShown = false;
  bool showEndTrip = false;


  void checkAndStartTimer() {
    setState(() => showEndTrip = false);
    final String? arrivalTimeStr = widget.client?.driverArrivalTime;
    final String? waitingTimeStr = widget.client?.driverWaitingTime;
    final DateTime now = DateTime.now();

    if (arrivalTimeStr != null && arrivalTimeStr.isNotEmpty) {
      setState(() => isGoingToClient = false);

      if (waitingTimeStr != null && waitingTimeStr.isNotEmpty) {
        DateTime waitingTime = DateTime.parse(waitingTimeStr).toLocal();
        bool isSameDay = waitingTime.year == now.year && waitingTime.month == now.month && waitingTime.day == now.day;

        if (isSameDay && waitingTime.isAfter(now)) {
          final durationUntilWait = waitingTime.difference(now);
          startCountdownTimer(durationUntilWait, showClientNotShownWhenFinished: false,from: 'waiting');
          setState(() => showArrived = false);
          setState(() => showClientNotShown = false);
          return;
        } else {
          print("object313");
          setState(() => showClientNotShown = false);
          setState(() => showEndTrip = true);
          return;
        }
      }

      DateTime arrivalTime = DateTime.parse(arrivalTimeStr).toLocal();
      log('arrivalTimeConverted $arrivalTime');
      DateTime arrivalDeadline = arrivalTime.add(const Duration(minutes: 5));

      if (arrivalDeadline.isAfter(now)) {
        setState(() => showArrived = false);
        setState(() => showClientNotShown = false);
        final Duration countdown = arrivalDeadline.difference(now);
        startCountdownTimer(countdown, showClientNotShownWhenFinished: true,from: 'arrival');
      } else {
        setState(() => showClientNotShown = true);
      }
    } else {
      setState(() => isGoingToClient = true);
    }
  }

  @override
  void initState() {
    super.initState();
    checkAndStartTimer();
  }

  @override
  void didUpdateWidget(covariant RunningTripClientWidget oldWidget) {
    print('didUpdateWidget');
    print('${oldWidget.client?.driverArrivalTime != widget.client?.driverArrivalTime}');
    print('${oldWidget.client?.driverArrivalTime != widget.client?.driverArrivalTime}');
    super.didUpdateWidget(oldWidget);
    checkAndStartTimer();
  }

  void startCountdownTimer(Duration duration, {bool showClientNotShownWhenFinished = true,required String from}) {
    remainingTime = duration;

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      print("widget.client?.status ${widget.client?.status}");
      if (widget.client?.status == 'pickedUp') {
        remainingTime == null;
        setState(() {});
        timer.cancel();
        return;
      }

      setState(() {
        if (remainingTime!.inSeconds > 1) {
          remainingTime = remainingTime! - const Duration(seconds: 1);
        } else {
          timer.cancel();
          remainingTime = null;
          otp='';
          if (showClientNotShownWhenFinished) {
            setState(() {
              showClientNotShown = true;
            });
          } else if (!showClientNotShownWhenFinished) {
            setState(() {
              showClientNotShown = false;
            });
          }
          if(from=='waiting'){
            setState(() {
              showEndTrip=true;
            });
          }
        }
      });
    });
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String getTripButtonTitle() {
    final isArabic = context.isArabic;
    final status = widget.client?.status;
    final index = widget.index;

    if (status == 'cancelled') {
      return isArabic ? 'تم الالغاء' : 'Cancelled';
    } else if (status == 'completed') {
      return isArabic ? 'تم التوصيل' : 'Dropped Off';
    } else if (isGoingToClient) {
      String clientOrder;
      if (index == 0) {
        clientOrder = isArabic ? 'الاول' : 'First';
      } else if (index == 1) {
        clientOrder = isArabic ? 'الثاني' : 'Second';
      } else {
        clientOrder = isArabic ? 'الثالث' : 'Third';
      }
      return isArabic
          ? "الذهاب الي العميل $clientOrder"
          : "Go To $clientOrder Client";
    } else if (showArrived) {
      return isArabic ? "انا وصلت" : "I'm Arrived";
    } else if (showEndTrip) {
      return isArabic ? "الغاء الرحله" : "End Trip";
    } else if (status == RouteClientStatus.pickedUp.name) {
      return isArabic ? "انهاء الرحله" : "Finish Trip";
    } else {
      return isArabic ? "بدء" : "Start";
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

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.h),
      margin: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        border: Border.all(color: context.isDarkMode ? Colors.white : AppColors.black),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.transparent,
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 10,
                  child: CircleAvatar(
                    backgroundColor: AppColors.getFillColor(context),
                    radius: 5,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.client?.location.address ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          if (remainingTime != null&&widget.client?.status != 'pickedUp'&&widget.client?.status != 'cancelled'&&widget.client?.status != 'completed')
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                formatDuration(remainingTime!),
                style: const TextStyle(
                  fontSize: FontSize.s16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    print("widget.client?.status ${widget.client?.status}");
                    if(widget.client?.status == 'cancelled'|| widget.client?.status == 'completed'){
                      return;
                    }
                    if (widget.client?.status == RouteClientStatus.pickedUp.name) {
                      widget.onDropOffClient();
                      return;
                    }
                    if (isGoingToClient) {
                      setState(() {
                        isGoingToClient = false;
                        showArrived = true;
                      });
                      return;

                    } else {
                      if (showArrived) {
                        widget.onDriverArrived();
                        return;

                      }
                      if (showArrived == false && isGoingToClient == false) {
                        if (showClientNotShown || remainingTime != null) {
                          if(remainingTime == null){
                            return;
                          }
                          if (otp.length == 6) {
                            widget.onPickClient(otp);
                            return;
                          }
                          if (otp.length < 6) {
                            showErrorMessage(context, context.isArabic ? 'يرجى إدخال كود التأكيد' : 'Please Enter OTP');
                            return;
                          }
                        } else if (showClientNotShown == false && remainingTime == null) {
                          widget.onPickClient('');
                          return;

                        }
                      }
                    }
                  },
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: (widget.client?.status == 'cancelled'|| widget.client?.status == 'completed')?Colors.transparent:isGoingToClient ? AppColors.PRIMARY_COLOR : AppColors.SECONDARY_COLOR,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      getTripButtonTitle(),
                      style: TextStyle(
                        fontSize: FontSize.s16,
                        fontWeight: FontWeight.bold,
                        color: (widget.client?.status == 'cancelled'|| widget.client?.status == 'completed')?AppColors.SECONDARY_COLOR:AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: ClickableWidget(
                  onTap: (){
                    ManageVibration.vibrate();
                    // openGoogleMapsWithDirections(
                    //   startLat: widget.activeTrip?.startCoordinates?[1] ?? 0.0,
                    //   startLng: widget.activeTrip?.startCoordinates?[0] ?? 0.0,
                    //   targetLat: widget.activeTrip?.targetCoordinates?[1] ?? 0.0,
                    //   targetLng: widget.activeTrip?.targetCoordinates?[0] ?? 0.0,
                    // );
                  },
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(10),
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
            ],
          ),
          SizedBox(height: (isGoingToClient ? 0 : 25).h),
          if (!isGoingToClient && !showArrived)
            ...[Row(
              children: [
                Expanded(child: Row(
                  children: [
                    Expanded(
                      child: SvgPicture.asset(
                        Assets.phoneIcon,
                        width: 50.w,
                        height: 35.h,
                        color: AppColors.SECONDARY_COLOR,
                      ),
                    ),
                    Expanded(
                      child: SvgPicture.asset(Assets.mailIcon,
                          width: 50.w,
                          height: 30.h,
                          color: AppColors.SECONDARY_COLOR),
                    )
                  ],
                )),
                SizedBox(width: 30.w),
                Expanded(
                  child: ClickableWidget(
                    onTap: !context.read<UserCubit>().isLoggedIn
                        ? () => pleaseLoginDialog(context)
                        : () {
                            bottomSheet(
                              context: context,
                              widget: ReportView(
                                id: 'widget.id',
                                categoryId: 'widget.subcategoryId',
                              ),
                            );
                          },
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.SECONDARY_COLOR,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.SECONDARY_COLOR),
                      ),
                      child: Text(
                        context.isArabic ? "تقرير العميل" : "Report Client",
                        style: const TextStyle(
                          fontSize: FontSize.s16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          SizedBox(height: 15.h)],
          if (remainingTime != null&&widget.client?.status != 'pickedUp'&&widget.client?.status != 'cancelled'&&widget.client?.status != 'completed')
            Visibility(
              visible: !isGoingToClient && !showArrived,
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                // controller: otpController,

                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeColor: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
                  inactiveColor: Colors.grey,
                  selectedColor: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9٠-٩]')),
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: false,
                enablePinAutofill: false,
                enabled: remainingTime != null,
                onCompleted: (value) => widget.onPickClient(value),
                onChanged: (value) {
                  setState(() {
                    otp = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return context.isArabic ? 'يرجى إدخال رمز التحقيق المكون من 6 أرقام' : 'Please enter a 6-digit code';
                  }
                  return null;
                },
              ),
            ),
          if (showClientNotShown && widget.client?.status != 'pickedUp'&& widget.client?.status != 'cancelled'&& widget.client?.status != 'completed')
            GestureDetector(
              onTap: () {
                widget.onClientNotShown();
              },
              child: Container(
                width: double.infinity,
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.isDarkMode ? AppColors.GREY_DARK_COLOR : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.PRIMARY_COLOR),
                ),
                child: Text(
                  context.isArabic ? "لم يظهر العميل" : "Client not show",
                  style: TextStyle(
                    fontSize: FontSize.s16,
                    fontWeight: FontWeight.bold,
                    color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
