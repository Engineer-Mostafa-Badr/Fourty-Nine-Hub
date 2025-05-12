import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import 'custom_wave_painter.dart';
import 'font_manager.dart';

class BottomRideStatusWidget extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    const Color navyColor = Color(0xFF0D1730);
    // const Color redColor = Color(0xFFFF4C4C);
    final Color greyTextColor = Colors.grey.shade600;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
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
                paymentMethod == 'cash'
                    ? context.isArabic
                        ? 'الدفع $price كاش'
                        : 'EGP $price Cash'
                    : context.isArabic
                        ? 'الدفع $price فيزا'
                        : 'EGP $price Visa',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onPartialPayment,
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
          if (fromLocation != null)
            _buildLocationRow(
              context: context,
              color: Colors.green,
              location: fromLocation!,
            ),
          if (wayPointOne != null)
            _buildLocationRow(
              context: context,
              color: Colors.red,
              location: wayPointOne!,
            ),
          if (wayPointTwo != null)
            _buildLocationRow(
              context: context,
              color: Colors.blue,
              location: wayPointTwo!,
            ),
          if (toLocation != null)
            _buildLocationRow(
              context: context,
              color: Colors.blue,
              location: toLocation!,
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.isArabic? "كود التحقق" : "Your OTP Code",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if(otp != null)
            Row(
              children: [
                ...otp!.split("").map((e) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 40,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        e,
                        style: const TextStyle(
                          fontSize: FontSize.s16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),),
              ],
            ),
          InkWell(
            onTap: onCallEmergency,
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
          // Cancel Button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onCancelRide,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: context.isDarkMode ? const Color(0xff2C2C2C) : const Color(0xFFF5F5F5), // Light gray background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // More rounded corners
                ),
              ),
              child: Text(
                LocaleKeys.cancelOrder.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.red, // Red text color
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildAudioRow(BuildContext context) {
    const Color navyColor = Color(0xFF0D1730);

    return Row(
      children: [
        InkWell(
          onTap: onMicTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: navyColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isRecording ? Icons.stop : Icons.mic,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
              height: 40,
              child: AudioWaveWidget(
                isRecording: isRecording,
                barCount: 40,
                barWidth: 4,
                spacing: 2,
                barColor: Colors.blueAccent,
              )),
        ),
        const SizedBox(width: 8),
        Text(
          audioDuration,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
