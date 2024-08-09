import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/tinder_view.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
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

// _showGiftBottomSheet2(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.black.withOpacity(0.8),
//     // To simulate the transparent effect
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (context) => BottomSheetContent(),
//   );
// }

class BottomSheetContent extends StatefulWidget {
  final List<GiftData>? gifts;

  final UserData? cardUser;

  final UserEntity? currentLoggedUser;

  // required BuildContext context,
  // required GiftData gift,
  // required receiverId,
  //     required giftId,
  // required subCategoryId,
  //     required UserEntity currentLoggedUser,

  const BottomSheetContent({
    super.key,
    required this.gifts,
    required this.cardUser,
    required this.currentLoggedUser,
    required subCategoryId,
  });

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  List<GiftData>? items;

  // late final List<Map<String, String>> items;
  // =
  // [
  //   {'icon': '🎶', 'name': 'Universes Music', 'price': '4888'},
  //   {'icon': '🐎', 'name': 'Arabian Stallion', 'price': '15000'},
  //   {'icon': '🎈', 'name': 'Tiktok Air Drop', 'price': '999'},
  //   {'icon': '🏕️', 'name': 'Desert Camp', 'price': '899'},
  //   {'icon': '🐉', 'name': 'Baby Dragon', 'price': '2000'},
  //   {'icon': '🐘', 'name': 'Ellie the Elephant', 'price': '5000'},
  //   {'icon': '💖', 'name': 'Crystal Heart', 'price': '499'},
  //   {'icon': '🌊', 'name': 'Pool Party', 'price': '4999'},
  // ];
  @override
  void initState() {
    items = widget.gifts!.toList();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: kToolbarHeight * 0.75,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
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
            const Divider(),
            // GridView.builder(
            //   shrinkWrap: true,
            //   itemCount: items!.length,
            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 4, // 4 items per row
            //     childAspectRatio: 1 / 1.5, // To control the item size
            //   ),
            //   itemBuilder: (context, index) {
            //     return Column(
            //       children: [
            //         // Text(items![index].picture!, style: TextStyle(fontSize: 40)),
            //         Text(
            //           items![index].nameEn!,
            //           textAlign: TextAlign.center,
            //           style: TextStyle(color: Colors.white),
            //         ),
            //         Text(
            //           items![index].value.toString(),
            //           style: TextStyle(color: Colors.yellow),
            //         ),
            //       ],
            //     );
            //   },
            // ),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              // itemCount: 100,
              itemCount: widget.gifts!.length,
              // Use the gifts list instead of items
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 items per row
                childAspectRatio: 1 / 1.5, // To control the item size
              ),
              itemBuilder: (context, index) {
                final gift = widget.gifts![index]; // Get the gift data

                return BlocProvider(
                  create: (context) => TinderViewCubit()..fetchGifts(),
                  child: BlocBuilder<TinderViewCubit, TinderViewState>(
                    builder: (context, state) => InkWell(
                      onTap: () async {
                        final data =
                            await context.read<TinderViewCubit>().sendGift(
                                  receiverId: widget.cardUser?.user?.sId ?? '',
                                  subCategoryId: '66af974f8bf69f9469944746',
                                  giftId: gift.sId ?? '',
                                  currentUserToken: 'currentUserToken',
                                );
                        // handleResponse(snapshot.data ?? '', context);
                        // Use switch case to handle different response types
                        print("${data}oppppppppppppppppppppppppp");
                        switch (data) {
                          case """{"success":false,"error":{"name":"Bad Request","httpCode":400,"message":"You does not have enough money in the wallet","data":{},"isOperational":true,"stack":"","domain":"49dev.com"}}""":
                            showInsufficientFundsPopup(context,
                                'You do not have enough money in your wallet.');

                            break;

                          case """{"status":true,"message":"sent Gift Successfully"}""":
                            showGiftSentPopup(context, gift.value.toString());
                            break;

                          default:
                            showInsufficientFundsPopup(
                                context, 'Unexpected response format.');
                            break;
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          gift.picture != null
                              ? Image.network(
                                  gift.picture!,
                                  width: 50,
                                  height: 50,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                    'assets/images/icon.png',
                                    width: 50,
                                    height: 50,
                                  ),
                                )
                              : Image.asset(
                                  'assets/images/icon.png',
                                  width: 50,
                                  height: 50,
                                ),
                          // Placeholder if no image
                          const SizedBox(height: 8),
                          // Spacing between image and text
                          Text(
                            gift.nameEn ?? 'No Name',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          // Spacing between name and value
                          Text(
                            '${gift.value ?? 0} 💰',
                            // Default to 0 if value is null
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {},
            //   child: const Text('Recharge'),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.amber,
            //   ),
            // ),
            Align(
              alignment: Alignment.bottomRight
              // bottom: 10,
              // right: 0,
              // left: 500,
              ,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: OutlinedButton(
                  style: ButtonStyle(
                    side: const MaterialStatePropertyAll(BorderSide(
                      // strokeAlign: 5,
                      width: 0,
                      // color: AppColors.ACCENT_COLOR,
                    )),
                    iconColor: const MaterialStatePropertyAll(Colors.white),
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.black.withOpacity(0.8),
                    ),
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
                            fontWeight: FontWeight.normal, color: Colors.white),
                        textScaler: TextScaler.linear(1.2),
                      ),
                      Icon(Icons.arrow_right),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
