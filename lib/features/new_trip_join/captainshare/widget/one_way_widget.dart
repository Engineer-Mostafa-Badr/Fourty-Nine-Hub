import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/utils/time_utils.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/localization/locale_keys.g.dart';

class OneWayWidget extends StatefulWidget {
  final String? statusDriver;
  final bool? cancelButton;
  final bool? isMyBooking;
  final String? requestType;
  final MyBookingEntity? model;
  final Function? onCancelBooking;
  final Function? onJoin;

  const OneWayWidget({
    super.key,
    this.statusDriver,
    this.model,
    this.cancelButton,
    this.isMyBooking,
    this.requestType,
    this.onCancelBooking,
    this.onJoin,
  });

  @override
  _OneWayWidgetState createState() => _OneWayWidgetState();
}

class _OneWayWidgetState extends State<OneWayWidget> {
  bool _showContainer = false; // متغير للتحكم في ظهور الـ Container
  ExpandableController _expandableController = ExpandableController();

  @override
  void initState() {
    super.initState();
    _expandableController = ExpandableController(initialExpanded: false);
  }

  String getBookingStatus(String status) {
    switch (status) {
      case 'pending':
        return LocaleKeys.pending.localize;
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

  // bool myRoute = widget.model?.creatorId == UserCubit.to.state.data?.id||((widget.model?.clients??[]).contain((e)=>e.id==UserCubit.to.state.data?.id));

  @override
  Widget build(BuildContext context) {
    print(
        "isMyBooking ${widget.model?.creatorId == UserCubit.to.state.data?.id}");
    print("widget.model?.creatorId ${widget.model?.creatorId}");
    print("UserCubit.to.state.data?.id ${UserCubit.to.state.data?.id}");
    print(
        "widget.model?.startLocation ${widget.model?.startLocation?.location}");
    print(
        "widget.model?.startLocation ${widget.model?.startLocation?.location[1]}");
    print(
        "widget.model?.startLocation ${widget.model?.startLocation?.location[0]}");
    return ClickableWidget(
      onTap: ()=>context.push(Routes.routeDetailsScreen,extra: widget.model),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
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
                            if (!(widget.model?.creatorId ==
                                UserCubit.to.state.data?.id))
                              SvgPicture.asset(Assets.bookedMan),
                            if (widget.model?.creatorId ==
                                UserCubit.to.state.data?.id)
                              CircleAvatar(
                                radius: 30.w,
                                backgroundColor: Colors.white,
                                backgroundImage: CachedNetworkImageProvider(
                                    UserCubit.to.state.data?.profilePicture ??
                                        UIConst.profilePlaceHolder),
                              ),
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
                            if (((widget.model?.availableSeats ?? 0) >= 2))
                              ClickableWidget(
                                onTap: () {
                                  if (widget.onJoin != null) {
                                    widget.onJoin!();
                                  }
                                },
                                child: SvgPicture.asset(
                                  Assets.freeIcon,
                                  color: AppColors.getTextColor(context),
                                ),
                              ),
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
                            if (((widget.model?.availableSeats ?? 0) >= 1))
                              ClickableWidget(
                                onTap: () {
                                  if (widget.onJoin != null) {
                                    widget.onJoin!();
                                  }
                                },
                                child: SvgPicture.asset(
                                  Assets.freeIcon,
                                  color: AppColors.getTextColor(context),
                                ),
                              ),
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
                        const Icon(Icons.circle, color: Colors.green, size: 12),
                        Expanded(
                          child: Divider(
                            color: context.isDarkMode
                                ? Colors.white
                                : AppColors.PRIMARY_COLOR,
                            thickness: 2,
                          ),
                        ),
                        const Icon(Icons.circle, color: Colors.green, size: 12),
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
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _expandableController.toggle();
                        });
                      },
                      child: SvgPicture.asset(
                        Assets.redFrame,
                        width: 50,
                      ),
                    ),
                  ),
                  ExpandablePanel(
                    controller: _expandableController,
                    theme: const ExpandableThemeData(
                      hasIcon: false,
                      tapBodyToCollapse: false,
                      tapHeaderToExpand: false,
                    ),
                    header: const SizedBox(),
                    collapsed: const SizedBox(),
                    expanded: const AddressWidget(),
                  ),
                  Row(
                    children: [
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
                ],
              ),
            ),
          ),
          // Positioned(
          //   bottom: 9,
          //   left: 270.h,
          //   child: GestureDetector(
          //     onTap: () {
          //       setState(() {
          //         _showContainer = !_showContainer; // تغيير حالة الـ Container
          //       });
          //     },
          //     child: SvgPicture.asset(
          //       Assets.frameIcon,
          //       width: 50,
          //     ),
          //   ),
          // ),
          // if (_showContainer)
          //   const Positioned(
          //     top: 0,
          //     bottom: 80,
          //     // تحديد المكان اللي هيظهر فيه الـ Container
          //     left: 0,
          //     right: 0,
          //     child: AddressWidget(),
          //   ),
        ],
      ),
    );
  }

  final MapController _mapController = MapController();

  Widget _buildTopMap(BuildContext context, MyBookingEntity? model) {
    List<LatLng> routePoints = [];
    List<dynamic> polyLine = model?.polyLine ?? [];

    List<List<double>> parsedPolyline = polyLine
        .map<List<double>>((item) =>
        (item as List).map((e) => (e as num).toDouble()).toList())
        .toList();
    routePoints =
        _convertPolylineToLatLng(parsedPolyline);

    if (model != null &&
        model.startLocation?.location[1] == null &&
        model.startLocation?.location[0] == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(
          LatLng(model.startLocation?.location[1],
              model.startLocation?.location[0]),
          12.0,
        );
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(
          LatLng(model?.startLocation?.location[1] ?? 30.033333,
              model?.startLocation?.location[0] ?? 31.233334),
          12.0,
        );
      });
    }

    List<BookingClientEntity> clients = model?.clients ?? [];
    if (clients.isNotEmpty) {
      clients.removeWhere((e) => e.id == model?.creatorId);
    }

    log("clients ${clients.length}");

    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: FlutterMap(
        mapController: _mapController,
        options: (model != null &&
                model.startLocation?.location[1] == null &&
                model.startLocation?.location[0] == null &&
                model.startLocation?.location[1] != 0 &&
                model.startLocation?.location[0] != 0)
            ? MapOptions(
                initialCenter: LatLng(model.startLocation?.location[1],
                    model.startLocation?.location[0]),
                initialZoom: 12.0,
              )
            : MapOptions(
                initialCenter: LatLng(30.033333, 31.233334),
                initialZoom: 12.0,
              ),
        children: [
          TileLayer(
            // urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            // urlTemplate: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
            // urlTemplate: "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png",
            urlTemplate: context.isDarkMode
                ? "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png" // Dark mode map
                : "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png", // Normal mode map
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              if (model != null &&
                  model.startLocation?.location[1] != null &&
                  model.startLocation?.location[0] != null &&
                  model.startLocation?.location[1] != 0 &&
                  model.startLocation?.location[0] != 0)
                Marker(
                  point: LatLng(model.startLocation?.location[1],
                      model.startLocation?.location[0]),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin,
                      color: Colors.green, size: 40),
                ),
              if (model?.targetLocation?.location != null &&
                  model?.targetLocation?.location[1] != null &&
                  model?.targetLocation?.location[0] != null &&
                  model?.targetLocation?.location[1] != 0 &&
                  model?.targetLocation?.location[0] != 0)
                Marker(
                  point: LatLng(model?.targetLocation?.location[1],
                      model?.targetLocation?.location[0]),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin,
                      color: Colors.blue, size: 40),
                ),
              if (clients.isNotEmpty)
                Marker(
                  point: LatLng(clients[0].location.location[1],
                      clients[0].location.location[0]),
                  width: 30,
                  height: 30,
                  child: const Icon(Icons.location_pin,
                      color: Colors.red, size: 30),
                ),
              if (clients.length > 1)
                Marker(
                  point: LatLng(clients[1].location.location[1],
                      clients[1].location.location[0]),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin,
                      color: Colors.red, size: 40),
                ),
            ],
          ),
          if (routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: routePoints,
                  color: context.isDarkMode ? Colors.blue : Colors.black87,
                  strokeWidth: 4.0,
                ),
              ],
            ),
        ],
      ),
    );
  }

  LatLng _getInitialCenter(MyBookingEntity? model) {
    if (model?.startLocation?.location != null &&
        model!.startLocation!.location.length >= 2 &&
        model.startLocation!.location[0] != 0 &&
        model.startLocation!.location[1] != 0) {
      return LatLng(
          model.startLocation!.location[1], model.startLocation!.location[0]);
    }

    // Default to Cairo
    return const LatLng(30.033333, 31.233334);
  }

  List<LatLng> _convertPolylineToLatLng(List<List<double>> polyline) {
    return polyline.map((point) => LatLng(point[0], point[1])).toList();
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
            // Positioned(
            //   bottom: -1,
            //   right: 5,
            //   left: 2,
            //   child: SvgPicture.asset(
            //     Assets.redFrame,
            //   ),
            // ),
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
