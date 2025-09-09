import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/gmap_search_and_pick.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/screen/custom_map.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/usecases/create_pick_me_offer_use_case.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../domain/usecases/create_trip_join_offer_use_case.dart';
import 'Modified_widgets/create_ad_widgets/trip_join_ad_buttons.dart';
import 'Modified_widgets/create_ad_widgets/trip_join_bottom_section.dart';
import 'Modified_widgets/infoButton.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../routes/routes.dart';
import '../../domain/usecases/get_expected_price_use_case.dart';
import '../cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';

import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/expected_price_entity.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class TripJoinCreateAdView extends StatefulWidget {
  const TripJoinCreateAdView({super.key, required this.isFromPickMe});
  final bool isFromPickMe;
  @override
  State<TripJoinCreateAdView> createState() => _TripJoinCreateAdViewState();
}

class _TripJoinCreateAdViewState extends State<TripJoinCreateAdView> {
  String? selectedBrand;
  String? selectedBrandId;
  String? selectedModel;
  String? selectedModelId;
  int? selectedSeatNum;
  bool isChecked = false;
  TimeOfDay? time;
  int seatNum = 1;
  var phoneController = TextEditingController();
  String? selectedCountry;
  final MapController _mapController = MapController();
  final _formKey = GlobalKey<FormState>();
  List<double>? currentLocation;
  List<double>? toLocation;
  String? currentAddress;
  String? toAddress;

