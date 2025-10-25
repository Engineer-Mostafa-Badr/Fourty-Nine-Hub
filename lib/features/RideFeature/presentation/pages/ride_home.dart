import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:fourtyninehub/features/RideFeature/domain/usecases/make_loading_request_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/make_non_tracking_request_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/client_trips_cubit/client_trips_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/upload_rider_images.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/client_rate_driver_sheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/ride_mode_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/expired_trips_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/gmap_search_and_pick.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/history_trips_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_personal_more_info_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_status_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/running_trips_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/support_screen/support_ride_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/bottom_button_ride_status_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/bottom_card_request.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/bottom_sheet/custom_reserve_ride_bottomsheet.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/dialog_widget/show_custom_dialog_trip.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/driver_header_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/top_card_request.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/screen/custom_map.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/shared_web_socket.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/form/text_fields/default_text_form_field.dart';
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
import '../../../social_media/twitter/presentation/widgets/report_view.dart';
import '../../domain/entities/get_location_from_address_entity.dart';
import '../../domain/usecases/rating_driver_by_client.dart';
import '../controllers/cubits/car_location_cubit.dart';
import 'dashboards/widgets/build_safety_sheet.dart';
import 'widgets/add_stops_widget.dart';
import 'widgets/bottom_sheet/custom_bottom_sheet.dart';
import 'widgets/driver_profile_modal.dart';
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

  final MapController _mapController = MapController();

  final GlobalKey<FormState> _phoneNumberFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _partialPaymentFormKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  bool _isPhoneNumberValidated = false;
  final TextEditingController _descriptionController = TextEditingController();

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
    SharedWebSocket.socket!.off('RIDE:UPDATED_OFFER');
    SharedWebSocket.socket!.off('RIDE:DRIVER_GO_TO_CLIENT_TO_START_TRIP');
    SharedWebSocket.socket!.off('RIDE:DRIVER_HAS_ARRIVED_AT_CLIENT');
    SharedWebSocket.socket!.off('RIDE:DRIVER_STARTED_TRIP');
    SharedWebSocket.socket!.off('RIDE:TRIP_CANCELLED_BY_DRIVER');
    SharedWebSocket.socket!.off('RIDE:DRIVER_COMPLETED_TRIP');

    SharedWebSocket.socket!.off('RIDE:FINALIZE_DRIVER_TRIP_PRE_START');
    SharedWebSocket.socket!.off('RIDE:ACCEPTED_AUTO_TRIP');
    SharedWebSocket.socket!.off('RIDE:VIEWER_TRIPS');
    SharedWebSocket.socket!.off('RIDE:TRIP_LOCATION_UPDATED');
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
                color: context.isDarkMode
                    ? AppColors.QUANTITY_COLOR
                    : AppColors.whiteColor,
              ),
              child: BottomCardRequest(
                driversCount: serviceLocator<RideCubit>().tripViewers.length,
                rideCubit: serviceLocator<RideCubit>(),
                onCancel: () async {
                  ManageVibration.vibrate();
                  await serviceLocator<RideCubit>().cancelPendingTripByClient(
                    tripId:
                        serviceLocator<RideCubit>().state.requestedTrip?.id ??
                            '',
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
                  ManageVibration.vibrate();
                  await serviceLocator<RideCubit>()
                      .acceptOfferByClient(offerId: offerEntity.offerId);
                },
              );
            },
          ),
        );
      },
    );
  }

  showCancelTripDialog({
    required BuildContext context,
  }) {
    showCustomDialogTrip(
        context,
        BlocProvider.value(
          value: serviceLocator<RideCubit>(),
          child: BlocBuilder<RideCubit, RideState>(builder: (context, state) {
            var cubit = serviceLocator<RideCubit>();
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LocaleKeys.alert.localize,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                    context.isArabic
                        ? 'لماذا تريد الغاء الرحلة'
                        : 'Why do you want to cancel ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: FontSize.s16,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                    )),
                const SizedBox(height: 20),
                ClickableWidget(
                  onTap: () {
                    ManageVibration.vibrate();
                    cubit.changeReasonSelection(isChangedMind: true);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: state.isChangedMindReason == true
                          ? Border.all(color: AppColors.SECONDARY_COLOR_DARK2)
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: Colors.black54),
                        SizedBox(width: 5),
                        Text(
                          context.isArabic
                              ? "لقد قمت بتغيير رأيي"
                              : "I changed my mind",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.requestedTrip?.status == TripState.goToClient.name)
                  if (state.requestedTrip?.driverIsArrivingIn != null)
                    if (DateTime.now().isAfter(state
                        .requestedTrip!.driverIsArrivingIn!
                        .add(Duration(minutes: 10))))
                      const SizedBox(height: 20),
                if (state.requestedTrip?.status == TripState.goToClient.name)
                  if (state.requestedTrip?.driverIsArrivingIn != null)
                    if (DateTime.now().isAfter(state
                        .requestedTrip!.driverIsArrivingIn!
                        .add(Duration(minutes: 10))))
                      ClickableWidget(
                        onTap: () {
                          ManageVibration.vibrate();
                          cubit.changeReasonSelection(isClientNotShown: true);
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: state.isClientNotShownReason == true
                                ? Border.all(
                                    color: AppColors.SECONDARY_COLOR_DARK2)
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info_outline, color: Colors.black54),
                              SizedBox(width: 5),
                              Text(
                                context.isArabic
                                    ? "لم يظهر السائق"
                                    : "The Driver did not show up",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                ClickableWidget(
                  onTap: () {
                    ManageVibration.vibrate();
                    cubit.changeReasonSelection(isOther: true);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: state.isOtherReason == true
                            ? Colors.transparent
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: Colors.black54),
                        SizedBox(width: 5),
                        Text(
                          context.isArabic ? "أخري" : "Other",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.isOtherReason == true) ...[
                  const SizedBox(height: 20),
                  DefaultTextFormField(
                    currentController: cubit.reasonController,
                    fillColor: context.isDarkMode
                        ? AppColors.GREY_DARK_COLOR
                        : AppColors.GREYBG,
                    borderColor: Colors.transparent,
                    hint: context.isArabic
                        ? 'اكتب السبب هنا'
                        : 'Write the reason here',
                    // label: LocaleKeys.firstName.localize,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return LocaleKeys.required.localize;
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton(
                        width: context.screenWidth / 3.4,
                        label: context.isArabic ? 'الغاء' : 'Close',
                        backColor: AppColors.SECONDARY_COLOR_DARK2,
                        onPressed: () {
                          ManageVibration.vibrate();
                          context.pop();
                          // cubit
                        }),
                    const SizedBox(width: 16),
                    AppButton(
                        width: context.screenWidth / 3.4,
                        label: context.isArabic ? 'تأكيد' : 'Confirm',
                        backColor: AppColors.PRIMARY_COLOR,
                        onPressed: () {
                          ManageVibration.vibrate();
                          context.pop();
                          if (state.isOtherReason == true ||
                              state.isChangedMindReason == true ||
                              state.isClientNotShownReason == true) {
                            cubit.cancleNonPendingTripByClient(
                              context: context,
                              tripId: state.requestedTrip?.id ?? '',
                              note: state.isOtherReason == true
                                  ? cubit.reasonController.text
                                  : state.isClientNotShownReason == true
                                      ? 'client-no-show'
                                      : state.isChangedMindReason == true
                                          ? 'change-my-mind'
                                          : '',
                              reasonId: state.isOtherReason == true
                                  ? '6693d4723aa4a25077cdbc7b'
                                  : state.isClientNotShownReason == true
                                      ? '688a24b8c2885aca461790bc'
                                      : state.isChangedMindReason == true
                                          ? '665ef7118e67e46ce6498fef'
                                          : '',
                            );
                          } else {
                            showErrorMessage(
                                context,
                                context.isArabic
                                    ? "يرجى تحديد سبب"
                                    : 'Please select a reason');
                          }
                        }),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
        ));
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
                  color: context.isDarkMode
                      ? AppColors.QUANTITY_COLOR
                      : Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
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
                      BlocBuilder<RideCubit, RideState>(
                          builder: (context, state) {
                        print(
                            "state.requestedTrip?.status ${state.requestedTrip?.status}");
                        return DriverHeaderWidget(
                          carModel: context.isArabic
                              ? state.requestedTrip?.vehicleModelAr
                              : state.requestedTrip?.vehicleModelEn,
                          carColor: state.requestedTrip?.vehicleColor,
                          rideStatusWidget: state.requestedTrip?.status ==
                                  TripState.started.name
                              ? TripDurationCountdown(
                                  key: ValueKey(
                                      "${state.requestedTrip?.driverIsArrivingIn}_${state.requestedTrip?.status}"),
                                  tripDurationSeconds:
                                      state.requestedTrip?.duration?.toDouble(),
                                  isArabic: context.isArabic,
                                )
                              : (state.requestedTrip?.status ==
                                          TripState.inLocation.name ||
                                      state.requestedTrip?.status ==
                                          TripState.goToClient.name)
                                  ? DriverArrivalCountdown(
                                      key: ValueKey(
                                          "${state.requestedTrip?.driverIsArrivingIn}_${state.requestedTrip?.status}"),
                                      arrivalDateTime: state
                                          .requestedTrip?.driverIsArrivingIn,
                                      isCountdown:
                                          state.requestedTrip?.status ==
                                              TripState.goToClient.name,
                                      isInLocation:
                                          state.requestedTrip?.status ==
                                              TripState.inLocation.name,
                                    )
                                  : const SizedBox.shrink(),
                          carImageUrl: state.requestedTrip?.vehiclePicture ??
                              "https://www.hyundai.com/content/dam/hyundai/in/en/data/find-a-car/i20/Highlights/pc/i20_Modelpc.png",
                          carName: context.isArabic
                              ? state.requestedTrip?.vehicleBrandAr
                              : state.requestedTrip?.vehicleBrandEn,
                          carNumber:
                              state.requestedTrip?.vehiclePlateNumber ?? "",
                        );
                      }),
                      if (state.requestedTrip?.status !=
                          TripState.inLocation.name)
                        const Divider(height: 1),
                      if (state.requestedTrip?.status ==
                          TripState.inLocation.name)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Container(
                              decoration: BoxDecoration(
                                color: context.isDarkMode
                                    ? AppColors.GREY_DARK_COLOR
                                    : AppColors.GREY_NORMAL_COLOR
                                        .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    BlocBuilder<RideCubit, RideState>(
                                        builder: (context, state) {
                                      return CountdownTimerWidget(
                                        isActive: state.requestedTrip?.status ==
                                            TripState.inLocation.name,
                                        isArabic: context.isArabic,
                                      );
                                    }),
                                    const SizedBox(height: 16),
                                    GestureDetector(
                                      onTap: () async {
                                        ManageVibration.vibrate();
                                        await serviceLocator<RideCubit>()
                                            .sendIamOkMessage(context);
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        decoration: BoxDecoration(
                                          color: AppColors.PRIMARY_COLOR,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              context.isArabic
                                                  ? "حسنا، أنا قادم"
                                                  : "Ok, I'm coming",
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
                        driverImageUrl:
                            state.requestedTrip?.driverProfilePicture,
                        driverRating: state.requestedTrip?.driverRating,
                        driverName: state.requestedTrip?.driverFirstName ?? "",
                        onDriverImageClick: () {
                          if (state.requestedTrip?.driverUserId != null) {
                            showDriverProfileSheet(context,
                                driverId:
                                    state.requestedTrip?.driverUserId ?? "");
                          }
                        },
                        onContactDriver: () {
                          ManageVibration.vibrate();
                          // context.push(Routes.ratingClientScreen);
                        },
                        onSafety: () {
                          ManageVibration.vibrate();
                          // context.push(Routes.rideArrivedScreen);
                          serviceLocator<RideCubit>()
                              .changeTripStatus(tripState: TripState.support);
                        },
                        is_show_message: true,
                        onMessage: () {
                          ManageVibration.vibrate();
                        },
                      ),
                      // const FeedbackWidget(),
                      // const Divider(height: 2),
                      GestureDetector(
                        onTap: () {
                          ManageVibration.vibrate();
                          bottomSheet(
                              context: context,
                              widget: ReportView(
                                id: state.requestedTrip?.id ?? "",
                                categoryId:
                                    state.requestedTrip?.subCategoryId ?? "",
                              ));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: context.isDarkMode
                                  ? AppColors.GREY_DARK_COLOR
                                  : AppColors.GREY_NORMAL_COLOR
                                      .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: AppColors.PRIMARY_COLOR),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Center(
                                  child: Text(context.isArabic
                                      ? "الابلاغ عن السائق"
                                      : "Report Driver")),
                            )),
                      ),
                      BottomRideStatusWidget(
                        price: state.requestedTrip?.price?.toInt() ?? 0,
                        isStarted: state.requestedTrip?.status ==
                            TripState.started.name,
                        fromLocation:
                            state.requestedTrip?.from ?? 'أول العاشر من رمضان',
                        toLocation: state.requestedTrip?.to ??
                            'المنطقة الصناعية الثالثة العاشر من رمضان (10th of Ramadan City 1) العالمية',
                        onGoogleMap: () {
                          ManageVibration.vibrate();
                        },
                        showCancelButton: (state.requestedTrip?.status ==
                                TripState.accepted.name ||
                            state.requestedTrip?.status ==
                                TripState.inLocation.name ||
                            state.requestedTrip?.status ==
                                TripState.goToClient.name),
                        showOTP: state.requestedTrip?.status ==
                            TripState.inLocation.name,
                        onPartialPayment: () {
                          ManageVibration.vibrate();
                          showModalBottomSheet<bool>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                    color: context.isDarkMode
                                        ? AppColors.QUANTITY_COLOR
                                        : AppColors.whiteColor,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20.0)),
                                  ),
                                  child: Form(
                                    key:
                                        _partialPaymentFormKey, // Use the class-level key
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const SizedBox(width: 24),
                                            Text(
                                              context.isArabic
                                                  ? "دفع جزئي"
                                                  : "Partial Payment",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.close),
                                              onPressed: () {
                                                ManageVibration.vibrate();
                                                Navigator.of(context)
                                                    .pop(false);
                                              }, // Pass false if dismissed without validation
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.payments_outlined,
                                              color: Colors.green,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              context.isArabic
                                                  ? "بطاقة بنكية"
                                                  : "Visa",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Spacer(),
                                            SizedBox(
                                              width: 200,
                                              height: 50,
                                              child: TextFormField(
                                                controller: _controller,
                                                autofocus: true,
                                                cursorColor: context.isDarkMode
                                                    ? Colors.white
                                                    : AppColors.PRIMARY_COLOR,
                                                cursorHeight: 30,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  TextInputFormatter
                                                      .withFunction(
                                                          (oldValue, newValue) {
                                                    if (newValue.text.isEmpty)
                                                      return newValue;
                                                    if (newValue.text == '0')
                                                      return newValue;
                                                    if (newValue.text
                                                        .startsWith('0')) {
                                                      return oldValue;
                                                    }
                                                    return newValue;
                                                  }),
                                                ],
                                                style: TextStyle(
                                                  color: context.isDarkMode
                                                      ? Colors.white
                                                      : AppColors.PRIMARY_COLOR,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 30,
                                                ),
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .never,
                                                  hintText: context.isArabic
                                                      ? 'ج.م'
                                                      : 'EGP',
                                                  hintStyle: const TextStyle(
                                                    color: Color(0xff96979B),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 30,
                                                  ),
                                                  fillColor: context.isDarkMode
                                                      ? AppColors.QUANTITY_COLOR
                                                      : Colors.white,
                                                  filled: true,
                                                  border:
                                                      const UnderlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  focusedBorder:
                                                      const UnderlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  enabledBorder:
                                                      const UnderlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  errorBorder:
                                                      const UnderlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  disabledBorder:
                                                      const UnderlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  focusedErrorBorder:
                                                      const UnderlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return context.isArabic
                                                        ? 'يرجى إدخال مبلغ'
                                                        : 'Please enter an amount';
                                                  }

                                                  final int? amount =
                                                      int.tryParse(value);

                                                  if (amount == null ||
                                                      amount < 100) {
                                                    return context.isArabic
                                                        ? 'يجب أن يكون المبلغ اكثر من ${FormatNumbers().convertNumberToLocalizedString('100', isArabic: context.isArabic)}'
                                                        : 'Amount must be greater than ${FormatNumbers().convertNumberToLocalizedString('100', isArabic: context.isArabic)}';
                                                  }

                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              ManageVibration.vibrate();
                                              if (_partialPaymentFormKey
                                                  .currentState!
                                                  .validate()) {
                                                context.pop();
                                                await serviceLocator<
                                                        RideCubit>()
                                                    .partialPayment(
                                                        tripId: state
                                                                .requestedTrip
                                                                ?.id ??
                                                            '',
                                                        amount: double.parse(
                                                            _controller.text),
                                                        context: context,
                                                        subCategoryId: state
                                                                .requestedTrip
                                                                ?.subCategoryId ??
                                                            '');
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.PRIMARY_COLOR,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              context.isArabic
                                                  ? "تطبيق"
                                                  : "Apply",
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
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
                        },
                        onStartRecord: () {
                          ManageVibration.vibrate();
                          serviceLocator<RideCubit>().startRecord();
                        },
                        onStopRecord: () {
                          ManageVibration.vibrate();
                          serviceLocator<RideCubit>().stopRecord(
                              context: context,
                              subcategoryId:
                                  state.requestedTrip?.subCategoryId ?? '',
                              tripId: state.requestedTrip?.id ?? '');
                        },
                        onCallEmergency: () async {
                          ManageVibration.vibrate();
                          final Uri launchUri = Uri(scheme: 'tel', path: '122');
                          if (await canLaunchUrl(launchUri)) {
                            await launchUrl(launchUri);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.isArabic
                                      ? 'لا يمكن الاتصال بالهاتف'
                                      : 'Could not launch phone dialer.',
                                ),
                              ),
                            );
                          }
                        },
                        onCancelRide: () {
                          ManageVibration.vibrate();
                          showCancelTripDialog(
                            context: context,
                          );
                        },
                        isRecording: state.requestedTrip?.status ==
                            TripState.started.name,
                        audioDuration: '',
                        onMicTap: () {
                          ManageVibration.vibrate();
                        },
                        paymentMethod:
                            state.requestedTrip?.paymentMethod ?? "cash",
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

  void _scrollRight(ScrollController controller) {
    if (controller.hasClients) {
      controller.animateTo(
        controller.offset + 200,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToStart(ScrollController controller) {
    if (controller.hasClients) {
      controller.animateTo(
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
          dev.log("state.requestedTrip?.status ${state.requestedTrip?.status}");
          var cubit = serviceLocator<RideCubit>();

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (c, v) async {
              if (cubit.selectedCategoryIsSocket) {
                context.go(Routes.HOME);
              } else {
                await cubit.returnToSocket();
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: cubit.loadingHomeData == true
                  ? const SizedBox()
                  : Form(
                      key: _formKey,
                      child: SafeArea(
                        child: SharedScaffold(
                          mainCategoryId: 2,
                          onBackPressed: () async {
                            if (cubit.selectedCategoryIsSocket) {
                              context.go(Routes.HOME);
                            } else {
                              await cubit.returnToSocket();
                            }
                          },
                          body: NestedAppbar(
                            scrollController: _scrollController,
                            appBars: const [],
                            body: Stack(
                              children: [
                                serviceLocator<RideCubit>()
                                        .selectedCategoryIsSocket
                                    ? _buildTopImage()
                                    : const SizedBox.shrink(),
                                state.requestedTrip == null
                                    ? _buildBottomSheet()
                                    : state.requestedTrip!.status ==
                                                TripState.completed.name ||
                                            state.requestedTrip!.status ==
                                                TripState.canceled.name ||
                                            state.requestedTrip!.status ==
                                                TripState
                                                    .cancelledByClient.name ||
                                            state.requestedTrip!.status ==
                                                TripState.cancelledByDriver.name
                                        ? _buildBottomSheet()
                                        : const SizedBox.shrink(),
                                !serviceLocator<RideCubit>()
                                        .selectedCategoryIsSocket
                                    ? const SizedBox()
                                    : state.requestedTrip == null
                                        ? const SizedBox()
                                        : state.requestedTrip!.status ==
                                                TripState.pending.name
                                            ? buildDriversOffers(context)
                                            : const SizedBox(),
                                !serviceLocator<RideCubit>()
                                        .selectedCategoryIsSocket
                                    ? const SizedBox()
                                    : state.requestedTrip == null
                                        ? _buildBottomSheet()
                                        : state.requestedTrip!.status ==
                                                    TripState.completed.name ||
                                                state.requestedTrip!.status ==
                                                    TripState.canceled.name ||
                                                state.requestedTrip!.status ==
                                                    TripState
                                                        .cancelledByClient.name ||
                                                state.requestedTrip!.status ==
                                                    TripState
                                                        .cancelledByDriver.name
                                            ? _buildBottomSheet()
                                            : state.requestedTrip!.status ==
                                                    TripState.pending.name
                                                ? buildPendingSheet()
                                                : state.requestedTrip!.status ==
                                                            TripState.accepted
                                                                .name ||
                                                        state.requestedTrip!.status ==
                                                            TripState.goToClient
                                                                .name ||
                                                        state.requestedTrip!.status ==
                                                            TripState.inLocation
                                                                .name ||
                                                        state.requestedTrip!
                                                                .status ==
                                                            TripState
                                                                .started.name
                                                    ? acceptedTripButtonSheet()
                                                    : state.requestedTrip!.status ==
                                                            TripState
                                                                .ratingSheet
                                                                .name
                                                        ? BuildClientRateDriverSheet(
                                                            onPressed: (String
                                                                    message,
                                                                double
                                                                    rate) async {
                                                              ManageVibration
                                                                  .vibrate();
                                                              await serviceLocator<
                                                                      RideCubit>()
                                                                  .ratingDriverByClient(
                                                                context,
                                                                RatingDriverByClientUseCaseParams(
                                                                  tripId: state
                                                                      .requestedTrip!
                                                                      .id!,
                                                                  ratingValue:
                                                                      rate.toInt(),
                                                                  comment:
                                                                      message,
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        : state.requestedTrip!
                                                                    .status ==
                                                                TripState
                                                                    .support
                                                                    .name
                                                            ? BuildSafetySheet(
                                                                params: SupportRideParams(
                                                                    tripId: state
                                                                            .requestedTrip
                                                                            ?.id ??
                                                                        '',
                                                                    tripType:
                                                                        'tracing',
                                                                    userType:
                                                                        'client',
                                                                    driverId: state
                                                                            .requestedTrip
                                                                            ?.driverId ??
                                                                        '',
                                                                    clientId: UserCubit
                                                                            .to
                                                                            .state
                                                                            .data
                                                                            ?.id ??
                                                                        ''),
                                                                onClose: () {
                                                                  ManageVibration
                                                                      .vibrate();
                                                                  serviceLocator<
                                                                          RideCubit>()
                                                                      .closeSafetySheet();
                                                                },
                                                                supportRideScreen:
                                                                    () {
                                                                  ManageVibration
                                                                      .vibrate();
                                                                  context.push(
                                                                      Routes
                                                                          .supportRideScreen,
                                                                      extra: SupportRideParams(
                                                                          tripId: state.requestedTrip?.id ??
                                                                              '',
                                                                          tripType:
                                                                              'tracing',
                                                                          userType:
                                                                              'client',
                                                                          driverId: state.requestedTrip?.driverId ??
                                                                              '',
                                                                          clientId:
                                                                              UserCubit.to.state.data?.id ?? ''));
                                                                },
                                                                emergencyContactsScreen:
                                                                    () {
                                                                  ManageVibration
                                                                      .vibrate();
                                                                  context.push(
                                                                      Routes
                                                                          .emergencyContactsScreen);
                                                                },
                                                                rideFindingScreen:
                                                                    () async {
                                                                  ManageVibration
                                                                      .vibrate();
                                                                  final Uri
                                                                      launchUri =
                                                                      Uri(
                                                                          scheme:
                                                                              'tel',
                                                                          path:
                                                                              '122');
                                                                  if (await canLaunchUrl(
                                                                      launchUri)) {
                                                                    await launchUrl(
                                                                        launchUri);
                                                                  } else {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                            Text(
                                                                          context.isArabic
                                                                              ? 'لا يمكن الاتصال بالهاتف'
                                                                              : 'Could not launch phone dialer.',
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              )
                                                            : const SizedBox(),
                                serviceLocator<RideCubit>()
                                            .selectedCategoryIsSocket &&
                                        (state.requestedTrip == null ||
                                            state.requestedTrip?.status ==
                                                TripState.completed.name ||
                                            state.requestedTrip?.status ==
                                                TripState.canceled.name ||
                                            state.requestedTrip?.status ==
                                                TripState
                                                    .cancelledByClient.name ||
                                            state.requestedTrip?.status ==
                                                TripState
                                                    .cancelledByDriver.name)
                                    ? cubit.state.rideExpectedPrice == null
                                        ? _carTruckBtn(
                                            driverInfo: state.driverInfo,
                                            loadingInfo: state.loaderInfo,
                                            openDrawer: () {
                                              ManageVibration.vibrate();
                                              showModalBottomSheet(
                                                backgroundColor: context
                                                        .isDarkMode
                                                    ? AppColors.QUANTITY_COLOR
                                                    : Colors.white,
                                                context: context,
                                                builder: (context) =>
                                                    _buttonsWidget(
                                                  driverInfo: state.driverInfo,
                                                  loadingInfo: state.loaderInfo,
                                                ),
                                              );
                                            })
                                        : const SizedBox()
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
    List<gmap.LatLng> routePoints = [];

    List<gmap.LatLng> driverRoutePoints = [];

    try {
      if (state.requestedTrip == null ||
          state.requestedTrip!.status == TripState.canceled.name ||
          state.requestedTrip!.status == TripState.cancelledByClient.name ||
          state.requestedTrip!.status == TripState.cancelledByDriver.name ||
          state.requestedTrip!.status == TripState.completed.name) {
        routePoints =
            _convertPolylineToLatLng(state.rideExpectedPrice?.polyline ?? []);
      } else {
        routePoints =
            _convertPolylineToLatLng(state.requestedTrip?.polyline ?? []);
      }

      if (state.requestedTrip != null &&
          (state.requestedTrip!.status != TripState.goToClient.name ||
              state.requestedTrip!.status != TripState.accepted.name)) {
        driverRoutePoints =
            _convertPolylineToLatLng(state.requestedTrip?.driverPolyline ?? []);
      }
    } catch (e) {
      print('Error processing route points: $e');
      routePoints = [];
    }

    List<gmap.LatLng> clients = [];
    List<String> clientsAddress = [];

    try {
      if (state.wayPointOne != null &&
          state.wayPointOne!.lat != null &&
          state.wayPointOne!.lng != null) {
        clients
            .add(gmap.LatLng(state.wayPointOne!.lat!, state.wayPointOne!.lng!));
      }

      if (state.wayPointTwo != null &&
          state.wayPointTwo!.lat != null &&
          state.wayPointTwo!.lng != null) {
        clients
            .add(gmap.LatLng(state.wayPointTwo!.lat!, state.wayPointTwo!.lng!));
      }
    } catch (e) {
      print('Error processing client locations: $e');
    }

    if (state.wayPointOne?.address != null &&
        (state.wayPointOne?.address?.isNotEmpty ?? false)) {
      clientsAddress.add(state.wayPointOne!.address!);
    }

    if (state.wayPointTwo?.address != null &&
        (state.wayPointTwo?.address?.isNotEmpty ?? false)) {
      clientsAddress.add(state.wayPointTwo!.address!);
    }

    // Provide default values to prevent null issues
    final startLat = state.currentLocation?.lat ?? 30.033333;
    final startLng = state.currentLocation?.lng ?? 31.233334;
    final targetLat = state.toLocation?.lat ?? 30.043333;
    final targetLng = state.toLocation?.lng ?? 31.243334;
    String startAddress = state.currentLocation?.address ?? '';
    String toAddress = state.toLocation?.address ?? '';

    final driverStartLat = state.requestedTrip?.driverStartLat ?? 30.033333;
    final driverStartLng = state.requestedTrip?.driverStartLng ?? 31.233334;
    final driverTargetLat = state.requestedTrip?.driverTargetLat ?? 30.043333;
    final driverTargetLng = state.requestedTrip?.driverTargetLng ?? 31.243334;

    bool isBeforeRequest = state.requestedTrip == null ||
        state.requestedTrip!.status == TripState.canceled.name ||
        state.requestedTrip!.status == TripState.cancelledByClient.name ||
        state.requestedTrip!.status == TripState.cancelledByDriver.name ||
        state.requestedTrip!.status == TripState.completed.name;
    print("state.requestedTrip ${state.requestedTrip?.status}");
    print("state.driverLocation != null ${state.driverLocation != null}");

    dev.log('driverRoutePoints: $driverRoutePoints');
    dev.log('driverStartLat: $driverStartLat');
    dev.log('driverStartLng: $driverStartLng');
    dev.log('driverTargetLat: $driverTargetLat');
    dev.log('driverTargetLng: $driverTargetLng');
    return Container(
      width: double.infinity,
      height: state.requestedTrip != null
          ? MediaQuery.of(context).size.height * 0.55
          : MediaQuery.of(context).size.height * 0.55,
      // Add this to fix rendering issues
      decoration: const BoxDecoration(
        color: Colors.grey,
      ),
      child: ClipRect(
        child: CustomGoogleMap(
            startLocation: (state.requestedTrip != null &&
                    (state.requestedTrip!.status == TripState.inLocation.name))
                ? null
                : (state.requestedTrip != null &&
                        (state.requestedTrip!.status ==
                                TripState.goToClient.name ||
                            state.requestedTrip!.status ==
                                TripState.accepted.name))
                    ? gmap.LatLng(driverStartLat, driverStartLng)
                    : state.currentLocation == null
                        ? null
                        : gmap.LatLng(isBeforeRequest ? startLat : startLng,
                            isBeforeRequest ? startLng : startLat),
            targetLocation: (state.requestedTrip != null &&
                    (state.requestedTrip!.status == TripState.inLocation.name))
                ? null
                : (state.requestedTrip != null &&
                        (state.requestedTrip!.status ==
                                TripState.goToClient.name ||
                            state.requestedTrip!.status ==
                                TripState.accepted.name))
                    ? gmap.LatLng(driverTargetLat, driverTargetLng)
                    : state.toLocation == null
                        ? null
                        : gmap.LatLng(isBeforeRequest ? targetLat : targetLng,
                            isBeforeRequest ? targetLng : targetLat),
            polylinePoints: (state.requestedTrip != null &&
                    (state.requestedTrip!.status == TripState.inLocation.name))
                ? []
                : (state.requestedTrip != null &&
                        (state.requestedTrip!.status ==
                                TripState.goToClient.name ||
                            state.requestedTrip!.status ==
                                TripState.accepted.name))
                    ? driverRoutePoints
                        .map((gmap.LatLng latLng) =>
                            gmap.LatLng(latLng.longitude, latLng.latitude))
                        .toList()
                    : routePoints,
            clientLocations: (state.requestedTrip != null &&
                    (state.requestedTrip!.status == TripState.inLocation.name))
                ? []
                : (state.requestedTrip != null &&
                        (state.requestedTrip!.status ==
                                TripState.goToClient.name ||
                            state.requestedTrip!.status ==
                                TripState.accepted.name))
                    ? []
                    : clients,
            enableScrolling: true,
            fromClient: true,
            startAddress: startAddress,
            targetAddress: toAddress,
            clientAddresses: clientsAddress),
      ),
    );
  }

  List<gmap.LatLng> _convertPolylineToLatLng(List<List<double>> polyline) {
    return polyline.map((point) => gmap.LatLng(point[1], point[0])).toList();
  }

  Widget _buttonsWidget(
      {LoadingInfoEntity? loadingInfo, DriverInfoEntity? driverInfo}) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      children: [
        Align(
          alignment: AlignmentDirectional.topStart,
          child: ClickableWidget(
              onTap: () {
                ManageVibration.vibrate();
                context.pop();
              },
              child: const Icon(
                Icons.close,
                color: AppColors.black,
              )),
        ),
        const Sizer(),
        GestureDetector(
          onTap: () {
            ManageVibration.vibrate();
            if (!context.read<UserCubit>().isLoggedIn) {
              return pleaseLoginDialog(context);
            }
            context.pop();
            if (driverInfo == null ||
                (driverInfo.driverType?.isEmpty ?? false)) {
              serviceLocator<RideCubit>().onNavigateToWelcomeScreen(
                  fromShipping: false, context: context);
            } else {
              if (driverInfo.status == RegistrationStatus.pending.status) {
                return;
              } else if (driverInfo.status ==
                  RegistrationStatus.rejected.status) {
                context.push(Routes.UploadRiderImages,
                    extra: UploadRiderImagesParams(
                        isShipping: false,
                        isSocket:
                            driverInfo.driverType == 'socket' ? true : false));
              } else if (driverInfo.status ==
                  RegistrationStatus.initial.status) {
                context.push(Routes.UploadRiderImages,
                    extra: UploadRiderImagesParams(
                        isShipping: false,
                        isSocket:
                            driverInfo.driverType == 'socket' ? true : false));
              } else {
                context.push(Routes.rideModeScreen,
                    extra: RideModeParams(
                        modeType: 'ride',
                        isSocket:
                            driverInfo.driverType == 'socket' ? true : false));
              }
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: driverInfo != null &&
                        (driverInfo.status ==
                            RegistrationStatus.approved.status)
                    ? [
                        AppColors.cF33D49,
                        AppColors.cC0303A,
                        AppColors.cA72A32,
                        AppColors.c9A272E,
                        AppColors.c93252C,
                        AppColors.c90242B,
                      ]
                    : [
                        const Color(0xFF0B1035),
                        const Color(0xFF161F68),
                        const Color(0xFF1B2781),
                        const Color(0xFF1E2B8E),
                        const Color(0xFF1F2D95),
                        const Color(0xFF0B1035)
                      ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3)),
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
                        : (driverInfo.status ==
                                RegistrationStatus.initial.status)
                            ? context.isArabic
                                ? 'استكمال تسجيل سائق'
                                : 'Complete Ride Register'
                            : (driverInfo.status ==
                                    RegistrationStatus.pending.status)
                                ? context.isArabic
                                    ? 'انتظار موافقة تسجيل سائق'
                                    : 'Waiting ِApproval Ride Register'
                                : context.isArabic
                                    ? 'تسجيل سائق سيارة'
                                    : 'Ride Register',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const Sizer(),
        GestureDetector(
          onTap: () {
            if (!context.read<UserCubit>().isLoggedIn) {
              ManageVibration.vibrate();
              context.pop();
              return pleaseLoginDialog(context);
            }
            ManageVibration.vibrate();
            context.pop();
            if (loadingInfo == null || (loadingInfo.status?.isEmpty ?? false)) {
              print("object");
              serviceLocator<RideCubit>().onNavigateToWelcomeScreen(
                  fromShipping: true, context: context);
            } else {
              print("loadingInfo.toJson()${loadingInfo.toJson()}");
              if (loadingInfo.status == RegistrationStatus.pending.status) {
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
                    extra: RideModeParams(modeType: 'truck', isSocket: false));
              }
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: loadingInfo != null &&
                        (loadingInfo.status ==
                            RegistrationStatus.approved.status)
                    ? [
                        AppColors.cF33D49,
                        AppColors.cC0303A,
                        AppColors.cA72A32,
                        AppColors.c9A272E,
                        AppColors.c93252C,
                        AppColors.c90242B,
                      ]
                    : [
                        const Color(0xFF0B1035),
                        const Color(0xFF161F68),
                        const Color(0xFF1B2781),
                        const Color(0xFF1E2B8E),
                        const Color(0xFF1F2D95),
                        const Color(0xFF0B1035)
                      ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3)),
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
                        : (loadingInfo.status ==
                                RegistrationStatus.initial.status)
                            ? context.isArabic
                                ? 'استكمال تسجيل سائق نقل'
                                : 'Complete Truck Register'
                            : (loadingInfo.status ==
                                    RegistrationStatus.pending.status)
                                ? context.isArabic
                                    ? 'انتظار موافقة تسجيل سائق'
                                    : 'Waiting ِApproval Truck Register'
                                : context.isArabic
                                    ? 'تسجيل سائق نقل'
                                    : 'Truck Register',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const Sizer(),
        GestureDetector(
          onTap: () {
            if (context.isUserLoggedIn) {
              ManageVibration.vibrate();
              context.pop();
              context.push(Routes.rideOffer, extra: 'ride');
            } else {
              ManageVibration.vibrate();
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
                    color: Colors.black.withValues(alpha: 0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3)),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.isArabic ? 'وضع المستخدم' : 'User Mode',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " (${((context.read<RideCubit>().state.unreadOffers?.loading ?? 0) + (context.read<RideCubit>().state.unreadOffers?.nonTracking ?? 0)).toString()})",
                    style: TextStyle(
                        color: AppColors.SECONDARY_COLOR,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Sizer(),
        GestureDetector(
          onTap: () {
            if (context.isUserLoggedIn) {
              ManageVibration.vibrate();
              context.pop();
              context.push(Routes.RIDEHISTORYTRIPS,
                  extra: HistoryTripsScreenParams(
                    rideCubit: serviceLocator<RideCubit>(),
                  ));
            } else {
              ManageVibration.vibrate();
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
                    color: Colors.black.withValues(alpha: 0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3)),
              ],
            ),
            child: Center(
              child: Text(
                context.isArabic ? 'تاريخ الرحلات' : 'Ride History',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _carTruckBtn(
      {LoadingInfoEntity? loadingInfo,
      DriverInfoEntity? driverInfo,
      required Function openDrawer}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      width: double.infinity,
      height: serviceLocator<RideCubit>().selectedCategoryIsSocket == false
          ? 55
          : 75,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClickableWidget(
                onTap: () {
                  ManageVibration.vibrate();
                  openDrawer();
                },
                child: Container(
                  width: 75.w,
                  height: 35,
                  decoration: BoxDecoration(
                    color: context.isDarkMode
                        ? AppColors.GREY_DARK_COLOR
                        : AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3)),
                    ],
                  ),
                  padding: const EdgeInsets.all(4),
                  alignment: Alignment.center,
                  child: Image.asset(
                    Assets.rideMenu,
                    color: context.isDarkMode ? AppColors.whiteColor : null,
                  ),
                ),
              ),
              Visibility(
                visible:
                    ((context.read<RideCubit>().state.unreadOffers?.loading ??
                                0) +
                            (context
                                    .read<RideCubit>()
                                    .state
                                    .unreadOffers
                                    ?.nonTracking ??
                                0)) >
                        0,
                child: PositionedDirectional(
                  top: -10.h,
                  end: -10.w,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.getRedColor(context)),
                    child: Center(
                      child: Text(
                        ((context
                                        .read<RideCubit>()
                                        .state
                                        .unreadOffers
                                        ?.loading ??
                                    0) +
                                (context
                                        .read<RideCubit>()
                                        .state
                                        .unreadOffers
                                        ?.nonTracking ??
                                    0))
                            .toString(),
                        style: Styles.smallText(
                            color: context.isDarkMode
                                ? Colors.black
                                : AppColors.whiteColor,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Sizer(),
          Expanded(
            child: SizedBox(
              height: 35,
              child: GestureDetector(
                onTap: () {
                  ManageVibration.vibrate();
                  if ((driverInfo?.status !=
                          RegistrationStatus.approved.status) &&
                      (loadingInfo?.status !=
                          RegistrationStatus.approved.status)) {
                    openDrawer();
                  } else if (driverInfo?.status ==
                          RegistrationStatus.approved.status &&
                      loadingInfo?.status ==
                          RegistrationStatus.approved.status) {
                    openDrawer();
                  } else {
                    if (driverInfo?.status ==
                            RegistrationStatus.approved.status &&
                        loadingInfo?.status !=
                            RegistrationStatus.approved.status) {
                      context.push(Routes.rideModeScreen,
                          extra: RideModeParams(
                              modeType: 'ride',
                              isSocket: driverInfo?.driverType == 'socket'
                                  ? true
                                  : false));
                    } else if (driverInfo?.status !=
                            RegistrationStatus.approved.status &&
                        loadingInfo?.status ==
                            RegistrationStatus.approved.status) {
                      context.push(Routes.rideModeScreen,
                          extra: RideModeParams(
                              modeType: 'truck', isSocket: false));
                    }
                  }
                },
                child: Container(
                  // margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  width: double.infinity,
                  // height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: (driverInfo?.status ==
                                  RegistrationStatus.approved.status ||
                              (loadingInfo?.status ==
                                  RegistrationStatus.approved.status))
                          ? [
                              AppColors.cF33D49,
                              AppColors.cC0303A,
                              AppColors.cA72A32,
                              AppColors.c9A272E,
                              AppColors.c93252C,
                              AppColors.c90242B,
                            ]
                          : [
                              const Color(0xFF0B1035),
                              const Color(0xFF161F68),
                              const Color(0xFF1B2781),
                              const Color(0xFF1E2B8E),
                              const Color(0xFF1F2D95),
                              const Color(0xFF0B1035)
                            ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3)),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      (driverInfo?.status ==
                                  RegistrationStatus.approved.status ||
                              loadingInfo?.status ==
                                  RegistrationStatus.approved.status)
                          ? context.isArabic
                              ? 'وضع السائق'
                              : 'Driver Mode'
                          : LocaleKeys.carTruckRegister.tr(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold),
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

  Widget _buildStepperLine(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Stepper Line Container
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.green,
                radius: 6,
                child: const CircleAvatar(
                    backgroundColor: Colors.white, radius: 3),
              ),
              SizedBox(
                height: 4.h,
              ),
              ...List.generate(
                4,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.isDarkMode
                        ? Colors.grey[600]
                        : Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 6,
                child: const CircleAvatar(
                    backgroundColor: Colors.white, radius: 3),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Positioned(
      bottom: !serviceLocator<RideCubit>().selectedCategoryIsSocket ? null : 0,
      left: 0,
      right: 0,
      child: Column(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        children: [
          serviceLocator<RideCubit>().selectedCategoryIsSocket
              ? serviceLocator<RideCubit>().state.rideExpectedPrice == null
                  ? Padding(
                      padding: const EdgeInsetsDirectional.only(
                          end: 16.0, start: 16.0, bottom: 0),
                      child: Row(
                        spacing: 6,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // showDriverProfileSheet(context, driverId: "688a530b143e1a7ef09e8206");
                            },
                            child: Container(
                              height: 30,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  color: context.isDarkMode
                                      ? AppColors.GREY_DARK_COLOR
                                      : AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.3),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3)),
                                  ]),
                              alignment: Alignment.center,
                              child: Image.asset(
                                Assets.targetLocation,
                                color: context.isDarkMode
                                    ? AppColors.whiteColor
                                    : null,
                                width: 35.w,
                                height: 35.w,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ClickableWidget(
                                onTap: () {
                                  ManageVibration.vibrate();
                                  context.push(Routes.RIDERUNNINGTRIPS,
                                      extra: RunningTripParams(
                                        rideCubit: serviceLocator<RideCubit>(),
                                      ));
                                },
                                child: _tripsWidget(
                                    LocaleKeys.runningTrips.tr(),
                                    color: AppColors.GREYCARD)),
                          ),
                          Expanded(
                            child: ClickableWidget(
                                onTap: () {
                                  ManageVibration.vibrate();
                                  context.push(Routes.RIDEEXPIREDTRIPE,
                                      extra: ExpiredTripsScreenParams(
                                        rideCubit: serviceLocator<RideCubit>(),
                                      ));
                                },
                                child: _tripsWidget(
                                    LocaleKeys.expiredTrips.tr(),
                                    color: AppColors.GREYCARD)),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox()
              : const SizedBox(),
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            padding:
                const EdgeInsets.only(left: 10, right: 10, bottom: 16, top: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius:
                  !serviceLocator<RideCubit>().selectedCategoryIsSocket
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
                      serviceLocator<RideCubit>().selectedCategoryIsSocket ==
                                  false &&
                              (state.requestedTrip == null ||
                                  state.requestedTrip?.status ==
                                      TripState.completed.name ||
                                  state.requestedTrip?.status ==
                                      TripState.canceled.name ||
                                  state.requestedTrip?.status ==
                                      TripState.cancelledByClient.name ||
                                  state.requestedTrip?.status ==
                                      TripState.cancelledByDriver.name)
                          ? serviceLocator<RideCubit>()
                                      .state
                                      .rideExpectedPrice ==
                                  null
                              ? _carTruckBtn(
                                  driverInfo: state.driverInfo,
                                  loadingInfo: state.loaderInfo,
                                  openDrawer: () {
                                    ManageVibration.vibrate();
                                    showModalBottomSheet(
                                      backgroundColor: context.isDarkMode
                                          ? AppColors.QUANTITY_COLOR
                                          : Colors.white,
                                      context: context,
                                      builder: (context) => _buttonsWidget(
                                        driverInfo: state.driverInfo,
                                        loadingInfo: state.loaderInfo,
                                      ),
                                    );
                                  })
                              : const SizedBox.shrink()
                          : const SizedBox.shrink(),
                      _buildCategoryList(
                          "ride", state.rideCategory?.subCategories ?? []),
                      _buildCategoryList("shipping",
                          state.shippingCategory?.subCategories ?? []),
                      if (!serviceLocator<RideCubit>().selectedCategoryIsSocket)
                        RidePersonalMoreInfoScreen(
                            subCategoryId:
                                serviceLocator<RideCubit>().subCategoryId,
                            type: serviceLocator<RideCubit>()
                                    .state
                                    .selectedType ??
                                'ride'),
                      // serviceLocator<RideCubit>().selectedCategoryIsSocket
                      //     ? _customLocationField(
                      //         isTo: false,
                      //         color: Colors.green,
                      //         text: state.currentLocation?.address,
                      //         onPressed: () async {
                      //           ManageVibration.vibrate();
                      //           if (context.isUserLoggedIn) {
                      //             context.push(
                      //               Routes.GoogleMapsSearchAndPick,
                      //               extra: RideGoogleMapSearchAndPickParams(
                      //                 minDistanceReferencePoint:
                      //                     state.toLocation == null
                      //                         ? null
                      //                         : LatLng(state.toLocation!.lat!,
                      //                             state.toLocation!.lng!),
                      //                 onPicked: (pickedData) async {
                      //                   ManageVibration.vibrate();
                      //                   serviceLocator<RideCubit>()
                      //                       .updateFromLocation(
                      //                     lat: pickedData.latitude,
                      //                     lng: pickedData.longitude,
                      //                     address: pickedData.address,
                      //                   );
                      //                   await serviceLocator<RideCubit>()
                      //                       .fetchRideExpectedPrice(id: 'id');
                      //                   context.pop();
                      //                 },
                      //               ),
                      //             );
                      //           } else {
                      //             context.push(Routes.FirstLoginScreen);
                      //           }
                      //         },
                      //       )
                      //     : const SizedBox(),
                      // serviceLocator<RideCubit>().selectedCategoryIsSocket
                      //     ? _customLocationField(
                      //         isTo: true,
                      //         color: Colors.blue,
                      //         text: state.toLocation?.address,
                      //         onPressed: () async {
                      //           ManageVibration.vibrate();
                      //           if (context.isUserLoggedIn) {
                      //             context.push(
                      //               Routes.GoogleMapsSearchAndPick,
                      //               extra: RideGoogleMapSearchAndPickParams(
                      //                 minDistanceReferencePoint:
                      //                     state.currentLocation == null
                      //                         ? null
                      //                         : LatLng(
                      //                             state.currentLocation!.lat!,
                      //                             state.currentLocation!.lng!),
                      //                 onPicked: (pickedData) async {
                      //                   ManageVibration.vibrate();
                      //                   serviceLocator<RideCubit>()
                      //                       .updateToLocation(
                      //                     lat: pickedData.latitude,
                      //                     lng: pickedData.longitude,
                      //                     address: pickedData.address,
                      //                   );
                      //                   await serviceLocator<RideCubit>()
                      //                       .fetchRideExpectedPrice(id: 'id');
                      //                   context.pop();
                      //                 },
                      //               ),
                      //             );
                      //           } else {
                      //             context.push(Routes.FirstLoginScreen);
                      //           }
                      //         },
                      //       )
                      //     : const SizedBox(),

                      serviceLocator<RideCubit>().selectedCategoryIsSocket
                          ? Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Column(
                                  children: [
                                    // From Location Field
                                    Padding(
                                      padding: EdgeInsets.only(left: 48.w),
                                      child: _customLocationField(
                                        isTo: false,
                                        color: Colors.green,
                                        text: state.currentLocation?.address,
                                        onPressed: () async {
                                          ManageVibration.vibrate();
                                          if (context.isUserLoggedIn) {
                                            context.push(
                                              Routes.GoogleMapsSearchAndPick,
                                              extra:
                                                  RideGoogleMapSearchAndPickParams(
                                                    initialPosition: state.currentLocation == null
                                                        ? null
                                                        : gmap.LatLng(
                                                      state.currentLocation!.lat!,
                                                      state.currentLocation!.lng!,
                                                    ),
                                                initialAddress: state.currentLocation?.address,
                                                minDistanceReferencePoint: state
                                                            .toLocation ==
                                                        null
                                                    ? null
                                                    : LatLng(
                                                        state.toLocation!.lat!,
                                                        state.toLocation!.lng!),
                                                onPicked: (pickedData) async {
                                                  ManageVibration.vibrate();

                                                  serviceLocator<RideCubit>()
                                                      .updateFromLocation(
                                                    lat: pickedData.latitude,
                                                    lng: pickedData.longitude,
                                                    address: pickedData.address,
                                                  );
                                                  // if(state.toLocation != null && state.currentLocation != null){
                                                  await serviceLocator<
                                                          RideCubit>()
                                                      .fetchRideExpectedPrice(
                                                          id: 'id');
                                                  // }
                                                  context.pop();
                                                },
                                              ),
                                            );
                                          } else {
                                            context
                                                .push(Routes.FirstLoginScreen);
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    // To Location Field
                                    Padding(
                                      padding: EdgeInsets.only(left: 48.w),
                                      child: _customLocationField(
                                        isTo: true,
                                        color: Colors.blue,
                                        text: state.toLocation?.address,
                                        onPressed: () async {
                                          ManageVibration.vibrate();
                                          if (context.isUserLoggedIn) {
                                            context.push(
                                              Routes.GoogleMapsSearchAndPick,
                                              extra:
                                                  RideGoogleMapSearchAndPickParams(
                                                    initialPosition: state.toLocation == null
                                                        ? null
                                                        : gmap.LatLng(
                                                      state.toLocation!.lat!,
                                                      state.toLocation!.lng!,
                                                    ),
                                                initialAddress: state.toLocation?.address,
                                                minDistanceReferencePoint: state
                                                            .currentLocation ==
                                                        null
                                                    ? null
                                                    : LatLng(
                                                        state.currentLocation!
                                                            .lat!,
                                                        state.currentLocation!
                                                            .lng!),
                                                onPicked: (pickedData) async {
                                                  ManageVibration.vibrate();

                                                  serviceLocator<RideCubit>()
                                                      .updateToLocation(
                                                    lat: pickedData.latitude,
                                                    lng: pickedData.longitude,
                                                    address: pickedData.address,
                                                  );
                                                  // if(state.currentLocation != null && state.toLocation != null){
                                                  await serviceLocator<
                                                          RideCubit>()
                                                      .fetchRideExpectedPrice(
                                                          id: 'id');
                                                  // }
                                                  context.pop();
                                                },
                                              ),
                                            );
                                          } else {
                                            context
                                                .push(Routes.FirstLoginScreen);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                // Stepper Line with Dots
                                Positioned(
                                    left: context.isArabic ? -18 : -10,
                                    top: 0,
                                    bottom: 0,
                                    child: _buildStepperLine(context)),
                              ],
                            )
                          : const SizedBox(),
                      serviceLocator<RideCubit>().selectedCategoryIsSocket
                          ? _fareField()
                          : const SizedBox(),
                      serviceLocator<RideCubit>().selectedCategoryIsSocket
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
                                          onPressed: () async {
                                            ManageVibration.vibrate();
                                            final rideCubit =
                                                serviceLocator<RideCubit>();
                                            final state = rideCubit.state;

                                            if (!context.isUserLoggedIn) {
                                              context.push(
                                                  Routes.FirstLoginScreen);
                                              return;
                                            }

                                            if (state.toLocation == null ||
                                                state.currentLocation == null) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                  context.isArabic
                                                      ? "يرجى تحديد الموقع"
                                                      : "Please select location",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                backgroundColor: Colors.red,
                                                duration:
                                                    const Duration(seconds: 2),
                                              ));
                                              return;
                                            }

                                            bool isSubscribed =
                                                await rideCubit.isSubscribed(
                                              userId:
                                                  UserCubit.to.state.data?.id ??
                                                      '',
                                              subcategoryId: state
                                                      .rideCategory
                                                      ?.subCategories[rideCubit
                                                          .selectedCategoryIndex!]
                                                      .subCategoryId ??
                                                  '',
                                            );

                                            if (!isSubscribed) {
                                              SubscriptionMethod().subscribe(
                                                subscribeId: state
                                                        .rideCategory
                                                        ?.subCategories[rideCubit
                                                            .selectedCategoryIndex!]
                                                        .subCategoryId ??
                                                    '',
                                                // onSubscribe: () {
                                                //   context.pop();
                                                //   context.pop();
                                                // },
                                                showRegular: false,
                                                title: context.isArabic
                                                    ? state
                                                            .rideCategory
                                                            ?.subCategories[
                                                                rideCubit
                                                                    .selectedCategoryIndex!]
                                                            .subCategoryNameAr ??
                                                        ''
                                                    : state
                                                            .rideCategory
                                                            ?.subCategories[
                                                                rideCubit
                                                                    .selectedCategoryIndex!]
                                                            .subCategoryNameEn ??
                                                        '',
                                              );
                                              return;
                                            }

                                            if (!_isPhoneNumberValidated) {
                                              if (rideCubit
                                                      .phoneNumberController
                                                      .text
                                                      .isEmpty ||
                                                  !(_phoneNumberFormKey
                                                          .currentState
                                                          ?.validate() ??
                                                      false)) {
                                                bool? isPhoneNumberValid =
                                                    await showModalBottomSheet<
                                                        bool>(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                context)
                                                            .viewInsets
                                                            .bottom,
                                                      ),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: context
                                                                  .isDarkMode
                                                              ? AppColors
                                                                  .QUANTITY_COLOR
                                                              : Colors.white,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          20.0)),
                                                        ),
                                                        child: Form(
                                                          key:
                                                              _phoneNumberFormKey,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  const SizedBox(
                                                                      width:
                                                                          24),
                                                                  Text(
                                                                    LocaleKeys
                                                                        .phoneNumber
                                                                        .localize,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .close),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            0),
                                                                    onPressed:
                                                                        () {
                                                                      ManageVibration
                                                                          .vibrate();
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(
                                                                              false);
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                              // const SizedBox(height: 20),
                                                              Text(
                                                                context.isArabic
                                                                    ? 'الرجاء إدخال رقم تواصل مباشر مع مقدم الخدمة'
                                                                    : "Please enter a direct contact number for the service provider.",
                                                              ),
                                                              // const SizedBox(height: 20),
                                                              // NewPhoneNumberTextFormField(
                                                              //   currentController: rideCubit.phoneNumberController,
                                                              //   keyboardType: TextInputType.number,
                                                              //   isRequired: true,
                                                              //   validator: validatorEgyptPhone,
                                                              // ),
                                                              NewPhoneNumberTextFormField(
                                                                currentController:
                                                                    rideCubit
                                                                        .phoneNumberController,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                isRequired:
                                                                    true,
                                                                validator:
                                                                    (value) {
                                                                  // تحويل الأرقام العربية إلى إنجليزية قبل الفاليديشن
                                                                  String
                                                                      normalized =
                                                                      value?.replaceAllMapped(
                                                                            RegExp(r'[٠-٩]'),
                                                                            (match) =>
                                                                                (match.group(0)!.codeUnitAt(0) - 0x0660).toString(),
                                                                          ) ??
                                                                          '';

                                                                  return validatorEgyptPhone(
                                                                      normalized);
                                                                },
                                                                inputFormatter: [
                                                                  ArabicNumberFormatter(
                                                                      isArabic:
                                                                          context
                                                                              .isArabic),
                                                                ],
                                                              ),
                                                              // const SizedBox(height: 20),
                                                              Text(
                                                                context.isArabic
                                                                    ? "كتابة رقم عميل آخر على مسؤوليتك و يعرض للمسائله القانونيه."
                                                                    : "Entering another customer's number is at your own risk and may subject you to legal liability.",
                                                              ),
                                                              const SizedBox(
                                                                  height: 20),
                                                              Theme(
                                                                data: ThemeData(
                                                                  inputDecorationTheme: InputDecorationTheme(
                                                                    border: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(12.0),
                                                                      borderSide: const BorderSide(
                                                                          color: AppColors.PRIMARY_COLOR),
                                                                    ),

                                                                    enabledBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(12.0),
                                                                      borderSide: const BorderSide(
                                                                          color: AppColors.PRIMARY_COLOR),
                                                                    ),
                                                                  )
                                                                ),
                                                                child: TextField(
                                                                  controller: _descriptionController,
                                                                  maxLines: 5,
                                                                  minLines: 3,
                                                                  cursorColor: AppColors.PRIMARY_COLOR,
                                                                  onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                                                                  decoration:
                                                                       InputDecoration(

                                                                    border:
                                                                        OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(12.0),
                                                                          borderSide: const BorderSide(
                                                                              color: AppColors.PRIMARY_COLOR),

                                                                        ),

                                                                         enabledBorder: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(12.0),
                                                                          borderSide: const BorderSide(
                                                                              color: AppColors.PRIMARY_COLOR),
                                                                         ),

                                                                         focusedBorder: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(12.0),
                                                                          borderSide: const BorderSide(
                                                                              color: AppColors.PRIMARY_COLOR),
                                                                         ),
                                                                         hintText: context.isArabic? "أكتب تعليق للسائق..." : "Write a comment for the driver...",
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 60),
                                                              SizedBox(
                                                                width: double
                                                                    .infinity,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    ManageVibration
                                                                        .vibrate();

                                                                    if (_phoneNumberFormKey
                                                                        .currentState!
                                                                        .validate()) {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(
                                                                              true);
                                                                    }
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        AppColors
                                                                            .PRIMARY_COLOR,
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            15),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    LocaleKeys
                                                                        .submit
                                                                        .localize,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .white),
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

                                                if (isPhoneNumberValid ==
                                                    true) {
                                                  _isPhoneNumberValidated =
                                                      true;
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                      context.isArabic
                                                          ? "رقم الهاتف غير صالح أو لم يتم إدخاله."
                                                          : "Phone number is invalid or not entered.",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    backgroundColor: Colors.red,
                                                    duration: const Duration(
                                                        seconds: 2),
                                                  ));
                                                  return;
                                                }
                                              }
                                            }

                                            /// ✅ Show reservation sheet directly if phone is validated
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (context) =>
                                                  CustomReserveRideBottomSheet(
                                                rideCubit: rideCubit,
                                                selectedCategoryId: state
                                                        .rideCategory
                                                        ?.subCategories[rideCubit
                                                            .selectedCategoryIndex!]
                                                        .subCategoryId ??
                                                    '',
                                                isPremium: true,
                                                    description: _descriptionController.text.trim() == '' ? null : _descriptionController.text.trim(),
                                              ),
                                            );
                                          },
                                          backColor:
                                              AppColors.SECONDARY_COLOR_DARK2,
                                          width: MediaQuery.of(context)
                                              .size
                                              .width)),
                                  Expanded(
                                      flex: 2,
                                      child: state.isLoadingSubmit
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : AppButton(
                                              radius: 15,
                                              label: LocaleKeys.request.tr(),
                                              backColor:
                                                  AppColors.PRIMARY_COLOR,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              onPressed: () async {
                                                ManageVibration.vibrate();

                                                if (!context.isUserLoggedIn) {
                                                  context.push(
                                                      Routes.FirstLoginScreen);
                                                  return;
                                                }

                                                final rideCubit =
                                                    serviceLocator<RideCubit>();
                                                final state = rideCubit.state;

                                                if (state.toLocation == null ||
                                                    state.currentLocation ==
                                                        null) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                      context.isArabic
                                                          ? "يرجى تحديد الموقع"
                                                          : "Please select location",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    backgroundColor: Colors.red,
                                                    duration: const Duration(
                                                        seconds: 2),
                                                  ));
                                                  return;
                                                }

                                                if (!_isPhoneNumberValidated) {
                                                  rideCubit
                                                      .phoneNumberController
                                                      .clear();
                                                  _phoneNumberFormKey
                                                      .currentState
                                                      ?.reset();

                                                  final bool?
                                                      isPhoneNumberValid =
                                                      await showModalBottomSheet<
                                                          bool>(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom,
                                                        ),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: context
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .QUANTITY_COLOR
                                                                : Colors.white,
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .vertical(
                                                                    top: Radius
                                                                        .circular(
                                                                            20.0)),
                                                          ),
                                                          child: Form(
                                                            key:
                                                                _phoneNumberFormKey,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const SizedBox(
                                                                        width:
                                                                            10),
                                                                    Text(
                                                                      LocaleKeys
                                                                          .phoneNumber
                                                                          .localize,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    IconButton(
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .close),
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              0),
                                                                      onPressed:
                                                                          () {
                                                                        ManageVibration
                                                                            .vibrate();
                                                                        Navigator.of(context)
                                                                            .pop(false);
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                                // const SizedBox(height: 20),
                                                                Text(
                                                                  context.isArabic
                                                                      ? 'الرجاء إدخال رقم تواصل مباشر مع مقدم الخدمة'
                                                                      : "Please enter a direct contact number for the service provider.",
                                                                ),
                                                                // const SizedBox(height: 20),
                                                                NewPhoneNumberTextFormField(
                                                                  currentController:
                                                                      rideCubit
                                                                          .phoneNumberController,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  isRequired:
                                                                      true,
                                                                  maxLength: 11,
                                                                  validator:
                                                                      (value) {
                                                                    // تحويل الأرقام العربية إلى إنجليزية قبل الفاليديشن
                                                                    String
                                                                        normalized =
                                                                        value?.replaceAllMapped(
                                                                              RegExp(r'[٠-٩]'),
                                                                              (match) => (match.group(0)!.codeUnitAt(0) - 0x0660).toString(),
                                                                            ) ??
                                                                            '';

                                                                    return validatorEgyptPhone(
                                                                        normalized);
                                                                  },
                                                                  onChanged:
                                                                      (v) {
                                                                    _phoneNumberFormKey
                                                                        .currentState!
                                                                        .validate();
                                                                  },
                                                                  inputFormatter: [
                                                                    ArabicNumberFormatter(
                                                                        isArabic:
                                                                            context.isArabic),
                                                                  ],
                                                                ),
                                                                // const SizedBox(height: 20),
                                                                Text(
                                                                  context.isArabic
                                                                      ? "كتابة رقم عميل آخر على مسؤوليتك و يعرض للمسائله القانونيه."
                                                                      : "Entering another customer's number is at your own risk and may subject you to legal liability.",
                                                                ),
                                                                const SizedBox(
                                                                    height: 20),
                                                                Theme(
                                                                  data: ThemeData(
                                                                      inputDecorationTheme: InputDecorationTheme(
                                                                        border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(12.0),
                                                                          borderSide: const BorderSide(
                                                                              color: AppColors.PRIMARY_COLOR),
                                                                        ),

                                                                        enabledBorder: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(12.0),
                                                                          borderSide: const BorderSide(
                                                                              color: AppColors.PRIMARY_COLOR),
                                                                        ),
                                                                      )
                                                                  ),
                                                                  child: TextField(
                                                                    controller: _descriptionController,
                                                                    maxLines: 5,
                                                                    minLines: 3,
                                                                    cursorColor: AppColors.PRIMARY_COLOR,
                                                                    onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                                                                    decoration:
                                                                    InputDecoration(

                                                                      border:
                                                                      OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(12.0),
                                                                        borderSide: const BorderSide(
                                                                            color: AppColors.PRIMARY_COLOR),

                                                                      ),

                                                                      enabledBorder: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(12.0),
                                                                        borderSide: const BorderSide(
                                                                            color: AppColors.PRIMARY_COLOR),
                                                                      ),

                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(12.0),
                                                                        borderSide: const BorderSide(
                                                                            color: AppColors.PRIMARY_COLOR),
                                                                      ),
                                                                      hintText: context.isArabic? "أكتب تعليق للسائق..." : "Write a comment for the driver...",
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 60),
                                                                SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      ManageVibration
                                                                          .vibrate();
                                                                      if (_phoneNumberFormKey
                                                                          .currentState!
                                                                          .validate()) {
                                                                        context.pop(
                                                                            true);
                                                                      }
                                                                    },
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      backgroundColor:
                                                                          AppColors
                                                                              .PRIMARY_COLOR,
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                              15),
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                    ),
                                                                    child: Text(
                                                                      LocaleKeys
                                                                          .submit
                                                                          .localize,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              Colors.white),
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

                                                  if (isPhoneNumberValid !=
                                                      true) {
                                                    // ❌ User didn't enter valid number
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                        context.isArabic
                                                            ? "رقم الهاتف غير صالح أو لم يتم إدخاله."
                                                            : "Phone number is invalid or not entered.",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      backgroundColor:
                                                          Colors.red,
                                                      duration: const Duration(
                                                          seconds: 2),
                                                    ));
                                                    return;
                                                  } else {
                                                    // ✅ Valid phone number entered
                                                    _isPhoneNumberValidated =
                                                        true;
                                                  }
                                                }

                                                // ✅ Show the reservation bottom sheet directly
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  builder: (context) =>
                                                      CustomReserveRideBottomSheet(
                                                    rideCubit: rideCubit,
                                                    selectedCategoryId: state
                                                            .rideCategory
                                                            ?.subCategories[
                                                                rideCubit
                                                                    .selectedCategoryIndex!]
                                                            .subCategoryId ??
                                                        '',
                                                    isPremium: false,
                                                        description: _descriptionController.text.trim() == '' ? null : _descriptionController.text.trim(),
                                                  ),
                                                );
                                              },
                                            )),
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
      height: 30,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: context.isDarkMode ? AppColors.GREY_DARK_COLOR : color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.DARK_BLUE_COLOR),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3)),
          ]),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildCategoryList(String type, List subCategories) {
    // Create a new controller for each widget instance instead of reusing
    final ScrollController controller = ScrollController();

    return Row(
      children: [
        Expanded(
          flex: 9,
          child: SizedBox(
            height: 46,
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.right,
              color: AppColors.SECONDARY_COLOR,
              child: ListView.builder(
                controller: controller,
                scrollDirection: Axis.horizontal,
                itemCount: subCategories.length,
                itemBuilder: (context, index) {
                  final subCategory = subCategories[index];
                  final bool isSelected =
                      serviceLocator<RideCubit>().selectedCategoryType ==
                              type &&
                          serviceLocator<RideCubit>().selectedCategoryIndex ==
                              index;
                  return GestureDetector(
                    onTap: () {
                      ManageVibration.vibrate();
                      context
                          .read<ClientTripsCubit>()
                          .initData(subCategories[index]?.subCategoryId ?? '');
                      context
                          .read<ClientTripsCubit>()
                          .initData(subCategories[index]?.subCategoryId ?? '');
                      context
                              .read<ClientTripsCubit>()
                              .makeNonTrackingTripParam =
                          MakeNonTrackingRequestTripUsecaseParam();
                      context.read<ClientTripsCubit>().makeLoadingTripParam =
                          MakeLoadingRequestTripUsecaseParam();
                      serviceLocator<RideCubit>().onChangeCategoriesType(type);
                      setState(() {
                        if (context.isUserLoggedIn &&
                            serviceLocator<UserCubit>().state.data?.gender !=
                                null) {
                          if (serviceLocator<UserCubit>().state.data?.gender ==
                                  "male" &&
                              subCategory.subCategoryNameEn
                                      .trim()
                                      .toLowerCase() ==
                                  "lady") {
                            showErrorMessage(
                                context,
                                context.isArabic
                                    ? "أنت رجل, لا يمكنك استخدام هذه الخدمة"
                                    : "You are a man, you can't use this service");
                            return;
                          }
                        }
                        if (serviceLocator<RideCubit>().selectedCategoryType ==
                                type &&
                            serviceLocator<RideCubit>().selectedCategoryIndex ==
                                index) {
                          // serviceLocator<RideCubit>().selectedCategoryType = null;
                          // serviceLocator<RideCubit>().selectedCategoryIndex = null;
                        } else {
                          serviceLocator<RideCubit>().selectedCategoryType =
                              type;
                          serviceLocator<RideCubit>().selectedCategoryIndex = 0;
                          subCategories.insert(
                              0, subCategories.removeAt(index));
                          if (!serviceLocator<RideCubit>()
                                  .selectedCategoryIsSocket &&
                              type == "ride")
                            serviceLocator<RideCubit>()
                                .returnToSoketFromSwitch();
                        }
                        serviceLocator<RideCubit>().subCategoryId =
                            subCategory.subCategoryId;
                        serviceLocator<RideCubit>()
                            .checkSelectedCategoryIsSocket(
                                subCategory.subCategoryId);
                      });
                      _scrollToStart(
                          controller); // Pass the controller directly
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
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              ManageVibration.vibrate();
              _scrollRight(controller); // Pass the controller directly
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
              ? Colors.redAccent.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imageUrl, width: 50, height: 18, fit: BoxFit.fill),
            const SizedBox(height: 2),
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
            color: context.isDarkMode
                ? AppColors.GREY_DARK_COLOR
                : const Color(0xFFEEEEEE),
          ),
          child: Row(
            children: [
              // CircleAvatar(
              //   backgroundColor: Colors.transparent,
              //   child: CircleAvatar(
              //     backgroundColor: color,
              //     radius: 10,
              //     child: const CircleAvatar(
              //         backgroundColor: Colors.white, radius: 5),
              //   ),
              // ),
              SizedBox(
                width: 16,
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
              SizedBox(
                width: 16,
              ),
              if (isTo == true && text != 'To')
                GestureDetector(
                  onTap: () {
                    ManageVibration.vibrate();
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
      if (serviceLocator<RideCubit>().selectedCategoryType == "ride") {
        selectedCategoryName = state
                .rideCategory
                ?.subCategories[
                    serviceLocator<RideCubit>().selectedCategoryIndex!]
                .subCategoryNameEn ??
            "";
      } else {
        selectedCategoryName = state
                .shippingCategory
                ?.subCategories[
                    serviceLocator<RideCubit>().selectedCategoryIndex!]
                .subCategoryNameEn ??
            "";
      }
      // log("""selectedCategoryName: $selectedCategoryName""");
      if (selectedCategoryName.trim().toLowerCase() ==
          "Captain".toLowerCase()) {
        selectedCategoryPrice = state.rideExpectedPrice?.priceForCaptain ?? 0.0;
      } else if (selectedCategoryName.trim().toLowerCase() ==
          "Scooter".toLowerCase()) {
        selectedCategoryPrice = state.rideExpectedPrice?.priceForScooter ?? 0.0;
      } else if (selectedCategoryName.trim().toLowerCase() ==
          "Taxi".toLowerCase()) {
        selectedCategoryPrice = state.rideExpectedPrice?.priceForTaxi ?? 0.0;
      } else if (selectedCategoryName.trim().toLowerCase() ==
          "Suv".toLowerCase()) {
        selectedCategoryPrice = state.rideExpectedPrice?.priceForSUV ?? 0.0;
      } else if (selectedCategoryName.trim().toLowerCase() ==
          "Lady".toLowerCase()) {
        selectedCategoryPrice = state.rideExpectedPrice?.priceForWomen ?? 0.0;
      } else if (selectedCategoryName.trim().toLowerCase() ==
          "Premium".toLowerCase()) {
        selectedCategoryPrice = state.rideExpectedPrice?.priceForPremium ?? 0.0;
      } else if (selectedCategoryName.trim().toLowerCase() ==
          "Intercity".toLowerCase()) {
        selectedCategoryPrice =
            state.rideExpectedPrice?.priceForIntercity ?? 0.0;
      }
      return GestureDetector(
        onTap: () {
          ManageVibration.vibrate();
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
                    isArabic: context.isArabic,
                    selectedCategoryPrice: serviceLocator<RideCubit>()
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 40,
                  decoration: BoxDecoration(
                    color: context.isDarkMode
                        ? AppColors.GREY_DARK_COLOR
                        : AppColors.GREYFIELD,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(LocaleKeys.egp.tr(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: AppColors.PRIMARY_COLOR_DARK)),
                      Spacer(),
                      state.rideExpectedPrice != null
                          ? Text(
                              FormatNumbers().convertNumberToLocalizedString(
                                  serviceLocator<RideCubit>()
                                      .getTotalPrice(selectedCategoryPrice)
                                      .toInt()
                                      .toString(),
                                  isArabic: context.isArabic),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                  color: AppColors.PRIMARY_COLOR))
                          : Text(LocaleKeys.offerYourFare.tr()),
                      const Spacer(),
                      Icon(
                        Icons.edit_outlined,
                        color: context.isDarkMode
                            ? null
                            : AppColors.DARK_BLUE_COLOR,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    ManageVibration.vibrate();
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
                            selectedCategoryPrice: serviceLocator<RideCubit>()
                                .getTotalPrice(selectedCategoryPrice),
                          ),
                          title: LocaleKeys.options.tr());
                    }
                  },
                  child: SizedBox(
                    height: 25,
                    child: Icon(
                      Icons.tune_outlined,
                      color:
                          context.isDarkMode ? null : AppColors.DARK_BLUE_COLOR,
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
    return BlocProvider.value(
      value: CarLocationCubit(),
      child: BlocBuilder<CarLocationCubit, GetLocationFromAddressEntity?>(
        builder: (context, state) {
          if (state == null ||
              state.lat == null ||
              state.lng == null ||
              _initialDirection == null) {
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
  static Marker build(LatLng carLocation, LatLng? previousLocation,
      {required double initialDirection}) {
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
    final double x =
        cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLng);
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

class _CountdownTimerWidgetState extends State<CountdownTimerWidget>
    with SingleTickerProviderStateMixin {
  static const int totalSeconds = 600;
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
    final isLastMinute = _remaining.inSeconds <= 300 && widget.isActive;

    final message = widget.isArabic
        ? (isLastMinute
            ? "كن حذرًا، يمكن أن يلغي السائق الرحلة، ولديه مبررات قوية لذلك."
            : "لا تتأخر، قد يؤثر على تقييمك")
        : (isLastMinute
            ? "Be careful, the driver could cancel the ride, and he has every right to do so."
            : "Please don't be late, it might affect your rating");

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
                    color: isLastMinute
                        ? Colors.red
                        : context.isDarkMode
                            ? AppColors.whiteColor
                            : Colors.black,
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
                    color: isLastMinute
                        ? Colors.red
                        : context.isDarkMode
                            ? AppColors.whiteColor
                            : Colors.black,
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

class ArabicNumberFormatter extends TextInputFormatter {
  final bool isArabic;
  ArabicNumberFormatter({required this.isArabic});

  static const englishNumbers = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9'
  ];
  static const arabicNumbers = [
    '٠',
    '١',
    '٢',
    '٣',
    '٤',
    '٥',
    '٦',
    '٧',
    '٨',
    '٩'
  ];

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    if (isArabic) {
      for (int i = 0; i < 10; i++) {
        text = text.replaceAll(englishNumbers[i], arabicNumbers[i]);
      }
    } else {
      for (int i = 0; i < 10; i++) {
        text = text.replaceAll(arabicNumbers[i], englishNumbers[i]);
      }
    }

    return newValue.copyWith(
      text: text,
      selection: newValue.selection,
    );
  }
}
