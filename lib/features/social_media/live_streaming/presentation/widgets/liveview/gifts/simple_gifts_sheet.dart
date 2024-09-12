// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/zego_uikit.dart';

import '../../../../../../../res/assets/assets.dart';

void showSimpleGiftBottomSheet(BuildContext context, String userId) {
  List<GiftItems> gifts = [
    GiftItems(
        price: '10',
        svgPath: 'assets/images/flower.svg',
        takbeesNo: 5,
        name: 'Flower'),
    GiftItems(
        price: '30',
        svgPath: 'assets/images/butterfly.svg',
        takbeesNo: 20,
        name: 'Butterfly'),
    GiftItems(
        price: '100',
        svgPath: 'assets/images/snake.svg',
        takbeesNo: 60,
        name: 'Snake'),
    GiftItems(
        price: '150',
        svgPath: 'assets/images/elephant.svg',
        takbeesNo: 200,
        name: 'Elephant'),
    GiftItems(
        price: '300',
        svgPath: 'assets/images/cheetah.svg',
        takbeesNo: 450,
        name: 'Cheetah'),
    GiftItems(
        price: '500',
        svgPath: 'assets/images/lion.svg',
        takbeesNo: 700,
        name: 'Lion'),
  ];
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (BuildContext context) {
      return Container(
        height:
            300, // Adjust this value to change the height of the bottom sheet
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Select a gift',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: GridView.builder(
                itemCount: gifts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 columns
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1, // Aspect ratio of the items
                ),
                itemBuilder: (BuildContext context, int index) {
                  final item = gifts[index];
                  return InkWell(
                    onTap: () {
                      String message = 'sent ${item.name}';
                      ZegoUIKit().sendInRoomMessage(message);
                      context.pop();
                    },
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          item.svgPath,
                          height: 60,
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.price, // Replace with your desired text
                              style: const TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Image.asset(
                              Assets.coin,
                              height: 20,
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

class GiftItems {
  final String price;
  final String svgPath;
  final String name;
  final int takbeesNo;
  GiftItems({
    required this.price,
    required this.svgPath,
    required this.takbeesNo,
    required this.name,
  });
}
