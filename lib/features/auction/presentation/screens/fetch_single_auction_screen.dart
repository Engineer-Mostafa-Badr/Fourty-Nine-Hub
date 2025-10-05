import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/auction/presentation/screens/widgets/auction_image_slider.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/enums/base_status_enum.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

import '../../domain/entities/get_all_auction_entity.dart';
import '../../domain/entities/listen_winner_bid_entity.dart';
import '../cubit/auction_cubit.dart';

import 'dart:async';



// Replace these with your actual imports

import 'package:intl/intl.dart';

class SingleAuctionScreen extends StatefulWidget {
  final String auctionId;

  const SingleAuctionScreen({super.key, required this.auctionId});

  @override
  State<SingleAuctionScreen> createState() => _SingleAuctionScreenState();
}

class _SingleAuctionScreenState extends State<SingleAuctionScreen> {
  final TextEditingController _bidController = TextEditingController();
  late final AuctionCubit _cubit; // ✅ نخزن cubit هنا
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
  void initState() {
    super.initState();
    _cubit = context.read<AuctionCubit>(); // ✅ نخزن نفس المرجع

    _cubit.getSingleAuction(widget.auctionId);
    // _cubit.joinAuction(widget.auctionId);
    _cubit.loadInitialParticipants(widget.auctionId);

    // ✅ Socket listeners - تتنادى مرة واحدة
    Future.microtask(() async {
       _cubit.joinAuction(widget.auctionId);
      _cubit.listenToNewBids();
      _cubit.listenToBidErrors();
      _cubit.listenToBidWinner();
    });
    // _cubit.listenToNewBids();
    // _cubit.listenToBidErrors();
    // _cubit.listenToBidWinner();
  }

  @override
  void dispose() {
    _cubit.leaveAuction(widget.auctionId); // ✅ لازم نسيب الغرفة
    _bidController.dispose();
    super.dispose();
  }

  int? _parseBid(String text) {
    const english = ['0','1','2','3','4','5','6','7','8','9'];
    const arabic  = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];

