
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/history_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_history_details_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/person_trip_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/car_circle_widget.dart';
import 'package:latlong2/latlong.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/widget/custom_loading_search_widget.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../routes/routes.dart';
import '../../../../service_locator/service_locator.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class HistoryTripsScreenParams {
  final RideCubit rideCubit;
  HistoryTripsScreenParams({required this.rideCubit});
}

class HistoryTripsScreen extends StatefulWidget {
  final HistoryTripsScreenParams params;
  const HistoryTripsScreen({super.key, required this.params});

  @override
  _HistoryTripsScreenState createState() => _HistoryTripsScreenState();
}

class _HistoryTripsScreenState extends State<HistoryTripsScreen> {
  late ScrollController _scrollController;
  int page = 1;
  final int limit = 10;
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.params.rideCubit.fetchAllHistoryTrips(limit: limit, page: page);
    });
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 100 && !isFetching) {
      _fetchMoreTrips();
    }
  }

  void _fetchMoreTrips() {
    if (isFetching) return;
    setState(() => isFetching = true);
    widget.params.rideCubit.fetchAllHistoryTrips(limit: limit, page: ++page).then((_) {
      if (mounted) setState(() => isFetching = false);
    }).catchError((_) {
      if (mounted) setState(() => isFetching = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.params.rideCubit,
      child: Builder(
        builder: (context) {
          return CustomScaffold(
            appBar: AppBar(
              titleSpacing: 0,
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
                onPressed: () {
      ManageVibration.vibrate();
                  Navigator.pop(context);
                },
              ),
              title: Transform(
                transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                child: Text(
                  context.isArabic? "الرحلات السابقة": "Your Past Trips",
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                ),
              ),
            ),
            body: BlocBuilder<RideCubit, RideState>(
              builder: (context, state) {
                if (state.status == RideStates.loading && page == 1) {

                  return const Center(child: CustomLoadingSearchWidget());
                } else if (state.status == RideStates.error) {

                  return const SizedBox();
                } {

                  if(state.historyTrips?.isEmpty??true) {
                    return Center(child: Text(context.isArabic ? "لا يوجد رحلات سابقة" : "No past trips"));
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: (state.historyTrips?.length ?? 0) + (isFetching ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.historyTrips?.length) {
                        return const Center(child: CustomLoadingSearchWidget());
                      }
                      final trip = state.historyTrips?[index];
                      if (trip == null) return const SizedBox.shrink();
                      // return Padding(
                      //   padding: const EdgeInsets.all(16),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       CarContainer(title: context.isArabic ? trip.categoryNameAr : trip.categoryNameEn, image: trip.categoryPicture),
                      //       const SizedBox(width: 16),
                      //       PriceColumn(
                      //         startAddressTitle: trip.address,
                      //         date: context.isArabic
                      //             ? DateFormat('d MMM - hh:mm a', 'ar').format(trip.createdAt)
                      //             : DateFormat('MMM d - hh:mm a', 'en').format(trip.createdAt),
                      //         price: '${NumberFormat('#,##0', context.isArabic ? 'ar' : 'en').format(trip.price)} ${context.isArabic ? trip.currencyAr : trip.currencyEn}',
                      //       ),
                      //       const Spacer(),
                      //       RateCar(image: (trip.carPicture.isNotEmpty) ? trip.carPicture : trip.categoryPicture, rate: trip.rating.toString()),
                      //     ],
                      //   ),
                      // );
                      return TripCard(trip: trip);
                    },
                  );
                }
                // return const Center(child: Text("No expired trips available"));
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
  final String date;
  final String price;

  const PriceColumn({
    super.key,
    required this.startAddressTitle,
    required this.targetAddressTitle,
    required this.date,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(startAddressTitle != null)
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.c19D176,
                size: 18,
              ),
              const SizedBox(width: 4),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.45),
                child: Label(
                  text: startAddressTitle!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 4),
        if(targetAddressTitle != null)
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.blueColor,
                size: 18,
              ),
              const SizedBox(width: 4),
              ConstrainedBox(
                constraints:  BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.45),
                child: Label(
                  text: targetAddressTitle!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 4),

        Row(
          spacing: 4,
          children: [
            Label(
              text: date,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 40),
            Label(
              text: price,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.PRIMARY_COLOR,
              ),
            ),
            // Label(
            //     text: LocaleKeys.egp.tr(),
            //     style: Styles.mediumText(
            //         color: AppColors.SECONDARY_COLOR,
            //         fontWeight: FontWeight.w700))
          ],
        ),

      ],
    );
  }
}


class TripCard extends StatelessWidget {
  final HistoryTripsEntity trip;

  const TripCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final dateFormat = DateFormat('hh:mm a', isArabic ? 'ar' : 'en');
    final numberFormat = NumberFormat('#,##0', isArabic ? 'ar' : 'en');

    return GestureDetector(
      onTap: () {
      ManageVibration.vibrate();
        context.push(Routes.RIDEDETAILSTRIPS,
            extra: RideHistoryDetailsScreenParams(
              rideCubit: serviceLocator<RideCubit>(),
              historyTripEntity: trip,
            ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          children: [
            // Flutter Map with two markers
            if(trip.startLocationLat != null && trip.startLocationLng != null && trip.targetLocationLat != null && trip.targetLocationLng != null)
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                child: SizedBox(
                  height: 130,
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(trip.startLocationLat?? 0, trip.startLocationLng?? 0),
                      zoom: 10.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: context.isDarkMode
                            ? "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png" // Dark mode map
                            : "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png", // Normal mode map
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(trip.startLocationLat?? 0, trip.startLocationLng?? 0),
                            width: 40,
                            height: 40,
                            child: const Icon(Icons.location_on, color: Colors.blue),
                          ),
                          Marker(
                            point: LatLng(trip.targetLocationLat?? 0, trip.targetLocationLng?? 0),
                            width: 40,
                            height: 40,
                            child: const Icon(Icons.location_on, color: AppColors.c19D176),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // Trip Details
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarContainer(
                    title: isArabic ? trip.subCategoryNameAr : trip.subCategoryNameEn,
                    image: trip.subCategoryPicture,
                  ),
                  const SizedBox(width: 16),
                  PriceColumn(
                    startAddressTitle: trip.startLocationAddressTitle,
                    targetAddressTitle: trip.targetLocationAddressTitle,
                    date: dateFormat.format(trip.createdAt!),
                    price: '${numberFormat.format(trip.price)} ${isArabic ? "ج.م" : "EGP"}',
                  ),
                  const Spacer(),
                  PersonTripWidget(
                    image: trip.driverProfileUrl,
                    name: trip.driverFirstName?.split(' ').first,
                    rate: trip.driverAverageRating?.toString(),
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