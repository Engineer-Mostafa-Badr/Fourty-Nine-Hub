import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fourtyninehub/common/functions/global/upload_image.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/trip_states_enum.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/service/storage.dart';
import 'package:fourtyninehub/core/utils/loading_method_helper.dart';
import 'package:fourtyninehub/core/utils/ride_method_helper.dart';
import 'package:fourtyninehub/core/utils/upload_record.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/cost_per_km_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_info_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_picture_optional_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/loading_info_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/loading_register_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_not_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/request_trip_params.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_brand_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_color_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_model_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_offer_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_request_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/accept_offer_by_client_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/cancel_pending_trip_by_client_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/check_real_amount_enough_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/click_global_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_cost_per_km_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_driver_picture_optional.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_loading_info_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_brands_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_car_colors_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_driver_information.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_governorates.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_models_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/activity_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/completed_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/expected_price_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/expected_price_params.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/get_location_from_address_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/running_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_activity_trips.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_completed_trips_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_running_trips_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_location_from_address_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_expexted_price_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_shipping_categories_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/listen_to_ride_offers_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/loading_register_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/make_request_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/recording_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/register_ride_not_special_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/register_ride_special_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/request_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/retrieve_client_latest_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/update_socket_location_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/update_trip_auto_accept_by_client_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/update_trip_price_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/personal_information_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/upload_rider_images.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../core/data/datasources/remote/socket/socket_data_source.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../../shared_web_socket.dart';
import '../../../../account_taps/my_adds/domain/entity/click_entity.dart';
import '../../../domain/entities/ride_category_entity.dart';
import '../../../domain/usecases/get_ride_categories_usecase.dart';
import 'package:record/record.dart';

import '../../../domain/usecases/rating_driver_by_client.dart';
import '../../../domain/usecases/send_ok_iam_coming_message_usecase.dart';


class RideCubit extends Cubit<RideState> {
  bool isComfort = false;
  // bool isComfortIsAdded = false;
  bool isNonSmoker = false;
  // bool isNonSmokerIsAdded = false;
  bool isAutoAccept = false;
  // bool isAutoAcceptIsAdded = false;
  bool isRecord = false;
  bool showWaypointOne = false;
  bool showWaypointTwo = false;

  String? selectedCategoryType = "ride";
  int? selectedCategoryIndex = 0;
  //
  // bool hasPendingShownBottomSheet = false;
  // bool hasAcceptedShownBottomSheet = false;

  bool selectedCategoryIsSocket = true;
  String subCategoryId = '';

  Map<String, String> socketCategories = {
    'captain': '62c8ba9f8e28a58a3edf57eb',
    'lady': '62ea012a69ea29c91dfc3917',
    'intercity': '62c8baa08e28a58a3edf57ed',
    'premium': '62c8baa38e28a58a3edf57f3',
    'taxi': '62c8ba9e8e28a58a3edf57e9',
    'suv': '62c8baa28e28a58a3edf57f1',
    'scooter': '6698736fdaa111da2d775627',
  };
  Map<String, String> trukCategories = {
    'Trucycle': '63044ea31df1280e87614fe4',
    'Delivery ': '62c8bab78e28a58a3edf5819',
    'Pickup': '62c8baad8e28a58a3edf5805',
    'Jumbo': '62c8baae8e28a58a3edf5807',
    'Tow': '62c8bab48e28a58a3edf5813',
    'Money': '62c8bab68e28a58a3edf5817',
    'Trailer': '62c8baaf8e28a58a3edf5809',
    'Flatbed': '62c8bab28e28a58a3edf580f',
    'Tank ': '62c8bab18e28a58a3edf580d',
    'Tipper': '62c8bab08e28a58a3edf580b',
    'Refriger': '62c8bab38e28a58a3edf5811',
    'Transport': '62c8bab88e28a58a3edf581b',
  };

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  final GetRideCategoriesUseCase getRideCategories;
  final GetShippingCategoriesUsecase getShippingCategoriesUsecase;
  final GetRideGovernoratesUseCase getRideGovernoratesUseCase;
  final GetRideBrandsUseCase getRideBrandsUseCase;
  final GetRideModelsUseCase getRideModelsUseCase;
  final GetRideCarColorsUseCase getRideCarColorsUseCase;
  final RegisterRideSpecialUseCase registerRideSpecialUseCase;
  final RegisterRideNotSpecialUseCase registerRideNotSpecialUseCase;
  final GetRideDriverInfoUseCase getRideDriverInfoUseCase;
  final GetDriverPictureOptionalUseCase getDriverPictureOptionalUseCase;
  final GetLocationFromAddressUseCase getLocationFromAddressUseCase;
  final GetRideExpectedPriceUseCase getRideExpectedPriceUseCase;
  final GetAllCompletedTripsUseCase getAllCompletedTripsUseCase;
  final GetAllRunningTripsUseCase getAllRunningTripsUseCase;
  final GetAllActivityTripsUseCase getAllActivityTripsUseCase;
  final CheckRealAmountEnoughUseCase checkRealAmountEnoughUseCase;
  final RequestTripUseCase requestTripUseCase;
  final CancelPendingTripByClientUseCase cancelPendingTripByClientUseCase;
  final RetrieveClientLatestTripUseCase retrieveClientLatestTripUseCase;
  final AcceptOfferByClientUseCase acceptOfferByClientUseCase;
  final ListenToRideOffersUseCase listenToRideOffersUseCase;
  final UpdateTripAutoAcceptByClientUseCase updateTripAutoAcceptByClientUseCase;
  final UpdateTripPriceUseCase updateTripPriceUseCase;
  final ClickUseCase clickUseCase;
  final SendOkIamComingMessageUseCase  sendOkIamComingMessageUseCase;
  final RatingDriverByClientUseCase ratingDriverByClientUseCase;

  final GetCostPerKmUseCase getCostPerKmUseCase;
  final LoadingRegisterUseCase loadingRegisterUseCase;
  final GetLoadingInfoUseCase getLoadingInfoUseCase;
  final MakeRequestTripUseCase makeRequestTripUseCase;
  final RecordingTripUseCase recordingTripUseCase;
  final UpdateSocketLocationUseCase updateSocketLocationUseCase;

  RideCubit(
    this.getRideCategories,
    this.getShippingCategoriesUsecase,
    this.getRideGovernoratesUseCase,
    this.getRideBrandsUseCase,
    this.getRideModelsUseCase,
    this.getRideCarColorsUseCase,
    this.registerRideSpecialUseCase,
    this.registerRideNotSpecialUseCase,
    this.getRideDriverInfoUseCase,
    this.getDriverPictureOptionalUseCase,
    this.getLocationFromAddressUseCase,
    this.getRideExpectedPriceUseCase,
    this.getAllCompletedTripsUseCase,
    this.getAllRunningTripsUseCase,
    this.getAllActivityTripsUseCase,
    this.checkRealAmountEnoughUseCase,
    this.requestTripUseCase,
    this.cancelPendingTripByClientUseCase,
    this.retrieveClientLatestTripUseCase,
    this.getCostPerKmUseCase,
    this.loadingRegisterUseCase,
    this.getLoadingInfoUseCase,
    this.makeRequestTripUseCase,
    this.recordingTripUseCase,
    this.listenToRideOffersUseCase,
    this.acceptOfferByClientUseCase,
    this.updateTripAutoAcceptByClientUseCase,
      this.updateSocketLocationUseCase,
      this.updateTripPriceUseCase,
      this.clickUseCase,
      this.sendOkIamComingMessageUseCase,
      this.ratingDriverByClientUseCase,
  ) : super( RideState(
    rideOffers: [],
  )){
    if(SharedWebSocket.socket != null){
      listenToRideOffers();

      //action: start arriving counter
      SharedWebSocket.socket!.on("RIDE:DRIVER_GO_TO_CLIENT_TO_START_TRIP", (data) {
        CliLogger.info("RIDE:DRIVER_GO_TO_CLIENT_TO_START_TRIP:  $data");
        // RIDE:DRIVER_GO_TO_CLIENT_TO_START_TRIP:  {driverGoToClientToStartTrip: {startArrivingTime: true}
        if(state.requestedTrip != null){
          state.requestedTrip!.status = TripState.goToClient.name;
          print("RIDE:DRIVER_GO_TO_CLIENT_TO_START_TRIP statttttus:  ${state.requestedTrip!.status.toString()}");

        }else{
          print("RIDE:DRIVER_GO_TO_CLIENT_TO_START_TRIP statttttus:  ${state.requestedTrip!.status.toString()}");
        }
        emit(state.copyWith(status: RideStates.success));
      });

      //action: the driver has arrived
      SharedWebSocket.socket!.on("RIDE:DRIVER_HAS_ARRIVED_AT_CLIENT", (data) {
        CliLogger.info("RIDE:DRIVER_HAS_ARRIVED_AT_CLIENT:  $data");
        if(state.requestedTrip != null){
          state.requestedTrip!.status = TripState.inLocation.name;
          print("RIDE:RIDE:DRIVER_HAS_ARRIVED_AT_CLIENT statttttus:  ${state.requestedTrip!.status.toString()}");

        }else{
          print("RIDE:RIDE:DRIVER_HAS_ARRIVED_AT_CLIENT statttttus:  ${state.requestedTrip!.status.toString()}");
        }
        emit(state.copyWith(status: RideStates.success));
      });

      // near by driver
      SharedWebSocket.socket!.on("subcategory:driver", (data) {
        CliLogger.info("nearbyDriversAvailable:  $data");
        emit(state.copyWith(status: RideStates.success));
      });

      // trip started socket event
      SharedWebSocket.socket!.on("RIDE:DRIVER_STARTED_TRIP", (data) {
        CliLogger.info("RIDE:DRIVER_STARTED_TRIP:  $data");
        if(state.requestedTrip != null){
          state.requestedTrip!.status = TripState.started.name;
          print("RIDE:RIDE:DRIVER_STARTED_TRIP statttttus:  ${state.requestedTrip!.status.toString()}");
        }else{
          print("RIDE:RIDE:DRIVER_STARTED_TRIP statttttus:  ${state.requestedTrip!.status.toString()}");
        }
        emit(state.copyWith(status: RideStates.success));
        // RIDE:DRIVER_STARTED_TRIP:  {driverStartedTrip: true}
      });

      // trip ended socket event
      SharedWebSocket.socket!.on("RIDE:DRIVER_COMPLETED_TRIP", (data) {
        CliLogger.info("RIDE:DRIVER_COMPLETED_TRIP:  $data");
        if(state.requestedTrip != null){
          state.requestedTrip!.status = TripState.ratingSheet.name;
          print("RIDE:RIDE:DRIVER_COMPLETED_TRIP statttttus:  ${state.requestedTrip!.status.toString()}");
        }else{
          print("RIDE:RIDE:DRIVER_COMPLETED_TRIP statttttus:  ${state.requestedTrip!.status.toString()}");
        }
        emit(state.copyWith(status: RideStates.success));
        // RIDE:DRIVER_COMPLETED_TRIP:  {driverCompletedTrip: true}
      });

      // tracking
      SharedWebSocket.socket!.on("RIDE:TRIP_LOCATION_UPDATED", (data) {
        CliLogger.info("RIDE:TRIP_LOCATION_UPDATED tracking:  $data");
        emit(state.copyWith(status: RideStates.success));
        //  RIDE:TRIP_LOCATION_UPDATED tracking:  {updateLocation: {tripId: 682a0ef3fe6c419d46b21cd0, driverId: 681fa7a42ad43c198641e0eb, location: {latitude: 31.2802515, longitude: 31.6776039, timestamp: null}}}
      });
    }
  }


