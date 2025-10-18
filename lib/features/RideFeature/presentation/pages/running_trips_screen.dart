import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/common/default_app_bar.dart';
import 'package:fourtyninehub/core/widget/common/global_card.dart';
import 'package:fourtyninehub/core/widget/common/trip_location_widget.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/running_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/car_circle_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/person_trip_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:intl/intl.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/utils/format_numbers.dart';
import '../../../../core/widget/olx_pagination/banner.dart';
import '../../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import '../../../../res/style/app_colors.dart';
import '../../../new_trip_join/captainshare/screen/custom_map.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;

class RunningTripParams {
  final RideCubit rideCubit;
  RunningTripParams({required this.rideCubit});
}

class RunningTripScreen extends StatefulWidget {
  final RunningTripParams params;
  const RunningTripScreen({super.key, required this.params});

  @override
  _RunningTripScreenState createState() => _RunningTripScreenState();
}

class _RunningTripScreenState extends State<RunningTripScreen> {
  late ScrollController _scrollController;
  late ScrollController newScrollController;
  int page = 1;
  final int limit = 10;
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    widget.params.rideCubit.loadInitialRunningTripsData();
    newScrollController = ScrollController();
    // _scrollController = ScrollController()..addListener(_onScroll);
    //
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   widget.params.rideCubit.loadInitialRunningTripsData();
    // });
  }





  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.params.rideCubit,
      child: Builder(
        builder: (context) {
          return CustomScaffold(
            appBar: DefaultAppBar(
              title:LocaleKeys.runningTrips.localize,
            ),
            body: BlocBuilder<RideCubit, RideState>(
              builder: (context, state) {
                if (widget.params.rideCubit.isLoadingRunningTrips) {
                  return const Center(child: CustomCircularProgressIndicator());
                } else if (state.status == RideStates.error) {
                  return const SizedBox();
                } else  {
                  if(widget.params.rideCubit.runningTrips.isEmpty) {
                    return Center(child: CustomEmptyWidget(label: context.isArabic ? "لا يوجد رحلات حالية" : "No running trips"));
                  }
                  return OlxPaginationWidget(
                    itemsPerPage: 3,
                    loadPage: (page) {
                      return widget.params.rideCubit.fetchAllRunningTrips();
                    },
                    banners: bannersList,
                    items: List.generate(
                      widget.params.rideCubit.runningTrips.length ?? 0,
                          (index){
                            if (index == widget.params.rideCubit.runningTrips.length) {
                              return const Center(child: CustomCircularProgressIndicator());
                            }
                            final trip = widget.params.rideCubit.runningTrips[index];
                            // return Padding(
                            //   padding: const EdgeInsets.all(16),
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       CarContainer(title: context.isArabic ? trip.subCategoryNameAr : trip.subCategoryNameEn, image: trip.subCategoryPicture),
                            //       const SizedBox(width: 16),
                            //       PriceColumn(
                            //         startAddressTitle: trip.startLocationAddressTitle,
                            //         targetAddressTitle: trip.targetLocationAddressTitle,
                            //         date: DateFormat('hh:mm a', context.isArabic ? 'ar' : 'en').format(trip.createdAt!),
                            //         price: '${NumberFormat('#,##0', context.isArabic ? 'ar' : 'en').format(trip.price)} ${context.isArabic ? "ج.م" : "EGP"}',
                            //       ),
                            //
                            //       const Spacer(),
                            //       PersonTripWidget(image: trip.driverProfileUrl, name: trip.driverFirstName?.split(' ').first, rate: trip.driverAverageRating?.toString(),),
                            //     ],
                            //   ),
                            // );
                            return TripCard(trip: trip);
                                  }
                    ), scrollController: newScrollController,
                  );
                  // return ListView.builder(
                  //   controller: _scrollController,
                  //   itemCount: (widget.params.rideCubit.runningTrips.length ?? 0) + (isFetching ? 1 : 0),
                  //   itemBuilder: (context, index) {
                  //     if (index == widget.params.rideCubit.runningTrips.length) {
                  //       return const Center(child: CustomCircularProgressIndicator());
                  //     }
                  //     final trip = widget.params.rideCubit.runningTrips[index];
                  //     if (trip == null) return const SizedBox.shrink();
                  //     // return Padding(
                  //     //   padding: const EdgeInsets.all(16),
                  //     //   child: Row(
                  //     //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     //     children: [
                  //     //       CarContainer(title: context.isArabic ? trip.subCategoryNameAr : trip.subCategoryNameEn, image: trip.subCategoryPicture),
                  //     //       const SizedBox(width: 16),
                  //     //       PriceColumn(
                  //     //         startAddressTitle: trip.startLocationAddressTitle,
                  //     //         targetAddressTitle: trip.targetLocationAddressTitle,
                  //     //         date: DateFormat('hh:mm a', context.isArabic ? 'ar' : 'en').format(trip.createdAt!),
                  //     //         price: '${NumberFormat('#,##0', context.isArabic ? 'ar' : 'en').format(trip.price)} ${context.isArabic ? "ج.م" : "EGP"}',
                  //     //       ),
                  //     //
                  //     //       const Spacer(),
                  //     //       PersonTripWidget(image: trip.driverProfileUrl, name: trip.driverFirstName?.split(' ').first, rate: trip.driverAverageRating?.toString(),),
                  //     //     ],
                  //     //   ),
                  //     // );
                  //     return TripCard(trip: trip);
                  //   },
                  // );
                }
                // return Center(child: context.isArabic ? const Text("لا يوجد رحلات مشغلة حاليا") : const Text("No running trips available"));
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class PriceColumn extends StatelessWidget {
  final String? startAddressTitle;
  final String? targetAddressTitle;

  const PriceColumn({
    super.key,
    required this.startAddressTitle,
    required this.targetAddressTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(startAddressTitle != null)
          TripLocationWidget(isFrom: true, title: startAddressTitle??''),
        const SizedBox(height: 16),
        if(targetAddressTitle != null)
          TripLocationWidget(isFrom: false, title: targetAddressTitle??''),
        const SizedBox(height: 4),

      ],
    );
  }
}


class TripCard extends StatelessWidget {
  final RunningTripsEntity trip;

  const TripCard({super.key, required this.trip});

  List<gmap.LatLng> _convertPolylineToLatLng(List<List<double>> polyline) {
    return polyline.map((point) => gmap.LatLng(point[1], point[0])).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final dateFormat = DateFormat('hh:mm a', isArabic ? 'ar' : 'en');
    final numberFormat = NumberFormat('#,##0', isArabic ? 'ar' : 'en');

    List<gmap.LatLng> clients = [];
    List<String> clientsAddress = [];

    try {
      if (trip.wayPointOneAddressTitle != null &&
          trip.wayPointOneLat != null &&
          trip.wayPointOneLng != null) {
        clients.add(gmap.LatLng(trip.wayPointOneLng!, trip.wayPointOneLat!));
      }

      if (trip.wayPointTwoAddressTitle != null &&
          trip.wayPointTwoLat != null &&
          trip.wayPointTwoLng != null) {
        clients.add(gmap.LatLng(trip.wayPointTwoLng!, trip.wayPointTwoLat!));
      }
    } catch (e) {
      print('Error processing client locations: $e');
    }

    if(trip.wayPointOneAddressTitle !=null && (trip.wayPointOneAddressTitle?.isNotEmpty??false)){
      clientsAddress.add(trip.wayPointOneAddressTitle!);
    }

    if(trip.wayPointTwoAddressTitle!=null && (trip.wayPointTwoAddressTitle?.isNotEmpty??false)){
      clientsAddress.add(trip.wayPointTwoAddressTitle!);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: GlobalCard(subcategoryId: '', phone: '', reportId: '', otherUserId: '',
      body: Column(
        children: [
          // Flutter Map with two markers
          if(trip.startLocationLat != null && trip.startLocationLng != null && trip.targetLocationLat != null && trip.targetLocationLng != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              child: SizedBox(
                height: 130,
                child: CustomGoogleMap(
                  startLocation: gmap.LatLng(trip.startLocationLng?? 0, trip.startLocationLat?? 0),
                  targetLocation: gmap.LatLng(trip.targetLocationLng?? 0, trip.targetLocationLat?? 0),
                  clientAddresses: clientsAddress,
                  clientLocations: clients,
                  polylinePoints: _convertPolylineToLatLng(trip.polyline ?? []),
                ),
              ),
            ),
          // ClipRRect(
          //   borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          //   child: SizedBox(
          //     height: 130,
          //     child: FlutterMap(
          //       options: MapOptions(
          //         center: LatLng(trip.startLocationLat?? 0, trip.startLocationLng?? 0),
          //         zoom: 10.0,
          //       ),
          //       children: [
          //         TileLayer(
          //           urlTemplate: context.isDarkMode
          //               ? "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png" // Dark mode map
          //               : "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png", // Normal mode map
          //           userAgentPackageName: 'com.example.app',
          //         ),
          //         MarkerLayer(
          //           markers: [
          //             Marker(
          //               point: LatLng(trip.startLocationLat?? 0, trip.startLocationLng?? 0),
          //               width: 40,
          //               height: 40,
          //               child: const Icon(Icons.location_on, color: Colors.blue),
          //             ),
          //             Marker(
          //               point: LatLng(trip.targetLocationLat?? 0, trip.targetLocationLng?? 0),
          //               width: 40,
          //               height: 40,
          //               child: const Icon(Icons.location_on, color: AppColors.c19D176),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          // Trip Details
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CarContainer(
                  title: isArabic ? trip.subCategoryNameAr : trip.subCategoryNameEn,
                  image: trip.subCategoryPicture,
                  date: dateFormat.format(trip.createdAt!),
                  price: '${numberFormat.format(trip.price)} ${isArabic ? "ج.م" : "EGP"}',
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: PriceColumn(
                    startAddressTitle: trip.startLocationAddressTitle,
                    targetAddressTitle: trip.targetLocationAddressTitle,

                  ),
                ),
                const Spacer(),
                PersonTripWidget(
                  image: trip.driverProfileUrl,
                  name: trip.driverFirstName?.split(' ').first,
                  rate: trip.driverAverageRating?.toString(),
                  isVerified: trip.verifiedBadge && trip.isDriverVerified,
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}