import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/constants/registration_status.dart';
import 'package:fourtyninehub/core/enums/trip_states_enum.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_info_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/loading_info_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_offer_entity.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/upload_rider_images.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/client_rate_driver_sheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/ride_mode_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/expired_trips_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/osm_search_and_pick.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_personal_more_info_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_status_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/running_trips_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/bottom_button_ride_status_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/bottom_card_request.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/bottom_sheet/custom_reserve_ride_bottomsheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/driver_header_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/feedback_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/location_info_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/payment_info_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/top_card_request.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/custom_ride_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/form/text_fields/new_phone_number_text_field.dart';
import '../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
import '../../../../core/messages/messages.dart';
import '../../../../core/utils/format_numbers.dart';
import '../../../../core/utils/validator.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../service_locator/service_locator.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../domain/entities/get_location_from_address_entity.dart';
import '../../domain/usecases/rating_driver_by_client.dart';
import '../controllers/cubits/car_location_cubit.dart';
import 'widgets/add_stops_widget.dart';
import 'widgets/bottom_sheet/custom_bottom_sheet.dart';
import 'widgets/fare_bottom_sheet_widget.dart';
import 'widgets/options_bottomsheet_widget.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

class RideHome extends StatefulWidget {
  const RideHome({super.key});

  @override
  State<RideHome> createState() => _RideHomeState();
}

