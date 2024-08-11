// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
// import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_subcategory_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/shared/tinder_shared_utils.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/tinder_view.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_sub_category_card.dart';
// import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
//
// class OutlineText extends StatelessWidget {
//   final String text;
//   final double strokeWidth;
//   final Color strokeColor;
//   final TextStyle textStyle;
//   final TextScaler textScaler;
//
//   const OutlineText({
//     this.textScaler = const TextScaler.linear(1),
//     super.key,
//     required this.text,
//     this.strokeWidth = 2.5,
//     this.strokeColor = Colors.black,
//     required this.textStyle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Stroke text
//         Text(
//           text,
//           style: textStyle.copyWith(
//             foreground: Paint()
//               ..color = strokeColor
//               ..style = PaintingStyle.stroke
//               ..strokeWidth = strokeWidth,
//           ),
//         ),
//         // Original text
//         Text(
//           text,
//           style: textStyle,
//           textScaler: textScaler,
//         ),
//       ],
//     );
//   }
// }
//
// // _showGiftBottomSheet2(BuildContext context) {
// //   showModalBottomSheet(
// //     context: context,
// //     isScrollControlled: true,
// //     backgroundColor: Colors.black.withOpacity(0.8),
// //     // To simulate the transparent effect
// //     shape: RoundedRectangleBorder(
// //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// //     ),
// //     builder: (context) => BottomSheetContent(),
// //   );
// // }
//
// class BottomSheetContent extends StatefulWidget {
//   final List<GiftData>? gifts;
//
//   final UserData? cardUser;
//
//   final UserEntity? currentLoggedUser;
//
//   // required BuildContext context,
//   // required GiftData gift,
//   // required receiverId,
//   //     required giftId,
//   // required subCategoryId,
//   //     required UserEntity currentLoggedUser,
//
//   const BottomSheetContent({
//     super.key,
//     required this.gifts,
//     required this.cardUser,
//     required this.currentLoggedUser,
//     required subCategoryId,
//   });
//
//   @override
//   State<BottomSheetContent> createState() => _BottomSheetContentState();
// }
//
// class _BottomSheetContentState extends State<BottomSheetContent> {
//   List<GiftData>? items;
//
//   // late final List<Map<String, String>> items;
//   // =
//   // [
//   //   {'icon': '🎶', 'name': 'Universes Music', 'price': '4888'},
//   //   {'icon': '🐎', 'name': 'Arabian Stallion', 'price': '15000'},
//   //   {'icon': '🎈', 'name': 'Tiktok Air Drop', 'price': '999'},
//   //   {'icon': '🏕️', 'name': 'Desert Camp', 'price': '899'},
//   //   {'icon': '🐉', 'name': 'Baby Dragon', 'price': '2000'},
//   //   {'icon': '🐘', 'name': 'Ellie the Elephant', 'price': '5000'},
//   //   {'icon': '💖', 'name': 'Crystal Heart', 'price': '499'},
//   //   {'icon': '🌊', 'name': 'Pool Party', 'price': '4999'},
//   // ];
//   @override
//   void initState() {
//     items = widget.gifts!.toList();
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height / 2,
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: double.infinity,
//               height: kToolbarHeight * 0.75,
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.4),
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(20),
//                 ),
//               ),
//               child: const FittedBox(
//                 fit: BoxFit.scaleDown,
//                 child: Text(
//                   'Send a gift 🎁',
//                   style: TextStyle(
//                       color: AppColors.ACCENT_COLOR,
//                       fontWeight: FontWeight.w300),
//                   textAlign: TextAlign.center,
//                   textScaler: TextScaler.linear(1.6),
//                 ),
//               ),
//             ),
//             const Divider(),
//             // GridView.builder(
//             //   shrinkWrap: true,
//             //   itemCount: items!.length,
//             //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             //     crossAxisCount: 4, // 4 items per row
//             //     childAspectRatio: 1 / 1.5, // To control the item size
//             //   ),
//             //   itemBuilder: (context, index) {
//             //     return Column(
//             //       children: [
//             //         // Text(items![index].picture!, style: TextStyle(fontSize: 40)),
//             //         Text(
//             //           items![index].nameEn!,
//             //           textAlign: TextAlign.center,
//             //           style: TextStyle(color: Colors.white),
//             //         ),
//             //         Text(
//             //           items![index].value.toString(),
//             //           style: TextStyle(color: Colors.yellow),
//             //         ),
//             //       ],
//             //     );
//             //   },
//             // ),
//             GridView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               // itemCount: 100,
//               itemCount: widget.gifts!.length,
//               // Use the gifts list instead of items
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 4, // 4 items per row
//                 childAspectRatio: 1 / 1.5, // To control the item size
//               ),
//               itemBuilder: (context, index) {
//                 final gift = widget.gifts![index]; // Get the gift data
//
//                 return BlocProvider(
//                   create: (context) =>
//                       TinderViewCubit()..fetchGifts(accessToken: ''),
//                   child: BlocBuilder<TinderViewCubit, TinderViewState>(
//                     builder: (context, state) => InkWell(
//                       onTap: () async {
//                         final data =
//                             await context.read<TinderViewCubit>().sendGift(
//                                   receiverId: widget.cardUser?.user?.sId ?? '',
//                                   subCategoryId: '66af974f8bf69f9469944746',
//                                   giftId: gift.sId ?? '',
//                                   currentUserToken: 'currentUserToken',
//                                   accessToken: '',
//                                 );
//                         // handleResponse(snapshot.data ?? '', context);
//                         // Use switch case to handle different response types
//                         log("${data}oppppppppppppppppppppppppp");
//                         TinderSharedUtils.handleGiftResponse(
//                             context: context, response: data!);
//                         // switch (data) {
//                         //   case """{"success":false,"error":{"name":"Bad Request","httpCode":400,"message":"You does not have enough money in the wallet","data":{},"isOperational":true,"stack":"","domain":"49dev.com"}}""":
//                         //     TinderSharedUtils.showInsufficientFundsPopup(
//                         //         context,
//                         //         'You do not have enough money in your wallet.');
//                         //
//                         //     break;
//                         //
//                         //   case """{"status":true,"message":"sent Gift Successfully"}""":
//                         //     TinderSharedUtils.showGiftSentPopup(
//                         //         context, gift.value.toString());
//                         //     break;
//                         //
//                         //   default:
//                         //     TinderSharedUtils.showInsufficientFundsPopup(
//                         //         context, 'Unexpected response format.');
//                         //     break;
//                         // }
//                       },
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           gift.picture != null
//                               ? Image.network(
//                                   gift.picture!,
//                                   width: 50,
//                                   height: 50,
//                                   loadingBuilder:
//                                       (context, child, loadingProgress) =>
//                                           Image.asset(
//                                     'assets/images/icon.png',
//                                     width: 50,
//                                     height: 50,
//                                   ),
//                                   errorBuilder: (context, error, stackTrace) =>
//                                       Image.asset(
//                                     'assets/images/icon.png',
//                                     width: 50,
//                                     height: 50,
//                                   ),
//                                 )
//                               : Image.asset(
//                                   'assets/images/icon.png',
//                                   width: 50,
//                                   height: 50,
//                                 ),
//                           // Placeholder if no image
//                           const SizedBox(height: 8),
//                           // Spacing between image and text
//                           Text(
//                             gift.nameEn ?? 'No Name',
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                                 fontSize: 16, color: Colors.white),
//                           ),
//                           const SizedBox(height: 4),
//                           // Spacing between name and value
//                           Text(
//                             '${gift.value ?? 0} 💰',
//                             // Default to 0 if value is null
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//
//             const SizedBox(height: 20),
//             // ElevatedButton(
//             //   onPressed: () {},
//             //   child: const Text('Recharge'),
//             //   style: ElevatedButton.styleFrom(
//             //     backgroundColor: Colors.amber,
//             //   ),
//             // ),
//             Align(
//               alignment: Alignment.bottomRight
//               // bottom: 10,
//               // right: 0,
//               // left: 500,
//               ,
//               child: Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: OutlinedButton(
//                   style: ButtonStyle(
//                     side: const MaterialStatePropertyAll(BorderSide(
//                       // strokeAlign: 5,
//                       width: 0,
//                       // color: AppColors.ACCENT_COLOR,
//                     )),
//                     iconColor: const MaterialStatePropertyAll(Colors.white),
//                     backgroundColor: MaterialStatePropertyAll(
//                       Colors.black.withOpacity(0.8),
//                     ),
//                   ),
//                   onPressed: () {
//                     serviceLocator<SubscriptionController>()
//                         .showActiveSubscriptionAmounts(
//                             walletType: WalletTypes.balance);
//                   },
//                   child: const Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         '💳 Recharge',
//                         style: TextStyle(
//                             fontWeight: FontWeight.normal, color: Colors.white),
//                         textScaler: TextScaler.linear(1.2),
//                       ),
//                       Icon(Icons.arrow_right),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
// //......................................................
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
// // import 'package:fourtyninehub/res/style/app_colors.dart';
// //
// // class OutlineText extends StatelessWidget {
// //   final String text;
// //   final double strokeWidth;
// //   final Color strokeColor;
// //   final TextStyle textStyle;
// //   final TextScaler textScaler;
// //
// //   const OutlineText({
// //     Key? key,
// //     required this.text,
// //     this.strokeWidth = 2.5,
// //     this.strokeColor = Colors.black,
// //     required this.textStyle,
// //     this.textScaler = const TextScaler.linear(1),
// //   }) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Stack(
// //       children: [
// //         Text(
// //           text,
// //           style: textStyle.copyWith(
// //             foreground: Paint()
// //               ..color = strokeColor
// //               ..style = PaintingStyle.stroke
// //               ..strokeWidth = strokeWidth,
// //           ),
// //         ),
// //         Text(
// //           text,
// //           style: textStyle,
// //           textScaler: textScaler,
// //         ),
// //       ],
// //     );
// //   }
// // }
// //
// // class BottomSheetContent extends StatefulWidget {
// //   final List<GiftModel>? gifts;
// //   final UserData? cardUser;
// //   final UserEntity? currentLoggedUser;
// //
// //   const BottomSheetContent({
// //     Key? key,
// //     required this.gifts,
// //     required this.cardUser,
// //     required this.currentLoggedUser,
// //   }) : super(key: key);
// //
// //   @override
// //   _BottomSheetContentState createState() => _BottomSheetContentState();
// // }
// //
// // class _BottomSheetContentState extends State<BottomSheetContent> {
// //   late List<GiftModel> items;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     items = widget.gifts?.toList() ?? [];
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SizedBox(
// //       height: MediaQuery.of(context).size.height / 2,
// //       child: SingleChildScrollView(
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             _buildHeader(),
// //             const Divider(),
// //             _buildGiftGrid(),
// //             const SizedBox(height: 20),
// //             _buildRechargeButton(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildHeader() {
// //     return Container(
// //       width: double.infinity,
// //       height: kToolbarHeight * 0.75,
// //       decoration: BoxDecoration(
// //         color: Colors.black.withOpacity(0.4),
// //         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
// //       ),
// //       child: const FittedBox(
// //         fit: BoxFit.scaleDown,
// //         child: Text(
// //           'Send a gift 🎁',
// //           style: TextStyle(
// //             color: AppColors.ACCENT_COLOR,
// //             fontWeight: FontWeight.w300,
// //           ),
// //           textAlign: TextAlign.center,
// //           textScaler: TextScaler.linear(1.6),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildGiftGrid() {
// //     return GridView.builder(
// //       physics: const NeverScrollableScrollPhysics(),
// //       shrinkWrap: true,
// //       itemCount: widget.gifts?.length ?? 0,
// //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //         crossAxisCount: 4,
// //         childAspectRatio: 1 / 1.5,
// //       ),
// //       itemBuilder: (context, index) {
// //         final gift = widget.gifts![index];
// //         return BlocProvider(
// //           create: (context) => TinderViewCubit()..fetchGifts(),
// //           child: BlocBuilder<TinderViewCubit, TinderState>(
// //             builder: (context, state) {
// //               return InkWell(
// //                 onTap: () async {
// //                   final data = await context.read<TinderViewCubit>().sendGift(
// //                     receiverId: widget.cardUser?.user?.sId ?? '',
// //                     subCategoryId: '66af974f8bf69f9469944746',
// //                     giftId: gift.sId ?? '',
// //                     currentUserToken: 'currentUserToken',
// //                   );
// //
// //                   _handleResponse(context, data);
// //                 },
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     gift.picture != null
// //                         ? Image.network(
// //                       gift.picture!,
// //                       width: 50,
// //                       height: 50,
// //                       errorBuilder: (context, error, stackTrace) =>
// //                           Image.asset('assets/images/icon.png', width: 50, height: 50),
// //                     )
// //                         : Image.asset('assets/images/icon.png', width: 50, height: 50),
// //                     const SizedBox(height: 8),
// //                     Text(
// //                       gift.nameEn ?? 'No Name',
// //                       textAlign: TextAlign.center,
// //                       style: const TextStyle(fontSize: 16, color: Colors.white),
// //                     ),
// //                     const SizedBox(height: 4),
// //                     Text(
// //                       '${gift.value ?? 0} 💰',
// //                       style: const TextStyle(color: Colors.white),
// //                     ),
// //                   ],
// //                 ),
// //               );
// //             },
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   Future<void> _handleResponse(BuildContext context, String data) async {
// //     switch (data) {
// //       case '{"success":false,"error":{"name":"Bad Request","httpCode":400,"message":"You do not have enough money in the wallet","data":{},"isOperational":true,"stack":"","domain":"49dev.com"}}':
// //         showInsufficientFundsPopup(context, 'You do not have enough money in your wallet.');
// //         break;
// //       case '{"status":true,"message":"sent Gift Successfully"}':
// //         showGiftSentPopup(context, 'Gift sent successfully!');
// //         break;
// //       default:
// //         showInsufficientFundsPopup(context, 'Unexpected response format.');
// //         break;
// //     }
// //   }
// //
// //   Widget _buildRechargeButton() {
// //     return Align(
// //       alignment: Alignment.bottomRight,
// //       child: Padding(
// //         padding: const EdgeInsets.all(4.0),
// //         child: OutlinedButton(
// //           style: ButtonStyle(
// //             side: const MaterialStatePropertyAll(BorderSide(width: 0)),
// //             backgroundColor: MaterialStatePropertyAll(Colors.black.withOpacity(0.8)),
// //           ),
// //           onPressed: () {
// //             // Handle recharge action
// //           },
// //           child: const Row(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Text(
// //                 '💳 Recharge',
// //                 style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white),
// //               ),
// //               Icon(Icons.arrow_right),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //---------------------------------
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
// // import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
// // import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
// // import 'package:fourtyninehub/res/style/app_colors.dart';
// // import 'package:fourtyninehub/service_locator/service_locator.dart';
// //
// // class OutlineText extends StatelessWidget {
// //   final String text;
// //   final double strokeWidth;
// //   final Color strokeColor;
// //   final TextStyle textStyle;
// //   final TextScaler textScaler;
// //
// //   const OutlineText({
// //     Key? key,
// //     required this.text,
// //     this.strokeWidth = 2.5,
// //     this.strokeColor = Colors.black,
// //     required this.textStyle,
// //     this.textScaler = const TextScaler.linear(1),
// //   }) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Stack(
// //       children: [
// //         Text(
// //           text,
// //           style: textStyle.copyWith(
// //             foreground: Paint()
// //               ..color = strokeColor
// //               ..style = PaintingStyle.stroke
// //               ..strokeWidth = strokeWidth,
// //           ),
// //         ),
// //         Text(
// //           text,
// //           style: textStyle,
// //           textScaler: textScaler,
// //         ),
// //       ],
// //     );
// //   }
// // }
// //
// // class BottomSheetContent extends StatelessWidget {
// //   final List<GiftData> gifts;
// //   final UserData? cardUser;
// //   final UserEntity? currentLoggedUser;
// //
// //   const BottomSheetContent({
// //     Key? key,
// //     required this.gifts,
// //     required this.cardUser,
// //     required this.currentLoggedUser,
// //   }) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SizedBox(
// //       height: MediaQuery.of(context).size.height / 2,
// //       child: SingleChildScrollView(
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             _buildHeader(),
// //             const Divider(),
// //             _buildGiftGrid(),
// //             const SizedBox(height: 20),
// //             _buildRechargeButton(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildHeader() {
// //     return Container(
// //       width: double.infinity,
// //       height: kToolbarHeight * 0.75,
// //       decoration: BoxDecoration(
// //         color: Colors.black.withOpacity(0.4),
// //         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
// //       ),
// //       child: const FittedBox(
// //         fit: BoxFit.scaleDown,
// //         child: Text(
// //           'Send a gift 🎁',
// //           style: TextStyle(
// //             color: AppColors.ACCENT_COLOR,
// //             fontWeight: FontWeight.w300,
// //           ),
// //           textAlign: TextAlign.center,
// //           textScaler: TextScaler.linear(1.6),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildGiftGrid() {
// //     return GridView.builder(
// //       physics: const NeverScrollableScrollPhysics(),
// //       shrinkWrap: true,
// //       itemCount: gifts.length,
// //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //         crossAxisCount: 4,
// //         childAspectRatio: 1 / 1.5,
// //       ),
// //       itemBuilder: (context, index) => _buildGiftItem(context, gifts[index]),
// //     );
// //   }
// //
// //   Widget _buildGiftItem(BuildContext context, GiftData gift) {
// //     return BlocProvider(
// //       create: (context) => TinderViewCubit()..fetchGifts(),
// //       child: BlocBuilder<TinderViewCubit, TinderViewState>(
// //         builder: (context, state) => InkWell(
// //           onTap: () => _handleGiftTap(context, gift),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               _buildGiftImage(gift),
// //               const SizedBox(height: 8),
// //               Text(
// //                 gift.nameEn ?? 'No Name',
// //                 textAlign: TextAlign.center,
// //                 style: const TextStyle(fontSize: 16, color: Colors.white),
// //               ),
// //               const SizedBox(height: 4),
// //               Text(
// //                 '${gift.value ?? 0} 💰',
// //                 style: const TextStyle(color: Colors.white),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildGiftImage(GiftData gift) {
// //     return gift.picture != null
// //         ? Image.network(
// //       gift.picture!,
// //       width: 50,
// //       height: 50,
// //       errorBuilder: (context, error, stackTrace) =>
// //           Image.asset('assets/images/icon.png', width: 50, height: 50),
// //     )
// //         : Image.asset('assets/images/icon.png', width: 50, height: 50);
// //   }
// //
// //   Future<void> _handleGiftTap(BuildContext context, GiftData gift) async {
// //     final data = await context.read<TinderViewCubit>().sendGift(
// //       receiverId: cardUser?.user?.sId ?? '',
// //       subCategoryId: '66af974f8bf69f9469944746',
// //       giftId: gift.sId ?? '',
// //       currentUserToken: 'currentUserToken',
// //     );
// //
// //     _handleGiftResponse(context, data, gift);
// //   }
// //
// //   void _handleGiftResponse(BuildContext context, String response, GiftData gift) {
// //     switch (response) {
// //       case """{"success":false,"error":{"name":"Bad Request","httpCode":400,"message":"You does not have enough money in the wallet","data":{},"isOperational":true,"stack":"","domain":"49dev.com"}}""":
// //         showInsufficientFundsPopup(context, 'You do not have enough money in your wallet.');
// //         break;
// //       case """{"status":true,"message":"sent Gift Successfully"}""":
// //         showGiftSentPopup(context, gift.value.toString());
// //         break;
// //       default:
// //         showInsufficientFundsPopup(context, 'Unexpected response format.');
// //         break;
// //     }
// //   }
// //
// //   Widget _buildRechargeButton() {
// //     return Align(
// //       alignment: Alignment.bottomRight,
// //       child: Padding(
// //         padding: const EdgeInsets.all(4.0),
// //         child: OutlinedButton(
// //           style: ButtonStyle(
// //             side: const MaterialStatePropertyAll(BorderSide(width: 0)),
// //             iconColor: const MaterialStatePropertyAll(Colors.white),
// //             backgroundColor: MaterialStatePropertyAll(Colors.black.withOpacity(0.8)),
// //           ),
// //           onPressed: () {
// //             serviceLocator<SubscriptionController>()
// //                 .showActiveSubscriptionAmounts(walletType: WalletTypes.balance);
// //           },
// //           child: const Row(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Text(
// //                 '💳 Recharge',
// //                 style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white),
// //                 textScaler: TextScaler.linear(1.2),
// //               ),
// //               Icon(Icons.arrow_right),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// class AddWid extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'عروسة - Ad Widget',
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//         textTheme: const TextTheme(
//           bodyText1: TextStyle(color: Colors.black87),
//           bodyText2: TextStyle(color: Colors.black54),
//         ),
//       ),
//       home: Scaffold(
//         appBar: AppBar(title: const Text('عروسة - Ad Widget')),
//         body: AdWidget(),
//       ),
//     );
//   }
// }
//
// class AdWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Card(
//         elevation: 8,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Image at the top
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(15),
//                 child: Image.network(
//                   'https://via.placeholder.com/300x150.png?text=عروسة',
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 '💃💃استمارة عروسة: #عروسة كود S1879',
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.purple),
//               ),
//               const SizedBox(height: 10),
//               const Divider(),
//               _buildInfoRow('المحافظة:', 'الجيزه'),
//               _buildInfoRow('الاقامة:', 'الهرم'),
//               _buildInfoRow('السن:', '٤٤و٨شهور'),
//               _buildInfoRow('المؤهل الدراسي:', 'دبلوم'),
//               _buildInfoRow('الوظيفه:', 'ربه منزل'),
//               _buildInfoRow('الطول:', '١٦٠ سم'),
//               _buildInfoRow('الوزن:', '٨٠ كجم'),
//               _buildInfoRow('لون البشره:', 'بيضاء'),
//               _buildInfoRow('الحاله الاجتماعيه:', 'ارمله'),
//               _buildInfoRow('عدد الأبناء:', '٣ بنات'),
//               _buildInfoRow('الديانة:', 'مسلمه'),
//               _buildInfoRow('مواظبه علي الصلاه:', 'الحمدلله غير مواظبه'),
//               _buildInfoRow('نوع الحجاب:', 'حجاب'),
//               _buildInfoRow('الانتقال لمحافظه أخري:', 'لا الجيزه والقاهره فقط'),
//               _buildInfoRow('تقبل التعدد:', 'لا'),
//               _buildInfoRow('مواصفات العريس المطلوب:', 'علي خلق ويتقي الله'),
//               const SizedBox(height: 10),
//               const Divider(),
//               const Center(
//                 child: Text(
//                   'للتواصل مع الادمن عالخاص',
//                   style: TextStyle(
//                       color: Colors.blue,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Text(
//               title,
//               style: const TextStyle(
//                   fontWeight: FontWeight.bold, color: Colors.purple),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               textAlign: TextAlign.end,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//

//down enhanced

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_subcategory_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/tinder_shared_utils.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_sub_category_card.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class OutlineText extends StatelessWidget {
  final String text;
  final double strokeWidth;
  final Color strokeColor;
  final TextStyle textStyle;
  final TextScaler textScaler;

  const OutlineText({
    this.textScaler = const TextScaler.linear(1),
    super.key,
    required this.text,
    this.strokeWidth = 2.5,
    this.strokeColor = Colors.black,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Stroke text
        Text(
          text,
          style: textStyle.copyWith(
            foreground: Paint()
              ..color = strokeColor
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth,
          ),
        ),
        // Original text
        Text(
          text,
          style: textStyle,
          textScaler: textScaler,
        ),
      ],
    );
  }
}

