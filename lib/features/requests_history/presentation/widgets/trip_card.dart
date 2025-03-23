import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/dynamic_map_test.dart';
import 'package:fourtyninehub/features/requests_history/data/models/request_history_ride_model.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class TripCard extends StatelessWidget {
  final RequestHistoryRideModel trip;

  const TripCard({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isDismissible: false,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        color: context.isDarkMode
                            ? AppColors.DARK_BLUE_COLOR.withOpacity(0.95)
                            : AppColors.LIGHT_COLOR,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 24, horizontal: 16),
                          child: Column(
                            children: [
                              Row(children: [
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(Icons.arrow_back_ios)),
                                const Spacer(),
                                Text(
                                  formatDate(trip.createdAt!,
                                      context.isArabic ? "arabic" : "english"),
                                  style: Styles.headerText(fontSize: 30),
                                ),
                                const Spacer()
                              ]),
                              const Sizer(
                                height: 30,
                              ),
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24)),
                                child: const DynamicMapWithPolyline(
                                  // polylineString: "",
                                  // BlocProvider.of<GetTripInfoCubit>(context).polyLine,
                                  useGoogleMaps: true,
                                  url:
                                      "https://maps.googleapis.com/maps/api/js?key=AIzaSyBBHEFa7D7qMSL4ivZhCqRQ4ok4sQN-Egc",
                                  apiKey:
                                      "AIzaSyBBHEFa7D7qMSL4ivZhCqRQ4ok4sQN-Egc",
                                ),
                              ),
                              const Sizer(
                                height: 30,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                              color:
                                                  Colors.blue.withOpacity(0.5),
                                              spreadRadius: 3,
                                              blurRadius: 4,
                                              offset: const Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Text(trip.fromAddress ?? "",
                                            overflow: TextOverflow.visible,
                                            maxLines: 1,
                                            style: Styles.mediumText(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                      const Spacer(),
                                      Text(formatTimeClock(
                                          trip.startTime, context))
                                    ],
                                  ),
                                  const SizedBox(height: 1),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 6, right: 6),
                                        child: SizedBox(
                                          height: 14,
                                          child: CustomPaint(
                                            size: const Size(1, 14),
                                            painter: DottedLinePainter(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 1),
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
                                              color:
                                                  Colors.green.withOpacity(0.5),
                                              spreadRadius: 3,
                                              blurRadius: 4,
                                              offset: const Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Text(trip.toAddress ?? "",
                                            overflow: TextOverflow.visible,
                                            maxLines: 1,
                                            style: Styles.mediumText(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                      const Spacer(),
                                      Text(formatTimeClockEnd(trip.startTime,
                                          context, trip.duration ?? 0))
                                    ],
                                  ),
                                  const Sizer(height: 36),
                                  trip.duration != null
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.schedule),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  context.isArabic
                                                      ? "المدة"
                                                      : "Duration",
                                                  style: Styles.mediumText(
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .GREY_DARK_COLOR),
                                                ),
                                                Text(
                                                  formatDuration(
                                                      trip.duration ?? 0,
                                                      context),
                                                  style: Styles.mediumText(
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                    Icons.pin_drop_outlined),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      context.isArabic
                                                          ? "المسافة"
                                                          : "Distance",
                                                      style: Styles.mediumText(
                                                          fontSize: 32,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColors
                                                              .GREY_DARK_COLOR),
                                                    ),
                                                    Text(
                                                      formatDistance(
                                                          trip.distance ?? 0,
                                                          context),
                                                      style: Styles.mediumText(
                                                          fontSize: 32,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                      : const SizedBox(),
                                  // const Spacer(),

                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Divider(
                                      height: 1,
                                      color: AppColors.GREY_DARK_COLOR,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.network(
                                                  trip.socketDriverImage ??
                                                      trip.noSocketDriverImage ??
                                                      "",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      trip.socketfirstName ??
                                                          trip.noSocketfirstName ??
                                                          "",
                                                      style: Styles.mediumText(
                                                          fontSize: 32,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      trip.socketLastName ??
                                                          trip.noSocketLastName ??
                                                          "",
                                                      style: Styles.mediumText(
                                                          fontSize: 32,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  child: Text(
                                                    "${trip.carModelSocket ?? trip.carModelNoSocket ?? ""} , ${trip.plateInfoSocket ?? trip.platInfoNoSocket ?? ""}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: Styles.mediumText(
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .DARK_GRAY_COLOR,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Divider(
                                      height: 1,
                                      color: AppColors.GREY_DARK_COLOR,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(context.isArabic ? "أنا دفعت" : "I paid",
                                      style: Styles.headerText()),
                                  const Spacer()
                                ],
                              ),
                              const Sizer(
                                height: 36,
                              ),
                              Row(
                                children: [
                                  Text(context.isArabic ? "أجرة" : "Fare",
                                      style: Styles.headerText(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                  Text(
                                    "${trip.price}${context.isArabic ? trip.currencyAr : trip.currencyEn}",
                                    style: Styles.headerText(fontSize: 30),
                                  ),
                                ],
                              ),
                              const Sizer(
                                height: 16,
                              ),
                              Row(
                                children: [
                                  Text(
                                      context.isArabic
                                          ? "التكلفة المدفوعة"
                                          : "Total paid",
                                      style: Styles.headerText(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                  Text(
                                    "${trip.price}${context.isArabic ? trip.currencyAr : trip.currencyEn}",
                                    style: Styles.headerText(fontSize: 30),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              );
            });
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Row(
                children: [
                  Text(
                    formatDate(trip.createdAt!,
                        context.isArabic ? "arabic" : "english"),
                    style: Styles.headerText(fontSize: 30),
                  ),
                  const Spacer(),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Sizer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                      offset: const Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(trip.fromAddress ?? "",
                                    overflow: TextOverflow.visible,
                                    maxLines: 1,
                                    style: Styles.mediumText(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 6, right: 6),
                                child: SizedBox(
                                  height: 14,
                                  child: CustomPaint(
                                    size: const Size(1, 14),
                                    painter: DottedLinePainter(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 1),
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
                                      offset: const Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(trip.toAddress ?? "",
                                    overflow: TextOverflow.visible,
                                    maxLines: 1,
                                    style: Styles.mediumText(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 22,
                    color: AppColors.LIGHT_GRAY_COLOR2,
                  ),
                ],
              ),
            ),
            const Sizer(
              height: 24,
            ),
            const Divider(
              height: 2,
              color: AppColors.LIGHT_GRAY_COLOR,
            )
          ],
        ),
      ),
    );
  }
}

String formatDistance(int meters, BuildContext context) {
  if (meters >= 1000) {
    double kilometers = meters / 1000;
    return context.isArabic
        ? '${kilometers.toStringAsFixed(2)} كم'
        : '${kilometers.toStringAsFixed(2)} km';
  } else {
    return context.isArabic ? '$meters م' : '$meters m';
  }
}

String formatDuration(int totalSeconds, BuildContext context) {
  if (totalSeconds >= 3600) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    return context.isArabic ? '$hours س, $minutes د' : '$hours h, $minutes min';
  } else if (totalSeconds >= 60) {
    int minutes = totalSeconds ~/ 60;
    return context.isArabic ? '$minutes د' : '$minutes min';
  } else {
    return context.isArabic ? '$totalSeconds ثانية' : '$totalSeconds s';
  }
}

// , $s
String formatTimeClockEnd(
    String? startTime, BuildContext context, int secondsToAdd) {
  if (startTime == null || startTime.isEmpty) return '';

  // Parse the startTime string to DateTime
  DateTime dateTime = DateTime.parse(startTime);

  // Add seconds to the parsed DateTime
  dateTime = dateTime.add(Duration(seconds: secondsToAdd));

  // Get the formatted time
  String time = DateFormat.jm().format(dateTime); // "4:02 PM" or "4:02 م"

  // Check if the context locale is Arabic
  if (Localizations.localeOf(context).languageCode == 'ar') {
    // Convert 'AM'/'PM' to 'ص' or 'م' in Arabic
    time = time.replaceAll('AM', 'ص').replaceAll('PM', 'م');
  }

  return time;
}

String formatTimeClock(String? startTime, BuildContext context) {
  if (startTime == null || startTime.isEmpty) return '';

  DateTime dateTime = DateTime.parse(startTime);

  String time = DateFormat.jm().format(dateTime); // "4:02 PM" or "4:02 م"

  if (Localizations.localeOf(context).languageCode == 'ar') {
    time = time.replaceAll('AM', 'ص').replaceAll('PM', 'م');
  }

  return time;
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
