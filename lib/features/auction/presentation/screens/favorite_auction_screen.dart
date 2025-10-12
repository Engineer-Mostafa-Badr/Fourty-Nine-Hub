// AVAILABLE TAB
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/auction/presentation/screens/widgets/auction_card.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/base_status_enum.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../core/widget/olx_pagination/banner.dart';
import '../../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import '../../../../helpers/manage_vibration.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../../../subcategories/presentation/widgets/floating_add_button.dart';
import '../cubit/auction_cubit.dart';
import 'create_auction_screen.dart';

class FavoriteAuctionScreen extends StatefulWidget {
   FavoriteAuctionScreen({super.key});

  @override
  State<FavoriteAuctionScreen> createState() => _FavoriteAuctionScreenState();
}

class _FavoriteAuctionScreenState extends State<FavoriteAuctionScreen> {
  late ScrollController _auctionScrollController ;

  bool isFloatingButtonVisible = true;
  void _scrollListener() {

    if (_auctionScrollController.position.userScrollDirection ==
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
    context.read<AuctionCubit>().loadInitialFavoriteNonSocketAuction();

    _auctionScrollController = ScrollController()..addListener(_scrollListener);

  }
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
          return  Center(
            child: Text(
                "${LocaleKeys.somethingWentWrong.localize}",
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        // Show loading only if state is loading AND auctions list is not yet fetched (null or empty initially)
        if (state.status == StateStatus.loading && auctions.isEmpty) {
          print("⏳ Showing loading indicator");
          return const Center(child: CustomCircularProgressIndicator());
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
        return Scaffold(
          floatingActionButton: isFloatingButtonVisible
              ? buildFloatingAction(context,title:   "${LocaleKeys.addAuction.localize} +", () {
            ManageVibration.vibrate();
            context.push(Routes.createAuctionScreen);
          })
              : null,
          body:OlxPaginationWidget(
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
        );
      },
    );
  }
}
