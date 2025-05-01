import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/components/unified_widget_view.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/search_app_users.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/social_media/spot_light/presentation/pages/other_profile_view.dart';
import 'package:fourtyninehub/features/social_media/spot_light/presentation/pages/profile_view.dart';
import 'package:fourtyninehub/features/social_media/spot_light/presentation/widgets/friends_stories.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../reels/data/models/new_reels_model.dart';
import '../../../reels/presentation/controllers/explore_reels_cubit/reel_cubit.dart';
import '../../../stories/presentation/cubit/stories_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

//Todo:Mohamed Magdy: جميع الاكواد اللي معمول لها كومينت هي اكواد فيها لوجيك انا شايلها عشان اشتغل علي ال يو اي او اكواد ملغيه انا عاملها كومنت عشان لو اللي هيربط يستفاد منها او ياخد اجزاء منها
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
    final userId = userCubit.state.data?.id ?? '';

    return CustomScaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: BackAppBar(
            label: LocaleKeys.spotlight_title.tr(),
            actions: [
              CircleAvatar(
                radius: 35.h, // Responsive radius
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: ClickableWidget(
                        onTap: ()=>Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>const SpotLightProfileScreen(),
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: AppColors.PRIMARY_COLOR,
                          backgroundImage: AssetImage(
                            Assets.personalImage,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Sizer(),
            ],
          ),
        ),
        body:
            // isLoggedIn
            //     ?
            CustomScrollView(
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
        // : const Center(
        //     child: CupertinoActivityIndicator(),
        //   ),
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
              LocaleKeys.friends_title.tr(),
              textScaler: TextScaler.noScaling,
              style: Styles.headerText(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          BlocProvider<StoryCubit>(
            create: (_) => serviceLocator()
              ..fetchStories()
              ..getMutedStories(),
            child: const FriendsStories(),
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

  void _onScroll(ScrollMetrics metrics) {
    double currentScrollPosition = metrics.pixels;

    bool isScrollingRightToLeft =
        currentScrollPosition > _previousScrollPosition;

    if (isScrollingRightToLeft &&
        currentScrollPosition >= metrics.maxScrollExtent + 20 &&
        !_isFetchingMore) {
      _fetchMoreReels();
    }

    _previousScrollPosition = currentScrollPosition;
  }

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
            style: Styles.headerText(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.65,
          width: double.infinity,
          child: BlocConsumer<ReelsCubit, ReelsState>(
            builder: (context, state) {
              // if (state.reelsForFollowing?.isEmpty ?? false) {
              //   return Center(child: Text(LocaleKeys.noFollowing.localize));
              // }
              return Stack(
                children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      if (notification is ScrollUpdateNotification) {
                        _onScroll(notification.metrics);
                      }
                      return true;
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      //(state.reelsForFollowing?.length ?? 0),
                      itemBuilder: (context, index) {
                        // final reel = state.reelsForFollowing![index];
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 6.h),
                            child: _buildReelCard(context, index),
                          ),
                        );
                      },
                    ),
                  ),
                  // if (_isFetchingMore)
                  //   const Positioned(
                  //     right: 16,
                  //     top: 16,
                  //     bottom: 16,
                  //     child: Center(child: CircularProgressIndicator()),
                  //   ),
                ],
              );
            },
            listener: (BuildContext context, ReelsState state) {},
          ),
        ),
      ],
    );
  }

  Widget _buildReelCard(
      BuildContext context,
      //Reel reel,
      int index) {
    return GestureDetector(
      onTap: () {},
      // async {
      //   await Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => BlocProvider.value(
      //           value: serviceLocator<ReelsCubit>(),
      //           child: CustomScaffold(
      //             extendBodyBehindAppBar: true,
      //             extendBody: true,
      //             appBar: AppBar(
      //               backgroundColor: Colors.transparent,
      //               elevation: 0,
      //               leading: IconAppButton(
      //                 icon: Icons.arrow_back,
      //                 size: 50.h,
      //                 color: context.isDarkMode ? Colors.white : Colors.grey,
      //                 onPressed: () => context.pop(),
      //               ),
      //               actions: const [
      //                 // const Spacer(),
      //                 // Padding(
      //                 //   padding: const EdgeInsets.all(8.0),
      //                 //   child: IconButton(
      //                 //     onPressed: () async {
      //                 //       // context.pop();
      //                 //       await Navigator.push(
      //                 //           context,
      //                 //           MaterialPageRoute(
      //                 //             builder: (context) =>
      //                 //                 const ReelsRecordingScreen(
      //                 //                     // advertisementType: 'reel',
      //                 //                     // comeFromCompany: 'company',
      //                 //                     // totalPrice: '500',
      //                 //                     ),
      //                 //           ));
      //                 //     },
      //                 //     icon: FaIcon(
      //                 //       Icons.camera_alt_outlined,
      //                 //       color: context.isDarkMode
      //                 //           ? Colors.white
      //                 //           : Colors.grey,
      //                 //       size: 50.h,
      //                 //     ),
      //                 //   ),
      //                 // )
      //               ],
      //             ),
      //             body: UnifiedReelItem(
      //               reel: reel,
      //               isVisible: true,
      //               index: index,
      //               itemType: ReelItemType.spotlight,
      //             ),
      //             // MainReelItem(
      //             //   key: ValueKey(reel.id),
      //             //   reel: reel,
      //             //   fromSpotlight: true,
      //             //   isVisible: true,
      //             // )
      //             // SpotlightReelItem(
      //             //   key: ValueKey(reel.id),
      //             //   reel: reel,
      //             //   isVisible: true,
      //             // ),,
      //           )),
      //     ),
      //   );
      // },
      child: Card(
        // elevation: 8,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            // Image.network(
            //   reel.thumbnailSignedUrl,
            //   width: double.infinity,
            //   height: double.infinity,
            //   fit: BoxFit.cover,
            //   errorBuilder: (context, error, stackTrace) =>const SizedBox.shrink(),
            //
            // ),

            //Todo: delete this wigdet and leave the network image above
            Image.asset(
              Assets.spotlight_profile,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClickableWidget(
                    onTap:()=>Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SpotLightOtherProfileScreen(),
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 40.w,
                      backgroundColor: AppColors.PRIMARY_COLOR,
                      //Todo: remove the background image and uncomment the child
                      backgroundImage: AssetImage(
                        Assets.personalImage,
                      ),
                      // child:ImageFromInternet(
                      //   image: reel.user.profilePictureSignedUrl ??
                      //       UIConst.profilePlaceHolder,
                      //   height: 60.h,
                      //   width: 60.w,
                      //   isCircle: true,
                      // ),
                    ),
                  ),
                  const Sizer(),
                  Label(
                    text: 'Ali\nMohamed',
                    //'${reel.user.firstName} ${_getFirstTwoWords(reel.user.lastName)}'
                    style: Styles.headerText(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 32),
                  ),
                  // Label(
                  //   text:
                  //   formatDate('${reel.createdAt}'
                  //   ),
                  // ),
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
            style: Styles.headerText(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Flexible(
          child: BlocBuilder<ReelsCubit, ReelsState>(
            builder: (context, state) {
              // if ((state.globalReels.isEmpty) &&
              //     !(state.globalReelsIsLoading)) {
              //   return const Center(child: CupertinoActivityIndicator());
              // }

              return GridView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.h,
                  crossAxisSpacing: 8.w,
                  childAspectRatio: 0.6,
                ),
                itemCount: 12,
                // (state.globalReels.length) +
                //     (widget.isFetchingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  // if (index == (state.globalReels.length) &&
                  //     widget.isFetchingMore) {
                  //   return const Padding(
                  //     padding: EdgeInsets.all(8.0),
                  //     child: CupertinoActivityIndicator(
                  //       color: Colors.black,
                  //     ),
                  //   );
                  // }
                  // final reel = state.globalReels[index];
                  return _buildReelCard(
                      context,
                      //reel,
                      index);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReelCard(
      BuildContext context,
      //Reel reel,
      int index) {
    return GestureDetector(
      onTap: () {},
      //Todo:  خلي اللي معموله كومينت مكان (){}
      // async {
      //   await Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => BlocProvider.value(
      //         value: serviceLocator<ReelsCubit>(),
      //         child: CustomScaffold(
      //           extendBodyBehindAppBar: true,
      //           extendBody: true,
      //           appBar: AppBar(
      //             backgroundColor: Colors.transparent,
      //             elevation: 0,
      //             leading: IconAppButton(
      //               icon: Icons.arrow_back,
      //               size: 50.h,
      //               color: context.isDarkMode ? Colors.white : Colors.grey,
      //               onPressed: () => context.pop(),
      //             ),
      //             actions: const [
      //               // const Spacer(),
      //               // Padding(
      //               //   padding: const EdgeInsets.all(8.0),
      //               //   child: IconButton(
      //               //     onPressed: () async {
      //               //       // context.pop();
      //               //       await Navigator.push(
      //               //           context,
      //               //           MaterialPageRoute(
      //               //             builder: (context) =>
      //               //                 const ReelsRecordingScreen(
      //               //                     // advertisementType: 'reel',
      //               //                     // comeFromCompany: 'company',
      //               //                     // totalPrice: '500',
      //               //                     ),
      //               //           ));
      //               //     },
      //               //     icon: FaIcon(
      //               //       Icons.camera_alt_outlined,
      //               //       color: context.isDarkMode
      //               //           ? Colors.white
      //               //           : Colors.grey,
      //               //       size: 50.h,
      //               //     ),
      //               //   ),
      //               // )
      //             ],
      //           ),
      //           body: UnifiedReelItem(
      //             reel: reel,
      //             index: index,
      //             isVisible: true,
      //             itemType: ReelItemType.spotlight,
      //           ),
      //           // SpotlightReelItem(
      //           //   key: ValueKey(reel.id),
      //           //   reel: reel,
      //           //   isVisible: true,
      //           // ),,
      //         ),
      //       ),
      //     ),
      //   );
      // },
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            // Image.network(
            //   reel.thumbnailSignedUrl,
            //   width: double.infinity,
            //   height: double.infinity,
            //   fit: BoxFit.cover,
            //   errorBuilder: (context, error, stackTrace) =>
            //       const SizedBox.shrink(),
            // ),

            // Todo: delete this widget and leave the network image above
            Image.asset(
              Assets.spotlight_profile,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClickableWidget(
                    onTap:()=>Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SpotLightOtherProfileScreen(),
                      ),
                    ),
                    child:
                    CircleAvatar(
                      radius: 32.w,
                      backgroundColor: AppColors.AUTH_CONTAINER_COLOR,
                      backgroundImage: AssetImage(
                        Assets.personalImage,
                      ),
                      // child:ImageFromInternet(
                      //   image: reel.user.profilePictureSignedUrl ??
                      //       UIConst.profilePlaceHolder,
                      //   height: 60.h,
                      //   width: 60.w,
                      //   isCircle: true,
                      // ),
                    ),
                  ),
                  const Sizer(),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Ali\n',
                        style: Styles.mediumText(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 32),
                      ),
                      TextSpan(
                        text: context.isArabic ? 'امس' : 'Yesterday',
                        style:
                            Styles.smallText(color: Colors.white, fontSize: 24),
                      ),
                    ]
                        // Localized text

                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
//
// String formatDate(String createdAt) {
//   final DateTime dateTime = DateTime.parse(createdAt);
//   final DateTime now = DateTime.now();
//
//   final DateTime today = DateTime(now.year, now.month, now.day);
//   final DateTime yesterday = today.subtract(const Duration(days: 1));
//
//   if (dateTime.isAfter(today)) {
//     return LocaleKeys.today.localize;
//   } else if (dateTime.isAfter(yesterday)) {
//     return LocaleKeys.yesterday.localize;
//   } else {
//     return context.locale == Locales.english
//         ? DateFormat('dd/MM/yyyy', 'en').format(dateTime)
//         : DateFormat('yyyy/MM/dd', 'ar')
//             .format(dateTime); // Format: 12-3-2022
//   }
// }
//
// String _getFirstTwoWords(String fullName) {
//   List<String> words = fullName.split(" ");
//   if (words.length > 1) {
//     // Capitalize the first letter of each word
//     words = words.map((word) {
//       return word[0].toUpperCase() + word.substring(1).toLowerCase();
//     }).toList();
//   }
//   return words.length > 1 ? '${words[0]} ${words[1]}' : words[0];
// }
}
