import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../core/utils/format_numbers.dart';
import '../../../../../core/widget/clickable_widget.dart';
import 'custom_wave_painter.dart';
import 'font_manager.dart';

class BottomRideStatusWidget extends StatefulWidget {
  final int price;
  final String? fromLocation;
  final String? toLocation;
  final String? wayPointOne;
  final String? wayPointTwo;
  final VoidCallback onGoogleMap;
  final VoidCallback onPartialPayment;
  final VoidCallback onCallEmergency;
  final VoidCallback onCancelRide;
  final String? paymentMethod;
  final String? otp;

  final bool isRecording;
  final String audioDuration;
  final VoidCallback onMicTap;
  final bool isStarted;

  final Function onStartRecord;
  final Function onStopRecord;

  const BottomRideStatusWidget({
    super.key,
    required this.price,
    required this.fromLocation,
    required this.wayPointOne,
    required this.wayPointTwo,
    required this.toLocation,
    required this.onGoogleMap,
    required this.onPartialPayment,
    required this.onCallEmergency,
    required this.onCancelRide,
    required this.isRecording,
    required this.audioDuration,
    required this.onMicTap,
    required this.paymentMethod,
    required this.otp,
    required this.isStarted,
    required this.onStartRecord,
    required this.onStopRecord,
  });

  @override
  State<BottomRideStatusWidget> createState() => _BottomRideStatusWidgetState();
}

class FakeRecordingWaveform extends StatefulWidget {
  const FakeRecordingWaveform({super.key});

  @override
  State<FakeRecordingWaveform> createState() => _FakeRecordingWaveformState();
}

