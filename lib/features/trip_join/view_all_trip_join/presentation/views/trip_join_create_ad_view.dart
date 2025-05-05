import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/osm_search_and_pick.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/create_ad_widgets/create_ad_location_button.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/create_ad_widgets/trip_join_ad_buttons.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/create_ad_widgets/trip_join_bottom_section.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/infoButton.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../routes/routes.dart';

class TripJoinCreateAdView extends StatefulWidget {
  const TripJoinCreateAdView({super.key});

  @override
  State<TripJoinCreateAdView> createState() => _TripJoinCreateAdViewState();
}

class _TripJoinCreateAdViewState extends State<TripJoinCreateAdView> {
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

  List<double>? currentLocation;
  List<double>? toLocation;
  String? currentAddress;
  String? toAddress;

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
        mainCategoryId: 1,
        isWithBackArrow: true,
        body: Padding(
          padding: const EdgeInsets.symmetric(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WelcomeTextWidget(
                    title: LocaleKeys.welcomeToTripjoin.localize,
                    infoMessage: context.isArabic
                        ? " انشئ إعلان لرحلة بسيارتك ، انتظر المستخدمين للاتصال بك. شارك الرحلة واكسب المال!"
                        : "Create Ad for a trip with your car, wait users to contact you. Share trip & gain money!",
                  ),
                ),
                _buildTopImage(),
                const Sizer(),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
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
                            currentLocation = [
                              pickedData.latLong.latitude,
                              pickedData.latLong.longitude
                            ];
                            context.pop();
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
                ),
                const Sizer(),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
                  child: _customLocationField(
                    isTo: true,
                    context: context,
                    color: Colors.blue,
                    text: toAddress,
                    onPressed: () async {
                      context.push(Routes.RIDEOPENSTREETMAPSEARCHANDPICK,
                          extra: RideOpenStreetMapSearchAndPickParams(
                        onPicked: (pickedData) async {
                          toAddress = pickedData.addressName;
                          toLocation = [
                            pickedData.latLong.latitude,
                            pickedData.latLong.longitude
                          ];
                          context.pop();
                          setState(() {});
                        },
                      ));
                    },
                  ),
                ),
                const Sizer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: FormTextField(
                      textStyle: Styles.mediumText(color: AppColors.getTextColor(context)),
                      type: TextInputType.phone,
                      height: 76.h,
                      style: Styles.mediumText(
                          color:
                          AppColors.getTextColor(context)),
                      constraints:
                          const BoxConstraints(maxHeight: 52, minHeight: 52),
                      fillColor: AppColors.getFillColor(context),
                      borderRadius: BorderRadius.circular(30.h),
                      borderColor: AppColors.getFillColor(context),
                      borderSide: AppColors.getFillColor(context),
                      controller: phoneController,
                      hint: LocaleKeys.phoneNumber.localize,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.please_enter_phone_number.localize;
                        }
                        return null;
                      }),
                ),
                const Sizer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: Row(
                    children: [
                      _buildMenuButton(
                          title: LocaleKeys.vehicleBrand.localize,
                          items: carBrands,
                          selectedItem: selectedBrand,
                          onSelected: (value) {
                            setState(() {
                              selectedBrand = value;
                            });
                          }),
                      const Sizer(),
                      _buildMenuButton(
                          title: LocaleKeys.vehicleModel.localize,
                          items: carModels,
                          selectedItem: selectedModel,
                          onSelected: (value) {
                            setState(() {
                              selectedModel = value;
                            });
                          }),
                    ],
                  ),
                ),
                const Sizer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: const TripJoinBottomSection(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.0.h,
                    vertical: 8.h,
                  ),
                  child: const PremiumAndRequestWidget(),
                ),
              ],
            ),
          ),
        ));
  }

  void _showDropdownMenu({
    required BuildContext context,
    required Offset position,
    required List items,
    required void Function(String) onSelected,
  }) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final selected = await showMenu<String>(
      color: AppColors.getFillColor(context),
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
                child: Text(
                  brand,
                  style: Styles.mediumText(
                      color: AppColors.getTextColor(context)),
                ),
              ))
          .toList(),
    );

    if (selected != null) {
      onSelected(selected);
    }
  }

  _buildMenuButton({
    required String title,
    required List items,
    required String? selectedItem,
    required void Function(String) onSelected,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32.h, vertical: 16.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.h),
            color: AppColors.getFillColor(context)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedItem ?? title,
              style: Styles.mediumText(
                  color: AppColors.getTextColor(context)),
            ),
            GestureDetector(
              child: Icon(Icons.keyboard_arrow_down,
                  color: AppColors.getTextColor(context)),
              onTapDown: (details) => _showDropdownMenu(
                onSelected: onSelected,
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
                    backgroundColor: AppColors.getFillColor(context), radius: 5),
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
                  style: Styles.mediumText(
                      color: AppColors.getTextColor(context))),
            ),
          ],
        ),
      ),
    );
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
      height: MediaQuery.of(context).size.height * 0.5,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(
            currentLocation?[0] ?? 30.0596113,
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
                    currentLocation?[0] ?? 0.0,
                    currentLocation?[1] ?? 0.0,
                  ),
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
}
