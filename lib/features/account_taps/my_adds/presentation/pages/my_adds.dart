import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class MyAddsView extends StatefulWidget {
  const MyAddsView({super.key});

  @override
  State<MyAddsView> createState() => _MyAddsViewState();
}

class _MyAddsViewState extends State<MyAddsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _scrollController = ScrollController();

    // Listen for tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _scrollToSelectedTab(_tabController.index);
      }
    });
  }

  void _scrollToSelectedTab(int index) {
    // The width of each tab (adjust as needed based on the UI)
    double tabWidth = 100.w; // Example width, adjust based on your layout
    // Scroll to the selected tab
    _scrollController.animateTo(
      tabWidth * index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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
                  SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: TabBar(
                      padding: EdgeInsets.zero,
                      labelPadding:
                          EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                      tabAlignment: TabAlignment.start,
                      controller: _tabController,
                      onTap: (i) {
                        i == 0
                            ? context.read<MyAddsCubit>().getPickMeTrips()
                            : i == 1
                                ? context
                                    .read<MyAddsCubit>()
                                    .getComeWithMeTrips()
                                : i == 2
                                    ? context.read<MyAddsCubit>().getMyAds()
                                    : i == 3
                                        ? context
                                            .read<MyAddsCubit>()
                                            .getMyAuctions()
                                        : null;
                      },
                      isScrollable: true,
                      tabs: const [
                        Tab(text: 'Auctions'),
                        Tab(text: 'Installment'),
                        Tab(text: 'Trip join'),
                        Tab(text: 'Carpool'),
                        Tab(text: 'Other'),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildMyAuctionsWidget(),
                          _buildMyInstallmentsWidget(),
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

  Widget _buildMyInstallmentsWidget() {
    return BlocBuilder<MyAddsCubit, MyAddsState>(builder: (context, state) {
      context.read<MyAddsCubit>();
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
      context.read<MyAddsCubit>();
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
