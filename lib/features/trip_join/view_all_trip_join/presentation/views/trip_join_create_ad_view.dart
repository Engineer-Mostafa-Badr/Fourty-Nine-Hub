import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/create_ad_widgets/create_ad_location_button.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/create_ad_widgets/trip_join_ad_buttons.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/create_ad_widgets/trip_join_bottom_section.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/infoButton.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../common/widgets/form/text_fields/form_text_field.dart';

class TripJoinCreateAdView extends StatefulWidget {
  const TripJoinCreateAdView({super.key});

  @override
  State<TripJoinCreateAdView> createState() => _TripJoinCreateAdViewState();
}

class _TripJoinCreateAdViewState extends State<TripJoinCreateAdView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedBrand;
  String? selectedModel;
  int? selectedSeatNum;
  bool isChecked = false;
  TimeOfDay? time;
  List<String> carBrands = [
    'Alfa Romeo',
    'Aston Martin',
    'Audi',
    'BMW',
    'Baic',
    'Bestune',
    'Brilliance',
    'Buick',
  ];
  List<String> countries = [
    'Egypt',
    'United States',
    'UAE',
    'Jordan',
    'England',
    'France',
  ];
  List<String> carModels = [
    'A1',
    'MZ 40',
    'X3',
  ];
  int seatNum = 1;
  var phoneController = TextEditingController();
  String? selectedCountry;
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SharedScaffold(
            mainCategoryId: 1,isWithBackArrow: false,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WelcomeTextWidget(
                      title: LocaleKeys.welcomeToTripjoin.localize,
                      infoMessage:
                          "Create Ad for a trip with your car, wait users to contact you. Share trip & gain money!",
                    ),
                    const Sizer(),
                    _buildTopImage(),
                    const Sizer(),
                    const Sizer(),
                    StartTextFieldAndFindButton(
                      hint: LocaleKeys.from.localize,
                      iconColor: AppColors.CHECK_MARK_COLOR,
                    ),
                    const Sizer(),
                    StartTextFieldAndFindButton(
                      hint: LocaleKeys.to.localize,
                      iconColor: AppColors.LIGHT_BLUE,
                    ),
                    const Sizer(),
                    FormTextField(
                        type: TextInputType.phone,
                        height: 76.h,
                        style: Styles.mediumText(),
                        constraints:
                            const BoxConstraints(maxHeight: 52, minHeight: 52),
                        fillColor: AppColors.colorGreyLight,
                        borderRadius: BorderRadius.circular(30.h),
                        controller: phoneController,
                        hint: LocaleKeys.phoneNumber.localize,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return LocaleKeys
                                .please_enter_phone_number.localize;
                          }
                          return null;
                        }),
                    const Sizer(),
                    Row(
                      children: [
                        _buildMenuButton(
                            title: LocaleKeys.vehicleBrand.localize,
                            items: carBrands,
                            selectedItem: selectedBrand),
                        const Sizer(),
                        _buildMenuButton(
                            title: LocaleKeys.vehicleModel.localize,
                            items: carModels,
                            selectedItem: selectedModel),
                      ],
                    ),
                    const Sizer(),
                    const TripJoinBottomSection(),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0.h, bottom: 20.h),
                      child: const PremiumAndRequestWidget(),
                    ),
                  ],
                ),
              ),
            )));
  }

  void _showDropdownMenu({
    required BuildContext context,
    required Offset position,
    required List items,
  }) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final selected = await showMenu<String>(
      color: AppColors.colorGreyLight,
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        overlay.size.width - position.dx,
        overlay.size.height - position.dy,
      ),
      items: items
          .map((brand) => PopupMenuItem<String>(
                value: brand,
                child: Text(brand),
              ))
          .toList(),
    );

    if (selected != null) {}
  }

  _buildMenuButton(
      {required String title, required List items, required var selectedItem}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32.h, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.h),
          color: AppColors.colorGreyLight,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedItem ?? title,
              style: Styles.mediumText(),
            ),
            GestureDetector(
              child: const Icon(Icons.keyboard_arrow_down),
              onTapDown: (details) => _showDropdownMenu(
                context: context,
                position: details.globalPosition,
                items: items,
              ),
            ),
          ],
        ),
      ),
    );
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
          : MediaQuery.of(context).size.height * 0.3,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(
            state.currentLocation?.lat ?? 30.0444,
            state.currentLocation?.lng ?? 31.2357,
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
