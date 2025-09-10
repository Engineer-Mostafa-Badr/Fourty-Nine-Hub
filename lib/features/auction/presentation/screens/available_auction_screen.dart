// AVAILABLE TAB
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/auction/presentation/screens/widgets/auction_card.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/base_status_enum.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../routes/routes.dart';
import '../cubit/auction_cubit.dart';
import 'create_auction_screen.dart';
class AvailableAuctionScreen extends StatelessWidget {
  const AvailableAuctionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuctionCubit, AuctionState>(
      builder: (context, state) {
        final cubit = context.read<AuctionCubit>();
        final auctions = cubit.availableAuctionNonSocketData;

        // Show error if state is error
        if (state.status == StateStatus.error) {
          return const Center(
            child: Text(
              "Something went wrong",
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        // Show loading only if state is loading AND auctions list is not yet fetched (null or empty initially)
        if (state.status == StateStatus.loading && auctions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // If the list is empty, show "No auctions available"
        if (auctions.isEmpty) {
          return const Center(child: Text("No auctions available"));
        }

        // Otherwise, show the auction list
        return Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: auctions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final auction = auctions[index];
                return AuctionCard(auction: auction);
              },
            ),
            PositionedDirectional(
              end: 16,
              top: MediaQuery.of(context).size.height * 0.45,
              child: FloatingActionButton.extended(
                onPressed: () {
                  context.push(Routes.createAuctionScreen);
                },
                backgroundColor: AppColors.PRIMARY_COLOR,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Add Auction",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/*
class AvailableAuctionScreen extends StatelessWidget {
  const AvailableAuctionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuctionCubit, AuctionState>(
      builder: (context, state) {
        final cubit = context.read<AuctionCubit>();
        final auctions = cubit.availableAuctionNonSocketData;

        if (state.status == StateStatus.loading && auctions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == StateStatus.error) {
          return const Center(
            child: Text(
              "Something went wrong",
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (auctions.isEmpty) {
          return const Center(child: Text("No auctions available"));
        }

        return Stack(
          children: [
            // ===== AUCTION LIST =====
            ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: auctions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final auction = auctions[index];
                return AuctionCard(auction: auction);
              },
            ),

            // ===== FLOATING ADD BUTTON =====
            PositionedDirectional(
              end: 16,
              top: MediaQuery.of(context).size.height * 0.45, // adjust for center
              child: FloatingActionButton.extended(
                onPressed: () {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text("Add Auction Clicked")),
                  // );
                 context.push(Routes.createAuctionScreen);
                },
                backgroundColor: AppColors.PRIMARY_COLOR,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Add Auction",
                  style: TextStyle(color: Colors.white),
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