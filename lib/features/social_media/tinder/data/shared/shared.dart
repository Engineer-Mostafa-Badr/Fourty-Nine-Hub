// import 'dart:developer';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/gift_cubit.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
// import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
//
// import '../../../../../res/style/styles.dart';
//
// class BottomSheetContent extends StatefulWidget {
//   final String? receiverId;
//
//   const BottomSheetContent({
//     super.key,
//     required this.receiverId,
//   });
//
//   @override
//   BottomSheetContentState createState() => BottomSheetContentState();
// }
//
// class BottomSheetContentState extends State<BottomSheetContent> {
//   late ScrollController _scrollController;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     _scrollController.addListener(_onScroll);
//     _fetchInitialGifts();
//   }
//
//   void _fetchInitialGifts() {
//     context.read<GiftsCubit>().fetchGifts();
//   }
//
//   void _onScroll() {
//     if (_scrollController.position.pixels ==
//         _scrollController.position.maxScrollExtent) {
//       context.read<GiftsCubit>().fetchGifts();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const crossAxisCount = 4; // Adjusts grid based on screen size
//
//     return BlocBuilder<GiftsCubit, GiftsState>(
//       builder: (context, state) {
//         if (state is GiftsInitial) {
//           return const Center(
//             child: CircularProgressIndicator(color: Colors.white),
//           );
//         } else if (state is GiftsLoaded) {
//           return GridView.builder(
//             controller: _scrollController,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: crossAxisCount,
//               childAspectRatio: 1 / 1.5, // Adjust aspect ratio
//             ),
//             itemCount: state.gifts.length + 1,
//             shrinkWrap: true,
//             itemBuilder: (context, index) {
//               if (index < state.gifts.length) {
//                 return _buildGiftItem(context, state.gifts[index],
//                     receiverId: widget.receiverId);
//               } else {
//                 return const Center(
//                     child: CircularProgressIndicator(color: Colors.white));
//               }
//             },
//           );
//         } else if (state is GiftsError) {
//           return Center(
//               child: Text(state.message,
//                   style: const TextStyle(color: Colors.white)));
//         } else {
//           return Container();
//         }
//       },
//     );
//   }
//
//   Widget _buildGiftItem(BuildContext context, GiftData gift,
//       {required String? receiverId}) {
//     return Padding(
//       padding: const EdgeInsets.all(4.0),
//       child: InkWell(
//         onTap: () => _handleGiftTap(context, gift, receiverId: receiverId),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Flexible(child: _buildGiftImage(gift)),
//             const SizedBox(height: 4),
//             Flexible(
//               child: Text(
//                 gift.nameEn ?? 'No Name',
//                 textScaleFactor: 1.0,
//                 textAlign: TextAlign.center,
//                 softWrap: true,
//                 maxLines: null,
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//             const SizedBox(height: 4),
//             FittedBox(
//               child: Text(
//                 '${gift.value ?? 0} 💰',
//                 textScaleFactor: 1.0,
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGiftImage(GiftData gift) {
//     return SvgPicture.network(
//       gift.picture!,
//       fit: BoxFit.scaleDown,
//       placeholderBuilder: (BuildContext context) => Image.asset(
//         'assets/images/icon.png',
//         width: 80.w,
//         height: 80.h,
//       ),
//       width: 80.w,
//       height: 80.h,
//     );
//   }
//
//   Future<void> _handleGiftTap(BuildContext context, GiftData gift,
//       {required String? receiverId}) async {
//     final data = await context.read<TinderViewCubit>().sendGift(
//           receiverId: receiverId!,
//           subCategoryId: '66af974f8bf69f9469944746',
//           giftId: gift.sId ?? '',
//         );
//
//     _handleGiftResponse(context: context, response: data, gift: gift);
//   }
//
//   void _handleGiftResponse({
//     required BuildContext context,
//     required response,
//     required GiftData gift,
//   }) {
//     const insufficientFundsMessage =
//         'You do not have enough money in your wallet.';
//     const successMessage = 'has been sent successfully!';
//
//     if (response.toString().contains('sent Gift Successfully')) {
//       _showDialog(
//         context: context,
//         icon: Icons.card_giftcard,
//         title: 'Gift Sent',
//         message: '$successMessage\nAmount deducted: ¥${gift.value}',
//         isError: false,
//         gift: gift,
//       );
//       return;
//     } else if (response
//         .toString()
//         .contains('You does not have enough money in the wallet')) {
//       _showDialog(
//         context: context,
//         icon: Icons.money_off,
//         title: 'Insufficient Funds',
//         message: insufficientFundsMessage,
//         isError: true,
//       );
//       return;
//     } else {
//       _showDialog(
//         context: context,
//         icon: Icons.error,
//         title: 'Error',
//         message: 'Unexpected error!',
//         isError: true,
//       );
//       return;
//     }
//
//
//   }
//
//   void _showDialog({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     required String message,
//     required bool isError,
//     GiftData? gift,
//   }) {
//     final primaryColor = isError ? Colors.red : Colors.green;
//     final buttonColor = isError ? Colors.red : Colors.indigo;
//
//     Navigator.pop(context);
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
//           title: title == 'Gift Sent'
//               ? const SizedBox.shrink()
//               : _buildDialogTitle(icon, title, primaryColor),
//           content: title == 'Gift Sent'
//               ? _buildGiftContent(gift!, message)
//               : _buildMessageContent(message),
//           actions: _buildDialogActions(context, isError, buttonColor),
//           actionsAlignment: MainAxisAlignment.end,
//         );
//       },
//     );
//   }
//
//   Widget _buildDialogTitle(IconData icon, String title, Color primaryColor) {
//     return Row(
//       children: [
//         Icon(icon, color: primaryColor, size: 30),
//         const SizedBox(width: 10),
//         Text(
//           title,
//           style: TextStyle(fontSize: 45.sp),
//           textScaleFactor: 1.0,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildGiftContent(GiftData gift, String message) {
//     return Wrap(
//       children: [
//         SvgPicture.network(
//           gift.picture ?? '',
//           fit: BoxFit.scaleDown,
//           placeholderBuilder: (BuildContext context) =>
//               Image.asset('assets/images/icon.png', width: 50, height: 50.h),
//           width: 50,
//           height: 50.h,
//         ),
//         Text(
//           "${gift.nameEn} gift $message",
//           textScaleFactor: 1.0,
//           style: TextStyle(
//               fontSize: 30.sp,
//               color: Colors.black87,
//               fontWeight: FontWeight.normal),
//           textAlign: TextAlign.left,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildMessageContent(String message) {
//     return Text(
//       message,
//       textScaleFactor: 1.0,
//       style: TextStyle(
//           fontSize: 30.sp,
//           color: Colors.black87,
//           fontWeight: FontWeight.normal),
//       textAlign: TextAlign.left,
//     );
//   }
//
//   List<Widget> _buildDialogActions(
//       BuildContext context, bool isError, Color buttonColor) {
//     return [
//       TextButton(
//         onPressed: () => Navigator.of(context).pop(),
//         style: TextButton.styleFrom(
//           foregroundColor: Colors.white,
//           backgroundColor:
//               isError ? AppColors.SECONDARY_COLOR : AppColors.WHATS_APP_COLOR,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
//         ),
//         child: Text('OK',
//             textScaleFactor: 1.0,
//             style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.normal)),
//       ),
//       if (isError)
//         TextButton(
//           onPressed: () {
//             serviceLocator<SubscriptionController>()
//                 .showActiveSubscriptionAmounts(walletType: WalletTypes.balance);
//           },
//           style: TextButton.styleFrom(
//             foregroundColor: Colors.white,
//             backgroundColor: AppColors.PRIMARY_COLOR,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0)),
//           ),
//           child: Text(
//             'Charge Wallet',
//             textScaleFactor: 1.0,
//             style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.normal),
//           ),
//         ),
//     ];
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
// }
//
// void showGiftBottomSheet(BuildContext context, {required String? receiverId}) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (context) => MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => GiftsCubit()),
//         BlocProvider(create: (_) => serviceLocator<TinderViewCubit>()),
//         BlocProvider(create: (_) => serviceLocator<UserCubit>()),
//       ],
//       child: DraggableScrollableSheet(
//         initialChildSize: 0.6,
//         minChildSize: 0.4,
//         maxChildSize: 0.9,
//         expand: false,
//         builder: (BuildContext context, ScrollController scrollController) {
//           return Container(
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.8),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   width: double.infinity,
//                   height: kToolbarHeight * 0.80,
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.4),
//                     borderRadius:
//                         const BorderRadius.vertical(top: Radius.circular(20)),
//                   ),
//                   child: FittedBox(
//                     fit: BoxFit.scaleDown,
//                     child: Text(
//                       'Send a gift 🎁',
//                       textScaleFactor: 1.0,
//                       style: TextStyle(
//                           color: AppColors.ACCENT_COLOR,
//                           fontSize: 45.sp,
//                           fontWeight: FontWeight.bold),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Stack(
//                     children: [
//                       BottomSheetContent(receiverId: receiverId),
//                       Positioned(
//                         bottom: 5,
//                         right: 5,
//                         child: Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: OutlinedButton(
//                             style: const ButtonStyle(
//                               side: MaterialStatePropertyAll(BorderSide(
//                                   width: 1, color: AppColors.ACCENT_COLOR)),
//                               iconColor: MaterialStatePropertyAll(Colors.white),
//                               backgroundColor:
//                                   MaterialStatePropertyAll(Colors.black),
//                             ),
//                             onPressed: () {
//                               serviceLocator<SubscriptionController>()
//                                   .showActiveSubscriptionAmounts(
//                                       walletType: WalletTypes.balance);
//                             },
//                             child: Text(
//                               'Recharge 💳',
//                               textScaleFactor: 1.0,
//                               style: TextStyle(
//                                   fontSize: 30.sp,
//                                   fontWeight: FontWeight.normal,
//                                   color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     ),
//   );
// }

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/gift_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../routes/routes.dart';
import '../../../../zoom/presentation/controller/stream_cubit.dart';