class _BottomRideStatusWidgetState extends State<BottomRideStatusWidget> {
  bool _isRecording = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDarkMode
            ? AppColors.QUANTITY_COLOR
            : AppColors.whiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.isArabic ? "الدفع" : "Payment",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.payments_outlined,
                color: Colors.green,
                size: 14,
              ),
              const SizedBox(width: 8),
              Text(
                widget.paymentMethod == 'cash'
                    ? context.isArabic
                        ? '${FormatNumbers().convertNumberToLocalizedString(widget.price.toString(), isArabic: context.isArabic)}ج.م نقدا'
                        : 'EGP ${FormatNumbers().convertNumberToLocalizedString(widget.price.toString(), isArabic: context.isArabic)} Cash'
                    : context.isArabic
                        ? '${FormatNumbers().convertNumberToLocalizedString(widget.price.toString(), isArabic: context.isArabic)} بطاقة بنكية'
                        : 'EGP ${FormatNumbers().convertNumberToLocalizedString(widget.price.toString(), isArabic: context.isArabic)} Visa',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
              if (widget.paymentMethod == 'cash' &&
                  widget.price >= 200 &&
                  widget.isStarted)
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onPartialPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      LocaleKeys.partialPayment.localize,
                      style: const TextStyle(
                          fontSize: FontSize.s14, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.yourCurrentRide.localize,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          if (widget.fromLocation != null)
            _buildLocationRow(
              context: context,
              color: Colors.green,
              location: widget.fromLocation!,
            ),
          if (widget.wayPointOne != null)
            _buildLocationRow(
              context: context,
              color: Colors.red,
              location: widget.wayPointOne!,
            ),
          if (widget.wayPointTwo != null)
            _buildLocationRow(
              context: context,
              color: Colors.blue,
              location: widget.wayPointTwo!,
            ),
          if (widget.toLocation != null)
            _buildLocationRow(
              context: context,
              color: Colors.blue,
              location: widget.toLocation!,
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.isArabic ? "رمز التحقق" : "Your OTP Code",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.otp != null)
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                children: [
                  ...widget.otp!.split("").map(
                        (e) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 40,
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: context.isDarkMode
                                        ? Colors.white
                                        : AppColors.PRIMARY_COLOR),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                FormatNumbers().convertNumberToLocalizedString(
                                    e,
                                    isArabic: context.isArabic),
                                style: const TextStyle(
                                  fontSize: FontSize.s16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          InkWell(
            onTap: widget.onCallEmergency,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  Assets.emergencyIcon,
                  color: Colors.red,
                  width: 24,
                  height: 24,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16),
                Text(
                  context.isArabic ? "اتصل بالطوارئ" : "Call Emergency",
                  style: TextStyle(
                    color: Colors.red.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.red.shade600,
                  size: 16,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (widget.isRecording)
            ClickableWidget(
              onTap: () {
                ManageVibration.vibrate();
                if (_isRecording) {
                  setState(() {
                    _isRecording = false;
                    widget.onStopRecord();
                  });
                } else {
                  setState(() {
                    _isRecording = true;
                    widget.onStartRecord();
                  });
                }
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: _isRecording ? Colors.grey[100] : Colors.transparent,
                    borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.all(20.w),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Assets.rideRecord,
                      color: _isRecording
                          ? null
                          : context.isDarkMode
                              ? AppColors.whiteColor
                              : Colors.black,
                    ),
                    SizedBox(width: 30.w),
                    if (!_isRecording)
                      Text(context.isArabic ? 'تسجيل صوتي' : 'Record',
                          style: TextStyle(
                              fontSize: FontSize.s14,
                              fontWeight: FontWeight.bold))
                    else
                      Expanded(child: _buildWaveform()),
                  ],
                ),
              ),
            ),
          if (widget.isStarted)
            Text(
                context.isArabic
                    ? 'اخر تسجيل صوتي فقط سيتم الاحتفاظ به'
                    : 'The last record only will be saved',
                style: TextStyle(
                    fontSize: FontSize.s12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.SECONDARY_COLOR)),

          // ClickableWidget(
          //   onTap: () {
          //     if (_isRecording) {
          //       setState(() {
          //
          //       });
          //     } else {
          //       setState(() {
          //
          //       });
          //     }
          //   },
          //   child: Container(
          //     height: 40,
          //     decoration: BoxDecoration(color: _isRecording ? Colors.grey[100] : Colors.transparent, borderRadius: BorderRadius.circular(12)),
          //     padding: EdgeInsets.all(20.w),
          //     child: Row(
          //       children: [
          //         SvgPicture.asset(
          //           Assets.rideRecord,
          //           color: _isRecording ? null : Colors.black,
          //         ),
          //         SizedBox(width: 30.w),
          //         // if (!_isRecording)  Text(context.isArabic ? "تسجيل الصوت": 'Record', style: const TextStyle(fontSize: FontSize.s14, fontWeight: FontWeight.bold)) else const Expanded(child: FakeRecordingWaveform())
          //
          //       ],
          //     ),
          //   ),
          // ),

          const SizedBox(height: 16),
          // Cancel Button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: widget.onCancelRide,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: context.isDarkMode
                    ? AppColors.PRIMARY_COLOR_DARK
                    : const Color(0xFFF5F5F5), // Light gray background
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30), // More rounded corners
                ),
              ),
              child: Text(
                LocaleKeys.cancelOrder.localize,
                style: TextStyle(
                  fontSize: 18,
                  color: context.isDarkMode
                      ? AppColors.whiteColor
                      : Colors.red, // Red text color
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioRow(BuildContext context) {
    const Color navyColor = Color(0xFF0D1730);

    return Row(
      children: [
        InkWell(
          onTap: widget.onMicTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: navyColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.isRecording ? Icons.stop : Icons.mic,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
              height: 40,
              child: AudioWaveWidget(
                isRecording: widget.isRecording,
                barCount: 40,
                barWidth: 4,
                spacing: 2,
                barColor: Colors.blueAccent,
              )),
        ),
        const SizedBox(width: 8),
        Text(
          widget.audioDuration,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildLocationRow({
    required BuildContext context,
    required Color color,
    required String location,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              location,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveform() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(20, (index) {
        final height = (index % 5 + 1) * 4.0;
        return Container(
          width: 3,
          height: height,
          margin: EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}

class _FakeRecordingWaveformState extends State<FakeRecordingWaveform> {
  final Random _random = Random();
  final int _barCount = 30;
  List<double> _heights = [];
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_barCount, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 3,
              height: _heights[index],
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _generateFakeWave();
    _timer = Timer.periodic(const Duration(milliseconds: 120), (_) {
      setState(() {
        _generateFakeWave();
      });
    });
  }

  void _generateFakeWave() {
    _heights = List.generate(_barCount, (_) => _random.nextDouble() * 60 + 10);
  }
}
