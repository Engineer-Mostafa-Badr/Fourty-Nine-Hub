import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import 'custom_wave_painter.dart';
import 'font_manager.dart';

class BottomRideStatusWidget extends StatelessWidget {
  final int price;
  final String fromLocation;
  final String toLocation;
  final VoidCallback onGoogleMap;
  final VoidCallback onPartialPayment;
  final VoidCallback onCallEmergency;
  final VoidCallback onCancelRide;

  final bool isRecording;
  final String audioDuration;
  final VoidCallback onMicTap;

  const BottomRideStatusWidget({
    super.key,
    required this.price,
    required this.fromLocation,
    required this.toLocation,
    required this.onGoogleMap,
    required this.onPartialPayment,
    required this.onCallEmergency,
    required this.onCancelRide,
    required this.isRecording,
    required this.audioDuration,
    required this.onMicTap,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.payments_outlined,
                color: Colors.green,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'EGP $price Cash',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onPartialPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:  Text(
                    LocaleKeys.partialPayment.localize,
                    style: const TextStyle(fontSize: FontSize.s14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            LocaleKeys.yourCurrentRide.localize,
            style: TextStyle(
              color: greyTextColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),

          _buildLocationRow(
            context: context,
            color: Colors.green,
            location: fromLocation,
          ),
          const SizedBox(height: 8),
          _buildLocationRow(
            context: context,
            color: Colors.red,
            location: toLocation,
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onGoogleMap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navyColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:  Text(
                    LocaleKeys.openGoogleMap.localize,
                    style:  const TextStyle(fontSize: FontSize.s14),
                  ),
                ),
              ),
              // const SizedBox(width: 8),

            ],
          ),
          const SizedBox(height: 16),

          InkWell(
            onTap: onCallEmergency,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(Assets.emergencyIcon,color: Colors.red,height: 30,),
                const SizedBox(width: 8),
                Text(
                  LocaleKeys.call_emergency.localize,
                  style: TextStyle(
                    color: Colors.red.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _buildAudioRow(context),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(LocaleKeys.cancelTheRide.localize,style:const TextStyle(
              fontSize: FontSize.s16,
              fontWeight: FontWeight.bold,
              color: AppColors.PRIMARY_COLOR_DARK,
            ),),
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
    return Row(
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

