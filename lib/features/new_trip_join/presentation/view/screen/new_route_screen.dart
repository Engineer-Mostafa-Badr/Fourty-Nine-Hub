import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../core/widget/custom_switch_button.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../widget/alert_text_widget.dart';
import '../widget/premium_and_request_widget.dart';
import '../widget/price_and_seat_widget.dart';
import '../widget/switch_widget.dart';
import '../widget/welcome_text_widget.dart';

class NewRouteScreen extends StatefulWidget {
  const NewRouteScreen({super.key});

  @override
  State<NewRouteScreen> createState() => _NewRouteScreenState();
}

class _NewRouteScreenState extends State<NewRouteScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: HomeAppbar(
          key: _scaffoldKey,
          isWithBackArrow: false,
          language: true,
          leading: IconButton(
            icon: const Icon(Icons.menu), // The menu icon
            onPressed: () {
              HandleCashback.setCount('drawerCount', context);
              _scaffoldKey.currentState?.openDrawer(); // Open the drawer
            },
          ),
        ),
      ),
      body: const NewRouteBody(),
    );
  }
}

class NewRouteBody extends StatefulWidget {
  const NewRouteBody({super.key});

  @override
  _NewRouteBodyState createState() => _NewRouteBodyState();
}

class _NewRouteBodyState extends State<NewRouteBody> {
  bool isComfort = false;
  bool isLady = false;
  bool isLadyDriver = false;
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //     const NewRouteTextWidget(),
          SizedBox(height: 10.h),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: WelcomeTextWidget(),
          ),
          const SizedBox(height: 10),
          _buildTopImage(),
          SizedBox(height: 10.h),
          const PriceAndSeatWidget(),
          SizedBox(height: 10.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                SwitchWidget(
                    title: LocaleKeys.comfort.localize,
                    value: isComfort,
                    onChanged: (val) {
                      setState(() => isComfort = val);
                    }),
                SwitchWidget(
                    title: LocaleKeys.lady.localize,
                    value: isLady,
                    onChanged: (val) {
                      setState(() => isLady = val);
                    }),
                SwitchWidget(
                    title: LocaleKeys.ladyDriver.localize,
                    value: isLadyDriver,
                    onChanged: (val) {
                      setState(() => isLadyDriver = val);
                    }),
              ],
            ),
          ),
          if (isLadyDriver)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                context.isArabic
                    ? "ستجد عددًا أقل من السائقين إذا قمت بتحديد هذا الخيار"
                    : 'You will find fewer drivers if you select this option!',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.SECONDARY_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          SizedBox(height: 5.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => showPaymentAlert(context),
                      child: Text(
                        LocaleKeys.paymentOption.localize,
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    GestureDetector(
                      onTap: () => showPaymentAlert(context),
                      child: SvgPicture.asset(Assets.ideaIcon),
                    ),
                  ],
                ),
                SvgPicture.asset(Assets.visaIcon, width: 40),
              ],
            ),
          ),
          SizedBox(height: 15.h),
          const PremiumAndRequestWidget(),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  void showPaymentAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: AppColors.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // زوايا مدورة
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      context.isArabic ? 'تحذير' : 'Alert!',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AlertTextWidget(
                    text: context.isArabic
                        ? "الدفع مقدمًا وشحن محفظتك."
                        : "Payment in advance, charge your wallet.",
                  ),
                  AlertTextWidget(
                      text: context.isArabic
                          ? "سيتم الاحتفاظ بالمال حتى انتهاء الرحلة."
                          : "Money will be holding till the ride ends."),
                  AlertTextWidget(
                    text: context.isArabic
                        ? "لا يوجد أموال للكابتن."
                        : "No cash for the captain.",
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.PRIMARY_COLOR,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 10),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        LocaleKeys.cancel.localize,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildTopMap(RideState state, BuildContext context) {
    List<LatLng> routePoints =
        _convertPolylineToLatLng(state.rideExpectedPrice?.polyline ?? []);

    if (state.currentLocation != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(
          LatLng(state.currentLocation!.lat!, state.currentLocation!.lng!),
          12.0,
        );
      });
    }

    return SizedBox(
      width: double.infinity,
      height: state.requestedTrip != null
          ? MediaQuery.of(context).size.height
          : MediaQuery.of(context).size.height * 0.5,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(
            state.currentLocation?.lat ?? 30.033333,
            state.currentLocation?.lng ?? 31.233334,
          ),
          initialZoom: 12.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          MarkerLayer(
            markers: [
              if (state.currentLocation != null)
                Marker(
                  point: LatLng(
                      state.currentLocation!.lat!, state.currentLocation!.lng!),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin,
                      color: Colors.blue, size: 40),
                ),
              if (state.toLocation != null)
                Marker(
                  point: LatLng(state.toLocation!.lat!, state.toLocation!.lng!),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin,
                      color: Colors.red, size: 40),
                ),
              if (state.wayPointOne != null)
                Marker(
                  point:
                      LatLng(state.wayPointOne!.lat!, state.wayPointOne!.lng!),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin,
                      color: Colors.green, size: 40),
                ),
              if (state.wayPointTwo != null)
                Marker(
                  point:
                      LatLng(state.wayPointTwo!.lat!, state.wayPointTwo!.lng!),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin,
                      color: Colors.green, size: 40),
                ),
            ],
          ),
          if (routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: routePoints,
                  color: Colors.blue,
                  strokeWidth: 4.0,
                ),
              ],
            ),
        ],
      ),
    );
  }

  List<LatLng> _convertPolylineToLatLng(List<List<double>> polyline) {
    return polyline.map((point) => LatLng(point[1], point[0])).toList();
  }

  Widget _buildTopImage() {
    return BlocBuilder<RideCubit, RideState>(builder: (context, state) {
      return Builder(builder: (context) {
        return Stack(
          children: [
            _buildTopMap(state, context),
          ],
        );
      });
    });
  }
}
