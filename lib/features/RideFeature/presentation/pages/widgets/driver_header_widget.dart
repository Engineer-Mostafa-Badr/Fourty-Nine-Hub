import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../core/utils/format_numbers.dart';
import '../../../../../res/style/app_colors.dart';
import 'font_manager.dart';

class DriverHeaderWidget extends StatelessWidget {
  final Widget rideStatusWidget;
  final String? carModel;
  final String? carColor;
  final String carImageUrl;
  final String? carName;
  final String carNumber;


   static List<ColorModel> colorList = [
    ColorModel(
      id: "677409f87167cb520348f4d5",
      nameEnglish: "Black",
      nameArabic: "أسود",
      code: "#000000",
    ),
    ColorModel(
      id: "677409f87167cb520348f4d6",
      nameEnglish: "White",
      nameArabic: "أبيض",
      code: "#FFFFFF",
    ),
    ColorModel(
      id: "677409f87167cb520348f4d7",
      nameEnglish: "Silver",
      nameArabic: "فضي",
      code: "#C0C0C0",
    ),
    ColorModel(
      id: "677409f87167cb520348f4d8",
      nameEnglish: "Gray",
      nameArabic: "رمادي",
      code: "#808080",
    ),
    ColorModel(
      id: "677409f87167cb520348f4d9",
      nameEnglish: "Red",
      nameArabic: "أحمر",
      code: "#FF0000",
    ),
    ColorModel(
      id: "677409f87167cb520348f4da",
      nameEnglish: "Blue",
      nameArabic: "أزرق",
      code: "#0000FF",
    ),
    ColorModel(
      id: "677409f87167cb520348f4db",
      nameEnglish: "Green",
      nameArabic: "أخضر",
      code: "#008000",
    ),
    ColorModel(
      id: "677409f87167cb520348f4dc",
      nameEnglish: "Yellow",
      nameArabic: "أصفر",
      code: "#FFFF00",
    ),
    ColorModel(
      id: "677409f87167cb520348f4dd",
      nameEnglish: "Brown",
      nameArabic: "بني",
      code: "#A52A2A",
    ),
    ColorModel(
      id: "677409f87167cb520348f4de",
      nameEnglish: "Beige",
      nameArabic: "بيج",
      code: "#F5F5DC",
    ),
    ColorModel(
      id: "677409f87167cb520348f4df",
      nameEnglish: "Ivory",
      nameArabic: "عاجي",
      code: "#FFFFF0",
    ),
    ColorModel(
      id: "677409f87167cb520348f4e0",
      nameEnglish: "Orange",
      nameArabic: "برتقالي",
      code: "#FFA500",
    ),
    ColorModel(
      id: "677409f87167cb520348f4e1",
      nameEnglish: "Gold",
      nameArabic: "ذهبي",
      code: "#FFD700",
    ),
    ColorModel(
      id: "677409f87167cb520348f4e2",
      nameEnglish: "Purple",
      nameArabic: "أرجواني",
      code: "#800080",
    ),
    ColorModel(
      id: "677409f87167cb520348f4e3",
      nameEnglish: "Maroon",
      nameArabic: "ماروني",
      code: "#800000",
    ),
    ColorModel(
      id: "677409f87167cb520348f4e4",
      nameEnglish: "Turquoise",
      nameArabic: "فيروزي",
      code: "#40E0D0",
    ),
    ColorModel(
      id: "677409f87167cb520348f4e5",
      nameEnglish: "Pink",
      nameArabic: "وردي",
      code: "#FFC0CB",
    ),
    ColorModel(
      id: "677409f87167cb520348f4e6",
      nameEnglish: "Navy Blue",
      nameArabic: "أزرق داكن",
      code: "#000080",
    ),
    ColorModel(
      id: "677409f87167cb520348f4e7",
      nameEnglish: "Teal",
      nameArabic: "أخضر مزرق",
      code: "#008080",
    ),
    ColorModel(
      id: "677409f87167cb520348f4e8",
      nameEnglish: "Charcoal",
      nameArabic: "فحمي",
      code: "#36454F",
    ),
  ];

  String? getColorNameById({
    required String id,
    required bool isArabic,
  }) {
    final color = colorList.firstWhere(
          (color) => color.id == id,
    );

    return color == null ? null : (isArabic ? color.nameArabic : color.nameEnglish);
  }


