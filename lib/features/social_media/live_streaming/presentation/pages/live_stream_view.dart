// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_bottom_navigator.dart';

import '../widgets/liveview/gifts/gift_manager.dart';
import '../widgets/liveview/gifts/gift_sheet.dart';
import '../widgets/liveview/gifts/mp4_player_widget.dart';
import '../widgets/liveview/gifts/zego_gift_item.dart';
import '../widgets/liveview/live_card.dart';

class LiveStreamView extends StatefulWidget {
  final String liveID;
  final bool isHost;

  const LiveStreamView({
    super.key,
    this.liveID = '123',
    this.isHost = false,
  });

  @override
  State<LiveStreamView> createState() => _LiveStreamViewState();
}

class _LiveStreamViewState extends State<LiveStreamView> {
  final userId = Random().nextInt(1000).toString();
  @override
  void initState() {
    super.initState();

    ZegoGiftManager().cache.cacheAllFiles(giftItemList);

    ZegoGiftManager().service.recvNotifier.addListener(onGiftReceived);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ZegoGiftManager().service.init(
            appID: UIConst.appId,
            liveID: widget.liveID,
            localUserID: userId,
            localUserName: 'user_$userId',
          );
    });
  }

  @override
  void dispose() {
    super.dispose();

    ZegoGiftManager().service.recvNotifier.removeListener(onGiftReceived);
    ZegoGiftManager().service.uninit();
  }

  @override
  Widget build(BuildContext context) {
    final hostConfig = ZegoUIKitPrebuiltLiveStreamingConfig.host(
      plugins: [ZegoUIKitSignalingPlugin()],
    );

    final audienceConfig = ZegoUIKitPrebuiltLiveStreamingConfig.audience(
      plugins: [ZegoUIKitSignalingPlugin()],
    )
      ..bottomMenuBar.coHostExtendButtons = [giftButton]
      ..bottomMenuBar.audienceExtendButtons = [giftButton];

    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: UIConst.appId /*input your AppID*/,
        appSign: UIConst.appSign /*input your AppSign*/,
        userID: userId,
        userName: 'user_$userId',
        liveID: widget.liveID,
        events: ZegoUIKitPrebuiltLiveStreamingEvents(
          onStateUpdated: (state) {
            if (ZegoLiveStreamingState.idle == state) {
              ZegoGiftManager().playList.clear();
            }
          },
        ),
        config: (widget.isHost ? hostConfig : audienceConfig)
          ..foreground = giftForeground()
          ..mediaPlayer.supportTransparent = true,
      ),
    );
  }

  Widget giftForeground() {
    return ValueListenableBuilder<PlayData?>(
      valueListenable: ZegoGiftManager().playList.playingDataNotifier,
      builder: (context, playData, _) {
        if (null == playData) {
          return const SizedBox.shrink();
        }

        if (playData.giftItem.type == ZegoGiftType.svga) {
          print('svga format');
          return Container();
        } else {
          return mp4Widget(playData);
        }
      },
    );
  }

  // Widget svgaWidget(PlayData playData) {
  //   if (playData.giftItem.type != ZegoGiftType.svga) {
  //     return const SizedBox.shrink();
  //   }

  //   /// you can define the area and size for displaying your own
  //   /// animations here
  //   int level = 1;
  //   if (playData.giftItem.weight < 10) {
  //     level = 1;
  //   } else if (playData.giftItem.weight < 100) {
  //     level = 2;
  //   } else {
  //     level = 3;
  //   }
  //   switch (level) {
  //     case 2:
  //       return Positioned(
  //         top: 100,
  //         bottom: 100,
  //         left: 10,
  //         right: 10,
  //         child: ZegoSvgaPlayerWidget(
  //           key: UniqueKey(),
  //           playData: playData,
  //           onPlayEnd: () {
  //             ZegoGiftManager().playList.next();
  //           },
  //         ),
  //       );
  //     case 3:
  //       return ZegoSvgaPlayerWidget(
  //         key: UniqueKey(),
  //         playData: playData,
  //         onPlayEnd: () {
  //           ZegoGiftManager().playList.next();
  //         },
  //       );
  //   }
  //   // level 1
  //   return Positioned(
  //     bottom: 200,
  //     left: 10,
  //     child: ZegoSvgaPlayerWidget(
  //       key: UniqueKey(),
  //       size: const Size(100, 100),
  //       playData: playData,
  //       onPlayEnd: () {
  //         /// if there is another gift animation, then play
  //         ZegoGiftManager().playList.next();
  //       },
  //     ),
  //   );
  // }

  Widget mp4Widget(PlayData playData) {
    if (playData.giftItem.type != ZegoGiftType.mp4) {
      return const SizedBox.shrink();
    }

    /// you can define the area and size for displaying your own
    /// animations here
    int level = 1;
    if (playData.giftItem.weight < 10) {
      level = 1;
    } else if (playData.giftItem.weight < 100) {
      level = 2;
    } else {
      level = 3;
    }
    switch (level) {
      case 2:
        return Positioned(
          top: 100,
          bottom: 100,
          left: 10,
          right: 10,
          child: ZegoMp4PlayerWidget(
            key: UniqueKey(),
            playData: playData,
            onPlayEnd: () {
              ZegoGiftManager().playList.next();
            },
          ),
        );
      case 3:
        return ZegoMp4PlayerWidget(
          key: UniqueKey(),
          playData: playData,
          onPlayEnd: () {
            ZegoGiftManager().playList.next();
          },
        );
    }
    // level 1
    return Positioned(
      bottom: 200,
      left: 10,
      child: ZegoMp4PlayerWidget(
        key: UniqueKey(),
        size: const Size(100, 100),
        playData: playData,
        onPlayEnd: () {
          /// if there is another gift animation, then play
          ZegoGiftManager().playList.next();
        },
      ),
    );
  }

  ZegoLiveStreamingMenuBarExtendButton get giftButton =>
      ZegoLiveStreamingMenuBarExtendButton(
        index: 0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(shape: const CircleBorder()),
          onPressed: () {
            showGiftListSheet(context);
          },
          child: const Icon(Icons.blender),
        ),
      );

  void onGiftReceived() {
    final receivedGift = ZegoGiftManager().service.recvNotifier.value ??
        ZegoGiftProtocolItem.empty();
    final giftData = queryGiftInItemList(receivedGift.name);
    if (null == giftData) {
      debugPrint('not ${receivedGift.name} exist');
      return;
    }

    ZegoGiftManager().playList.add(PlayData(
          giftItem: giftData,
          count: receivedGift.count,
        ));
  }
}

Widget _buildLivePages() {
  return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 15,
      itemBuilder: (context, index) => const LiveCard());
}
