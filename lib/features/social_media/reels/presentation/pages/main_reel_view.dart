import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/recording/recording_shared.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/reel_items.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';

class ReelView extends StatelessWidget {
  const ReelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => serviceLocator<ReelsCubit>(),
          ),
          BlocProvider(
            create: (context) => serviceLocator<UserCubit>(),
          )
        ],
        child: const ReelsScreen(),
      ),
    );
  }
}

void showSnackBarAfterBuild(
  BuildContext context, {
  required String message,
  String? actionLabel,
  VoidCallback? onActionPressed,
  IconData? icon,
  Color backgroundColor = Colors.black,
  Color textColor = Colors.red,
  Color actionTextColor = Colors.blue,
  Duration duration = const Duration(seconds: 1),
}) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Expanded(
          child: Text(
            message, textScaleFactor: 1.0, // Disable font scaling

            style: TextStyle(
                color: textColor, fontSize: 30.sp, fontWeight: FontWeight.w700),
          ),
        ),
        if (icon != null) ...[
          Icon(
            icon,
            color: Colors.green,
            size: 50.h,
          ),
          const SizedBox(width: 12),
        ],
      ],
    ),
    backgroundColor: backgroundColor,
    duration: duration,
    action: actionLabel != null
        ? SnackBarAction(
            label: actionLabel,
            onPressed: onActionPressed ?? () {},
            textColor: actionTextColor,
          )
        : null,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    margin: const EdgeInsets.all(16),
    elevation: 10,
  );
  SchedulerBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  });
}

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  ReelsScreenState createState() => ReelsScreenState();
}