    String normalized = text;
    for (int i = 0; i < arabic.length; i++) {
      normalized = normalized.replaceAll(arabic[i], english[i]);
    }
    return int.tryParse(normalized);
  }

  void _placeBid(BuildContext context, String auctionId) {
    final bidAmount = _parseBid(_bidController.text);
    if (bidAmount == null || bidAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content:Text(
            context.isArabic ? "أدخل مبلغ صالح" : "Enter a valid amount"
        ),
        ),
      );
      return;
    }

    _cubit.sendBid(auctionId, bidAmount);
    _bidController.clear();
  }


  String formatNumber(num number) {
    if (number >= 1000000) {
      return "${(number / 1000000).toStringAsFixed(1)}m";
    } else if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(1)}k";
    } else {
      return number.toString();
    }
  }

  String _toArabicDigits(String input) {
    const english = ['0','1','2','3','4','5','6','7','8','9'];
    const arabic  = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];

    var output = input;
    for (int i = 0; i < english.length; i++) {
      output = output.replaceAll(english[i], arabic[i]);
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuctionCubit, AuctionState>(
          listenWhen: (previous, current) =>
              previous.bidError != current.bidError && current.bidError != null,
          listener: (context, state) {
            if (state.bidError != null) {
              showErrorMessage(
                context,
                state.bidError!.error ?? "Unknown bid error",
              );
            }
          },
        ),
        BlocListener<AuctionCubit, AuctionState>(
          listenWhen: (previous, current) =>
              previous.bidWinner != current.bidWinner &&
              current.bidWinner != null,
          listener: (context, state) {
            final winner = state.bidWinner;
            if (winner != null) {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) => _WinnerDialog(winner: winner),
              );
            }
          },
        ),
      ],
      child: WillPopScope(
        onWillPop: () async {
          // _cubit.leaveAuction(widget.auctionId); // ✅ نسيب الغرفة عند الرجوع
          return true;
        },
        child: Scaffold(
          appBar: AppBar(title:  Text(LocaleKeys.auction.localize)),
          body: BlocBuilder<AuctionCubit, AuctionState>(
            builder: (context, state) {
              if (state.status == StateStatus.loading &&
                  state.singleAuction == null) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == StateStatus.error &&
                  state.singleAuction == null) {
                return  Center(
                    child: Text(
                      context.isArabic ? 'حدث خطأ أثناء تحميل المزاد' : 'Error loading auction',

                    style: TextStyle(color: Colors.red)),
                );
              }

              final auction = state.singleAuction;
              if (auction == null) {
                return Center(
                  child: Text(
                    context.isArabic ? 'المزاد غير موجود' : 'Auction not found',
                  ),
                );

              }

              return Column(
                children: [
                  // Combined auction details and participants
                  Expanded(
                    child: _AuctionDetailsWithParticipants(
                      auction: auction,
                      auctionId: widget.auctionId,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Builder(
                          builder: (context) {
                            final auction = context
                                .read<AuctionCubit>()
                                .state
                                .singleAuction;
                            final minBid = auction?.minBiddingPrice ??
                                10; // 👈 assume field in model
                            final increments = [1, 2, 4, 6, 10]; // multipliers

                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: increments.map((multiplier) {
                                  final value = minBid * multiplier;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: GestureDetector(
                                      // onTap: (){
                                      //   _bidController.text = value.toString();
                                      // },
                                      onTap: () {
                                        final plain = value.toString(); // no formatting
                                        _bidController.text = context.isArabic
                                            ? _toArabicDigits(plain)
                                            : plain;
                                      },

                                      child: SizedBox(
                                        width: 62, // 👈 كل البوكسات نفس العرض
                                        height: 50, // 👈 وكلها نفس الطول
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppColors.cD9D9D9,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          alignment: Alignment.center,
                                          child: Label(
                                            text: _formatNumber(context, value),
                                            // text: "$value",
                                            textAlign: TextAlign.center,
                                            style: Styles.mediumText(
                                              fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                        Sizer(height: 10,),
                        Row(
                          children: [
                            Expanded(
                              child: FormTextField(
                                controller: _bidController,
                                type: TextInputType.number,
                                hint: LocaleKeys.enterYourBid.localize,
                                inputFormatters: [
                                  ArabicEnglishDigitsOnlyFormatter(), // ✅ 1st: Allow only digits
                                  if (context.isArabic) ArabicDigitsFormatter(), // ✅ 2nd: Convert to Arabic
                                  NoPasteFormatterAuction(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            AppButton(
                              padding: 10,
                              onPressed: () =>
                                  _placeBid(context, widget.auctionId),
                              label:LocaleKeys.placeBid.localize,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),


                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
class NoPasteFormatterAuction extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // If the new text length is significantly larger than old text + 1,
    // it's likely a paste operation, so reject it
    if (newValue.text.length > oldValue.text.length + 1) {
      return oldValue;
    }
    return newValue;
  }
}
class _AuctionDetailsWithParticipants extends StatefulWidget {
  final GetAvailableAuctionEntity auction;
  final String auctionId;

  const _AuctionDetailsWithParticipants({
    required this.auction,
    required this.auctionId,
  });

  @override
  State<_AuctionDetailsWithParticipants> createState() =>
      _AuctionDetailsWithParticipantsState();
}

class _AuctionDetailsWithParticipantsState
    extends State<_AuctionDetailsWithParticipants> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _startTimer();

    // Add scroll listener for participants pagination
    final cubit = context.read<AuctionCubit>();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        cubit.getParticipants(widget.auctionId); // 👈 fetch more
      }
    });
  }

  void _calculateTimeLeft() {
    if (widget.auction.endAt != null) {
      final now = DateTime.now();
      final endTime = widget.auction.endAt!;
      final diff = endTime.difference(now);
      setState(() {
        _timeLeft = diff.isNegative ? Duration.zero : diff;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateTimeLeft();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _timeLeft.inDays;
    final hours = _timeLeft.inHours % 24;
    final minutes = _timeLeft.inMinutes % 60;
    final seconds = _timeLeft.inSeconds % 60;

    return BlocBuilder<AuctionCubit, AuctionState>(
      builder: (context, state) {
        final auction =
            state.singleAuction ?? widget.auction; // 👈 use updated auction
        final participants = state.auctionParticipants ?? [];
        final lastBidPrice =
            participants.isNotEmpty ? participants.first.newPrice : null;
        final currentPrice = lastBidPrice ?? widget.auction.lastPrice ?? 0;

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Auction Details Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Auction Image
                    if (widget.auction.media?.isNotEmpty == true)
                      AuctionImageCarousel(
                        images: auction.media!,
                        // images: auction.media ?? [],
                      ),
                    const SizedBox(height: 16),

                    // Title and Description
                    Label(
                      text: widget.auction.title ?? "",
                      style: Styles.headerText(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Label(
                      text: widget.auction.description ?? "",
                      style: Styles.mediumText(fontWeight: FontWeight.w400),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    // Price Information
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Label(
                            text: LocaleKeys.startAuctionFrom.localize,
                            style:
                                Styles.mediumText(fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Flexible(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "${_formatNumber(context,widget.auction.price ?? 0)} ",
                                  style: Styles.mediumText(
                                      fontWeight: FontWeight.w400),
                                ),
                                TextSpan(
                                  text: LocaleKeys.egp.localize,
                                  style: Styles.mediumText(
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Label(
                            text: "${LocaleKeys.priceNow.localize}:",
                            style:
                                Styles.mediumText(fontWeight: FontWeight.w500,
                                color: AppColors.PRIMARY_COLOR_DARK,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Flexible(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "${_formatNumber(context,currentPrice)} ",
                                  style: Styles.mediumText(
                                      fontWeight: FontWeight.w400,   color: AppColors.PRIMARY_COLOR_DARK,),
                                ),
                                TextSpan(
                                  text: LocaleKeys.egp.localize,
                                  style: Styles.mediumText(
                                      fontWeight: FontWeight.w700,   color: AppColors.PRIMARY_COLOR_DARK,),
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 16),
                    // Time left countdown
                    Label(
                      text:LocaleKeys.timeLeftForAuctionEnd.localize,
                      style: Styles.mediumText(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _buildTimeBox("${_formatNumber(context, days)}", LocaleKeys.day.localize),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: _buildTimeBox("${_formatNumber(context, hours)}", LocaleKeys.hour.localize),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: _buildTimeBox("${_formatNumber(context, minutes)}", LocaleKeys.minuteLoc.localize),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: _buildTimeBox("${_formatNumber(context, seconds)}", LocaleKeys.timer_seconds.localize),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.visibility,
                             color: Colors.grey),
                        Sizer(width: 5,),
                        Text(
                          "${_formatNumber(context,auction.views)} ${LocaleKeys.views.localize}",
                          style: Styles.mediumText(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Participants Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Label(
                          text: "${LocaleKeys.liveAuction.localize}",
                          style: Styles.mediumText(fontWeight: FontWeight.w600),
                        ),
                        Label(
                          text:"${ _formatNumber(
                            context,
                            state.auctionParticipants?.length ?? auction.numberOfParticipants,
                          )} ${LocaleKeys.participants.localize}",
                          style: Styles.mediumText(fontWeight: FontWeight.w600),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Participants List Section
            _buildParticipantsList(participants, state),
          ],
        );
      },
    );
  }
  final formatter = NumberFormat.decimalPattern();

  String formatPrice(num? price, bool isArabic) {
    final number = price ?? 0;

    // لو عربي -> locale: 'ar' ، لو إنجليزي -> locale: 'en'
    final formatter = NumberFormat.decimalPattern(isArabic ? 'ar' : 'en');

    return formatter.format(number);
  }
  String timeAgo(BuildContext context, DateTime? date) {
    if (date == null) return "";

    final now = DateTime.now();
    final diff = now.difference(date);

    final isArabic = context.isArabic;

    if (diff.inSeconds < 60) {
      return isArabic
          ? "${_formatNumber(context, diff.inSeconds)} ث"  // ثواني
          : "${diff.inSeconds}s";
    } else if (diff.inMinutes < 60) {
      return isArabic
          ? "${_formatNumber(context, diff.inMinutes)} د"  // دقائق
          : "${diff.inMinutes}m";
    } else if (diff.inHours < 24) {
      return isArabic
          ? "${_formatNumber(context, diff.inHours)} س"  // ساعات
          : "${diff.inHours}h";
    } else if (diff.inDays < 7) {
      return isArabic
          ? "${_formatNumber(context, diff.inDays)} ي"  // أيام
          : "${diff.inDays}d";
    } else {
      final weeks = (diff.inDays / 7).floor();
      return isArabic
          ? "${_formatNumber(context, weeks)} أ"  // أسابيع
          : "${weeks}w";
    }
  }



  Widget _buildParticipantsList(
      List<dynamic> participants, AuctionState state) {
    // 🔹 Case 1: Still loading and no data yet
    if (participants.isEmpty &&
        state.participantsStatus == StateStatus.loading) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // 🔹 Case 2: Failed to load and no data
    if (participants.isEmpty && state.participantsStatus == StateStatus.error) {
      return  SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              context.isArabic ? 'فشل في تحميل المشاركين' : 'Failed to load participants',
            ),

          ),
        ),
      );
    }

    // 🔹 Case 3: Success or already has data
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == participants.length) {
            final cubit = context.read<AuctionCubit>();
            return cubit.hasMoreParticipants
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox(height: 16);
          }

          final p = participants[index];
          return // Replace your ListTile with this custom widget:
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: p.profilePicture != null ? NetworkImage(p.profilePicture!) : null,
                    onBackgroundImageError: p.profilePicture != null
                        ? (_, __) {
                      // Optional: log error or fallback
                      CliLogger.info("Profile image failed to load");
                    }
                        : null,
                    child: p.profilePicture == null
                        ? const Icon(Icons.person, size: 24, color: Colors.white) // fallback logo
                        : null,
                  ),


                  const SizedBox(width: 12),

                  // Name and Time Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(
                         text:  p.username ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            // color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Label(
                          text:  timeAgo(context,p.createdAt?.toLocal()),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Price (Right side)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    // decoration: BoxDecoration(
                    //   color: Colors.green.shade50,
                    //   borderRadius: BorderRadius.circular(20),
                    //   border: Border.all(color: Colors.green.shade200),
                    // ),
                    child: Text(
                      "${_formatNumber(context, p.newPrice)} ${LocaleKeys.egp.localize}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        // color: Colors.green.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            );
        },
        childCount: participants.length + 1,
      ),
    );
  }

  Widget _buildTimeBox(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: 78,
      decoration: BoxDecoration(
        // color: ِAppColors.cE8EDF5,
        color: AppColors.cE8EDF5,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
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
/*
  String _formatNumber(BuildContext context, num? value) {
    if (value == null) return '0';

    if (context.isArabic) {
      const english = ['0','1','2','3','4','5','6','7','8','9'];
      const arabic  = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];

      String text = value.toString();
      for (int i = 0; i < english.length; i++) {
        text = text.replaceAll(english[i], arabic[i]);
      }
      return text;
    }
    return value.toString();
  }

*/
}

class _WinnerDialog extends StatelessWidget {
  final BidWinnerEntity winner;

  const _WinnerDialog({required this.winner});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Crown + Name
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
                // crown
                const SizedBox(width: 8),
                Text(
                  winner.username ?? "",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Avatar
            CircleAvatar(
              radius: 40,
              // backgroundImage: winner.profilePicture != null
              //     ? NetworkImage(winner.profilePicture!)
              //     : null,
              child: Text(winner.username?[0].toUpperCase() ?? "?",
                  style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(height: 16),

            // Price + Auction Title
            Text(
              "${winner.price?.toStringAsFixed(0)} ${LocaleKeys.egp.localize}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              winner.auctionTitle ?? "",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Close button
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                context.isArabic ? 'إغلاق' : 'Close',
              ),

            )
          ],
        ),
      ),
    );
  }
}

class ArabicEnglishDigitsOnlyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final filtered = newValue.text.replaceAll(
        RegExp(r'[^0-9٠-٩]'),
        ''
    );

    return newValue.copyWith(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}

class ArabicDigitsFormatter extends TextInputFormatter {
  static const _english = ['0','1','2','3','4','5','6','7','8','9'];
  static const _arabic  = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String text = newValue.text;
    for (int i = 0; i < _english.length; i++) {
      text = text.replaceAll(_english[i], _arabic[i]);
    }

    return newValue.copyWith(
      text: text,
      selection: newValue.selection, // ✅ Keep cursor position
    );
  }
}