  const DriverHeaderWidget({
    super.key,
    required this.rideStatusWidget,
    required this.carModel,
    required this.carColor,
    required this.carImageUrl,
    required this.carName,
    required this.carNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                rideStatusWidget,
                const SizedBox(height: 4),
                Row(
                  children: [


                    if (carName != null)
                      Text(
                        '$carName',
                        style:  TextStyle(
                          fontSize: FontSize.s14,
                          fontWeight: FontWeight.bold,
                          color: context.isDarkMode
                              ? AppColors.whiteColor
                              :  AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    if (carModel != null && carName != null)
                       Text(
                        ' - ',
                        style:  TextStyle(
                          fontSize: FontSize.s14,
                          fontWeight: FontWeight.bold,
                          color:  context.isDarkMode
                              ? AppColors.whiteColor
                              :  AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    if (carModel != null)
                      Text(
                        '$carModel',
                        style:  TextStyle(
                          fontSize: FontSize.s14,
                          fontWeight: FontWeight.bold,
                          color:  context.isDarkMode
                              ? AppColors.whiteColor
                              :  AppColors.PRIMARY_COLOR,
                        ),
                      ),

                    if (carColor != null && carModel != null)
                       Text(
                        ' - ',
                        style:  TextStyle(
                          fontSize: FontSize.s14,
                          fontWeight: FontWeight.bold,
                          color:  context.isDarkMode
                              ? AppColors.whiteColor
                              :  AppColors.PRIMARY_COLOR,
                        ),
                      ),

                    if (carColor != null)
                      Text(
                        // '$carColor',
                        // '${HexColor(carColor!)}',
                        '${getColorNameById(id: carColor!, isArabic: context.isArabic)}',
                        style:  TextStyle(
                          fontSize: FontSize.s14,
                          fontWeight: FontWeight.bold,
                          color:  context.isDarkMode
                        ? AppColors.whiteColor
                            :  AppColors.PRIMARY_COLOR,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ]
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    carImageUrl,
                    width: 50,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                carNumber,
                style: const TextStyle(
                  fontSize: FontSize.s12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DriverArrivalCountdown extends StatefulWidget {
  final DateTime? arrivalDateTime;
  final bool isCountdown;
  final bool isInLocation;

  const DriverArrivalCountdown({
    super.key,
    required this.arrivalDateTime,
    required this.isCountdown,
    required this.isInLocation,
  });

  @override
  State<DriverArrivalCountdown> createState() => _DriverArrivalCountdownState();
}

class _DriverArrivalCountdownState extends State<DriverArrivalCountdown> {
  late Duration remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    if (widget.isCountdown && remaining.inSeconds > 0) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(covariant DriverArrivalCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCountdown &&
        widget.arrivalDateTime != oldWidget.arrivalDateTime) {
      _timer?.cancel();
      _updateRemaining();
      _startTimer();
    }
  }

  void _updateRemaining() {
    final now = DateTime.now();
    final arrival = widget.arrivalDateTime ?? now;
    remaining = arrival.difference(now);
    if (remaining.isNegative) {
      remaining = Duration.zero;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _updateRemaining();
        if (remaining.inSeconds <= 0) {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return "${FormatNumbers().convertNumberToLocalizedString(minutes.toString().padLeft(2, '0'), isArabic: context.isArabic)}:${FormatNumbers().convertNumberToLocalizedString(seconds.toString().padLeft(2, '0'), isArabic: context.isArabic)}";
  }

  @override
  Widget build(BuildContext context) {
    final arrivalText = _formatDuration(remaining);

    return widget.isInLocation
        ? Text(
      context.isArabic ? "لقد وصل السائق" : "The Driver has Arrived",
      style: const TextStyle(
        fontSize: FontSize.s14,
        fontWeight: FontWeight.bold,
      ),
    )
        : Text(
      context.isArabic
          ? "سوف يصل السائق في $arrivalText"
          : "Driver is arriving in $arrivalText",
      style: const TextStyle(
        fontSize: FontSize.s14,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}


class TripDurationCountdown extends StatefulWidget {
  final double? tripDurationSeconds;
  final bool isArabic;

  const TripDurationCountdown({
    super.key,
    required this.tripDurationSeconds,
    required this.isArabic,
  });

  @override
  State<TripDurationCountdown> createState() => _TripDurationCountdownState();
}

class _TripDurationCountdownState extends State<TripDurationCountdown> {
  late Duration remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeCountdown();
  }

  void _initializeCountdown() {
    remaining = Duration(seconds: widget.tripDurationSeconds?.toInt() ?? 0);
    if (remaining.inSeconds > 0) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remaining.inSeconds > 0) {
          remaining = remaining - const Duration(seconds: 1);
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  void didUpdateWidget(covariant TripDurationCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tripDurationSeconds?.toInt() != oldWidget.tripDurationSeconds?.toInt()) {
      _timer?.cancel();
      _initializeCountdown();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return "${FormatNumbers().convertNumberToLocalizedString(minutes.toString().padLeft(2, '0'), isArabic: widget.isArabic)}:"
        "${FormatNumbers().convertNumberToLocalizedString(seconds.toString().padLeft(2, '0'), isArabic: widget.isArabic)}";
  }

  @override
  Widget build(BuildContext context) {
    if (remaining.inSeconds <= 0) {
      return Text(
        widget.isArabic ? "لقد وصلت" : "You have arrived",
        style: const TextStyle(
          fontSize: FontSize.s14,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    final formattedTime = _formatDuration(remaining);

    return Text(
      widget.isArabic
          ? "سوف تصل خلال $formattedTime"
          : "You’ll be Arriving in $formattedTime",
      style: const TextStyle(
        fontSize: FontSize.s14,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class ColorModel {
  final String id;
  final String nameEnglish;
  final String nameArabic;
  final String code;

  ColorModel({
    required this.id,
    required this.nameEnglish,
    required this.nameArabic,
    required this.code,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      id: json['_id']['\$oid'],
      nameEnglish: json['name_english'],
      nameArabic: json['name_arabic'],
      code: json['code'],
    );
  }
}
