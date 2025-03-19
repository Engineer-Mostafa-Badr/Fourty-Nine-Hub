import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';
import '../../../../carpool/add_new_route/presentation/widgets/dynamic_map_test.dart';
import '../../../../carpool/avaliable_routes/presentation/widgets/get_current_location_driver.dart';
import '../../../../ride/RideRequest/presentation/widgets/start_text_field_and_find_widget.dart';
import 'bottom_sheet/custom_bottom_sheet.dart';
import 'custom_ride_button.dart';

class MapSection extends StatefulWidget {
  const MapSection({super.key});

  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  @override
  void initState() {
    super.initState();
    _setUserCurrentLocation();
  }

  void _setUserCurrentLocation() async {
    try {
      Position position = await GetCurrentLocationDriver.getCurrentPosition();
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      StartTextFieldAndFindWidget.startingPoint.text = "Your location";
      // await context.read<GetStartingPointRideCubit>().getStartingPoint(
      //       address: "",
      //       isFirstTime: true,
      //       lat: position.latitude,
      //       long: position.longitude,
      //       platformType: "google",
      //     );
    } catch (e) {
      print('Error fetching current location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DynamicMapWithPolyline(
          url: getMapUrl(context, type: "mapBox"),
          apiKey: getApiKey(context, type: "mapBox"),
        ),
        // Image.network(
        //   "https://miro.medium.com/v2/resize:fit:1024/1*lNbCllyMLyiVyGfY-HXHjw.png",
        //   width: double.infinity,
        //   height: MediaQuery.of(context).size.height * 0.4,
        //   fit: BoxFit.cover,
        // ),

        Padding(
          padding: const EdgeInsets.all(16),
          child: CustomRideButton(
            text: LocaleKeys.carTruckRegister.tr(),
            onPressed: () {
              context.push(Routes.rideModeScreen, extra: 'truk');
              // customBottomSheet(context,
              //     child: Padding(
              //       padding: const EdgeInsets.all(12.0),
              //       child: Column(
              //         spacing: 10,
              //         children: [
              //           AppButton(
              //               radius: 15,
              //               label: LocaleKeys.ride.tr(),
              //               onPressed: () {
              //                 context.push(Routes.welcomeRideRegister);
              //               },
              //               backColor: AppColors.PRIMARY_COLOR,
              //               width: double.infinity),
              //           AppButton(
              //               radius: 15,
              //               label: LocaleKeys.shipping.tr(),
              //               onPressed: () {},
              //               backColor: AppColors.PRIMARY_COLOR,
              //               width: double.infinity),
              //         ],
              //       ),
              //     ),
              //     title: '');
            },
          ),
        ),
      ],
    );
  }
}

String getMapUrl(BuildContext context, {required String type}) {
  // final type = isStart
  //     ? BlocProvider.of<GetStartingPointRideCubit>(context).type
  //     : BlocProvider.of<GetDestinationPointRideCubit>(context).type;
  switch (type) {
    case "google":
      return "https://maps.googleapis.com/maps/api/js?key=AIzaSyBBHEFa7D7qMSL4ivZhCqRQ4ok4sQN-Egc";
    case "HEREPlatform":
      return "https://1.base.maps.ls.hereapi.com/maptile/2.1/maptile/newest/normal.day/{z}/{x}/{y}/256/png8?apiKey=jdgJA3hOg-0P67s5Xu86joSAajr8W1OX1nC2sL9g-hA";
    case "mapBox":
      return "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=sk.eyJ1IjoiNDlhcHAiLCJhIjoiY20xem83MGQ5MDg3aDJqczhhYnlmMGI1ZSJ9.8sYHBUyxYXncueYcckCBMg";
    case "TomTom":
      return "https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?Key=GR8JEzJYyIFNKqD7WJJ1pfNRpf3Ckiyw";
    default:
      return "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";
  }
}

String getApiKey(BuildContext context, {required String type}) {
  // final type = isStart
  //     ? BlocProvider.of<GetStartingPointRideCubit>(context).type
  //     : BlocProvider.of<GetDestinationPointRideCubit>(context).type;
  switch (type) {
    case "google":
      return "AIzaSyBBHEFa7D7qMSL4ivZhCqRQ4ok4sQN-Egc";
    case "HEREPlatform":
      return "jdgJA3hOg-0P67s5Xu86joSAajr8W1OX1nC2sL9g-hA";
    case "mapBox":
      return "sk.eyJ1IjoiNDlhcHAiLCJhIjoiY20xem83MGQ5MDg3aDJqczhhYnlmMGI1ZSJ9.8sYHBUyxYXncueYcckCBMg";
    case "TomTom":
      return "GR8JEzJYyIFNKqD7WJJ1pfNRpf3Ckiyw";
    default:
      return "5b3ce3597851110001cf6248d06d230ff17942299e5608fa3709ced9";
  }
}

String getDefaultMapUrl() {
  return "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";
}

String getDefaultApiKey() {
  return "5b3ce3597851110001cf6248d06d230ff17942299e5608fa3709ced9";
}
