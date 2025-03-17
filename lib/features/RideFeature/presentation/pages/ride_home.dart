import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/expired_trips_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/osm_search_and_pick.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/running_trips_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/bottom_sheet/custom_reserve_ride_bottomsheet.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:latlong2/latlong.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'widgets/add_stops_widget.dart';
import 'widgets/bottom_sheet/custom_bottom_sheet.dart';
import 'widgets/country_dropdown.dart';
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
  String? _selectedCategoryType = "ride"; // Initially "ride"
  int? _selectedCategoryIndex = 0; // Initially selecting the first category
  // String? _selectedCountry;
  final MapController _mapController = MapController();


  @override
  void initState() {
    super.initState();
    // _country = CountryPickerUtils.getCountryByName('Egypt');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rideCubit = context.read<RideCubit>();
      if (!rideCubit.isClosed) {
        rideCubit.fetchRideCategories(UserCubit.to.state.data?.id ?? "");
        rideCubit.fetchShippingCategories(UserCubit.to.state.data?.id ?? "");
        rideCubit.fetchRideGovernorates();
      }
    });
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


  @override
  Widget build(BuildContext context) {
    // _selectedCountry = context.isArabic ? 'القاهرة' : 'Cairo';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SharedScaffold(
            mainCategoryId: 2,
            body: NestedAppbar(
              scrollController: _scrollController,
              appBars: const [],
              body: Stack(
                children: [
                  _buildTopImage(),
                  _buildBottomSheet(),
                  _carTruckBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildTopMap(RideState state, BuildContext context) {
  //   return SizedBox(
  //     width: double.infinity,
  //     height: MediaQuery.of(context).size.height * 0.4,
  //     child: FlutterMap(
  //       options: MapOptions(
  //         initialCenter: LatLng(
  //           state.currentLocation?.lat ?? 0.0,
  //           state.currentLocation?.lng ?? 0.0,
  //         ),
  //         initialZoom: 12.0,
  //       ),
  //       children: [
  //         TileLayer(
  //           urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
  //         ),
  //         MarkerLayer(
  //           markers: [
  //             if (state.currentLocation != null)
  //               Marker(
  //                 point: LatLng(state.currentLocation!.lat!, state.currentLocation!.lng!),
  //                 width: 40,
  //                 height: 40,
  //                 child: const Icon(Icons.location_pin, color: Colors.blue, size: 40),
  //               ),
  //             if (state.toLocation != null)
  //               Marker(
  //                 point: LatLng(state.toLocation!.lat!, state.toLocation!.lng!),
  //                 width: 40,
  //                 height: 40,
  //                 child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
  //               ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTopMap(RideState state, BuildContext context) {
    List<LatLng> routePoints = _convertPolylineToLatLng(state.rideExpectedPrice?.polyline ?? []);

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
      height: MediaQuery.of(context).size.height * 0.5,
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
          ),
          MarkerLayer(
            markers: [
              if (state.currentLocation != null)
                Marker(
                  point: LatLng(state.currentLocation!.lat!, state.currentLocation!.lng!),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin, color: Colors.blue, size: 40),
                ),
              if (state.toLocation != null)
                Marker(
                  point: LatLng(state.toLocation!.lat!, state.toLocation!.lng!),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                ),
              if (state.wayPointOne != null)
                Marker(
                  point: LatLng(state.wayPointOne!.lat!, state.wayPointOne!.lng!),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin, color: Colors.green, size: 40),
                ),
              if (state.wayPointTwo != null)
                Marker(
                  point: LatLng(state.wayPointTwo!.lat!, state.wayPointTwo!.lng!),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin, color: Colors.green, size: 40),
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

  Widget _carTruckBtn(){
    return GestureDetector(
      onTap: () {
        customBottomSheet(context,
            context.read<RideCubit>(),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                spacing: 10,
                children: [
                  AppButton(
                      radius: 15,
                      label: LocaleKeys.ride.tr(),
                      onPressed: () {
                        if(context.isUserLoggedIn){
                        context.push(Routes.welcomeRideRegister);
                        }
                        else{
                          context.push(Routes.LOGIN);
                        }
                      },
                      backColor: AppColors.PRIMARY_COLOR,
                      width: double.infinity),
                  AppButton(
                      radius: 15,
                      label: LocaleKeys.shipping.tr(),
                      onPressed: () {
                        if(context.isUserLoggedIn){
                          // context.push(Routes.welcomeShippingRegister);
                        }
                        else{
                          context.push(Routes.LOGIN);
                        }
                      },
                      backColor: AppColors.PRIMARY_COLOR,
                      width: double.infinity),
                ],
              ),
            ),
            title: '');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        height: 40,
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
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildTopImage() {
    return BlocBuilder<RideCubit, RideState>(
      builder: (context, state) {
        return Builder(
          builder: (context) {
            return Stack(
              children: [
                _buildTopMap(state, context),
              ],
            );
          }
        );
      }
    );
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
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16.0, start: 16.0),
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
                        onTap: (){
                          if(context.isUserLoggedIn){
                          }
                          else{
                            context.push(Routes.LOGIN);
                          }
                        },
                        child: _tripsWidget(context.isArabic? "طلبات الرحلات": "Ride Requests", color: const Color(0xffD9D9D9))),
                  ),
                ),
                Expanded(
                  child: Badge(
                    backgroundColor: AppColors.PRIMARY_COLOR_DARK,
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(2),
                    label: const Text('1K'),
                    isLabelVisible: true,
                    child: ClickableWidget(
                        onTap: (){
                          if(context.isUserLoggedIn){
                          }
                          else{
                            context.push(Routes.LOGIN);
                          }
                        },
                        child: _tripsWidget(context.isArabic? "طلبات التحميل": "Loading Requests", color: const Color(0xffD9D9D9))),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16.0, start: 16.0, bottom: 16),
            child: Row(
              spacing: 6,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: ClickableWidget(
                      onTap: (){
                        if(context.isUserLoggedIn){
                          context.push(Routes.RIDEACTIVITY);
                        }
                        else{
                          context.push(Routes.LOGIN);
                        }
                      },
                      child: _tripsWidget(LocaleKeys.activity.tr(), color: AppColors.GREYCARD)),
                ),
                Expanded(
                  child: ClickableWidget(
                      onTap: (){
                          context.push(Routes.RIDERUNNINGTRIPS, extra: RunningTripParams(
                            rideCubit: context.read<RideCubit>(),
                          ));

                      },
                      child: _tripsWidget(LocaleKeys.runningTrips.tr(), color: AppColors.GREYCARD)),
                ),
                Expanded(
                  child: ClickableWidget(
                      onTap: (){
                          context.push(Routes.RIDEEXPIREDTRIPE, extra: ExpiredTripsScreenParams(
                            rideCubit: context.read<RideCubit>(),
                          ));
                      },
                      child: _tripsWidget(LocaleKeys.expiredTrips.tr(), color: AppColors.GREYCARD)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 16, top: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: BlocBuilder<RideCubit, RideState>(
              builder: (context, state) {
                return Column(
                  spacing: 8,
                  children: [
                    _buildCategoryList(
                        "ride", state.rideCategory?.subCategories ?? []),
                    _buildCategoryList(
                        "shipping", state.shippingCategory?.subCategories ?? []
                    ),
                    _customLocationField(
                      isTo: false,
                      color: Colors.green,
                      text: state.currentLocation?.address,
                      onPressed: ()async {
                        context.push(Routes.RIDEOPENSTREETMAPSEARCHANDPICK, extra: RideOpenStreetMapSearchAndPickParams(
                          rideCubit: context.read<RideCubit>(),
                          isFrom: true,
                        ));
                      },
                    ),
                    _customLocationField(
                      isTo: true,
                      color: Colors.blue,
                      text: state.toLocation?.address,
                      onPressed: ()async {
                        context.push(Routes.RIDEOPENSTREETMAPSEARCHANDPICK, extra: RideOpenStreetMapSearchAndPickParams(
                          rideCubit: context.read<RideCubit>(),
                          isTo: true,
                        ));
                      },
                    ),

                    _fareField(),
                    SizedBox(
                      height: 40,
                      child: Row(
                        spacing: 6,
                        children: [
                          Expanded(
                              flex: 2,
                              child: AppButton(
                                  radius: 15,
                                  label: LocaleKeys.premiumRequest.tr(),
                                  onPressed: () {
                                    if(context.isUserLoggedIn){
                                      SubscriptionMethod().subscribe(
                                          subscribeId: state.rideCategory?.subCategories[_selectedCategoryIndex!].subCategoryId ?? '',
                                          showRegular:false,
                                          title: LocaleKeys.premiumRequest.localize);
                                    }
                                    else{
                                      context.push(Routes.LOGIN);
                                    }
                                  },
                                  backColor: AppColors.SECONDARY_COLOR_DARK2,
                                  width: MediaQuery.of(context).size.width)),
                          Expanded(
                              flex: 2,
                              child: AppButton(
                                  radius: 15,
                                  label: LocaleKeys.request.tr(),
                                  onPressed: () async {
                                    if(context.isUserLoggedIn){
                                      showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  backgroundColor: Colors.transparent,
                                                  builder: (context) => CustomReserveRideBottomSheet (rideCubit: context.read<RideCubit>(), selectedCategoryId: state.rideCategory?.subCategories[_selectedCategoryIndex!].subCategoryId ?? '',),
                                                );
                                    }
                                    else{
                                      context.push(Routes.LOGIN);
                                    }
                                  },
                                  backColor: AppColors.PRIMARY_COLOR,
                                  width: MediaQuery.of(context).size.width)),
                        ],
                      ),
                    )
                  ],
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
          color: color,
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
                final bool isSelected =
                    _selectedCategoryType == type && _selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedCategoryType == type && _selectedCategoryIndex == index) {
                        _selectedCategoryType = null;
                        _selectedCategoryIndex = null;
                      } else {
                        _selectedCategoryType = type;
                        _selectedCategoryIndex = 0;
                        subCategories.insert(0, subCategories.removeAt(index));
                      }
                    });
                  },
                  child: _categoryItem(
                      context.isArabic ? subCategory.subCategoryNameAr : subCategory.subCategoryNameEn,
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

  Widget _customLocationField(
      {
        required Color color,
        required String? text,
        required bool isTo,
        required Function()? onPressed,
      }) {
    if (text == null) {
      if (isTo == true) {
        text = 'To';
      }
      else{
        text = 'From';
      }
    }

    return BlocBuilder<RideCubit, RideState>(
      builder: (context, state) {
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
                  child: Text(text == 'From' ? context.isArabic? "من": "From" : text == 'To' ? context.isArabic? "إلى": "To": text!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isTo == true && text != 'To')
                  GestureDetector(
                    onTap: () {
                      customBottomSheet(context,
                          context.read<RideCubit>(),
                          child: AddStopsWidget(
                            rideCubit: context.read<RideCubit>(),
                          ), title: context.isArabic ? 'إضافة موقع' : 'Add Stops');
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
      }
    );
  }


  Widget _fareField() {
    return BlocBuilder<RideCubit, RideState>(
      builder: (context, state) {
        String selectedCategoryName = "Captain";
        double selectedCategoryPrice = 0.0;
        if (_selectedCategoryType == "ride") {
         selectedCategoryName = state.rideCategory?.subCategories[_selectedCategoryIndex!].subCategoryNameEn ?? "";
        }
        else{
          selectedCategoryName = state.shippingCategory?.subCategories[_selectedCategoryIndex!].subCategoryNameEn ?? "";
        }
        if (selectedCategoryName == "Captain") {
          selectedCategoryPrice = state.rideExpectedPrice?.priceForCaptain ?? 0.0;
        }
        else if (selectedCategoryName == "Scooter") {
          selectedCategoryPrice = state.rideExpectedPrice?.priceForScooter ?? 0.0;
        }
        else if (selectedCategoryName == "Taxi") {
          selectedCategoryPrice = state.rideExpectedPrice?.priceForTaxi ?? 0.0;
        }
        else if (selectedCategoryName == "Suv") {
          selectedCategoryPrice = state.rideExpectedPrice?.priceForSUV ?? 0.0;
        }
        return GestureDetector(
          onTap: () {
            customBottomSheet(context,
                context.read<RideCubit>(),
                child:  Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: FareBottomSheetWidget(
                    rideCubit: context.read<RideCubit>(),
                    selectedCategoryPrice: selectedCategoryPrice,
                    selectedCategoryName: selectedCategoryName,
                  ),
                ),
                title: LocaleKeys.offerYourFare.tr());
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
                      color: AppColors.GREYFIELD,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      spacing: 10,
                      children: [
                        Text(LocaleKeys.egp.tr(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                        state.rideExpectedPrice != null ? Text(selectedCategoryPrice.toInt().toString()) : Text(LocaleKeys.offerYourFare.tr()),
                        const Spacer(),
                        Image.asset('assets/icons/edit.png'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      customBottomSheet(context,
                          context.read<RideCubit>(),
                          child:  OptionsBottomsheetWidget(
                            rideCubit: context.read<RideCubit>(),
                            selectedCategoryName: selectedCategoryName,
                            selectedCategoryPrice: selectedCategoryPrice,
                          ),
                          title: LocaleKeys.options.tr());
                    },
                    child: SizedBox(
                      height: 25,
                      child: Image.asset('assets/icons/option.png'),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
