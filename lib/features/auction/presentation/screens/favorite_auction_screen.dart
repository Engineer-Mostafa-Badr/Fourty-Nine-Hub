// AVAILABLE TAB
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/auction/presentation/screens/widgets/auction_card.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/base_status_enum.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/widget/olx_pagination/banner.dart';
import '../../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../cubit/auction_cubit.dart';
import 'create_auction_screen.dart';

class FavoriteAuctionScreen extends StatelessWidget {
   FavoriteAuctionScreen({super.key});
  final ScrollController _auctionScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    print("🏗️ FavoriteAuctionScreen: Building widget");

    return BlocBuilder<AuctionCubit, AuctionState>(
      builder: (context, state) {
        print("🔄 BlocBuilder: State changed - Status: ${state.status}");

        final cubit = context.read<AuctionCubit>();
        final auctions = cubit.favoriteAuctionNonSocketData;

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
          return  Center(child: Text(LocaleKeys.noAuctionAvailable.localize));
        }

        // If the list is empty, show LocaleKeys.noAuctionAvailable.localize
        if (auctions.isEmpty) {
          print("📭 Showing 'No auctions available' message (duplicate check)");
          return  Center(child: Text(LocaleKeys.noAuctionAvailable.localize));
        }

        // Otherwise, show the auction list
        print("📊 Rendering auction list with ${auctions.length} items");
        return Stack(
          children: [
           OlxPaginationWidget(
          itemsPerPage: 3,
          scrollController: _auctionScrollController,
          banners: bannersList, // 👉 add banner list if needed
          loadPage: (page) {
            return context.read<AuctionCubit>().getFavoriteNonSocketAuction();
          },

          items: List.generate(
            auctions.length,
                (index) {
              final auction = auctions[index];
              return AuctionCard(auction: auction,isFavorite: true,);
            },
          ),
        ),
            // ListView.separated(
            //   padding: const EdgeInsets.all(16),
            //   itemCount: auctions.length,
            //   separatorBuilder: (_, __) => const SizedBox(height: 16),
            //   itemBuilder: (context, index) {
            //     final auction = auctions[index];
            //     print("🎯 Rendering auction at index $index: ${auction.toString()}");
            //     return AuctionCard(auction: auction,isFavorite: true,);
            //   },
            // ),
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
