import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/dynamic_map_test.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/get_current_location_driver.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_destination_point_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_starting_point_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_trip_info_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_trip_reel_time_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/destination_text_field_and_find_ride_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/start_text_field_and_find_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapAndAddressFinderRide extends StatefulWidget {
  const MapAndAddressFinderRide({super.key});

  @override
  State<MapAndAddressFinderRide> createState() =>
      _MapAndAddressFinderRideState();
}

class _MapAndAddressFinderRideState extends State<MapAndAddressFinderRide> {
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
      await context.read<GetStartingPointRideCubit>().getStartingPoint(
            address: "",
            isFirstTime: true,
            lat: position.latitude,
            long: position.longitude,
            platformType: "google",
          );
    } catch (e) {
      print('Error fetching current location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const GoogleMapViewAddres(),
        BlocBuilder<GetDestinationPointRideCubit, RiderState>(
          builder: (context, destState) {
            if (destState is SuccessGetDestinationPointState &&
                BlocProvider.of<GetStartingPointRideCubit>(context).startLat !=
                    null &&
                BlocProvider.of<GetStartingPointRideCubit>(context).startLong !=
                    null &&
                BlocProvider.of<GetDestinationPointRideCubit>(context).endLat !=
                    null &&
                BlocProvider.of<GetDestinationPointRideCubit>(context)
                        .endLong !=
                    null) {
              context.read<GetTripInfoCubit>().getTripInfoRequest(
                  subCateogryId:
                      context.read<RiderTripReelTimeCubit>().subCategory?.id ??
                          "",
                  startLatLng: LatLng(
                      BlocProvider.of<GetStartingPointRideCubit>(context)
                          .startLat!,
                      BlocProvider.of<GetStartingPointRideCubit>(context)
                          .startLong!),
                  destinationLatLng: LatLng(
                      BlocProvider.of<GetDestinationPointRideCubit>(context)
                          .endLat!,
                      BlocProvider.of<GetDestinationPointRideCubit>(context)
                          .endLong!));
              print("i am in first case \n");

              return BlocBuilder<GetTripInfoCubit, RiderState>(
                builder: (context, state) {
                  if (state is SuccessGetTripInfoState) {
                    return SizedBox(
                      height: 200,
                      child: DynamicMapWithPolyline(
                        polylineString: state.model.polyline,
                        useGoogleMaps: destIsGoogleMap(context),
                        url: getMapUrl(context, isStart: false),
                        apiKey: getApiKey(context, isStart: false),
                      ),
                    );
                  }
                  return SizedBox(
                    height: 200,
                    child: DynamicMapWithPolyline(
                      url: getDefaultMapUrl(),
                      apiKey: getDefaultApiKey(),
                    ),
                  );
                },
              );
            }
            if (destState is SuccessGetDestinationPointState &&
                BlocProvider.of<GetStartingPointRideCubit>(context).startLat ==
                    null &&
                BlocProvider.of<GetStartingPointRideCubit>(context).startLong ==
                    null) {
              print("i am in secound case \n");
              return SizedBox(
                height: 200,
                child: DynamicMapWithPolyline(
                  useGoogleMaps: destIsGoogleMap(context),
                  latitude:
                      BlocProvider.of<GetDestinationPointRideCubit>(context)
                          .endLat,
                  longitude:
                      BlocProvider.of<GetDestinationPointRideCubit>(context)
                          .endLong,
                  url: getMapUrl(context, isStart: false),
                  apiKey: getApiKey(context, isStart: false),
                ),
              );
            }
            return BlocBuilder<GetStartingPointRideCubit, RiderState>(
              builder: (context, startState) {
                if (startState is SuccessGetStartingPointState &&
                    BlocProvider.of<GetDestinationPointRideCubit>(context)
                            .endLat !=
                        null &&
                    BlocProvider.of<GetDestinationPointRideCubit>(context)
                            .endLong !=
                        null) {
                  print("i am in third case \n");
                  context.read<GetTripInfoCubit>().getTripInfoRequest(
                      subCateogryId: context
                              .read<RiderTripReelTimeCubit>()
                              .subCategory
                              ?.id ??
                          "",
                      startLatLng: LatLng(
                          BlocProvider.of<GetStartingPointRideCubit>(context)
                              .startLat!,
                          BlocProvider.of<GetStartingPointRideCubit>(context)
                              .startLong!),
                      destinationLatLng: LatLng(
                          BlocProvider.of<GetDestinationPointRideCubit>(context)
                              .endLat!,
                          BlocProvider.of<GetDestinationPointRideCubit>(context)
                              .endLong!));
                  return BlocBuilder<GetTripInfoCubit, RiderState>(
                    builder: (context, state) {
                      if (state is SuccessGetTripInfoState) {
                        return SizedBox(
                          height: 200,
                          child: DynamicMapWithPolyline(
                            polylineString: state.model.polyline,
                            // polylineString:
                            //     BlocProvider.of<GetPriceCarpoolCubit>(context)
                            //         .carpoolRouteInfoModel
                            //         ?.polyline,
                            useGoogleMaps: isGoogleMap(context),
                            url: getMapUrl(context, isStart: true),
                            apiKey: getApiKey(context, isStart: true),
                          ),
                        );
                      }
                      return SizedBox(
                        height: 200,
                        child: DynamicMapWithPolyline(
                          url: getDefaultMapUrl(),
                          apiKey: getDefaultApiKey(),
                        ),
                      );
                    },
                  );
                }
                if (startState is SuccessGetStartingPointState &&
                        BlocProvider.of<GetDestinationPointRideCubit>(context)
                                .endLat ==
                            null ||
                    BlocProvider.of<GetDestinationPointRideCubit>(context)
                            .endLat ==
                        0) {
                  print("i am in fourth case \n");

                  return SizedBox(
                    height: 200,
                    child: DynamicMapWithPolyline(
                      useGoogleMaps: isGoogleMap(context),
                      latitude:
                          BlocProvider.of<GetStartingPointRideCubit>(context)
                              .startLat,
                      longitude:
                          BlocProvider.of<GetStartingPointRideCubit>(context)
                              .startLong,
                      url: getMapUrl(context, isStart: true),
                      apiKey: getApiKey(context, isStart: true),
                    ),
                  );
                }
                print("i am in fifth case \n");

                return SizedBox(
                  height: 200,
                  child: DynamicMapWithPolyline(
                    url: getDefaultMapUrl(),
                    apiKey: getDefaultApiKey(),
                  ),
                );
              },
            );
          },
        ),
        const Sizer(height: 20),
        const StartTextFieldAndFindWidget(),
        const Sizer(height: 20),
        const DestinationTextFieldAndFindRideWidget(),
      ],
    );
  }

  bool isGoogleMap(BuildContext context) {
    return BlocProvider.of<GetStartingPointRideCubit>(context).type == "google";
  }

  bool destIsGoogleMap(BuildContext context) {
    return BlocProvider.of<GetDestinationPointRideCubit>(context).type ==
        "google";
  }

  String getMapUrl(BuildContext context, {required bool isStart}) {
    final type = isStart
        ? BlocProvider.of<GetStartingPointRideCubit>(context).type
        : BlocProvider.of<GetDestinationPointRideCubit>(context).type;
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

  String getApiKey(BuildContext context, {required bool isStart}) {
    final type = isStart
        ? BlocProvider.of<GetStartingPointRideCubit>(context).type
        : BlocProvider.of<GetDestinationPointRideCubit>(context).type;
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
}
