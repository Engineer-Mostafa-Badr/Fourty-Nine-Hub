import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/phone_number_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/utils/time_utils.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/screen/custom_map.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/widget/client_status_bar_widget.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/widget/map_view_details.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
// import 'package:latlong2/latlong.dart';

import '../../../../core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;

class OneWayWidget extends StatefulWidget {
  final String? statusDriver;
  final bool? cancelButton;
  final bool? hasAcceptButton;
  final String? requestType;
  final MyBookingEntity? model;
  final Function? onCancelBooking;
  final Function(String phone)? onJoin;
  final Function? onAccept;
  final Function? onTap;

  const OneWayWidget({
    super.key,
    this.statusDriver,
    this.model,
    this.cancelButton,
    this.hasAcceptButton,
    this.onAccept,
    this.requestType,
    this.onCancelBooking,
    this.onJoin,
    this.onTap,
  });

  @override
  _OneWayWidgetState createState() => _OneWayWidgetState();
}

class _OneWayWidgetState extends State<OneWayWidget> {
  final bool _showContainer = false;
  ExpandableController _expandableController = ExpandableController();

  TextEditingController phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  String convertDigits(String input, {bool toArabic = false}) {
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    final from = toArabic ? western : eastern;
    final to = toArabic ? eastern : western;

    for (int i = 0; i < from.length; i++) {
      input = input.replaceAll(from[i], to[i]);
    }

    return input;
  }

  // Timer related variables
  Timer? _timer;
  Duration _remainingTime = Duration.zero;
  bool _showTimer = false;

