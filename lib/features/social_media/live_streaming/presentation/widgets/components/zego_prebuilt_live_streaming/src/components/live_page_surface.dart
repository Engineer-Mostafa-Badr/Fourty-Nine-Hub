// Dart imports:
import 'dart:core';

// Flutter imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/components/update_goals_sheet.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/src/components/screen_util/core/size_extension.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/gift_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/features/zoom/presentation/controller/stream_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/controller/stream_state.dart';

// Package imports:

// Project imports:
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/components/duration_time_board.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/components/message/view.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/core/live_status_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/core/plugins.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/core/live_duration_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/components/components.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/controller.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/core/connect_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/core/host_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/components/utils/pop_up_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/defines.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/config.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/events.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/src/events.defines.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../../../res/style/styles.dart';

/// @nodoc
class ZegoLiveStreamingLivePageSurface extends StatefulWidget {
  final bool isLiveStream;

  const ZegoLiveStreamingLivePageSurface({
    super.key,
    required this.config,
    required this.events,
    required this.defaultEndAction,
    required this.defaultLeaveConfirmationAction,
    required this.hostManager,
    required this.liveStatusManager,
    required this.liveDurationManager,
    required this.popUpManager,
    required this.connectManager,
    required this.isLiveStream,
    this.plugins,
  });

  final ZegoUIKitPrebuiltLiveStreamingConfig config;
  final ZegoUIKitPrebuiltLiveStreamingEvents events;
  final void Function(ZegoLiveStreamingEndEvent event) defaultEndAction;
  final Future<bool> Function(
    ZegoLiveStreamingLeaveConfirmationEvent event,
  ) defaultLeaveConfirmationAction;

  final ZegoLiveStreamingHostManager hostManager;
  final ZegoLiveStreamingStatusManager liveStatusManager;
  final ZegoLiveStreamingDurationManager liveDurationManager;
  final ZegoLiveStreamingPopUpManager popUpManager;
  final ZegoLiveStreamingPlugins? plugins;
  final ZegoLiveStreamingConnectManager connectManager;

  @override
  State<ZegoLiveStreamingLivePageSurface> createState() =>
      _ZegoLiveStreamingLivePageSurfaceState();
}

