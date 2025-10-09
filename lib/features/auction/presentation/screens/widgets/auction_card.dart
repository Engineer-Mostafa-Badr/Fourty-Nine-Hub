import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/common/global_card.dart';
import 'package:fourtyninehub/features/auction/presentation/screens/widgets/show_winner_widget.dart';
import 'package:fourtyninehub/features/auction/presentation/screens/widgets/winner_overlay_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../domain/entities/get_all_auction_entity.dart';
import '../../../domain/entities/listen_winner_bid_entity.dart';
import '../../cubit/auction_cubit.dart';
import '../fetch_single_auction_screen.dart';
import 'auction_image_slider.dart';

class AuctionCard extends StatelessWidget {
  final GetAvailableAuctionEntity auction;
  final bool isFavorite;

  const AuctionCard({
    super.key,
    required this.auction,
    this.isFavorite = false,
  });
  String _formatTimeLeft(BuildContext context) {
    final endAt = auction.endAt;
    if (endAt == null) return '';

    final nowUtc = DateTime.now().toUtc();
    final endUtc = endAt.isUtc ? endAt : endAt.toUtc();

    if (endUtc.isBefore(nowUtc)) {
      return context.isArabic ? 'انتهى' : 'Ended';
    }

    final diff = endUtc.difference(nowUtc);

    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    final seconds = diff.inSeconds % 60;

    String format(num number) => _formatNumber(context, number);

    if (days > 0) {
      if (hours > 0) {
        return context.isArabic
            ? '${format(days)} يوم ${format(hours)} ساعة متبقية'
            : '${format(days)}d ${format(hours)}h left';
      }
      return context.isArabic
          ? '${format(days)} يوم متبقي'
          : '${format(days)}d left';
    }

    if (hours > 0) {
      if (minutes > 0) {
        return context.isArabic
            ? '${format(hours)} ساعة ${format(minutes)} دقيقة متبقية'
            : '${format(hours)}h ${format(minutes)}m left';
      }
      return context.isArabic
          ? '${format(hours)} ساعة متبقية'
          : '${format(hours)}h left';
    }

    if (minutes > 0) {
      return context.isArabic
          ? '${format(minutes)} دقيقة متبقية'
          : '${format(minutes)}m left';
    }

    if (seconds > 0) {
      return context.isArabic
          ? '${format(seconds)} ثانية متبقية'
          : '${format(seconds)}s left';
    }

    return context.isArabic
        ? 'أقل من ثانية متبقية'
        : 'Less than 1s left';
  }



  String _formatNumber(BuildContext context, num? number) {
    if (number == null) return "0";

    final locale = context.isArabic ? 'ar' : 'en';
    final formatter = NumberFormat.decimalPattern(locale);
    String formatted = formatter.format(number);

    if (context.isArabic) {
      const english = ['0','1','2','3','4','5','6','7','8','9'];
      const arabic = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];

      for (int i = 0; i < english.length; i++) {
        formatted = formatted.replaceAll(english[i], arabic[i]);
      }
    }

    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    bool isEnded = auction.status == "ended";

