import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/requests_history/presentation/cubit/request_history_cubit.dart';
import 'package:fourtyninehub/features/requests_history/presentation/widgets/trip_card.dart';

import '../../../../res/assets/assets.dart';
import '../../../../res/strings/labels.dart';
import '../../../health_feature/health/presentation/widgets/booking/booking_card.dart';
import '../widgets/food_order_card.dart';
import '../widgets/shipping_request_card.dart';

class HistoryRequestsView extends StatelessWidget {
  const HistoryRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<RequestHistoryCubit>();
    return BlocBuilder<RequestHistoryCubit, RequestHistoryState>(
        builder: (context, state) {
      return DefaultTabController(
        length: 5,
        initialIndex: 0,
        child: Scaffold(
          appBar: const BackAppBar(
            label: Labels.requestsHistory,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RefreshIndicator(
                onRefresh: () async => controller.loadData(),
                child: state.isLoading
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : Column(
                        children: [
                          TabBar(tabs: [
                            Tab(
                              text: 'Ride',
                              icon: SvgPicture.asset(height: 20, Assets.ride),
                            ),
                            Tab(
                              text: 'Shipping',
                              icon:
                                  SvgPicture.asset(height: 20, Assets.shipping),
                            ),
                            Tab(
                              text: 'Health',
                              icon: SvgPicture.asset(height: 20, Assets.health),
                            ),
                            Tab(
                              text: 'Food',
                              icon: SvgPicture.asset(height: 20, Assets.food),
                            ),
                            Tab(
                              text: 'Requests',
                              icon: Image.asset(height: 20, Assets.hand),
                            )
                          ]),
                          const Sizer(),
                          Expanded(
                              child: TabBarView(children: [
                            _buildRideRequests(),
                            _buildShippingRequests(),
                            _buildHealthBooking(),
                            _buildFoodOrders(),
                            _buildEmptyList(),
                          ])),
                        ],
                      )),
          ),
        ),
      );
    });
  }

  Widget _buildEmptyList() {
    return const Center(
      child: Label(
        text: "There is no items",
      ),
    );
  }

  Widget _buildShippingRequests() {
    return BlocBuilder<RequestHistoryCubit, RequestHistoryState>(
        builder: (context, state) {
      return ListView.separated(
          itemCount: state.shippingRequests?.length ?? 0,
          separatorBuilder: (context, index) => const Sizer(),
          itemBuilder: (context, index) {
            return ShippingRequestCard(trip: state.shippingRequests![index]);
          });
    });
  }

  Widget _buildHealthBooking() {
    return BlocBuilder<RequestHistoryCubit, RequestHistoryState>(
        builder: (context, state) {
      return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => HealthBookingCard(
                appointment: state.healthBookings![index],
              ),
          separatorBuilder: (context, index) => const Sizer(),
          itemCount: state.healthBookings?.length ?? 0);
    });
  }

  Widget _buildRideRequests() {
    return BlocBuilder<RequestHistoryCubit, RequestHistoryState>(
        builder: (context, state) {
      return ListView.separated(
          itemCount: state.trips?.length ?? 0,
          separatorBuilder: (context, index) => const Sizer(),
          itemBuilder: (context, index) {
            return TripCard(trip: state.trips![index]);
          });
    });
  }

  Widget _buildFoodOrders() {
    return BlocBuilder<RequestHistoryCubit, RequestHistoryState>(
        builder: (context, state) {
      return ListView.separated(
          itemCount: state.foodOrders?.length ?? 0,
          separatorBuilder: (context, index) => const Sizer(),
          itemBuilder: (context, index) {
            return FoodOrderCard(
              item: state.foodOrders![index],
            );
          });
    });
  }
}
