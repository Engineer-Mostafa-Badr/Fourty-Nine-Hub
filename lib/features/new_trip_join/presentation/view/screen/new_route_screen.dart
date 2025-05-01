import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/osm_search_and_pick.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../core/widget/custom_switch_button.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../settings/presentation/pages/widgets/custombutton.dart';
import '../../../../trip_join/view_all_trip_join/presentation/views/Modified_widgets/create_ad_widgets/create_ad_location_button.dart';
import '../../../../trip_join/view_all_trip_join/presentation/views/Modified_widgets/create_ad_widgets/find_location_button.dart';
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

  List<double>? currentLocation;
  List<double>? toLocation;
  String? currentAddress;
  String? toAddress;


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //     const NewRouteTextWidget(),
          SizedBox(height: 20.h),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: WelcomeTextWidget(),
          ),
          const SizedBox(height: 10),
          _buildTopImage(),
          SizedBox(height: 10.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _customLocationField(
              isTo: false,
              context: context,
              color: Colors.green,
              text: currentAddress,
              onPressed: () async {
                context.push(
                  Routes.RIDEOPENSTREETMAPSEARCHANDPICK,
                  extra: RideOpenStreetMapSearchAndPickParams(
                    onPicked: (pickedData) async {
                      currentAddress = pickedData.addressName;
                      currentLocation = [pickedData.latLong.latitude, pickedData.latLong.longitude];
                      context.pop();
                      setState(() {

                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _customLocationField(
              isTo: true,
              context: context,
              color: Colors.blue,
              text:toAddress,
              onPressed: () async {
                context.push(Routes.RIDEOPENSTREETMAPSEARCHANDPICK,
                    extra: RideOpenStreetMapSearchAndPickParams(
                      onPicked: (pickedData) async {
                        toAddress = pickedData.addressName;
                        toLocation = [pickedData.latLong.latitude, pickedData.latLong.longitude];
                        context.pop();
                        setState(() {});
                      },
                    ));
              },
            ),
          ),
           const PriceAndSeatWidget(

           ),
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
                      child: CustomButton(
                    width: double.infinity,
                    onPressed: () {
                      context.pop();
                    },
                    color: AppColors.PRIMARY_COLOR,
                    text: LocaleKeys.cancel.localize,
                    textStyle: const TextStyle(color: Colors.white),
                  )),
                ],
              ),
            ),
          );
        });
  }

  Widget _customLocationField({
    required Color color,
    required String? text,
    required bool isTo,
    required Function()? onPressed,
    required BuildContext context,
  }) {
    if (text == null) {
      if (isTo == true) {
        text = 'To';
      } else {
        text = 'From';
      }
    }

    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFEEEEEE),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: CircleAvatar(
                backgroundColor: color,
                radius: 10,
                child: const CircleAvatar(
                    backgroundColor: Colors.white, radius: 5),
              ),
            ),
            Expanded(
              child: Text(
                text == 'From'
                    ? context.isArabic
                    ? "من"
                    : "From"
                    : text == 'To'
                    ? context.isArabic
                    ? "إلى"
                    : "To"
                    : text!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopMap(BuildContext context) {

    if (currentLocation != null && currentLocation!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(
          LatLng(currentLocation![0], currentLocation![1]),
          12.0,
        );
      });
    }

    return SizedBox(
      width: double.infinity,
      height:MediaQuery.of(context).size.height * 0.5,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(
            currentLocation?[0]?? 30.0596113,
            currentLocation?[1] ?? 31.1760625,
          ),
          initialZoom: 12.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          MarkerLayer(
            markers: [
              if (currentLocation != null && currentLocation!.isNotEmpty)
                Marker(
                  point: LatLng(
                    currentLocation?[0]?? 0.0,
                    currentLocation?[1] ?? 0.0,),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin,
                      color: Colors.blue, size: 40),
                ),
              if (toLocation != null)
                Marker(
                  point: LatLng(toLocation![0], toLocation![1]),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin,
                      color: Colors.red, size: 40),
                ),

            ],
          ),
          // if (routePoints.isNotEmpty)
          //   PolylineLayer(
          //     polylines: [
          //       Polyline(
          //         points: routePoints,
          //         color: Colors.blue,
          //         strokeWidth: 4.0,
          //       ),
          //     ],
          //   ),
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
            _buildTopMap(context),
          ],
        );
      });
    });
  }
}
