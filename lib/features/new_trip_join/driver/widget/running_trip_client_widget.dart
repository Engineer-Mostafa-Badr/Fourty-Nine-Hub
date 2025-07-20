import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/constants/constants.dart';
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
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class RunningTripClientWidget extends StatefulWidget {
  const RunningTripClientWidget({
    super.key,
    required this.client,
    this.index,
    required this.onPickClient,
    required this.onDriverArrived,
    required this.onClientNotShown,
  });

  final BookingClientEntity? client;
  final int? index;
  final Function(String otp) onPickClient;
  final Function() onDriverArrived;
  final Function() onClientNotShown;

  @override
  State<RunningTripClientWidget> createState() => _RunningTripClientWidgetState();
}

class _RunningTripClientWidgetState extends State<RunningTripClientWidget> {
  final TextEditingController otpController = TextEditingController();


  Timer? _countdownTimer;
  Duration? remainingTime;

  void checkAndStartTimer() {
    final String? arrivalTimeStr = widget.client?.driverArrivalTime;
    final String? waitingTimeStr = widget.client?.driverWaitingTime;
    final DateTime now = DateTime.now();

    if (arrivalTimeStr != null && arrivalTimeStr.isNotEmpty) {
      setState(() => context.read<CaptainShareDashboardCubit>().isGoingToClient = false);

      if (waitingTimeStr != null && waitingTimeStr.isNotEmpty) {
        DateTime waitingTime = DateTime.parse(waitingTimeStr).toLocal();
        bool isSameDay = waitingTime.year == now.year &&
            waitingTime.month == now.month &&
            waitingTime.day == now.day;

        if (isSameDay && waitingTime.isAfter(now)) {
          final durationUntilWait = waitingTime.difference(now);
          startCountdownTimer(durationUntilWait);
          setState(() => context.read<CaptainShareDashboardCubit>().showArrived = false);
          setState(() => context.read<CaptainShareDashboardCubit>().showClientNotShown = false);
          return;
        }else{
          setState(() => context.read<CaptainShareDashboardCubit>().showClientNotShown = false);
          setState(() => context.read<CaptainShareDashboardCubit>().showEndTrip = true);
          return;
        }
      }

      DateTime arrivalTime = DateTime.parse(arrivalTimeStr).toLocal();
      log('arrivalTimeConverted $arrivalTime');
      DateTime arrivalDeadline = arrivalTime.add(const Duration(minutes: 5));

      if (arrivalDeadline.isAfter(now)) {
        setState(() => context.read<CaptainShareDashboardCubit>().showArrived = false);
        setState(() => context.read<CaptainShareDashboardCubit>().showClientNotShown = false);
        final Duration countdown = arrivalDeadline.difference(now);
        startCountdownTimer(countdown);
      } else {
        setState(() => context.read<CaptainShareDashboardCubit>().showClientNotShown = true);
      }
    } else {
      setState(() => context.read<CaptainShareDashboardCubit>().isGoingToClient = true);
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


  void startCountdownTimer(Duration duration) {
    remainingTime = duration;

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        if (remainingTime!.inSeconds > 1) {
          remainingTime = remainingTime! - const Duration(seconds: 1);
        } else {
          timer.cancel();
          remainingTime = null;
          context.read<CaptainShareDashboardCubit>().showClientNotShown = true;
        }
      });
    });
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("widget.client?.driverWaitingTime ${widget.client?.driverWaitingTime}");
    print("widget.client?.driverArrivalTime ${widget.client?.driverArrivalTime}");
    return Column(
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

        if (remainingTime != null)
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
                  if (context.read<CaptainShareDashboardCubit>().isGoingToClient) {
                    setState(() {
                      context.read<CaptainShareDashboardCubit>().isGoingToClient = false;
                      context.read<CaptainShareDashboardCubit>().showArrived = true;
                    });
                  } else {
                    if (context.read<CaptainShareDashboardCubit>().showArrived) {
                      widget.onDriverArrived();
                    }
                    if (context.read<CaptainShareDashboardCubit>().showArrived==false && context.read<CaptainShareDashboardCubit>().isGoingToClient==false) {
                      if(context.read<CaptainShareDashboardCubit>().showClientNotShown||remainingTime!=null){
                        if (otpController.text.length == 6) {
                          widget.onPickClient(otpController.text);
                        }
                        if(otpController.text.length<6){
                          showErrorMessage(context,context.isArabic?'يرجى إدخال كود التأكيد':'Please Enter OTP');
                        }
                      }else if(context.read<CaptainShareDashboardCubit>().showClientNotShown==false&&remainingTime==null){
                        widget.onPickClient('');
                      }
                    }
                  }
                },
                child: Container(
                  height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.read<CaptainShareDashboardCubit>().isGoingToClient ? AppColors.PRIMARY_COLOR : AppColors.SECONDARY_COLOR,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
    context.read<CaptainShareDashboardCubit>().showClientNotShown==false&&remainingTime==null?
                    (context.isArabic ? "انهاء الرحله" : "End Trip"):
                    context.read<CaptainShareDashboardCubit>().isGoingToClient
                        ? (context.isArabic
                        ? "الذهاب الي العميل ${widget.index == 0 ? 'الاول' : widget.index == 1 ? 'الثاني' : 'الثالث'}"
                        : "Go To ${widget.index == 0 ? 'First' : widget.index == 1 ? 'Second' : 'Third'} Client")
                        : context.read<CaptainShareDashboardCubit>().showArrived
                        ? (context.isArabic ? "انا وصلت" : "I'm Arrived")
                        : (context.isArabic ? "بدء" : "Start"),
                    style: const TextStyle(
                      fontSize: FontSize.s16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 25.h),
            Expanded(
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
          ],
        ),
        SizedBox(height: (context.read<CaptainShareDashboardCubit>().isGoingToClient ? 15 : 25).h),

        if (!context.read<CaptainShareDashboardCubit>().isGoingToClient && !context.read<CaptainShareDashboardCubit>().showArrived)
          Row(
            children: [
              Expanded(
                child: CallMessageButtons(
                  flex: 1,
                  chatFlex: 1,
                  otherUserId: '',
                  subcategoryId: 'Constants',
                  phone: 'widget.item.phone',
                  id: 'widget.item.id',
                  hasReport: false,
                ),
              ),
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
        SizedBox(height: 15.h),

        if (!context.read<CaptainShareDashboardCubit>().isGoingToClient && !context.read<CaptainShareDashboardCubit>().showArrived &&!context.read<CaptainShareDashboardCubit>().showEndTrip)
          PinCodeTextField(
            appContext: context,
            length: 6,
            controller: otpController,
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
            enabled: context.read<CaptainShareDashboardCubit>().showClientNotShown||remainingTime!=null,
            onCompleted: (value) => widget.onPickClient(value),
            onChanged: (value) {},
            validator: (value) {
              if (value == null || value.length < 6) {
                return context.isArabic
                    ? 'يرجى إدخال رمز التحقيق المكون من 6 أرقام'
                    : 'Please enter a 6-digit code';
              }
              return null;
            },
          ),

        if (context.read<CaptainShareDashboardCubit>().showClientNotShown)
          GestureDetector(
            onTap: (){
              widget.onClientNotShown();
            },
            child: Container(
              width: double.infinity,
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.PRIMARY_COLOR),
              ),
              child: Text(
                context.isArabic ? "لم يظهر العميل" : "Client not show",
                style: const TextStyle(
                  fontSize: FontSize.s16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.PRIMARY_COLOR,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