class BottomSheetContent extends StatefulWidget {
  final List<GiftData>? gifts;
  final UserData? cardUser;
  final UserEntity? currentLoggedUser;

  const BottomSheetContent({
    super.key,
    required this.gifts,
    required this.cardUser,
    required this.currentLoggedUser,
  });

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  late final List<GiftData> items;

  @override
  void initState() {
    super.initState();
    items = widget.gifts?.toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const Divider(),
            _buildGiftGrid(),
            const SizedBox(height: 20),
            _buildRechargeButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: kToolbarHeight * 0.75,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: const FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'Send a gift 🎁',
          style: TextStyle(
            color: AppColors.ACCENT_COLOR,
            fontWeight: FontWeight.w300,
          ),
          textAlign: TextAlign.center,
          textScaler: TextScaler.linear(1.6),
        ),
      ),
    );
  }

  Widget _buildGiftGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1 / 1.5,
      ),
      itemBuilder: (context, index) => _buildGiftItem(context, items[index]),
    );
  }

  Widget _buildGiftItem(BuildContext context, GiftData gift) {
    return BlocProvider(
      create: (context) => TinderViewCubit()..fetchGifts(accessToken: ''),
      child: BlocBuilder<TinderViewCubit, TinderViewState>(
        builder: (context, state) {
          return InkWell(
            onTap: () => _handleGiftTap(context, gift),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGiftImage(gift),
                const SizedBox(height: 8),
                Text(
                  gift.nameEn ?? 'No Name',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  '${gift.value ?? 0} 💰',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGiftImage(GiftData gift) {
    return gift.picture != null
        ? Image.network(
      gift.picture!,
      width: 50,
      height: 50,
      loadingBuilder: (context, child, loadingProgress) => Image.asset(
        'assets/images/icon.png',
        width: 50,
        height: 50,
      ),
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/icon.png',
        width: 50,
        height: 50,
      ),
    )
        : Image.asset(
      'assets/images/icon.png',
      width: 50,
      height: 50,
    );
  }

  Future<void> _handleGiftTap(BuildContext context, GiftData gift) async {
    final data = await context.read<TinderViewCubit>().sendGift(
      receiverId: widget.cardUser?.user?.sId ?? '',
      subCategoryId: '66af974f8bf69f9469944746',
      giftId: gift.sId ?? '',
      currentUserToken: 'currentUserToken',
      accessToken: '',
    );

    TinderSharedUtils.handleGiftResponse(context: context, response: data!);
  }

  Widget _buildRechargeButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: OutlinedButton(
          style: ButtonStyle(
            side: const MaterialStatePropertyAll(BorderSide(width: 0)),
            iconColor: const MaterialStatePropertyAll(Colors.white),
            backgroundColor: MaterialStatePropertyAll(Colors.black.withOpacity(0.8)),
          ),
          onPressed: () {
            serviceLocator<SubscriptionController>()
                .showActiveSubscriptionAmounts(walletType: WalletTypes.balance);
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '💳 Recharge',
                style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white),
                textScaler: TextScaler.linear(1.2),
              ),
              Icon(Icons.arrow_right),
            ],
          ),
        ),
      ),
    );
  }
}

