import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/requests_history/presentation/cubit/get_shipping_request_cubit.dart';
import 'package:fourtyninehub/features/requests_history/presentation/cubit/rating_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/call_message_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/trip_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/requests_history/presentation/cubit/request_history_cubit.dart';
import 'package:fourtyninehub/features/requests_history/presentation/widgets/trip_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            centerTitle: false,
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
                              icon: SvgPicture.asset(height: 20.h, Assets.ride),
                            ),
                            Tab(
                              text: 'Ship',
                              icon:
                                  SvgPicture.asset(height: 20, Assets.shipping),
                            ),
                            Tab(
                              text: 'Health',
                              icon:
                                  SvgPicture.asset(height: 20.h, Assets.health),
                            ),
                            Tab(
                              text: 'Food',
                              icon: SvgPicture.asset(height: 20.h, Assets.food),
                            ),
                            Tab(
                              text: 'Requests',
                              icon: Image.asset(height: 20.h, Assets.hand),
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
    // return BlocBuilder<RequestHistoryCubit, RequestHistoryState>(
    //     builder: (context, state) {
    //   return ListView.separated(
    //       itemCount: state.shippingRequests?.length ?? 0,
    //       separatorBuilder: (context, index) => const Sizer(),
    //       itemBuilder: (context, index) {
    //         return ShippingRequestCard(trip: state.shippingRequests![index]);
    //       });
    // });r
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocator<TripCubit>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<CallMessageCubit>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<GetShippingRequestCubit>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<RatingCubit>(),
        ),
      ],
      child: BlocBuilder<GetShippingRequestCubit, ShippingState>(
        builder: (context, state) {
          if (state is SuccessGetShippingHistoryState) {
            return ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                return ShppingHistoryCard(
                    isHistory: true,
                    priceFontSize: 20,
                    model: state.list[index]);
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
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
