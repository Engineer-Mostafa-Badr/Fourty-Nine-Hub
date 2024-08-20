import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/pages/empty.dart';

import 'package:fourtyninehub/features/account_taps/my_adds/presentation/cubit/my_adds_cubit.dart';
import 'package:fourtyninehub/features/installment_feature/installment_list/presentation/widgets/installment_ad_card.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_list/presentation/widgets/auction_card.dart';
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
      length: 5,
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
                  const TabBar(isScrollable: true, tabs: [
                    Tab(
                      text: 'Pick Me',
                    ),
                    Tab(
                      text: 'Come With Me',
                    ),
                    Tab(
                      text: 'Other',
                    ),
                    Tab(
                      text: 'Auctions',
                    ),
                    Tab(
                      text: 'Installment',
                    ),
                  ]),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TabBarView(children: [
                      _buildMyPickMeTripsWidget(),
                      _buildMyComeWithmeWidget(),
                      _buildMyAdsWidget(),
                      _buildMyAuctionsWidget(),
                      _buildMyInstallmentsWidget(),
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

  Widget _buildMyInstallmentsWidget() {
    return BlocBuilder<MyAddsCubit, MyAddsState>(builder: (context, state) {
      final controller = context.read<MyAddsCubit>();
      if (state.myInstallments?.isEmpty ?? true) {
        return const EmptyPage();
      }
      return ListView.separated(
          itemCount: state.myInstallments?.length ?? 0,
          separatorBuilder: (context, index) => const Sizer(),
          itemBuilder: (context, index) {
            return InstallmentAdCard(
              isVertical: false,
              item: state.myInstallments![index],
            );
          });
    });
  }

  Widget _buildMyAuctionsWidget() {
    return BlocBuilder<MyAddsCubit, MyAddsState>(builder: (context, state) {
      final controller = context.read<MyAddsCubit>();
      if (state.myAuctions?.isEmpty ?? true) {
        return const EmptyPage();
      }
      return ListView.separated(
          itemCount: state.myAuctions?.length ?? 0,
          separatorBuilder: (context, index) => const Sizer(),
          itemBuilder: (context, index) {
            return AuctionCard(
              isVertical: false,
              item: state.myAuctions![index],
            );
          });
    });
  }

  Widget _buildMyAdsWidget() {
    return BlocBuilder<MyAddsCubit, MyAddsState>(builder: (context, state) {
      final controller = context.read<MyAddsCubit>();
      if (state.myAds?.isEmpty ?? true) {
        return const EmptyPage();
      }
      return ListView.separated(
          itemCount: state.myAds?.length ?? 0,
          separatorBuilder: (context, index) => const Sizer(),
          itemBuilder: (context, index) {
            return MyAdCard(
              item: state.myAds![index],
              onDelete: (String id) => controller.cancelAd(id: id),
            );
          });
    });
  }

  Widget _buildMyPickMeTripsWidget() {
    return BlocBuilder<MyAddsCubit, MyAddsState>(builder: (context, state) {
      final controller = context.read<MyAddsCubit>();
      if (state.pickMeTrips?.isEmpty ?? true) {
        return const EmptyPage();
      }
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
      if (state.comeWithMeTrips?.isEmpty ?? true) {
        return const EmptyPage();
      }
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
