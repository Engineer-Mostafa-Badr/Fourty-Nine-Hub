import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/reel_items.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          ),
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
            message,
            textScaler: TextScaler.noScaling,
            style: TextStyle(
              color: textColor,
              fontSize: 30.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (icon != null)
          Icon(
            icon,
            color: Colors.green,
            size: 50.h,
          ),
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

class ReelsScreenState extends State<ReelsScreen>
    with AutomaticKeepAliveClientMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  bool get wantKeepAlive => true;

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ReelsCubit, ReelsState>(
      builder: (context, state) {
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
                    isVisible: _currentPage == index,
                    itemType: ReelItemType.main,
                  );
                },
              ),
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
              Colors.blueGrey.withOpacity(0.2),
            ),
          ),
          icon: const Icon(
            FontAwesomeIcons.music,
            color: Colors.white,
          ),
          label: const Text(
            'Audio',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
