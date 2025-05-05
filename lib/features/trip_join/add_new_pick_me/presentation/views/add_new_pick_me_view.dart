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
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/create_ad_widgets/trip_join_ad_buttons.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/create_ad_widgets/trip_join_bottom_section.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/infoButton.dart';

import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../common/widgets/form/text_fields/new_phone_number_text_field.dart';
import '../../../../../routes/routes.dart';
import '../../../../RideFeature/presentation/pages/osm_search_and_pick.dart';

class AddNewPickMeView extends StatefulWidget {
  const AddNewPickMeView({super.key});

  @override
  State<AddNewPickMeView> createState() => _AddNewPickMeViewState();
}

class _AddNewPickMeViewState extends State<AddNewPickMeView> {
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
    return SharedScaffold(
        mainCategoryId: 1,isWithBackArrow: true,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.h,vertical:8.h ),
                child: WelcomeTextWidget(
                  title: LocaleKeys.welcome_pick_me.localize,
                  infoMessage:
                  context.isArabic?"انشئ رحلة واضف رحلتك. انتظر أصحاب السيارات للاتصال بك. شارك الرحلة و وفر المال!":"Create a ride & add your trip. wait for car owners to contact you. Share trip & save money!",
                ),
              ),
              _buildTopImage(),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
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
              const Sizer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.h,vertical: 8.h),
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
                child: NewPhoneNumberTextFormField(
                    style: Styles.mediumText(),
                    constraints:
                    const BoxConstraints(maxHeight: 52, minHeight: 52),
                    fillColor: AppColors.colorGreyLight,
                    currentController: phoneController,
                    isRequired: true,
                ),
              ),
              const Sizer(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TripJoinBottomSection(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0.h, vertical: 8.h,),
                child: const PremiumAndRequestWidget(),
              ),
            ],

          ),
        ));
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
                    : text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Styles.mediumText(color: Colors.black),
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