  @override
  void initState() {
    super.initState();
    _expandableController = ExpandableController(initialExpanded: false);
    if (widget.model?.status == 'pending') _setupTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _setupTimer() {
    if (widget.model?.createdAt != null) {
      try {
        DateTime createdAt = DateTime.parse(widget.model!.createdAt!);
        DateTime now = DateTime.now();

        // Check if it's the same day
        bool isSameDay = createdAt.year == now.year &&
            createdAt.month == now.month &&
            createdAt.day == now.day;

        if (isSameDay) {
          Duration elapsed = now.difference(createdAt);
          Duration oneHour = const Duration(hours: 1);

          // Check if less than 1 hour has passed
          if (elapsed < oneHour) {
            _remainingTime = oneHour - elapsed;
            _showTimer = true;

            // Start the countdown timer
            _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
              setState(() {
                if (_remainingTime.inSeconds > 0) {
                  _remainingTime = _remainingTime - const Duration(seconds: 1);
                } else {
                  _timer?.cancel();
                  _showTimer = false;
                  _onTimerFinished();
                }
              });
            });
          }
        }
      } catch (e) {
        print('Error parsing createdAt: $e');
      }
    }
  }

  // This method will be called when timer finishes
  void _onTimerFinished() {
    // Add your logic here when timer finishes
    print('Timer finished! Add your custom logic here.');
    // You can add any functionality you need here
  }

  String _formatRemainingTime(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String getBookingStatus(String status) {
    switch (status) {
      case 'pending':
        return context.isArabic ? 'انتظار' : 'Pending';
      case 'accepted':
        return LocaleKeys.accepted.localize;
      case 'expired':
        return LocaleKeys.expired.localize;
      case 'cancelled':
        return context.isArabic ? 'تم الغاء' : 'Canceled';
      case 'full':
        return context.isArabic ? 'ممتلئ' : 'Full';
      case 'completed':
        return context.isArabic ? 'مكتمل' : 'Completed';
      case 'running':
        return context.isArabic ? 'جارية' : 'Running';
      case 'done':
        return LocaleKeys.done.localize;
      default:
        return LocaleKeys.pending.localize;
    }
  }

  String getPassengerDescription(List<dynamic> options, bool isArabic) {
    bool hasLadyDriver = options.contains('LADY_DRIVER');
    bool hasLadyPassenger = options.contains('LADY_PASSENGER');

    if (hasLadyPassenger && hasLadyDriver) {
      return isArabic ? 'سيدات' : 'Ladies';
    } else if (hasLadyPassenger || hasLadyDriver) {
      return isArabic ? 'راكبات' : 'Lady passengers';
    } else {
      return isArabic ? 'أي راكب' : 'Any passenger';
    }
  }

  bool isComfort(List<dynamic> options) {
    return options.contains('COMFORT');
  }

  @override
  Widget build(BuildContext context) {
    bool myRoute = (widget.model?.creatorId == UserCubit.to.state.data?.id) ||
        ((widget.model?.clients ?? [])
            .any((e) => e.id == UserCubit.to.state.data?.id));
    return GestureDetector(
      // onTap: widget.onTap!=null?widget.onTap!():null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // محتوى الكونتينر الأساسي
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getPassengerDescription(
                        widget.model?.features ?? [], context.isArabic),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.getRedColor(context),
                    ),
                  ),
                  Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "${widget.model?.pricePerSeat} ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.getTextColor(context),
                          ),
                          children: [
                            TextSpan(
                              text: context.isArabic ? "ج.م" : "EGP",
                              style: TextStyle(
                                color: AppColors.getRedColor(context),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        context.isArabic ? 'لكل مقعد' : 'Per Seat',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.getRedColor(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              ClientStatusBarWidget(
                formKey: formKey,
                statusDriver:widget.statusDriver,
                myRoute: myRoute,
                phoneController: phoneController,
                model: widget.model,
                onJoin: (phone) {
                  if(widget.onJoin != null) widget.onJoin!(phone);
                },
              ),
              const SizedBox(height: 8),
              SizedBox(
                  height: 200.h, child: _buildTopMap(context, widget.model)),
              const SizedBox(height: 8),

              // 🟩🟦 Location Stepper (From/To)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // الخط العمودي بين الدائرتين
                  Positioned(
                    left: context.isArabic ? null : 0,
                    right: context.isArabic ? 0 : null,
                    top: 0,
                    bottom: 0,
                    child: _buildStepperLine(context),
                  ),

                  // النصوص والعناوين
                  Padding(
                    padding: EdgeInsets.only(
                      left: context.isArabic ? 0 : 28.w,
                      right: context.isArabic ? 28.w : 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // From location
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.model?.startLocation?.address ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  color: context.isDarkMode
                                      ? Colors.white
                                      : AppColors.PRIMARY_COLOR,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 18.h),

                        // To location
                        Row(
                          children: [

                            Flexible(
                              child: Text(
                                widget.model?.targetLocation?.address ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  color: context.isDarkMode
                                      ? Colors.white
                                      : AppColors.PRIMARY_COLOR,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),
              Row(
                children: [
                  // Show timer if conditions are met, otherwise show time ago
                  _showTimer
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.timer,
                                size: 16,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatRemainingTime(_remainingTime),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text(
                          TimeUtils.formatTimeAgo(
                              widget.model?.createdAt ??
                                  DateTime.now().toString(),
                              context.isArabic),
                          style: TextStyle(
                            fontSize: 14,
                            color: context.isDarkMode
                                ? Colors.white
                                : AppColors.PRIMARY_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      isComfort(widget.model?.features ?? [])
                          ? LocaleKeys.comfort.localize
                          : (context.isArabic ? 'غير مريح' : 'Uncomfortable'),
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: context.isDarkMode
                            ? Colors.white
                            : AppColors.PRIMARY_COLOR,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  widget.cancelButton == true
                      ? GestureDetector(
                          onTap: () {
                            if (widget.onCancelBooking != null) {
                              widget.onCancelBooking!();
                            }
                          },
                          child: Container(
                            width: 120.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: AppColors.SECONDARY_COLOR_DARK,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                LocaleKeys.cancel.localize,
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              SizedBox(height: 8),
              if (widget.hasAcceptButton == true)
                AppButton(
                    width: context.screenWidth,
                    label: context.isArabic ? 'قبول' : 'Accept',
                    backColor: AppColors.PRIMARY_COLOR,
                    onPressed: () {
                      if (widget.onAccept != null) {
                        widget.onAccept!();
                      }
                      // cubit
                    }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepperLine(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.green,
          radius: 6,
          child: const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 3,
          ),
        ),
        SizedBox(height: 4.h),
        ...List.generate(
          2,
              (index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: context.isDarkMode ? Colors.grey[600] : Colors.grey[400],
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 6,
          child: const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 3,
          ),
        ),
      ],
    );
  }


  final MapController _mapController = MapController();

  Widget _buildTopMap(BuildContext context, MyBookingEntity? model) {
    List<gmap.LatLng> routePoints = [];
    List<dynamic> polyLine = model?.polyLine ?? [];

    List<List<double>> parsedPolyline = polyLine
        .map<List<double>>(
            (item) => (item as List).map((e) => (e as num).toDouble()).toList())
        .toList();
    routePoints = _convertPolylineToLatLng(parsedPolyline);

    List<BookingClientEntity> clients = List.from(model?.clients ?? []);
    if (clients.isNotEmpty) {
      clients.removeWhere((e) => e.id == model?.creatorId);
    }

    List<gmap.LatLng> convertClientsToLatLng(
        List<BookingClientEntity> clients) {
      return clients.map((client) {
        final coords = client.location.location;
        return gmap.LatLng(coords[1], coords[0]); // [latitude, longitude]
      }).toList();
    }

    return GestureDetector(
      onTap:widget.onTap!=null?widget.onTap!(): () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                  title: Text(
                      context.isArabic ? 'تفاصيل الرحلة' : 'Route Details')),
              body: MapViewDetails(
                startLocation: gmap.LatLng(model?.startLocation?.location[1],
                    model?.startLocation?.location[0]),
                targetLocation: gmap.LatLng(model?.targetLocation?.location[1],
                    model?.targetLocation?.location[0]),
                polylinePoints: routePoints,
                clientLocations: convertClientsToLatLng(clients),
              ),
            ),
          ),
        );
      },
      child: AbsorbPointer(
        absorbing: true,
        child: CustomGoogleMap(
          startLocation: model?.startLocation == null
              ? null
              : gmap.LatLng(model?.startLocation?.location[1],
                  model?.startLocation?.location[0]),
          targetLocation: model?.targetLocation == null
              ? null
              : gmap.LatLng(model?.targetLocation?.location[1],
                  model?.targetLocation?.location[0]),
          polylinePoints: routePoints,
          clientLocations: convertClientsToLatLng(clients),
        ),
      ),
    );
  }

  List<gmap.LatLng> _convertPolylineToLatLng(List<List<double>> polyline) {
    return polyline.map((point) => gmap.LatLng(point[1], point[0])).toList();
  }
}

class AddressWidget extends StatelessWidget {
  const AddressWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDarkMode
            ? const Color(0xFF333333)
            : AppColors.BG_GRAY_COLOR,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextAddressWidget(
                    color: Colors.green,
                    address: context.isArabic ? "الجيزة، مصر" : "Giza , Egypt",
                  ),
                  SizedBox(height: 12.h),
                  TextAddressWidget(
                    color: Colors.black,
                    address: context.isArabic ? "الجيزة، مصر" : "Giza , Egypt",
                  ),
                  SizedBox(height: 12.h),
                  TextAddressWidget(
                    color: Colors.black,
                    address: context.isArabic ? "الجيزة، مصر" : "Giza , Egypt",
                  ),
                  SizedBox(height: 12.h),
                  TextAddressWidget(
                    color: Colors.blue,
                    address: context.isArabic ? "الجيزة، مصر" : "Giza , Egypt",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextAddressWidget extends StatelessWidget {
  final String? address;
  final Color? color;

  const TextAddressWidget({
    super.key,
    this.address,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: Colors.transparent,
          child: CircleAvatar(
            backgroundColor: color,
            radius: 7,
            child: CircleAvatar(
                backgroundColor: context.isDarkMode
                    ? const Color(0xFF333333)
                    : AppColors.BG_GRAY_COLOR,
                radius: 3),
          ),
        ),
        SizedBox(width: 9.w),
        Text(
          context.isArabic ? address ?? "" : address ?? "",
          style: TextStyle(
            fontSize: 28.sp,
            color: AppColors.getTextColor(context),
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
