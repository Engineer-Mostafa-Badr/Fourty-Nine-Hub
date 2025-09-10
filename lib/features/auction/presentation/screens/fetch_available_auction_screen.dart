import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../cubit/auction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'available_auction_screen.dart';


class AuctionScreen extends StatefulWidget {
  const AuctionScreen({super.key});

  @override
  State<AuctionScreen> createState() => _AuctionScreenState();
}

class _AuctionScreenState extends State<AuctionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<AuctionCubit>().getAvailableNonSocketAuction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== TOP CONTAINER =====
          Container(
            padding:
                const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: const [
                    Icon(Icons.arrow_back_ios, size: 20),
                    SizedBox(width: 8),
                    Text("Auction",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    Spacer(),
                    Text("(22/1500) Winners",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14)),
                    SizedBox(width: 6),
                    Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    "https://picsum.photos/400/120",
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),

          Row(
            // spacing: 10,
            children: [
              SizedBox(
                width: 15,
              ),
              SvgPicture.asset(Assets.searchIcon),
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: TabBar(
                    tabAlignment: TabAlignment.start,
                    controller: _tabController,
                    isScrollable: true,
                    indicator: const BoxDecoration(color: Colors.transparent),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelPadding: EdgeInsets.zero,
                    // Remove default TabBar padding
                    tabs: List.generate(4, (index) {
                      final labels = [
                        LocaleKeys.available.localize,
                        LocaleKeys.expired.localize,
                        LocaleKeys.favorite.localize,
                        LocaleKeys.requestLog.localize
                      ];
                      return AnimatedBuilder(
                        animation: _tabController,
                        builder: (context, _) {
                          final isSelected = _tabController.index == index;
                          return Container(
                            margin: const EdgeInsets.only(right: 4),
                            // Only 4px space between tabs
                            height: 32,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.PRIMARY_COLOR
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              labels[index],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),

          // ===== BUTTON under tabs =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: AppButton(
              onPressed: () {},
              width: double.infinity,
              backColor: AppColors.cE0E0E0,
              label: LocaleKeys.myAuction.localize,
              style: Styles.mediumText(color: AppColors.black),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                AvailableAuctionScreen(),
                Center(child: Text("Expired Auctions")),
                Center(child: Text("Favorite Auctions")),
                Center(child: Text("Request Log")),
              ],
            ),
          ),
        ],
      ),

    );
  }
}


