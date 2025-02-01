import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/friends_stories_model.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:story_view/story_view.dart';
import 'package:voice_message_package/voice_message_package.dart';
import '../../../../../res/style/const.dart';
import '../../../tinder/data/shared/shared.dart';
import '../../../twitter/presentation/widgets/report_view.dart';
import '../cubit/stories_cubit.dart';

class EnhancedInputWidget extends StatefulWidget {
  const EnhancedInputWidget({super.key, required this.story});
  final Story story;

  @override
  State<EnhancedInputWidget> createState() => _EnhancedInputWidgetState();
}

class _EnhancedInputWidgetState extends State<EnhancedInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade900,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              spreadRadius: 1.0,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  widget.story.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: widget.story.isLiked
                      ? AppColors.PRIMARY_COLOR_DARK
                      : Colors.white,
                ),
                onPressed: () async {
                  // Handle favorite button press

                  await BlocProvider.of<StoryCubit>(context)
                      .makeLike(widget.story.id!);
                  setState(() {
                    widget.story.isLiked = !widget.story.isLiked;
                  });
                },
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  disabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  hintText: context.isArabic ? 'رد' : 'Replay',
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  // Handle send button press
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReactionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> reactions = [
    {'icon': '❤️', 'color': Colors.red, 'label': 'Love'},
    {'icon': '👍', 'color': Colors.blue, 'label': 'Like'},
    {'icon': '😂', 'color': Colors.amber, 'label': 'Haha'},
    {'icon': '😮', 'color': Colors.yellow, 'label': 'Wow'},
    {'icon': '😢', 'color': Colors.orange, 'label': 'Sad'},
    {'icon': '😠', 'color': Colors.redAccent, 'label': 'Angry'},
  ];

  ReactionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      // Disable text scaling
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: _buildTextField(context),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: _buildReactionsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(25.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: TextField(
          maxLines: null,
          onChanged: (value) => debugPrint(value),
          cursorColor: Colors.white,
          cursorErrorColor: Colors.red,
          decoration: const InputDecoration(
            fillColor: Colors.transparent,
            hintText: 'Send message...',
            hintStyle: TextStyle(
              color: Colors.white54,
            ),
          ),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildReactionsList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: reactions.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final reaction = reactions[index];
        return FloatingActionButton.small(
          onPressed: () {
            debugPrint('Selected: ${reaction['label']}');
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Text(reaction['icon']),
        );
      },
    );
  }
}

class StoryViewScreen extends StatefulWidget {
  final int initialUserIndex;
  final List<UserStories> stories;

  final List<UserStories>? mutedStories;

  const StoryViewScreen({
    super.key,
    this.initialUserIndex = 0,
    required this.stories,
    this.mutedStories,
  });

  @override
  StoryViewScreenState createState() => StoryViewScreenState();
}

