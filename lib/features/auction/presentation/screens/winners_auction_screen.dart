import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/rendering.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/common/winner_grid_view_widget.dart';
import 'package:fourtyninehub/features/auction/domain/entities/all_winner_auction_entity.dart';
import 'package:fourtyninehub/features/auction/presentation/cubit/auction_cubit.dart';
import 'package:fourtyninehub/features/star_feature/presentation/shared/widgets/winners_grid_view.dart';


import 'package:fourtyninehub/res/assets/assets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../../../core/enums/base_status_enum.dart';
import '../../../../core/localization/locale_keys.g.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';


import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/widget/common/default_app_bar.dart';
import '../../../../helpers/manage_vibration.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';


class WinnersAuctionScreen extends StatefulWidget {
  const WinnersAuctionScreen({super.key});

  @override
  State<WinnersAuctionScreen> createState() => _WinnersAuctionScreenState();
}

class _WinnersAuctionScreenState extends State<WinnersAuctionScreen> {
  late final ScrollController _scrollController;
  bool isFloatingButtonVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    // Delay initial load to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cubit = context.read<AuctionCubit>();
      await cubit.loadInitialWinnersAuction();

      // 👇 Auto-load next page if list too short to scroll
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   if (_scrollController.position.maxScrollExtent <= 0 &&
      //       cubit.hasMoreWinnersAuction &&
      //       !cubit.isAuctionMoreWinnersAuction) {
      //     print("⚙️ Auto-loading next page because grid not scrollable yet");
      //     cubit.getWinnersAuction();
      //   }
      // });
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final cubit = context.read<AuctionCubit>();
        await cubit.loadInitialWinnersAuction();

        Future<void> tryAutoLoad() async {
          final scrollController = _scrollController;
          if (!scrollController.hasClients) return;

          final canScroll = scrollController.position.maxScrollExtent > 0;
          final itemCount = cubit.allWinnersData.length;
          final isOddRow = itemCount % 2 != 0;

          if ((!canScroll || isOddRow) &&
              cubit.hasMoreWinnersAuction &&
              !cubit.isAuctionMoreWinnersAuction) {
            print("⚙️ Auto-loading next page (grid not filled or not scrollable yet)");
            await cubit.getWinnersAuction();

            // Recheck after next frame in case more data is still needed
            WidgetsBinding.instance.addPostFrameCallback((_) => tryAutoLoad());
          }
        }

        WidgetsBinding.instance.addPostFrameCallback((_) => tryAutoLoad());
      });



    });
  }

  void _onScroll() {
    final cubit = context.read<AuctionCubit>();

    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // 👇 Trigger earlier — before the loader is fully visible
    if (currentScroll >= maxScroll - 250 &&
        !cubit.isAuctionMoreWinnersAuction &&
        cubit.hasMoreWinnersAuction) {
      cubit.getWinnersAuction();
    }

    // 👇 Floating button logic (unchanged)
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (isFloatingButtonVisible) {
        setState(() => isFloatingButtonVisible = false);
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!isFloatingButtonVisible) {
        setState(() => isFloatingButtonVisible = true);
      }
    }
  }




  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title:LocaleKeys.winners.localize,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Image.asset(
              Assets.winners,
              height: 20,
              width: 20,
            ),
          ),
        ],
      ),
      body: BlocBuilder<AuctionCubit, AuctionState>(
        builder: (context, state) {
          final cubit = context.read<AuctionCubit>();
          final winners = cubit.allWinnersData;

          // ⏳ Initial loading
          if (state.status == StateStatus.loading && winners.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // ❌ Error
          if (state.status == StateStatus.error && winners.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(LocaleKeys.somethingWentWrong.localize),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => cubit.loadInitialWinnersAuction(),
                    child: Text(LocaleKeys.retry.localize),
                  ),
                ],
              ),
            );
          }

          // 🈳 Empty
          if (winners.isEmpty) {
            return Center(child: Text(LocaleKeys.noAuctionAvailable.localize));
          }

          // ✅ Main grid
          return GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 12,
              mainAxisExtent: 270,
            ),
            itemCount: winners.length + (cubit.hasMoreWinnersAuction ? 1 : 0),
            // itemCount: winners.length,

            itemBuilder: (context, index) {
              if (index >= winners.length) {
                // ⏳ Pagination indicator
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final auction = winners[index];
              // return AuctionWinnerGridItem(auction: auction);
              return WinnerGridViewWidget(
                date: auction.endAt,
                title: auction.title,
                imageUrl: auction.winner?.userProfile?.profilePicture?.mediaKey,
                lastPrice: auction.lastPrice,
                name: '${auction.winner?.firstName ?? ''} ${auction.winner?.lastName ?? ''}'.trim(),
                viewsCount: auction.viewsCount,
                // rating: 1000,

              );
            },
          );
        },
      ),
    );
  }
}

