import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/entities/get_price_carpool_param.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/get_llat_and_long/cubit/cubit/dest_get_lat_and_long_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/get_llat_and_long/cubit/get_lat_and_long_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/get_price_carpool/get_price_carpool_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/dest_text_field_googlemap.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/dynamic_map_test.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/starting_text_field_googlemap.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/welcome_text_car_pool.dart';

class MapAndAddressFinderCarPool extends StatelessWidget {
  const MapAndAddressFinderCarPool({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...welcomeTextCarPool(context),
        BlocBuilder<DestGetLatAndLongCubit, DestGetLatAndLongState>(
          builder: (context, destState) {
            if (destState is DestGetLatAndLongSuccess &&
                BlocProvider.of<GetLatAndLongCubit>(context).startLat != null &&
                BlocProvider.of<GetLatAndLongCubit>(context).startLong !=
                    null &&
                BlocProvider.of<DestGetLatAndLongCubit>(context).endLat !=
                    null &&
                BlocProvider.of<DestGetLatAndLongCubit>(context).endLong !=
                    null) {
              print("i am in first case \n");

              return SizedBox(
                height: 200,
                child: DynamicMapWithPolyline(
                  polylineString: BlocProvider.of<GetPriceCarpoolCubit>(context)
                      .carpoolRouteInfoModel
                      ?.polyline,
                  useGoogleMaps: destIsGoogleMap(context),
                  url: getMapUrl(context, isStart: false),
                  apiKey: getApiKey(context, isStart: false),
                ),
              );
            }
            if (destState is DestGetLatAndLongSuccess &&
                BlocProvider.of<GetLatAndLongCubit>(context).startLat == null &&
                BlocProvider.of<GetLatAndLongCubit>(context).startLong ==
                    null) {
              print("i am in secound case \n");
              return SizedBox(
                height: 200,
                child: DynamicMapWithPolyline(
                  useGoogleMaps: destIsGoogleMap(context),
                  latitude:
                      BlocProvider.of<DestGetLatAndLongCubit>(context).endLat,
                  longitude:
                      BlocProvider.of<DestGetLatAndLongCubit>(context).endLong,
                  url: getMapUrl(context, isStart: false),
                  apiKey: getApiKey(context, isStart: false),
                ),
              );
            }
            return BlocBuilder<GetLatAndLongCubit, GetLatAndLongState>(
              builder: (context, startState) {
                print("i am in zero case \n");
                if (startState is GetLatAndLongSuccess &&
                    BlocProvider.of<DestGetLatAndLongCubit>(context).endLat !=
                        null &&
                    BlocProvider.of<DestGetLatAndLongCubit>(context).endLong !=
                        null) {
                  print("i am in third case \n");

                  return SizedBox(
                    height: 200,
                    child: DynamicMapWithPolyline(
                      polylineString:
                          BlocProvider.of<GetPriceCarpoolCubit>(context)
                              .carpoolRouteInfoModel
                              ?.polyline,
                      useGoogleMaps: isGoogleMap(context),
                      url: getMapUrl(context, isStart: true),
                      apiKey: getApiKey(context, isStart: true),
                    ),
                  );
                }
                if (startState is GetLatAndLongSuccess &&
                        BlocProvider.of<DestGetLatAndLongCubit>(context)
                                .endLat ==
                            null ||
                    BlocProvider.of<DestGetLatAndLongCubit>(context).endLat ==
                        0) {
                  print("i am in fourth case \n");

                  return SizedBox(
                    height: 200,
                    child: DynamicMapWithPolyline(
                      useGoogleMaps: isGoogleMap(context),
                      latitude:
                          BlocProvider.of<GetLatAndLongCubit>(context).startLat,
                      longitude: BlocProvider.of<GetLatAndLongCubit>(context)
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
        const StartTextFieldAndFindButonGoogleMap(),
        const Sizer(height: 20),
        const DestinationTextFieldAndFindButonGoogleMap(),
        const Sizer(height: 30),
      ],
    );
  }

  bool isGoogleMap(BuildContext context) {
    return BlocProvider.of<GetLatAndLongCubit>(context).type == "google";
  }

  bool destIsGoogleMap(BuildContext context) {
    return BlocProvider.of<DestGetLatAndLongCubit>(context).type == "google";
  }

  String getMapUrl(BuildContext context, {required bool isStart}) {
    final type = isStart
        ? BlocProvider.of<GetLatAndLongCubit>(context).type
        : BlocProvider.of<DestGetLatAndLongCubit>(context).type;
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
        ? BlocProvider.of<GetLatAndLongCubit>(context).type
        : BlocProvider.of<DestGetLatAndLongCubit>(context).type;
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
