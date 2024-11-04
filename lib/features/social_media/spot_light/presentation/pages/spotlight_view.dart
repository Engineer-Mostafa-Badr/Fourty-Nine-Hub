import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/main_reel_view.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/components/unified_widget_view.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../reels/data/models/new_reels_model.dart';
import '../../../reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
import '../../../reels/presentation/widgets/comments.dart';
import '../../../stories/presentation/cubit/stories_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

class SpotlightView extends StatefulWidget {
  const SpotlightView({super.key});

  @override
  State<SpotlightView> createState() => _SpotlightViewState();
}

class _SpotlightViewState extends State<SpotlightView> {
  late ScrollController _scrollController;
  bool _isFetchingMore = false;
  int itemCount = 20;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _fetchInitialData();
  }

  void _fetchInitialData() {
    context.read<StoryCubit>().fetchStories();
    context.read<StoryCubit>().getMutedStories();
    context.read<ReelsCubit>().fetchReels();
    context.read<ReelsCubit>().fetchReelsForFollowers();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
            _scrollController.position.maxScrollExtent + 50 &&
        !_isFetchingMore) {
      _fetchMoreReels();
    }
  }

  Future<void> _fetchMoreReels() async {
    setState(() {
      _isFetchingMore = true;
    });
    await context.read<ReelsCubit>().fetchReels();
    setState(() {
      _isFetchingMore = false;
      itemCount += 10; // Simulate more items being added
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userCubit = serviceLocator<UserCubit>();
    final isLoggedIn = userCubit.isLoggedIn;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: isLoggedIn
          ? CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(
                  child: Column(
                    children: [
                      FriendsList(),
                      Sizer(),
                      FollowingSection(),
                      Sizer(),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: DiscoverSection(isFetchingMore: _isFetchingMore),
                ),
                if (_isFetchingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            )
          : const Center(
              child: CupertinoActivityIndicator(),
            ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final userCubit = serviceLocator<UserCubit>();
    final userId = userCubit.state.data?.id ?? '';

    return AppBar(
      elevation: 2,
      title: Text(
        LocaleKeys.spotlight_title.tr(),
        textScaler: TextScaler.noScaling,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 55.sp),
      ),
      actions: [
        IconButton(
          onPressed: () {
            context.push(
              Routes.OTHERSACCOUNT,
              extra: userId,
            );
          },
          icon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(
              Icons.person,
              size: 35,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}

class FriendsList extends StatelessWidget {
  const FriendsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              LocaleKeys.friends_title.tr(), // Localized text
              textScaler: TextScaler.noScaling,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.sp),
            ),
          ),
          BlocProvider<StoryCubit>(
            create: (_) => serviceLocator()
              ..fetchStories()
              ..getMutedStories(),
            child: const ChatStories(),
          ),
        ],
      ),
    );
  }
}

class FollowingSection extends StatefulWidget {
  const FollowingSection({super.key});

  @override
  State<FollowingSection> createState() => _FollowingSectionState();
}

class _FollowingSectionState extends State<FollowingSection> {
  late ScrollController _scrollController;
  bool _isFetchingMore = false;
  double _previousScrollPosition = 0.0; // Track previous scroll position

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // _scrollController.addListener(_onScroll);
  }

  // Updated _onScroll method to detect scroll direction and trigger fetch
  void _onScroll(ScrollMetrics metrics) {
    double currentScrollPosition = metrics.pixels;

    // print(
    //     'Current scroll: ${currentScrollPosition}, Max scroll extent: ${metrics.maxScrollExtent}');

    // Check if the user is scrolling right to left (i.e., scroll value is increasing)
    bool isScrollingRightToLeft =
        currentScrollPosition > _previousScrollPosition;

    // Check if user has reached near the end of the list and is scrolling right to left
    if (isScrollingRightToLeft &&
        currentScrollPosition >= metrics.maxScrollExtent + 20 &&
        !_isFetchingMore) {
      _fetchMoreReels();
    }

    // Update the previous scroll position for the next event
    _previousScrollPosition = currentScrollPosition;
  }

  // void _onScroll() {
  //   if (_scrollController.position.pixels >=
  //           _scrollController.position.maxScrollExtent - 200 &&
  //       !_isFetchingMore) {
  //     _fetchMoreReels();
  //   }
  // }

  Future<void> _fetchMoreReels() async {
    setState(() {
      _isFetchingMore = true;
    });

    try {
      await context.read<ReelsCubit>().fetchReelsForFollowers();
      print('Fetching more reels');
    } finally {
      setState(() {
        _isFetchingMore = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            LocaleKeys.following_title.tr(), // Localized text
            textScaler: TextScaler.noScaling, // Adjusting for scaling
            style: TextStyle(fontSize: 50.sp, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.7,
          width: double.infinity,
          child: BlocConsumer<ReelsCubit, ReelsState>(
            builder: (context, state) {
              if (state.reelsForFollower?.isEmpty??false) {
                return const Center(child: CupertinoActivityIndicator());
              }
              return Stack(
                children: [
                  // Wrap ListView.builder in a NotificationListener to track scrolls
                  NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      if (notification is ScrollUpdateNotification) {
                        _onScroll(notification.metrics);
                      }
                      return true; // Prevent the event from bubbling up
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: (state.reelsForFollower?.length??0),
                      itemBuilder: (context, index) {
                        final reel = state.reelsForFollower![index];
                        return SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 12.h),
                            child: _buildReelCard(context, reel,index),
                          ),
                        );
                      },
                    ),
                  ),
                  if (_isFetchingMore)
                    const Positioned(
                      right: 16,
                      top: 16,
                      bottom: 16,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              );
            },
            listener: (BuildContext context, ReelsState state) {},
          ),
        ),
      ],
    );
  }

  Widget _buildReelCard(BuildContext context, Reel reel,int index) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                value: serviceLocator<ReelsCubit>(),
                child: Scaffold(
                  extendBodyBehindAppBar: true,
                  extendBody: true,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconAppButton(
                      icon: Icons.arrow_back,
                      size: 50.h,
                      color: context.isDarkMode ? Colors.white : Colors.grey,
                      onPressed: () => context.pop(),
                    ),
                    actions: const [
                      // const Spacer(),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: IconButton(
                      //     onPressed: () async {
                      //       // context.pop();
                      //       await Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) =>
                      //                 const ReelsRecordingScreen(
                      //                     // advertisementType: 'reel',
                      //                     // comeFromCompany: 'company',
                      //                     // totalPrice: '500',
                      //                     ),
                      //           ));
                      //     },
                      //     icon: FaIcon(
                      //       Icons.camera_alt_outlined,
                      //       color: context.isDarkMode
                      //           ? Colors.white
                      //           : Colors.grey,
                      //       size: 50.h,
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                  body: UnifiedReelItem(
                    reel: reel,
                    isVisible: true,
                    index:index,
                    itemType: ReelItemType.spotlight,
                  ),
                  // MainReelItem(
                  //   key: ValueKey(reel.id),
                  //   reel: reel,
                  //   fromSpotlight: true,
                  //   isVisible: true,
                  // )
                  // SpotlightReelItem(
                  //   key: ValueKey(reel.id),
                  //   reel: reel,
                  //   isVisible: true,
                  // ),,
                )),
          ),
        );
      },
      child: Card(
        elevation: 8,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Image.network(
              reel.thumbnailSignedUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: CupertinoActivityIndicator()),
            ),
            Positioned(
              bottom: 8,
              left: 2,
              child: Row(
                children: [
                  const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    reel.viewCount.toString(),
                    textScaler: TextScaler.noScaling,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiscoverSection extends StatefulWidget {
  final bool isFetchingMore;

  const DiscoverSection({super.key, required this.isFetchingMore});

  @override
  DiscoverSectionState createState() => DiscoverSectionState();
}

class DiscoverSectionState extends State<DiscoverSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            LocaleKeys.discover_title.tr(), // Localized text
            textScaler: TextScaler.noScaling,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.sp),
          ),
        ),
        Flexible(
          child: BlocBuilder<ReelsCubit, ReelsState>(
            builder: (context, state) {
              if ((state.globalReels?.isEmpty??false) && !(state.globalReelsIsLoading??false)) {
                return const Center(child: CupertinoActivityIndicator());
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // GridView won't scroll independently
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
                itemCount:
                    (state.globalReels?.length??0) + (widget.isFetchingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == (state.globalReels?.length??0) &&
                      widget.isFetchingMore) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CupertinoActivityIndicator(
                        color: Colors.black,
                      ),
                    );
                  }
                  final reel = state.globalReels![index];
                  return _buildReelCard(context, reel,index);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReelCard(BuildContext context, Reel reel,int index) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: serviceLocator<ReelsCubit>(),
              child: Scaffold(
                extendBodyBehindAppBar: true,
                extendBody: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconAppButton(
                    icon: Icons.arrow_back,
                    size: 50.h,
                    color: context.isDarkMode ? Colors.white : Colors.grey,
                    onPressed: () => context.pop(),
                  ),
                  actions: const [
                    // const Spacer(),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: IconButton(
                    //     onPressed: () async {
                    //       // context.pop();
                    //       await Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) =>
                    //                 const ReelsRecordingScreen(
                    //                     // advertisementType: 'reel',
                    //                     // comeFromCompany: 'company',
                    //                     // totalPrice: '500',
                    //                     ),
                    //           ));
                    //     },
                    //     icon: FaIcon(
                    //       Icons.camera_alt_outlined,
                    //       color: context.isDarkMode
                    //           ? Colors.white
                    //           : Colors.grey,
                    //       size: 50.h,
                    //     ),
                    //   ),
                    // )
                  ],
                ),
                body: UnifiedReelItem(
                  reel: reel,
                  index:index,
                  isVisible: true,
                  itemType: ReelItemType.spotlight,
                ),
                // SpotlightReelItem(
                //   key: ValueKey(reel.id),
                //   reel: reel,
                //   isVisible: true,
                // ),,
              ),
            ),
          ),
        );
      },
      child: Card(
        elevation: 8,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Image.network(
              reel.thumbnailSignedUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: CupertinoActivityIndicator()),
            ),
            Positioned(
              bottom: 8,
              left: 2,
              child: Row(
                children: [
                  const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(
                      width: 4
                  ),
                  Text(
                    reel.viewCount.toString(),
                    textScaler: TextScaler.noScaling,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
