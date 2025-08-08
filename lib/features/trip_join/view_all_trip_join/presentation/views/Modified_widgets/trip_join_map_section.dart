import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../carpool/add_new_route/presentation/cubits/get_llat_and_long/cubit/cubit/dest_get_lat_and_long_cubit.dart';
import '../../../../../carpool/add_new_route/presentation/cubits/get_llat_and_long/cubit/get_lat_and_long_cubit.dart';
import '../../../../../carpool/add_new_route/presentation/widgets/dynamic_map_test.dart';
import '../../../../add_new_trip_join/presentation/cubits/fetch_price_distance/fetch_price_distance_cubit.dart';

class MapSection extends StatelessWidget {
  const MapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DestGetLatAndLongCubit, DestGetLatAndLongState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, destState) {
        final getLatLongCubit = context.read<GetLatAndLongCubit>();
        final destGetLatLongCubit = context.read<DestGetLatAndLongCubit>();
        final priceDistanceCubit = context.read<FetchPriceDistanceCubit>();

        // Both start and destination coordinates available
        if (destState is DestGetLatAndLongSuccess &&
            getLatLongCubit.startLat != null &&
            getLatLongCubit.startLong != null &&
            destGetLatLongCubit.endLat != null &&
            destGetLatLongCubit.endLong != null) {
          return SizedBox(
            height: 200,
            child: DynamicMapWithPolyline(
              showNavBar: false,
              polylineString: priceDistanceCubit.tripInfoEntity?.polyline,
              useGoogleMaps: destGetLatLongCubit.type == "google",
              url: _getMapUrl(context, isStart: false),
              apiKey: _getApiKey(context, isStart: false),
            ),
          );
        }

        // Only destination coordinates available
        if (destState is DestGetLatAndLongSuccess &&
            (getLatLongCubit.startLat == null ||
                getLatLongCubit.startLong == null)) {
          return SizedBox(
            height: 200,
            child: DynamicMapWithPolyline(
              showNavBar: false,
              useGoogleMaps: destGetLatLongCubit.type == "google",
              latitude: destGetLatLongCubit.endLat,
              longitude: destGetLatLongCubit.endLong,
              url: _getMapUrl(context, isStart: false),
              apiKey: _getApiKey(context, isStart: false),
            ),
          );
        }

        // Check for start coordinates with BlocBuilder
        return BlocBuilder<GetLatAndLongCubit, GetLatAndLongState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, startState) {
            // Both start and destination coordinates available (alternative path)
            if (startState is GetLatAndLongSuccess &&
                destGetLatLongCubit.endLat != null &&
                destGetLatLongCubit.endLong != null) {
              return SizedBox(
                height: 200,
                child: DynamicMapWithPolyline(
                  showNavBar: false,
                  polylineString: priceDistanceCubit.tripInfoEntity?.polyline,
                  useGoogleMaps: getLatLongCubit.type == "google",
                  url: _getMapUrl(context, isStart: true),
                  apiKey: _getApiKey(context, isStart: true),
                ),
              );
            }

            // Only start coordinates available
            if (startState is GetLatAndLongSuccess &&
                (destGetLatLongCubit.endLat == null ||
                    destGetLatLongCubit.endLat == 0)) {
              return SizedBox(
                height: 200,
                child: DynamicMapWithPolyline(
                  showNavBar: false,
                  useGoogleMaps: getLatLongCubit.type == "google",
                  latitude: getLatLongCubit.startLat,
                  longitude: getLatLongCubit.startLong,
                  url: _getMapUrl(context, isStart: true),
                  apiKey: _getApiKey(context, isStart: true),
                ),
              );
            }

            // Default map (no coordinates available)
            return SizedBox(
              height: 200,
              child: DynamicMapWithPolyline(
                showNavBar: false,
                url: _getDefaultMapUrl(),
                apiKey: _getDefaultApiKey(),
              ),
            );
          },
        );
      },
    );
  }

  // Move these utility methods to a separate map service class in production
  String _getMapUrl(BuildContext context, {required bool isStart}) {
    final type = isStart
        ? context.read<GetLatAndLongCubit>().type
        : context.read<DestGetLatAndLongCubit>().type;

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

  String _getApiKey(BuildContext context, {required bool isStart}) {
    final type = isStart
        ? context.read<GetLatAndLongCubit>().type
        : context.read<DestGetLatAndLongCubit>().type;

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

  String _getDefaultMapUrl() {
    return "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";
  }

  String _getDefaultApiKey() {
    return "5b3ce3597851110001cf6248d06d230ff17942299e5608fa3709ced9";
  }
}