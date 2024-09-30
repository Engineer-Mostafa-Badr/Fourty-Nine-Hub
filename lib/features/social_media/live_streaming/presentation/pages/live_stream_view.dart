// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/liveview/gifts/simple_gifts_sheet.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/pk_widgets/configs.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/pk_widgets/surfuce.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_bottom_navigator.dart';

import '../../../../../secrets/controller/secrets_cubit.dart';
import '../widgets/liveview/super_gifts/gift_manager.dart';
import '../widgets/liveview/super_gifts/gift_sheet.dart';
import '../widgets/liveview/super_gifts/mp4_player_widget.dart';
import '../widgets/liveview/super_gifts/zego_gift_item.dart';
import '../widgets/pk_widgets/events.dart';
import '../widgets/pk_widgets/mute_widget.dart';
import '../widgets/components/zego_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LiveStreamView extends StatefulWidget {
  final String liveID;
  final bool isHost;

  const LiveStreamView({
    super.key,
    required this.liveID,
    required this.isHost,
  });

  @override
  State<LiveStreamView> createState() => _LiveStreamViewState();
}

class _LiveStreamViewState extends State<LiveStreamView> {
  final liveStateNotifier = ValueNotifier<ZegoLiveStreamingState>(
    ZegoLiveStreamingState.idle,
  );

  final requestingHostsMapRequestIDNotifier =
      ValueNotifier<Map<String, List<String>>>({});
  final requestIDNotifier = ValueNotifier<String>('');
  PKEvents? pkEvents;

  @override
  void initState() {
    super.initState();

    ZegoGiftManager().cache.cacheAllFiles(giftItemList);

    ZegoGiftManager().service.recvNotifier.addListener(onGiftReceived);
    pkEvents = PKEvents(
      requestIDNotifier: requestIDNotifier,
      requestingHostsMapRequestIDNotifier: requestingHostsMapRequestIDNotifier,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ZegoGiftManager().service.init(
            appID: context.read<SecretsCubit>().state.secrets?.zegoAppId??0,
            liveID: widget.liveID,
            localUserID: context.read<UserCubit>().state.data!.id,
            localUserName: context.read<UserCubit>().state.data!.fullName,
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
    )
      ..layout = ZegoLayout.gallery()
      ..pkBattle = pkConfig();

    final audienceConfig = ZegoUIKitPrebuiltLiveStreamingConfig.audience(
      plugins: [ZegoUIKitSignalingPlugin()],
    )
      ..bottomMenuBar.coHostExtendButtons = [
        giftButton,
        superGiftButton,
      ]
      ..bottomMenuBar.hostButtons = []
      ..bottomMenuBar.audienceButtons = []
      ..bottomMenuBar.coHostButtons = []
      ..bottomMenuBar.audienceExtendButtons = [
        giftButton,
        superGiftButton,
      ]
      ..bottomMenuBar.audienceButtons = [
        ZegoLiveStreamingMenuBarButtonName.expanding,
        ZegoLiveStreamingMenuBarButtonName.coHostControlButton,
        // ZegoLiveStreamingMenuBarButtonName.soundEffectButton,
      ]
      ..inRoomMessage = ZegoLiveStreamingInRoomMessageConfig(
          resendIcon: const Icon(
        Icons.reply,
        color: Colors.white,
      ))
      ..foreground = PKV2Surface(
        requestIDNotifier: requestIDNotifier,
        liveStateNotifier: liveStateNotifier,
        requestingHostsMapRequestIDNotifier:
            requestingHostsMapRequestIDNotifier,
      )
      ..layout = ZegoLayout.gallery()
      ..audioVideoView.foregroundBuilder = foregroundBuilder
      ..pkBattle = pkConfig();

    final userId = context.read<UserCubit>().state.data!.id;
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: context.read<SecretsCubit>().state.secrets!.zegoAppId,
        appSign: context.read<SecretsCubit>().state.secrets!.zegoAppSign,
        userID: userId,
        userName: context.read<UserCubit>().state.data!.fullName,
        liveID: widget.liveID,
        isLiveStream: true,
        events: ZegoUIKitPrebuiltLiveStreamingEvents(
          pk: pkEvents?.event,
          onStateUpdated: (state) {
            if (ZegoLiveStreamingState.idle == state) {
              ZegoGiftManager().playList.clear();
            }
            liveStateNotifier.value = state;
          },
        ),
        config: widget.isHost ? hostConfig : audienceConfig
          // ..foreground = giftForeground()
          ..mediaPlayer.supportTransparent = true,
      ),
    );
  }

  Widget foregroundBuilder(context, size, ZegoUIKitUser? user, _) {
    if (user == null) {
      return Container();
    }

    final hostWidgets = [
      /// mute pk user
      Positioned(
        top: 5,
        left: 5,
        child: SizedBox(
          width: 40,
          height: 40.h,
          child: PKMuteButton(userID: user.id),
        ),
      ),
    ];

    return Stack(
      children: [
        ...((widget.isHost &&
                user.id != context.read<UserCubit>().state.data!.id)
            ? hostWidgets
            : [
                giftForeground(),
              ]),

        /// camera state
        Positioned(
          top: 5,
          right: 35,
          child: SizedBox(
            width: 18,
            height: 18.h,
            child: CircleAvatar(
              backgroundColor: Colors.purple.withOpacity(0.6),
              child: Icon(
                user.camera.value ? Icons.videocam : Icons.videocam_off,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
        ),

        /// microphone state
        Positioned(
          top: 5,
          right: 5,
          child: SizedBox(
            width: 18,
            height: 18.h,
            child: CircleAvatar(
              backgroundColor: Colors.purple.withOpacity(0.6),
              child: Icon(
                user.microphone.value ? Icons.mic : Icons.mic_off,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
        ),

        /// name
        Positioned(
          top: 25,
          right: 5,
          child: Container(
            // width: 30,
            height: 18.h,
            color: Colors.purple,
            child: Text(user.name),
          ),
        ),
      ],
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
  //     return SizedBox.shrink();
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
        index: 0, //index of button
        child: InkWell(
            onTap: () {
              //send a message and some interaction
              showSimpleGiftBottomSheet(
                  context, context.read<UserCubit>().state.data!.id);
            },
            child: SvgPicture.asset(
              'assets/images/gift.svg',
              height: 50.h,
            )),
      );

  ZegoLiveStreamingMenuBarExtendButton get superGiftButton =>
      ZegoLiveStreamingMenuBarExtendButton(
        index: 1,
        child: InkWell(
            onTap: () => showGiftListSheet(context),
            child: SvgPicture.asset(
              'assets/images/super_gifts.svg',
              height: 40.h,
            )),
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
