import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wheel_wallet_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/gift_two_cubit/gift_two_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/competition_header_item.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/competition_list_view_item.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_button_wallet_and_gift_and_cashback.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../core/utils/custom_show_dialog.dart';
import '../../domain/entities/gift_competitions_entity.dart';
import 'competitions_pop_up_items.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
// Import your existing files (Entities, Styles, LocaleKeys, etc.)
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
/*
class CompetitionsSection extends StatelessWidget {
  const CompetitionsSection({
    super.key,
    required this.competitions,
    required this.luckyWheel,
    required this.currency,
  });

  final List<GiftCompetitionEntity> competitions;
  final WheelWalletEntity luckyWheel;
  final String currency;

  @override
  Widget build(BuildContext context) {
    // ✅ include lucky wheel as first competition
    final allCompetitions = [
      GiftCompetitionEntity(
        id: 'lucky',
        nameEn: LocaleKeys.luckyWheel.localize,
        nameAr: LocaleKeys.luckyWheel.localize,
        amount: luckyWheel.amount.toString(),
        descriptionEn: luckyWheel.descriptionEn,
        descriptionAr: luckyWheel.descriptionAr,
        descriptionGiftWalletAr: luckyWheel.descriptionGiftWalletAr,
        descriptionGiftWalletEn: luckyWheel.descriptionGiftWalletEn,
        withdrawLimit: luckyWheel.limit.toInt(),
        pricePerRequest: 0,
        maxRequests: luckyWheel.limit,
        countOfRequest: luckyWheel.amount,
        awaitApproval: false,
      ),
      ...competitions,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: LocaleKeys.competitions.localize,
          style: Styles.headerText(fontSize: 32),
        ),
        const SizedBox(height: 16),

        /// 🧩 Grid View replacing ListView
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(4),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 24,  // 50 was a bit too wide
            mainAxisSpacing: 32,   // 100 is excessive; 32 looks elegant
            childAspectRatio: 0.5,
          ),

          itemCount: allCompetitions.length,
          itemBuilder: (context, index) {
            final competition = allCompetitions[index];
            final isLuckyWheel = competition.id == 'lucky';
            return _CompetitionCard(
              title: context.isArabic
                  ? competition.nameAr ?? ''
                  : competition.nameEn ?? '',
              value: FormatNumbers().formatNumber(
                num.tryParse(competition.amount ?? '0') ?? 0,
                useArabicNumerals: context.isArabic,
              ),
              description: context.isArabic
                  ? competition.descriptionAr ?? ''
                  : competition.descriptionEn ?? '',
              secondaryDescription: context.isArabic
                  ? competition.descriptionGiftWalletAr ?? ''
                  : competition.descriptionGiftWalletEn ?? '',
              svgPath: context.isDarkMode
                  ? (isLuckyWheel
                  ? Assets.luckyWheelIconDark
                  : competitionIconsDark[competition.id] ?? '')
                  : (isLuckyWheel
                  ? Assets.luckyWheelIcon
                  : competitionIcons[competition.id] ?? ''),
              percentage: _getPercentage(competition, luckyWheel, isLuckyWheel),
              currency: currency,
              isLuckyWheel: isLuckyWheel,
              onPressed: () async {
                ManageVibration.vibrate();
                showLoadingDialog(context);
                if (isLuckyWheel) {
                  await context.read<GiftTwoCubit>().requestTransferLuckyWheel(
                    context,
                  );
                } else {
                  await context.read<GiftTwoCubit>().requestTransferCompetition(
                    context,
                    competitionId: competition.id ?? '',
                  );
                }
                if (context.mounted) Navigator.pop(context);
              },
            );
          },
        ),
      ],
    );
  }

  double _getPercentage(GiftCompetitionEntity competition,
      WheelWalletEntity luckyWheel, bool isLuckyWheel) {
    if (isLuckyWheel) {
      if (luckyWheel.limit == 0) return 0;
      return (luckyWheel.amount / luckyWheel.limit) * 100;
    } else {
      if ((competition.withdrawLimit ?? 0) == 0) return 0;
      return ((num.tryParse(competition.amount ?? '0') ?? 0) /
          (competition.withdrawLimit ?? 1)) *
          100;
    }
  }
}
class _CompetitionCard extends StatefulWidget {
  const _CompetitionCard({
    required this.title,
    required this.value,
    required this.description,
    required this.secondaryDescription,
    required this.svgPath,
    required this.percentage,
    required this.currency,
    required this.isLuckyWheel,
    required this.onPressed,
  });

  final String title;
  final String value;
  final String description;
  final String secondaryDescription;
  final String svgPath;
  final double percentage;
  final String currency;
  final bool isLuckyWheel;
  final VoidCallback onPressed;

  @override
  State<_CompetitionCard> createState() => _CompetitionCardState();
}

class _CompetitionCardState extends State<_CompetitionCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    final bgColor = dark ? const Color(0xff1C1C1C) : Colors.white;
    final borderColor = dark ? Colors.white12 : Colors.black12;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: _hover ? 1.02 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: bgColor,
            border: Border.all(color: borderColor),
            boxShadow: [
              if (_hover)
                BoxShadow(
                  color: dark
                      ? Colors.tealAccent.withOpacity(0.2)
                      : Colors.blueAccent.withOpacity(0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
            ],
            gradient: _hover
                ? LinearGradient(
              colors: dark
                  ? [const Color(0xff1C1C1C), const Color(0xff262626)]
                  : [Colors.white, Colors.blue.withOpacity(0.03)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // ✅ Important fix
            children: [
              // 🔹 Header (icon + title)
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.blue.withOpacity(0.08),
                    ),
                    child: Center(
                      child: widget.svgPath.isEmpty
                          ? const Icon(Icons.image_not_supported_outlined)
                          : SvgPicture.asset(widget.svgPath, height: 30),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Label(
                      text: widget.title,
                      style: Styles.headerText(fontSize: 20),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 🔹 Amount
              Label(
                text: "${widget.value} ${widget.currency}",
                style: Styles.headerText(
                  fontSize: 22,
                  color: dark ? Colors.tealAccent : Colors.blueAccent,
                ),
              ),

              const SizedBox(height: 12),

              // 🔹 Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (widget.percentage / 100).clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor:
                  dark ? Colors.white10 : Colors.grey.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    dark ? Colors.tealAccent : Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${widget.percentage.toStringAsFixed(1)}%",
                  style: Styles.mediumText(fontSize: 14),
                ),
              ),

              const SizedBox(height: 12),

              // 🔹 Description
              Label(
                text: widget.description,
                style: Styles.mediumText(fontSize: 20),
                maxLines: 3,
              ),

              const SizedBox(height: 12),

              // 🔹 Transfer Button
              CustomButtonWalletAndGiftAndCashback(
                title: LocaleKeys.requestTransfer.localize,
                onPressed: widget.onPressed,
                status: widget.percentage >= 100,
              ),

              const SizedBox(height: 8),

              // 🔹 Secondary Info (optional)
              if (widget.secondaryDescription.isNotEmpty)
                Label(
                  text: widget.secondaryDescription,
                  style: Styles.mediumText(
                    fontSize: 14,
                    color:
                    dark ? Colors.white70 : Colors.black.withOpacity(0.7),
                  ),
                  maxLines: 3,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

*/
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

