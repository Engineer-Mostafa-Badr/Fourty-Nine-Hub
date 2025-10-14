// AVAILABLE TAB
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late final AuctionCubit _cubit; // ✅ نخزن cubit هنا

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
    context.read<AuctionCubit>().loadInitialExpiredNonSocketAuction();



  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuctionCubit, AuctionState>(
      builder: (context, state) {
        final cubit = context.read<AuctionCubit>();
        final auctions = cubit.expiredAuctionNonSocketData;

        Widget body;


         if (state.status == StateStatus.loading && auctions.isEmpty) {
           body = const Center(child: CustomCircularProgressIndicator());
        } else if (auctions.isEmpty) {
          body = Center(child: CustomEmptyWidget(label: LocaleKeys.noAuctionAvailable.localize,));
          // body =  Center(child: Text(LocaleKeys.noAuctionAvailable.localize));
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

        }
        return Scaffold(
          floatingActionButton: isFloatingButtonVisible
              ? buildFloatingAction(context,title:  "${LocaleKeys.addAuction.localize} +", () {
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

