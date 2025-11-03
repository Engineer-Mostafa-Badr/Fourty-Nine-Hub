import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'muted_stories.dart';
import '../../../../../service_locator/service_locator.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
// Import localization keys

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';
import '../../../tinder/data/shared/shared.dart';
import '../cubit/stories_cubit.dart';
import 'more_stories.dart';
import 'create_story_screen.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class Stories extends StatelessWidget {
  const Stories({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight * 3.2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        padding: const EdgeInsets.all(8),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CameraScreen(),
                ),
              );

              // ignore: use_build_context_synchronously
              BlocProvider.of<StoryCubit>(context)
                ..fetchStories()
                ..getMutedStories();
            },
            child: Container(
              height: kToolbarHeight * 2, // Maintain story aspect ratio
              width: 104, // Maintain width proportion
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius:
                    BorderRadius.circular(12), // Slightly rounded corners
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  /// Profile Image (Top Half)
                  Column(
                    children: [
                      /// Image Takes Up **More Than Half** to Make Space for Circle
                      Expanded(
                        flex: 6,
                        child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top:
                                    Radius.circular(12)), // Rounded top corners
                            child: Image.asset(
                              'assets/images/454545.png',
                              fit: BoxFit.fitHeight,
                            )
                            //
                            // Image.network(
                            //   serviceLocator<UserCubit>().state.data != null &&
                            //           serviceLocator<UserCubit>()
                            //                   .state
                            //                   .data!
                            //                   .profilePicture !=
                            //               null
                            //       ? serviceLocator<UserCubit>()
                            //           .state
                            //           .data!
                            //           .profilePicture!
                            //       : 'assets/images/454545.png',
                            //   width: double.infinity,
                            //   fit: BoxFit
                            //       .cover, // Ensures the image covers full width
                            //   errorBuilder: (context, error, stackTrace) =>
                            //       Image.asset('assets/images/454545.png'),
                            // ),
                            ),
                      ),

                      /// White Bottom Section with Text
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 76, 71, 71),
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(12)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(
                                height: 22), // Space for the overlapping circle
                            Label(
                              text: context.isArabic
                                  ? 'إنشاء قصة'
                                  : 'Create\nStory',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),

                  /// "+" Button Positioned in Middle (Half on Image, Half on White Section)
                  const Positioned(
                    bottom: (kToolbarHeight * 0.8),
                    child: CircleAvatar(
                      radius: 22, // Slightly bigger to match Facebook UI
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 19,
                        backgroundColor: AppColors.PRIMARY_COLOR,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // const Sizer(),
          // if (UserCubit.to.isLoggedIn) _buildYourStory(context),
          // const Sizer(
          //   width: 8,
          // ),
          const Sizer(),
          SizedBox(
            height: kToolbarHeight * 2.5,
            child: BlocBuilder<StoryCubit, StoryState>(
              builder: (context, state) {
                return (state.users.isNotEmpty)
                    ? ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) =>
                            _buildOthersStories(context, state, 10),
                        separatorBuilder: (context, index) => const Sizer(
                              width: 8,
                            ),
                        itemCount: 10)
                    // : Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    //     child: Shimmer.fromColors(
                    //       baseColor: Colors.transparent,
                    //       highlightColor: Colors.grey.withOpacity(0.2),
                    //       child: Container(
                    //         color: Colors.grey,
                    //         height: kToolbarHeight * 2,
                    //         width: kToolbarHeight * 1.5,
                    //       ),
                    //     ),
                    //   );
                    : const SizedBox();
              },
            ),
          ),
          const Sizer(
            width: 8,
          ),
          BlocConsumer<StoryCubit, StoryState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state.mutedStoriesResponse != null &&
                  UserCubit.to.isLoggedIn) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemExtent: 112,
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                      ),
                      child: _buildMutedStories(context),
                    );
                  },
                );
              }
              return const SizedBox(
                height: 0,
                width: 0,
              );
            },
          ),
          const Sizer(
            width: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildOthersStories(BuildContext context, StoryState state, index) {
    final userController = StoryController();

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: GestureDetector(
        onTap: () async {
          ManageVibration.vibrate();
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: serviceLocator<StoryCubit>(),
                child: StoryViewScreen(
                  stories: state.users,
                  initialUserIndex: index,
                ),
              ),
            ),
          );
          // ignore: use_build_context_synchronously
          BlocProvider.of<StoryCubit>(context)
            ..fetchStories()
            ..getMutedStories();
        },
        child: Container(
          height: kToolbarHeight * 2.5,
          width: kToolbarHeight * 1.5,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: (state.users.isNotEmpty) &&
                  state.users[index].stories != null &&
                  (state.users[index].stories?.isNotEmpty ?? false)
              ? Stack(
                  children: [
                    Positioned.fill(
                      child: StoryView(
                          indicatorColor: Colors.transparent,
                          indicatorForegroundColor: Colors.transparent,
                          storyItems: [
                            state.users[index].stories?.first.type != 'video'
                                ? createStoryItem(
                                    context,
                                    state.users[index].stories!.first,
                                    userController)
                                : StoryItem.pageImage(
                                    loadingWidget:
                                        const CupertinoActivityIndicator(
                                      color: Colors.white,
                                    ),
                                    url: state.users[index].user
                                            ?.profilePictureUrl ??
                                        '',
                                    errorWidget: Image.network(
                                      UIConst.profilePlaceHolder,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    imageFit: BoxFit.fitHeight,
                                    controller: userController,
                                  )
                          ],
                          controller: userController),
                    ),
                    Positioned.fill(
                        child: Container(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(.1),
                    )),
                    Positioned.fill(
                        child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.SECONDARY_COLOR,
                            radius: 16,
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(state.users[index]
                                              .user!.profilePictureUrl !=
                                          null &&
                                      (state.users[index].user
                                              ?.profilePictureUrl?.isNotEmpty ??
                                          false)
                                  ? state.users[index].user!.profilePictureUrl!
                                  : UIConst.profilePlaceHolder),
                              onBackgroundImageError: (exception, stackTrace) =>
                                  const NetworkImage(
                                UIConst.profilePlaceHolder,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Label(
                                text: capitalizeAndSplit2Only(
                                    "${state.users[index].user!.firstName} ${state.users[index].user!.lastName}"),
                                textAlign: TextAlign.start,
                                style: Styles.mediumText(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    const Shadow(
                                      offset: Offset(1.0, 1.0),
                                      blurRadius: 8.0,
                                      color: Colors.black,
                                    ),
                                  ],
                                )),
                          )
                        ],
                      ),
                    ))
                  ],
                )
              : const Center(
                  child: CupertinoActivityIndicator(
                    color: Colors.black,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildYourStory(BuildContext context) {
    return Column(children: [
      Expanded(
          child: GestureDetector(
        onTap: () async {
          ManageVibration.vibrate();
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CameraScreen(),
            ),
          );

          // ignore: use_build_context_synchronously
          BlocProvider.of<StoryCubit>(context)
            ..fetchStories()
            ..getMutedStories();
        },
        child: Container(
          height: 74,
          width: 104,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0B1035), // Dark blue
                Color(0xFF202F9B), // Deep blue
              ],
            ),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                  child: Column(
                children: [
                  const Sizer(),
                  Expanded(
                    child: SvgPicture.asset(
                      Assets.createStory,
                      // ignore: deprecated_member_use
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Label(
                        text: context.isArabic
                            ? 'إضافة \n قصة'
                            : 'Create\nStory',
                        // Localized text
                        color: Theme.of(context).primaryColor,
                        // maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                    ],
                  )
                ],
              )),
              // const Positioned.fill(
              //     child: Center(
              //       child: CircleAvatar(
              //         radius: 18,
              //         backgroundColor: Colors.white,
              //         child: CircleAvatar(
              //           radius: 15,
              //           backgroundColor: AppColors.PRIMARY_COLOR,
              //           child: Icon(
              //             Icons.add,
              //             color: Colors.white,
              //           ),
              //         ),
              //       ),
              //     ))
            ],
          ),
        ),
      )),
      const Sizer(),
      Expanded(
          child: GestureDetector(
        onTap: () async {
          ManageVibration.vibrate();
          // await Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const CameraScreen(),
          //   ),
          // );
          //
          // BlocProvider.of<StoryCubit>(context)
          //   ..fetchStories()
          //   ..getMutedStories();
        },
        child: Container(
          height: 74,
          width: 104,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0B1035), // Dark blue
                Color(0xFFFF3308), // Deep blue
              ],
            ),
            borderRadius: BorderRadius.circular(6), // Add border radius
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color:
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.2), // Shadow color with opacity
                blurRadius: 8, // Spread of the shadow
                offset: const Offset(0, 4), // Position of the shadow (x, y)
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                  child: Column(
                children: [
                  // Expanded(
                  //   child: Image.network(
                  //     serviceLocator<UserCubit>().state.data != null &&
                  //         serviceLocator<UserCubit>()
                  //             .state
                  //             .data!
                  //             .profilePicture !=
                  //             null
                  //         ? serviceLocator<UserCubit>()
                  //         .state
                  //         .data!
                  //         .profilePicture!
                  //         : UIConst.profilePlaceHolder,
                  //     errorBuilder: (context, error, stackTrace) =>
                  //         Image.network(UIConst.imagePlaceHolder),
                  //   ),
                  // ),
                  const Sizer(),
                  Expanded(
                    child: SvgPicture.asset(
                      Assets.createReel,
                      // ignore: deprecated_member_use
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Label(
                        text:
                            context.isArabic ? 'إضافة\n ريل' : 'Create\n Reel',
                        // Localized text
                        color: Theme.of(context).primaryColor,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                    ],
                  )
                ],
              )),
              // const Positioned.fill(
              //     child: Center(
              //       child: CircleAvatar(
              //         radius: 18,
              //         backgroundColor: Colors.white,
              //         child: CircleAvatar(
              //           radius: 15,
              //           backgroundColor: AppColors.PRIMARY_COLOR,
              //           child: Icon(
              //             Icons.add,
              //             color: Colors.white,
              //           ),
              //         ),
              //       ),
              //     ))
            ],
          ),
        ),
      ))
    ]);
  }

  Widget _buildMutedStories(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12), // Facebook-like rounded edges
      child: GestureDetector(
        onTap: () async {
          ManageVibration.vibrate();
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: serviceLocator<StoryCubit>(),
                child: const MutedStories(),
              ),
            ),
          );

          // ignore: use_build_context_synchronously
          BlocProvider.of<StoryCubit>(context)
            ..fetchStories()
            ..getMutedStories();
        },
        child: Container(
          height: kToolbarHeight * 2, // Facebook Story Aspect Ratio
          width: 104, // Fixed width for consistency
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              /// **Full Background Image**
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  serviceLocator<UserCubit>().state.data != null &&
                          serviceLocator<UserCubit>()
                                  .state
                                  .data!
                                  .profilePicture !=
                              null
                      ? serviceLocator<UserCubit>().state.data!.profilePicture!
                      : 'assets/images/454545.png',
                  fit: BoxFit.cover,
                ),
              ),

              /// **Circular Profile Picture with Muted Icon (Top Left)**
              /// **Circular Profile Picture with White Border & Muted Icon**
              /// **Circular Profile Picture with White Border**
              Positioned(
                top: 8,
                right: 8,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    /// **Outer White Circle (Border)**
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                    ),

                    /// **Inner Profile Picture (28x28)**
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.grey.shade300, // Placeholder BG
                      backgroundImage: NetworkImage(
                        serviceLocator<UserCubit>().state.data != null &&
                                serviceLocator<UserCubit>()
                                        .state
                                        .data!
                                        .profilePicture !=
                                    null
                            ? serviceLocator<UserCubit>()
                                .state
                                .data!
                                .profilePicture!
                            : 'assets/images/454545.png',
                      ),
                    ),
                  ],
                ),
              ),

              /// **Muted Text (Bottom Center)**
              Positioned(
                bottom: 10,
                left: 6,
                right: 4,
                child: Label(
                  text: context.isArabic
                      ? ''
                      : serviceLocator<UserCubit>().state.data != null &&
                              serviceLocator<UserCubit>()
                                      .state
                                      .data!
                                      .profilePicture !=
                                  null
                          ? serviceLocator<UserCubit>().state.data!.fullName
                          : "",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// _buildMutedStories(BuildContext context) {
  //   return ClipRRect(
  //     borderRadius: BorderRadius.circular(5),
  //     child: GestureDetector(
  //       onTap: () async {
  //         await Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => BlocProvider.value(
  //               value: serviceLocator<StoryCubit>(),
  //               child: const MutedStories(),
  //             ),
  //           ),
  //         );
  //
  //         BlocProvider.of<StoryCubit>(context)
  //           ..fetchStories()
  //           ..getMutedStories();
  //       },
  //       child: Container(
  //         height: kToolbarHeight * 2,
  //         width: kToolbarHeight * 1.5,
  //         decoration: const BoxDecoration(
  //           color: Colors.black12,
  //         ),
  //         child: Stack(
  //           children: [
  //             const Positioned(
  //               top: 2,
  //               left: 2,
  //               child: Icon(Icons.notifications_off_outlined,
  //                   color: Colors.black54),
  //             ),
  //             Positioned(
  //               bottom: 4,
  //               left: 2,
  //               // right: 2,
  //               child: Label(
  //                 text: context.isArabic ? 'صامته' : 'Muted',
  //                 // Localized text
  //                 color: Theme.of(context).primaryColor,
  //                 maxLines: 1,
  //
  //                 style: Styles.mediumText(
  //                     color: Theme.of(context).primaryColor,
  //                     fontWeight: FontWeight.bold),
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
