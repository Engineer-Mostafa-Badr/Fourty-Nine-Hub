import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/friends_stories_model.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:story_view/story_view.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../res/style/const.dart';
import '../../../tinder/data/shared/shared.dart';
import '../../../twitter/presentation/widgets/report_view.dart';
import '../cubit/stories_cubit.dart';

class ReactionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> reactions = [
    {'icon': '❤️', 'color': Colors.red, 'label': 'Love'},
    {'icon': '👍', 'color': Colors.blue, 'label': 'Like'},
    {'icon': '😂', 'color': Colors.amber, 'label': 'Haha'},
    {'icon': '😮', 'color': Colors.yellow, 'label': 'Wow'},
    {'icon': '😢', 'color': Colors.orange, 'label': 'Sad'},
    {'icon': '😠', 'color': Colors.redAccent, 'label': 'Angry'},
  ];

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

  const StoryViewScreen({
    super.key,
    this.initialUserIndex = 0,
    required this.stories,
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
        body: widget.stories.isNotEmpty
            ? PageView.builder(
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
              )
            : const Sizer(),
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

class UserStoryViewState extends State<UserStoryView> {
  late final StoryController _storyController;
  late final ValueNotifier<DateTime> _currentStoryCreatedAtNotifier;
  late final ValueNotifier<String> _currentStoryIdNotifier;

  @override
  void initState() {
    super.initState();
    _storyController = StoryController();
    _currentStoryCreatedAtNotifier =
        ValueNotifier<DateTime>(widget.userStory.userStories!.first.createdAt!);
    _currentStoryIdNotifier = ValueNotifier<String>('');
  }

  @override
  void dispose() {
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
        Positioned(
          bottom: 8,
          right: 0,
          left: 0,
          child: SizedBox(
            height: kToolbarHeight,
            child: ReactionWidget(),
          ),
        ),
      ],
    );
  }

  Widget _buildStoryView() {
    return StoryView(
      storyItems: widget.userStory.userStories
              ?.map(
                  (story) => createStoryItem(context, story, _storyController))
              .toList() ??
          [],
      onStoryShow: (storyItem, index) {
        _currentStoryCreatedAtNotifier.value =
            widget.userStory.userStories![index].createdAt!;
        _currentStoryIdNotifier.value =
            widget.userStory.userStories![index].id ?? '';
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
                ),
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
                onTap: _storyController.previous,
                child: Container(color: Colors.transparent),
              ),
            ),
            Expanded(
              child: GestureDetector(
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

  const UserInfoBar({
    super.key,
    required this.userStory,
    required this.createdAt,
    required this.currentUserId,
    required this.currentStoryId,
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
        shadows: [
          Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 9),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context) {
    return InkWell(
      onTap: () =>
          context.push(Routes.OTHERSACCOUNT, extra: widget.userStory.user?.id),
      child: CircleAvatar(
        minRadius: 25,
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
          style: const TextStyle(color: Colors.white),
        ),
        SizedBox(height: 4.h),
        Text(
          DateFormat('hh:mm a').format(widget.createdAt),
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildMoreOptionsButton(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
        size: 35,
      ),
      onSelected: (String value) async {
        if (value == 'delete') {
          debugPrint('Deleting story with ID: ${widget.currentStoryId}');
          await BlocProvider.of<StoryCubit>(context)
              .deleteStory(widget.currentStoryId);
          Navigator.of(context).pop();
        } else if (value == 'report') {
          bottomSheet(
            context: context,
            widget: ReportView(
              id: widget.currentUserId,
              categoryId: '66684135dbb427ee42aa0141',
            ),
          );
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          if (widget.userStory.user?.id == widget.currentUserId)
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 10),
                  Text(
                    'Delete',
                    textScaler: TextScaler.noScaling,
                  ),
                ],
              ),
            ),
          if (widget.userStory.user?.id != widget.currentUserId)
            const PopupMenuItem<String>(
              value: 'report',
              child: Row(
                children: [
                  Icon(Icons.report, color: Colors.orange),
                  SizedBox(width: 10),
                  Text(
                    'Report',
                    textScaler: TextScaler.noScaling,
                  ),
                ],
              ),
            ),
        ];
      },
    );
  }
}

// String capitalizeAndSplit2Only(String text) {
//   return text.split(' ').map((str) {
//     return str[0].toUpperCase() + str.substring(1).toLowerCase();
//   }).join(' ');
// }

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
        backgroundColor:
            colorMap[getFirstSubstringBeforeTilde(storyData.content!)] ??
                Colors.deepOrange,
      );
    case 'image':
      return StoryItem.pageImage(
        loadingWidget: const CupertinoActivityIndicator(
          color: Colors.white,
        ),
        errorWidget: const CupertinoActivityIndicator(
          color: Colors.white,
        ),
        url: storyData.content!,
        caption: storyData.caption != null && storyData.caption != 'null'
            ? Text(
                storyData.caption!,
                textScaler: TextScaler.noScaling,
                style: const TextStyle(color: Colors.white),
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
        storyData.content!,
        caption: storyData.caption != null && storyData.caption != 'null'
            ? Text(
                storyData.caption!,
                textScaler: TextScaler.noScaling,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
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
