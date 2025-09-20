// AVAILABLE TAB
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/auction/presentation/screens/widgets/auction_card.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/base_status_enum.dart';
import '../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../../../RideFeature/presentation/pages/widgets/font_manager.dart';
import '../cubit/auction_cubit.dart';
import 'create_auction_screen.dart';

class AvailableAuctionScreen extends StatefulWidget {
  const AvailableAuctionScreen({super.key});

  @override
  State<AvailableAuctionScreen> createState() => _AvailableAuctionScreenState();
}

class _AvailableAuctionScreenState extends State<AvailableAuctionScreen> {
  final ScrollController _auctionScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 🔹 Trigger initial load when screen opens
    context.read<AuctionCubit>().loadInitialAvailableNonSocketAuction(context);
  }

  Future<void> _addAuction() async {
    final result = await context.push(Routes.createAuctionScreen);
    if (result == true) {
      context.read<AuctionCubit>().loadInitialAvailableNonSocketAuction(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuctionCubit, AuctionState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == StateStatus.error) {
          final errorMessage =
              getFailureMessage(state.failure!, context) ??
                  "Something went wrong";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<AuctionCubit>();
        final auctions = cubit.availableAuctionNonSocketData;

        print("🔄 Auction UI State: ${state.status}, items=${auctions.length}");

        // 🔹 Loader
        if (cubit.isAuctionInitialLoading) {
          return const Center(child: CustomCircularProgressIndicator());
        }

        // 🔹 No data
        if (!cubit.isAuctionInitialLoading && auctions.isEmpty) {
          return Center(
            child: Text(
              context.isArabic ? 'لا يوجد مزادات متاحة' : 'No Available Auctions',
              style: TextStyle(fontSize: FontSize.s18),
            ),
          );
        }

        // 🔹 Data available with pagination
        if (auctions.isNotEmpty) {
          return OlxPaginationWidget(
            itemsPerPage: cubit.auctionPageSize,
            scrollController: _auctionScrollController,
            banners: [], // 👉 add banner list if needed
            loadPage: (page) {
              print("==> Auction page $page");
              return context.read<AuctionCubit>().getAvailableNonSocketAuction(context);
            },
            items: List.generate(
              auctions.length,
                  (index) {
                final auction = auctions[index];
                return AuctionCard(auction: auction);
              },
            ),
          );
        }

        // 🔹 Fallback
        return const Center(child: Text("Something went wrong"));
      },
    );
  }
}
