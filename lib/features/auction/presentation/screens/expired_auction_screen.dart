// AVAILABLE TAB
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/auction/presentation/screens/widgets/auction_card.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/floating_add_button.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/base_status_enum.dart';
import '../../../../core/widget/olx_pagination/banner.dart';
import '../../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import '../../../../helpers/manage_vibration.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../cubit/auction_cubit.dart';
import 'create_auction_screen.dart';
class ExpiredAuctionScreen extends StatefulWidget {
   ExpiredAuctionScreen({super.key});

  @override
  State<ExpiredAuctionScreen> createState() => _ExpiredAuctionScreenState();
}

class _ExpiredAuctionScreenState extends State<ExpiredAuctionScreen> {
  late ScrollController _auctionExpiredScrollController;

  bool isFloatingButtonVisible = true;
  void _scrollListener() {

    if (_auctionExpiredScrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      isFloatingButtonVisible = false;
    } else {
      isFloatingButtonVisible = true;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _auctionExpiredScrollController = ScrollController()..addListener(_scrollListener);

  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuctionCubit, AuctionState>(
      builder: (context, state) {
        final cubit = context.read<AuctionCubit>();
        final auctions = cubit.expiredAuctionNonSocketData;

        Widget body;


         if (state.status == StateStatus.loading && auctions.isEmpty) {
          body = const Center(child: CircularProgressIndicator());
        } else if (auctions.isEmpty) {
          body =  Center(child: Text(LocaleKeys.noAuctionAvailable.localize));
        } else {
           body = OlxPaginationWidget(
             itemsPerPage: 3,
             scrollController: _auctionExpiredScrollController,
             banners: bannersList, // 👉 add banner list if needed
             loadPage: (page) {
               return context.read<AuctionCubit>().getExpiredNonSocketAuction();
             },

             items: List.generate(
               auctions.length,
                   (index) {
                 final auction = auctions[index];
                 return AuctionCard(auction: auction);
               },
             ),
           );
          // body = ListView.separated(
          //   padding: const EdgeInsets.all(16),
          //   itemCount: auctions.length,
          //   separatorBuilder: (_, __) => const SizedBox(height: 16),
          //   itemBuilder: (context, index) {
          //     final auction = auctions[index];
          //     return AuctionCard(auction: auction);
          //   },
          // );
        }
        return Scaffold(
          floatingActionButton: isFloatingButtonVisible
              ? buildFloatingAction(context,title:  "${LocaleKeys.addAuction.localize}", () {
            ManageVibration.vibrate();
            context.push(Routes.createAuctionScreen);
          })
              : null,
          body: body,
        );
      },
    );
  }
}

/*
class ExpiredAuctionScreen extends StatelessWidget {
  const ExpiredAuctionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("🏗️ ExpiredAuctionScreen: Building widget");

    return BlocBuilder<AuctionCubit, AuctionState>(
      builder: (context, state) {
        print("🔄 BlocBuilder: State changed - Status: ${state.status}");

        final cubit = context.read<AuctionCubit>();
        final auctions = cubit.expiredAuctionNonSocketData;

        print("📋 Current auctions list:");
        print("   - Length: ${auctions.length}");
        print("   - Is Empty: ${auctions.isEmpty}");
        print("   - State Status: ${state.status}");

        // Show error if state is error
        if (state.status == StateStatus.error) {
          print("❌ Showing error state");
          return const Center(
            child: Text(
              "Something went wrong",
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        // Show loading only if state is loading AND auctions list is not yet fetched (null or empty initially)
        if (state.status == StateStatus.loading && auctions.isEmpty) {
          print("⏳ Showing loading indicator");
          return const Center(child: CircularProgressIndicator());
        }

        if (auctions.isEmpty) {
          print("📭 Showing 'No auctions available' message");
          return const Center(child: Text(LocaleKeys.noAuctionAvailable.localize));
        }

        // If the list is empty, show LocaleKeys.noAuctionAvailable.localize
        if (auctions.isEmpty) {
          print("📭 Showing 'No auctions available' message (duplicate check)");
          return const Center(child: Text(LocaleKeys.noAuctionAvailable.localize));
        }

        // Otherwise, show the auction list
        print("📊 Rendering auction list with ${auctions.length} items");
        return Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: auctions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final auction = auctions[index];
                print("🎯 Rendering auction at index $index: ${auction.toString()}");
                return AuctionCard(auction: auction);
              },
            ),
            PositionedDirectional(
              end: 16,
              top: MediaQuery.of(context).size.height * 0.50,
              child: FloatingActionButton.extended(
                onPressed: () {
                  context.push(Routes.createAuctionScreen);
                },
                backgroundColor: AppColors.PRIMARY_COLOR,
                icon: const Icon(Icons.add, color: Colors.white),
                label:  Text(
                  "${LocaleKeys.addAuction.localize}",
                  style:Styles.mediumText(
                      color: Colors.white
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
*/