import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/features/trip_join/fetch_my_pick_me_trips/presentation/cubits/fetch_my_pick_me_trips/cubit/fetch_my_pick_me_trips_cubit.dart';
import 'package:fourtyninehub/features/trip_join/get_requests_pick_me/data/models/get_requests_pick_me_model.dart';
import 'package:fourtyninehub/features/trip_join/get_requests_pick_me/presentation/cubits/cubit/get_requests_pick_me_cubit.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/presentation/cubits/delete_trips/delete_trips_cubit.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/presentation/cubits/fetch_my_trip_join_ads/fetch_my_trip_join_ads_cubit.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/presentation/widgets/trip_join_request_card.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/presentation/widgets/trip_join_request_loading.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/presentation/widgets/my_all_pick_me_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class TripJoinRequestBuilder extends StatefulWidget {
  const TripJoinRequestBuilder({super.key});

  @override
  State<TripJoinRequestBuilder> createState() => _TripJoinRequestBuilderState();
}

class _TripJoinRequestBuilderState extends State<TripJoinRequestBuilder> {
  late final ScrollController scrollController;
  bool isLoading = false;
  late final FetchMyTripJoinAdsCubit fetchMyTripJoinAdsCubit;
  late final FetchMyPickMeTripsCubit fetchMyPickMeTripsCubit;
  late final GetRequestsPickMeCubit getRequestsPickMeCubit;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetCurrencyCubit>(context).getCurrencyData();

