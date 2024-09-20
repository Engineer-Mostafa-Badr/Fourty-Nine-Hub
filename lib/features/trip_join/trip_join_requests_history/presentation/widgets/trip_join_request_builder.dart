import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/presentation/cubits/delete_trips/delete_trips_cubit.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/presentation/cubits/fetch_my_trip_join_ads/fetch_my_trip_join_ads_cubit.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/presentation/widgets/trip_join_request_card.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/presentation/widgets/trip_join_request_loading.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class TripJoinRequestBuilder extends StatefulWidget {
  const TripJoinRequestBuilder({
    super.key,
  });

  @override
  State<TripJoinRequestBuilder> createState() => _TripJoinRequestBuilderState();
}

class _TripJoinRequestBuilderState extends State<TripJoinRequestBuilder> {
  late final ScrollController scrollController;
  late double scrollPosition;
  late double scrollMaxExtent;
  bool isLoading = false;
  late final FetchMyTripJoinAdsCubit fetchMyTripJoinAdsCubit;
  @override
  void initState() {
    fetchMyTripJoinAdsCubit = context.read<FetchMyTripJoinAdsCubit>();
    _fetchTripsIfEmpty();
    _scrollListener();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchMyTripJoinAdsCubit, FetchMyTripJoinAdsState>(
      builder: (context, state) {
        return ListView.builder(
          // physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          controller: scrollController,
          itemCount: fetchMyTripJoinAdsCubit.trips.length + 1,
          itemBuilder: (context, index) {
            if (state is! FetchMyTripJoinAdsLoading &&
                fetchMyTripJoinAdsCubit.trips.isEmpty) {
              // if (true) {
              return Container(
                height: context.screenHeight * 0.6,
                width: double.infinity,
                alignment: Alignment.center,
                child: Text('There are no requests in history',
                    style: Styles.headerText()),
              );
            }
            if (index < fetchMyTripJoinAdsCubit.trips.length) {
              return TripJoinRequestCard(
                tripJoinRequestEntity: fetchMyTripJoinAdsCubit.trips[index],
                deleteRequestOnTap: () async {
                  await context.read<DeleteTripsCubit>().deleteTrip(
                      id: fetchMyTripJoinAdsCubit.trips[index].id ?? '');
                  fetchMyTripJoinAdsCubit.trips.removeAt(index);
                  setState(() {});
                },
                subscribeOnTap: () {
                  serviceLocator<SubscriptionController>()
                      .showSubscriptionPlans(
                    wallets: [
                      fetchMyTripJoinAdsCubit
                              .trips[index].paymentMethod?.toWalletType ??
                          WalletTypes.balance
                    ],
                    subCategoryId:
                        fetchMyTripJoinAdsCubit.trips[index].categoryMainId ??
                            '',
                    title: 'Trip Join Subscription',
                  );
                },
                requestHistoryOnTap: () {
                  context.push(Routes.TRIP_JOIN_REQUEST_HISTORY,
                      extra: {'id': fetchMyTripJoinAdsCubit.trips[index].id});
                },
              );
            }
            return state is FetchMyTripJoinAdsLoading
                ? const TripJoinRequestLoadingList()
                : const SizedBox();
          },
        );
      },
    );
  }

  void _scrollListener() {
    // const t = 'scrollListener';
    scrollController = ScrollController();
    scrollController.addListener(() async {
      scrollPosition = scrollController.position.pixels;
      scrollMaxExtent = scrollController.position.maxScrollExtent;
      if (scrollPosition >= 0.7 * scrollMaxExtent) {
        // pr('0.7 * scrollMaxExtent', t);
        // pr(fetchMyTripJoinAdsCubit.trips.last.hasNextPage, t);
        // pr(fetchMyTripJoinAdsCubit.trips.last.nextPage, t);
        if (!isLoading &&
            (fetchMyTripJoinAdsCubit.trips.last.hasNextPage ?? false)) {
          // pr('new request', t);
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
  }
}
