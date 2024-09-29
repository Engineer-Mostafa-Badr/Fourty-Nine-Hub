import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/pages/empty.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import 'package:fourtyninehub/features/account_taps/my_adds/presentation/cubit/my_adds_cubit.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../service_locator/service_locator.dart';
import '../widgets/build_item_auction_card.dart';
import 'my_ads_other.dart';
import 'my_ads_trip_join.dart';

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
    _tabController = TabController(length: 4, vsync: this);
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
      length: 4,
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
                     // padding: EdgeInsets.zero,
                      // labelPadding:
                      //     EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                      tabAlignment: TabAlignment.start,
                      controller: _tabController,
                      onTap: (i) {
                        i == 0
                            ? context.read<MyAddsCubit>().getMyAuctions()
                            : i == 1
                                ? context
                                    .read<MyAddsCubit>()
                                    .getMyInstallment()
                                : i == 2
                                    ? context.read<MyAddsCubit>().getMyTripJoin()
                                    : i == 3
                                        ? context
                                            .read<MyAddsCubit>()
                                            .getMyAuctions()
                                        : null;
                      },
                      isScrollable: true,

                      tabs:  [
                        Tab(text: LocaleKeys.auction.localize),
                        Tab(text: LocaleKeys.installments.localize),
                        Tab(text: LocaleKeys.tripJoin.localize),
                        const Tab(text: 'Other'),
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
    return BlocProvider<MyAddsCubit>(
      create: (BuildContext context) =>serviceLocator()..getMyInstallment(),
      child: BlocBuilder<MyAddsCubit, MyAddsState>(builder: (context, state) {
        final controller = context.read<MyAddsCubit>();
        context.read<MyAddsCubit>();
        if (state.status ==MyAddsStates.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if(state.status ==MyAddsStates.initState) {
          return ListView.separated(
            itemCount: state.myInstallments?.length ?? 0,
            separatorBuilder: (context, index) => const Sizer(),
            itemBuilder: (context, index) {
              return BuildItemAuctionCard(
                item: state.myInstallments![index],
                onDelete: (String id) => controller.cancelAd(id: id),
              );
            });
        }else if (state.myInstallments!.isEmpty) {
          return const EmptyPage();
        }else{
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  Widget _buildMyAuctionsWidget() {
    return BlocProvider<MyAddsCubit>(
      create: (BuildContext context) =>serviceLocator()..getMyAuctions(),
      child: BlocBuilder<MyAddsCubit, MyAddsState>(builder: (context, state) {
        final controller = context.read<MyAddsCubit>();
        context.read<MyAddsCubit>();
        if (state.status ==MyAddsStates.loading) {
          return const Center(child: CircularProgressIndicator());
        }
       if(state.status ==MyAddsStates.initState) {
          return ListView.separated(
             itemCount: state.myAuctions?.length ?? 0,
            separatorBuilder: (context, index) => const Sizer(),
            itemBuilder: (context, index) {
              return BuildItemAuctionCard(
                item: state.myAuctions![index],
                onDelete: (String id) => controller.cancelAd(id: id),
              );
            });
       }
        else if (state.myAuctions?.isEmpty ?? true) {
            return const EmptyPage();
          }else{
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
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
            return MyAdsOther(
              item: state.myAds![index],
              onDelete: (String id) => controller.cancelAd(id: id),
            );
          });
    });
  }

  Widget _buildMyPickMeTripsWidget() {
    return BlocProvider<MyAddsCubit>(
      create: (BuildContext context) =>serviceLocator()..getMyTripJoin(),
      child: BlocBuilder<MyAddsCubit, MyAddsState>(builder: (context, state) {
        final controller = context.read<MyAddsCubit>();
        // if (state.pickMeTrips?.isEmpty ?? true) {
        //   return const EmptyPage();
        // }
        if (state.status ==MyAddsStates.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if(state.status ==MyAddsStates.initState) {
          return ListView.separated(
            itemCount: state.tripJoin?.docs.length ?? 0,
            separatorBuilder: (context, index) => const Sizer(),
            itemBuilder: (context, index) {
              return MyAdsTripJoin(
                tripJoinCardEntity: state.tripJoin!.docs[index],
                reportOnTap: () {
                 // _reportOnTap(context, index);
                },
                premuimRequestOnTap: () async {
                  // if (await _userApproved(
                  //   tripJoinCardEntity,
                  //   tripJoinCardEntity.categoryId ?? '',
                  //   'Trip Join Subscription',
                  // )) {}
                },
                requestOnTap: () async {
                  // await showModalBottomSheet(
                  //   context: context,
                  //   isDismissible: true,
                  //   isScrollControlled: true,
                  //   builder: (_) {
                  //     return BlocProvider.value(
                  //         value: BlocProvider.of<RequestTripJoinCubit>(context),
                  //         child: RequstTripJoinBottomSheet(tripJoinCardEntity: tripJoinCardEntity));
                  //   },
                  // );
                },
                callOnTap: () async {
                  // launchUrlString("tel://${tripJoinCardEntity.phone}");
                  // return;
                  // if (await _userApproved(
                  //   tripJoinCardEntity,
                  //   UIConst.chatNormalId,
                  //   'Chat Subscription',
                  // )) {
                  //   launchUrlString("tel://${tripJoinCardEntity.phone}");
                  // }
                },
                messageOnTap: () async {
                  // if (await _userApproved(
                  //   tripJoinCardEntity,
                  //   UIConst.chatNormalId,
                  //   'Chat Subscription',
                  // )) {}
                },
                subscribeMessageOnTap: () async {
                  // if (await _userApproved(
                  //   tripJoinCardEntity,
                  //   tripJoinCardEntity.categoryId ?? '',
                  //   'Trip Join Subscription',
                  // )) {}
                },
              );
            });
        }else if (state.tripJoin!.docs.isEmpty ?? true) {
          return const EmptyPage();
        }else{
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  // Widget _buildMyComeWithmeWidget() {
  //   return BlocBuilder<MyAddsCubit, MyAddsState>(builder: (context, state) {
  //     final controller = context.read<MyAddsCubit>();
  //     if (state.comeWithMeTrips?.isEmpty ?? true) {
  //       return const EmptyPage();
  //     }
  //     return ListView.separated(
  //         itemCount: state.comeWithMeTrips?.length ?? 0,
  //         separatorBuilder: (context, index) => const Sizer(),
  //         itemBuilder: (context, index) {
  //           return TripCard(
  //             requests: state.comeWithMeTrips![index].requests,
  //             trip: state.comeWithMeTrips![index].trip,
  //             showDelete: true,
  //             onAccept: (String id) =>
  //                 controller.acceptComeWithMeRequest(id: id),
  //             onReject: (String id) =>
  //                 controller.rejectComeWithMeRequest(id: id),
  //             onDelete: (String id) => controller.deleteComeWithMe(id: id),
  //           );
  //         });
  //   });
  // }
}
