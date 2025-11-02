// AVAILABLE TAB
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:fourtyninehub/features/auction/presentation/screens/widgets/auction_card.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/floating_add_button.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/base_status_enum.dart';
import '../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../core/widget/olx_pagination/banner.dart';
import '../../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import '../../../../helpers/manage_vibration.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../cubit/auction_cubit.dart';

class AvailableAuctionScreen extends StatefulWidget {
  const AvailableAuctionScreen({super.key});

  @override
  State<AvailableAuctionScreen> createState() => _AvailableAuctionScreenState();
}

class _AvailableAuctionScreenState extends State<AvailableAuctionScreen> {
  late ScrollController _auctionScrollController;

  @override
  void initState() {
    super.initState();
    _auctionScrollController = ScrollController()..addListener(_scrollListener);
    // _auctionScrollController.addListener(() {
    //   final cubit = context.read<AuctionCubit>();
    //
    //   if (_auctionScrollController.position.pixels >=
    //       _auctionScrollController.position.maxScrollExtent - 200 &&
    //       cubit.hasMoreAvailableNonSocketAuction &&
    //       !cubit.isAuctionMoreAvailableNonSocketAuction) {
    //     print("📢 Triggering available auction pagination");
    //     cubit.getAvailableNonSocketAuction(context);
    //   }
    // });

    // Trigger initial load
    context.read<AuctionCubit>().loadInitialAvailableNonSocketAuction(context);
  }

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

  Future<void> _addAuction() async {
    final result = await context.push(Routes.createAuctionScreen);
    if (result == true) {
      context
          .read<AuctionCubit>()
          .loadInitialAvailableNonSocketAuction(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuctionCubit, AuctionState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == StateStatus.error) {
          final errorMessage = getFailureMessage(state.failure!, context) ??
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

        Widget body;

        if (cubit.isAuctionInitialLoading) {
          body = const Center(child: CustomCircularProgressIndicator());
        } else if (!cubit.isAuctionInitialLoading && auctions.isEmpty) {
          body = Center(
            child: Text(
              context.isArabic
                  ? 'لا يوجد مزادات متاحة'
                  : 'No Available Auctions',
              style: Styles.mediumText(),
            ),
          );
        } else if (auctions.isNotEmpty) {
          body = OlxPaginationWidget(
            itemsPerPage: 3,
            scrollController: _auctionScrollController,
            banners: bannersList, // 👉 add banner list if needed
            loadPage: (page) {
              return context
                  .read<AuctionCubit>()
                  .getAvailableNonSocketAuction(context);
            },

            items: List.generate(
              auctions.length,
              (index) {
                final auction = auctions[index];
                return AuctionCard(auction: auction);
              },
            ),
          );
        } else if (auctions.isEmpty) {
          print("📭 Showing 'No auctions available' message");
          return Center(
              child: CustomEmptyWidget(
            label: LocaleKeys.noAuctionAvailable.localize,
          ));
        } else {
          body = Center(child: Text(LocaleKeys.somethingWentWrong.localize));
        }

        return Scaffold(
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: isFloatingButtonVisible
              ? buildFloatingAction(context,
                  title: "${LocaleKeys.addAuction.localize} +", () {
                  ManageVibration.vibrate();
                  _addAuction();
                })
              : null,
          body: body,
        );
      },
    );
  }
}
