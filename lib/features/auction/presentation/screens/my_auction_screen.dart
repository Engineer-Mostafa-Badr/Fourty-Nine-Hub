// AVAILABLE TAB
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/auction/presentation/screens/widgets/auction_card.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/base_status_enum.dart';
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
class MyAuctionScreen extends StatefulWidget {
  const MyAuctionScreen({super.key});

  @override
  State<MyAuctionScreen> createState() => _MyAuctionScreenState();
}
class _MyAuctionScreenState extends State<MyAuctionScreen> {
  late ScrollController _scrollController;

  bool isFloatingButtonVisible = true;

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
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
    _scrollController = ScrollController()
      ..addListener(_scrollListener);
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _addAuction() async {
    final result = await context.push(Routes.createAuctionScreen);
    if (result == true) {
      context.read<AuctionCubit>().loadInitialMyAuction();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuctionCubit, AuctionState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == StateStatus.error) {
          final errorMessage =
              getFailureMessage(state.failure!, context) ?? "Something went wrong";
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
        final auctions = cubit.myAuctionNonSocketData;

        if (state.status == StateStatus.loading && auctions.isEmpty) {
          return const Center(child: CustomCircularProgressIndicator());
        }

        if (auctions.isEmpty) {
          return Center(
            child: Text(
              context.isArabic ? 'لا توجد مزادات خاصة بي' : 'No auctions my',
            ),
          );

        }

        return Scaffold(
          floatingActionButton: isFloatingButtonVisible
              ? buildFloatingAction(context,title:  "${LocaleKeys.addAuction.localize}", () {
            ManageVibration.vibrate();
            _addAuction();
          })
              : null,
          body:  OlxPaginationWidget(
            itemsPerPage: 3,
            scrollController: _scrollController,
            banners: bannersList, // 👉 add banner list if needed
            loadPage: (page) {
              return context.read<AuctionCubit>().getMyAuction();
            },

            items: List.generate(
              auctions.length,
                  (index) {
                final auction = auctions[index];
                return AuctionCard(auction: auction,);
              },
            ),
          ),
        );

      },
    );
  }
}