  bool loadingHomeData = false;
  Future<void> initHome(BuildContext context) async {
    loadingHomeData = true;
    emit(state.copyWith(status: RideStates.loading));
    await Future.wait([
      // _fetchUserLocation(),

      fetchRideDriverInfo(context,false),
      fetchRideDriverInfo(context,true),
      retrieveClientLatestTrip(),
      // fetchRideDriverInfo(context,false),
      getCostPerKm(),
      fetchLoaderInfo(context, false),
      fetchLoaderInfo(context, true),
      fetchRideDriverPictureOptional(context),
      // fetchRideCategories(UserCubit.to.state.data?.id??'',false),
      fetchRideCategories(UserCubit.to.state.data?.id??'',true),
      // fetchShippingCategories(UserCubit.to.state.data?.id??'',false),
      fetchShippingCategories(UserCubit.to.state.data?.id??'',true),
      fetchRideGovernorates(),
    ]);
    if(state.requestedTrip == null && state.rideExpectedPrice == null){
      _fetchUserLocation();
    }else{
      if(state.requestedTrip!.status == TripState.canceled.name || state.requestedTrip!.status == TripState.completed.name){
        _fetchUserLocation();
      }
      else{
        if (state.requestedTrip!.targetCoordinates != null && state.requestedTrip!.targetCoordinates!.length >= 2) {
          updateToLocation(
            lat: state.requestedTrip!.targetCoordinates!.first,
            lng: state.requestedTrip!.targetCoordinates!.last,
            address: state.requestedTrip!.to!,
          );
        }

        if (state.requestedTrip!.startCoordinates != null && state.requestedTrip!.startCoordinates!.length >= 2) {
          updateCurrentLocation(
            lat: state.requestedTrip!.startCoordinates!.first,
            lng: state.requestedTrip!.startCoordinates!.last,
            address: state.requestedTrip!.from!,
          );
        }

        if (state.requestedTrip?.wayPointOne != null &&
            state.requestedTrip!.wayPointOne!.length >= 2 &&
            state.requestedTrip!.wayPointOneTitle != null) {
          updateWayPointOne(
            lat: state.requestedTrip!.wayPointOne!.first,
            lng: state.requestedTrip!.wayPointOne!.last,
            address: state.requestedTrip!.wayPointOneTitle!,
          );
        }

        if (state.requestedTrip?.wayPointTwo != null &&
            state.requestedTrip!.wayPointTwo!.length >= 2 &&
            state.requestedTrip!.wayPointTwoTitle != null) {
          updateWayPointTwo(
            lat: state.requestedTrip!.wayPointTwo!.first,
            lng: state.requestedTrip!.wayPointTwo!.last,
            address: state.requestedTrip!.wayPointTwoTitle!,
          );
        }
      }
    }
    loadingHomeData = false;
    emit(state.copyWith(status: RideStates.success));
  }

  Future<void> sendIamOkMessage(BuildContext context) async {
  emit(state.copyWith(status: RideStates.loading));
    final result = await sendOkIamComingMessageUseCase();

    result.fold(
      (failure) {
        showErrorMessage(context,
            context.isArabic? "لم يتم ارسال الرسالة" : "Message not sent");

        emit(state.copyWith(status: RideStates.error));},
      (data) {
        showSuccessMessage(
            context,
            context.isArabic
                ? "تم ارسال الرسالة بنجاح"
                : "Message sent successfully");
        emit(state.copyWith(status: RideStates.success));},
    );
  }

  Future<void> ratingDriverByClient(BuildContext context, RatingDriverByClientUseCaseParams params) async {
    final result = await ratingDriverByClientUseCase(params);

    result.fold(
      (failure) {
        showErrorMessage(context,
            context.isArabic? "لم يتم تقييم السائق" : "Driver not rated");
        emit(state.copyWith(status: RideStates.error));},
      (data)async {
        showSuccessMessage(
            context,
            context.isArabic
                ? "تم تقييم السائق بنجاح" : "Driver rated successfully");

        state.rideExpectedPrice = null;
        state.requestedTrip = null;
        state.currentLocation = null;
        state.toLocation = null;
        state.wayPointOne = null;
        state.wayPointTwo = null;
        await _fetchUserLocation();
        showSuccessMessage(
            context,
            context.isArabic
                ? "رحلة سعيدة" : "Happy trip");
        emit(state.copyWith(status: RideStates.success, requestedTrip: state.requestedTrip, rideExpectedPrice: state.rideExpectedPrice));},
    );
  }

  Future<void> finishTripWithoutRating(BuildContext context) async {
    emit(state.copyWith(status: RideStates.loading));

    state.rideExpectedPrice = null;
    state.requestedTrip = null;
    state.currentLocation = null;
    state.toLocation = null;
    state.wayPointOne = null;
    state.wayPointTwo = null;
    await _fetchUserLocation();
    showSuccessMessage(
        context,
        context.isArabic
            ? "رحلة سعيدة" : "Happy trip");
    emit(state.copyWith(status: RideStates.success, requestedTrip: state.requestedTrip, rideExpectedPrice: state.rideExpectedPrice));
}

  bool isTruk = false;
  // update current location
  void updateCurrentLocation({required double lat, required double lng, required String address}) {
    GetLocationFromAddressEntity currentLocation = GetLocationFromAddressEntity(
      lat: lat,
      lng: lng,
      address: address,
    );
    emit(state.copyWith(status: RideStates.loading, currentLocation: currentLocation));
  }

  void checkSelectedCategoryIsSocket(String selectedCategory) {
    if (socketCategories.containsValue(selectedCategory)) {
      selectedCategoryIsSocket = true;
    } else if (trukCategories.containsValue(selectedCategory)) {
      selectedCategoryIsSocket = false;
      isTruk = true;
    } else {
      isTruk = false;
      selectedCategoryIsSocket = false;
    }
    log(selectedCategoryIsSocket.toString());
    emit(state.copyWith(status: RideStates.success));
  }

