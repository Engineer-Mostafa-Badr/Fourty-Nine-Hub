import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/trip_join/requests_history/domain/entities/tripjoin_request_entity.dart';
import 'package:fourtyninehub/features/trip_join/requests_history/presentation/widgets/trip_join_request_card.dart';
import 'package:fourtyninehub/features/trip_join/requests_history/presentation/widgets/trip_join_request_loading.dart';

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
  int nextPage = 1;
  bool isLoading = false;
  @override
  void initState() {
    _scrollListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final staticData = List.generate(
      5,
      (index) => TripJoinRequestCard(
        tripJoinRequestEntity: TripJoinRequestEntity(
          id: '66dd733c4d2f94d445bd95d3',
          categoryId: '62ea00e269ea29c91dfc390c',
          brand: 'toyota',
          model: 'Corolla',
          journeyPrice: 10,
          status: 'Regular',
          seatNumber: 2,
          isRepeated: true,
          startingAddressEn:
              '29J7+X65, Samia El Gamal, Mansoura Qism 2, El Mansoura, Dakahlia Governorate 7650310, Egypt',
          destinationAddressEn: 'El Gomhouria St, Dakahlia Governorate, Egypt',
          subscriptionEndDate: 1725788940000,
          publishDate: 1725788940000,
          // publishDate: 1726604033000,
          paymentMethod: 'mainWallet',
          subscribedPremium: false,
        ),
      ),
    );
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      controller: scrollController,
      itemCount: staticData.length + 1,
      itemBuilder: (context, index) {
        if (index < staticData.length) {
          return staticData[index];
        }
        return const TripJoinRequestLoadingList();
      },
    );
  }

  void _scrollListener() {
    scrollController = ScrollController();
    scrollController.addListener(() async {
      scrollPosition = scrollController.position.pixels;
      scrollMaxExtent = scrollController.position.maxScrollExtent;
      if (scrollPosition >= 0.7 * scrollMaxExtent) {
        if (!isLoading
            // && (getAppNotificationsCubit.notifications.last.hasNextPage ??false)
            ) {
          isLoading = true;
          // getAppNotificationsCubit.page =
          //     getAppNotificationsCubit.notifications.last.nextPageNumber!;
          // await getAppNotificationsCubit.getAppNotifications();
          nextPage++;
          isLoading = false;
        }
      }
    });
  }
}
