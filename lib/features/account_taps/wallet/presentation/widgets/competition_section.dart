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
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_button_wallet_and_gift_and_cashback.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import '../../domain/entities/gift_competitions_entity.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Label(
          text: LocaleKeys.competitions.localize,
          style: Styles.headerText(fontSize: 32),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // ✅ Responsive grid with equal height cards
        LayoutBuilder(
          builder: (context, constraints) {
            return StaggeredGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                for (final competition in allCompetitions)
                // ✅ Wrap each card in IntrinsicHeight for equal heights
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
          // ✅ Set a minimum height to ensure all cards are the same size
          constraints: const BoxConstraints(
            minHeight: 290, // Adjust this value based on your content
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
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
          // ✅ Wrap content in SingleChildScrollView to prevent overflow
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
                    "${formatNumberAccordingToLocale(widget.percentage.toStringAsFixed(1), context.isArabic)}%",
                    style: Styles.mediumText(),
                  ),
                ),

                const SizedBox(height: 12),
                EllipsisTextWithDialog(
                  title: widget.title,
                  text: widget.description,
                  svgPath: widget.svgPath, // ✅ show same icon
                  style: Styles.mediumText(fontSize: 20),
                  maxLines: 3,
                ),


                const SizedBox(height: 12),
                CustomButtonWalletAndGiftAndCashback(
                  radius: 8,
                  title: LocaleKeys.requestTransfer.localize,
                  onPressed: widget.onPressed,
                  status: widget.percentage >= 100,
                ),
                const SizedBox(height: 8),
                if (widget.secondaryDescription.isNotEmpty)
                  EllipsisTextWithDialog(
                    title: widget.title,
                    text: widget.secondaryDescription,
                    svgPath: widget.svgPath, // ✅ show same icon
                    style: Styles.mediumText(
                      fontSize: 17,
                      color: dark ? Colors.white70 : Colors.black.withOpacity(0.7),
                    ),
                    maxLines: 2,
                  ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}


String formatNumberAccordingToLocale(String number, bool isArabic) {
  if (!isArabic) return number; // Just return as-is

  const westernToArabicDigits = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
    '.': '٫', // Arabic decimal separator
  };

  return number.split('').map((ch) => westernToArabicDigits[ch] ?? ch).join('');
}

class EllipsisTextWithDialog extends StatefulWidget {
  final String text;
  final String? title;
  final TextStyle? style;
  final int maxLines;
  final TextAlign? textAlign;
  final Color? accentColor;
  final String? svgPath; // ✅ new: path to the competition icon

  const EllipsisTextWithDialog({
    super.key,
    required this.text,
    this.title,
    this.style,
    this.maxLines = 1,
    this.textAlign,
    this.accentColor,
    this.svgPath, // ✅ new
  });

  @override
  State<EllipsisTextWithDialog> createState() => _EllipsisTextWithDialogState();
}

class _EllipsisTextWithDialogState extends State<EllipsisTextWithDialog>
    with SingleTickerProviderStateMixin {
  void _showDialog() {
    if (widget.text.trim().isEmpty) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, anim1, anim2) => Container(),
      transitionBuilder: (ctx, anim1, anim2, child) {
        final curvedAnim = CurvedAnimation(
          parent: anim1,
          curve: Curves.easeOutCubic,
        );

        return Transform.scale(
          scale: Tween<double>(begin: 0.8, end: 1.0).evaluate(curvedAnim),
          child: FadeTransition(
            opacity: curvedAnim,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                decoration: BoxDecoration(
                  color: Theme.of(ctx).dialogBackgroundColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ✅ Header with icon and title
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(ctx).dividerColor.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (widget.accentColor ??
                                  Theme.of(ctx).primaryColor)
                                  .withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: widget.svgPath != null
                                ? SvgPicture.asset(
                              widget.svgPath!,
                              height: 24,
                              width: 24,
                            )
                                : Icon(
                              Icons.info_outline,
                              color: widget.accentColor ??
                                  Theme.of(ctx).primaryColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              widget.title ??
                                  (context.isArabic
                                      ? 'المحتوى الكامل'
                                      : 'Full Content'),
                              style: Theme.of(ctx)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.of(ctx).pop(),
                            borderRadius: BorderRadius.circular(12),
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.close_rounded, size: 24),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ✅ Content
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        physics: const BouncingScrollPhysics(),
                        child: SelectableText(
                          widget.text,
                          style: Styles.mediumText(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final truncatedText = Text(
      widget.text,
      style: widget.style,
      maxLines: widget.maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: widget.textAlign,
    );

    return GestureDetector(
      onTap: _showDialog,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: truncatedText),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _showDialog,
            child: Icon(
              Icons.info_outline,
              size: 18,
              color: AppColors.PRIMARY_COLOR_DARK,
            ),
          ),
        ],
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