    return Container(
      margin: EdgeInsets.all(8),
      child: GlobalCard(
        subcategoryId: '',
        phone: '',
        reportId: '',
        otherUserId: '',
        onTap: () {
          },
        hasTopSide: true,
        hasBottomSide: false,
        subscriptionType: LocaleKeys.notSubscribed.localize,
        views: auction.views,
        onRequest: (){
      
        },
        onShowViewers: () async {
          final cubit = context.read<AuctionCubit>();

          // Fetch viewers first
          await cubit.fetchViewerEntity(id: auction.id!);

          final viewers = cubit.state.auctionViewerData;

          if (viewers != null && viewers.isNotEmpty) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue.shade50, Colors.purple.shade50],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade600,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.people, color: Colors.white, size: 24),
                                ),
                                SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Auction Viewers",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade900,
                                      ),
                                    ),
                                    Text(
                                      "${viewers.length} ${viewers.length == 1 ? 'viewer' : 'viewers'} online",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.close, color: Colors.grey.shade700),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),

                        // Viewers list
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: viewers.isEmpty
                                ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(48.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.people_outline, size: 64, color: Colors.grey.shade300),
                                    SizedBox(height: 16),
                                    Text(
                                      "No viewers yet",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                                : ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(8),
                              itemCount: viewers.length,
                              separatorBuilder: (context, index) => Divider(height: 1, indent: 72),
                              itemBuilder: (context, index) {
                                final viewer = viewers[index];
                                final hasImage = viewer.profilePictureKey != null &&
                                    viewer.profilePictureKey!.isNotEmpty;

                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.transparent,
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    leading: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.blue.shade200,
                                          width: 2,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 24,
                                        backgroundColor: Colors.blue.shade100,
                                        backgroundImage: hasImage
                                            ? NetworkImage(viewer.profilePictureKey!)
                                            : null,
                                        child: !hasImage
                                            ? Text(
                                          (viewer.firstName?.isNotEmpty ?? false)
                                              ? viewer.firstName![0].toUpperCase()
                                              : '?',
                                          style: TextStyle(
                                            color: Colors.blue.shade700,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        )
                                            : null,
                                      ),
                                    ),
                                    title: Text(
                                      "${viewer.firstName ?? 'Unknown'} ${viewer.lastName ?? ''}".trim(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    subtitle: viewer.gender != null && viewer.gender!.isNotEmpty
                                        ? Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            viewer.gender?.toLowerCase() == 'male'
                                                ? Icons.male
                                                : viewer.gender?.toLowerCase() == 'female'
                                                ? Icons.female
                                                : Icons.person,
                                            size: 14,
                                            color: Colors.grey.shade500,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            viewer.gender!,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                        : null,
                                    trailing: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade400,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.green.shade200,
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        // Close button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              "Close",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            // Handle empty viewers or error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("No viewers available")),
            );
          }
        },


        onSubscribe: (){
          context.pop();
        },
        body:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + heart
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AuctionImageCarousel(
                    images: auction.media ?? [], // ✅ use empty list if null
                    // images: auction.media ?? [],
                  ),
                ),

                PositionedDirectional(
                  top: 12,
                  start: 12,
                  child: GestureDetector(
                    onTap: () {
                      context.read<AuctionCubit>().toggleFavoriteAuction(auction.id ?? "");
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        // 👇 if forceFavorite=true → always heart filled
                        isFavorite
                            ? Icons.favorite
                            : (auction.isFavorite == true
                            ? Icons.favorite
                            : Icons.favorite_border),
                        color: Colors.red[400],
                        size: 30,
                      ),
                    ),
                  ),

                ),

              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          auction.title ?? "",
                          style: Styles.mediumText(
                            // fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: context.isDarkMode ? Colors.white : Colors.black
                            // height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        child: Text.rich(
                          TextSpan(
                            style:Styles.mediumText(
                              // fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color:context.isDarkMode ? Colors.white :  Colors.black,
                            ),
                            children: [
                              TextSpan(text:LocaleKeys.priceNow.localize),
                              TextSpan(
                                  text: " ${_formatNumber(context,auction.lastPrice ?? 0,)} ",
                                  style: Styles.mediumText(
                                      fontWeight: FontWeight.bold
                                  )
                                // TextStyle(
                                //   fontSize: 30.sp,
                                //   fontWeight: FontWeight.w400,
                                //   color: Color(0xff0B1035),
                                // ),

                              ),
                              TextSpan(
                                text: LocaleKeys.EGP.localize,
                                style: Styles.mediumText(
                                  fontWeight: FontWeight.w600, // bold
                                  color:context.isDarkMode ? Colors.white :  Colors.black,
                                ),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text.rich(
                          TextSpan(
                            style: Styles.mediumText(
                              color:context.isDarkMode ? Colors.white :  Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(text: LocaleKeys.startFrom.localize),
                              TextSpan(
                                // child: SizedBox(
                                //   width: 60,
                                //   child: AutoSizeText(
                                //     " ${_formatNumber(context,auction.price ?? 0)} ",
                                //     style: Styles.mediumText(
                                //       fontWeight: FontWeight.bold,
                                //       color: context.isDarkMode ? Colors.white : Colors.black,
                                //     ),
                                //   ),
                                // ),
                                text: " ${_formatNumber(context,auction.price ?? 0)} ",
                                style: Styles.mediumText(
                                  fontWeight: FontWeight.bold,
                                  color: context.isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: LocaleKeys.EGP.localize,
                                style: Styles.mediumText(
                                  color:context.isDarkMode ? Colors.white :  Colors.black,
                                  fontWeight: FontWeight.w600, // bold
                                ),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          isEnded ? "${LocaleKeys.ended.localize}" : _formatTimeLeft(context
                          ),
                          style: Styles.mediumText(
                            color:context.isDarkMode ? Colors.white :  Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 👈 Left side (participants + views)
                      Flexible(
                        child: Row(
                          children: [
                            // participants
                            Flexible(
                              child: Text(
                                "${_formatNumber(context, auction.numberOfParticipants ?? 0)} ${LocaleKeys.participants.localize}",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // AppButton(
                      //   width: 91,
                      //   backColor: (auction.status == "expired" || auction.status == "pending")
                      //       ? AppColors.grey // grey out if expired or pending
                      //       : auction.isWinner == true
                      //       ? AppColors.cFFAC3F
                      //       : AppColors.PRIMARY_COLOR_DARK,
                      //   onPressed: (auction.status == "expired" || auction.status == "pending")
                      //       ? (){} // 👈 null disables the button completely
                      //       : () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (_) => BlocProvider(
                      //           create: (_) => serviceLocator<AuctionCubit>(),
                      //           child: SingleAuctionScreen(
                      //             auctionId: auction.id ?? "",
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      //   style: Styles.mediumText(
                      //     color: (auction.status == "expired" || auction.status == "pending")
                      //         ? AppColors.grey.shade700
                      //         : auction.isWinner == true
                      //         ? AppColors.black
                      //         : AppColors.whiteColor,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      //   // label: auction.status == "expired"
                      //   //     ? LocaleKeys.expired.localize
                      //   //     : auction.status == "pending"
                      //   //     ? LocaleKeys.pending.localize
                      //   //     : auction.isWinner == true
                      //   //     ? LocaleKeys.winnerAuction.localize
                      //   //     : LocaleKeys.joinNow.localize,
                      //   label: auction.status == "expired"
                      //       ? LocaleKeys.expired.localize
                      //       : auction.status == "pending"
                      //       ? LocaleKeys.pending.localize
                      //       : auction.isWinner == true
                      //       ? LocaleKeys.winnerAuction.localize
                      //       : LocaleKeys.joinNow.localize,
                      // ),
/*
                      AppButton(
                        width: 91,
                        backColor: auction.isWinner == true
                            ? AppColors.cFFAC3F // 🟧 Winner color
                            : (auction.status == "expired" || auction.status == "pending")
                            ? AppColors.grey
                            : AppColors.PRIMARY_COLOR_DARK,

                        onPressed: (auction.status == "expired" || auction.status == "pending")
                            ? () {}
                            : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => serviceLocator<AuctionCubit>(),
                                child: SingleAuctionScreen(
                                  auctionId: auction.id ?? "",
                                ),
                              ),
                            ),
                          );
                        },

                        style: Styles.mediumText(
                          color: auction.isWinner == true
                              ? AppColors.black
                              : (auction.status == "expired" || auction.status == "pending")
                              ? AppColors.grey.shade700
                              : AppColors.whiteColor,
                          fontWeight: FontWeight.w500,
                        ),

                        label: auction.isWinner == true
                            ? LocaleKeys.winnerAuction.localize // 🏆 Winner text
                            : auction.status == "expired"
                            ? LocaleKeys.expired.localize
                            : auction.status == "pending"
                            ? LocaleKeys.pending.localize
                            : LocaleKeys.joinNow.localize,
                      )
*/
                      AppButton(
                        width: 91,
                        backColor: auction.isWinner == true
                            ? AppColors.cFFAC3F
                            : (auction.status == "expired" || auction.status == "pending")
                            ? AppColors.grey
                            : AppColors.PRIMARY_COLOR_DARK,
                        onPressed: () {
                          // Only proceed if not pending
                          if (auction.status != "pending") {
                            if (auction.winnerData != null) {
                              // Show winner overlay for winner or expired auction with winner data
                          /*
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: 'WinnerOverlay',
                                barrierColor: Colors.black54,
                                transitionDuration: const Duration(milliseconds: 200),
                                pageBuilder: (context, _, __) {
                                  // return WinnerOverlay(
                                  // // return WinnerOverlayWidget(
                                  //   winner: auction.winnerData!,
                                  //   onClose: () => Navigator.of(context).pop(),
                                  // );

                                },
                                transitionBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: ScaleTransition(
                                      scale: Tween(begin: 0.95, end: 1.0).animate(animation),
                                      child: child,
                                    ),
                                  );
                                },
                              );
                              */
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: 'WinnerOverlay',
                                barrierColor: Colors.black54, // optional: slight background dim
                                transitionDuration: const Duration(milliseconds: 200),
                                pageBuilder: (context, _, __) {
                                  return WinnerOverlayWidget(
                                    winner: auction.winnerData!,
                                    onClose: () {
                                      Navigator.of(context).pop(); // close overlay
                                    },
                                  );
                                },
                                transitionBuilder: (context, animation, secondaryAnimation, child) {
                                  // optional: fade + scale animation
                                  return FadeTransition(
                                    opacity: animation,
                                    child: ScaleTransition(
                                      scale: Tween(begin: 0.95, end: 1.0).animate(animation),
                                      child: child,
                                    ),
                                  );
                                },
                              );
                            } else if (auction.status != "expired" && auction.status != "winner") {
                              // If no winnerData and not expired/winner, navigate to auction
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (_) => serviceLocator<AuctionCubit>(),
                                    child: SingleAuctionScreen(
                                      auctionId: auction.id ?? "",
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        style: Styles.mediumText(
                          color: auction.isWinner == true
                              ? AppColors.black
                              : (auction.status == "expired" || auction.status == "pending")
                              ? AppColors.grey.shade700
                              : AppColors.whiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                        label: auction.isWinner == true
                            ? LocaleKeys.winnerAuction.localize
                            : auction.status == "expired"
                            ? LocaleKeys.expired.localize
                            : auction.status == "pending"
                            ? LocaleKeys.pending.localize
                            : LocaleKeys.joinNow.localize,
                      )

                      // AppButton(
                      //   width: 91,
                      //   backColor: auction.isWinner == true
                      //       ? AppColors.cFFAC3F
                      //       : (auction.status == "expired" || auction.status == "pending")
                      //       ? AppColors.grey
                      //       : AppColors.PRIMARY_COLOR_DARK,
                      //   onPressed: (auction.status == "expired" || auction.status == "pending")
                      //       ? () {}
                      //       : () {
                      //     if (auction.winnerData != null) {
                      //       showGeneralDialog(
                      //         context: context,
                      //         barrierDismissible: true,
                      //         barrierLabel: 'WinnerOverlay',
                      //         barrierColor: Colors.black54, // optional: slight background dim
                      //         transitionDuration: const Duration(milliseconds: 200),
                      //         pageBuilder: (context, _, __) {
                      //           return WinnerOverlay(
                      //             winner: BidWinnerEntity(
                      //               gender: "Male",
                      //             ),
                      //             onClose: () {
                      //               Navigator.of(context).pop(); // close overlay
                      //             },
                      //           );
                      //         },
                      //         transitionBuilder: (context, animation, secondaryAnimation, child) {
                      //           // optional: fade + scale animation
                      //           return FadeTransition(
                      //             opacity: animation,
                      //             child: ScaleTransition(
                      //               scale: Tween(begin: 0.95, end: 1.0).animate(animation),
                      //               child: child,
                      //             ),
                      //           );
                      //         },
                      //       );
                      //     } else {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (_) => BlocProvider(
                      //             create: (_) => serviceLocator<AuctionCubit>(),
                      //             child: SingleAuctionScreen(
                      //               auctionId: auction.id ?? "",
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     }
                      //   },
                      //   style: Styles.mediumText(
                      //     color: auction.isWinner == true
                      //         ? AppColors.black
                      //         : (auction.status == "expired" || auction.status == "pending")
                      //         ? AppColors.grey.shade700
                      //         : AppColors.whiteColor,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      //   label: auction.isWinner == true
                      //       ? LocaleKeys.winnerAuction.localize
                      //       : auction.status == "expired"
                      //       ? LocaleKeys.expired.localize
                      //       : auction.status == "pending"
                      //       ? LocaleKeys.pending.localize
                      //       : LocaleKeys.joinNow.localize,
                      // )



                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