class BottomSheetContent extends StatefulWidget {
  final String? receiverId;
  final bool forSelect;
  final void Function(GiftData)? selectGift;

  const BottomSheetContent({
    super.key,
    required this.receiverId,
    this.forSelect = false,
    this.selectGift,
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
    const crossAxisCount = 3; // Adjusts grid based on screen size

    return BlocBuilder<GiftsCubit, GiftsState>(
      builder: (context, state) {
        if (state is GiftsInitial) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if (state is GiftsLoaded) {
          log("${state.length}  "
              "555555555555");

          return GridView.builder(
            controller: _scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 1 / 0.95, // Adjust aspect ratio
            ),
            itemCount: state.gifts.length + 1,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index < state.gifts.length) {
                if (widget.forSelect) {
                  return _buildGiftItemForSelect(
                    context,
                    state.gifts[index],
                    receiverId: widget.receiverId,
                    selectGift: widget.selectGift!,
                  );
                } else {
                  return _buildGiftItem(context, state.gifts[index],
                      receiverId: widget.receiverId);
                }
              } else {
                return const Center(child: CupertinoActivityIndicator());
              }
            },
          );
        } else if (state is GiftsError) {
          return Center(
              child: Text(state.message,
                  textScaleFactor: 1.0,
                  style: const TextStyle(color: Colors.white)));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildGiftItem(BuildContext context, GiftData gift,
      {required String? receiverId}) {
    return InkWell(
      onTap: () => _handleGiftTap(context, gift, receiverId: receiverId),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: _buildGiftImage(gift)),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              context.isArabic ? '${gift.nameAr}' : '${gift.nameEn}',
              textScaler: const TextScaler.linear(1.0),
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: isDarkTheme(context) ? Colors.white : Colors.black87,
                  fontSize: 25.sp),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              '${gift.value ?? 0} 💰',
              textScaler: const TextScaler.linear(1.0),
              style: TextStyle(
                  color: isDarkTheme(context) ? Colors.white : Colors.black87,
                  fontSize: 20.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGiftImage(GiftData gift) {
    return SvgPicture.network(
      gift.picture!,
      fit: BoxFit.scaleDown,
      placeholderBuilder: (BuildContext context) => Image.asset(
        'assets/images/icon.png',
        width: 100.w,
        height: 100.h,
      ),
      width: 100.w,
      height: 100.h,
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
    if (response.toString().contains('sent Gift Successfully')) {
      _showDialog(
        context: context,
        icon: Icons.card_giftcard,
        title: LocaleKeys.gift_body_gift_sent.tr(),
        message:
            '${LocaleKeys.gift_body_sent_successfully.tr()}\n${LocaleKeys.gift_body_amount_deducted.tr()}: ¥${gift.value}',
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
        title: LocaleKeys.gift_body_insufficient_funds.tr(),
        message: LocaleKeys.gift_body_insufficient_funds_message.tr(),
        isError: true,
      );
      return;
    } else {
      _showDialog(
        context: context,
        icon: Icons.error,
        title: LocaleKeys.gift_body_error.tr(),
        message: LocaleKeys.gift_body_unexpected_error.tr(),
        isError: true,
      );
      return;
    }
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
          title: title == LocaleKeys.gift_body_gift_sent.tr()
              ? const SizedBox.shrink()
              : _buildDialogTitle(icon, title, primaryColor),
          content: title == LocaleKeys.gift_body_gift_sent.tr()
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
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(fontSize: 45.sp, fontWeight: FontWeight.bold),
          textScaler: TextScaler.noScaling,
        ),
      ],
    );
  }

  Widget _buildGiftContent(GiftData gift, String message) {
    return Wrap(
      children: [
        Column(
          children: [
            SvgPicture.network(
              gift.picture ?? '',
              fit: BoxFit.scaleDown,
              placeholderBuilder: (BuildContext context) => Image.asset(
                  'assets/images/icon.png',
                  width: 100.w,
                  height: 100.h),
              width: 100.w,
              height: 100.h,
            ),
            Text(
              "${context.isArabic ? gift.nameAr : gift.nameEn}",
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                  fontSize: 40.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ],
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              message,
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                  fontSize: 45.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.normal),
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageContent(String message) {
    return Text(
      message,
      textScaler: TextScaler.noScaling,
      style: TextStyle(
          fontSize: 40.sp,
          color: Colors.black87,
          fontWeight: FontWeight.normal),
      textAlign: TextAlign.start,
    );
  }

  List<Widget> _buildDialogActions(
      BuildContext context, bool isError, Color buttonColor) {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor:
              isError ? AppColors.SECONDARY_COLOR : AppColors.WHATS_APP_COLOR,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        child: Text(LocaleKeys.ok.tr(),
            textScaleFactor: 1.0,
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.normal)),
      ),
      if (isError)
        TextButton(
          onPressed: () {
            serviceLocator<SubscriptionController>()
                .showActiveSubscriptionAmounts(walletType: WalletTypes.balance);
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: AppColors.PRIMARY_COLOR,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
          ),
          child: Text(
            LocaleKeys.gift_body_charge_wallet.tr(),
            textScaleFactor: 1.0,
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.normal),
          ),
        ),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildGiftItemForSelect(BuildContext context, GiftData gift,
      {String? receiverId, required void Function(GiftData) selectGift}) {
    return InkWell(
      onTap: () {
        // context.read<StreamCubit>().selectGift(gift);
        // print(
        //     'selected ${context.read<StreamCubit>().state.selectedGifts.toString()}');
        selectGift.call(gift);
        Navigator.of(context).pop();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: _buildGiftImage(gift)),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              context.isArabic ? '${gift.nameAr}' : '${gift.nameEn}',
              textScaler: const TextScaler.linear(1.0),
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: isDarkTheme(context) ? Colors.white : Colors.black87,
                  fontSize: 25.sp),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              '${gift.value ?? 0} 💰',
              textScaler: const TextScaler.linear(1.0),
              style: TextStyle(
                  color: isDarkTheme(context) ? Colors.white : Colors.black87,
                  fontSize: 20.sp),
            ),
          ),
        ],
      ),
    );
  }
}

