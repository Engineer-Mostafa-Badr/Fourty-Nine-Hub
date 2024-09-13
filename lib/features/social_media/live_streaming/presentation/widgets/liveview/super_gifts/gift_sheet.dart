import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'zego_gift_item.dart';

import 'gift_manager.dart';

void showGiftListSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.black.withOpacity(0.8),
    context: context,
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32.0),
        topRight: Radius.circular(32.0),
      ),
    ),
    isDismissible: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 50),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: ZegoGiftSheet(
              itemDataList: giftItemList,
            ),
          ),
        ),
      );
    },
  );
}

class ZegoGiftSheet extends StatefulWidget {
  const ZegoGiftSheet({
    super.key,
    required this.itemDataList,
  });

  final List<ZegoGiftItem> itemDataList;

  @override
  State<ZegoGiftSheet> createState() => _ZegoGiftSheetState();
}

class _ZegoGiftSheetState extends State<ZegoGiftSheet> {
  final selectedGiftItemNotifier = ValueNotifier<ZegoGiftItem?>(null);
  final countNotifier = ValueNotifier<String>('1');

  @override
  void initState() {
    super.initState();

    widget.itemDataList.sort((l, r) {
      return l.weight.compareTo(r.weight);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: CustomScrollView(
            scrollDirection: Axis.horizontal,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: giftList(),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            countDropList(),
            SizedBox(
              height: 30.h,
              child: sendButton(),
            ),
          ],
        ),
      ],
    );
  }

  Widget sendButton() {
    return ElevatedButton(
      onPressed: () {
        if (selectedGiftItemNotifier.value == null) {
          return;
        }

        final giftItem = selectedGiftItemNotifier.value!;
        final giftCount = int.tryParse(countNotifier.value) ?? 1;
        Navigator.of(context).pop();

        /// local play
        ZegoGiftManager()
            .playList
            .add(PlayData(giftItem: giftItem, count: giftCount));

        /// notify remote host
        ZegoGiftManager()
            .service
            .sendGift(name: giftItem.name, count: giftCount);
      },
      child: const Text('SEND'),
    );
  }

  Widget countDropList() {
    var textStyle = TextStyle(
      color: Colors.white,
      fontSize: 15.sp,
    );

    return ValueListenableBuilder<String>(
        valueListenable: countNotifier,
        builder: (context, count, _) {
          return DropdownButton<String>(
            value: count,
            onChanged: (selectedValue) {
              countNotifier.value = selectedValue!;
            },
            alignment: AlignmentDirectional.centerEnd,
            style: textStyle,
            dropdownColor: Colors.black.withOpacity(0.5),
            items: <String>['1', '5', '10', '100'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: textStyle,
                ),
              );
            }).toList(),
          );
        });
  }

  Widget giftList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: widget.itemDataList
          .map((item) {
            return GestureDetector(
              onTap: () => selectedGiftItemNotifier.value = item,
              child: Column(
                children: [
                  ValueListenableBuilder<ZegoGiftItem?>(
                      valueListenable: selectedGiftItemNotifier,
                      builder: (context, selectedGiftItem, _) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(2)),
                            border: Border.all(
                              color: selectedGiftItem?.name == item.name
                                  ? Colors.red
                                  : Colors.white.withOpacity(0.2),
                            ),
                          ),
                          width: 50,
                          height: 50.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: item.icon.isEmpty
                                ? const Icon(Icons.card_giftcard,
                                    color: Colors.red)
                                : Image.asset(item.icon),
                          ),
                        );
                      }),
                  Text(item.name, style: const TextStyle(color: Colors.white)),
                  Row(
                    children: [
                      const Icon(Icons.attach_money, color: Colors.yellow),
                      Text(
                        item.weight.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            );
          })
          .map((item) => Row(children: [item, Container(width: 20)]))
          .toList(),
    );
  }
}

final List<ZegoGiftItem> giftItemList = [
  ZegoGiftItem(
    name: 'GramaPhone',
    icon: 'assets/images/musicBox.png',
    sourceURL:
        'https://storage.zego.im/sdk-doc/Pics/zegocloud/gift/music_box.mp4',
    source: ZegoGiftSource.url,
    type: ZegoGiftType.mp4,
    weight: 1,
  ),
  ZegoGiftItem(
    name: 'Rocket',
    icon: 'assets/images/rocket.png',
    sourceURL:
        'https://storage.zego.im/sdk-doc/Pics/zegocloud/gift/music_box.mp4',
    source: ZegoGiftSource.url,
    type: ZegoGiftType.mp4,
    weight: 10,
  ),
  ZegoGiftItem(
    name: 'Crown',
    icon: 'assets/images/crown.png',
    sourceURL:
        'https://storage.zego.im/sdk-doc/Pics/zegocloud/gift/music_box.mp4',
    source: ZegoGiftSource.url,
    type: ZegoGiftType.mp4,
    weight: 100,
  ),
];

ZegoGiftItem? queryGiftInItemList(String name) {
  final index = giftItemList.indexWhere((item) => item.name == name);
  return -1 != index ? giftItemList.elementAt(index) : null;
}
