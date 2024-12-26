import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/requests_history/data/models/shipping_request_model/shipping_request_model.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class ShippingRequestCard extends StatelessWidget {
  final ShippingRequestModel trip;
  const ShippingRequestCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Row(
            children: [
              Text(
                formatDate(
                    trip.createdAt, context.isArabic ? "arabic" : "english"),
                style: Styles.headerText(fontSize: 30),
              ),
              Spacer(),
              Text(
                "${trip.price}${context.isArabic ? trip.currencyAr : trip.currencyEn}",
                style: Styles.headerText(fontSize: 30),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: Column(
            children: [
              const Sizer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 4,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(trip.fromAddress,
                            overflow: TextOverflow.visible,
                            maxLines: 1,
                            style: Styles.mediumText(
                                fontSize: 32, fontWeight: FontWeight.w400)),
                      ),
                    ],
                  ),
                  SizedBox(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 6, right: 6),
                        child: Container(
                          height: 14,
                          child: CustomPaint(
                            size: Size(1, 14),
                            painter: DottedLinePainter(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 4,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(trip.toAddress,
                            overflow: TextOverflow.visible,
                            maxLines: 1,
                            style: Styles.mediumText(
                                fontSize: 32, fontWeight: FontWeight.w400)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const Sizer(
          height: 24,
        ),
        Divider(
          height: 2,
          color: AppColors.LIGHT_GRAY_COLOR,
        )
      ],
    );
  }
}

String formatDate(String dateString, String language) {
  DateTime date = DateTime.parse(dateString);

  final DateFormat formatter = language == "arabic"
      ? DateFormat("d MMMM, h:mm a", "ar_SA")
      : DateFormat("d MMMM, h:mm a");

  String formattedDate = formatter.format(date);

  return formattedDate;
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 189, 193, 196)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    double dashWidth = 2;
    double dashSpace = 3.0;
    double startX = 0.0;

    while (startX < size.height) {
      canvas.drawLine(
        Offset(0, startX),
        Offset(0, startX + dashWidth),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