// ✅ Your existing imports here (LocaleKeys, Styles, etc.)

class CompetitionsSection extends StatelessWidget {
  const CompetitionsSection({
    super.key,
    required this.competitions,
    required this.luckyWheel,
    required this.currency,
  });

  final List<GiftCompetitionEntity> competitions;
  final WheelWalletEntity luckyWheel;
  final String currency;

  @override
  Widget build(BuildContext context) {
    // ✅ include lucky wheel as first competition
    final allCompetitions = [
      GiftCompetitionEntity(
        id: 'lucky',
        nameEn: LocaleKeys.luckyWheel.localize,
        nameAr: LocaleKeys.luckyWheel.localize,
        amount: luckyWheel.amount.toString(),
        descriptionEn: luckyWheel.descriptionEn,
        descriptionAr: luckyWheel.descriptionAr,
        descriptionGiftWalletAr: luckyWheel.descriptionGiftWalletAr,
        descriptionGiftWalletEn: luckyWheel.descriptionGiftWalletEn,
        withdrawLimit: luckyWheel.limit.toInt(),
        pricePerRequest: 0,
        maxRequests: luckyWheel.limit,
        countOfRequest: luckyWheel.amount,
        awaitApproval: false,
      ),
      ...competitions,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: LocaleKeys.competitions.localize,
          style: Styles.headerText(fontSize: 32),
        ),
        const SizedBox(height: 16),

        // ✅ Responsive grid with 2 columns and dynamic height
        LayoutBuilder(
          builder: (context, constraints) {
            return StaggeredGrid.count(
              crossAxisCount: 2, // always 2 per row
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              children: [
                for (final competition in allCompetitions)
                  _CompetitionCard(
                    title: context.isArabic
                        ? competition.nameAr ?? ''
                        : competition.nameEn ?? '',
                    value: FormatNumbers().formatNumber(
                      num.tryParse(competition.amount ?? '0') ?? 0,
                      useArabicNumerals: context.isArabic,
                    ),
                    description: context.isArabic
                        ? competition.descriptionAr ?? ''
                        : competition.descriptionEn ?? '',
                    secondaryDescription: context.isArabic
                        ? competition.descriptionGiftWalletAr ?? ''
                        : competition.descriptionGiftWalletEn ?? '',
                    svgPath: context.isDarkMode
                        ? (competition.id == 'lucky'
                        ? Assets.luckyWheelIconDark
                        : competitionIconsDark[competition.id] ?? '')
                        : (competition.id == 'lucky'
                        ? Assets.luckyWheelIcon
                        : competitionIcons[competition.id] ?? ''),
                    percentage: _getPercentage(
                        competition, luckyWheel, competition.id == 'lucky'),
                    currency: currency,
                    isLuckyWheel: competition.id == 'lucky',
                    onPressed: () async {
                      ManageVibration.vibrate();
                      showLoadingDialog(context);
                      if (competition.id == 'lucky') {
                        await context
                            .read<GiftTwoCubit>()
                            .requestTransferLuckyWheel(context);
                      } else {
                        await context
                            .read<GiftTwoCubit>()
                            .requestTransferCompetition(
                          context,
                          competitionId: competition.id ?? '',
                        );
                      }
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  double _getPercentage(GiftCompetitionEntity competition,
      WheelWalletEntity luckyWheel, bool isLuckyWheel) {
    if (isLuckyWheel) {
      if (luckyWheel.limit == 0) return 0;
      return (luckyWheel.amount / luckyWheel.limit) * 100;
    } else {
      if ((competition.withdrawLimit ?? 0) == 0) return 0;
      return ((num.tryParse(competition.amount ?? '0') ?? 0) /
          (competition.withdrawLimit ?? 1)) *
          100;
    }
  }
}

// ✅ Your existing _CompetitionCard remains the same
class _CompetitionCard extends StatefulWidget {
  const _CompetitionCard({
    required this.title,
    required this.value,
    required this.description,
    required this.secondaryDescription,
    required this.svgPath,
    required this.percentage,
    required this.currency,
    required this.isLuckyWheel,
    required this.onPressed,
  });

  final String title;
  final String value;
  final String description;
  final String secondaryDescription;
  final String svgPath;
  final double percentage;
  final String currency;
  final bool isLuckyWheel;
  final VoidCallback onPressed;

  @override
  State<_CompetitionCard> createState() => _CompetitionCardState();
}

class _CompetitionCardState extends State<_CompetitionCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    final bgColor = dark ? const Color(0xff1C1C1C) : Colors.white;
    final borderColor = dark ? Colors.white12 : Colors.black12;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: _hover ? 1.02 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: bgColor,
            border: Border.all(color: borderColor),
            boxShadow: [
              if (_hover)
                BoxShadow(
                  color: dark
                      ? Colors.tealAccent.withOpacity(0.2)
                      : Colors.blueAccent.withOpacity(0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
            ],
            gradient: _hover
                ? LinearGradient(
              colors: dark
                  ? [const Color(0xff1C1C1C), const Color(0xff262626)]
                  : [Colors.white, Colors.blue.withOpacity(0.03)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // ✅ Let content decide height
            children: [
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.blue.withOpacity(0.08),
                    ),
                    child: Center(
                      child: widget.svgPath.isEmpty
                          ? const Icon(Icons.image_not_supported_outlined)
                          : SvgPicture.asset(widget.svgPath, height: 30),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Label(
                      text: widget.title,
                      style: Styles.headerText(fontSize: 20),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Label(
                text: "${widget.value} ${widget.currency}",
                style: Styles.headerText(
                  fontSize: 22,
                  color: dark ? Colors.tealAccent : Colors.blueAccent,
                ),
              ),

              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (widget.percentage / 100).clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor:
                  dark ? Colors.white10 : Colors.grey.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    dark ? Colors.tealAccent : Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${widget.percentage.toStringAsFixed(1)}%",
                  style: Styles.mediumText(fontSize: 14),
                ),
              ),

              const SizedBox(height: 12),
              Label(
                text: widget.description,
                style: Styles.mediumText(fontSize: 20),
                maxLines: 10, // ✅ Let longer text wrap naturally
              ),
              const SizedBox(height: 12),

              CustomButtonWalletAndGiftAndCashback(
                title: LocaleKeys.requestTransfer.localize,
                onPressed: widget.onPressed,
                status: widget.percentage >= 100,
              ),

              const SizedBox(height: 8),
              if (widget.secondaryDescription.isNotEmpty)
                Label(
                  text: widget.secondaryDescription,
                  style: Styles.mediumText(
                    fontSize: 14,
                    color:
                    dark ? Colors.white70 : Colors.black.withOpacity(0.7),
                  ),
                  maxLines: 5,
                ),
            ],
          ),
        ),
      ),
    );
  }
}


final Map<String, String> competitionIcons = {
  '66bca1717a9c14dbbb053cea': Assets.rideUsageIcon,
  '663e265a9c4c5ed6b7621bc8': Assets.userShippingTripsIcon,
  '66bc9d237a9c14dbbb053cdd': Assets.foodRequestIcon,
  '66bca0847a9c14dbbb053ce1': Assets.patientAppointmentIcon,
  '66bca1cf7a9c14dbbb053cec': Assets.premiumAdvertiseIcon,
  '663e260c9c4c5ed6b7621bc4': Assets.friendsIcon,
  '677d5ff2404736470bb04b46':
      Assets.followRequestIcon, // 'طلب متابعه - Follow Request',
  '677d634a404736470bb04e67': Assets.viewCountIcon,
  '677d566ce7cb468172395aac': Assets.likeClickedIcon,
  '663e25de9c4c5ed6b7621bc0':
      Assets.friendRequestsIcon, //'طلبات صداقه - Friend Requests',
  '677d5efc60a4075f2f61de1e': Assets.followersIcon,
  '677d5c1d60a4075f2f61db00': Assets.profileViewIcon,
  '67a88f44f77f8cccf2fa609b':
      Assets.storyViewsIcon, // 'مشاهدات قصة - Story Views',
  '677d5979a500582a081522b8': Assets.reel_view_icon,
  '677d3ecd12853350f9a1acaf': Assets.postLikesIcon,
  '67aacf8df8842fddb6516ea4':
      Assets.storyLikesIcon, // 'اعجابات القصة - Story Likes',
  '677d1f23f1066ffc57bab771': Assets.reelLikesIcon,
  '66bcaabf7a9c14dbbb053cf7':
      Assets.liveLickesIcon, // 'اعجابات بث مباشر - Live Lickes',
  '66bca14c7a9c14dbbb053ce8':
      Assets.captainTripsIcon, // 'رحلات كابتن - Captain Trips',
  '663e26789c4c5ed6b7621bcc': Assets
      .shippingDriverTripsIcon, // 'رحلات سائق شحن - Shipping Driver Trips',
  '66bca0f87a9c14dbbb053ce6':
      Assets.restauranOrdersIcon, // 'طلبات مطعم - Restaurant Orders',
  '66bca05d7a9c14dbbb053cdf':
      Assets.doctorBookingsIcon, // 'حجوزات دكتور - Doctor Bookings',
  '67ac3a3b1b196340209a8918':
      Assets.clicksOnLiveIcon, // 'النقرات البث المباشرة - Clicks on live',
};

final Map<String, String> competitionIconsDark = {
  '66bca1717a9c14dbbb053cea': Assets.rideUsageIconDark,
  '663e265a9c4c5ed6b7621bc8': Assets.userShippingTripsIconDark,
  '66bc9d237a9c14dbbb053cdd': Assets.foodRequestIconDark,
  '66bca0847a9c14dbbb053ce1': Assets.patientAppointmentIconDark,
  '66bca1cf7a9c14dbbb053cec': Assets.premiumAdvertiseIconDark,
  '663e260c9c4c5ed6b7621bc4': Assets.friendsIconDark,
  '677d5ff2404736470bb04b46':
      Assets.followRequestIconDark, // 'طلب متابعه - Follow Request',
  '677d634a404736470bb04e67': Assets.viewCountIconDark,
  '677d566ce7cb468172395aac': Assets.likeClickedIconDark,
  '663e25de9c4c5ed6b7621bc0':
      Assets.friendRequestsIconDark, //'طلبات صداقه - Friend Requests',
  '677d5efc60a4075f2f61de1e': Assets.followersIconDark,
  '677d5c1d60a4075f2f61db00': Assets.profileViewIconDark,
  '67a88f44f77f8cccf2fa609b':
      Assets.storyViewsIconDark, // 'مشاهدات قصة - Story Views',
  '677d5979a500582a081522b8': Assets.reel_view_icon_dark,
  '677d3ecd12853350f9a1acaf': Assets.postLikesIconDark,
  '67aacf8df8842fddb6516ea4':
      Assets.storyLikesIconDark, // 'اعجابات القصة - Story Likes',
  '677d1f23f1066ffc57bab771': Assets.reelLikesIconDark,
  '66bcaabf7a9c14dbbb053cf7':
      Assets.liveLickesIconDark, // 'اعجابات بث مباشر - Live Lickes',
  '66bca14c7a9c14dbbb053ce8':
      Assets.captainTripsIcon, // 'رحلات كابتن - Captain Trips',
  '663e26789c4c5ed6b7621bcc': Assets
      .shippingDriverTripsIconDark, // 'رحلات سائق شحن - Shipping Driver Trips',
  '66bca0f87a9c14dbbb053ce6':
      Assets.restauranOrdersIconDark, // 'طلبات مطعم - Restaurant Orders',
  '66bca05d7a9c14dbbb053cdf':
      Assets.doctorBookingsIconDark, // 'حجوزات دكتور - Doctor Bookings',
  '67ac3a3b1b196340209a8918':
      Assets.clicksOnLiveIconDark, // 'النقرات البث المباشرة - Clicks on live',
};

/*
class CompetitionsSection extends StatelessWidget {
  const CompetitionsSection({
    super.key,
    required this.competitions,
    required this.luckyWheel,
    required this.currency,
  });

  final List<GiftCompetitionEntity> competitions;
  final WheelWalletEntity luckyWheel;
  final String currency;

  @override
  Widget build(BuildContext context) {
    // ✅ Fixed: Provide all required fields when creating the Lucky Wheel entity
    final allCompetitions = [
      GiftCompetitionEntity(
        id: 'lucky',
        nameEn: LocaleKeys.luckyWheel.localize,
        nameAr: LocaleKeys.luckyWheel.localize,
        amount: luckyWheel.amount.toString(),
        descriptionEn: luckyWheel.descriptionEn,
        descriptionAr: luckyWheel.descriptionAr,
        descriptionGiftWalletAr: luckyWheel.descriptionGiftWalletAr,
        descriptionGiftWalletEn: luckyWheel.descriptionGiftWalletEn,
        withdrawLimit: luckyWheel.limit.toInt(),
        pricePerRequest: 0,
        maxRequests: luckyWheel.limit,
        countOfRequest: luckyWheel.amount,
        awaitApproval: false,
      ),
      ...competitions,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: LocaleKeys.competitions.localize,
          style: Styles.headerText(fontSize: 32),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: allCompetitions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final competition = allCompetitions[index];
            final isLuckyWheel = competition.id == 'lucky';

            return _CompetitionCard(
              title: context.isArabic
                  ? competition.nameAr ?? ''
                  : competition.nameEn ?? '',
              value: FormatNumbers().formatNumber(
                num.tryParse(competition.amount ?? '0') ?? 0,
                useArabicNumerals: context.isArabic,
              ),
              description: context.isArabic
                  ? competition.descriptionAr ?? ''
                  : competition.descriptionEn ?? '',
              secondaryDescription: context.isArabic
                  ? competition.descriptionGiftWalletAr ?? ''
                  : competition.descriptionGiftWalletEn ?? '',
              svgPath: context.isDarkMode
                  ? (isLuckyWheel
                  ? Assets.luckyWheelIconDark
                  : competitionIconsDark[competition.id] ?? '')
                  : (isLuckyWheel
                  ? Assets.luckyWheelIcon
                  : competitionIcons[competition.id] ?? ''),
              percentage: _getPercentage(competition, luckyWheel, isLuckyWheel),
              currency: currency,
              isLuckyWheel: isLuckyWheel,
              onPressed: () async {
                ManageVibration.vibrate();
                showLoadingDialog(context);
                if (isLuckyWheel) {
                  await context.read<GiftTwoCubit>().requestTransferLuckyWheel(
                    context,
                  );
                } else {
                  await context.read<GiftTwoCubit>().requestTransferCompetition(
                    context,
                    competitionId: competition.id ?? '',
                  );
                }
                if (context.mounted) Navigator.pop(context);
              },
            );
          },
        ),
      ],
    );
  }

  double _getPercentage(GiftCompetitionEntity competition,
      WheelWalletEntity luckyWheel, bool isLuckyWheel) {
    if (isLuckyWheel) {
      if (luckyWheel.limit == 0) return 0;
      return (luckyWheel.amount / luckyWheel.limit) * 100;
    } else {
      if ((competition.withdrawLimit ?? 0) == 0) return 0;
      return ((num.tryParse(competition.amount ?? '0') ?? 0) /
          (competition.withdrawLimit ?? 1)) *
          100;
    }
  }
}


class _CompetitionCard extends StatelessWidget {
  const _CompetitionCard({
    required this.title,
    required this.value,
    required this.description,
    required this.secondaryDescription,
    required this.svgPath,
    required this.percentage,
    required this.currency,
    required this.isLuckyWheel,
    required this.onPressed,
  });

  final String title;
  final String value;
  final String description;
  final String secondaryDescription;
  final String svgPath;
  final double percentage;
  final String currency;
  final bool isLuckyWheel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final themeColor = context.isDarkMode
        ? const Color(0xff333333)
        : const Color(0xffF1F1F1);

    return Container(
      decoration: BoxDecoration(
        color: themeColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white24,
                ),
                child: svgPath.isEmpty
                    ? const Icon(Icons.image_not_supported_outlined)
                    : SvgPicture.asset(svgPath),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Label(
                  text: title,
                  style: Styles.headerText(fontSize: 22),
                  maxLines: 2,
                ),
              ),
              Label(
                text: "$value $currency",
                style: Styles.headerText(fontSize: 20),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress bar (percentage visual)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: (percentage / 100).clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: Colors.grey.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                context.isDarkMode ? Colors.tealAccent : Colors.blueAccent,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${percentage.toStringAsFixed(1)}%",
              style: Styles.mediumText(fontSize: 16),
            ),
          ),

          const SizedBox(height: 16),

          // Description
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(Assets.alertIcon, height: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Label(
                  text: description,
                  style: Styles.mediumText(fontSize: 18),
                  maxLines: 4,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Transfer Button
          CustomButtonWalletAndGiftAndCashback(
            title: LocaleKeys.requestTransfer.localize,
            onPressed: onPressed,
            status: percentage >= 100,
          ),

          const SizedBox(height: 12),

          // Secondary Info
          if (secondaryDescription.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(Assets.alertIcon, height: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Label(
                    text: secondaryDescription,
                    style: Styles.mediumText(fontSize: 18),
                    maxLines: 4,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
*/