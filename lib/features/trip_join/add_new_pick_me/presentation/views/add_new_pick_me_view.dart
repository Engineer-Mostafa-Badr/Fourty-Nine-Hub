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
import '../../../../RideFeature/presentation/pages/osm_search_and_pick.dart';

class AddNewPickMeView extends StatefulWidget {
  const AddNewPickMeView({super.key});

  @override
  State<AddNewPickMeView> createState() => _AddNewPickMeViewState();
}

class _AddNewPickMeViewState extends State<AddNewPickMeView> {
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
    return SafeArea(
        child: SharedScaffold(
            mainCategoryId: 1,isWithBackArrow: false,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: WelcomeTextWidget(
                        title: LocaleKeys.welcome_pick_me.localize,
                        infoMessage:
                        "Create a ride &add your trip. wait for car owners to contact you. Share trip & save money!",
                      ),
                    ),
                    const Sizer(),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
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
                    const Sizer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FormTextField(
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
                    ),
                    const Sizer(),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TripJoinBottomSection(),
                    ),
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

  // _buildMenuButton(
  //     {required String title, required List items, required var selectedItem}) {
  //   return Expanded(
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 32.h, vertical: 16.h),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(30.h),
  //         color: AppColors.colorGreyLight,
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             selectedItem ?? title,
  //             style: Styles.mediumText(),
  //           ),
  //           GestureDetector(
  //             child: const Icon(Icons.keyboard_arrow_down),
  //             onTapDown: (details) => _showDropdownMenu(
  //               context: context,
  //               position: details.globalPosition,
  //               items: items,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