  Future<void> _fetchUserLocation() async {
    emit(state.copyWith(status: RideStates.loading));

    try {
      Position position = await _determinePosition();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      String address = placemarks.isNotEmpty
          ? "${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}"
          : "Unknown current Location";

      GetLocationFromAddressEntity currentLocation =
          GetLocationFromAddressEntity(
        lat: position.latitude,
        lng: position.longitude,
        address: address,
      );

      emit(state.copyWith(
          status: RideStates.success, currentLocation: currentLocation));
    } catch (e) {
      log('_fetchUserLocation ${e.toString()}');
    }
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    print(" permanently denied$permission");
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Position(
        longitude: 31.235457277186548,
        latitude: 30.047873322617807,
        timestamp: DateTime.now(),
        accuracy: 0.2,
        altitude: 0.5,
        altitudeAccuracy: 0.6,
        heading: 0.2,
        headingAccuracy: 0.1,
        speed: 20,
        speedAccuracy: 10,
      );
    }
    if (permission == LocationPermission.denied) {
      print("objectLocation permissions are permanently denied");
      // permission = await Geolocator.requestPermission();
      // if (permission == LocationPermission.deniedForever||permission == LocationPermission.whileInUse) {
        print("objectLocation permissions are permanently denied");
        return Position(
          longitude: 31.235457277186548,
          latitude: 30.047873322617807,
          timestamp: DateTime.now(),
          accuracy: 0.2,
          altitude: 0.5,
          altitudeAccuracy: 0.6,
          heading: 0.2,
          headingAccuracy: 0.1,
          speed: 20,
          speedAccuracy: 10,
        );
      }
    // }
    return await Geolocator.getCurrentPosition();
  }

  final formKey = GlobalKey<FormState>();
  final idFormKey = GlobalKey<FormState>();
  final carLicenseFormKey = GlobalKey<FormState>();
  final driverLicenseFormKey = GlobalKey<FormState>();
  final drugAnalysisFormKey = GlobalKey<FormState>();
  final criminalRecordFormKey = GlobalKey<FormState>();
  final terminalExaminationFormKey = GlobalKey<FormState>();
  TextEditingController rideNameController = TextEditingController();
  TextEditingController rideSurNameController = TextEditingController();
  TextEditingController rideDateOfBirthController = TextEditingController();
  TextEditingController ridePhoneNumberController = TextEditingController();
  TextEditingController rideDriverLicenseNumController =
      TextEditingController();
  TextEditingController rideDriverExpireDateController =
      TextEditingController();
  TextEditingController ridePersonalDocLicenseNumController =
      TextEditingController();
  TextEditingController ridePersonalDocIdNumController =
      TextEditingController();
  TextEditingController ridePersonalDocExpireDateController =
      TextEditingController();
  TextEditingController rideVehicleLicenseNumController =
      TextEditingController();
  TextEditingController rideVehicleExpireDateController =
      TextEditingController();
  TextEditingController rideDragAnalysisExpireDateController =
      TextEditingController();
  TextEditingController rideTechnicalExaminationExpireDateController =
      TextEditingController();
  TextEditingController rideCriminalRecordExpireDateController =
      TextEditingController();
  TextEditingController rideVehicleProductionYearController =
      TextEditingController();
  TextEditingController rideVehiclePlateNumberController =
      TextEditingController();
  TextEditingController ridePricingPerKmController = TextEditingController();
  TextEditingController rideCarModelController = TextEditingController();

  Future<void> fetchRideCategories(String userId, bool refresh) async {
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, RideCategoryEntityUpdated> result =
        await getRideCategories(
            GetRideCategoriesParams(userId: userId, refresh: refresh));

    result.fold(
      (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (rideCategory) async {
        if (selectedCategoryType == 'ride' && subCategoryId.isNotEmpty) {
          final index = rideCategory.subCategories.indexWhere(
                (sub) => sub.subCategoryId == subCategoryId,
          );

          if (index != -1) {
            final matchedSubCategory = rideCategory.subCategories.removeAt(index);
            rideCategory.subCategories.insert(0, matchedSubCategory);
          }
        }
        emit(state.copyWith(
            status: RideStates.success,
            rideCategory: rideCategory,
            rideSubCategories: rideCategory.subCategories));
      },
    );
  }

  Future<void> fetchShippingCategories(String userId, bool refresh) async {
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, RideCategoryEntityUpdated> result =
        await getShippingCategoriesUsecase(
            GetRideCategoriesParams(userId: userId, refresh: refresh));

    result.fold(
      (failure) =>
          emit(state.copyWith(status: RideStates.error, failure: failure)),
      (rideCategory) async {
        if (selectedCategoryType != 'ride' && subCategoryId.isNotEmpty) {
          final index = rideCategory.subCategories.indexWhere(
                (sub) => sub.subCategoryId == subCategoryId,
          );

          if (index != -1) {
            final matchedSubCategory = rideCategory.subCategories.removeAt(index);
            rideCategory.subCategories.insert(0, matchedSubCategory);
          }
        }
        emit(state.copyWith(
            status: RideStates.success,
            shippingCategory: rideCategory,
            shippingSubCategories: rideCategory.subCategories));
      },
    );
  }

  Future<bool> isSubscribed({required String userId, required String subcategoryId}) async {
    emit(state.copyWith(status: RideStates.loading));
    bool isSuccess = false;
    final Either<Failure, ClickEntity> result = await clickUseCase(ClickParams(ownerId: userId, subcategoryId: subcategoryId, clientId: userId));
    result.fold(
      (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (data) {
        log("isSubscribed $data");
        isSuccess = data.data == 'enable';
        emit(state.copyWith(status: RideStates.success));
      },
    );
    return isSuccess;
  }

  Future<bool> makeRequestTrips() async {
    // if (isClosed) return false;
    emit(state.copyWith(status: RideStates.loadingSubmit));
    bool isSuccess = true;
    final Either<Failure, bool> result =
        await makeRequestTripUseCase(const NoParams());

    // if (isClosed) return false;
    result.fold(
      (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (data) {
        isSuccess = data;
        emit(state.copyWith(status: RideStates.success));
      },
    );
    return isSuccess;
  }

  Future<void> getCostPerKm() async {
    if (isClosed) {
      return; // Prevents state emission if the cubit is already disposed.
    }
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, CostPerKmEntity> result =
        await getCostPerKmUseCase(const NoParams());

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
      (failure) =>
          emit(state.copyWith(status: RideStates.error, failure: failure)),
      (data) {
        emit(state.copyWith(status: RideStates.success, costPerKm: data));
      },
    );
  }

  Future<void> fetchRideDriverInfo(BuildContext context, bool refresh) async {
    if (isClosed) {
      return; // Prevents state emission if the cubit is already disposed.
    }
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, DriverInfoEntity> result =
        await getRideDriverInfoUseCase(refresh);

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
      (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (info) {
        emit(state.copyWith(
            status: RideStates.success,
            driverInfo: info,
            isApproved: info.isApproved,
            isUploadCarImage: info.isUploadCarImage,
            isUploadDriverId: info.isUploadDriverId,
            isUploadDriverImage: info.isUploadDriverImage,
            isUploadDriverLicense: info.isUploadDriverLicense,
            isUploadConfirmIdentifier: info.isUploadConfirmIdentifier,
            isUploadCarLicense: info.isUploadCarLicense,
            isUploadDrugAnalysis: info.isUploadDrugAnalysis,
            isUploadCriminalRecord: info.isUploadCriminalRecord,
            isUploadTechnicalExamination: info.isUploadTechnicalExamination,
            registerType: info.driverType == 'socket' ? 'socket' : 'noSocket',
            isShipping: false));
      },
    );
  }

  Future<void> fetchLoaderInfo(BuildContext context, bool refresh) async {
    if (isClosed) {
      return; // Prevents state emission if the cubit is already disposed.
    }
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, LoadingInfoEntity> result =
        await getLoadingInfoUseCase(refresh);

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
      (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (info) {
        emit(state.copyWith(
            status: RideStates.success,
            loaderInfo: info,
            registerType: 'noSocket',
            isShipping: true));
      },
    );
  }

  fetchRideUploadedImagesData(
      BuildContext context, UploadRiderImagesParams? params) async {
    if (params != null) {
      emit(state.copyWith(
          isShipping: params.isShipping,
          registerType: params.isSocket == true ? 'socket' : 'noSocket'));
    }
    emit(state.copyWith(status: RideStates.loading));
    await Future.wait([
      fetchRideDriverPictureOptional(context),
      if (state.isShipping == true || params?.isShipping == true)
        fetchLoaderInfo(context, false),
      if (state.isShipping == true || params?.isShipping == true)
        fetchLoaderInfo(context, true),
      if (state.isShipping == false || params?.isShipping == false)
        fetchRideDriverInfo(context, false),
      if (state.isShipping == false || params?.isShipping == false)
        fetchRideDriverInfo(context, true)
    ]);
    emit(state.copyWith(status: RideStates.success));
  }

  Future<void> fetchRideDriverPictureOptional(BuildContext context) async {
    if (isClosed) {
      return; // Prevents state emission if the cubit is already disposed.
    }
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, DriverPictureOptionalEntity> result =
        await getDriverPictureOptionalUseCase(const NoParams());

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
      (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (data) {
        emit(state.copyWith(status: RideStates.success, pictureOptional: data));
      },
    );
  }

  Future<void> fetchRideGovernorates() async {
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, List<GovernorateEntity>> result =
        await getRideGovernoratesUseCase(const NoParams());

    result.fold(
      (failure) =>
          emit(state.copyWith(status: RideStates.error, failure: failure)),
      (governorates) async {
        RegisterRideSpecialEntity? data = await Storage().getDriverEntity();
        GovernorateEntity? selectedCity;
        if (data?.city != null && (data?.city.isNotEmpty ?? false)) {
          selectedCity = governorates
              .firstWhereOrNull((element) => element.id == data?.city);
        }
        emit(state.copyWith(
            status: RideStates.success,
            governorates: governorates,
            city: selectedCity));
      },
    );
  }

  double getTotalPrice(double price, {bool isScooter = false}) {
    double totalPrice = price;
    // if (!isScooter) {
      if (serviceLocator<RideCubit>().isComfort) {
        totalPrice += state.rideExpectedPrice?.comfort ?? 0;
      }
      if (serviceLocator<RideCubit>().isNonSmoker) {
        totalPrice += state.rideExpectedPrice?.nonSmoking ?? 0;
      }
      if (serviceLocator<RideCubit>().isAutoAccept) {
        totalPrice += state.rideExpectedPrice?.autoAccept ?? 0;
      }
    // }
    return totalPrice;
  }

  Future<void> fetchRideExpectedPrice({required String id}) async {
    emit(state.copyWith(status: RideStates.loading));

    if(state.currentLocation == null || state.toLocation == null) {
      return;
    }

    final Either<Failure, RideExpectedPriceEntity> result =
        await getRideExpectedPriceUseCase(
      RideExpectedPriceParams(
          startLocation: [
            state.currentLocation!.lat!,
            state.currentLocation!.lng!
          ],
          targetLocation: [
            state.toLocation!.lat!,
            state.toLocation!.lng!
          ],
          // startLocation: [30.0445439,31.2326909],
          // targetLocation: [30.1186853,31.3609478],
          comfort: isComfort,
          nonSmoking: isNonSmoker,
          autoAccept: isAutoAccept,
          wayPointOne: (state.wayPointOne != null)
              ? [state.wayPointOne!.lat!, state.wayPointOne!.lng!]
              : null,
          wayPointTwo: (state.wayPointTwo != null)
              ? [state.wayPointTwo!.lat!, state.wayPointTwo!.lng!]
              : null,
          id: id),
    );

    log(result.toString());

    result.fold(
      (failure) =>
          emit(state.copyWith(status: RideStates.error, failure: failure)),
      (rideExpectedPrice) => emit(state.copyWith(
          status: RideStates.success, rideExpectedPrice: rideExpectedPrice)),
    );
  }

  Future<bool> checkRealAmountIsEnough({required double price}) async {
    final Either<Failure, bool> result =
        await checkRealAmountEnoughUseCase(price);

    return result.fold(
      (failure) => false,
      (isEnough) => isEnough,
    );
  }

  Future<void> requestTrip({
    required String subcategoryId,
    required double price,
    required String fromTitle,
    required String toTitle,
    required double distance,
    required int duration,
    required List<double> startLocation,
    required List<double> targetLocation,
    required List<double>? wayPointOne,
    required List<double>? wayPointTwo,
    required int calculateB,
    required String paymentMethod,
    required int passengers,
    required bool comfort,
    required bool nonSmoker,
    required bool autoAccept,
    required bool isPremium,
    required List<List<double>> polyline,
    required String? wayPointOneTitle,
    required String? wayPointTwoTitle
  }) async {
    final Either<Failure, RideRequestTripEntity> result =
        await requestTripUseCase(
      RequestTripUseCaseParams(
        subcategoryId: subcategoryId,
        price: price,
        fromTitle: fromTitle,
        toTitle: toTitle,
        distance: distance,
        duration: duration,
        startLocation: startLocation,
        targetLocation: targetLocation,
        wayPointOne: wayPointOne,
        wayPointTwo: wayPointTwo,
        calculateB: calculateB,
        paymentMethod: paymentMethod,
        passengers: passengers,
        comfort: comfort,
        nonSmoker: nonSmoker,
        autoAccept: autoAccept,
        isPremium: isPremium,
        polyline: polyline,
        wayPointOneTitle: wayPointOneTitle,
        wayPointTwoTitle: wayPointTwoTitle,
        phoneNumber: "01211972375"
      ),
    );

    result.fold(
          (failure) => emit(state.copyWith(status: RideStates.error, failure: failure)),
          (rideRequestTrip){
            log("tripId${rideRequestTrip.id}");
            if(rideRequestTrip.status == TripState.canceled.name || rideRequestTrip.status == TripState.completed.name){
              _fetchUserLocation();
            }
            else{
              if (rideRequestTrip.targetCoordinates != null && rideRequestTrip.targetCoordinates!.length >= 2) {
                updateToLocation(
                  lat: rideRequestTrip.targetCoordinates!.first,
                  lng: rideRequestTrip.targetCoordinates!.last,
                  address: rideRequestTrip.to!,
                );
              }

              if (rideRequestTrip.startCoordinates != null && rideRequestTrip.startCoordinates!.length >= 2) {
                updateCurrentLocation(
                  lat: rideRequestTrip.startCoordinates!.first,
                  lng: rideRequestTrip.startCoordinates!.last,
                  address: rideRequestTrip.from!,
                );
              }

              if (rideRequestTrip.wayPointOne != null &&
                  rideRequestTrip.wayPointOne!.length >= 2 &&
                  rideRequestTrip.wayPointOneTitle != null) {
                updateWayPointOne(
                  lat: rideRequestTrip.wayPointOne!.first,
                  lng: rideRequestTrip.wayPointOne!.last,
                  address: rideRequestTrip.wayPointOneTitle!,
                );
              }

              if (rideRequestTrip.wayPointTwo != null &&
                  rideRequestTrip.wayPointTwo!.length >= 2 &&
                  rideRequestTrip.wayPointTwoTitle != null) {
                updateWayPointTwo(
                  lat: rideRequestTrip.wayPointTwo!.first,
                  lng: rideRequestTrip.wayPointTwo!.last,
                  address: rideRequestTrip.wayPointTwoTitle!,
                );
              }
            }
            emit(state.copyWith(status: RideStates.success, requestedTrip: rideRequestTrip,));
          },
    );
  }

  Future<void> updateTripAutoAcceptStatus({required bool isAutoAccept}) async {
    final Either<Failure, bool> result =
        await updateTripAutoAcceptByClientUseCase(
      UpdateTripAutoAcceptByClientUseCaseParams(
        isAutoAccept: isAutoAccept,
      ),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(status: RideStates.error, failure: failure)),
      (status) {
        state.requestedTrip!.autoAccept = isAutoAccept;
        emit(state.copyWith(status: RideStates.success));
      },
    );
  }

  Future<void> updateTripPriceStatus({required double newOfferPrice}) async {

    final Either<Failure, bool> result = await updateTripPriceUseCase(
      UpdateTripPriceUseCaseParams(
        newOfferPrice: newOfferPrice,
      ),
    );

    result.fold(
          (failure) => emit(state.copyWith(status: RideStates.error, failure: failure)),
          (status){
            if (state.requestedTrip != null && state.requestedTrip!.price != null) {
              final newPrice = state.requestedTrip!.price! + newOfferPrice;
              final updatedTrip = state.requestedTrip!.copyWith(price: newPrice);

              emit(state.copyWith(
                requestedTrip: updatedTrip,
                status: RideStates.success,
              ));
            } else {
              emit(state.copyWith(status: RideStates.success));
            }
          },
    );
  }

  Future<void> retrieveClientLatestTrip() async {
    final Either<Failure, RideRequestTripEntity> result =
        await retrieveClientLatestTripUseCase(const NoParams());

    result.fold(
          (failure) => emit(state.copyWith(status: RideStates.error, failure: failure, requestedTrip: null)),
          (rideRequestTrip){
            if(rideRequestTrip.status == TripState.canceled.name || rideRequestTrip.status == TripState.completed.name){
              _fetchUserLocation();
            }
            else{
              if (rideRequestTrip.targetCoordinates != null && rideRequestTrip.targetCoordinates!.length >= 2) {
                updateToLocation(
                  lat: rideRequestTrip.targetCoordinates!.first,
                  lng: rideRequestTrip.targetCoordinates!.last,
                  address: rideRequestTrip.to!,
                );
              }

              if (rideRequestTrip.startCoordinates != null && rideRequestTrip.startCoordinates!.length >= 2) {
                updateCurrentLocation(
                  lat: rideRequestTrip.startCoordinates!.first,
                  lng: rideRequestTrip.startCoordinates!.last,
                  address: rideRequestTrip.from!,
                );
              }

              if (rideRequestTrip.wayPointOne != null &&
                  rideRequestTrip.wayPointOne!.length >= 2 &&
                  rideRequestTrip.wayPointOneTitle != null) {
                updateWayPointOne(
                  lat: rideRequestTrip.wayPointOne!.first,
                  lng: rideRequestTrip.wayPointOne!.last,
                  address: rideRequestTrip.wayPointOneTitle!,
                );
              }

              if (rideRequestTrip.wayPointTwo != null &&
                  rideRequestTrip.wayPointTwo!.length >= 2 &&
                  rideRequestTrip.wayPointTwoTitle != null) {
                updateWayPointTwo(
                  lat: rideRequestTrip.wayPointTwo!.first,
                  lng: rideRequestTrip.wayPointTwo!.last,
                  address: rideRequestTrip.wayPointTwoTitle!,
                );
              }
            }
            emit(state.copyWith(status: RideStates.success, requestedTrip: rideRequestTrip));
          },
    );
  }

  Future<void> acceptOfferByClient({required String offerId}) async {
    final Either<Failure, RideRequestTripEntity> result =
        await acceptOfferByClientUseCase(offerId);

    result.fold(
          (failure) => emit(state.copyWith(status: RideStates.error, failure: failure)),
          (rideRequestTrip) {
            if(rideRequestTrip.status == TripState.canceled.name || rideRequestTrip.status == TripState.completed.name){
              _fetchUserLocation();
            }
            else{
              if (rideRequestTrip.targetCoordinates != null && rideRequestTrip.targetCoordinates!.length >= 2) {
                updateToLocation(
                  lat: rideRequestTrip.targetCoordinates!.first,
                  lng: rideRequestTrip.targetCoordinates!.last,
                  address: rideRequestTrip.to!,
                );
              }

              if (rideRequestTrip.startCoordinates != null && rideRequestTrip.startCoordinates!.length >= 2) {
                updateCurrentLocation(
                  lat: rideRequestTrip.startCoordinates!.first,
                  lng: rideRequestTrip.startCoordinates!.last,
                  address: rideRequestTrip.from!,
                );
              }

              if (rideRequestTrip.wayPointOne != null &&
                  rideRequestTrip.wayPointOne!.length >= 2 &&
                  rideRequestTrip.wayPointOneTitle != null) {
                updateWayPointOne(
                  lat: rideRequestTrip.wayPointOne!.first,
                  lng: rideRequestTrip.wayPointOne!.last,
                  address: rideRequestTrip.wayPointOneTitle!,
                );
              }

              if (rideRequestTrip.wayPointTwo != null &&
                  rideRequestTrip.wayPointTwo!.length >= 2 &&
                  rideRequestTrip.wayPointTwoTitle != null) {
                updateWayPointTwo(
                  lat: rideRequestTrip.wayPointTwo!.first,
                  lng: rideRequestTrip.wayPointTwo!.last,
                  address: rideRequestTrip.wayPointTwoTitle!,
                );
              }
            }
            rideRequestTrip.status = TripState.accepted.name;
            emit(state.copyWith(status: RideStates.success, requestedTrip: rideRequestTrip));
          },
    );
  }

  Future<void> cancelPendingTripByClient({required String tripId}) async {
    // emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, bool> result = await cancelPendingTripByClientUseCase(
      CancelPendingTripByClientUseCaseParams(
        tripId: tripId,
      ),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(status: RideStates.error, failure: failure)),
      (isCanceled) {
        if (isCanceled) {
          state.rideExpectedPrice = null;
          state.requestedTrip = null;
        }
        emit(state.copyWith(
            status: RideStates.success, requestedTrip: state.requestedTrip));
      },
    );
  }

  Future<void> fetchAllCompletedTrips(
      {required int limit, required int page}) async {
    //emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, List<CompletedTripsEntity>> result =
        await getAllCompletedTripsUseCase(
            GetAllCompletedTripsUseCaseParams(limit, page));

    result.fold(
      (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (completedTrips) {
        final List<CompletedTripsEntity> updatedTrips = page == 1
            ? completedTrips
            : [...?state.completedTrips, ...completedTrips];

        emit(state.copyWith(
            status: RideStates.success, completedTrips: updatedTrips));
      },
    );
  }

  Future<void> fetchAllRunningTrips(
      {required int limit, required int page}) async {
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, List<RunningTripsEntity>> result =
        await getAllRunningTripsUseCase(
            GetAllRunningTripsUseCaseParams(limit, page));

    result.fold(
      (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (runningTrips) {
        final List<RunningTripsEntity> updatedTrips = page == 1
            ? runningTrips
            : [...?state.runningTrips, ...runningTrips];

        emit(state.copyWith(
            status: RideStates.success, runningTrips: updatedTrips));
      },
    );
  }

  Future<void> fetchAllActivityTrips(
      {required int limit, required int page}) async {
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, ActivityTripEntity> result =
        await getAllActivityTripsUseCase(
            GetAllActivityTripsUseCaseParams(limit: limit, page: page));
    result.fold(
      (failure) =>
          emit(state.copyWith(status: RideStates.error, failure: failure)),
      (activityTrips) => emit(state.copyWith(
          status: RideStates.success, activityTrips: activityTrips)),
    );
  }

  void updateFromLocation(
      {required double lat, required double lng, required String address}) {
    GetLocationFromAddressEntity currentLocation = GetLocationFromAddressEntity(
      lat: lat,
      lng: lng,
      address: address,
    );

    emit(state.copyWith(
        status: RideStates.success, currentLocation: currentLocation));
  }

  void emitRefreshState() {
    emit(state.copyWith(status: RideStates.success));
  }

  void updateToLocation(
      {required double lat, required double lng, required String address}) {
    GetLocationFromAddressEntity toLocation = GetLocationFromAddressEntity(
      lat: lat,
      lng: lng,
      address: address,
    );

    emit(state.copyWith(status: RideStates.success, toLocation: toLocation));
  }

  void updateWayPointOne(
      {required double lat, required double lng, required String address}) {
    GetLocationFromAddressEntity wayPointOne = GetLocationFromAddressEntity(
      lat: lat,
      lng: lng,
      address: address,
    );

    emit(state.copyWith(status: RideStates.success, wayPointOne: wayPointOne));
  }

  void updateWayPointTwo(
      {required double lat, required double lng, required String address}) {
    GetLocationFromAddressEntity wayPointTwo = GetLocationFromAddressEntity(
      lat: lat,
      lng: lng,
      address: address,
    );

    emit(state.copyWith(status: RideStates.success, wayPointTwo: wayPointTwo));
  }

  loadRegisterData(BuildContext context) async {
    emit(state.copyWith(status: RideStates.loading));
    await Future.wait(
        [fetchGovs(), fetchBrands(context), fetchColors(context)]);
    emit(state.copyWith(status: RideStates.success));
  }

  Future<void> fetchGovs() async {
    final Either<Failure, List<GovernorateEntity>> result =
        await getRideGovernoratesUseCase(const NoParams());

    result.fold(
      (failure) =>
          emit(state.copyWith(status: RideStates.error, failure: failure)),
      (governorates) async {
        RegisterRideSpecialEntity? cachedData =
            await Storage().getDriverEntity();
        String? cityId = cachedData?.city;
        GovernorateEntity? selectedCity;
        if (cityId != null && (cityId.isNotEmpty)) {
          selectedCity =
              governorates.firstWhere((element) => element.id == cityId);
          onSelectGov(cityId);
        }
        emit(state.copyWith(
            status: RideStates.success,
            govs: governorates,
            city: selectedCity));
      },
    );
  }

  Future<void> fetchBrands(BuildContext context) async {
    final Either<Failure, List<RideBrandEntity>> result =
        await getRideBrandsUseCase(const NoParams());

    result.fold(
      (failure) =>
          emit(state.copyWith(status: RideStates.error, failure: failure)),
      (data) async {
        RegisterRideSpecialEntity? cachedData =
            await Storage().getDriverEntity();
        String? brand = cachedData?.vehicleBrand;
        if (brand != null && (brand.isNotEmpty)) {
          await onSelectBrand(brand, context);
        }
        emit(state.copyWith(
            status: RideStates.success, brands: data, selectedBrand: brand));
      },
    );
  }

  List<String> subscriptionPlans = [
    'Percentage',
    'Subscribe Package',
  ];

  List<RideModelEntity> models = [];
  onSelectBrand(String brand, BuildContext context) async {
    if (brand == state.selectedBrand) return;
    emit(state.copyWith(
        selectedBrand: brand,
        selectedModel: '',
        status: RideStates.loadingModels));
    await fetchModels(brand, context);
    emit(state.copyWith(status: RideStates.success));
  }

  onSelectModel(String model) {
    emit(state.copyWith(selectedModel: model, status: RideStates.success));
  }

  onSelectColor(RideColorEntity color) {
    emit(state.copyWith(selectedColors: color, status: RideStates.success));
  }

  onSelectGov(String gov) {
    emit(state.copyWith(selectedGov: gov, status: RideStates.success));
  }

  onSelectPlan(String plan) {
    String selectedPlan =
        plan == 'Percentage' ? 'percentage' : 'subscribePackage';
    emit(
        state.copyWith(selectedPlan: selectedPlan, status: RideStates.success));
  }

  Future<void> fetchModels(String brandId, BuildContext context) async {
    models.clear();
    emit(state.copyWith(colors: [], status: RideStates.loadingModels));
    final Either<Failure, List<RideModelEntity>> result =
        await getRideModelsUseCase(brandId);

    result.fold(
      (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (data) async {
        models.addAll(data);
        // RegisterRideSpecialEntity? cachedData = await Storage().getDriverEntity();
        // String? model = cachedData?.vehicleModel;
        // if (model != null && (model.isNotEmpty)) {
        //   onSelectModel(model);
        // }
        emit(state.copyWith(status: RideStates.success, models: data));
      },
    );
  }

  Future<void> fetchColors(BuildContext context) async {
    final Either<Failure, List<RideColorEntity>> result =
        await getRideCarColorsUseCase(const NoParams());

    result.fold(
      (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (data) async {
        RegisterRideSpecialEntity? cachedData =
            await Storage().getDriverEntity();
        String? color = cachedData?.vehicleColor;
        RideColorEntity? selectedColor;
        if (color != null && (color.isNotEmpty)) {
          selectedColor = data.firstWhere((element) => element.id == color);
          onSelectColor(selectedColor);
        }
        emit(state.copyWith(
            status: RideStates.success, colors: data, color: selectedColor));
      },
    );
  }

  onUploadPersonalPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(personalPicture: file));
        });
  }

  onUploadDriverLicensePicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(driverLicensePicture: file));
        });
  }

  onUploadBackOfDriverLicensePicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(backOfDriverLicensePicture: file));
        });
  }

  onUploadSelfieDriverLicensePicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(selfieDriverLicensePicture: file));
        });
  }

  onUploadPersonalFrontIdPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(personalFrontIdPicture: file));
        });
  }

  onUploadPersonalBackIdPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(personalBackIdPicture: file));
        });
  }

  onUploadPersonalCriminalRecordPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(personalCriminalRecordPicture: file));
        });
  }

  onUploadPersonalDrugAnalysisPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(personalDrugAnalysisPicture: file));
        });
  }

  onUploadPersonalTechnicalExaminationPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(personalTechnicalExaminationPicture: file));
        });
  }

  onUploadVehicleFrontPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(vehicleFrontPicture: file));
        });
  }

  onUploadVehicleBackPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(vehicleBackPicture: file));
        });
  }

  onUploadVehiclePicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(vehiclePicture: file));
        });
  }

  String captain = '62c8ba9f8e28a58a3edf57eb';
  String lady = '62ea012a69ea29c91dfc3917';
  String intercity = '62c8baa08e28a58a3edf57ed';
  String premium = '62c8baa38e28a58a3edf57f3';
  String taxi = '62c8ba9e8e28a58a3edf57e9';
  String suv = '62c8baa28e28a58a3edf57f1';
  String scooter = '6698736fdaa111da2d775627';

  onSubmitSelectSubCategories(BuildContext context) async {
    final categoriesToCheck = {
      captain,
      lady,
      premium,
      intercity,
      taxi,
      suv,
      scooter,
    };

    if ((state.rideSubCategories ?? []).any((element) =>
        categoriesToCheck.contains(element.subCategoryId) &&
        element.isSelected == true)) {
      emit(state.copyWith(registerType: 'socket', isShipping: false));
      context.push(Routes.personalInformationScreen,
          extra: RideFeatureRegisterParams(
              isSocket: true,
              isShipping: false,
              subCategoriesId: (state.rideSubCategories ?? [])
                  .where((e) => e.isEnabled == true)
                  .toList()
                  .map((e) => e.subCategoryId)
                  .toList()));
    } else {
      emit(state.copyWith(registerType: 'noSocket', isShipping: false));
      context.push(Routes.personalInformationScreen,
          extra: RideFeatureRegisterParams(
              isSocket: false,
              isShipping: false,
              subCategoriesId: (state.rideSubCategories ?? [])
                  .where((e) => e.isEnabled == true)
                  .toList()
                  .map((e) => e.subCategoryId)
                  .toList()));
    }
  }

  onSubmitSelectShippingSubCategories(BuildContext context) async {
    emit(state.copyWith(registerType: 'noSocket', isShipping: true));
    context.push(Routes.personalInformationScreen,
        extra: RideFeatureRegisterParams(
            isSocket: false,
            isShipping: true,
            subCategoriesId: (state.shippingSubCategories ?? [])
                .where((e) => e.isEnabled == true)
                .toList()
                .map((e) => e.subCategoryId)
                .toList()));
  }

  onNavigateToWelcomeScreen(
      {required bool fromShipping, required BuildContext context}) {
    if (fromShipping == true) {
      emit(state.copyWith(isShipping: true, status: RideStates.success));
      context.push(Routes.welcomeRideRegister, extra: fromShipping);
    } else {
      emit(state.copyWith(isShipping: false, status: RideStates.success));
      context.push(Routes.welcomeRideRegister, extra: fromShipping);
    }
  }

  onSelectShippingSubCategory(String id, BuildContext context) {
    List<SubCategoryEntityUpdated> subCategories = [];
    subCategories.addAll(state.shippingSubCategories ?? []);
    SubCategoryEntityUpdated selectedItem =
        subCategories.firstWhere((element) => element.subCategoryId == id);
    if (selectedItem.isSelected == true) {
      selectedItem.isSelected = false;
      subCategories.where((e) => e.isEnabled = true).toList();
    } else {
      subCategories.where((e) => e.isEnabled = false).toList();
      selectedItem.isSelected = true;
      selectedItem.isEnabled = true;
    }
    emit(state.copyWith(rideSubCategories: subCategories));
  }

  onSelectSubCategory(String id, BuildContext context) {
    bool isMale = UserCubit.to.state.data?.gender == 'male';
    List<SubCategoryEntityUpdated> subCategories = [];
    subCategories.addAll(state.rideSubCategories ?? []);
    SubCategoryEntityUpdated selectedItem =
        subCategories.firstWhere((element) => element.subCategoryId == id);
    SubCategoryEntityUpdated captainCategory =
        subCategories.firstWhere((element) => element.subCategoryId == captain);
    SubCategoryEntityUpdated ladyCategory =
        subCategories.firstWhere((element) => element.subCategoryId == lady);
    SubCategoryEntityUpdated premiumCategory =
        subCategories.firstWhere((element) => element.subCategoryId == premium);
    SubCategoryEntityUpdated intercityCategory = subCategories
        .firstWhere((element) => element.subCategoryId == intercity);
    if (id == captain) {
      if (!isMale) {
        showErrorMessage(context,
            "You are female, try register as a lady or change your gender from setting.");
        return;
      }
      if (selectedItem.isSelected == true) {
        if (premiumCategory.isSelected == true ||
            intercityCategory.isSelected == true) {
          ladyCategory.isEnabled = true;
          captainCategory.isEnabled = true;
          captainCategory.isSelected = false;
        } else {
          captainCategory.isSelected = false;
          subCategories.where((e) => e.isEnabled = true).toList();
        }
      } else {
        if (premiumCategory.isSelected == true ||
            intercityCategory.isSelected == true) {
          ladyCategory.isEnabled = false;
          ladyCategory.isSelected = false;
          captainCategory.isEnabled = true;
          captainCategory.isSelected = true;
        } else {
          subCategories.where((e) => e.isEnabled = false).toList();
          subCategories.where((e) => e.isSelected = false).toList();
          captainCategory.isEnabled = true;
          captainCategory.isSelected = true;
          premiumCategory.isEnabled = true;
          intercityCategory.isEnabled = true;
        }
      }
    } else if (id == lady) {
      if (isMale) {
        showErrorMessage(context,
            "You are male, try register as a captain or change your gender from setting.");
        return;
      }
      if (selectedItem.isSelected == true) {
        if (premiumCategory.isSelected == true ||
            intercityCategory.isSelected == true) {
          captainCategory.isEnabled = true;
          ladyCategory.isEnabled = true;
          ladyCategory.isSelected = false;
        } else {
          ladyCategory.isSelected = false;
          subCategories.where((e) => e.isEnabled = true).toList();
        }
      } else {
        if (premiumCategory.isSelected == true ||
            intercityCategory.isSelected == true) {
          captainCategory.isEnabled = false;
          captainCategory.isSelected = false;
          ladyCategory.isEnabled = true;
          ladyCategory.isSelected = true;
        } else {
          subCategories.where((e) => e.isEnabled = false).toList();
          subCategories.where((e) => e.isSelected = false).toList();
          ladyCategory.isEnabled = true;
          ladyCategory.isSelected = true;
          premiumCategory.isEnabled = true;
          intercityCategory.isEnabled = true;
        }
      }
    } else if (id == premium) {
      if (selectedItem.isSelected == true) {
        if (captainCategory.isSelected == true ||
            ladyCategory.isSelected == true ||
            intercityCategory.isSelected == true) {
          premiumCategory.isSelected = false;
        } else {
          premiumCategory.isSelected = false;
          subCategories.where((e) => e.isEnabled = true).toList();
        }
      } else {
        if (captainCategory.isSelected == true ||
            ladyCategory.isSelected == true ||
            intercityCategory.isSelected == true) {
          premiumCategory.isSelected = true;
        } else {
          subCategories.where((e) => e.isEnabled = false).toList();
          premiumCategory.isSelected = true;
          premiumCategory.isEnabled = true;
          intercityCategory.isEnabled = true;
          captainCategory.isEnabled = true;
          ladyCategory.isEnabled = true;
        }
      }
    } else if (id == intercity) {
      if (selectedItem.isSelected == true) {
        if (captainCategory.isSelected == true ||
            ladyCategory.isSelected == true ||
            premiumCategory.isSelected == true) {
          intercityCategory.isSelected = false;
        } else {
          intercityCategory.isSelected = false;
          subCategories.where((e) => e.isEnabled = true).toList();
        }
      } else {
        if (captainCategory.isSelected == true ||
            ladyCategory.isSelected == true ||
            premiumCategory.isSelected == true) {
          intercityCategory.isSelected = true;
        } else {
          subCategories.where((e) => e.isEnabled = false).toList();
          intercityCategory.isSelected = true;
          intercityCategory.isEnabled = true;
          premiumCategory.isEnabled = true;
          captainCategory.isEnabled = true;
          ladyCategory.isEnabled = true;
        }
      }
    } else {
      if (selectedItem.isSelected == true) {
        selectedItem.isSelected = false;
        subCategories.where((e) => e.isEnabled = true).toList();
      } else {
        subCategories.where((e) => e.isEnabled = false).toList();
        selectedItem.isSelected = true;
        selectedItem.isEnabled = true;
      }
    }
    emit(state.copyWith(rideSubCategories: subCategories));
  }

  onChangeSmokingValue() {
    emit(state.copyWith(
        isSmoking: !(state.isSmoking ?? false), status: RideStates.success));
  }

  onChangeAirCondition() {
    emit(state.copyWith(
        hasAirCondition: !(state.hasAirCondition ?? false),
        status: RideStates.success));
  }

  onSubmitUploadingId(BuildContext context) async {
    emit(state.copyWith(status: RideStates.loadingSubmit));
    DriverInfoEntity? driverInfo = state.driverInfo;
    LoadingInfoEntity? loaderInfo = state.loaderInfo;
    if (idFormKey.currentState!.validate()) {
      if (state.personalFrontIdPicture == null) {
        showErrorMessage(context, "Please select front id picture");
        return;
      }
      if (state.personalBackIdPicture == null) {
        showErrorMessage(context, "Please select back id picture");
        return;
      }
      showLoadingDialog(context, canPop: false);
      emit(state.copyWith(status: RideStates.loadingSubmit));
      state.isShipping == true
          ? await LoadingMethodHelper().uploadDriverId(
              idImageInBehind: state.personalBackIdPicture!,
              idImageInFront: state.personalFrontIdPicture!,
              idExpiryDate: ridePersonalDocExpireDateController.text,
              onSuccessUploaded: (bool isSuccess) async {
                if (isSuccess == true) {
                  loaderInfo?.isUploadDriverId = true;
                  emit(state.copyWith(
                      loaderInfo: loaderInfo, status: RideStates.success));
                  if (state.loaderInfo?.isUploadDriverLicense == true &&
                      state.loaderInfo?.isUploadDriverId == true &&
                      state.loaderInfo?.isUploadCarLicense == true &&
                      state.loaderInfo?.isUploadCarImage == true) {
                    await fetchLoaderInfo(context, false);
                  }
                  showSuccessMessage(
                      context,
                      context.isArabic
                          ? 'تم رفع الصور بنجاح'
                          : "Successfully uploaded images");
                  context.pop();
                  context.pop();
                } else {
                  context.pop();
                  showErrorMessage(
                      context,
                      context.isArabic
                          ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                          : 'An error occurred while uploading images. Please try again.');
                }
              })
          : await RideMethodHelper().uploadDriverId(
              idImageInBehind: state.personalBackIdPicture!,
              idImageInFront: state.personalFrontIdPicture!,
              idExpiryDate: ridePersonalDocExpireDateController.text,
              onSuccessUploaded: (bool isSuccess) async {
                if (isSuccess) {
                  driverInfo?.isUploadDriverId = true;
                  emit(state.copyWith(
                      driverInfo: driverInfo, status: RideStates.success));
                  if (state.driverInfo?.isUploadDriverLicense == true &&
                      state.driverInfo?.isUploadDriverId == true &&
                      state.driverInfo?.isUploadCarLicense == true &&
                      state.driverInfo?.isUploadConfirmIdentifier == true &&
                      state.driverInfo?.isUploadDriverImage == true &&
                      state.driverInfo?.isUploadCarImage == true) {
                    await fetchRideDriverInfo(context, false);
                    showSuccessMessage(
                        context,
                        context.isArabic
                            ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                            : "Successfully uploaded images, please wait for the approval of all data.");
                  }
                  showSuccessMessage(
                      context,
                      context.isArabic
                          ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                          : "Successfully uploaded images, please wait for the approval of all data.");
                  context.pop();
                  context.pop();
                  emit(state.copyWith(status: RideStates.success));
                } else {
                  context.pop();
                  showErrorMessage(
                      context,
                      context.isArabic
                          ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                          : 'An error occurred while uploading images. Please try again.');
                }
              });
      Future.delayed(const Duration(seconds: 3));
      driverInfo?.isUploadDriverId = true;
    }
  }

  onSubmitUploadingDriverLicense(BuildContext context) async {
    DriverInfoEntity? driverInfo = state.driverInfo;
    LoadingInfoEntity? loaderInfo = state.loaderInfo;
    if (driverLicenseFormKey.currentState!.validate()) {
      if (state.driverLicensePicture == null) {
        showErrorMessage(context, "Please select driver license picture");
        return;
      }
      if (state.backOfDriverLicensePicture == null) {
        showErrorMessage(
            context, "Please select back of driver license picture");
        return;
      }
      if (state.selfieDriverLicensePicture == null &&
          state.isShipping != true) {
        showErrorMessage(
            context, "Please select selfie driver license picture");
        return;
      }
      showLoadingDialog(context, canPop: false);
      state.isShipping == true
          ? await LoadingMethodHelper().uploadDriverLicense(
              onSuccessUploaded: (isSuccess) async {
                if (isSuccess == true) {
                  loaderInfo?.isUploadDriverLicense = true;
                  emit(state.copyWith(
                      loaderInfo: loaderInfo, status: RideStates.success));
                  if (state.loaderInfo?.isUploadDriverLicense == true &&
                      state.loaderInfo?.isUploadDriverId == true &&
                      state.loaderInfo?.isUploadCarLicense == true &&
                      state.loaderInfo?.isUploadCarImage == true) {
                    await fetchLoaderInfo(context, false);
                    showSuccessMessage(
                        context,
                        context.isArabic
                            ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                            : "Successfully uploaded images, please wait for the approval of all data.");
                  }
                  showSuccessMessage(
                      context,
                      context.isArabic
                          ? 'تم رفع الصور بنجاح'
                          : "Successfully uploaded images");
                  context.pop();
                  context.pop();
                } else {
                  context.pop();
                  showErrorMessage(
                      context,
                      context.isArabic
                          ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                          : 'An error occurred while uploading images. Please try again.');
                }
              },
              drivingImageInFront: state.driverLicensePicture!,
              drivingImageBehind: state.backOfDriverLicensePicture!,
              drivingExpiryDate: rideDriverExpireDateController.text)
          : await RideMethodHelper().uploadDriverLicense(
              drivingImageInFront: state.driverLicensePicture!,
              drivingImageBehind: state.backOfDriverLicensePicture!,
              drivingExpiryDate: rideDriverExpireDateController.text,
              onSuccessUploaded: (bool isSuccess) async {
                if (isSuccess) {
                  driverInfo?.isUploadDriverLicense = true;
                  emit(state.copyWith(
                      driverInfo: driverInfo, status: RideStates.success));
                  if (state.driverInfo?.isUploadDriverLicense == true &&
                      state.driverInfo?.isUploadDriverId == true &&
                      state.driverInfo?.isUploadCarLicense == true &&
                      state.driverInfo?.isUploadConfirmIdentifier == true &&
                      state.driverInfo?.isUploadDriverImage == true &&
                      state.driverInfo?.isUploadCarImage == true) {
                    await fetchRideDriverInfo(context, false);
                    showSuccessMessage(
                        context,
                        context.isArabic
                            ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                            : "Successfully uploaded images, please wait for the approval of all data.");
                  }
                  emit(state.copyWith(status: RideStates.success));
                } else {
                  showErrorMessage(
                      context,
                      context.isArabic
                          ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                          : 'An error occurred while uploading images. Please try again.');
                }
              });
      emit(state.copyWith(status: RideStates.success));
      if (state.isShipping != true) {
        await RideMethodHelper().confirmIdentity(
            verifyUserImage: state.selfieDriverLicensePicture!,
            onSuccessUploaded: (bool isSuccess) async {
              if (isSuccess) {
                driverInfo?.isUploadConfirmIdentifier = true;
                emit(state.copyWith(
                    driverInfo: driverInfo, status: RideStates.success));
                if (state.driverInfo?.isUploadDriverLicense == true &&
                    state.driverInfo?.isUploadDriverId == true &&
                    state.driverInfo?.isUploadCarLicense == true &&
                    state.driverInfo?.isUploadConfirmIdentifier == true &&
                    state.driverInfo?.isUploadDriverImage == true &&
                    state.driverInfo?.isUploadCarImage == true) {
                  await fetchRideDriverInfo(context, false);
                  showSuccessMessage(
                      context,
                      context.isArabic
                          ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                          : "Successfully uploaded images, please wait for the approval of all data.");
                }
                showSuccessMessage(
                    context,
                    context.isArabic
                        ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                        : "Successfully uploaded images, please wait for the approval of all data.");
                context.pop();
                context.pop();
                emit(state.copyWith(status: RideStates.success));
              } else {
                context.pop();
                showErrorMessage(
                    context,
                    context.isArabic
                        ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                        : 'An error occurred while uploading images. Please try again.');
              }
            });
      }
      emit(state.copyWith(status: RideStates.success));
    }
  }

  onSubmitUploadingCarLicense(BuildContext context) async {
    emit(state.copyWith(status: RideStates.loadingSubmit));
    DriverInfoEntity? driverInfo = state.driverInfo;
    LoadingInfoEntity? loaderInfo = state.loaderInfo;

    showLoadingDialog(context, canPop: false);
    state.isShipping == true
        ? await LoadingMethodHelper().uploadCarLicense(
            licenseExpiryDate: rideVehicleExpireDateController.text,
            carLicenseBehindImage: state.vehicleBackPicture!,
            carLicenseFrontImage: state.vehicleFrontPicture!,
            onSuccessUploaded: (bool isSuccess) async {
              if (isSuccess == true) {
                loaderInfo?.isUploadCarLicense = true;
                emit(state.copyWith(
                    loaderInfo: loaderInfo, status: RideStates.success));
                if (state.loaderInfo?.isUploadDriverLicense == true &&
                    state.loaderInfo?.isUploadDriverId == true &&
                    state.loaderInfo?.isUploadCarLicense == true &&
                    state.loaderInfo?.isUploadCarImage == true) {
                  await fetchLoaderInfo(context, false);
                  showSuccessMessage(
                      context,
                      context.isArabic
                          ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                          : "Successfully uploaded images, please wait for the approval of all data.");
                }
                showSuccessMessage(
                    context,
                    context.isArabic
                        ? 'تم رفع الصور بنجاح'
                        : "Successfully uploaded images");
              } else {
                context.pop();
                showErrorMessage(
                    context,
                    context.isArabic
                        ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                        : 'An error occurred while uploading images. Please try again.');
              }
            })
        : await RideMethodHelper().uploadCarLicense(
            licenseExpiryDate: rideVehicleExpireDateController.text,
            carLicenseBehindImage: state.vehicleBackPicture!,
            carLicenseFrontImage: state.vehicleFrontPicture!,
            onSuccessUploaded: (bool isSuccess) async {
              if (isSuccess) {
                driverInfo?.isUploadCarLicense = true;
                emit(state.copyWith(
                    driverInfo: driverInfo, status: RideStates.success));
                if (state.driverInfo?.isUploadDriverLicense == true &&
                    state.driverInfo?.isUploadDriverId == true &&
                    state.driverInfo?.isUploadCarLicense == true &&
                    state.driverInfo?.isUploadConfirmIdentifier == true &&
                    state.driverInfo?.isUploadDriverImage == true &&
                    state.driverInfo?.isUploadCarImage == true) {
                  await fetchRideDriverInfo(context, false);
                  showSuccessMessage(
                      context,
                      context.isArabic
                          ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                          : "Successfully uploaded images, please wait for the approval of all data.");
                }
                emit(state.copyWith(status: RideStates.success));
              } else {
                showErrorMessage(
                    context,
                    context.isArabic
                        ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                        : 'An error occurred while uploading images. Please try again.');
              }
            });
    state.isShipping == true
        ? await LoadingMethodHelper().uploadCarImage(
            carImage: state.vehiclePicture!,
            onSuccessUploaded: (bool isSuccess) async {
              if (isSuccess) {
                loaderInfo?.isUploadCarImage = true;
                emit(state.copyWith(
                    loaderInfo: loaderInfo, status: RideStates.success));
                if (state.loaderInfo?.isUploadDriverLicense == true &&
                    state.loaderInfo?.isUploadDriverId == true &&
                    state.loaderInfo?.isUploadCarLicense == true &&
                    state.loaderInfo?.isUploadCarImage == true) {
                  await fetchLoaderInfo(context, false);
                  showSuccessMessage(
                      context,
                      context.isArabic
                          ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                          : "Successfully uploaded images, please wait for the approval of all data.");
                }
                context.pop();
                context.pop();
                emit(state.copyWith(
                    status: RideStates.success, isUploadCarImage: isSuccess));
              } else {
                context.pop();
                showErrorMessage(
                    context,
                    context.isArabic
                        ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                        : 'An error occurred while uploading images. Please try again.');
              }
            })
        : await RideMethodHelper().uploadCarImage(
            carImage: state.vehiclePicture!,
            onSuccessUploaded: (bool isSuccess) async {
              log('uploadCarImageSuccessCubit $isSuccess');

              if (isSuccess) {
                driverInfo?.isUploadCarImage = true;
                emit(state.copyWith(
                    driverInfo: driverInfo, status: RideStates.success));
                if (state.driverInfo?.isUploadDriverLicense == true &&
                    state.driverInfo?.isUploadDriverId == true &&
                    state.driverInfo?.isUploadCarLicense == true &&
                    state.driverInfo?.isUploadConfirmIdentifier == true &&
                    state.driverInfo?.isUploadDriverImage == true &&
                    state.driverInfo?.isUploadCarImage == true) {
                  await fetchRideDriverInfo(context, false);
                  showSuccessMessage(
                      context,
                      context.isArabic
                          ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                          : "Successfully uploaded images, please wait for the approval of all data.");
                }
                context.pop();
                context.pop();
                emit(state.copyWith(status: RideStates.success));
              } else {
                context.pop();
                showErrorMessage(
                    context,
                    context.isArabic
                        ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                        : 'An error occurred while uploading images. Please try again.');
              }
            });
    emit(state.copyWith(status: RideStates.success));
  }

  onSubmitUploadingDrugAnalysis(BuildContext context) async {
    if (drugAnalysisFormKey.currentState!.validate()) {
      emit(state.copyWith(status: RideStates.loadingSubmit));
      DriverInfoEntity? driverInfo = state.driverInfo;
      showLoadingDialog(context, canPop: false);
      await RideMethodHelper().uploadDrugAnalysis(
          dragAnalysisDate: rideDragAnalysisExpireDateController.text,
          dragAnalysis: state.personalDrugAnalysisPicture!,
          onSuccessUploaded: (bool isSuccess) async {
            if (isSuccess) {
              driverInfo?.isUploadDrugAnalysis = true;
              emit(state.copyWith(
                  driverInfo: driverInfo, status: RideStates.success));
              if (state.driverInfo?.isUploadDriverLicense == true &&
                  state.driverInfo?.isUploadDriverId == true &&
                  state.driverInfo?.isUploadCarLicense == true &&
                  state.driverInfo?.isUploadConfirmIdentifier == true &&
                  state.driverInfo?.isUploadDriverImage == true &&
                  state.driverInfo?.isUploadCarImage == true) {
                await fetchRideDriverInfo(context, false);
                showSuccessMessage(
                    context,
                    context.isArabic
                        ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                        : "Successfully uploaded images, please wait for the approval of all data.");
              }
              context.pop();
              context.pop();
              emit(state.copyWith(status: RideStates.success));
            } else {
              context.pop();
              showErrorMessage(
                  context,
                  context.isArabic
                      ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                      : 'An error occurred while uploading images. Please try again.');
            }
          });
      emit(state.copyWith(
          status: RideStates.success, isUploadDrugAnalysis: true));
    }
  }

  onSubmitUploadingCriminalRecord(BuildContext context) async {
    if (criminalRecordFormKey.currentState!.validate()) {
      emit(state.copyWith(status: RideStates.loadingSubmit));
      DriverInfoEntity? driverInfo = state.driverInfo;
      showLoadingDialog(context, canPop: false);
      await RideMethodHelper().uploadCriminalRecord(
          criminalRecordDate: rideCriminalRecordExpireDateController.text,
          criminalRecordImage: state.personalCriminalRecordPicture!,
          onSuccessUploaded: (bool isSuccess) async {
            if (isSuccess) {
              driverInfo?.isUploadCriminalRecord = true;
              emit(state.copyWith(
                  driverInfo: driverInfo, status: RideStates.success));
              if (state.driverInfo?.isUploadDriverLicense == true &&
                  state.driverInfo?.isUploadDriverId == true &&
                  state.driverInfo?.isUploadCarLicense == true &&
                  state.driverInfo?.isUploadConfirmIdentifier == true &&
                  state.driverInfo?.isUploadDriverImage == true &&
                  state.driverInfo?.isUploadCarImage == true) {
                await fetchRideDriverInfo(context, false);
                showSuccessMessage(
                    context,
                    context.isArabic
                        ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                        : "Successfully uploaded images, please wait for the approval of all data.");
              }
              context.pop();
              context.pop();
              emit(state.copyWith(status: RideStates.success));
            } else {
              context.pop();
              showErrorMessage(
                  context,
                  context.isArabic
                      ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                      : 'An error occurred while uploading images. Please try again.');
            }
          });
      emit(state.copyWith(
          status: RideStates.success, isUploadCriminalRecord: true));
    }
  }

  onSubmitUploadingTechnicalExamination(BuildContext context) async {
    if (terminalExaminationFormKey.currentState!.validate()) {
      emit(state.copyWith(status: RideStates.loadingSubmit));
      DriverInfoEntity? driverInfo = state.driverInfo;
      showLoadingDialog(context, canPop: false);
      await RideMethodHelper().uploadTechnicalExamination(
          technicalExaminationDate:
              rideTechnicalExaminationExpireDateController.text,
          technicalExaminationImage: state.personalTechnicalExaminationPicture!,
          onSuccessUploaded: (bool isSuccess) async {
            if (isSuccess) {
              driverInfo?.isUploadTechnicalExamination = true;
              emit(state.copyWith(
                  driverInfo: driverInfo, status: RideStates.success));
              if (state.driverInfo?.isUploadDriverLicense == true &&
                  state.driverInfo?.isUploadDriverId == true &&
                  state.driverInfo?.isUploadCarLicense == true &&
                  state.driverInfo?.isUploadConfirmIdentifier == true &&
                  state.driverInfo?.isUploadDriverImage == true &&
                  state.driverInfo?.isUploadCarImage == true) {
                await fetchRideDriverInfo(context, false);
                showSuccessMessage(
                    context,
                    context.isArabic
                        ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                        : "Successfully uploaded images, please wait for the approval of all data.");
              }
              context.pop();
              context.pop();
              emit(state.copyWith(status: RideStates.success));
            } else {
              context.pop();
              showErrorMessage(
                  context,
                  context.isArabic
                      ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                      : 'An error occurred while uploading images. Please try again.');
            }
          });
      emit(state.copyWith(
          status: RideStates.success, isUploadTechnicalExamination: true));
    }
  }

  onSaveRegisterData(BuildContext context) async {
    RegisterRideSpecialEntity params = RegisterRideSpecialEntity(
        driverFirstName: rideNameController.text,
        driverLastName: rideSurNameController.text,
        airConditioner: state.hasAirCondition ?? false,
        birthday: rideDateOfBirthController.text,
        city: state.selectedGov ?? '',
        driverLicenseNumber: ridePersonalDocLicenseNumController.text,
        idNumber: ridePersonalDocIdNumController.text,
        phone: ridePhoneNumberController.text,
        plateInfo: rideVehiclePlateNumberController.text,
        pricingPerKm: ridePricingPerKmController.text,
        smoker: state.isSmoking ?? false,
        vehicleBrand: state.selectedBrand ?? '',
        vehicleColor: state.selectedColors?.id ?? '',
        vehicleModel: state.selectedModel ?? '',
        vehicleYear: rideVehicleProductionYearController.text,
        workingType: state.selectedPlan ?? '',
        personalPicture: state.personalPicture?.path,
        isShipping: state.isShipping,
        subcategoryIds: (state.rideSubCategories ?? [])
            .where((e) => e.isEnabled == true)
            .toList()
            .map((e) => e.subCategoryId)
            .toList());
    await Storage().saveDriverEntity(params);
    await Storage().removeDriverNoSocketEntity();
    context.go(Routes.RIDE_HOME);
  }

  onSetSavedData() async {
    RegisterRideSpecialEntity? data = await Storage().getDriverEntity();
    print("data?.personalPicture${data?.personalPicture}");
    rideNameController.text = data?.driverFirstName ?? '';
    rideSurNameController.text = data?.driverLastName ?? '';
    rideDateOfBirthController.text = data?.birthday ?? '';
    ridePersonalDocLicenseNumController.text = data?.driverLicenseNumber ?? '';
    ridePersonalDocIdNumController.text = data?.idNumber ?? '';
    rideVehiclePlateNumberController.text = data?.plateInfo ?? '';
    ridePhoneNumberController.text = data?.phone ?? '';
    ridePricingPerKmController.text = data?.pricingPerKm ?? '';
    rideVehicleProductionYearController.text = data?.vehicleYear ?? '';
    emit(state.copyWith(
      hasAirCondition: data?.airConditioner,
      selectedGov: data?.city,
      isSmoking: data?.smoker,
      selectedBrand: data?.vehicleBrand,
      selectedColors:
          (state.colors != null || (state.colors?.isNotEmpty ?? false))
              ? state.colors?.firstWhere((e) => e.id == data?.vehicleColor)
              : null,
      selectedModel: data?.vehicleModel,
      selectedPlan: data?.workingType,
      personalPicture: XFile(data?.personalPicture ?? ''),
      savedRideSubCategories: data?.subcategoryIds ?? [],
    ));
  }

  //model brand color city plan

  bool isLoadingSubmitRegister = false;

  onRegister(BuildContext context) async {
    DriverInfoEntity? driverInfo = state.driverInfo;
    if (state.personalPicture == null) {
      showErrorMessage(context, "Please select profile picture");
      return;
    }
    if (formKey.currentState!.validate()) {
      if (state.selectedBrand == null ||
          (state.selectedBrand?.isEmpty ?? false)) {
        showErrorMessage(context, "Please select vehicle brand");
        return;
      }

      if (state.selectedModel == null ||
          (state.selectedModel?.isEmpty ?? false)) {
        showErrorMessage(context, "Please select vehicle Model");
        return;
      }
      if (state.selectedColors == null ||
          (state.selectedColors?.id.isEmpty ?? false)) {
        showErrorMessage(context, "Please select color");
        return;
      }

      if (state.selectedPlan == null ||
          (state.selectedPlan?.isEmpty ?? false)) {
        showErrorMessage(context, "Please select plan");
        return;
      }
      if (state.selectedGov == null || (state.selectedGov?.isEmpty ?? false)) {
        showErrorMessage(context, "Please select city");
        return;
      }

      isLoadingSubmitRegister = true;
      emit(state.copyWith(status: RideStates.loadingSubmit));

      RegisterRideSpecialEntity params = RegisterRideSpecialEntity(
          driverFirstName: rideNameController.text,
          driverLastName: rideSurNameController.text,
          airConditioner: state.hasAirCondition ?? false,
          birthday: rideDateOfBirthController.text,
          city: state.selectedGov ?? '',
          driverLicenseNumber: ridePersonalDocLicenseNumController.text,
          idNumber: ridePersonalDocIdNumController.text,
          phone: ridePhoneNumberController.text,
          plateInfo: rideVehiclePlateNumberController.text,
          pricingPerKm: ridePricingPerKmController.text,
          smoker: state.isSmoking ?? false,
          vehicleBrand: state.selectedBrand ?? '',
          vehicleColor: state.selectedColors?.id ?? '',
          vehicleModel: state.selectedModel ?? '',
          vehicleYear: rideVehicleProductionYearController.text,
          workingType: state.selectedPlan ?? '',
          subcategoryIds: (state.rideSubCategories ?? [])
              .where((e) => e.isEnabled == true)
              .toList()
              .map((e) => e.subCategoryId)
              .toList());
      final Either<Failure, bool> result =
          await registerRideSpecialUseCase(params);

      result.fold(
        (failure) {
          showErrorMessage(context, getFailureMessage(failure, context));
          isLoadingSubmitRegister = false;
          emit(state.copyWith(status: RideStates.error, failure: failure));
        },
        (data) async {
          await RideMethodHelper().uploadDriverImage(
              driverImage: state.personalPicture!,
              onSuccessUploaded: (bool isSuccess) async {
                if (isSuccess) {
                  driverInfo?.isUploadDriverImage = true;
                  emit(state.copyWith(
                      driverInfo: driverInfo, status: RideStates.success));
                  if (state.driverInfo?.isUploadDriverLicense == true &&
                      state.driverInfo?.isUploadDriverId == true &&
                      state.driverInfo?.isUploadCarLicense == true &&
                      state.driverInfo?.isUploadConfirmIdentifier == true &&
                      state.driverInfo?.isUploadDriverImage == true &&
                      state.driverInfo?.isUploadCarImage == true) {
                    await fetchRideDriverInfo(context, false);
                    showSuccessMessage(
                        context,
                        context.isArabic
                            ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                            : "Successfully uploaded images, please wait for the approval of all data.");
                  }
                  context.pop();
                  context.pop();
                  emit(state.copyWith(status: RideStates.success));
                } else {
                  context.pop();
                  showErrorMessage(
                      context,
                      context.isArabic
                          ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                          : 'An error occurred while uploading images. Please try again.');
                }
              });
          await fetchRideDriverInfo(context, false);
          await fetchRideDriverPictureOptional(context);
          showSuccessMessage(
              context,
              context.isArabic
                  ? "تم التسجيل بنجاح"
                  : "Registered successfully");
          context.pushReplacement(Routes.UploadRiderImages);
          isLoadingSubmitRegister = false;
          emit(state.copyWith(status: RideStates.success));
        },
      );
    }
  }

  onNoSocketRegister(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      isLoadingSubmitRegister = true;
      emit(state.copyWith(status: RideStates.loadingSubmit));

      RegisterRideNotSpecialEntity params = RegisterRideNotSpecialEntity(
          driverFirstName: rideNameController.text,
          driverLastName: rideSurNameController.text,
          birthday: rideDateOfBirthController.text,
          driverLicenseNumber: ridePersonalDocLicenseNumController.text,
          idNumber: ridePersonalDocIdNumController.text,
          phone: ridePhoneNumberController.text,
          plateInfo: rideVehiclePlateNumberController.text,
          // subcategoryId: "62c8baa08e28a58a3edf57ed",
          subcategoryId: (state.rideSubCategories ?? [])
              .firstWhere((e) => e.isEnabled == true)
              .subCategoryId,
          carModel: rideCarModelController.text);
      final Either<Failure, bool> result =
          await registerRideNotSpecialUseCase(params);

      result.fold(
        (failure) {
          showErrorMessage(context, getFailureMessage(failure, context));
          isLoadingSubmitRegister = false;
          emit(state.copyWith(status: RideStates.error, failure: failure));
        },
        (data) async {
          isLoadingSubmitRegister = false;
          await fetchRideDriverInfo(context, false);
          emit(state.copyWith(status: RideStates.success));
          showSuccessMessage(
              context,
              context.isArabic
                  ? "تم التسجيل بنجاح"
                  : "Registered successfully");
          context.pushReplacement(Routes.completeRegisterScreen);
          // context.pushReplacement(Routes.UploadRiderImages);
        },
      );
    }
  }

  onLoadingRegister(BuildContext context) async {
    context.pushReplacement(Routes.completeRegisterScreen);

    if (formKey.currentState!.validate()) {
      isLoadingSubmitRegister = true;
      emit(state.copyWith(status: RideStates.loadingSubmit));

      LoadingRegisterEntity params = LoadingRegisterEntity(
          idNumber: ridePersonalDocIdNumController.text,
          phone: ridePhoneNumberController.text,
          plateInformation: rideVehiclePlateNumberController.text,
          location: state.selectedGov ?? '',
          firstName: rideNameController.text,
          lastName: rideSurNameController.text,
          categoryId: (state.shippingSubCategories ?? [])
              .firstWhere((e) => e.isEnabled == true)
              .subCategoryId,
          carModel: rideCarModelController.text);
      final Either<Failure, bool> result = await loadingRegisterUseCase(params);

      result.fold(
        (failure) {
          showErrorMessage(context, getFailureMessage(failure, context));
          isLoadingSubmitRegister = false;
          emit(state.copyWith(status: RideStates.error, failure: failure));
        },
        (data) async {
          isLoadingSubmitRegister = false;
          await fetchLoaderInfo(context, false);
          emit(state.copyWith(status: RideStates.success));
          showSuccessMessage(
              context,
              context.isArabic
                  ? "تم التسجيل بنجاح"
                  : "Registered successfully");
          context.pushReplacement(Routes.completeRegisterScreen);
        },
      );
    }
  }

  uploadRecord(String tripId, String mediaId) async {
    final Either<Failure, bool> result =
        await recordingTripUseCase(RecordingTripUseCaseParams(tripId, mediaId));

    result.fold(
      (failure) {
        isLoadingSubmitRegister = false;
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (data) async {
        emit(state.copyWith(status: RideStates.success));
      },
    );
  }

  ///record trip
  final record = AudioRecorder();

  // Start recording
  Future<void> startRecord() async {
    log('startRecorddd${await record.hasPermission()}');
    try {
      if (await record.hasPermission()) {
        log('record.hasPermission');
        Directory tempDir = await getTemporaryDirectory();
        String tempPath =
            '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav';
        await record.start(const RecordConfig(),
          path: tempPath,
        );
        print("object");
      } else {
        throw Exception('Microphone permission not granted');
      }
    } catch (e) {
      log('Error starting record: $e');
    }
  }

  Future<String?> stopRecord(
      {required String subcategoryId, required String tripId}) async {
    try {
      log('stopRecord');
      String? path = await record.stop();
      await UploadRecord().mediaUrl(
        tripId: tripId,
        path: path ?? "",
        subcategoryId: subcategoryId,
        onSuccess: (String mediaId, String tripId) async {
          log("tripId$tripId");
          log("mediaId$mediaId");
          await uploadRecord(tripId, mediaId);
        },
      );
      // await recordingTripUseCase(RecordingTripUseCaseParams( tripId,  'mediaId'));
      return path;
    } catch (e) {
      log('Error stopping record: $e');
      return null;
    }
  }
  Future<void> emitDriverLocation(BuildContext context) async {
    final result = await updateSocketLocationUseCase(
        UpdateSocketLocationParams(latitude: 31.241106, longitude: 30.047558));
    result
        .fold((l) => emit(state.copyWith(failure: l, status: RideStates.error)),
            (r) async {
      if (r == true) {
        showSuccessMessage(context, "Location Updated Successfully");
      }
    });
  }

  void removeRideOfferFromRideOffers(RideOfferEntity offer) {
    offer.isExpired = true;
    emit(state.copyWith(status: RideStates.success));
  }

  void listenToRideOffers() {
    listenToRideOffersUseCase((offer) {
      final updatedOffers = List<RideOfferEntity>.from(state.rideOffers)
        ..add(offer);

      emit(state.copyWith(
          status: RideStates.success, rideOffers: updatedOffers));
    });
  }

  @override
  Future<void> close() {
    SharedWebSocket.socket!.off(SocketIOListeners.rideSendOffer);
    return super.close();
  }
}