class ReelsScreenState extends State<ReelsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchInitialReels();
  }

  void _fetchInitialReels() {
    if (mounted) {
      context.read<ReelsCubit>().fetchReels();
    }
  }

  // Widget _buildAppBar(BuildContext context) {
  //   return SizedBox(
  //     width: context.screenWidth,
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Stack(
  //                 children: [
  //                   IconButton(
  //                     icon: FaIcon(
  //                       Icons.arrow_back,
  //                       color: Colors.white,
  //                       size: 40.h,
  //                     ),
  //                     color: Colors.white,
  //                     onPressed: () => context.pop(),
  //                   ),
  //                   IconButton(
  //                     icon: FaIcon(
  //                       Icons.arrow_back,
  //                       color: AppColors.PRIMARY_COLOR.withOpacity(0.5),
  //                       size: 40.h,
  //                     ),
  //                     color: Colors.white,
  //                     onPressed: () => context.pop(),
  //                   ),
  //                 ],
  //               ),
  //               Expanded(child: Container()),
  //             ],
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [
  //               //live
  //               Stack(
  //                 children: [
  //                   IconButton(
  //                     icon: SvgPicture.asset(
  //                       'assets/images/live_icon.svg',
  //                       height: 50.w,
  //                       width: 50.w,
  //                       color: AppColors.PRIMARY_COLOR.withOpacity(0.5),
  //                     ),
  //                     onPressed: () {
  //                       context.push(Routes.LIVE);
  //                     },
  //                   ),
  //                   IconButton(
  //                     icon: SvgPicture.asset(
  //                       'assets/images/live_icon.svg',
  //                       height: 50.w,
  //                       width: 50.w,
  //                     ),
  //                     color: Colors.white,
  //                     onPressed: () {
  //                       context.push(Routes.LIVE);
  //                     },
  //                   ),
  //                 ],
  //               ),
  //               const Sizer(),
  //               const Sizer(),
  //
  //               //tinder
  //
  //               //spotlight
  //               Stack(
  //                 children: [
  //                   IconButton(
  //                     icon: Label(
  //                       text: 'Spotlight',
  //                       style: Styles.mediumText(
  //                           decoration: TextDecoration.underline,
  //                           color: AppColors.PRIMARY_COLOR.withOpacity(0.5),
  //                           fontWeight: FontWeight.bold),
  //                     ),
  //                     color: Colors.white,
  //                     onPressed: () {
  //                       context.push(Routes.SPOTLIGHT);
  //                     },
  //                   ),
  //                   Positioned(
  //                     top: -1,
  //                     right: -1,
  //                     left: -1,
  //                     child: IconButton(
  //                       icon: Label(
  //                         text: 'Spotlight',
  //                         style: Styles.mediumText(
  //                             fontWeight: FontWeight.bold,
  //                             decoration: TextDecoration.underline,
  //                             color: Colors.white),
  //                       ),
  //                       color: Colors.white,
  //                       onPressed: () {
  //                         context.push(Routes.SPOTLIGHT);
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               Stack(
  //                 children: [
  //                   IconButton(
  //                     icon: Label(
  //                       text: 'Snap',
  //                       style: Styles.mediumText(
  //                           decoration: TextDecoration.underline,
  //                           color: AppColors.PRIMARY_COLOR.withOpacity(0.5),
  //                           fontWeight: FontWeight.bold),
  //                     ),
  //                     color: Colors.white,
  //                     onPressed: () {
  //                       context.push(Routes.SNAP);
  //                     },
  //                   ),
  //                   Positioned(
  //                     top: -1,
  //                     right: -1,
  //                     left: -1,
  //                     child: IconButton(
  //                       icon: Label(
  //                         text: 'Snap',
  //                         style: Styles.mediumText(
  //                             decoration: TextDecoration.underline,
  //                             color: Colors.white,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                       color: Colors.white,
  //                       onPressed: () {
  //                         context.push(Routes.SNAP);
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               //reels
  //               Stack(
  //                 children: [
  //                   IconButton(
  //                     icon: Label(
  //                       text: 'Reels',
  //                       style: Styles.mediumText(
  //                           decoration: TextDecoration.underline,
  //                           color: AppColors.PRIMARY_COLOR.withOpacity(0.5),
  //                           fontWeight: FontWeight.bold),
  //                     ),
  //                     color: Colors.white,
  //                     onPressed: () async {
  //                       // context.pop();
  //                       await Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                             builder: (context) => const ReelsRecordingScreen(
  //                                 // advertisementType: 'reel',
  //                                 // comeFromCompany: 'company',
  //                                 // totalPrice: '500',
  //                                 ),
  //                           ));
  //                     },
  //                   ),
  //                   Positioned(
  //                     top: -1,
  //                     right: -1,
  //                     left: -1,
  //                     child: IconButton(
  //                       icon: Label(
  //                         text: 'Reels',
  //                         style: Styles.mediumText(
  //                             decoration: TextDecoration.underline,
  //                             color: Colors.white,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                       color: Colors.white,
  //                       onPressed: () async {
  //                         // context.pop();
  //                         await Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder: (context) =>
  //                                   const ReelsRecordingScreen(
  //                                       // advertisementType: 'reel',
  //                                       // comeFromCompany: 'company',
  //                                       // totalPrice: '500',
  //                                       ),
  //                             ));
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const Sizer(),
  //               const Sizer(),
  //               Stack(
  //                 children: [
  //                   IconButton(
  //                     onPressed: () async {
  //                       context.push(Routes.Tinder);
  //                     },
  //                     icon: FaIcon(
  //                       FontAwesomeIcons.search,
  //                       color: Colors.white,
  //                       size: 35.h,
  //                     ),
  //                   ),
  //                   IconButton(
  //                     onPressed: () async {
  //                       context.push(Routes.Tinder);
  //                     },
  //                     icon: FaIcon(
  //                       FontAwesomeIcons.search,
  //                       color: AppColors.PRIMARY_COLOR.withOpacity(0.4),
  //                       size: 35.h,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [
          //     Colors.deepPurpleAccent,
          //     Colors.blueAccent,
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button Row
          Row(
            children: [
              _buildGradientIconButton(
                iconData: Icons.arrow_back,
                onPressed: () => context.pop(),
              ),
              Expanded(child: Container()),
            ],
          ),
          const SizedBox(height: 10),
          // Buttons Row
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Live Button
                _buildGradientSvgButton(
                  assetName: 'assets/images/live_icon.svg',
                  onPressed: () => context.push(Routes.LIVE),
                ),
                const Sizer(),
                // Spotlight Button
                _buildGradientTextButton(
                  text: 'Spotlight',
                  onPressed: () => context.push(Routes.SPOTLIGHT),
                ),const Sizer(),
                // Snap Button
                _buildGradientTextButton(
                  text: 'Snap',
                  onPressed: () => context.push(Routes.SNAP),
                ),const Sizer(),
                // Reels Button
                _buildGradientTextButton(
                  text: 'Reels',
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReelsRecordingScreen(),
                      ),
                    );
                  },
                ),const Sizer(),
                // Search Button
                _buildGradientIconButton(
                  iconData: FontAwesomeIcons.search,
                  onPressed: () => context.push(Routes.Tinder),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

// Helper method for gradient icon buttons
  Widget _buildGradientIconButton(
      {required IconData iconData, required VoidCallback onPressed}) {
    return Container(
      height: 60.h,
      decoration: _buttonDecoration(),
      child: IconButton(
        icon: FittedBox(
          child: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

// Helper method for gradient SVG buttons
  Widget _buildGradientSvgButton(
      {required String assetName, required VoidCallback onPressed}) {
    return Container(
      height: 60.h,
      decoration: _buttonDecoration(),
      child: IconButton(
        icon: SvgPicture.asset(
          assetName,
          fit: BoxFit.fitHeight,
        ),
        onPressed: onPressed,
      ),
    );
  }

// Helper method for gradient text buttons
  Widget _buildGradientTextButton(
      {required String text, required VoidCallback onPressed}) {
    return Container(
      height: 60.h,
      decoration: _buttonDecoration(),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: Styles.mediumText(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

// Button decoration with gradient and rounded corners
  BoxDecoration _buttonDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Colors.white10,
          Colors.black12,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        const BoxShadow(
          color: Colors.black26,
          blurRadius: 2,
          offset: Offset(0, 2),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReelsCubit, ReelsState>(
      builder: (context, state) {
        // if ((state.globalReels.isEmpty)) {
        //   return const Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }
        // if (!serviceLocator<UserCubit>().isLoggedIn) {
        //   return pleaseLoginWidget(context);
        // }
        return Stack(
          children: [
            Positioned.fill(
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: state.globalReels.length +
                    (state.globalReelsHasReachedMax ? 0 : 1),
                onPageChanged: _handlePageChange,
                itemBuilder: (context, index) {
                  if (index >= state.globalReels.length) {
                    return const Center(
                      child: CupertinoActivityIndicator(radius: 25),
                    );
                  }
                  return UnifiedReelItem(
                    reel: state.globalReels[index],
                    isVisible: true,
                    itemType: ReelItemType.main,
                  );
                  //   MainReelItem(
                  //   reel: state.globalReels[index],
                  //   fromSpotlight: false,
                  //   isVisible: _currentPage == index,
                  // );
                },
              ),
            ),
            Positioned(
              top: 20,
              child: _buildAppBar(context),
            ),
          ],
        );
      },
    );
  }

  void _handlePageChange(int index) {
    setState(() => _currentPage = index);
    final reelsCubit = context.read<ReelsCubit>();
    if (index == reelsCubit.state.globalReels.length - 1 && mounted) {
      reelsCubit.fetchReels();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// class ScrollingText extends StatefulWidget {
//   final String text;
//
//   const ScrollingText({super.key, required this.text});
//
//   @override
//   ScrollingTextState createState() => ScrollingTextState();
// }
//
// class ScrollingTextState extends State<ScrollingText>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       duration: const Duration(seconds: 10),
//       vsync: this,
//     )..repeat(reverse: false);
//
//     _animation = Tween<double>(begin: -1.0, end: 1.0).animate(_controller);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double textSize = screenWidth * 0.03;
//
//     return ClipRect(
//       child: Container(
//         alignment: Alignment.centerLeft,
//         child: AnimatedBuilder(
//           animation: _animation,
//           builder: (context, child) {
//             return FractionalTranslation(
//               translation: Offset(_animation.value, 0),
//               child: child,
//             );
//           },
//           child: Text(
//             widget.text,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               fontSize: textSize,
//               color: AppColors.UNSELECTED_GRAY_COLOR,
//               decoration: TextDecoration.none,
//               shadows: [
//                 const Shadow(
//                   offset: Offset(1.0, 1.0),
//                   blurRadius: 4.0,
//                   color: Colors.black,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class RoundedButtonWithImage extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  const RoundedButtonWithImage({
    super.key,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 100,
        height: 50,
        child: FittedBox(
          child: ElevatedButton.icon(
              onPressed: onPressed,
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Colors.blueGrey.withOpacity(0.2))),
              icon: const Icon(
                FontAwesomeIcons.music,
                color: Colors.white,
              ),
              label: const Text(
                'Audio',
                style: TextStyle(color: Colors.white),
              )),
        )
        // ElevatedButton(
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: Colors.transparent,
        //     shadowColor: Colors.transparent,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(12),
        //       side: const BorderSide(color: Colors.white, width: 1),
        //     ),
        //     padding: EdgeInsets.zero,
        //   ),
        //   onPressed: ,
        //   child: ClipRRect(
        //     borderRadius: BorderRadius.circular(12),
        //     child: Stack(
        //       children: [
        //         Image.network(
        //           width: double.infinity,
        //           height: double.infinity,
        //           imagePath,
        //           fit: BoxFit.fill,
        //         ),
        //         const Positioned(
        //           bottom: 4,
        //           right: 4,
        //           child: Center(
        //             child: FaIcon(
        //               FontAwesomeIcons.music,
        //               size: 15,
        //               color: Colors.white,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}