// class DynamicGridViewPage extends StatelessWidget {
//   final List<SubCategoryData> subCategoryDataList;
//
//   const DynamicGridViewPage({super.key, required this.subCategoryDataList});
//
//   @override
//   Widget build(BuildContext context) {
//     final List<List<SubCategoryData>> gridChunks = _splitListIntoChunks(subCategoryDataList, 4);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dynamic Grid View Page'),
//       ),
//       body: ListView.builder(
//         itemCount: gridChunks.length,
//         itemBuilder: (context, index) {
//           return _buildGridRow(context, gridChunks[index]);
//         },
//       ),
//     );
//   }
//
//   /// Splits a list into chunks of a specified size.
//   List<List<SubCategoryData>> _splitListIntoChunks(List<SubCategoryData> list, int chunkSize) {
//     final List<List<SubCategoryData>> chunks = [];
//     for (var i = 0; i < list.length; i += chunkSize) {
//       chunks.add(list.sublist(i, i + chunkSize > list.length ? list.length : i + chunkSize));
//     }
//     return chunks;
//   }
//
//   /// Builds a row of cards for the grid.
//   Widget _buildGridRow(BuildContext context, List<SubCategoryData> subCategoryChunk) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: subCategoryChunk.map((subCategoryData) => _buildCard(context, subCategoryData)).toList(),
//         ),
//       ),
//     );
//   }
//
//   /// Builds a single card with subcategory data.
//   Widget _buildCard(BuildContext context, SubCategoryData subCategoryData) {
//     return Container(
//       width: 200,
//       height: MediaQuery.of(context).size.height / 4,
//       padding: const EdgeInsets.all(8.0),
//       child: TinderSubCategoryCard(
//         subCategoryCardData: subCategoryData,
//         tinderViewCubit: TinderViewCubit(),
//         activeFav: false,
//       ),
//     );
//   }
// }
