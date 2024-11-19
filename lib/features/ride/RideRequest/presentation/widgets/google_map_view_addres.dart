import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_destination_point_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_starting_point_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_trip_info_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/location_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_trip_reel_time_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapViewAddres extends StatefulWidget {
  const GoogleMapViewAddres({super.key});

  @override
  State<GoogleMapViewAddres> createState() => _GoogleMapViewAddresState();
}

class _GoogleMapViewAddresState extends State<GoogleMapViewAddres> {
  Set<Marker> markets = {};
  late GoogleMapController mapController;
  Set<Polyline> polyLineGoogleMap = {};
  LatLng? start;
  LatLng? end;
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetStartingPointRideCubit, RiderState>(
          listener: (context, state) {
            if (state is SuccessGetStartingPointState) {
              context.read<LocationSocketCubit>().sendSubCategoryId(
              subCategoryId:
                  context.read<RiderTripReelTimeCubit>().tempCategory!.id,
              address: state.address,
            );
              Marker? mark = markets
                  .where((element) => element.markerId.value == "Start")
                  .firstOrNull;
              if (mark == null) {
                markets.add(
                  Marker(
                    markerId: const MarkerId("Start"),
                    position: LatLng(
                      state.lat,
                      state.lng,
                    ),
                  ),
                );
              } else {
                markets.remove(mark);
                markets.add(
                  Marker(
                    markerId: const MarkerId("Start"),
                    position: LatLng(
                      state.lat,
                      state.lng,
                    ),
                  ),
                );
              }

              mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(
                        state.lat,
                        state.lng,
                      ),
                      zoom: 14),
                ),
              );
              start = LatLng(state.lat, state.lng);
              if (markets.length == 2) {
                if (start != null && end != null) {
                  context.read<GetTripInfoCubit>().getTripInfoRequest(
                      subCateogryId: context
                              .read<RiderTripReelTimeCubit>()
                              .subCategory
                              ?.id ??
                          "",
                      startLatLng: start!,
                      destinationLatLng: end!);
                }
              }
            }
            setState(() {});
          },
        ),
        BlocListener<GetDestinationPointRideCubit, RiderState>(
          listener: (context, state) {
            log(state.toString());
            if (state is SuccessGetDestinationPointState) {
              Marker? mark = markets
                  .where((element) => element.markerId.value == "End")
                  .firstOrNull;
              log(mark.toString(), name: "lskdjflskdf");
              if (mark == null) {
                markets.add(
                  Marker(
                    markerId: const MarkerId("End"),
                    position: LatLng(
                      state.lat,
                      state.lng,
                    ),
                  ),
                );
              } else {
                log(markets.length.toString(), name: "start");
                markets.remove(mark);
                log(markets.length.toString(), name: "End");
                markets.add(
                  Marker(
                    markerId: const MarkerId("End"),
                    position: LatLng(
                      state.lat,
                      state.lng,
                    ),
                  ),
                );
              }

              mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(
                        state.lat,
                        state.lng,
                      ),
                      zoom: 14),
                ),
              );
              end = LatLng(state.lat, state.lng);
              log(markets.length.toString(), name: "kdkdkdkdkdkdkdkdk");
              if (markets.length == 2) {
                log("okokok");
                if (start != null && end != null) {
                  context.read<GetTripInfoCubit>().getTripInfoRequest(
                      subCateogryId: context
                              .read<RiderTripReelTimeCubit>()
                              .subCategory
                              ?.id ??
                          "",
                      startLatLng: start!,
                      destinationLatLng: end!);
                }
              }
            }
            setState(() {});
          },
        ),
      ],
      child: BlocConsumer<GetTripInfoCubit, RiderState>(
        listener: (context, state) {
          if (state is SuccessGetTripInfoState) {
            setPolyLine(polyline: state.model.polyline ?? "");
            // showBottomSheet(
            //         context: context,
            //         builder: (context) {
            //           return TripInfoRequestWidget(model: state.model,);
            //         },
            //       );
            setState(() {});
          }
        },
        builder: (context, state) {
          return SizedBox(
            height: 200,
            width: double.infinity,
            child: GoogleMap(
              polylines: polyLineGoogleMap,
              markers: markets,
              onMapCreated: (controller) {
                mapController = controller;
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(30.033333, 31.233334),
                zoom: 14.4746,
              ),
            ),
          );
        },
      ),
    );
  }

  setPolyLine({
    required String polyline,
  }) {
    if (markets.length == 2) {
      addPolyLineGoogleMap(polyline);
    }
  }

  List<LatLng> decodePolyline(String polyline) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPoints = polylinePoints.decodePolyline(polyline);
    return decodedPoints
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  addPolyLineGoogleMap(String line) {
    List<LatLng> polyLineDecode = decodePolyline(line);
    final Polyline polyline = Polyline(
        polylineId: const PolylineId("polyLine"),
        points: polyLineDecode,
        color: Colors.blue);
    setState(() {
      polyLineGoogleMap.add(polyline);
    });
  }
}