class _ZegoLiveStreamingLivePageSurfaceState
    extends State<ZegoLiveStreamingLivePageSurface>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.0, 0.0),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  bool showComments = false;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: body,
    );
  }

  Widget get body {
    return BlocBuilder<StreamCubit, StreamState>(
      builder: (context, state) {
        return LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              durationTimeBoard(),
              if (!state.isOpenWhiteBoard) topBar(),
              if (widget.isLiveStream)
                Positioned.directional(
                  textDirection: context.textDirection,
                  end: 20,
                  start: widget.config.role != ZegoLiveStreamingRole.host
                      ? null
                      : context.screenWidth / 4,
                  top: 180.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.config.role == ZegoLiveStreamingRole.host) ...[
                        state.selectedGifts.isEmpty
                            ? GestureDetector(
                                onTap: () {
                                  showUpdateGoalsSheet(context,
                                      onEdit: (String id) {});
                                  // var cubit = context.read<StreamCubit>();
                                  // CliLogger.info(cubit.state.live.toString());
                                  // context.read<StreamCubit>().sendPoints(
                                  //     cubit.state.live!.members[0].id,
                                  //     cubit.state.live!.id);
                                },
                                child: Container(
                                    width: context.screenWidth * 0.4,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Label(
                                                  text: "Add ",
                                                  style: Styles.headerText(),
                                                ),
                                                Image.asset(
                                                  'assets/49-New-icons/goal.png',
                                                  width: 70.w,
                                                ),
                                              ],
                                            ),
                                            const Sizer(),
                                            Label(
                                              text: "Live goals",
                                              style: Styles.headerText(),
                                            ),
                                          ]),
                                    )),
                              )
                            : GestureDetector(
                                onTap: () {
                                  showUpdateGoalsSheet(context, onEdit: (id) {
                                    state.selectedGifts
                                        .firstWhere(
                                            (element) => element.sId == id)
                                        .showEdit = true;
                                    print(state.selectedGifts
                                        .firstWhere(
                                            (element) => element.sId == id)
                                        .showEdit);
                                    setState(() {});
                                  });

                                  // onTap: () {
                                  //   context.read<StreamCubit>().requestBattle(
                                  //       "66b9da437b1fafcdf897bbe1",
                                  //       "6702b91d870285d189a6e408");
                                },
                                child: Container(
                                  width: context.screenWidth * 0.4,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                          text: TextSpan(
                                              text: '0',
                                              style: TextStyle(
                                                color: Colors.yellow,
                                                fontSize: 30.sp,
                                              ),
                                              children: [
                                            TextSpan(
                                              text: '/',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30.sp,
                                              ),
                                            ),
                                            TextSpan(
                                              text: context
                                                  .read<StreamCubit>()
                                                  .state
                                                  .selectedGifts[0]
                                                  .currentValue
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30.sp,
                                              ),
                                            ),
                                          ])),
                                      // const Sizer(width: 30,),
                                      SvgPicture.network(
                                        state.selectedGifts[0].picture!,
                                        height: 75.h,
                                        width: 75.w,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        participants()
                      ],
                      if (widget.config.role != ZegoLiveStreamingRole.host)
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showUserGiftBottomSheet(context,
                                    receiverId: context
                                        .read<UserCubit>()
                                        .state
                                        .data!
                                        .id,
                                    forSelect: true, selectGift: (gift) {
                                  // context.read<StreamCubit>().selectGift(gift);
                                });
                              },
                              child: SvgPicture.asset(
                                'context.read<StreamCubit>().state.goals.first',
                                width: 70.w,
                              ),
                            ),
                            Sizer(
                              width: 50.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                showUserGiftBottomSheet(context,
                                    receiverId: context
                                        .read<UserCubit>()
                                        .state
                                        .data!
                                        .id,
                                    forSelect: true, selectGift: (gift) {
                                  context
                                      .read<StreamCubit>()
                                      .onSendGift(gift.sId ?? '');
                                });
                              },
                              child: Image.asset(
                                'assets/49-New-icons/goal.png',
                                width: 70.w,
                              ),
                            ),
                            Sizer(
                              width: 50.w,
                            ),
                            participants(),
                          ],
                        ),
                    ],
                  ),
                ),
              bottomBar(() {
                setState(() {
                  showComments == true;
                });
                print(showComments);
              }, showComments),
              if (!state.isOpenWhiteBoard && state.hideComments == false)
                messageList(),
              foreground(
                constraints.maxWidth,
                constraints.maxHeight,
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> showUserGiftBottomSheet(BuildContext context,
      {required String? receiverId,
      bool forSelect = false,
      void Function(GiftData)? selectGift}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: serviceLocator<GiftsCubit>()),
          BlocProvider.value(value: serviceLocator<TinderViewCubit>()),
          // BlocProvider.value(value: serviceLocator<StreamCubit>()),
        ],
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            List<GiftData> goals = [];
            for (var item in context.read<GiftsCubit>().state.gifts) {
              if (context
                  .read<StreamCubit>()
                  .rooms[context.read<StreamCubit>().state.pageIndex ?? 0]
                  .gift
                  .any((element) => element.giftId == item.sId)) {
                goals.add(item);
              }
            }
            return Container(
              decoration: BoxDecoration(
                color: context.isDarkMode
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
                      color: context.isDarkMode
                          ? Colors.black.withOpacity(0.4)
                          : Colors.grey.withOpacity(0.9),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        LocaleKeys.gift_body_send_a_gift.tr(),
                        textScaler: const TextScaler.linear(1.0),
                        style: TextStyle(
                            color: context.isDarkMode
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
                          goals: goals,
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
                                backgroundColor: context.isDarkMode
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
                                    color: context.isDarkMode
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

  Widget participants() => Container(
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(10)),
      child: ZoomParticipantsBuilder(widgetTop: widget));

  Widget topBar() {
    final isCoHostEnabled = (widget.plugins?.isEnabled ?? false) &&
        widget.config.bottomMenuBar.audienceButtons
            .contains(ZegoLiveStreamingMenuBarButtonName.coHostControlButton);
    return Positioned(
      left: 0,
      right: 0,
      top: 64.h,
      child: ZegoLiveStreamingTopBar(
        config: widget.config,
        events: widget.events,
        defaultEndAction: widget.defaultEndAction,
        defaultLeaveConfirmationAction: widget.defaultLeaveConfirmationAction,
        isCoHostEnabled: isCoHostEnabled,
        hostManager: widget.hostManager,
        hostUpdateEnabledNotifier: widget.hostManager.hostUpdateEnabledNotifier,
        connectManager: widget.connectManager,
        popUpManager: widget.popUpManager,
        isLeaveRequestingNotifier: ZegoUIKitPrebuiltLiveStreamingController()
            .isLeaveRequestingNotifier,
        translationText: widget.config.innerText,
        isLiveStream: widget.isLiveStream,
      ),
    );
  }

  Widget bottomBar(Function showComments, bool isHide) {
    final isCoHostEnabled = (widget.plugins?.isEnabled ?? false) &&
        widget.config.bottomMenuBar.audienceButtons
            .contains(ZegoLiveStreamingMenuBarButtonName.coHostControlButton);
    return Align(
      alignment: Alignment.bottomCenter,
      child: ZegoLiveStreamingBottomBar(
        buttonSize: zegoLiveButtonSize,
        config: widget.config,
        events: widget.events,
        defaultEndAction: widget.defaultEndAction,
        defaultLeaveConfirmationAction: widget.defaultLeaveConfirmationAction,
        hostManager: widget.hostManager,
        hostUpdateEnabledNotifier: widget.hostManager.hostUpdateEnabledNotifier,
        liveStatusNotifier: widget.liveStatusManager.notifier,
        connectManager: widget.connectManager,
        isLeaveRequestingNotifier: ZegoUIKitPrebuiltLiveStreamingController()
            .isLeaveRequestingNotifier,
        popUpManager: widget.popUpManager,
        isLiveStream: widget.isLiveStream,
        isCoHostEnabled: isCoHostEnabled,
        translationText: widget.config.innerText,
        showComments: showComments,
        isHide: isHide,
      ),
    );
  }

  Widget messageList() {
    if (!widget.config.inRoomMessage.visible) {
      return Container();
    }

    var listSize = Size(
      widget.config.inRoomMessage.width ?? 540.zR,
      widget.config.inRoomMessage.height ?? 400.zR,
    );
    if (listSize.width < 54.zR) {
      listSize = Size(54.zR, listSize.height);
    }
    if (listSize.height < 40.zR) {
      listSize = Size(listSize.width, 40.zR);
    }
    return Positioned(
      left: 32.zR + (widget.config.inRoomMessage.bottomLeft?.dx ?? 0),
      bottom: 124.zR + (widget.config.inRoomMessage.bottomLeft?.dy ?? 0),
      child: ConstrainedBox(
        constraints: BoxConstraints.loose(listSize),
        child: ZegoLiveStreamingInRoomLiveMessageView(
          config: widget.config.inRoomMessage,
          events: widget.events.inRoomMessage,
          innerText: widget.config.innerText,
          avatarBuilder: widget.config.avatarBuilder,
          pseudoStream: ZegoUIKitPrebuiltLiveStreamingController()
                  .message
                  .private
                  .streamControllerPseudoMessage
                  ?.stream ??
              const Stream.empty(),
        ),
      ),
    );
  }

  Widget durationTimeBoard() {
    if (!widget.config.duration.isVisible) {
      return Container();
    }

    return Positioned(
      left: 0,
      right: 0,
      top: 10,
      child: ZegoLiveStreamingDurationTimeBoard(
        config: widget.config.duration,
        events: widget.events.duration,
        manager: widget.liveDurationManager,
      ),
    );
  }

  Widget foreground(double width, double height) {
    return widget.config.foreground ?? Container();
  }
}
