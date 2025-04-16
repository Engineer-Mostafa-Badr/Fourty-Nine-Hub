import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/cubit/stories_cubit.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/pages/create_story_screen.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/pages/more_stories.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:story_view/controller/story_controller.dart';

class FriendsStories extends StatelessWidget {
  const FriendsStories({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 8,
              ),
              // SizedBox(height: 100, child: _createMyStory(context)),
              const SizedBox(
                width: 6,
              ),
              BlocBuilder<StoryCubit, StoryState>(
                builder: (context, state) {
                  // if (state.users.isEmpty ?? false) {
                  //   // return Padding(
                  //   //   padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  //   //   child: Shimmer.fromColors(
                  //   //     baseColor: Colors.grey.withOpacity(0.1),
                  //   //     highlightColor: Colors.grey.withOpacity(0.5),
                  //   //     child: CircleAvatar(
                  //   //       radius: MediaQuery.of(context).size.height *
                  //   //           0.03, // Responsive radius
                  //   //     ),
                  //   //   ),
                  //   // );
                  //   return const SizedBox();
                  // }
                  return ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: _buildStoryItem(context, state, index),
                      );
                    },
                    separatorBuilder: (context, index) => const Sizer(
                      width: 8,
                    ),
                    itemCount:
                    // state.users.length ??
                    6,
                  );
                },
              ),
              const Sizer(
                width: 12,
              ),
              // BlocConsumer<StoryCubit, StoryState>(
              //   listener: (context, state) {
              //     // TODO: implement listener
              //   },
              //   builder: (context, state) {
              //     if (state.mutedStoriesResponse != null &&
              //         state.mutedStoriesResponse!.data.stories.isNotEmpty) {
              //       return _mutedStories(context);
              //     }
              //     return const SizedBox(
              //       height: 0,
              //       width: 0,
              //     );
              //   },
              // ),
              const Sizer(
                width: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createMyStory(BuildContext context) {
    return FittedBox(
      child: GestureDetector(
        onTap: () async {
          context.read<UserCubit>().isLoggedIn
              ? await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CameraScreen(),
            ),
          )
              : context.push(Routes.LOGIN);

          BlocProvider.of<StoryCubit>(context)
            ..fetchStories()
            ..getMutedStories();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF0B1035), Color(0xFFFF3308)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(6.h),
                child: Container(
                  padding: EdgeInsets.all(1.h),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.all(Radius.circular(100)),
                  ),
                  child: CircleAvatar(
                    radius: 48.h, // Responsive radius
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: CircleAvatar(
                            backgroundColor: AppColors.PRIMARY_COLOR,
                            backgroundImage: NetworkImage(
                              serviceLocator<UserCubit>().state.data != null &&
                                  context.isUserLoggedIn
                                  ? serviceLocator<UserCubit>()
                                  .state
                                  .data!
                                  .profilePicture!
                                  : UIConst.profilePlaceHolder,
                            ),
                            onBackgroundImageError: (_, __) => Image.asset(
                              UIConst.profilePlaceHolder,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -4,
                          right: -6,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFF0B1035), Color(0xFFFF3308)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            padding: const EdgeInsets.all(3),
                            child: CircleAvatar(
                              backgroundColor: AppColors.PRIMARY_COLOR,
                              radius: 14.h,
                              child: Icon(
                                Icons.add,
                                size: 25.h,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            RichText(
              text:
              TextSpan(
                  children: [
                    TextSpan(
                      text: context.isArabic?"قصتي":"My Story",
                      style: Styles.mediumText(fontWeight: FontWeight.w400,),
                    ),
                  ]
                // Localized text

              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _mutedStories(BuildContext context) {
  //   return FittedBox(
  //     child: GestureDetector(
  //       onTap: () async {
  //         context.read<UserCubit>().isLoggedIn
  //             ? await Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => BlocProvider.value(
  //               value: serviceLocator<StoryCubit>(),
  //               child: const MutedStories(),
  //             ),
  //           ),
  //         )
  //             : context.push(Routes.LOGIN);
  //
  //         context.read<StoryCubit>()
  //           ..fetchStories()
  //           ..getMutedStories();
  //       },
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           CircleAvatar(
  //             radius:
  //             MediaQuery.of(context).size.width * 0.08, // Responsive radius
  //             backgroundColor: Colors.black12,
  //
  //             child: Icon(
  //               Icons.notifications_off_outlined,
  //               color: context.isDarkMode
  //                   ? AppColors.LIGHT_COLOR
  //                   : Colors.black.withOpacity(0.68),
  //             ),
  //             // child: Icon(icon)
  //           ),
  //           const SizedBox(
  //             height: 2,
  //           ),
  //           FittedBox(
  //             child: Text(
  //               LocaleKeys.muted.localize,
  //               style: Styles.headerText(
  //                   color: context.isDarkMode
  //                       ? AppColors.LIGHT_COLOR
  //                       : Colors.black.withOpacity(0.68),
  //                   fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildStoryItem(BuildContext context, StoryState state, int index) {
    final userController = StoryController();

    return FittedBox(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          context.read<UserCubit>().isLoggedIn
              ? await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: serviceLocator<StoryCubit>(),
                child: StoryViewScreen(
                  stories: state.users ?? [],
                  initialUserIndex: index,
                ),
              ),
            ),
          )
              : context.push(Routes.LOGIN);

          BlocProvider.of<StoryCubit>(context)
            ..fetchStories()
            ..getMutedStories();
        },
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClickableWidget(
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF0B1035), Color(0xFFFF3308)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(6.h),
                  child: Container(
                    padding: EdgeInsets.all(1.h),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.all(Radius.circular(100)),
                    ),
                    child: CircleAvatar(
                      radius: 48.h, // Responsive radius
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned.fill(
                            child: CircleAvatar(
                              backgroundColor: AppColors.PRIMARY_COLOR,
                              backgroundImage: AssetImage(
                                Assets.spotlight_profile,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            FittedBox(
              child:
              RichText(
                textAlign: TextAlign.center,
                text:
                TextSpan(
                    children: [
                      TextSpan(
                        text: 'Ali\n',
                        style: Styles.mediumText(fontWeight: FontWeight.w400,),
                      ),
                      TextSpan(
                        text: "Alimohamed",
                        style: Styles.smallText(color: Colors.black.withOpacity(0.7)),
                      ),
                    ]
                  // Localized text

                ),
              ),

            ),
          ],
        ),
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     ProfileWithStoriesBorder(
        //       profilePictureUrl:'ljk',
        //           // state.users[index].user?.profilePictureUrl ?? '',
        //       storiesCount: 1
        //       // state.users[index].stories?.length ?? 0,
        //     ),
        //     const SizedBox(height: 8),
        //     FittedBox(
        //       child: Text(
        //         'ahmed',
        //         // capitalizeAndSplit2Only(
        //         //   state.users[index].user?.firstName?.split(' ').first ?? '',
        //         // ),
        //         textScaler: TextScaler.noScaling,
        //         style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
        //         textAlign: TextAlign.center,
        //         maxLines: 1,
        //         overflow: TextOverflow.ellipsis,
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}