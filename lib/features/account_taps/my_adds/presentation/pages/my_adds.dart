import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/pages/empty.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/presentation/cubit/my_adds_cubit.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../widgets/build_item_auction_card.dart';
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
  late MyAddsCubit _myAddsCubit;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    _myAddsCubit = context.read<MyAddsCubit>();

    // Fetch initial data for the first tab
    _myAddsCubit.getMyTripJoin();

    // Listen for tab changes and fetch data for the selected tab
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _fetchTabData(_tabController.index);
      }
    });
  }

  void _fetchTabData(int index) {
    if (index == 0) {
      _myAddsCubit.getMyTripJoin();
    } else if (index == 1) {
      _myAddsCubit.getMyOtherAds();
    }
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
      length: 2,
      child: Scaffold(
        appBar: BackAppBar(label: LocaleKeys.myAds.localize),
        body: BlocConsumer<MyAddsCubit, MyAddsState>(
          listener: (context, state) {
            if (state.status == MyAddsStates.error && state.failure != null) {
              showErrorMessage(
                context,
                getFailureMessage(state.failure!, context),
              );
            }
          },
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                _fetchTabData(_tabController.index);
              },
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    onTap: (index) {
                      // Explicitly fetch data only if the user taps the tab
                      _fetchTabData(index);
                    },
                    isScrollable: false,
                    tabs: [
                      Tab(text: LocaleKeys.tripJoin.localize),
                      Tab(text: LocaleKeys.Other.localize),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildMyPickMeTripsWidget(),
                          _buildMyAdsWidget(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMyAdsWidget() {
    return BlocBuilder<MyAddsCubit, MyAddsState>(
      builder: (context, state) {
        if (state.status == MyAddsStates.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == MyAddsStates.error) {
          return const Center(child: Text('Error loading data'));
        } else if (state.myOtherAds?.isEmpty ?? true) {
          return const EmptyPage();
        }
        return ListView.separated(
          itemCount: state.myOtherAds!.length,
          separatorBuilder: (context, index) => const Sizer(),
          itemBuilder: (context, index) {
            return BuildItemAuctionCard(item: state.myOtherAds![index]);
          },
        );
      },
    );
  }

  Widget _buildMyPickMeTripsWidget() {
    return BlocBuilder<MyAddsCubit, MyAddsState>(
      builder: (context, state) {
        if (state.status == MyAddsStates.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == MyAddsStates.error) {
          return const Center(child: Text('Error loading data'));
        } else if (state.tripJoin?.docs.isEmpty ?? true) {
          return const EmptyPage();
        }
        return ListView.separated(
          itemCount: state.tripJoin!.docs.length,
          separatorBuilder: (context, index) => const Sizer(),
          itemBuilder: (context, index) {
            return MyAdsTripJoin(
                tripJoinCardEntity: state.tripJoin!.docs[index]);
          },
        );
      },
    );
  }
}
