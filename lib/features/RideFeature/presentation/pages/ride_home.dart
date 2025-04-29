import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
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
import 'package:latlong2/latlong.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../service_locator/service_locator.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'widgets/add_stops_widget.dart';
import 'widgets/bottom_sheet/custom_bottom_sheet.dart';
import 'widgets/fare_bottom_sheet_widget.dart';
import 'widgets/options_bottomsheet_widget.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class RideHome extends StatefulWidget {
  const RideHome({super.key});

  @override
  State<RideHome> createState() => _RideHomeState();
}

class _RideHomeState extends State<RideHome> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  // String? _selectedCountry;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // _country = CountryPickerUtils.getCountryByName('Egypt');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rideCubit = serviceLocator<RideCubit>();
      if (!rideCubit.isClosed) {
        rideCubit.initHome(context);
      }
      // Check if there's an active trip and show the modal if needed
      // if (rideCubit.state.requestedTrip != null) {
      //   _showDriversOffersBottomSheet();
      // }
    });
  }

  void _showDriversOffersBottomSheet() async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      isScrollControlled: true,
      builder: (context) => BlocProvider.value(
        value: serviceLocator<RideCubit>(),
        child: Builder(
          builder: (context) {
            return BlocBuilder<RideCubit, RideState>(builder: (context, state) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: _buildDriversOffers(),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      color: AppColors.whiteColor,
                    ),
                    // padding: const EdgeInsets.only(
                    //   // bottom: MediaQuery.of(context).viewInsets.bottom + 25,
                    // ),
                    child: BottomCardRequest(
                      driversCount: 3,
                      rideCubit: serviceLocator<RideCubit>(),
                      onCancel: () async {
                        await context
                            .read<RideCubit>()
                            .cancelPendingTripByClient(
                              tripId: context
                                      .read<RideCubit>()
                                      .state
                                      .requestedTrip
                                      ?.id ??
                                  '',
                            );
                        context.pop();
                      },
                    ),
                  ),
                ],
              );
            });
          },
        ),
      ),
    );
    serviceLocator<RideCubit>().hasPendingShownBottomSheet = false;
  }
  String getArrivalTimeString(double? seconds) {
    if (seconds == null) return "";

    final now = DateTime.now();
    final arrivalTime = now.add(Duration(seconds: seconds.toInt()));
    final formattedTime = "${arrivalTime.minute.toString().padLeft(2, '0')}:${arrivalTime.second.toString().padLeft(2, '0')}";

    return formattedTime;
  }
  void _showAcceptedTripBottomSheet() async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      isScrollControlled: true,
      builder: (context) => BlocProvider.value(
        value: serviceLocator<RideCubit>(),
        child: Builder(
          builder: (context) {
            return BlocBuilder<RideCubit, RideState>(builder: (context, state) {
              log("mabdooon ${state.requestedTrip?.vehicleModel ?? ""} ${state.requestedTrip?.vehicleBrand ?? ""}");
              return DraggableScrollableSheet(
                initialChildSize: 0.4,
                minChildSize: 0.2,
                maxChildSize: 0.9,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                             DriverHeaderWidget(
                              // carModel: "${state.requestedTrip?.vehicleModel ?? ""} ${state.requestedTrip?.vehicleBrand ?? ""}",
                               carModel: "Model",
                               rideStatus: context.isArabic
                                   ? "سيتم الوصول في ${getArrivalTimeString(state.requestedTrip?.driverIsArrivingIn)}"
                                   : "You'll be Arriving at ${getArrivalTimeString(state.requestedTrip?.driverIsArrivingIn)}",
                              carImageUrl: state.requestedTrip?.vehiclePicture ?? "https://www.hyundai.com/content/dam/hyundai/in/en/data/find-a-car/i20/Highlights/pc/i20_Modelpc.png",
                              carName: "",
                              carNumber: state.requestedTrip?.vehiclePlateNumber ?? "",
                            ),
                            const Divider(
                              height: 2,
                            ),
                            ActionButtonsWidget(
                              driverImageUrl: state.requestedTrip?.driverProfilePicture ?? Assets.maleImagePlaceholder,
                              driverRating: state.requestedTrip?.driverRating ?? 0.0,
                              driverName: state.requestedTrip?.driverFirstName ?? "",
                              onContactDriver: () {
                                context.push(Routes.ratingClientScreen);
                              },
                              onSafety: () {
                                context.push(Routes.rideArrivedScreen);
                              },
                              is_show_message: true,
                              onMessage: () {},
                            ),
                            const Divider(
                              height: 2,
                            ),

                            const FeedbackWidget(),
                            const Divider(
                              height: 2,
                            ),

                            // PaymentInfoWidget(price: state.requestedTrip?.price?.toInt() ?? 0),
                            //

                            // LocationInfoWidget(
                            //   from: state.requestedTrip?.from ?? "",
                            //   to: state.requestedTrip?.to ?? "",
                            // ),

                            BottomRideStatusWidget(
                              price: 200,
                              fromLocation: 'أول العاشر من رمضان',
                              toLocation:
                                  'المنطقة الصناعية الثالثة العاشر من رمضان (10th of Ramadan City 1) العالمية',
                              onGoogleMap: () {},
                              onPartialPayment: () {},
                              onCallEmergency: () {},
                              onCancelRide: () {},
                              isRecording: true,
                              audioDuration: '',
                              onMicTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            });
          },
        ),
      ),
    );
    serviceLocator<RideCubit>().hasAcceptedShownBottomSheet = false;
  }

  Widget _buildDriversOffers() {
    return BlocBuilder<RideCubit, RideState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.rideOffers.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final RideOfferEntity offerEntity = state.rideOffers[index];
            return TopCardRequest(
              rideOffer: offerEntity,
              rideCubit: serviceLocator<RideCubit>(),
              onAccept: () async {
                await context
                    .read<RideCubit>()
                    .acceptOfferByClient(offerId: offerEntity.offerId);
                context.pop();
                _showAcceptedTripBottomSheet();
              },
            );
          },
        );
      },
    );
  }

  final ScrollController _rideScrollController = ScrollController();
  final ScrollController _shippingScrollController = ScrollController();

  void _scrollRight(String type) {
    final ScrollController? activeController =
        type == "ride" ? _rideScrollController : _shippingScrollController;

    if (activeController != null && activeController.hasClients) {
      activeController.animateTo(
        activeController.offset + 200,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToStart(String type) {
    final ScrollController? activeController =
    type == "ride" ? _rideScrollController : _shippingScrollController;

    if (activeController != null && activeController.hasClients) {
      activeController.animateTo(
        0, // تحرك للبداية
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RideCubit, RideState>(listener: (context, state) {
      log("new state listener");
      var cubit = serviceLocator<RideCubit>();
      if (state.requestedTrip != null) {
        log("trip status 1 : ${state.requestedTrip!.status}");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          log("trip status 2: ${state.requestedTrip!.status}");
          if (state.requestedTrip!.status == TripState.pending.name &&
              !cubit.hasPendingShownBottomSheet) {
            cubit.hasPendingShownBottomSheet = true;
            _showDriversOffersBottomSheet();
          }
          if (state.requestedTrip!.status == TripState.accepted.name &&
              !cubit.hasAcceptedShownBottomSheet) {
            cubit.hasAcceptedShownBottomSheet = true;
            _showAcceptedTripBottomSheet();
          }
        });
      }
    }, builder: (context, state) {
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
                            context.read<RideCubit>().selectedCategoryIsSocket
                                ? _buildTopImage()
                                : const SizedBox.shrink(),
                            state.requestedTrip == null
                                ? _buildBottomSheet()
                                : state.requestedTrip!.status ==
                                            TripState.completed.name ||
                                        state.requestedTrip!.status ==
                                            TripState.canceled.name
                                    ? _buildBottomSheet()
                                    : const SizedBox.shrink(),
                            !context.read<RideCubit>().selectedCategoryIsSocket
                                ? const SizedBox()
                                : state.requestedTrip == null
                                    ? _carTruckBtn(
                                        driverInfo: state.driverInfo,
                                        loadingInfo: state.loaderInfo)
                                    : (state.requestedTrip!.status ==
                                                TripState.completed.name ||
                                            state.requestedTrip!.status ==
                                                TripState.canceled.name)
                                        ? _carTruckBtn(
                                            driverInfo: state.driverInfo,
                                            loadingInfo: state.loaderInfo)
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
      routePoints =
          _convertPolylineToLatLng(state.rideExpectedPrice?.polyline ?? []);
    }
    else {
      routePoints = _convertPolylineToLatLng(state.requestedTrip!.polyline);
    }

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
            state.currentLocation?.lat ?? 0.0,
            state.currentLocation?.lng ?? 0.0,
          ),
          initialZoom: 12.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            // urlTemplate: context.isDarkMode ? "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png" // Dark mode map
            //     : "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", // Normal mode map
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
                      color: Colors.green, size: 40),
                ),
              if (state.toLocation != null)
                Marker(
                  point: LatLng(state.toLocation!.lat!, state.toLocation!.lng!),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin,
                      color: Colors.blue, size: 40),
                ),
              if (state.wayPointOne != null)
                Marker(
                  point:
                      LatLng(state.wayPointOne!.lat!, state.wayPointOne!.lng!),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin,
                      color: Colors.red, size: 40),
                ),
              if (state.wayPointTwo != null)
                Marker(
                  point:
                      LatLng(state.wayPointTwo!.lat!, state.wayPointTwo!.lng!),
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

  Widget _carTruckBtn(
      {LoadingInfoEntity? loadingInfo, DriverInfoEntity? driverInfo}) {
    if (loadingInfo == null && driverInfo == null) {
      return SizedBox(
        height: 48,
        child: GestureDetector(
          onTap: () {
            customBottomSheet(context, serviceLocator<RideCubit>(),
                isDarkMode: context.isDarkMode,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    spacing: 10,
                    children: [
                      AppButton(
                          radius: 15,
                          label: LocaleKeys.ride.tr(),
                          onPressed: () {
                            context.pop();
                            serviceLocator<RideCubit>()
                                .onNavigateToWelcomeScreen(
                                    fromShipping: false, context: context);
                          },
                          backColor: AppColors.PRIMARY_COLOR,
                          width: double.infinity),
                      AppButton(
                          radius: 15,
                          label: LocaleKeys.shipping.tr(),
                          onPressed: () {
                            context.pop();
                            serviceLocator<RideCubit>()
                                .onNavigateToWelcomeScreen(
                                    fromShipping: true, context: context);
                          },
                          backColor: AppColors.PRIMARY_COLOR,
                          width: double.infinity),
                    ],
                  ),
                ),
                title: '');
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0B1035),
                  Color(0xFF161F68),
                  Color(0xFF1B2781),
                  Color(0xFF1E2B8E),
                  Color(0xFF1F2D95),
                  Color(0xFF0B1035)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3)),
              ],
            ),
            child: Center(
              child: Text(
                LocaleKeys.carTruckRegister.tr(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        width: double.infinity,
        height: 75,
        child: Row(
          children: [
            Expanded(
              child: CustomRideButton(
                onPressed: () {
                  if (driverInfo == null) {
                    serviceLocator<RideCubit>().onNavigateToWelcomeScreen(
                        fromShipping: false, context: context);
                  } else {
                    if (driverInfo.status ==
                        RegistrationStatus.pending.status) {
                      return;
                    } else if (driverInfo.status ==
                        RegistrationStatus.rejected.status) {
                      context.push(Routes.UploadRiderImages,
                          extra: UploadRiderImagesParams(
                              isShipping: false,
                              isSocket: driverInfo.driverType == 'socket'
                                  ? true
                                  : false));
                    } else if (driverInfo.status ==
                        RegistrationStatus.initial.status) {
                      context.push(Routes.UploadRiderImages,
                          extra: UploadRiderImagesParams(
                              isShipping: false,
                              isSocket: driverInfo.driverType == 'socket'
                                  ? true
                                  : false));
                    } else {
                      context.push(Routes.rideModeScreen,
                          extra: RideModeParams(
                              modeType: 'ride',
                              isSocket: driverInfo.driverType == 'socket'
                                  ? true
                                  : false));
                    }
                  }
                },
                onTap: () {
                  // context.push(Routes.UploadRiderImages, extra: UploadRiderImagesParams(isShipping: false, isSocket: driverInfo?.driverType == 'socket' ? true : false));
                  if (driverInfo != null &&
                      driverInfo.status == RegistrationStatus.pending.status) {
                    return;
                  } else if (driverInfo != null &&
                      driverInfo.status == RegistrationStatus.rejected.status) {
                    context.push(Routes.UploadRiderImages,
                        extra: UploadRiderImagesParams(
                            isShipping: false,
                            isSocket: driverInfo.driverType == 'socket'
                                ? true
                                : false));
                  } else if (driverInfo != null &&
                      driverInfo.status == RegistrationStatus.initial.status) {
                    context.push(Routes.UploadRiderImages,
                        extra: UploadRiderImagesParams(
                            isShipping: false,
                            isSocket: driverInfo.driverType == 'socket'
                                ? true
                                : false));
                  } else {
                    context.push(Routes.rideModeScreen,
                        extra: RideModeParams(
                            modeType: 'ride',
                            isSocket: driverInfo?.driverType == 'socket'
                                ? true
                                : false));
                  }
                },
                isRed: (driverInfo != null &&
                        (driverInfo.status !=
                            RegistrationStatus.rejected.status))
                    ? true
                    : false,
                isPending: driverInfo != null &&
                    (driverInfo.status == RegistrationStatus.pending.status),
                isDisabled: driverInfo != null &&
                    (driverInfo.status != RegistrationStatus.approved.status),
                text: LocaleKeys.rideMode.tr(),
                status: driverInfo?.status ?? '',
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: CustomRideButton(
                onPressed: () {
                  if (loadingInfo == null) {
                    print("object");
                    serviceLocator<RideCubit>().onNavigateToWelcomeScreen(
                        fromShipping: true, context: context);
                  } else {
                    print("loadingInfo.toJson()${loadingInfo.toJson()}");
                    if (loadingInfo.status ==
                        RegistrationStatus.pending.status) {
                      return;
                    } else if (loadingInfo.status ==
                        RegistrationStatus.rejected.status) {
                      context.push(Routes.UploadRiderImages,
                          extra: UploadRiderImagesParams(
                              isShipping: true, isSocket: false));
                    } else if (loadingInfo.status ==
                        RegistrationStatus.initial.status) {
                      context.push(Routes.UploadRiderImages,
                          extra: UploadRiderImagesParams(
                              isShipping: true, isSocket: false));
                    } else {
                      context.push(Routes.rideModeScreen,
                          extra: RideModeParams(
                              modeType: 'ride',
                              isSocket: driverInfo?.driverType == 'socket'
                                  ? true
                                  : false));
                    }
                  }
                },
                onTap: () {
                  print("loadingInfo.toJson()${loadingInfo?.toJson()}");
                  if (loadingInfo != null &&
                      loadingInfo.status == RegistrationStatus.pending.status) {
                    return;
                  } else if (loadingInfo != null &&
                      loadingInfo.status ==
                          RegistrationStatus.rejected.status) {
                    context.push(Routes.UploadRiderImages,
                        extra: UploadRiderImagesParams(
                            isShipping: true, isSocket: false));
                  } else if (loadingInfo != null &&
                      loadingInfo.status == RegistrationStatus.initial.status) {
                    context.push(Routes.UploadRiderImages,
                        extra: UploadRiderImagesParams(
                            isShipping: true, isSocket: false));
                  } else {
                    context.push(Routes.rideModeScreen,
                        extra: RideModeParams(
                            modeType: 'ride',
                            isSocket: driverInfo?.driverType == 'socket'
                                ? true
                                : false));
                  }
                },
                isRed: (loadingInfo != null &&
                        (loadingInfo.status !=
                            RegistrationStatus.rejected.status))
                    ? true
                    : false,
                isDisabled: loadingInfo != null &&
                    (loadingInfo.status == RegistrationStatus.pending.status ||
                        loadingInfo.status ==
                            RegistrationStatus.rejected.status ||
                        loadingInfo.status ==
                            RegistrationStatus.initial.status),
                text: LocaleKeys.trukMode.tr(),
                status: loadingInfo?.status ?? '',
              ),
            ),
          ],
        ),
      );
    }
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
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        children: [
          context.read<RideCubit>().selectedCategoryIsSocket
              ? Padding(
                  padding:
                      const EdgeInsetsDirectional.only(end: 16.0, start: 16.0),
                  child: Row(
                    spacing: 6,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Badge(
                          backgroundColor: AppColors.PRIMARY_COLOR_DARK,
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(2),
                          label: const Text('1'),
                          isLabelVisible: false,
                          child: ClickableWidget(
                              onTap: () {
                                if (context.isUserLoggedIn) {
                                  context.push(Routes.rideLoadingRequestScreen,extra: false);
                                } else {
                                  context.push(Routes.LOGIN);
                                }
                              },
                              child: _tripsWidget(
                                  context.isArabic
                                      ? "عروض الرحلات"
                                      : "Ride Offers",
                                  color: const Color(0xffD9D9D9))),
                        ),
                      ),
                      Expanded(
                        child: Badge(
                          backgroundColor: AppColors.PRIMARY_COLOR_DARK,
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(2),
                          label: const Text('1K'),
                          isLabelVisible: false,
                          child: ClickableWidget(
                              onTap: () {
                                if (context.isUserLoggedIn) {
                                  context.push(Routes.rideLoadingRequestScreen,extra: true);
                                } else {
                                  context.push(Routes.LOGIN);
                                }
                              },
                              child: _tripsWidget(
                                  context.isArabic
                                      ? "عروض التحميل"
                                      : "Loading Offers",
                                  color: const Color(0xffD9D9D9))),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          context.read<RideCubit>().selectedCategoryIsSocket
              ? Padding(
                  padding: const EdgeInsetsDirectional.only(
                      end: 16.0, start: 16.0, bottom: 16),
                  child: Row(
                    spacing: 6,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: ClickableWidget(
                            onTap: () {
                              if (context.isUserLoggedIn) {
                                context.push(Routes.RIDEACTIVITY);
                              } else {
                                context.push(Routes.LOGIN);
                              }
                            },
                            child: _tripsWidget(LocaleKeys.activity.tr(),
                                color: AppColors.GREYCARD)),
                      ),
                      Expanded(
                        child: ClickableWidget(
                            onTap: () {
                              context.push(Routes.RIDERUNNINGTRIPS,
                                  extra: RunningTripParams(
                                    rideCubit: serviceLocator<RideCubit>(),
                                  ));
                            },
                            child: _tripsWidget(LocaleKeys.runningTrips.tr(),
                                color: AppColors.GREYCARD)),
                      ),
                      Expanded(
                        child: ClickableWidget(
                            onTap: () {
                              context.push(Routes.RIDEEXPIREDTRIPE,
                                  extra: ExpiredTripsScreenParams(
                                    rideCubit: serviceLocator<RideCubit>(),
                                  ));
                            },
                            child: _tripsWidget(LocaleKeys.expiredTrips.tr(),
                                color: AppColors.GREYCARD)),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            padding:
                const EdgeInsets.only(left: 10, right: 10, bottom: 16, top: 8),
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
                      _buildCategoryList(
                          "ride", state.rideCategory?.subCategories ?? []),
                      _buildCategoryList("shipping",
                          state.shippingCategory?.subCategories ?? []),
                      if (!context.read<RideCubit>().selectedCategoryIsSocket)
                        RidePersonalMoreInfoScreen(
                          isTruk: context.read<RideCubit>().isTruk,
                          subCategoryId:
                          context.read<RideCubit>().subCategoryId,
                        ),
                      context.read<RideCubit>().selectedCategoryIsSocket? _customLocationField(
                        isTo: false,
                        color: Colors.green,
                        text: state.currentLocation?.address,
                        onPressed: () async {
                          context.push(
                            Routes.RIDEOPENSTREETMAPSEARCHANDPICK,
                            extra: RideOpenStreetMapSearchAndPickParams(
                              onPicked: (pickedData) async {
                                serviceLocator<RideCubit>().updateFromLocation(
                                  lat: pickedData.latLong.latitude,
                                  lng: pickedData.latLong.longitude,
                                  address: pickedData.addressName,
                                );
                                context.pop();
                              },
                            ),
                          );
                        },
                      ) : const SizedBox(),
                      context.read<RideCubit>().selectedCategoryIsSocket? _customLocationField(
                        isTo: true,
                        color: Colors.blue,
                        text: state.toLocation?.address,
                        onPressed: () async {
                          context.push(Routes.RIDEOPENSTREETMAPSEARCHANDPICK,
                              extra: RideOpenStreetMapSearchAndPickParams(
                            onPicked: (pickedData) async {
                              serviceLocator<RideCubit>().updateToLocation(
                                lat: pickedData.latLong.latitude,
                                lng: pickedData.latLong.longitude,
                                address: pickedData.addressName,
                              );
                              await context
                                  .read<RideCubit>()
                                  .fetchRideExpectedPrice(id: 'id');
                              context.pop();
                            },
                          ));
                        },
                      ) : const SizedBox(),
                      context.read<RideCubit>().selectedCategoryIsSocket? _fareField() : const SizedBox(),
                      context.read<RideCubit>().selectedCategoryIsSocket? SizedBox(
                        height: 40,
                        child: Row(
                          spacing: 6,
                          children: [
                            Expanded(
                                flex: 2,
                                child: AppButton(
                                    radius: 15,
                                    label: LocaleKeys.premiumRequest.tr(),
                                    onPressed: () async {
                                      if (context.isUserLoggedIn) {
                                        if (state.toLocation != null &&
                                            state.currentLocation != null) {
                                          bool isSubscribed = await context.read<RideCubit>().isSubscribed(userId: UserCubit.to.state.data?.id??'', subcategoryId: state.rideCategory?.subCategories[context.read<RideCubit>().selectedCategoryIndex!].subCategoryId??'');
                                          if (!isSubscribed) {
                                            SubscriptionMethod().subscribe(
                                                subscribeId: state
                                                    .rideCategory
                                                    ?.subCategories[
                                                context.read<RideCubit>().selectedCategoryIndex!]
                                                    .subCategoryId ??
                                                    '',
                                                onSubscribe: () {
                                                  context.pop();
                                                  context.pop();
                                                },
                                                showRegular: false,

                                                title: LocaleKeys
                                                    .premiumRequest.localize);
                                          }
                                          else{
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor: Colors.transparent,
                                              builder: (context) =>
                                                  CustomReserveRideBottomSheet(
                                                    rideCubit:
                                                    serviceLocator<RideCubit>(),
                                                    selectedCategoryId: state
                                                        .rideCategory
                                                        ?.subCategories[
                                                    context.read<RideCubit>().selectedCategoryIndex!]
                                                        .subCategoryId ??
                                                        '',
                                                    isPremium: true,
                                                  ),
                                            );
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                context.isArabic
                                                    ? "يرجى تحديد الموقع"
                                                    : "Please select location", // Ensure you define this key in your localization file
                                                textAlign: TextAlign.center,
                                              ),
                                              backgroundColor: Colors.red,
                                              duration:
                                                  const Duration(seconds: 2),
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
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : AppButton(
                                        radius: 15,
                                        label: LocaleKeys.request.tr(),
                                        onPressed: () async {
                                          if (context.isUserLoggedIn) {
                                            if (state.toLocation != null &&
                                                state.currentLocation != null) {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder: (context) =>
                                                    BlocProvider.value(
                                                        value: serviceLocator<
                                                            RideCubit>(),
                                                        child:
                                                            CustomReserveRideBottomSheet(
                                                          rideCubit:
                                                              serviceLocator<
                                                                  RideCubit>(),
                                                          selectedCategoryId: state
                                                                  .rideCategory
                                                                  ?.subCategories[
                                                          serviceLocator<
                                                              RideCubit>().selectedCategoryIndex!]
                                                                  .subCategoryId ??
                                                              '',
                                                          isPremium: false,
                                                        )),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    context.isArabic
                                                        ? "يرجى تحديد الموقع"
                                                        : "Please select location", // Ensure you define this key in your localization file
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  backgroundColor: Colors.red,
                                                  duration:
                                                      const Duration(seconds: 2),
                                                ),
                                              );
                                            }
                                          } else {
                                            context.push(Routes.LOGIN);
                                          }
                                        },
                                        backColor: AppColors.PRIMARY_COLOR,
                                        width:
                                            MediaQuery.of(context).size.width)),
                          ],
                        ),
                      ): const SizedBox.shrink(),
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
      height: 26,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: context.isDarkMode ? AppColors.GREY_DARK_COLOR : color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.DARK_BLUE_COLOR)),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildCategoryList(String type, List subCategories) {
    final ScrollController controller =
        type == "ride" ? _rideScrollController : _shippingScrollController;

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
                final bool isSelected = context.read<RideCubit>().selectedCategoryType == type &&
                    context.read<RideCubit>().selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (context.read<RideCubit>().selectedCategoryType == type &&
                          context.read<RideCubit>().selectedCategoryIndex == index) {
                        // context.read<RideCubit>().selectedCategoryType = null;
                        // context.read<RideCubit>().selectedCategoryIndex = null;
                      } else {
                        context.read<RideCubit>().selectedCategoryType = type;
                        context.read<RideCubit>().selectedCategoryIndex = 0;
                        subCategories.insert(0, subCategories.removeAt(index));
                      }
                      context.read<RideCubit>().subCategoryId =
                          subCategory.subCategoryId;
                      context.read<RideCubit>().checkSelectedCategoryIsSocket(
                          subCategory.subCategoryId);
                    });
                    _scrollToStart(type);
                  },
                  child: _categoryItem(
                      context.isArabic
                          ? subCategory.subCategoryNameAr
                          : subCategory.subCategoryNameEn,
                      subCategory.picture,
                      isSelected),
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
            child: const Icon(Icons.arrow_forward_ios,
                size: 18, color: AppColors.SECONDARY_COLOR_DARK),
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
          color: isSelected
              ? Colors.redAccent.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imageUrl,
                width: 50, height: 20, fit: BoxFit.fitWidth),
            const SizedBox(height: 5),
            Text(title,
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
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
        selectedCategoryName = state.rideCategory
                ?.subCategories[context.read<RideCubit>().selectedCategoryIndex!].subCategoryNameEn ??
            "";

      } else {
        selectedCategoryName = state.shippingCategory
                ?.subCategories[context.read<RideCubit>().selectedCategoryIndex!].subCategoryNameEn ??
            "";
      }
      log("""selectedCategoryName: $selectedCategoryName""");
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
          if(state.rideExpectedPrice == null){
            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content: Text(
                  context.isArabic
                      ? "يرجي اختيار موقع اولا قبل تعديل سعر الرحله"
                      : "Please select a location first before editing the fare", // Ensure you define this key in your localization file
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.red,
                duration:
                const Duration(seconds: 2),
              ),
            );
          }else{
            customBottomSheet(context, serviceLocator<RideCubit>(),
                isDarkMode: context.isDarkMode,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: FareBottomSheetWidget(
                    rideCubit: serviceLocator<RideCubit>(),
                    selectedCategoryPrice: context
                        .read<RideCubit>()
                        .getTotalPrice(selectedCategoryPrice),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? AppColors.GREY_DARK_COLOR : AppColors.GREYFIELD,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      Text(LocaleKeys.egp.tr(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      state.rideExpectedPrice != null
                          ? Text(context
                              .read<RideCubit>()
                              .getTotalPrice(selectedCategoryPrice)
                              .toInt()
                              .toString())
                          : Text(LocaleKeys.offerYourFare.tr()),
                      const Spacer(),
                      Icon(Icons.edit_outlined, color:context.isDarkMode? null: AppColors.DARK_BLUE_COLOR,),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    if(state.rideExpectedPrice == null){
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            context.isArabic
                                ? "يرجي اختيار موقع اولا قبل تعديل سعر الرحله"
                                : "Please select a location first before editing the fare", // Ensure you define this key in your localization file
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: Colors.red,
                          duration:
                          const Duration(seconds: 2),
                        ),
                      );
                    }else{
                      customBottomSheet(context, serviceLocator<RideCubit>(),
                          isDarkMode: context.isDarkMode,
                          child: OptionsBottomsheetWidget(
                            rideCubit: serviceLocator<RideCubit>(),
                            selectedCategoryName: selectedCategoryName,
                            selectedCategoryPrice: context
                                .read<RideCubit>()
                                .getTotalPrice(selectedCategoryPrice),
                          ),
                          title: LocaleKeys.options.tr());
                    }
                  },
                  child: SizedBox(
                    height: 25,
                    child: Icon(Icons.tune_outlined, color:context.isDarkMode? null: AppColors.DARK_BLUE_COLOR,),
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