  List<String> carModels = [];
  bool isModelLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isFromPickMe == false) context.read<ViewAllTripJoinCubit>().loadInitialCarBrandLoading();
  }

  String _formatDistance(double meters) {
    final km = (meters / 1000).toStringAsFixed(1);
    return '$km ${LocaleKeys.KM.localize}';
  }

  String _calculateTotalPrice(ExpectedPriceTripEntity? entity) {
    final pricePerSeat = entity?.pricePerSeat ?? 0;
    final seatCount = selectedSeatNum ?? 1;
    final total = pricePerSeat * seatCount;
    return total % 1 == 0 ? total.toInt().toString() : total.toStringAsFixed(1);
  }

  String _getTime2() {
    return time?.format(context) ?? TimeOfDay.now().format(context);
  }

  DateTime _getTime() {
    final now = DateTime.now();
    final selected = time ?? TimeOfDay.now();
    return DateTime(now.year, now.month, now.day, selected.hour, selected.minute);
  }

  // New method to print all selected data
  void _printAllData(ViewAllTripJoinState state) {
    print('=== Trip Join Data ===');
    print('Selected Brand: ${selectedBrand ?? 'Not selected'}');
    print('Selected Model: ${selectedModel ?? 'Not selected'}');
    print('Selected Seat Number: ${selectedSeatNum ?? 'Not selected'}');
    print('Repeat Trip: $isChecked');
    print('Selected Time: ${_getTime()}');
    double? rawDistance = state.expectedPriceEntity?.distance;
    print('Distance: ${rawDistance != null ? rawDistance.toStringAsFixed(1) : 'Not available'} meters');
    print('Total Price: ${_calculateTotalPrice(state.expectedPriceEntity)} ${context.isArabic ? 'جنيه' : 'EGP'}');
    print('Phone Number: ${phoneController.text.isEmpty ? 'Not entered' : phoneController.text}');
    print('Current Location: ${currentLocation?.join(', ') ?? 'Not selected'}');
    print('Current Address: ${currentAddress ?? 'Not selected'}');
    print('To Location: ${toLocation?.join(', ') ?? 'Not selected'}');
    print('To Address: ${toAddress ?? 'Not selected'}');
    print('=================');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ViewAllTripJoinCubit, ViewAllTripJoinState>(
      listener: (context, state) {
        if (state.status == ViewAllTripJoinStatus.failure) {
          String errorName = getFailureName(state.failure!, context);
          final failure = state.failure;
          if (failure is ServerFailure) {
            // Try to get errors from the errors list first
            if (failure.errors != null && failure.errors!.isNotEmpty) {
              showErrorMessage(context, failure.errors!.first);
              return;
            }
            errorName == 'DebtError'
                ? showDebtDialog(context, "62c8ba9f8e28a58a3edf57ee", LocaleKeys.tripJoin.localize)
                : errorName == 'SubscribeError'
                    ? showSubscribeDialog(context, "62c8ba9f8e28a58a3edf57ee")
                    : showErrorMessage(context, getFailureMessage(state.failure!, context));
          }
        }
      },
      child: BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(
        builder: (context, state) {
          return SharedScaffold(
            mainCategoryId: 1,
            isWithBackArrow: true,
            body: Padding(
              padding: const EdgeInsets.symmetric(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: WelcomeTextWidget(
                      title: widget.isFromPickMe == true ? LocaleKeys.welcome_pick_me.localize : LocaleKeys.welcomeToTripjoin.localize,
                      infoMessage: widget.isFromPickMe == true?
                      context.isArabic
                          ? "قم بالاعلات عن رحلتك المتكرره يوميا"
                          : "Create a recurring trip every day"
                          :
                      context.isArabic
                          ? " انشئ إعلان لرحلة بسيارتك ، انتظر المستخدمين للاتصال بك. شارك الرحلة واكسب المال!"
                          : "Create Ad for a trip with your car, wait users to contact you. Share trip & gain money!",
                    ),
                  ),
                  _buildTopImage(),
                  // const Sizer(),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
                          child: _customLocationField(
                            isTo: false,
                            context: context,
                            color: Colors.green,
                            text: currentAddress,
                            onPressed: () async {
                              ManageVibration.vibrate();
                              context.push(
                                Routes.GoogleMapsSearchAndPick,
                                extra: RideGoogleMapSearchAndPickParams(
                                  onPicked: (pickedData) async {
                                    currentAddress = pickedData.address;
                                    currentLocation = [pickedData.latitude, pickedData.longitude];
                                    context.pop();
                                    setState(() {});
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
                          child: _customLocationField(
                              isTo: true,
                              context: context,
                              color: Colors.blue,
                              text: toAddress,
                              onPressed: () async {
                                ManageVibration.vibrate();
                                context.push(
                                  Routes.GoogleMapsSearchAndPick,
                                  extra: RideGoogleMapSearchAndPickParams(
                                    onPicked: (pickedData) async {
                                      toAddress = pickedData.address;
                                      toLocation = [
                                        pickedData.latitude,
                                        pickedData.longitude,
                                      ];

                                      context.pop();

                                      if (currentLocation != null && toLocation != null) {
                                        final params = ExpectedPriceTripParams(
                                          startLatitude: currentLocation![0],
                                          startLongitude: currentLocation![1],
                                          targetLatitude: toLocation![0],
                                          targetLongitude: toLocation![1],
                                        );

                                        context.read<ViewAllTripJoinCubit>().getExpectedPrice(params: params);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Please select both locations')),
                                        );
                                      }

                                      setState(() {});
                                    },
                                  ),
                                );
                              }

                              /*
                          onPressed: () async {
                          ManageVibration.vibrate();
                            context.push(Routes.RIDEOPENSTREETMAPSEARCHANDPICK,
                                extra: RideOpenStreetMapSearchAndPickParams(
                                  onPicked: (pickedData) async {
                                    toAddress = pickedData.addressName;
                                    toLocation = [
                                      pickedData.latLong.latitude,
                                      pickedData.latLong.longitude
                                    ];
                                    context.pop();
                                    if (currentLocation != null && toLocation != null) {
                                      final params = ExpectedPriceTripParams(
                                        startLocation: currentLocation!,
                                        targetLocation: toLocation!,
                                      );
                                      context.read<ViewAllTripJoinCubit>().getExpectedPrice(params: params);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Please select both locations')),
                                      );
                                    }
                                    setState(() {});
                                  },
                                ));
                          },

                           */
                              ),
                        ),
                        const Sizer(),
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction, // 👈 enables live validation
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.h),
                            child: FormTextField(
                              textStyle: Styles.mediumText(color: AppColors.getTextColor(context)),
                              type: TextInputType.phone,
                              height: 76.h,
                              style: Styles.mediumText(color: AppColors.getTextColor(context)),
                              constraints: const BoxConstraints(maxHeight: 52, minHeight: 52),
                              fillColor: AppColors.getFillColor(context),
                              borderRadius: BorderRadius.circular(30.h),
                              borderColor: AppColors.getFillColor(context),
                              borderSide: AppColors.getFillColor(context),
                              controller: phoneController,
                              hint: LocaleKeys.phoneNumber.localize,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(11),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LocaleKeys.please_enter_phone_number.localize;
                                }

                                if (!value.startsWith('01')) {
                                  return LocaleKeys.please_enter_phone_number.localize;
                                }

                                final egyptianPhoneRegExp = RegExp(r'^(010|011|012|015)\d{8}$');
                                if (!egyptianPhoneRegExp.hasMatch(value)) {
                                  return LocaleKeys.please_enter_phone_number.localize;
                                }

                                return null;
                              },
                            ),
                          ),
                        ),
                        const Sizer(),
                        if (widget.isFromPickMe == false)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.h),
                            child: BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(
                              builder: (context, state) {
                                final cubit = context.read<ViewAllTripJoinCubit>();
                                if (cubit.isLoadingCarBrandLoading && cubit.carBrandData.isEmpty) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                if (cubit.carBrandData.isEmpty) {
                                  return Center(child: Text("No brands found"));
                                }
                                return Row(
                                  children: [
                                    _buildMenuButton(
                                      title: LocaleKeys.vehicleBrand.localize,
                                      items: cubit.carBrandData.map((e) => e.brandNameEn).toList(),
                                      selectedItem: selectedBrand,
                                      onSelected: (value) async {
                                        final selectedBrandEntity = cubit.carBrandData.firstWhere(
                                          (e) => e.brandNameEn == value,
                                        );
                                        setState(() {
                                          selectedBrand = selectedBrandEntity.brandNameEn;
                                          selectedBrandId = selectedBrandEntity.id;
                                          selectedModel = null;
                                          carModels.clear();
                                          isModelLoading = true;
                                        });
                                        try {
                                          await cubit.loadInitialCarModelLoading(brandId: selectedBrandEntity.id);
                                          setState(() {
                                            carModels = cubit.carModelData.map((e) => e.modelEn).toList();
                                            isModelLoading = false;
                                          });
                                        } catch (error) {
                                          setState(() {
                                            isModelLoading = false;
                                            carModels.clear();
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Failed to load car models')),
                                          );
                                        }
                                      },
                                      isPaginated: true,
                                      canOpen: true,
                                    ),
                                    const Sizer(),
                                    isModelLoading
                                        ? Expanded(
                                            child: Container(
                                              height: 48.h,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30.h),
                                                color: AppColors.getFillColor(context),
                                              ),
                                              child: Center(child: CircularProgressIndicator()),
                                            ),
                                          )
                                        : _buildMenuButton(
                                            title: LocaleKeys.vehicleModel.localize,
                                            items: carModels,
                                            selectedItem: selectedModel,
                                            onSelected: (value) {
                                              final selectedModelEntity = context.read<ViewAllTripJoinCubit>().carModelData.firstWhere(
                                                    (e) => e.modelEn == value,
                                                  );
                                              setState(() {
                                                selectedModel = value;
                                              });
                                              selectedModelId = selectedModelEntity.id;
                                            },
                                            isPaginated: true,
                                            canOpen: selectedBrandId != null && carModels.isNotEmpty,
                                          ),
                                  ],
                                );
                              },
                            ),
                          ),
                        const Sizer(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.h),
                          child: TripJoinBottomSection(
                            expectedPriceTripEntity: state.expectedPriceEntity,
                            selectedSeatNum: selectedSeatNum,
                            isChecked: isChecked,
                            time: time,
                            onSeatNumChanged: (int? value) {
                              setState(() {
                                selectedSeatNum = value ?? 1;
                              });
                            },
                            onCheckedChanged: (bool? value) {
                              setState(() {
                                isChecked = value ?? false;
                              });
                            },
                            onTimeChanged: (TimeOfDay? newTime) {
                              setState(() {
                                time = newTime;
                              });
                            },
                            formatDistance: _formatDistance,
                            calculateTotalPrice: () => _calculateTotalPrice(state.expectedPriceEntity),
                            getTime: _getTime2,
                          ),
                        ),
                        const Sizer(),
                        // New button to print all data
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.0.h, vertical: 8.h),
                          child: PremiumAndRequestTripWidget(
                            onPremiumPressed: () {
                              bool isTripJoinValid = (phoneController.text.isEmpty ||
                                  selectedBrand == null ||
                                  selectedModel == null ||
                                  selectedSeatNum == null ||
                                  currentLocation == null ||
                                  toLocation == null ||
                                  selectedBrandId == null ||
                                  selectedModelId == null);
                              bool isPickMeValid = (phoneController.text.isEmpty ||
                                  selectedBrand == null ||
                                  selectedModel == null ||
                                  selectedSeatNum == null ||
                                  currentLocation == null ||
                                  toLocation == null);
                              if (widget.isFromPickMe == false ? isTripJoinValid : isPickMeValid) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(LocaleKeys.pleaseFillAllFields.localize),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              final params = CreateTripJoinParams(
                                creatorPhoneNumber: phoneController.text,
                                subcategoryId: "62c8ba9f8e28a58a3edf57ee",
                                isPremium: true,
                                isRepeat: isChecked,
                                passengers: selectedSeatNum!,
                                vehicleCarBrandId: selectedBrandId!,
                                vehicleModelId: selectedModelId!,
                                startDate: _getTime(),
                                startLongitude: currentLocation![1],
                                startLatitude: currentLocation![0],
                                targetLongitude: toLocation![1],
                                targetLatitude: toLocation![0],
                              );

                              final pickMeParams = CreatePickMeParams(
                                creatorPhoneNumber: phoneController.text,
                                subcategoryId: "62c8ba9f8e28a58a3edf57ee",
                                isPremium: true,
                                isRepeat: isChecked,
                                passengers: selectedSeatNum!,
                                startDate: _getTime(),
                                startLongitude: currentLocation![1],
                                startLatitude: currentLocation![0],
                                targetLongitude: toLocation![1],
                                targetLatitude: toLocation![0],
                              );

                              if (widget.isFromPickMe == false) {
                                context.read<ViewAllTripJoinCubit>().createTripJoinOffer(params, context).then((_) {
                                  // Navigator.pop(context);
                                });
                              } else {
                                context.read<ViewAllTripJoinCubit>().createPickMeOffer(pickMeParams, context).then((_) {
                                  // Navigator.pop(context);
                                });
                              }
                            },
                            onNormalPressed: () {
                              bool isTripJoinValid = (phoneController.text.isEmpty ||
                                  selectedBrand == null ||
                                  selectedModel == null ||
                                  selectedSeatNum == null ||
                                  currentLocation == null ||
                                  toLocation == null ||
                                  selectedBrandId == null ||
                                  selectedModelId == null);
                              bool isPickMeValid = (phoneController.text.isEmpty ||
                                  selectedSeatNum == null ||
                                  currentLocation == null ||
                                  toLocation == null);
                              print("""
                              selectedBrand $selectedBrand
                              selectedModel $selectedModel
                              selectedSeatNum $selectedSeatNum
                              currentLocation $currentLocation
                              toLocation $toLocation
                              selectedBrandId $selectedBrandId
                              selectedModelId $selectedModelId
                              """);
                              print("isTripJoinValid $isTripJoinValid isPickMeValid $isPickMeValid");
                              if (widget.isFromPickMe == false ? isTripJoinValid : isPickMeValid) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(LocaleKeys.pleaseFillAllFields.localize),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              final params = CreateTripJoinParams(
                                creatorPhoneNumber: phoneController.text,
                                subcategoryId: "62c8ba9f8e28a58a3edf57ee",
                                isPremium: false,
                                isRepeat: isChecked,
                                passengers: selectedSeatNum??0,
                                vehicleCarBrandId: selectedBrandId??'',
                                vehicleModelId: selectedModelId??'',
                                startDate: _getTime(),
                                startLongitude: currentLocation?[1]??0,
                                startLatitude: currentLocation?[0]??0,
                                targetLongitude: toLocation?[1]??0,
                                targetLatitude: toLocation?[0]??0,
                              );

                              final pickMeParams = CreatePickMeParams(
                                creatorPhoneNumber: phoneController.text,
                                subcategoryId: "62c8ba9f8e28a58a3edf57ee",
                                isPremium: false,
                                isRepeat: isChecked,
                                passengers: selectedSeatNum??0,
                                startDate: _getTime(),
                                startLongitude: currentLocation?[1]??0,
                                startLatitude: currentLocation?[0]??0,
                                targetLongitude: toLocation?[1]??0,
                                targetLatitude: toLocation?[0]??0,
                              );

                              if (widget.isFromPickMe == false) {
                                context.read<ViewAllTripJoinCubit>().createTripJoinOffer(params, context).then((_) {
                                  Navigator.pop(context);
                                });
                              } else {
                                context.read<ViewAllTripJoinCubit>().createPickMeOffer(pickMeParams, context).then((_) {
                                  Navigator.pop(context);
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _customLocationField({
    required Color color,
    required String? text,
    required bool isTo,
    required Function()? onPressed,
    required BuildContext context,
  }) {
    final displayText = text ?? (isTo ? (context.isArabic ? "إلى" : "To") : (context.isArabic ? "من" : "From"));
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
                child: CircleAvatar(backgroundColor: AppColors.getFillColor(context), radius: 5),
              ),
            ),
            Expanded(
              child: Text(
                displayText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Styles.mediumText(color: AppColors.getTextColor(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopImage() {
    return _buildTopMap(context);
  }

  Widget _buildTopMap(BuildContext context) {
    List<LatLng> routePoints = [];
    routePoints = _convertPolylineToLatLng(context.read<ViewAllTripJoinCubit>().state.expectedPriceEntity?.polyline ?? []);

    LatLng startLocation = LatLng(
      currentLocation?[0] ?? 0,
      currentLocation?[1] ?? 0,
    );

    LatLng targetLocation = LatLng(
      toLocation?[0] ?? 0,
      toLocation?[1] ?? 0,
    );
    print('currentLocation $currentLocation');
    print('toLocation $toLocation');
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.5,
      child: CustomGoogleMap(
        // startLocation: null,
        // targetLocation: null,
        startLocation: (currentLocation == null || (currentLocation?.isEmpty ?? false)) ? null : startLocation,
        targetLocation: (toLocation == null || (toLocation?.isEmpty ?? false)) ? null : targetLocation,
        polylinePoints: routePoints,
        // mapController: _mapController,
        // options: MapOptions(
        //   initialCenter: LatLng(
        //     currentLocation?[0] ?? 30.0596113,
        //     currentLocation?[1] ?? 31.1760625,
        //   ),
        //   initialZoom: 12.0,
        // ),
        // children: [
        //   TileLayer(
        //     // urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
        //     // urlTemplate: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
        //     // urlTemplate: "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png",
        //     urlTemplate: context.isDarkMode
        //         ? "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png" // Dark mode map
        //         : "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png", // Normal mode map
        //     subdomains: const ['a', 'b', 'c'],
        //     userAgentPackageName: 'com.example.app',
        //   ),
        //   MarkerLayer(
        //     markers: [
        //       if (currentLocation != null && currentLocation!.isNotEmpty)
        //         Marker(
        //           point: LatLng(currentLocation![0], currentLocation![1]),
        //           width: 40,
        //           height: 40,
        //           child: const Icon(Icons.location_pin,
        //               color: Colors.blue, size: 40),
        //         ),
        //       if (toLocation != null)
        //         Marker(
        //           point: LatLng(toLocation![0], toLocation![1]),
        //           width: 40,
        //           height: 40,
        //           child: const Icon(Icons.location_pin,
        //               color: Colors.red, size: 40),
        //         ),
        //     ],
        //   ),
        //   if (routePoints.isNotEmpty)
        //     PolylineLayer(
        //       polylines: [
        //         Polyline(
        //           points: routePoints,
        //           color: context.isDarkMode ? Colors.blue : Colors.black87,
        //           strokeWidth: 4.0,
        //         ),
        //       ],
        //     ),
        // ],
      ),
    );
  }

  List<LatLng> _convertPolylineToLatLng(List<List<double>> polyline) {
    return polyline.map((point) => LatLng(point[0], point[1])).toList();
  }

  Widget _buildMenuButton({
    required String title,
    required List items,
    required String? selectedItem,
    required void Function(String) onSelected,
    bool isPaginated = false,
    bool canOpen = true,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32.h, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.h),
          color: AppColors.getFillColor(context),
          border: !canOpen ? Border.all(color: Colors.grey.withOpacity(0.3)) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedItem ?? title,
              style: Styles.mediumText(
                color: canOpen ? AppColors.getTextColor(context) : AppColors.getTextColor(context).withOpacity(0.5),
              ),
            ),
            GestureDetector(
              child: Icon(
                Icons.keyboard_arrow_down,
                color: canOpen ? AppColors.getTextColor(context) : AppColors.getTextColor(context).withOpacity(0.5),
              ),
              onTap: () {
                ManageVibration.vibrate();
                if (!canOpen) {
                  showSuccessMessage(context, LocaleKeys.emptyFieldNotValid.localize);
                  return;
                }
                if (isPaginated) {
                  if (title == LocaleKeys.vehicleBrand.localize) {
                    _showPaginatedBrandDropdownMenu(context: context, onSelected: onSelected);
                  } else if (title == LocaleKeys.vehicleModel.localize) {
                    _showPaginatedModelDropdownMenu(context: context, onSelected: onSelected);
                  }
                } else {
                  _showDropdownMenu(
                    onSelected: onSelected,
                    context: context,
                    position: Offset(0, 0),
                    items: items,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPaginatedBrandDropdownMenu({
    required BuildContext context,
    required void Function(String) onSelected,
  }) {
    final cubit = context.read<ViewAllTripJoinCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        ScrollController scrollController = ScrollController();
        scrollController.addListener(() {
          if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
            cubit.getCarBrandLoading();
          }
        });
        return SizedBox(
          height: MediaQuery.of(bottomSheetContext).size.height * 0.5,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  LocaleKeys.selectCarBrand.localize,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(
                  bloc: cubit,
                  builder: (context, state) {
                    final brands = cubit.carBrandData.map((e) => e.brandNameEn).toList();
                    if (state.status == ViewAllTripJoinStatus.loading && brands.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (brands.isEmpty) {
                      return Center(child: Text(LocaleKeys.noData.localize));
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: brands.length + (cubit.isLoadingMoreCarBrandLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= brands.length) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        final brand = brands[index];
                        return ListTile(
                          title: Text(brand),
                          onTap: () {
                            ManageVibration.vibrate();
                            Navigator.pop(bottomSheetContext);
                            onSelected(brand);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPaginatedModelDropdownMenu({
    required BuildContext context,
    required void Function(String) onSelected,
  }) {
    final cubit = context.read<ViewAllTripJoinCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        ScrollController scrollController = ScrollController();
        scrollController.addListener(() {
          if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
            if (selectedBrandId != null) {
              cubit.getCarModelLoading(brandId: selectedBrandId!);
            }
          }
        });
        return SizedBox(
          height: MediaQuery.of(bottomSheetContext).size.height * 0.5,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  LocaleKeys.selectCarModel.localize,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(
                  bloc: cubit,
                  builder: (context, state) {
                    final models = cubit.carModelData.map((e) => e.modelEn).toList();
                    if (cubit.isLoadingCarModelLoading && models.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (models.isEmpty) {
                      return Center(child: Text(LocaleKeys.noData.localize));
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: models.length + (cubit.isLoadingMoreCarModelLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= models.length) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        final model = models[index];
                        return ListTile(
                          title: Text(model),
                          onTap: () {
                            ManageVibration.vibrate();
                            Navigator.pop(bottomSheetContext);
                            onSelected(model);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDropdownMenu({
    required BuildContext context,
    required void Function(String) onSelected,
    required Offset position,
    required List items,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item),
                onTap: () {
                  ManageVibration.vibrate();
                  Navigator.pop(context);
                  onSelected(item);
                },
              );
            },
          ),
        );
      },
    );
  }
}

class EgyptianPhoneFormatter extends TextInputFormatter {
  static final _validPrefix = RegExp(r'^01[0125]');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Allow empty input (so user can start typing)
    if (text.isEmpty) return newValue;

    // Only digits
    if (!RegExp(r'^\d*$').hasMatch(text)) return oldValue;

    // Limit to 11 digits (handled by LengthLimitingTextInputFormatter but just in case)
    if (text.length > 11) return oldValue;

    // Must start with 010, 011, 012, or 015
    if (!_validPrefix.hasMatch(text)) {
      if (text.length <= 3) return newValue; // let user finish typing prefix
      return oldValue;
    }

    return newValue;
  }
}
