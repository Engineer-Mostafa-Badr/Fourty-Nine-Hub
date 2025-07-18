import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/gmap_search_and_pick.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/osm_search_and_pick.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/screen/custom_map.dart';
import 'package:fourtyninehub/features/new_trip_join/controllers/captain_share_cubit/captain_share_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/create_price_per_seat_use_case.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../settings/presentation/pages/widgets/custombutton.dart';
import '../widget/alert_text_widget.dart';
import '../widget/premium_and_request_widget.dart';
import '../widget/price_and_seat_widget.dart';
import '../widget/switch_widget.dart';
import '../widget/welcome_text_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;

class NewRouteScreen extends StatefulWidget {
  const NewRouteScreen({super.key});

  @override
  State<NewRouteScreen> createState() => _NewRouteScreenState();
}

class _NewRouteScreenState extends State<NewRouteScreen> {

  @override
  Widget build(BuildContext context) {
    return const SharedScaffold(
      mainCategoryId: 1,isWithBackArrow: true,
      body: NewRouteBody(),
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

  initState() {
    super.initState();
    context.read<CaptainShareCubit>().fetchUserLocation();
  }

  // List<double>? currentLocation;
  // List<double>? toLocation;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaptainShareCubit,CaptainShareState>(
      builder: (context,state) {
        var cubit = context.read<CaptainShareCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: WelcomeTextWidget(),
            ),
            const SizedBox(height: 10),
            _buildTopImage(state.pricePerSeat?.polyline??[],state),
            Expanded(child: ListView(
              children: [
                SizedBox(height: 10.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _customLocationField(
                    isTo: false,
                    context: context,
                    color: Colors.green,
                    text: state.currentLocation?.address,
                    onPressed: () async {
                      if (context.isUserLoggedIn) {
                        context.push(
                          Routes.GoogleMapsSearchAndPick,
                          extra: RideGoogleMapSearchAndPickParams(
                            minDistanceReferencePoint: state.toLocation == null ? null : LatLng(state.toLocation!.lat!, state.toLocation!.lng!),
                            onPicked: (pickedData) async {
                              cubit.updateFromLocation(
                                lat: pickedData.latitude,
                                lng: pickedData.longitude,
                                address: pickedData.address,
                              );
                              if (state.toLocation == null) {
                                context.pop();
                                return;
                              }
                              await cubit.createOffer(context: context,params: CreatePricePerSeatParams(
                                  fromLocation: [
                                    pickedData.latitude,
                                    pickedData.longitude
                                  ],
                                  toLocation: [
                                    state.toLocation!.lat!,
                                    state.toLocation!.lng!
                                  ],
                                  isComfort: isComfort,
                                  isLadiesPassenger: isLady,
                                  isLadiesDriver: isLadyDriver
                              ));                              context.pop();
                            },
                          ),
                        );
                      } else {
                        context.push(Routes.LOGIN);
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _customLocationField(
                    isTo: true,
                    context: context,
                    color: Colors.blue,
                    text: state.toLocation?.address,
                    onPressed: () async {
                      if (context.isUserLoggedIn) {
                        context.push(
                          Routes.GoogleMapsSearchAndPick,
                          extra: RideGoogleMapSearchAndPickParams(
                            minDistanceReferencePoint: state.currentLocation == null ? null : LatLng(state.currentLocation!.lat!, state.currentLocation!.lng!),
                            onPicked: (pickedData) async {
                              await cubit.updateToLocation(
                                lat: pickedData.latitude,
                                lng: pickedData.longitude,
                                address: pickedData.address,
                              );
                              print("state.currentLocation ${state.currentLocation} state.toLocation ${state.toLocation}");
                              if (state.currentLocation == null) {
                                context.pop();
                                return;
                              }
                              await cubit.createOffer(context: context,params: CreatePricePerSeatParams(
                                  fromLocation: [
                                    state.currentLocation!.lat!,
                                    state.currentLocation!.lng!
                                  ],
                                  toLocation: [
                                    pickedData.latitude,
                                    pickedData.longitude
                                  ],
                                  isComfort: isComfort,
                                  isLadiesPassenger: isLady,
                                  isLadiesDriver: isLadyDriver
                              ));
                              context.pop();
                            },
                          ),
                        );
                      } else {
                        context.push(Routes.LOGIN);
                      }
                    },
                  ),
                ),
                PriceAndSeatWidget(price: state.pricePerSeat?.finalPricePerSeat,),
                SizedBox(height: 10.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      SwitchWidget(
                          title: LocaleKeys.comfort.localize,
                          value: isComfort,
                          onChanged: (val) {
                            if (state.currentLocation == null || state.toLocation == null) {
                              return;
                            }
                            setState(() => isComfort = val);
                            cubit.createOffer(context: context,params: CreatePricePerSeatParams(
                                fromLocation: [
                                  state.currentLocation!.lat!,
                                  state.currentLocation!.lng!
                                ],
                                toLocation: [
                                  state.toLocation!.lat!,
                                  state.toLocation!.lng!
                                ],
                                isComfort: isComfort,
                                isLadiesPassenger: isLady,
                                isLadiesDriver: isLadyDriver
                            ));
                          }),
                      SwitchWidget(
                          title: context.isArabic?'راكبات سيدات':'Lady Passengers',
                          value: isLady,
                          onChanged: (val) {
                            bool gender = UserCubit.to.state.data?.gender=='male';
                            if(gender){
                              showErrorMessage(context, context.isArabic?'أنت رجل و لا يمكنك تحديد هذا الخيار':'You are a man and you can not select this option');
                              return;
                            }
                            if (state.currentLocation == null || state.toLocation == null) {
                              return;
                            }
                            setState(() => isLady = val);
                            cubit.createOffer(context: context,params: CreatePricePerSeatParams(
                                fromLocation: [
                                  state.currentLocation!.lat!,
                                  state.currentLocation!.lng!
                                ],
                                toLocation: [
                                  state.toLocation!.lat!,
                                  state.toLocation!.lng!
                                ],
                                isComfort: isComfort,
                                isLadiesPassenger: isLady,
                                isLadiesDriver: isLadyDriver
                            ));
                          }),
                      SwitchWidget(
                          title: context.isArabic?'سائقة':'Lady Driver',
                          value: isLadyDriver,
                          onChanged: (val) {
                            bool gender = UserCubit.to.state.data?.gender=='male';
                            if(gender){
                              showErrorMessage(context, context.isArabic?'أنت رجل و لا يمكنك تحديد هذا الخيار':'You are a man and you can not select this option');
                              return;
                            }
                            setState(() => isLadyDriver = val);
                            cubit.createOffer(context: context,params: CreatePricePerSeatParams(
                                fromLocation: [
                                  state.currentLocation!.lat!,
                                  state.currentLocation!.lng!
                                ],
                                toLocation: [
                                  state.toLocation!.lat!,
                                  state.toLocation!.lng!
                                ],
                                isComfort: isComfort,
                                isLadiesPassenger: isLady,
                                isLadiesDriver: isLadyDriver
                            ));
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
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.getRedColor(context),
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
                      SvgPicture.asset(Assets.visaIcon, width: 40,color: context.isDarkMode?AppColors.Floating_Button_COLOR_DARK:null,),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                PremiumAndRequestWidget(
                  onPremiumRequest: (){
                    cubit.createRoute(context: context,params: CreatePricePerSeatParams(
                        isPremium: true,
                        fromLocation: [
                          state.currentLocation!.lat!,
                          state.currentLocation!.lng!
                        ],
                        toLocation: [
                          state.toLocation!.lat!,
                          state.toLocation!.lng!
                        ],
                        isComfort: isComfort,
                        isLadiesPassenger: isLady,
                        isLadiesDriver: isLadyDriver
                    ));
                  },
                  onRequest: (){
                    cubit.createRoute(context: context,params: CreatePricePerSeatParams(
                        isPremium: false,
                        fromLocation: [
                          state.currentLocation!.lat!,
                          state.currentLocation!.lng!
                        ],
                        toLocation: [
                          state.toLocation!.lat!,
                          state.toLocation!.lng!
                        ],
                        isComfort: isComfort,
                        isLadiesPassenger: isLady,
                        isLadiesDriver: isLadyDriver
                    ));
                  },
                ),
                SizedBox(height: 30.h),
              ],
            ))
          ],
        );
      }
    );
  }

  void showPaymentAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: AppColors.getFillColor(context),
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
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.getRedColor(context),
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
                    color: AppColors.getButtonPrimaryColor(context),
                    text: LocaleKeys.cancel.localize,
                    textStyle: TextStyle(
                        color:
                            context.isDarkMode ? Colors.black : Colors.white),
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
          color: AppColors.getFillColor(context),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: CircleAvatar(
                backgroundColor: color,
                radius: 10,
                child: CircleAvatar(
                    backgroundColor: AppColors.getFillColor(context),
                    radius: 5),
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
                        : text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.getTextColor(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopMap(CaptainShareState state, BuildContext context) {
    List<gmap.LatLng> routePoints = [];

    try {
        routePoints = _convertPolylineToLatLng(state.pricePerSeat?.polyline??[]);
    } catch (e) {
      print('Error processing route points: $e');
      routePoints = [];
    }

    List<gmap.LatLng> clients = [];

    // Provide default values to prevent null issues
    final startLat = state.currentLocation?.lat ?? 30.033333;
    final startLng = state.currentLocation?.lng ?? 31.233334;
    final targetLat = state.toLocation?.lat?? 30.043333;
    final targetLng = state.toLocation?.lng ?? 31.243334;

    return Container(
      width: double.infinity,
      height:MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.grey,
      ),
      child: ClipRect(
        child: CustomGoogleMap(
          // key: ValueKey('map_${DateTime.now().millisecondsSinceEpoch}'), // Force rebuild
          startLocation: state.currentLocation==null?null:gmap.LatLng(startLat, startLng),
          targetLocation: state.toLocation==null?null:gmap.LatLng(targetLat, targetLng),
          polylinePoints: routePoints,
          clientLocations: clients,
          enableScrolling: true,
        ),
      ),
    );
    // return SizedBox(
    //   width: double.infinity,
    //   height: state.requestedTrip != null ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 0.5,
    //   child: FlutterMap(
    //     mapController: _mapController,
    //     options: MapOptions(
    //       initialCenter: LatLng(
    //         state.currentLocation?.lat ?? 0.0,
    //         state.currentLocation?.lng ?? 0.0,
    //       ),
    //       initialZoom: 12.0,
    //     ),
    //     children: [
    //       TileLayer(
    //         // urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
    //         // urlTemplate: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
    //         // urlTemplate: "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png",
    //         urlTemplate: context.isDarkMode
    //             ? "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png" // Dark mode map
    //             : "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png", // Normal mode map
    //         subdomains: const ['a', 'b', 'c'],
    //         userAgentPackageName: 'com.example.app',
    //       ),
    //       MarkerLayer(
    //         markers: [
    //           if (state.currentLocation != null)
    //             Marker(
    //               point: LatLng(state.currentLocation!.lat!, state.currentLocation!.lng!),
    //               width: 40,
    //               height: 40,
    //               child: const Icon(Icons.location_pin, color: Colors.green, size: 40),
    //             ),
    //           if (state.toLocation != null)
    //             Marker(
    //               point: LatLng(state.toLocation!.lat!, state.toLocation!.lng!),
    //               width: 40,
    //               height: 40,
    //               child: const Icon(Icons.location_pin, color: Colors.blue, size: 40),
    //             ),
    //           if (state.wayPointOne != null)
    //             Marker(
    //               point: LatLng(state.wayPointOne!.lat!, state.wayPointOne!.lng!),
    //               width: 40,
    //               height: 40,
    //               child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
    //             ),
    //           if (state.wayPointTwo != null)
    //             Marker(
    //               point: LatLng(state.wayPointTwo!.lat!, state.wayPointTwo!.lng!),
    //               width: 40,
    //               height: 40,
    //               child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
    //             ),
    //         ],
    //       ),
    //       if (state.requestedTrip != null)
    //         if (state.requestedTrip!.status == TripState.started.name)
    //           BlocBuilder<RideCubit, RideState>(builder: (context, state) {
    //             return const CarMarkerOnClientSideWidget();
    //           }),
    //       if (routePoints.isNotEmpty)
    //         PolylineLayer(
    //           polylines: [
    //             Polyline(
    //               points: routePoints,
    //               color: context.isDarkMode ? Colors.blue : Colors.black87,
    //               strokeWidth: 4.0,
    //             ),
    //           ],
    //         ),
    //     ],
    //   ),
    // );
  }

  List<gmap.LatLng> _convertPolylineToLatLng(List<List<double>> polyline) {
    return polyline.map((point) => gmap.LatLng(point[1], point[0])).toList();
  }

  Widget _buildTopImage(List<List<double>> routePoints,CaptainShareState state) {
    return _buildTopMap(state,context);
  }
}
