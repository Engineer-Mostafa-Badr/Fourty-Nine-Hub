import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/utils/time_utils.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/screen/custom_map.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/widget/map_view_details.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
// import 'package:latlong2/latlong.dart';

import '../../../../core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:fourtyninehub/helpers/manage_vibration.dart';
class DriverRouteWidget extends StatefulWidget {
  final String? statusDriver;
  final bool? cancelButton;
  final bool? hasAcceptButton;
  final MyBookingEntity? model;
  final Function? onAccept;

  const DriverRouteWidget({
    super.key,
    this.statusDriver,
    this.model,
    this.cancelButton,
    this.hasAcceptButton,
    this.onAccept,
  });

  @override
  _DriverRouteWidgetState createState() => _DriverRouteWidgetState();
}

class _DriverRouteWidgetState extends State<DriverRouteWidget> {




  String getBookingStatus(String status) {
    switch (status) {
      case 'pending':
        return context.isArabic?'انتظار':'Pending';
      case 'accepted':
        return LocaleKeys.accepted.localize;
      case 'expired':
        return LocaleKeys.expired.localize;
      case 'cancelled':
        return context.isArabic ? 'تم الغاء' : 'Canceled';
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
    return GestureDetector(
      // onTap: ()=>context.push(Routes.routeDetailsScreen,extra: widget.model),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
            context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
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
                        context.isArabic?'لكل مقعد':'Per Seat',
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
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          LocaleKeys.booked.localize,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                          SvgPicture.asset(Assets.bookedMan),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          ((widget.model?.availableSeats ?? 0) >= 2)
                              ? LocaleKeys.free.localize
                              : LocaleKeys.booked.localize,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        if (((widget.model?.availableSeats ?? 0) < 2))
                          CircleAvatar(
                            radius: 30.w,
                            backgroundColor: Colors.white,
                            backgroundImage: CachedNetworkImageProvider(
                                UIConst.profilePlaceHolder),
                          ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 13),
                          child: Text(
                            ((widget.model?.availableSeats ?? 0) >= 1)
                                ? LocaleKeys.free.localize
                                : LocaleKeys.booked.localize,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        if (((widget.model?.availableSeats ?? 0) < 1))
                          CircleAvatar(
                            radius: 30.w,
                            backgroundColor: Colors.white,
                            backgroundImage: CachedNetworkImageProvider(
                                UIConst.profilePlaceHolder),
                          ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: context.isDarkMode
                                ? Colors.white
                                : AppColors.PRIMARY_COLOR,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.h, left: 8.h),
                          child: SizedBox(
                            width: 55.w,
                            child: Text(
                              getBookingStatus(widget.statusDriver ?? ""),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: context.isDarkMode
                                    ? Colors.white
                                    : AppColors.PRIMARY_COLOR,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Icon(Icons.circle,
                        color: AppColors.getRedColor(context), size: 12),
                    Expanded(
                      child: Divider(
                        color: context.isDarkMode
                            ? Colors.white
                            : AppColors.PRIMARY_COLOR,
                        thickness: 2,
                      ),
                    ),
                    Icon(Icons.circle, color:((widget.model?.availableSeats ?? 0) <= 1)?Colors.red: Colors.green, size: 12),
                    Expanded(
                      child: Divider(
                        color: context.isDarkMode
                            ? Colors.white
                            : AppColors.PRIMARY_COLOR,
                        thickness: 2,
                      ),
                    ),
                    Icon(Icons.circle, color: ((widget.model?.availableSeats ?? 0) < 1)?Colors.red:Colors.green, size: 12),
                    Expanded(
                      child: Divider(
                        color: context.isDarkMode
                            ? Colors.white
                            : AppColors.PRIMARY_COLOR,
                        thickness: 2,
                      ),
                    ),
                    const Icon(Icons.circle, color: Colors.blue, size: 12),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                  height: 200.h, child: _buildTopMap(context, widget.model)),
              const SizedBox(height: 8),

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
                          radius: 5),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.model?.startLocation?.address ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        color: context.isDarkMode
                            ? Colors.white
                            : AppColors.PRIMARY_COLOR,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.transparent,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 10,
                      child: CircleAvatar(
                          backgroundColor: AppColors.getFillColor(context),
                          radius: 5),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.model?.targetLocation?.address ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        color: context.isDarkMode
                            ? Colors.white
                            : AppColors.PRIMARY_COLOR,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  // Show timer if conditions are met, otherwise show time ago
                  Text(
                    TimeUtils.formatTimeAgo(
                        widget.model?.createdAt ?? DateTime.now().toString(),
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
                    onPressed: () {

      ManageVibration.vibrate();
                    },
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
                ],
              ),
              SizedBox(height: 8),
              if(widget.hasAcceptButton==true)AppButton(
                  width: context.screenWidth ,
                  label: context.isArabic ? 'قبول' : 'Accept',
                  backColor: AppColors.PRIMARY_COLOR,
                  onPressed: () {
      ManageVibration.vibrate();
                    if(widget.onAccept!=null){
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

  final MapController _mapController = MapController();

  Widget _buildTopMap(BuildContext context, MyBookingEntity? model) {
    List<gmap.LatLng> routePoints = [];
    List<dynamic> polyLine = model?.polyLine ?? [];

    List<List<double>> parsedPolyline = polyLine
        .map<List<double>>((item) =>
        (item as List).map((e) => (e as num).toDouble()).toList())
        .toList();
    routePoints =
        _convertPolylineToLatLng(parsedPolyline);



    List<BookingClientEntity> clients = List.from(model?.clients ?? []);
    if (clients.isNotEmpty) {
      clients.removeWhere((e) => e.id == model?.creatorId);
    }

    List<gmap.LatLng> convertClientsToLatLng(List<BookingClientEntity> clients) {
      return clients.map((client) {
        final coords = client.location.location;
        return gmap.LatLng(coords[1], coords[0]); // [latitude, longitude]
      }).toList();
    }

    log("clients ${clients.length}");

    return GestureDetector(
      onTap: (){
      ManageVibration.vibrate();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: Text(context.isArabic?'تفاصيل الرحلة':'Route Details')),
              body: MapViewDetails(
                startLocation: gmap.LatLng(model?.startLocation?.location[1],
                    model?.startLocation?.location[0]),
                targetLocation: gmap.LatLng(model?.targetLocation?.location[1],
                    model?.targetLocation?.location[0]),
                polylinePoints:routePoints,
                clientLocations: convertClientsToLatLng(clients),
              ),
            ),
          ),
        );
      },
      child: AbsorbPointer(
        absorbing: true,
        child: CustomGoogleMap(
          startLocation:model?.startLocation==null?null: gmap.LatLng(model?.startLocation?.location[1],
              model?.startLocation?.location[0]),
          targetLocation: model?.targetLocation==null?null:gmap.LatLng(model?.targetLocation?.location[1],
              model?.targetLocation?.location[0]),
          polylinePoints:routePoints,
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