void showGiftBottomSheet(BuildContext context,
    {required String? receiverId,
    bool forSelect = false,
    void Function(GiftData)? selectGift}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GiftsCubit()),
        BlocProvider.value(value: serviceLocator<StreamCubit>()),
      ],
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: isDarkTheme(context)
                  ? Colors.black.withOpacity(0.8)
                  : Colors.white.withOpacity(0.9),
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
                    color: isDarkTheme(context)
                        ? Colors.black.withOpacity(0.4)
                        : Colors.grey.withOpacity(0.9),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      forSelect
                          ? LocaleKeys.editYourLiveGoal.tr()
                          : LocaleKeys.gift_body_send_a_gift.tr(),
                      textScaler: const TextScaler.linear(1.0),
                      style: TextStyle(
                          color: isDarkTheme(context)
                              ? AppColors.ACCENT_COLOR
                              : AppColors.PRIMARY_COLOR,
                          fontSize: 40.sp,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      BottomSheetContent(
                        receiverId: receiverId,
                        forSelect: forSelect,
                        selectGift: selectGift,
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: OutlinedButton(
                            style: ButtonStyle(
                              side: const WidgetStatePropertyAll(BorderSide(
                                  width: 1, color: AppColors.ACCENT_COLOR)),
                              iconColor:
                                  const WidgetStatePropertyAll(Colors.white),
                              backgroundColor: isDarkTheme(context)
                                  ? const WidgetStatePropertyAll(Colors.black)
                                  : WidgetStatePropertyAll(
                                      Colors.grey.withOpacity(0.9)),
                            ),
                            onPressed: () {
                              serviceLocator<SubscriptionController>()
                                  .showActiveSubscriptionAmounts(
                                      walletType: WalletTypes.balance);
                            },
                            child: Text(
                              "${LocaleKeys.gift_body_recharge.tr()} 💳",
                              textScaler: const TextScaler.linear(1.0),
                              style: TextStyle(
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkTheme(context)
                                      ? AppColors.YELLOW_COLOR
                                      : Colors.black),
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

String capitalize(String name) {
  if (name.isEmpty) return name;
  return name[0].toUpperCase() + name.substring(1).toLowerCase();
}

String capitalizeAndSplit(String name) {
  if (name.isEmpty) return name;
  List<String> parts = name.split(' ').toList();
  return parts.map(capitalize).join(' ');
}

String capitalizeAndSplit2Only(String name) {
  if (name.isEmpty) return name;
  List<String> parts = name.split(' ').take(2).toList();
  return parts.map(capitalize).join(' ');
}

String getTimeAgo(BuildContext context, String lastSeen) {
  DateTime lastSeenTime = DateTime.parse(lastSeen);
  DateTime now = DateTime.now().toUtc();

  Duration difference = now.difference(lastSeenTime);

  if (difference.inDays > 7) {
    DateFormat dateFormat = DateFormat('E, d/M/yyyy ');
    DateFormat timeFormat = DateFormat('h:mm a');
    String formattedDate = dateFormat.format(lastSeenTime);
    String formattedTime = timeFormat.format(lastSeenTime);
    return context.isArabic
        ? '$formattedDate: $formattedTime'
        : 'Date: $formattedDate\nTime: $formattedTime';
  } else if (difference.inMinutes < 1) {
    return context.isArabic ? 'الآن' : "Just now";
  } else if (difference.inMinutes == 1) {
    return "1 ${context.isArabic ? 'دقيقه' : "minute ago"}";
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes} ${context.isArabic ? 'دقائق' : 'minutes ago'}";
  } else if (difference.inHours == 1) {
    return context.isArabic ? 'ساعة' : "1 hour ago";
  } else {
    return "${difference.inHours} ${context.isArabic ? 'ساعة' : 'hours ago'}";
  }
}

pleaseLoginWidget(context) {
  return StatefulBuilder(builder: (context, setState) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: OutlinedButton(
          onPressed: () => context.push(Routes.LOGIN),
          style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(
                  isDarkTheme(context) ? Colors.white70 : Colors.black87)),
          child: FittedBox(
            child: Text(
              LocaleKeys.pleaseLoginRegisterToEnjoyTheApp.tr(),
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                fontSize: 22.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  });
}
