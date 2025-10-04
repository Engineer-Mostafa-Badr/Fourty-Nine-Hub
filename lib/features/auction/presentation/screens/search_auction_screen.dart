import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/auction/presentation/screens/widgets/auction_card.dart';
import '../../../../core/enums/base_status_enum.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

import '../../../RideFeature/presentation/pages/widgets/font_manager.dart';
import '../../domain/entities/get_all_auction_entity.dart';
import '../cubit/auction_cubit.dart';
// 📌 UPDATE IN YOUR AuctionScreen:
// Replace this:
// SearchAuctionScreen(
//   data: state.searchAuction,
//   isLoading: state.status == StateStatus.loading,
//   onLoadMore: () => cubit.getSearchAuction(context),
// )
//
// With this:
// const SearchAuctionScreen()

class SearchAuctionScreen extends StatefulWidget {
  const SearchAuctionScreen({super.key});

  @override
  State<SearchAuctionScreen> createState() => _SearchAuctionScreenState();
}

class _SearchAuctionScreenState extends State<SearchAuctionScreen> {
  final ScrollController _searchScrollController = ScrollController();

  @override
  void dispose() {
    _searchScrollController.dispose();
    super.dispose();
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
        final auctions = cubit.searchAuctionData; // 🔹 Use data from cubit, not state

        Widget body;

        if (cubit.isAuctionInitialLoading) {
          body = const Center(child: CustomCircularProgressIndicator());
        } else if (!cubit.isAuctionInitialLoading && auctions.isEmpty) {
          body = Center(
            child: Text(
              context.isArabic ? 'لا يوجد نتائج' : 'No Results Found',
              style: TextStyle(fontSize: FontSize.s18),
            ),
          );
        } else if (auctions.isNotEmpty) {
          body = OlxPaginationWidget(
            itemsPerPage: cubit.auctionPageSize,
            scrollController: _searchScrollController,
            banners: [], // 👉 add banners if needed
            loadPage: (page) {
              return context.read<AuctionCubit>().getSearchAuction(context);
            },
            items: List.generate(
              auctions.length,
                  (index) {
                final auction = auctions[index];
                return AuctionCard(auction: auction);
              },
            ),
          );
        } else {
          body = const Center(child: Text("Something went wrong"));
        }

        return Scaffold(
          body: body,
        );
      },
    );
  }
}

/*
class SearchAuctionScreen extends StatefulWidget {
  final List<GetAvailableAuctionEntity>? data; // ✅ nullable
  final bool isLoading;
  final Future<void> Function() onLoadMore;

  const SearchAuctionScreen({
    super.key,
    required this.data,
    required this.isLoading,
    required this.onLoadMore,
  });

  @override
  State<SearchAuctionScreen> createState() => _SearchAuctionScreenState();
}

class _SearchAuctionScreenState extends State<SearchAuctionScreen> {
  final ScrollController _searchScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 🔹 Trigger initial load handled already by AuctionCubit.loadInitialSearchAuction
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
        final auctions = state.searchAuction;

        Widget body;

        if (cubit.isAuctionInitialLoading) {
          body = const Center(child: CustomCircularProgressIndicator());
        } else if (!cubit.isAuctionInitialLoading && auctions!.isEmpty) {
          body = Center(
            child: Text(
              context.isArabic ? 'لا يوجد نتائج' : 'No Results Found',
              style: TextStyle(fontSize: FontSize.s18),
            ),
          );
        } else if (auctions!.isNotEmpty) {
          body = OlxPaginationWidget(
            itemsPerPage: cubit.auctionPageSize,
            scrollController: _searchScrollController,
            banners: [], // 👉 add banners if needed
            loadPage: (page) async {
              await widget.onLoadMore();
            },
            items: List.generate(
              auctions.length,
                  (index) {
                final auction = auctions[index];
                return AuctionCard(auction: auction);
              },
            ),
          );
        } else {
          body = const Center(child: Text("Something went wrong"));
        }

        return Scaffold(
          body: body,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              // 👉 For search we usually don’t allow adding auctions,
              // but if you want same behavior as AvailableAuctionScreen:
              // context.push(Routes.createAuctionScreen);
            },
            backgroundColor: AppColors.PRIMARY_COLOR,
            icon: const Icon(Icons.search, color: Colors.white),
            label: Text(
              context.isArabic ? "بحث" : "Search",
              style: Styles.mediumText(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
*/