    fetchMyTripJoinAdsCubit = context.read<FetchMyTripJoinAdsCubit>();
    fetchMyPickMeTripsCubit = context.read<FetchMyPickMeTripsCubit>();
    getRequestsPickMeCubit = context.read<GetRequestsPickMeCubit>();
    getRequestsPickMeCubit.getRequestsPickMe();
    scrollController = ScrollController();
    _fetchTripsIfEmpty();
    _scrollListener();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          BlocBuilder<FetchMyTripJoinAdsCubit, FetchMyTripJoinAdsState>(
            builder: (context, state1) {
              return BlocBuilder<FetchMyPickMeTripsCubit,
                  FetchMyPickMeTripsState>(
                builder: (context, state2) {
                  return _buildContent(state1, state2);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
      FetchMyTripJoinAdsState state1, FetchMyPickMeTripsState state2) {
    if (state1 is FetchMyTripJoinAdsLoading ||
        state2 is FetchMyPickMeTripsLoading) {
      return const Column(
        children: [
          Sizer(),
          Center(
              child: CircularProgressIndicator(
            color: AppColors.PRIMARY_COLOR,
          )),
        ],
      );
    }

    // Check if both lists are empty
    if (fetchMyTripJoinAdsCubit.trips.isEmpty &&
        fetchMyPickMeTripsCubit.trips.isEmpty) {
      return Container(
        height: context.screenHeight * 0.6,
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(LocaleKeys.noTripRequests.localize,
            style: Styles.headerText()),
      );
    }

    return Column(
      children: [
        _buildTripJoinAdsList(state1),
        _buildPickMeTripsList(state2),
      ],
    );
  }

  Widget _buildTripJoinAdsList(FetchMyTripJoinAdsState state) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Prevent scrolling
      itemCount: fetchMyTripJoinAdsCubit.trips.length + 1,
      itemBuilder: (context, index) {
        if (index < fetchMyTripJoinAdsCubit.trips.length) {
          return TripJoinRequestCard(
            tripJoinRequestEntity: fetchMyTripJoinAdsCubit.trips[index],
            deleteRequestOnTap: () async {
              await context.read<DeleteTripsCubit>().deleteTrip(
                  subCategory: UIConst.tripJoinCategoryId,
                  url: "/ride/come-with-you/Delete",
                  id: fetchMyTripJoinAdsCubit.trips[index].id ?? '');
              fetchMyTripJoinAdsCubit.trips.removeAt(index);
              setState(() {});
            },
            subscribeOnTap: () {
              serviceLocator<SubscriptionController>().showSubscriptionPlans(
                wallets: [
                  fetchMyTripJoinAdsCubit
                          .trips[index].paymentMethod?.toWalletType ??
                      WalletTypes.mainWallet
                ],
                subCategoryId:
                    fetchMyTripJoinAdsCubit.trips[index].categoryMainId ?? '',
                title: LocaleKeys.tripjoinPremuimSubscription,
              );
            },
            requestHistoryOnTap: () {
              context.push(Routes.TRIP_JOIN_REQUEST_HISTORY,
                  extra: {'id': fetchMyTripJoinAdsCubit.trips[index].id});
            },
          );
        }

        // Show loading indicator if there's more data to load
        return state is FetchMyTripJoinAdsLoading
            ? const TripJoinRequestLoadingList()
            : const SizedBox();
      },
    );
  }

  Widget _buildPickMeTripsList(FetchMyPickMeTripsState state) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Prevent scrolling
      itemCount: fetchMyPickMeTripsCubit.trips.length,
      itemBuilder: (context, index) {
        final trip = fetchMyPickMeTripsCubit.trips[index];

        return MyAllPickMeCard(
          deleteRequestOnTap: () async {
            await context.read<DeleteTripsCubit>().deleteTrip(
                subCategory: "62ea008d69ea29c91dfc3908",
                url: "/ride/pick-me/Delete",
                id: trip.id);
            fetchMyPickMeTripsCubit.trips.removeAt(index);
            setState(() {});
          },
          requestHistoryOnTap: () {
            // Access data list from GetRequestsPickMeCubit
            List<TripDataWithRequests> tripsWithRequests =
                getRequestsPickMeCubit.tripDataWithRequests;

            List<PickMeRequest>? requestsList;

            // Loop through each trip in tripsWithRequests to check if trip.id matches any data.trip._id
            for (var tripData in tripsWithRequests) {
              if (trip.id == tripData.trip?.id) {
                // Store the list of requests for the matching trip
                requestsList = tripData.requests ?? [];

                print("Trip exists in data");

                if (requestsList.isNotEmpty) {
                  print("Trip has requests\n");
                } else {
                  print("Trip has an empty requests list\n");
                }
                break; // Exit loop after finding the trip
              }
            }

            // Check if the trip was found and pass the requests list if available
            // if (requestsList != null) {
            context.push(
              Routes.TRIP_JOIN_REQUEST_HISTORY_Pick_Me,
              extra: requestsList, // Passing the requests list
            );
            // }
          },
          subscribeOnTap: () {
            serviceLocator<SubscriptionController>().showSubscriptionPlans(
              wallets: [WalletTypes.mainWallet],
              subCategoryId: trip.categoryId ?? '62ea008d69ea29c91dfc3908',
              title: LocaleKeys.tripjoinPremuimSubscription,
            );
          },
          fetchMyPickMeModel: trip,
        );
      },
    );
  }

  void _scrollListener() {
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.7) {
        if (!isLoading && (fetchMyTripJoinAdsCubit.trips.isNotEmpty)) {
          isLoading = true;
          fetchMyTripJoinAdsCubit.page =
              fetchMyTripJoinAdsCubit.trips.last.nextPage!;
          await fetchMyTripJoinAdsCubit.fetchMyTripJoinAds();
          isLoading = false;
        }
      }
    });
  }

  void _fetchTripsIfEmpty() {
    if (fetchMyTripJoinAdsCubit.trips.isEmpty) {
      fetchMyTripJoinAdsCubit.page = 1;
      fetchMyTripJoinAdsCubit.fetchMyTripJoinAds();
    }
    if (fetchMyPickMeTripsCubit.trips.isEmpty) {
      fetchMyPickMeTripsCubit.page = 1;
      fetchMyPickMeTripsCubit.fetchMyPickMeTrips();
    }
  }
}
