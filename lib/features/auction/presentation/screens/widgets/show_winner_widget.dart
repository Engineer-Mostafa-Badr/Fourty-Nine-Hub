import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:intl/intl.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/styles.dart';
import '../../../domain/entities/get_all_auction_entity.dart';
String formatNumberAuction(BuildContext context, num? number) {
  if (number == null) return "0";

  final locale = context.isArabic ? 'ar' : 'en';
  final formatter = NumberFormat.decimalPattern(locale);
  String formatted = formatter.format(number);

  if (context.isArabic) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < english.length; i++) {
      formatted = formatted.replaceAll(english[i], arabic[i]);
    }
  }

  return formatted;
}

class WinnerOverlayWidget extends StatelessWidget {
  final WinnerDataEntity winner;
  final VoidCallback onClose;

  const WinnerOverlayWidget({
    required this.winner,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    // WillPopScope catches back button or Navigator.pop
    return WillPopScope(
      onWillPop: () async {
        onClose();
        return true; // allow pop to continue
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, // detects taps outside overlay
        onTap: onClose,
        child: Stack(
          children: [
            // Transparent background to detect taps outside
            Positioned.fill(
              child: Container(color: Colors.transparent),
            ),

            // Centered overlay itself
            Center(
              child: GestureDetector(
                // prevent the inside area from triggering close tap
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Material(
                        // 🔹 Match Figma background: #0B103533
                        color:  Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        elevation: 0,
                        child: Container(
                          height: 129,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border(
                              left: BorderSide(
                                color: Colors.white.withOpacity(0.7),
                                width: 1.5,
                              ),
                              right: BorderSide(
                                color: Colors.white.withOpacity(0.7),
                                width: 1.5,
                              ),
                            ),
                            // 🔹 Two drop shadows from Figma
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black.withOpacity(0.25),
                            //     offset: const Offset(0, 4),
                            //     blurRadius: 4,
                            //     spreadRadius: 0,
                            //   ),
                            //   BoxShadow(
                            //     color: Colors.black.withOpacity(0.25),
                            //     offset: const Offset(0, 4),
                            //     blurRadius: 4,
                            //     spreadRadius: 0,
                            //   ),
                            // ],
                          ),
                          child: Stack(
                            children: [
                              // X Button
                              Positioned(
                                top: 8,
                                left: 5,
                                child: InkWell(
                                  onTap: onClose,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    // decoration: BoxDecoration(
                                    //   color: Colors.black.withOpacity(0.05),
                                    //   shape: BoxShape.circle,
                                    // ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              // Content
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            CircleAvatar(
                                              radius: 35,
                                              backgroundColor: Colors.grey.shade400,
                                              backgroundImage: (winner.profilePictureKey != null &&
                                                  winner.profilePictureKey!.isNotEmpty)
                                                  ? NetworkImage(winner.profilePictureKey!)
                                                  : const NetworkImage(
                                                "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80",
                                              ),
                                            ),
                                            Positioned(
                                              top: -25,
                                              right: -4,
                                              child: SvgPicture.asset(
                                                Assets.winnerCrown,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Flexible(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${winner.firstName ?? ''} ${winner.lastName ?? ''}".trim(),
                                              overflow: TextOverflow.ellipsis,
                                              style: Styles.headerText(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),

                                            const SizedBox(height: 4),
                                            Label(
                                              text: DateFormat('d-M-yyyy', context.isArabic ? 'ar' : 'en')
                                                  .format(winner.time ?? DateTime.now()),
                                              style: Styles.mediumText(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),

                                            const SizedBox(height: 4),
                                            // Text(
                                            //   "${NumberFormat.decimalPattern(context.isArabic ? 'ar' : 'en').format(winner.price ?? 0)} ${LocaleKeys.egp.localize}",
                                            //   style: Styles.mediumText(
                                            //     fontWeight: FontWeight.w600,
                                            //     color: Colors.white,
                                            //   ),
                                            // ),
                                            Text(
                                              "${formatNumberAuction(context,winner.price ??0)} ${LocaleKeys.egp.localize}",
                                              style: Styles.mediumText(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),


                                            Label(
                                              text:winner.title ?? "",
                                              style: Styles.mediumText(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}