import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/gift_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../../res/style/styles.dart';

class BottomSheetContent extends StatefulWidget {
  final String? receiverId;

  const BottomSheetContent({
    super.key,
    required this.receiverId,
  });

  @override
  BottomSheetContentState createState() => BottomSheetContentState();
}

class BottomSheetContentState extends State<BottomSheetContent> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _fetchInitialGifts();
  }

  void _fetchInitialGifts() {
    context.read<GiftsCubit>().fetchGifts();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<GiftsCubit>().fetchGifts();
    }
  }

  @override
  Widget build(BuildContext context) {
    const crossAxisCount = 4; // Adjusts grid based on screen size

    return BlocBuilder<GiftsCubit, GiftsState>(
      builder: (context, state) {
        if (state is GiftsInitial) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if (state is GiftsLoaded) {
          return GridView.builder(
            controller: _scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 1 / 1.5, // Adjust aspect ratio
            ),
            itemCount: state.gifts.length + 1,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index < state.gifts.length) {
                return _buildGiftItem(context, state.gifts[index],
                    receiverId: widget.receiverId);
              } else {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.white));
              }
            },
          );
        } else if (state is GiftsError) {
          return Center(
              child: Text(state.message,
                  style: const TextStyle(color: Colors.white)));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildGiftItem(BuildContext context, GiftData gift,
      {required String? receiverId}) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => _handleGiftTap(context, gift, receiverId: receiverId),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGiftImage(gift),
            SizedBox(height: 8.h),
            Text(
              gift.nameEn ?? 'No Name',
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: null,
              style: Styles.headerText(color: Colors.white),
            ),
            SizedBox(height: 4.h),
            FittedBox(
              child: Text(
                '${gift.value ?? 0} 💰',
                style:  Styles.mediumText(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGiftImage(GiftData gift) {
    return SvgPicture.network(
      gift.picture!,
      fit: BoxFit.scaleDown,
      placeholderBuilder: (BuildContext context) => Image.asset(
        'assets/images/icon.png',
        width: 80.w,
        height: 80.h,
      ),
      width: 80.w,
      height: 80.h,
    );
  }

  Future<void> _handleGiftTap(BuildContext context, GiftData gift,
      {required String? receiverId}) async {
    final data = await context.read<TinderViewCubit>().sendGift(
          receiverId: receiverId!,
          subCategoryId: '66af974f8bf69f9469944746',
          giftId: gift.sId ?? '',
        );

    _handleGiftResponse(context: context, response: data, gift: gift);
  }

  void _handleGiftResponse({
    required BuildContext context,
    required response,
    required GiftData gift,
  }) {
    const insufficientFundsMessage =
        'You do not have enough money in your wallet.';
    const successMessage = 'has been sent successfully!';

    if (response.toString().contains('sent Gift Successfully')) {
      _showDialog(
        context: context,
        icon: Icons.card_giftcard,
        title: 'Gift Sent',
        message: '$successMessage\nAmount deducted: ¥${gift.value}',
        isError: false,
        gift: gift,
      );
      return;
    } else if (response
        .toString()
        .contains('You does not have enough money in the wallet')) {
      _showDialog(
        context: context,
        icon: Icons.money_off,
        title: 'Insufficient Funds',
        message: insufficientFundsMessage,
        isError: true,
      );
      return;
    } else {
      _showDialog(
        context: context,
        icon: Icons.error,
        title: 'Error',
        message: 'Unexpected error!',
        isError: true,
      );
      return;
    }

    // print("--------------_handleGiftResponse -> ${response["success"]}");
    //
    // switch (response["success"]) {
    // // case '{"success":false,"error":{"name":"Bad Request","httpCode":400,"message":"You does not have enough money in the wallet","data":{},"isOperational":true,"stack":"","domain":"49dev.com"}}':
    //   case false:
    //     _showDialog(
    //       context: context,
    //       icon: Icons.money_off,
    //       title: 'Insufficient Funds',
    //       message: insufficientFundsMessage,
    //       isError: true,
    //     );
    //     break;
    // // case '{"status":true,"message":"sent Gift Successfully"}':
    //   case true:
    //     _showDialog(
    //       context: context,
    //       icon: Icons.card_giftcard,
    //       title: 'Gift Sent',
    //       message: '$successMessage\nAmount deducted: ¥${gift.value}',
    //       isError: false,
    //       gift: gift,
    //     );
    //     break;
    //   default:
    //     _showDialog(
    //       context: context,
    //       icon: Icons.error,
    //       title: 'Error',
    //       message: 'Unexpected error!',
    //       isError: true,
    //     );
    //     break;
    // }
  }

  void _showDialog({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String message,
    required bool isError,
    GiftData? gift,
  }) {
    final primaryColor = isError ? Colors.red : Colors.green;
    final buttonColor = isError ? Colors.red : Colors.indigo;

    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          title: title == 'Gift Sent'
              ? SizedBox.shrink()
              : _buildDialogTitle(icon, title, primaryColor),
          content: title == 'Gift Sent'
              ? _buildGiftContent(gift!, message)
              : _buildMessageContent(message),
          actions: _buildDialogActions(context, isError, buttonColor),
          actionsAlignment: MainAxisAlignment.end,
        );
      },
    );
  }

  Widget _buildDialogTitle(IconData icon, String title, Color primaryColor) {
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: 30),
        SizedBox(width: 10),
        Text(title),
      ],
    );
  }

  Widget _buildGiftContent(GiftData gift, String message) {
    return Wrap(
      children: [
        SvgPicture.network(
          gift.picture ?? '',
          fit: BoxFit.scaleDown,
          placeholderBuilder: (BuildContext context) =>
              Image.asset('assets/images/icon.png', width: 50, height: 50.h),
          width: 50,
          height: 50.h,
        ),
        Text(
          "${gift.nameEn} gift $message",
          style: TextStyle(fontSize: 16.sp, color: Colors.black87),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildMessageContent(String message) {
    return Text(
      message,
      style: TextStyle(fontSize: 16.sp, color: Colors.black87),
      textAlign: TextAlign.left,
    );
  }

  List<Widget> _buildDialogActions(
      BuildContext context, bool isError, Color buttonColor) {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: buttonColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        child: Text('OK', style: TextStyle(fontSize: 16.sp)),
      ),
      if (isError)
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.indigo,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
          ),
          child: const Text('Charge Wallet'),
        ),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

void showGiftBottomSheet(BuildContext context, {required String? receiverId}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GiftsCubit()),
        BlocProvider(create: (_) => serviceLocator<TinderViewCubit>()),
        BlocProvider(create: (_) => serviceLocator<UserCubit>()),
      ],
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: kToolbarHeight * 0.80,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Send a gift 🎁',
                      style: TextStyle(
                          color: AppColors.ACCENT_COLOR,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                      textScaler: TextScaler.linear(1.6),
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      BottomSheetContent(receiverId: receiverId),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: OutlinedButton(
                            style: const ButtonStyle(
                              side: MaterialStatePropertyAll(BorderSide(
                                  width: 1.5, color: AppColors.ACCENT_COLOR)),
                              iconColor: MaterialStatePropertyAll(Colors.white),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.black),
                            ),
                            onPressed: () {
                              serviceLocator<SubscriptionController>()
                                  .showActiveSubscriptionAmounts(
                                      walletType: WalletTypes.balance);
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '💳 Recharge',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                  textScaler: TextScaler.linear(1.2),
                                ),
                                Icon(Icons.arrow_right),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