class StoryViewScreenState extends State<StoryViewScreen> {
  late final PageController _pageController;
  int _currentUserIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialUserIndex);
    _currentUserIndex = widget.initialUserIndex;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToNextUser() {
    if (_currentUserIndex < widget.stories.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _navigateToPreviousUser() {
    if (_currentUserIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Builder(builder: (context) {
          if (widget.stories.isNotEmpty) {
            return PageView.builder(
              controller: _pageController,
              itemCount: widget.stories.length,
              onPageChanged: (index) {
                setState(() {
                  _currentUserIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return UserStoryView(
                  currentUserId: serviceLocator<UserCubit>().state.data!.id,
                  userStory: widget.stories[index],
                  onComplete: _navigateToNextUser,
                  onPrevious: _navigateToPreviousUser,
                );
              },
            );
          }
          if (widget.mutedStories!.isNotEmpty) {
            return PageView.builder(
              controller: _pageController,
              itemCount: widget.mutedStories!.length,
              onPageChanged: (index) {
                setState(() {
                  _currentUserIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return UserStoryView(
                  currentUserId: serviceLocator<UserCubit>().state.data!.id,
                  userStory: widget.mutedStories![index],
                  onComplete: _navigateToNextUser,
                  onPrevious: _navigateToPreviousUser,
                );
              },
            );
          }
          return const Sizer();
        }),
      ),
    );
  }
}

class UserStoryView extends StatefulWidget {
  final UserStories userStory;
  final VoidCallback onComplete;
  final VoidCallback onPrevious;
  final String currentUserId;

  const UserStoryView({
    super.key,
    required this.userStory,
    required this.onComplete,
    required this.onPrevious,
    required this.currentUserId,
  });

  @override
  UserStoryViewState createState() => UserStoryViewState();
}

class UserStoryViewState extends State<UserStoryView>
    with WidgetsBindingObserver {
  late final StoryController _storyController;
  late final ValueNotifier<DateTime> _currentStoryCreatedAtNotifier;
  late final ValueNotifier<String> _currentStoryIdNotifier;
  late final ValueNotifier<int> _currentStoryIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _storyController = StoryController();
    _currentStoryCreatedAtNotifier =
        ValueNotifier<DateTime>(widget.userStory.stories!.first.createdAt!);
    _currentStoryIdNotifier = ValueNotifier<String>('');
    // Add this widget as an observer to listen for keyboard visibility changes
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottomInset > 0.0) {
      // Keyboard is visible
      _storyController.pause();
    } else {
      // Keyboard is hidden
      _storyController.play();
    }
  }

  @override
  void dispose() {
    // Clean up resources
    WidgetsBinding.instance.removeObserver(this);
    _storyController.dispose();
    _currentStoryCreatedAtNotifier.dispose();
    _currentStoryIdNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildStoryView(),
        _buildUserInfoBar(),
        _buildNavigationOverlay(),
        if (widget.userStory.user!.id !=
            serviceLocator<UserCubit>().state.data!.id)
          Positioned(
            bottom: 8,
            right: 0,
            left: 0,
            child: SizedBox(
              height: kToolbarHeight,
              child: ValueListenableBuilder<int>(
                  valueListenable: _currentStoryIndex,
                  builder: (context, currentIndex, child) {
                    return EnhancedInputWidget(
                        story: widget.userStory.stories![currentIndex]);
                  }),
            ),
          )
        else
          BlocBuilder<StoryCubit, StoryState>(
            // listener: (context, state) {
            //   TODO: implement listener
            // },
            builder: (context, state) {
              return Positioned(
                bottom: 8,
                right: 0,
                left: 0,
                child: SizedBox(
                  height: kToolbarHeight,
                  width: 0.1.sw,
                  child: InkWell(
                    onTap: () async {
                      _storyController.pause();
                      await showViewerList(context, state.viewersResponse!);
                      _storyController.play();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.remove_red_eye_outlined,
                          size: 32,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          state.viewersResponse != null
                              ? state.viewersResponse!.data.length.toString()
                              : '',
                          style: Styles.mediumText(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ValueListenableBuilder<int>(
          valueListenable: _currentStoryIndex,
          builder: (context, currentIndex, child) {
            if (widget.userStory.stories![currentIndex].type == 'audio') {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: MediaQuery.of(context).size.height * 0.44),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: VoiceMessageView(
                                counterTextStyle:
                                    const TextStyle(color: Colors.white),
                                activeSliderColor: AppColors.BACKGROUND_COLOR,
                                circlesColor: AppColors.PRIMARY_COLOR_DARK,
                                notActiveSliderColor:
                                    Colors.black.withOpacity(0),
                                backgroundColor: Colors.transparent,
                                innerPadding: 12,
                                cornerRadius: 12,
                                controller: VoiceController(
                                  audioSrc: widget.userStory
                                      .stories![currentIndex].content!,
                                  maxDuration: const Duration(minutes: 1000),
                                  isFile: false,
                                  onComplete: () async {
                                    _storyController.play();
                                  },
                                  onPause: () async {
                                    _storyController.play();
                                  },
                                  onPlaying: () async {
                                    _storyController.pause();
                                  },
                                  onError: (p0) {},
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: AppColors.LIGHT_GRAY_COLOR2,
                          height: 70,
                          indent: MediaQuery.of(context).size.width * 0.3,
                          endIndent: MediaQuery.of(context).size.width * 0.32,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox
                .shrink(); // Return an empty widget if not audio
          },
        )
      ],
    );
  }

  Widget _buildStoryView() {
    return StoryView(
      storyItems: widget.userStory.stories
              ?.map(
                  (story) => createStoryItem(context, story, _storyController))
              .toList() ??
          [],
      onStoryShow: (storyItem, index) {
        // Update the existing ValueNotifier
        _currentStoryIndex.value = index;
        context.read<StoryCubit>().makeView(
            context: context, storyId: widget.userStory.stories![index].id);
        _currentStoryCreatedAtNotifier.value =
            widget.userStory.stories![index].createdAt!;
        _currentStoryIdNotifier.value =
            widget.userStory.stories![index].id ?? '';
      },
      controller: _storyController,
      onComplete: widget.onComplete,
      onVerticalSwipeComplete: (direction) {
        if (direction == Direction.down) {
          Navigator.of(context).pop();
        }
      },
      progressPosition: ProgressPosition.top,
    );
  }

  Widget _buildUserInfoBar() {
    return Positioned(
      top: kToolbarHeight,
      left: 0,
      right: 0,
      child: ValueListenableBuilder<DateTime>(
        valueListenable: _currentStoryCreatedAtNotifier,
        builder: (context, createdAt, child) {
          return ValueListenableBuilder(
            valueListenable: _currentStoryIdNotifier,
            builder: (BuildContext context, value, Widget? child) {
              return BlocProvider(
                create: (context) => serviceLocator<StoryCubit>(),
                child: UserInfoBar(
                    currentUserId: widget.currentUserId,
                    userStory: widget.userStory,
                    createdAt: createdAt,
                    currentStoryId: value,
                    controller: _storyController),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNavigationOverlay() {
    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight * 2),
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! < 0) {
              widget.onComplete();
            } else if (details.primaryVelocity! > 0) {
              widget.onPrevious();
            }
          }
        },
        onVerticalDragEnd: (DragEndDetails details) {
          if (details.primaryVelocity! < -300 ||
              details.primaryVelocity! > 300) {
            Navigator.of(context).pop();
          }
        },
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onLongPressEnd: (details) {
                  _storyController.play();
                },
                onLongPress: () {
                  _storyController.pause();
                },
                onTap: _storyController.previous,
                child: Container(color: Colors.transparent),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onLongPressEnd: (details) {
                  _storyController.play();
                },
                onLongPress: () {
                  _storyController.pause();
                },
                onTap: _storyController.next,
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoBar extends StatefulWidget {
  final UserStories userStory;
  final DateTime createdAt;
  final String currentUserId;
  final String currentStoryId;
  final StoryController controller;

  const UserInfoBar({
    super.key,
    required this.userStory,
    required this.createdAt,
    required this.currentUserId,
    required this.currentStoryId,
    required this.controller,
  });

  @override
  State<UserInfoBar> createState() => _UserInfoBarState();
}

class _UserInfoBarState extends State<UserInfoBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildBackButton(context),
          _buildUserAvatar(context),
          const SizedBox(width: 8),
          _buildUserInfo(),
          const Spacer(),
          _buildMoreOptionsButton(context),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
        size: 25,
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context) {
    return InkWell(
      onTap: () =>
          context.push(Routes.OTHERSACCOUNT, extra: widget.userStory.user?.id),
      child: CircleAvatar(
        minRadius: 22,
        backgroundImage:
            NetworkImage(widget.userStory.user?.profilePictureUrl ?? ''),
        onBackgroundImageError: (_, __) =>
            const NetworkImage(UIConst.profilePlaceHolder),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          capitalizeAndSplit2Only(
              '${widget.userStory.user?.firstName ?? ''} ${widget.userStory.user?.lastName ?? ''}'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          DateFormat('hh:mm a').format(widget.createdAt),
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMoreOptionsButton(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
        size: 25,
      ),
      color: AppColors.PRIMARY_COLOR,
      onOpened: () {
        widget.controller.pause();
      },
      onCanceled: () => widget.controller.play(),
      onSelected: (String value) async {
        if (value == 'Delete') {
          debugPrint('Deleting story with ID: ${widget.currentStoryId}');
          await BlocProvider.of<StoryCubit>(context)
              .deleteStory(widget.currentStoryId);
          setState(() {
            widget.userStory.stories!
                .removeWhere((story) => story.id == widget.currentStoryId);
          });
          Navigator.of(context).pop();
        } else if (value == 'Report') {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return SizedBox(
                height: isKeyboardVisible(context) ? 0.8.sh : 0.6.sh,
                child: ReportView(
                  id: widget.currentStoryId,
                  categoryId: '668e7b4be8cfec5bcc752af9',
                ),
              );
            },
          );
        } else if (value == 'Mute') {
          context.read<StoryCubit>().muteUserStories(
              context: context, userId: widget.userStory.user!.id ?? '');
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          if (widget.userStory.user?.id == widget.currentUserId)
            PopupMenuItem<String>(
              value: 'Delete',
              child: Text(
                context.isArabic ? "حذف" : "Delete",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (widget.userStory.user?.id != widget.currentUserId)
            PopupMenuItem<String>(
              value: 'Mute',
              child: Text(
                context.isArabic ? "كتم" : "Mute",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (widget.userStory.user?.id != widget.currentUserId)
            PopupMenuItem<String>(
              value: 'Message',
              child: Text(
                context.isArabic ? "رسالة" : "Message",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (widget.userStory.user?.id != widget.currentUserId)
            PopupMenuItem<String>(
              value: 'Voice call',
              child: Text(
                context.isArabic ? "مكالمة صوتية" : "Voice call",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (widget.userStory.user?.id != widget.currentUserId)
            PopupMenuItem<String>(
              value: 'video call',
              child: Text(
                context.isArabic ? "مكالمة فيديو" : "Video call",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (widget.userStory.user?.id != widget.currentUserId)
            PopupMenuItem<String>(
              value: 'View contact',
              child: Text(
                context.isArabic ? "عرض جهة الاتصال" : "View contact",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (widget.userStory.user?.id != widget.currentUserId)
            PopupMenuItem<String>(
              value: 'Report',
              child: Text(
                context.isArabic ? "إبلاغ" : "Report",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ];
      },
    );
  }
}

String removeSubstringBeforeFirstTildeOnly(String input) {
  int tildeIndex = input.indexOf('~');
  if (tildeIndex != -1) {
    return input.substring(tildeIndex + 1);
  } else {
    return input; // Return the whole string if there's no tilde
  }
}

final Map<String, Color> colorMap = {
  'Colors.red': Colors.red,
  'Colors.white': Colors.blueGrey,
  'Colors.black': Colors.black,
  'Colors.blue': Colors.blue,
  'Colors.green': Colors.green,
  'Colors.yellow': Colors.yellow,
  'Colors.orange': Colors.orange,
  'Colors.purple': Colors.purple,
};

String getFirstSubstringBeforeTilde(String input) {
  if (input.contains('~')) {
    return input.split('~')[0];
  } else {
    return input; // Return the whole string if there's no tilde
  }
}

StoryItem createStoryItem(context, Story storyData, StoryController controller,
    {TextStyle? textStyle}) {
  switch (storyData.type) {
    case 'text':
      return StoryItem.text(
        title: removeSubstringBeforeFirstTildeOnly(storyData.content!),
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontFamily: storyData.fontFamily,
        ),
        duration: const Duration(seconds: 7),
        backgroundColor: colorMap[storyData.color] ?? Colors.deepOrange,
      );
    case 'audio':
      return StoryItem.text(
        title: '',
        duration: const Duration(seconds: 7),
        backgroundColor: colorMap[storyData.color] ?? Colors.deepOrange,
      );
    case 'image':
      return StoryItem.pageImage(
        loadingWidget: const CupertinoActivityIndicator(
          color: Colors.white,
        ),
        errorWidget: const CupertinoActivityIndicator(
          color: Colors.white,
        ),
        captionOuterPadding: const EdgeInsets.only(bottom: 60, top: 16),
        // imageFit: BoxFit.cover,
        duration: const Duration(seconds: 7),
        url: storyData.content!,
        caption: storyData.caption != null && storyData.caption != 'null'
            ? Text(
                storyData.caption!,
                // textScaler: TextScaler.noScaling,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              )
            : null,
        controller: controller,
      );
    case 'video':
      return StoryItem.pageVideo(
        loadingWidget: const CupertinoActivityIndicator(
          color: Colors.white,
        ),
        errorWidget: const CupertinoActivityIndicator(
          color: Colors.white,
        ),
        duration: const Duration(seconds: 7),
        storyData.content!,
        caption: storyData.caption != null && storyData.caption != 'null'
            ? Container(
                // color: Colors.black54,
                padding: const EdgeInsets.only(bottom: 40, top: 16),
                child: Text(
                  storyData.caption!,
                  textScaler: TextScaler.noScaling,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              )
            : null,
        controller: controller,
      );
    default:
      return StoryItem.text(
        title: "Unknown story type",
        backgroundColor: Colors.red,
      );
  }
}
