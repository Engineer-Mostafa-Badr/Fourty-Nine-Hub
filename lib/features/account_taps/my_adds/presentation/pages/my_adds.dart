import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';

import 'package:fourtyninehub/features/account_taps/my_adds/presentation/cubit/my_adds_cubit.dart';
import 'package:fourtyninehub/features/requests_history/presentation/widgets/trip_card.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../widgets/my_ad_card.dart';

class MyAddsView extends StatelessWidget {
  const MyAddsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const BackAppBar(
          label: 'My Ads',
        ),
        body: BlocConsumer<MyAddsCubit, MyAddsState>(
          listener: (context, state) {
            if (state.status == MyAddsStates.error && state.failure != null) {
              showErrorMessage(
                context,
                getFailureMessage(
                  state.failure!,
                  context,
                ),
              );
            }
          },
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async => context.read<MyAddsCubit>().loadData(),
              child: Column(
                children: [
                  const TabBar(tabs: [
                    Tab(
                      text: 'Pick Me',
                    ),
                    Tab(
                      text: 'Come With Me',
                    ),
                    Tab(
                      text: 'Other',
                    ),
                  ]),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TabBarView(children: [
                      _buildMyPickMeTripsWidget(),
                      _buildMyComeWithmeWidget(),
                      _buildMyAdsWidget(),
                    ]),
                  )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMyAdsWidget() {
    return BlocBuilder<MyAddsCubit, MyAddsState>(builder: (context, state) {
      return ListView.separated(
          itemCount: state.myAds?.length ?? 0,
          separatorBuilder: (context, index) => const Sizer(),
          itemBuilder: (context, index) {
            return MyAdCard(
              item: state.myAds![index],
            );
          });
    });
  }

  Widget _buildMyPickMeTripsWidget() {
    return BlocBuilder<MyAddsCubit, MyAddsState>(builder: (context, state) {
      final controller = context.read<MyAddsCubit>();
      return ListView.separated(
          itemCount: state.pickMeTrips?.length ?? 0,
          separatorBuilder: (context, index) => const Sizer(),
          itemBuilder: (context, index) {
            return TripCard(
              requests: state.pickMeTrips![index].requests,
              trip: state.pickMeTrips![index].trip,
              showDelete: true,
              onAccept: (String id) => controller.acceptPickMeRequest(id: id),
              onReject: (String id) => controller.rejectPickMeRequest(id: id),
              onDelete: (String id) => controller.deletePickMeRequest(id: id),
            );
          });
    });
  }

  Widget _buildMyComeWithmeWidget() {
    return BlocBuilder<MyAddsCubit, MyAddsState>(builder: (context, state) {
      final controller = context.read<MyAddsCubit>();

      return ListView.separated(
          itemCount: state.comeWithMeTrips?.length ?? 0,
          separatorBuilder: (context, index) => const Sizer(),
          itemBuilder: (context, index) {
            return TripCard(
              requests: state.comeWithMeTrips![index].requests,
              trip: state.comeWithMeTrips![index].trip,
              showDelete: true,
              onAccept: (String id) =>
                  controller.acceptComeWithMeRequest(id: id),
              onReject: (String id) =>
                  controller.rejectComeWithMeRequest(id: id),
              onDelete: (String id) => controller.deleteComeWithMe(id: id),
            );
          });
    });
  }
}
