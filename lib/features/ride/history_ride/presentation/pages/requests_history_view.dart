import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/features/ride/history_ride/presentation/cubit/history_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/history_ride/presentation/widgets/trip_card.dart';

import '../../../../../res/assets/assets.dart';

class HistoryRequestsView extends StatelessWidget {
  const HistoryRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<HistoryRideCubit>();
    return BlocBuilder<HistoryRideCubit, HistoryRideState>(
        builder: (context, state) {
      return DefaultTabController(
        length: 5,
        initialIndex: 0,
        child: Scaffold(
          appBar: const BackAppBar(
            label: 'Requests History',
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
                              text: 'Other',
                              icon: Image.asset(height: 20, Assets.hand),
                            )
                          ]),
                          const Sizer(),
                          Expanded(
                              child: TabBarView(children: [
                            _buildRideRequests(),
                            _buildRideRequests(),
                            _buildRideRequests(),
                            _buildRideRequests(),
                            _buildRideRequests(),
                          ])),
                        ],
                      )),
          ),
        ),
      );
    });
  }

  Widget _buildRideRequests() {
    return BlocBuilder<HistoryRideCubit, HistoryRideState>(
        builder: (context, state) {
      return ListView.separated(
          itemCount: state.trips?.length ?? 0,
          separatorBuilder: (context, index) => const Sizer(),
          itemBuilder: (context, index) {
            return TripCard(trip: state.trips![index]);
          });
    });
  }
}