class _RideHomeState extends State<RideHome> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  final MapController _mapController = MapController();

  final GlobalKey<FormState> _phoneNumberFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rideCubit = serviceLocator<RideCubit>();
      if (!rideCubit.isClosed) {
        rideCubit.initHome(context);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildPendingSheet() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: BlocBuilder<RideCubit, RideState>(
        builder: (context, state) {
          return SafeArea(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: context.isDarkMode ? AppColors.QUANTITY_COLOR : AppColors.whiteColor,
              ),
              child: BottomCardRequest(
                driversCount: serviceLocator<RideCubit>().tripViewers.length,
                rideCubit: serviceLocator<RideCubit>(),
                onCancel: () async {
                  await context.read<RideCubit>().cancelPendingTripByClient(
                        tripId: context.read<RideCubit>().state.requestedTrip?.id ?? '',
                      );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildDriversOffers(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: BlocBuilder<RideCubit, RideState>(
        builder: (context, state) {
          return SafeArea(
            child: SizedBox(
              // height: MediaQuery.of(context).size.height * 0.6,
              child: _buildDriversOffers(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDriversOffers() {
    return BlocBuilder<RideCubit, RideState>(
      builder: (context, state) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: state.rideOffers.length,
            itemBuilder: (context, index) {
              final RideOfferEntity offerEntity = state.rideOffers[index];
              return TopCardRequest(
                rideOffer: offerEntity,
                rideCubit: serviceLocator<RideCubit>(),
                onAccept: () async {
                  await context.read<RideCubit>().acceptOfferByClient(offerId: offerEntity.offerId);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget acceptedTripButtonSheet() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: BlocBuilder<RideCubit, RideState>(builder: (context, state) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.25,
            // maxChildSize: 0.75,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlocBuilder<RideCubit, RideState>(builder: (context, state) {
                        print("state.requestedTrip?.status ${state.requestedTrip?.status}");
                        return DriverHeaderWidget(
                          carModel: state.requestedTrip?.vehicleModel,
                          carColor: state.requestedTrip?.vehicleColor,
                          rideStatusWidget: state.requestedTrip?.status == TripState.started.name
                              ? TripDurationCountdown(
                                  key: ValueKey("${state.requestedTrip?.driverIsArrivingIn}_${state.requestedTrip?.status}"),
                                  tripDurationSeconds: state.requestedTrip?.duration?.toDouble(),
                                  isArabic: context.isArabic,
                                )
                              : DriverArrivalCountdown(
                                  key: ValueKey("${state.requestedTrip?.driverIsArrivingIn}_${state.requestedTrip?.status}"),
                                  arrivalTimestampMs: state.requestedTrip?.driverIsArrivingIn ?? 0,
                                  isCountdown: state.requestedTrip?.status == TripState.goToClient.name,
                                  isInLocation: state.requestedTrip?.status == TripState.inLocation.name,
                                ),
                          carImageUrl: state.requestedTrip?.vehiclePicture ?? "https://www.hyundai.com/content/dam/hyundai/in/en/data/find-a-car/i20/Highlights/pc/i20_Modelpc.png",
                          carName: state.requestedTrip?.vehicleBrand,
                          carNumber: state.requestedTrip?.vehiclePlateNumber ?? "",
                        );
                      }),
                      if (state.requestedTrip?.status != TripState.inLocation.name) const Divider(height: 1),
                      if (state.requestedTrip?.status == TripState.inLocation.name)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Container(
                              decoration: BoxDecoration(
                                color: context.isDarkMode ? AppColors.GREY_DARK_COLOR : AppColors.GREY_NORMAL_COLOR.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    BlocBuilder<RideCubit, RideState>(builder: (context, state) {
                                      return CountdownTimerWidget(
                                        isActive: state.requestedTrip?.status == TripState.inLocation.name,
                                        isArabic: context.isArabic,
                                      );
                                    }),
                                    const SizedBox(height: 16),
                                    GestureDetector(
                                      onTap: () async {
                                        await serviceLocator<RideCubit>().sendIamOkMessage(context);
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.6,
                                        decoration: BoxDecoration(
                                          color: AppColors.PRIMARY_COLOR,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              context.isArabic ? "حسنا، أنا قادم" : "Ok, I'm coming",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ActionButtonsWidget(
                        driverImageUrl: state.requestedTrip?.driverProfilePicture,
                        driverRating: state.requestedTrip?.driverRating,
                        driverName: state.requestedTrip?.driverFirstName ?? "",
                        onContactDriver: () {
                          // context.push(Routes.ratingClientScreen);
                        },
                        onSafety: () {
                          // context.push(Routes.rideArrivedScreen);
                        },
                        is_show_message: true,
                        onMessage: () {},
                      ),
                      // const FeedbackWidget(),
                      // const Divider(height: 2),
                      Container(
                          decoration: BoxDecoration(
                            color: context.isDarkMode ? AppColors.GREY_DARK_COLOR : AppColors.GREY_NORMAL_COLOR.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.PRIMARY_COLOR),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Center(child: Text(context.isArabic ? "الابلاغ عن السائق" : "Report Driver")),
                          )),

                      BottomRideStatusWidget(
                        price: state.requestedTrip?.price?.toInt() ?? 0,
                        fromLocation: state.requestedTrip?.from ?? 'أول العاشر من رمضان',
                        toLocation: state.requestedTrip?.to ?? 'المنطقة الصناعية الثالثة العاشر من رمضان (10th of Ramadan City 1) العالمية',
                        onGoogleMap: () {},
                        onPartialPayment: () {},
                        onCallEmergency: () {},
                        onCancelRide: () {},
                        isRecording: state.requestedTrip?.status == TripState.started.name,
                        audioDuration: '',
                        onMicTap: () {},
                        paymentMethod: state.requestedTrip?.paymentMethod ?? "cash",
                        wayPointOne: state.requestedTrip?.wayPointOneTitle,
                        wayPointTwo: state.requestedTrip?.wayPointTwoTitle,
                        otp: state.requestedTrip?.otp,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  final ScrollController _rideScrollController = ScrollController();
  final ScrollController _shippingScrollController = ScrollController();

  void _scrollRight(String type) {
    final ScrollController? activeController = type == "ride" ? _rideScrollController : _shippingScrollController;

    if (activeController != null && activeController.hasClients) {
      activeController.animateTo(
        activeController.offset + 200,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToStart(String type) {
    final ScrollController? activeController = type == "ride" ? _rideScrollController : _shippingScrollController;

    if (activeController != null && activeController.hasClients) {
      activeController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RideCubit, RideState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = serviceLocator<RideCubit>();
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (c, v) => context.go(Routes.HOME),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: cubit.loadingHomeData == true
                  ? const Center(child: CircularProgressIndicator())
                  : Form(
                      key: _formKey,
                      child: SafeArea(
                        child: SharedScaffold(
                          mainCategoryId: 2,
                          body: NestedAppbar(
                            scrollController: _scrollController,
                            appBars: const [],
                            body: Stack(
                              children: [
                                context.read<RideCubit>().selectedCategoryIsSocket ? _buildTopImage() : const SizedBox.shrink(),
                                state.requestedTrip == null
                                    ? _buildBottomSheet()
                                    : state.requestedTrip!.status == TripState.completed.name || state.requestedTrip!.status == TripState.canceled.name
                                        ? _buildBottomSheet()
                                        : const SizedBox.shrink(),
                                !context.read<RideCubit>().selectedCategoryIsSocket
                                    ? const SizedBox()
                                    : state.requestedTrip == null
                                        ? const SizedBox()
                                        : state.requestedTrip!.status == TripState.pending.name
                                            ? buildDriversOffers(context)
                                            : const SizedBox(),
                                !context.read<RideCubit>().selectedCategoryIsSocket
                                    ? const SizedBox()
                                    : state.requestedTrip == null
                                        ? _buildBottomSheet()
                                        : state.requestedTrip!.status == TripState.completed.name || state.requestedTrip!.status == TripState.canceled.name
                                            ? _buildBottomSheet()
                                            : state.requestedTrip!.status == TripState.pending.name
                                                ? buildPendingSheet()
                                                : state.requestedTrip!.status == TripState.accepted.name ||
                                                        state.requestedTrip!.status == TripState.goToClient.name ||
                                                        state.requestedTrip!.status == TripState.inLocation.name ||
                                                        state.requestedTrip!.status == TripState.started.name
                                                    ? acceptedTripButtonSheet()
                                                    : state.requestedTrip!.status == TripState.ratingSheet.name
                                                        ? BuildClientRateDriverSheet(
                                                            onPressed: (String message, double rate) async {
                                                              await serviceLocator<RideCubit>().ratingDriverByClient(
                                                                context,
                                                                RatingDriverByClientUseCaseParams(
                                                                  tripId: state.requestedTrip!.id!,
                                                                  ratingValue: rate.toInt(),
                                                                  comment: message,
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        : const SizedBox(),
                                context.read<RideCubit>().selectedCategoryIsSocket &&
                                        (state.requestedTrip == null ||
                                            state.requestedTrip?.status == TripState.completed.name ||
                                            state.requestedTrip?.status == TripState.canceled.name)
                                    ? _carTruckBtn(
                                        driverInfo: state.driverInfo,
                                        loadingInfo: state.loaderInfo,
                                        openDrawer: () {
                                          showModalBottomSheet(
                                            backgroundColor: context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.white,
                                            context: context,
                                            builder: (context) => _buttonsWidget(
                                              driverInfo: state.driverInfo,
                                              loadingInfo: state.loaderInfo,
                                            ),
                                          );
                                        })
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          );
        });
  }

  Widget _buildTopMap(RideState state, BuildContext context) {
    List<LatLng> routePoints = [];
    if (state.requestedTrip == null || state.requestedTrip!.status == TripState.canceled.name || state.requestedTrip!.status == TripState.completed.name) {
      routePoints = _convertPolylineToLatLng(state.rideExpectedPrice?.polyline ?? []);
    } else {
      routePoints = _convertPolylineToLatLng(state.requestedTrip?.polyline ?? []);
    }

    if (state.currentLocation != null && state.rideExpectedPrice == null && state.requestedTrip == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(
          LatLng(state.currentLocation!.lat!, state.currentLocation!.lng!),
          12.0,
        );
      });
    }

    return SizedBox(
      width: double.infinity,
      height: state.requestedTrip != null ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 0.5,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(
            state.currentLocation?.lat ?? 0.0,
            state.currentLocation?.lng ?? 0.0,
          ),
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
              if (state.currentLocation != null)
                Marker(
                  point: LatLng(state.currentLocation!.lat!, state.currentLocation!.lng!),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin, color: Colors.green, size: 40),
                ),
              if (state.toLocation != null)
                Marker(
                  point: LatLng(state.toLocation!.lat!, state.toLocation!.lng!),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin, color: Colors.blue, size: 40),
                ),
              if (state.wayPointOne != null)
                Marker(
                  point: LatLng(state.wayPointOne!.lat!, state.wayPointOne!.lng!),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                ),
              if (state.wayPointTwo != null)
                Marker(
                  point: LatLng(state.wayPointTwo!.lat!, state.wayPointTwo!.lng!),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                ),
            ],
          ),
          if (state.requestedTrip != null)
            if (state.requestedTrip!.status == TripState.started.name)
              BlocBuilder<RideCubit, RideState>(builder: (context, state) {
                return const CarMarkerWidget();
              }),
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

  List<LatLng> _convertPolylineToLatLng(List<List<double>> polyline) {
    return polyline.map((point) => LatLng(point[1], point[0])).toList();
  }

  Widget _buttonsWidget({LoadingInfoEntity? loadingInfo, DriverInfoEntity? driverInfo}) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      children: [
        Align(
          alignment: AlignmentDirectional.topStart,
          child: ClickableWidget(
              onTap: () => context.pop(),
              child: const Icon(
                Icons.close,
                color: AppColors.black,
              )),
        ),
        const Sizer(),
        GestureDetector(
          onTap: () {
            if (!context.read<UserCubit>().isLoggedIn) {
              return pleaseLoginDialog(context);
            }
            context.pop();
            if (driverInfo == null || (driverInfo.driverType?.isEmpty ?? false)) {
              serviceLocator<RideCubit>().onNavigateToWelcomeScreen(fromShipping: false, context: context);
            } else {
              if (driverInfo.status == RegistrationStatus.pending.status) {
                return;
              } else if (driverInfo.status == RegistrationStatus.rejected.status) {
                context.push(Routes.UploadRiderImages, extra: UploadRiderImagesParams(isShipping: false, isSocket: driverInfo.driverType == 'socket' ? true : false));
              } else if (driverInfo.status == RegistrationStatus.initial.status) {
                context.push(Routes.UploadRiderImages, extra: UploadRiderImagesParams(isShipping: false, isSocket: driverInfo.driverType == 'socket' ? true : false));
              } else {
                context.push(Routes.rideModeScreen, extra: RideModeParams(modeType: 'ride', isSocket: driverInfo.driverType == 'socket' ? true : false));
              }
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: driverInfo != null && (driverInfo.status == RegistrationStatus.approved.status)
                    ? [
                        AppColors.cF33D49,
                        AppColors.cC0303A,
                        AppColors.cA72A32,
                        AppColors.c9A272E,
                        AppColors.c93252C,
                        AppColors.c90242B,
                      ]
                    : [const Color(0xFF0B1035), const Color(0xFF161F68), const Color(0xFF1B2781), const Color(0xFF1E2B8E), const Color(0xFF1F2D95), const Color(0xFF0B1035)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3)),
              ],
            ),
            child: Center(
              child: Text(
                driverInfo == null
                    ? context.isArabic
                        ? 'تسجيل سائق سيارة'
                        : 'Ride Register'
                    : (driverInfo.status == RegistrationStatus.approved.status)
                        ? context.isArabic
                            ? 'وضع سائق سيارة'
                            : 'Ride Mode'
                        : (driverInfo.status == RegistrationStatus.initial.status)
                            ? context.isArabic
                                ? 'استكمال تسجيل سائق'
                                : 'Complete Ride Register'
                            : (driverInfo.status == RegistrationStatus.pending.status)
                                ? context.isArabic
                                    ? 'انتظار موافقة تسجيل سائق'
                                    : 'Waiting ِApproval Ride Register'
                                : context.isArabic
                                    ? 'تسجيل سائق سيارة'
                                    : 'Ride Register',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const Sizer(),
        GestureDetector(
          onTap: () {
            if (!context.read<UserCubit>().isLoggedIn) {
              context.pop();
              return pleaseLoginDialog(context);
            }
            context.pop();
            if (loadingInfo == null || (loadingInfo.status?.isEmpty ?? false)) {
              print("object");
              serviceLocator<RideCubit>().onNavigateToWelcomeScreen(fromShipping: true, context: context);
            } else {
              print("loadingInfo.toJson()${loadingInfo.toJson()}");
              if (loadingInfo.status == RegistrationStatus.pending.status) {
                return;
              } else if (loadingInfo.status == RegistrationStatus.rejected.status) {
                context.push(Routes.UploadRiderImages, extra: UploadRiderImagesParams(isShipping: true, isSocket: false));
              } else if (loadingInfo.status == RegistrationStatus.initial.status) {
                context.push(Routes.UploadRiderImages, extra: UploadRiderImagesParams(isShipping: true, isSocket: false));
              } else {
                context.push(Routes.rideModeScreen, extra: RideModeParams(modeType: 'truck', isSocket: driverInfo?.driverType == 'socket' ? true : false));
              }
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: loadingInfo != null && (loadingInfo.status == RegistrationStatus.approved.status)
                    ? [
                        AppColors.cF33D49,
                        AppColors.cC0303A,
                        AppColors.cA72A32,
                        AppColors.c9A272E,
                        AppColors.c93252C,
                        AppColors.c90242B,
                      ]
                    : [const Color(0xFF0B1035), const Color(0xFF161F68), const Color(0xFF1B2781), const Color(0xFF1E2B8E), const Color(0xFF1F2D95), const Color(0xFF0B1035)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3)),
              ],
            ),
            child: Center(
              child: Text(
                loadingInfo == null
                    ? context.isArabic
                        ? 'تسجيل سائق نقل'
                        : 'Truck Register'
                    : (loadingInfo.status == RegistrationStatus.approved.status)
                        ? context.isArabic
                            ? 'وضع سائق نقل'
                            : 'Truck Mode'
                        : (loadingInfo.status == RegistrationStatus.initial.status)
                            ? context.isArabic
                                ? 'استكمال تسجيل سائق نقل'
                                : 'Complete Truck Register'
                            : (loadingInfo.status == RegistrationStatus.pending.status)
                                ? context.isArabic
                                    ? 'انتظار موافقة تسجيل سائق'
                                    : 'Waiting ِApproval Truck Register'
                                : context.isArabic
                                    ? 'تسجيل سائق نقل'
                                    : 'Truck Register',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const Sizer(),
        GestureDetector(
          onTap: () {
            if (context.isUserLoggedIn) {
              context.pop();
              context.push(Routes.rideOffer, extra: (serviceLocator<RideCubit>().state.selectedType?.isNotEmpty??false)?serviceLocator<RideCubit>().state.selectedType:!context.read<RideCubit>().selectedCategoryIsSocket?'shipping':'ride');
            } else {
              context.pop();
              return pleaseLoginDialog(context);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0B1035), Color(0xFF161F68), Color(0xFF1B2781), Color(0xFF1E2B8E), Color(0xFF1F2D95), Color(0xFF0B1035)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3)),
              ],
            ),
            child: Center(
              child: Text(
                context.isArabic ? 'وضع المستخدم' : 'User Mode',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const Sizer(),
        GestureDetector(
          onTap: () {
            if (context.isUserLoggedIn) {
              context.pop();
              context.push(Routes.RIDEACTIVITY);
            } else {
              context.pop();
              pleaseLoginDialog(context);
              // context.push(Routes.LOGIN);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0B1035), Color(0xFF161F68), Color(0xFF1B2781), Color(0xFF1E2B8E), Color(0xFF1F2D95), Color(0xFF0B1035)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3)),
              ],
            ),
            child: Center(
              child: Text(
                context.isArabic ? 'سجل الرحلات' : 'Ride Log',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _carTruckBtn({LoadingInfoEntity? loadingInfo, DriverInfoEntity? driverInfo, required Function openDrawer}) {
    print("loadingInfo?.status ${loadingInfo?.status}");
    print("loadingInfo?.status ${loadingInfo?.status}");
    print("loadingInfo?.status ${driverInfo?.driverType}");
    print("loadingInfo?.status ${driverInfo?.driverType}");
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      width: double.infinity,
      height: 75,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClickableWidget(
            onTap: () => openDrawer(),
            child: Container(
              width: 85.w,
              height: kToolbarHeight * 1.2.h,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(4),
              alignment: Alignment.center,
              child: Image.asset(
                Assets.rideMenu,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 50,
              child: GestureDetector(
                onTap: () {
                  if ((driverInfo == null || (driverInfo.status != RegistrationStatus.approved.status)) &&
                      (loadingInfo == null || (loadingInfo.status != RegistrationStatus.approved.status))) {
                    openDrawer();
                  } else if ((driverInfo != null && (driverInfo.status == RegistrationStatus.approved.status)) &&
                      (loadingInfo != null && (loadingInfo.status == RegistrationStatus.approved.status))) {
                    openDrawer();
                  } else {
                    if ((driverInfo != null && (driverInfo.status == RegistrationStatus.approved.status)) &&
                        (loadingInfo == null || (loadingInfo.status != RegistrationStatus.approved.status))) {
                      context.push(Routes.rideModeScreen, extra: RideModeParams(modeType: 'ride', isSocket: driverInfo.driverType == 'socket' ? true : false));
                    } else if ((driverInfo == null || (driverInfo.status != RegistrationStatus.approved.status)) &&
                        (loadingInfo != null && (loadingInfo.status == RegistrationStatus.approved.status))) {
                      context.push(Routes.rideModeScreen, extra: RideModeParams(modeType: 'truk', isSocket: driverInfo?.driverType == 'socket' ? true : false));
                    }
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: ((driverInfo != null && (driverInfo.status == RegistrationStatus.approved.status)) ||
                              (loadingInfo != null && (loadingInfo.status == RegistrationStatus.approved.status)))
                          ? [
                              AppColors.cF33D49,
                              AppColors.cC0303A,
                              AppColors.cA72A32,
                              AppColors.c9A272E,
                              AppColors.c93252C,
                              AppColors.c90242B,
                            ]
                          : [const Color(0xFF0B1035), const Color(0xFF161F68), const Color(0xFF1B2781), const Color(0xFF1E2B8E), const Color(0xFF1F2D95), const Color(0xFF0B1035)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      ((driverInfo != null && (driverInfo.status == RegistrationStatus.approved.status)) ||
                              (loadingInfo != null && (loadingInfo.status == RegistrationStatus.approved.status)))
                          ? context.isArabic
                              ? 'وضع السائق'
                              : 'Driver Mode'
                          : LocaleKeys.carTruckRegister.tr(),
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
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

  Widget _buildBottomSheet() {
    return Positioned(
      bottom: !context.read<RideCubit>().selectedCategoryIsSocket ? null : 0,
      left: 0,
      right: 0,
      child: Column(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        children: [
          context.read<RideCubit>().selectedCategoryIsSocket
              ? Padding(
                  padding: const EdgeInsetsDirectional.only(end: 16.0, start: 16.0, bottom: 0),
                  child: Row(
                    spacing: 6,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          Assets.targetLocation,
                        ),
                      ),
                      Expanded(
                        child: ClickableWidget(
                            onTap: () {
                              context.push(Routes.RIDERUNNINGTRIPS,
                                  extra: RunningTripParams(
                                    rideCubit: serviceLocator<RideCubit>(),
                                  ));
                            },
                            child: _tripsWidget(LocaleKeys.runningTrips.tr(), color: AppColors.GREYCARD)),
                      ),
                      Expanded(
                        child: ClickableWidget(
                            onTap: () {
                              context.push(Routes.RIDEEXPIREDTRIPE,
                                  extra: ExpiredTripsScreenParams(
                                    rideCubit: serviceLocator<RideCubit>(),
                                  ));
                            },
                            child: _tripsWidget(LocaleKeys.expiredTrips.tr(), color: AppColors.GREYCARD)),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 16, top: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: !context.read<RideCubit>().selectedCategoryIsSocket
                  ? null
                  : const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
            ),
            child: BlocBuilder<RideCubit, RideState>(
              builder: (context, state) {
                // var cubit = serviceLocator<RideCubit>();
                return SingleChildScrollView(
                  child: Column(
                    spacing: 8,
                    children: [
                      if (!context.read<RideCubit>().selectedCategoryIsSocket || state.selectedType == 'shipping')
                        _carTruckBtn(
                            driverInfo: state.driverInfo,
                            loadingInfo: state.loaderInfo,
                            openDrawer: () {
                              showModalBottomSheet(
                                backgroundColor: context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.white,
                                context: context,
                                builder: (context) => _buttonsWidget(
                                  driverInfo: state.driverInfo,
                                  loadingInfo: state.loaderInfo,
                                ),
                              );
                            }),
                      _buildCategoryList("ride", state.rideCategory?.subCategories ?? []),
                      _buildCategoryList("shipping", state.shippingCategory?.subCategories ?? []),
                      if (!context.read<RideCubit>().selectedCategoryIsSocket)
                        RidePersonalMoreInfoScreen(
                          isTruk: context.read<RideCubit>().isTruk,
                          subCategoryId: context.read<RideCubit>().subCategoryId,
                            type: context.read<RideCubit>().state.selectedType??'ride'
                        ),
                      context.read<RideCubit>().selectedCategoryIsSocket
                          ? _customLocationField(
                              isTo: false,
                              color: Colors.green,
                              text: state.currentLocation?.address,
                              onPressed: () async {
                                if (context.isUserLoggedIn) {
                                  context.push(
                                    Routes.RIDEOPENSTREETMAPSEARCHANDPICK,
                                    extra: RideOpenStreetMapSearchAndPickParams(
                                      minDistanceReferencePoint: state.toLocation == null ? null : LatLng(state.toLocation!.lat!, state.toLocation!.lng!),
                                      onPicked: (pickedData) async {
                                        serviceLocator<RideCubit>().updateFromLocation(
                                          lat: pickedData.latLong.latitude,
                                          lng: pickedData.latLong.longitude,
                                          address: pickedData.addressName,
                                        );
                                        await context.read<RideCubit>().fetchRideExpectedPrice(id: 'id');
                                        context.pop();
                                      },
                                    ),
                                  );
                                } else {
                                  context.push(Routes.LOGIN);
                                }
                              },
                            )
                          : const SizedBox(),
                      context.read<RideCubit>().selectedCategoryIsSocket
                          ? _customLocationField(
                              isTo: true,
                              color: Colors.blue,
                              text: state.toLocation?.address,
                              onPressed: () async {
                                if (context.isUserLoggedIn) {
                                  context.push(
                                    Routes.RIDEOPENSTREETMAPSEARCHANDPICK,
                                    extra: RideOpenStreetMapSearchAndPickParams(
                                      minDistanceReferencePoint: state.currentLocation == null ? null : LatLng(state.currentLocation!.lat!, state.currentLocation!.lng!),
                                      onPicked: (pickedData) async {
                                        serviceLocator<RideCubit>().updateToLocation(
                                          lat: pickedData.latLong.latitude,
                                          lng: pickedData.latLong.longitude,
                                          address: pickedData.addressName,
                                        );
                                        await context.read<RideCubit>().fetchRideExpectedPrice(id: 'id');
                                        context.pop();
                                      },
                                    ),
                                  );
                                } else {
                                  context.push(Routes.LOGIN);
                                }
                              },
                            )
                          : const SizedBox(),
                      context.read<RideCubit>().selectedCategoryIsSocket ? _fareField() : const SizedBox(),
                      context.read<RideCubit>().selectedCategoryIsSocket
                          ? SizedBox(
                              height: 40,
                              child: Row(
                                spacing: 6,
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: AppButton(
                                          radius: 15,
                                          label: LocaleKeys.premiumRequest.tr(),
                                          // onPressed: () async {
                                          //   if (context.isUserLoggedIn) {
                                          //     if (state.toLocation != null &&
                                          //         state.currentLocation !=
                                          //             null) {
                                          //       bool isSubscribed = await context
                                          //           .read<RideCubit>()
                                          //           .isSubscribed(
                                          //           userId: UserCubit
                                          //               .to
                                          //               .state
                                          //               .data
                                          //               ?.id ??
                                          //               '',
                                          //           subcategoryId: state
                                          //               .rideCategory
                                          //               ?.subCategories[context
                                          //               .read<
                                          //               RideCubit>()
                                          //               .selectedCategoryIndex!]
                                          //               .subCategoryId ??
                                          //               '');
                                          //       if (!isSubscribed) {
                                          //         SubscriptionMethod()
                                          //             .subscribe(
                                          //             subscribeId: state
                                          //                 .rideCategory
                                          //                 ?.subCategories[context
                                          //                 .read<
                                          //                 RideCubit>()
                                          //                 .selectedCategoryIndex!]
                                          //                 .subCategoryId ??
                                          //                 '',
                                          //             onSubscribe: () {
                                          //               context.pop();
                                          //               context.pop();
                                          //             },
                                          //             showRegular: false,
                                          //             title: LocaleKeys
                                          //                 .premiumRequest
                                          //                 .localize);
                                          //       } else {
                                          //         showModalBottomSheet(
                                          //           context: context,
                                          //           isScrollControlled: true,
                                          //           backgroundColor:
                                          //           Colors.transparent,
                                          //           builder: (context) =>
                                          //               CustomReserveRideBottomSheet(
                                          //                 rideCubit: serviceLocator<
                                          //                     RideCubit>(),
                                          //                 selectedCategoryId: state
                                          //                     .rideCategory
                                          //                     ?.subCategories[
                                          //                 serviceLocator<
                                          //                     RideCubit>()
                                          //                     .selectedCategoryIndex!]
                                          //                     .subCategoryId ??
                                          //                     '',
                                          //                 isPremium: true,
                                          //               ),
                                          //         );
                                          //       }
                                          //     } else {
                                          //       ScaffoldMessenger.of(context)
                                          //           .showSnackBar(
                                          //         SnackBar(
                                          //           content: Text(
                                          //             context.isArabic
                                          //                 ? "يرجى تحديد الموقع"
                                          //                 : "Please select location", // Ensure you define this key in your localization file
                                          //             textAlign:
                                          //             TextAlign.center,
                                          //             style: const TextStyle(
                                          //                 color: Colors.white),
                                          //           ),
                                          //           backgroundColor: Colors.red,
                                          //           duration: const Duration(
                                          //               seconds: 2),
                                          //         ),
                                          //       );
                                          //     }
                                          //   } else {
                                          //     context.push(Routes.LOGIN);
                                          //   }
                                          // },
                                          onPressed: () async {
                                            if (context.isUserLoggedIn) {
                                              if (state.toLocation != null && state.currentLocation != null) {
                                                bool isSubscribed = await context.read<RideCubit>().isSubscribed(
                                                      userId: UserCubit.to.state.data?.id ?? '',
                                                      subcategoryId: state.rideCategory?.subCategories[context.read<RideCubit>().selectedCategoryIndex!].subCategoryId ?? '',
                                                    );
                                                if (!isSubscribed) {
                                                  SubscriptionMethod().subscribe(
                                                      subscribeId: state.rideCategory?.subCategories[context.read<RideCubit>().selectedCategoryIndex!].subCategoryId ?? '',
                                                      onSubscribe: () {
                                                        context.pop();
                                                        context.pop();
                                                      },
                                                      showRegular: false,
                                                      title: LocaleKeys.premiumRequest.localize);
                                                } else {
                                                  // Reset the controller and form state before showing the sheet
                                                  serviceLocator<RideCubit>().phoneNumberController.clear(); // Clear any previous input
                                                  _phoneNumberFormKey.currentState?.reset(); // Reset validation state

                                                  // Show the phone number input bottom sheet
                                                  final bool? isPhoneNumberValid = await showModalBottomSheet<bool>(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    backgroundColor: Colors.transparent,
                                                    builder: (BuildContext context) {
                                                      return Padding(
                                                        padding: EdgeInsets.only(
                                                          bottom: MediaQuery.of(context).viewInsets.bottom,
                                                        ),
                                                        child: Container(
                                                          padding: const EdgeInsets.all(20.0),
                                                          decoration: const BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                                                          ),
                                                          child: Form(
                                                            key: _phoneNumberFormKey, // Use the class-level key
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    const SizedBox(width: 24),
                                                                    Text(
                                                                      LocaleKeys.phoneNumber.localize,
                                                                      style: const TextStyle(
                                                                        fontSize: 18,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    IconButton(
                                                                      icon: const Icon(Icons.close),
                                                                      onPressed: () => Navigator.of(context).pop(false), // Pass false if dismissed without validation
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 20),
                                                                NewPhoneNumberTextFormField(
                                                                  currentController: serviceLocator<RideCubit>().phoneNumberController, // Use the class-level controller
                                                                  keyboardType: TextInputType.number,
                                                                  isRequired: true,
                                                                  validator: validatorEgyptPhone,
                                                                ),
                                                                const SizedBox(height: 20),
                                                                SizedBox(
                                                                  width: double.infinity,
                                                                  child: ElevatedButton(
                                                                    onPressed: () {
                                                                      if (_phoneNumberFormKey.currentState!.validate()) {
                                                                        Navigator.of(context).pop(true); // Pass true if validated
                                                                      }
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: AppColors.PRIMARY_COLOR,
                                                                      padding: const EdgeInsets.symmetric(vertical: 15),
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                    ),
                                                                    child: Text(
                                                                      LocaleKeys.submit.localize,
                                                                      style: const TextStyle(fontSize: 18, color: Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );

                                                  // This block runs after the phone number bottom sheet is dismissed
                                                  // isPhoneNumberValid will be true if validated, false if dismissed without validating
                                                  if (isPhoneNumberValid == true) {
                                                    // If valid, show the CustomReserveRideBottomSheet
                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      backgroundColor: Colors.transparent,
                                                      builder: (context) => CustomReserveRideBottomSheet(
                                                        rideCubit: serviceLocator<RideCubit>(),
                                                        selectedCategoryId:
                                                            state.rideCategory?.subCategories[serviceLocator<RideCubit>().selectedCategoryIndex!].subCategoryId ?? '',
                                                        isPremium: true,
                                                        // Pass the phone number here if CustomReserveRideBottomSheet needs it
                                                        // phoneNumber: _phoneNumberController.text,
                                                      ),
                                                    );
                                                  } else {
                                                    // If phone number is null or invalid, do nothing (sheet already closed)
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          context.isArabic ? "رقم الهاتف غير صالح أو لم يتم إدخاله." : "Phone number is invalid or not entered.",
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(color: Colors.white),
                                                        ),
                                                        backgroundColor: Colors.red,
                                                        duration: const Duration(seconds: 2),
                                                      ),
                                                    );
                                                  }
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      context.isArabic ? "يرجى تحديد الموقع" : "Please select location",
                                                      textAlign: TextAlign.center,
                                                      style: const TextStyle(color: Colors.white),
                                                    ),
                                                    backgroundColor: Colors.red,
                                                    duration: const Duration(seconds: 2),
                                                  ),
                                                );
                                              }
                                            } else {
                                              context.push(Routes.LOGIN);
                                            }
                                          },
                                          backColor: AppColors.SECONDARY_COLOR_DARK2,
                                          width: MediaQuery.of(context).size.width)),
                                  Expanded(
                                      flex: 2,
                                      child: state.isLoadingSubmit
                                          ? const Center(child: CircularProgressIndicator())
                                          : AppButton(
                                              radius: 15,
                                              label: LocaleKeys.request.tr(),
                                              onPressed: () async {
                                                if (context.isUserLoggedIn) {
                                                  if (state.toLocation != null && state.currentLocation != null) {
                                                    // showModalBottomSheet(
                                                    //   context: context,
                                                    //   isScrollControlled: true,
                                                    //   backgroundColor:
                                                    //   Colors.transparent,
                                                    //   builder: (context) =>
                                                    //       BlocProvider.value(
                                                    //           value: serviceLocator<
                                                    //               RideCubit>(),
                                                    //           child:
                                                    //           CustomReserveRideBottomSheet(
                                                    //             rideCubit:
                                                    //             serviceLocator<
                                                    //                 RideCubit>(),
                                                    //             selectedCategoryId: state
                                                    //                 .rideCategory
                                                    //                 ?.subCategories[
                                                    //             serviceLocator<RideCubit>().selectedCategoryIndex!]
                                                    //                 .subCategoryId ??
                                                    //                 '',
                                                    //             isPremium:
                                                    //             false,
                                                    //           )),
                                                    // );
                                                    // Reset the controller and form state before showing the sheet
                                                    serviceLocator<RideCubit>().phoneNumberController.clear(); // Clear any previous input
                                                    _phoneNumberFormKey.currentState?.reset(); // Reset validation state

                                                    // Show the phone number input bottom sheet
                                                    final bool? isPhoneNumberValid = await showModalBottomSheet<bool>(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      backgroundColor: Colors.transparent,
                                                      builder: (BuildContext context) {
                                                        return Padding(
                                                          padding: EdgeInsets.only(
                                                            bottom: MediaQuery.of(context).viewInsets.bottom,
                                                          ),
                                                          child: Container(
                                                            padding: const EdgeInsets.all(20.0),
                                                            decoration: const BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                                                            ),
                                                            child: Form(
                                                              key: _phoneNumberFormKey, // Use the class-level key
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      const SizedBox(width: 24),
                                                                      Text(
                                                                        LocaleKeys.phoneNumber.localize,
                                                                        style: const TextStyle(
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      IconButton(
                                                                        icon: const Icon(Icons.close),
                                                                        onPressed: () => Navigator.of(context).pop(false), // Pass false if dismissed without validation
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 20),
                                                                  NewPhoneNumberTextFormField(
                                                                    currentController: serviceLocator<RideCubit>().phoneNumberController, // Use the class-level controller
                                                                    keyboardType: TextInputType.number,
                                                                    isRequired: true,
                                                                    validator: validatorEgyptPhone,
                                                                  ),
                                                                  const SizedBox(height: 20),
                                                                  SizedBox(
                                                                    width: double.infinity,
                                                                    child: ElevatedButton(
                                                                      onPressed: () {
                                                                        if (_phoneNumberFormKey.currentState!.validate()) {
                                                                          Navigator.of(context).pop(true); // Pass true if validated
                                                                        }
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                        backgroundColor: AppColors.PRIMARY_COLOR,
                                                                        padding: const EdgeInsets.symmetric(vertical: 15),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                        ),
                                                                      ),
                                                                      child: Text(
                                                                        LocaleKeys.submit.localize,
                                                                        style: const TextStyle(fontSize: 18, color: Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );

                                                    // This block runs after the phone number bottom sheet is dismissed
                                                    // isPhoneNumberValid will be true if validated, false if dismissed without validating
                                                    if (isPhoneNumberValid == true) {
                                                      // If valid, show the CustomReserveRideBottomSheet
                                                      showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled: true,
                                                        backgroundColor: Colors.transparent,
                                                        builder: (context) => CustomReserveRideBottomSheet(
                                                          rideCubit: serviceLocator<RideCubit>(),
                                                          selectedCategoryId:
                                                              state.rideCategory?.subCategories[serviceLocator<RideCubit>().selectedCategoryIndex!].subCategoryId ?? '',
                                                          isPremium: false,
                                                          // Pass the phone number here if CustomReserveRideBottomSheet needs it
                                                          // phoneNumber: _phoneNumberController.text,
                                                        ),
                                                      );
                                                    } else {
                                                      // If phone number is null or invalid, do nothing (sheet already closed)
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            context.isArabic ? "رقم الهاتف غير صالح أو لم يتم إدخاله." : "Phone number is invalid or not entered.",
                                                            textAlign: TextAlign.center,
                                                            style: const TextStyle(color: Colors.white),
                                                          ),
                                                          backgroundColor: Colors.red,
                                                          duration: const Duration(seconds: 2),
                                                        ),
                                                      );
                                                    }
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          context.isArabic ? "يرجى تحديد الموقع" : "Please select location", // Ensure you define this key in your localization file
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(color: Colors.white),
                                                        ),
                                                        backgroundColor: Colors.red,
                                                        duration: const Duration(seconds: 2),
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  context.push(Routes.LOGIN);
                                                }
                                              },
                                              backColor: AppColors.PRIMARY_COLOR,
                                              width: MediaQuery.of(context).size.width)),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _tripsWidget(String text, {required Color color}) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: context.isDarkMode ? AppColors.GREY_DARK_COLOR : color, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.DARK_BLUE_COLOR)),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildCategoryList(String type, List subCategories) {
    final ScrollController controller = type == "ride" ? _rideScrollController : _shippingScrollController;

    return Row(
      children: [
        Expanded(
          flex: 9,
          child: SizedBox(
            height: 60,
            child: ListView.builder(
              controller: controller, // Use the correct controller
              scrollDirection: Axis.horizontal,
              itemCount: subCategories.length,
              itemBuilder: (context, index) {
                final subCategory = subCategories[index];
                final bool isSelected = context.read<RideCubit>().selectedCategoryType == type && context.read<RideCubit>().selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (context.isUserLoggedIn && serviceLocator<UserCubit>().state.data?.gender != null) {
                        if (serviceLocator<UserCubit>().state.data?.gender == "male" && subCategory.subCategoryNameEn.trim().toLowerCase() == "lady") {
                          showErrorMessage(context, context.isArabic ? "أنت رجل, لا يمكنك استخدام هذه الخدمة" : "You are a man, you can't use this service");
                          return;
                        }
                      }
                      if (context.read<RideCubit>().selectedCategoryType == type && context.read<RideCubit>().selectedCategoryIndex == index) {
                        // context.read<RideCubit>().selectedCategoryType = null;
                        // context.read<RideCubit>().selectedCategoryIndex = null;
                      } else {
                        context.read<RideCubit>().selectedCategoryType = type;
                        context.read<RideCubit>().selectedCategoryIndex = 0;
                        subCategories.insert(0, subCategories.removeAt(index));
                      }
                      context.read<RideCubit>().subCategoryId = subCategory.subCategoryId;
                      context.read<RideCubit>().checkSelectedCategoryIsSocket(subCategory.subCategoryId, type);
                    });
                    _scrollToStart(type);
                  },
                  child: _categoryItem(context.isArabic ? subCategory.subCategoryNameAr : subCategory.subCategoryNameEn, subCategory.picture, isSelected),
                );
              },
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              _scrollRight(type);
            },
            child: const Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.SECONDARY_COLOR_DARK),
          ),
        ),
      ],
    );
  }

  Widget _categoryItem(String title, String imageUrl, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.redAccent.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imageUrl, width: 50, height: 20, fit: BoxFit.fitWidth),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }

  Widget _customLocationField({
    required Color color,
    required String? text,
    required bool isTo,
    required Function()? onPressed,
  }) {
    if (text == null) {
      if (isTo == true) {
        text = 'To';
      } else {
        text = 'From';
      }
    }

    return BlocBuilder<RideCubit, RideState>(builder: (context, state) {
      return InkWell(
        onTap: onPressed,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: context.isDarkMode ? AppColors.GREY_DARK_COLOR : const Color(0xFFEEEEEE),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: CircleAvatar(
                  backgroundColor: color,
                  radius: 10,
                  child: const CircleAvatar(backgroundColor: Colors.white, radius: 5),
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
                ),
              ),
              if (isTo == true && text != 'To')
                GestureDetector(
                  onTap: () {
                    customBottomSheet(context, serviceLocator<RideCubit>(),
                        isDarkMode: context.isDarkMode,
                        child: AddStopsWidget(
                          rideCubit: serviceLocator<RideCubit>(),
                        ),
                        title: context.isArabic ? 'إضافة موقع' : 'Add Stops');
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.add, size: 18),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _fareField() {
    return BlocBuilder<RideCubit, RideState>(builder: (context, state) {
      String selectedCategoryName = "Captain";
      double selectedCategoryPrice = 0.0;
      if (context.read<RideCubit>().selectedCategoryType == "ride") {
        selectedCategoryName = state.rideCategory?.subCategories[context.read<RideCubit>().selectedCategoryIndex!].subCategoryNameEn ?? "";
      } else {
        selectedCategoryName = state.shippingCategory?.subCategories[context.read<RideCubit>().selectedCategoryIndex!].subCategoryNameEn ?? "";
      }
      // log("""selectedCategoryName: $selectedCategoryName""");
      if (selectedCategoryName.trim().toLowerCase() == "Captain".toLowerCase()) {
        selectedCategoryPrice = state.rideExpectedPrice?.priceForCaptain ?? 0.0;
      } else if (selectedCategoryName.trim().toLowerCase() == "Scooter".toLowerCase()) {
        selectedCategoryPrice = state.rideExpectedPrice?.priceForScooter ?? 0.0;
      } else if (selectedCategoryName.trim().toLowerCase() == "Taxi".toLowerCase()) {
        selectedCategoryPrice = state.rideExpectedPrice?.priceForTaxi ?? 0.0;
      } else if (selectedCategoryName.trim().toLowerCase() == "Suv".toLowerCase()) {
        selectedCategoryPrice = state.rideExpectedPrice?.priceForSUV ?? 0.0;
      } else if (selectedCategoryName.trim().toLowerCase() == "Lady".toLowerCase()) {
        selectedCategoryPrice = state.rideExpectedPrice?.priceForWomen ?? 0.0;
      } else if (selectedCategoryName.trim().toLowerCase() == "Premium".toLowerCase()) {
        selectedCategoryPrice = state.rideExpectedPrice?.priceForPremium ?? 0.0;
      } else if (selectedCategoryName.trim().toLowerCase() == "Intercity".toLowerCase()) {
        selectedCategoryPrice = state.rideExpectedPrice?.priceForIntercity ?? 0.0;
      }
      return GestureDetector(
        onTap: () {
          if (state.rideExpectedPrice == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  context.isArabic
                      ? "يرجي اختيار موقع اولا قبل تعديل سعر الرحله"
                      : "Please select a location first before editing the fare", // Ensure you define this key in your localization file
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          } else {
            customBottomSheet(context, serviceLocator<RideCubit>(),
                isDarkMode: context.isDarkMode,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: FareBottomSheetWidget(
                    rideCubit: serviceLocator<RideCubit>(),
                    selectedCategoryPrice: context.read<RideCubit>().getTotalPrice(selectedCategoryPrice),
                    selectedCategoryName: selectedCategoryName,
                  ),
                ),
                title: LocaleKeys.offerYourFare.tr());
          }
        },
        child: SizedBox(
          height: 40,
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? AppColors.GREY_DARK_COLOR : AppColors.GREYFIELD,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      Text(LocaleKeys.egp.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      state.rideExpectedPrice != null
                          ? Text(FormatNumbers()
                              .convertNumberToLocalizedString(context.read<RideCubit>().getTotalPrice(selectedCategoryPrice).toInt().toString(), isArabic: context.isArabic))
                          : Text(LocaleKeys.offerYourFare.tr()),
                      const Spacer(),
                      Icon(
                        Icons.edit_outlined,
                        color: context.isDarkMode ? null : AppColors.DARK_BLUE_COLOR,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    if (state.rideExpectedPrice == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            context.isArabic
                                ? "يرجي اختيار موقع اولا قبل تعديل سعر الرحله"
                                : "Please select a location first before editing the fare", // Ensure you define this key in your localization file
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } else {
                      customBottomSheet(context, serviceLocator<RideCubit>(),
                          isDarkMode: context.isDarkMode,
                          child: OptionsBottomsheetWidget(
                            rideCubit: serviceLocator<RideCubit>(),
                            selectedCategoryName: selectedCategoryName,
                            selectedCategoryPrice: context.read<RideCubit>().getTotalPrice(selectedCategoryPrice),
                          ),
                          title: LocaleKeys.options.tr());
                    }
                  },
                  child: SizedBox(
                    height: 25,
                    child: Icon(
                      Icons.tune_outlined,
                      color: context.isDarkMode ? null : AppColors.DARK_BLUE_COLOR,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

class CarMarkerWidget extends StatefulWidget {
  const CarMarkerWidget({super.key});

  @override
  State<CarMarkerWidget> createState() => _CarMarkerWidgetState();
}

class _CarMarkerWidgetState extends State<CarMarkerWidget> {
  LatLng? _previousLocation;
  double? _initialDirection;

  @override
  void initState() {
    super.initState();
    _getInitialDirection();
  }

  Future<void> _getInitialDirection() async {
    final position = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    setState(() {
      _initialDirection = position.heading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CarLocationCubit(),
      child: BlocBuilder<CarLocationCubit, GetLocationFromAddressEntity?>(
        builder: (context, state) {
          if (state == null || state.lat == null || state.lng == null || _initialDirection == null) {
            return const SizedBox.shrink();
          }

          final currentLocation = LatLng(state.lat!, state.lng!);
          final marker = CarMarker.build(
            currentLocation,
            _previousLocation,
            initialDirection: _initialDirection!,
          );
          _previousLocation = currentLocation;

          return MarkerLayer(markers: [marker]);
        },
      ),
    );
  }
}

class CarMarker {
  static Marker build(LatLng carLocation, LatLng? previousLocation, {required double initialDirection}) {
    double rotation = initialDirection;

    if (previousLocation != null) {
      rotation = _calculateBearing(previousLocation, carLocation);
    }

    return Marker(
      point: carLocation,
      width: 60,
      height: 60,
      child: _RotatingCarIcon(targetAngle: rotation),
    );
  }

  static double _calculateBearing(LatLng from, LatLng to) {
    final double lat1 = from.latitude * (pi / 180);
    final double lat2 = to.latitude * (pi / 180);
    final double deltaLng = (to.longitude - from.longitude) * (pi / 180);

    final double y = sin(deltaLng) * cos(lat2);
    final double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLng);
    final double bearing = atan2(y, x);
    return (bearing * (180 / pi) + 360) % 360; // Degrees
  }
}

class _RotatingCarIcon extends StatefulWidget {
  final double targetAngle; // in degrees

  const _RotatingCarIcon({required this.targetAngle});

  @override
  State<_RotatingCarIcon> createState() => _RotatingCarIconState();
}

class _RotatingCarIconState extends State<_RotatingCarIcon> {
  double _currentAngle = 0;

  @override
  void didUpdateWidget(covariant _RotatingCarIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    _currentAngle = widget.targetAngle;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: _currentAngle,
        end: widget.targetAngle,
      ),
      duration: const Duration(milliseconds: 300),
      builder: (_, angle, child) {
        return Transform.rotate(
          angle: angle * pi / 180,
          child: child,
        );
      },
      onEnd: () => _currentAngle = widget.targetAngle,
      child: Image.asset("assets/images/car_for_tracking.png"),
    );
  }
}

class CountdownTimerWidget extends StatefulWidget {
  final bool isActive;
  final bool isArabic;

  const CountdownTimerWidget({
    super.key,
    required this.isActive,
    required this.isArabic,
  });

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> with SingleTickerProviderStateMixin {
  static const int totalSeconds = 300;
  late Duration _remaining = const Duration(seconds: totalSeconds);
  Timer? _timer;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      lowerBound: 0.9,
      upperBound: 1,
    )..repeat(reverse: true);

    if (widget.isActive) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(covariant CountdownTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive && !oldWidget.isActive) {
      _startTimer();
    } else if (!widget.isActive && oldWidget.isActive) {
      _stopTimer();
    }
  }

  void _startTimer() {
    _remaining = const Duration(seconds: totalSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() {
          _remaining = _remaining - const Duration(seconds: 1);
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _remaining = const Duration(seconds: totalSeconds);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    final formattedMinutes = FormatNumbers().convertNumberToLocalizedString(
      minutes.toString().padLeft(1, '0'),
      isArabic: widget.isArabic,
    );
    final formattedSeconds = FormatNumbers().convertNumberToLocalizedString(
      seconds.toString().padLeft(2, '0'),
      isArabic: widget.isArabic,
    );

    return '$formattedMinutes:$formattedSeconds';
  }

  @override
  Widget build(BuildContext context) {
    final isLastMinute = _remaining.inSeconds <= 60 && widget.isActive;

    final message = widget.isArabic
        ? (isLastMinute ? "كن حذرًا، يمكن أن يلغي السائق الرحلة، ولديه مبررات قوية لذلك." : "لا تتأخر، قد يؤثر على تقييمك")
        : (isLastMinute ? "Be careful, the driver could cancel the ride, and he has every right to do so." : "Please don't be late, it might affect your rating");

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final scale = isLastMinute ? _animationController.value : 1.0;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Transform.scale(
                scale: scale,
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isLastMinute ? Colors.red : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Transform.scale(
              scale: scale,
              child: SizedBox(
                width: 50,
                child: Text(
                  _formatTime(_remaining),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isLastMinute ? Colors.red : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
