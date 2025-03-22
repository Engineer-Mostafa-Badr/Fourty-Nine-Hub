import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_audio_streaming/zego_uikit_prebuilt_live_audio_room.dart';
import 'package:fourtyninehub/res/style/const.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/enums/club_house_layout_mode_enum.dart';
import '../../../../../secrets/controller/secrets_cubit.dart';
import '../../../twitter/presentation/widgets/report_view.dart';
import 'components/custom_extended_button.dart';
import 'components/media_player.dart';

class ZegoAudioRoomWidget extends StatefulWidget {
  final bool isHost;
  final String roomId;
  final LayoutMode layoutMode;
  const ZegoAudioRoomWidget({
    super.key,
    required this.isHost,
    required this.roomId,
    this.layoutMode = LayoutMode.full,
    required String roomSubject,
  });

  @override
  State<ZegoAudioRoomWidget> createState() => _ZegoAudioRoomWidgetState();
}

class _ZegoAudioRoomWidgetState extends State<ZegoAudioRoomWidget> {
  @override
  Widget build(BuildContext context) {
    final String userId = context.read<UserCubit>().state.data!.id;
    final String userName = context.read<UserCubit>().state.data!.fullName;
    final String imageUrl =
        context.read<UserCubit>().state.data!.profilePicture ??
            UIConst.profilePlaceHolder;
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ZegoUIKitPrebuiltLiveAudioRoom(
        appID: context.read<SecretsCubit>().state.secrets!.zegoAppId,
        appSign: context.read<SecretsCubit>().state.secrets!.zegoAppSign,
        userID: userId,
        userName: userName,
        roomID: widget.roomId,
        events: events,
        config: config(imageUrl),
      ),
    );
  }

  ZegoUIKitPrebuiltLiveAudioRoomEvents get events {
    return ZegoUIKitPrebuiltLiveAudioRoomEvents(
      user: ZegoLiveAudioRoomUserEvents(
        onCountOrPropertyChanged: (List<ZegoUIKitUser> users) {},
      ),
      seat: ZegoLiveAudioRoomSeatEvents(
        onClosed: () {
          debugPrint('on seat closed');
        },
        onOpened: () {
          debugPrint('on seat opened');
        },
        onChanged: (
          Map<int, ZegoUIKitUser> takenSeats,
          List<int> untakenSeats,
        ) {
          debugPrint(
            'on seats changed, taken seats:$takenSeats, untaken seats:$untakenSeats',
          );
        },

        // / WARNING: will override prebuilt logic
        onClicked: (int index, ZegoUIKitUser? user) {
          debugPrint('on seat clicked, index:$index, user:${user.toString()}');
        },
        host: ZegoLiveAudioRoomSeatHostEvents(
          onTakingRequested: (ZegoUIKitUser audience) {
            debugPrint('on seat taking requested, audience:$audience');
          },
          onTakingRequestCanceled: (ZegoUIKitUser audience) {
            debugPrint('on seat taking request canceled, audience:$audience');
          },
          onTakingInvitationFailed: () {
            debugPrint('on invite audience to take seat failed');
          },
          onTakingInvitationRejected: (ZegoUIKitUser audience) {
            debugPrint('on seat taking invite rejected');
          },
        ),
        audience: ZegoLiveAudioRoomSeatAudienceEvents(
          onTakingRequestFailed: () {
            debugPrint('on seat taking request failed');
          },
          onTakingRequestRejected: () {
            debugPrint('on seat taking request rejected');
          },
          onTakingInvitationReceived: () {
            debugPrint('on host seat taking invite sent');
          },
        ),
      ),

      /// WARNING: will override prebuilt logic
      memberList: ZegoLiveAudioRoomMemberListEvents(
        onMoreButtonPressed: onMemberListMoreButtonPressed,
      ),
    );
  }

  ZegoUIKitPrebuiltLiveAudioRoomConfig config(String imageUrl) {
    var zegoLiveAudioRoomSeatConfig = getSeatConfig()
      ..takeIndexWhenJoining = widget.isHost ? getHostSeatIndex() : -1
      ..hostIndexes = getLockSeatIndex()
      ..layout = getLayoutConfig();

    return (widget.isHost
        ? (ZegoUIKitPrebuiltLiveAudioRoomConfig.host())
        : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience())
      ..seat = zegoLiveAudioRoomSeatConfig
      ..background = Container(
        color: context.theme.scaffoldBackgroundColor,
      )
      ..topMenuBar.showLeaveButton = false
      // ..background = background()
      // ..topMenuBar.showLeaveButton = false
      // ..emptyAreaBuilder = mediaPlayer
      ..topMenuBar.buttons = [
        // ZegoLiveAudioRoomMenuBarButtonName.minimizingButton
      ]
      ..bottomMenuBar.audienceButtons = [
        // ZegoLiveAudioRoomMenuBarButtonName.leaveButton,
        ZegoLiveAudioRoomMenuBarButtonName.showMemberListButton,
        ZegoLiveAudioRoomMenuBarButtonName.toggleMicrophoneButton,
        // ZegoLiveAudioRoomMenuBarButtonName.applyToTakeSeatButton,
      ]
      ..bottomMenuBar.hostButtons = [
        ZegoLiveAudioRoomMenuBarButtonName.showMemberListButton,
        ZegoLiveAudioRoomMenuBarButtonName.soundEffectButton,
        ZegoLiveAudioRoomMenuBarButtonName.toggleMicrophoneButton,
        ZegoLiveAudioRoomMenuBarButtonName.closeSeatButton,
        // ZegoLiveAudioRoomMenuBarButtonName.applyToTakeSeatButton,
        // ZegoLiveAudioRoomMenuBarButtonName.leaveButton,
      ]
      ..bottomMenuBar.hostExtendButtons = [
        reportButton(),
      ]
      ..bottomMenuBar.audienceExtendButtons = [
        applyToTakeButton(),
      ]
      //must be within 64 bytes
      ..userAvatarUrl = imageUrl;
  }

  CustomExtendedButton reportButton() {
    return CustomExtendedButton(
      onTap: () => bottomSheet(
          context: context,
          widget: ReportView(
            id: widget.roomId,
            categoryId: Constants.clubVoiceSubCategory,
          )),
      icon: Icons.report,
      color: Colors.red,
    );
  }

  ///to send request to [take] a seat
  CustomExtendedButton applyToTakeButton() {
    return CustomExtendedButton(
      onTap: () => ZegoUIKitPrebuiltLiveAudioRoomController()
          .seat
          .audience
          .applyToTake(),
      icon: Icons.voice_chat,
      color: Colors.grey,
    );
  }

  Widget mediaPlayer(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return advanceMediaPlayer(
          constraints: constraints,
          canControl: widget.isHost,
        );
      },
    );
  }

  ZegoLiveAudioRoomSeatConfig getSeatConfig() {
    if (widget.layoutMode == LayoutMode.hostTopCenter) {
      return ZegoLiveAudioRoomSeatConfig(
        backgroundBuilder: (
          BuildContext context,
          Size size,
          ZegoUIKitUser? user,
          Map<String, dynamic> extraInfo,
        ) {
          return Container(color: Colors.grey);
        },
      );
    }

    return ZegoLiveAudioRoomSeatConfig(
        // avatarBuilder: avatarBuilder,
        );
  }

  int getHostSeatIndex() {
    if (widget.layoutMode == LayoutMode.hostCenter) {
      return 4;
    }

    return 0;
  }

  List<int> getLockSeatIndex() {
    if (widget.layoutMode == LayoutMode.hostCenter) {
      return [4];
    }

    return [0];
  }

  ZegoLiveAudioRoomLayoutConfig getLayoutConfig() {
    final config = ZegoLiveAudioRoomLayoutConfig();
    switch (widget.layoutMode) {
      case LayoutMode.defaultLayout:
        break;
      case LayoutMode.full:
        config.rowSpacing = 5;
        config.rowConfigs = List.generate(
          4,
          (index) => ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
        );
        break;
      case LayoutMode.horizontal:
        config.rowSpacing = 5;
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 8,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
        ];
        break;
      case LayoutMode.vertical:
        config.rowSpacing = 5;
        config.rowConfigs = List.generate(
          8,
          (index) => ZegoLiveAudioRoomLayoutRowConfig(
            count: 1,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
        );
        break;
      case LayoutMode.hostTopCenter:
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 1,
            alignment: ZegoLiveAudioRoomLayoutAlignment.center,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 2,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceEvenly,
          ),
        ];
        break;
      case LayoutMode.hostCenter:
        config.rowSpacing = 5;
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
        ];
        break;
      case LayoutMode.fourPeoples:
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 5,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
        ];
        break;
    }
    return config;
  }

  void onMemberListMoreButtonPressed(ZegoUIKitUser user) {
    showModalBottomSheet(
      backgroundColor: const Color(0xff111014),
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        ),
      ),
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        var textStyle = TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        );
        final listMenu = ZegoUIKitPrebuiltLiveAudioRoomController()
                .seat
                .localHasHostPermissions
            ? membersBottomSheetActions(context, user, textStyle)
            : [];
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 50),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 0.h,
              horizontal: 10,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: listMenu.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 60.h,
                  child: Center(child: listMenu[index]),
                );
              },
            ),
          ),
        );
      },
    );
  }

  List<GestureDetector> membersBottomSheetActions(
      BuildContext context, ZegoUIKitUser user, TextStyle textStyle) {
    return [
      GestureDetector(
        onTap: () async {
          Navigator.of(context).pop();

          ZegoUIKit().removeUserFromRoom(
            [user.id],
          ).then((result) {
            debugPrint('kick out result:$result');
          });
        },
        child: Text(
          'Kick Out ${user.name}',
          style: textStyle,
        ),
      ),
      GestureDetector(
        onTap: () async {
          Navigator.of(context).pop();

          ZegoUIKitPrebuiltLiveAudioRoomController()
              .seat
              .host
              .inviteToTake(user.id)
              .then((result) {
            debugPrint('invite audience to take seat result:$result');
          });
        },
        child: Text(
          'Invite ${user.name} to take seat',
          style: textStyle,
        ),
      ),
      GestureDetector(
        onTap: () async {
          Navigator.of(context).pop();

          ZegoUIKitPrebuiltLiveAudioRoomController()
              .seat
              .host
              .muteByUserID(user.id)
              .then((result) {
            debugPrint('Mute seat result:$result');
          });
        },
        child: Text(
          'Mute ${user.name}',
          style: textStyle,
        ),
      ),
      GestureDetector(
        onTap: () async {
          Navigator.of(context).pop();
        },
        child: Text(
          'Cancel',
          style: textStyle,
        ),
      ),
    ];
  }
}
