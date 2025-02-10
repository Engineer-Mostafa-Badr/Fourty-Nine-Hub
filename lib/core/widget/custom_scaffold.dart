import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/stateless/labels/label.dart';
import '../../res/assets/assets.dart';
import '../../res/style/styles.dart';
import '../../routes/routes.dart';
import '../localization/locale_keys.g.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({
    super.key,
    required this.body,
    this.backgroundColor,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    this.drawer,
    this.bottomNavigationBar,
    this.appBar,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.bottomSheet,
    this.resizeToAvoidBottomInset,
  });

  final Widget body;
  final Color? backgroundColor;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool? resizeToAvoidBottomInset;
  final Widget? bottomSheet;

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  bool floatNavigator = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Scaffold(
          backgroundColor: widget.backgroundColor,
          floatingActionButtonLocation: widget.floatingActionButtonLocation,
          floatingActionButton: widget.floatingActionButton,
          drawer: widget.drawer,
          bottomNavigationBar: widget.bottomNavigationBar,
          body: widget.body,
          appBar: widget.appBar,
          extendBody: widget.extendBody,
          extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
          bottomSheet: widget.bottomSheet,
          resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        ),
        PositionedDirectional(
          start: 0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              floatNavigator
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.horizontal(
                          end: Radius.circular(60.r),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        child: Column(
                          spacing: 16.h,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            drawerRollWidget(
                              label: LocaleKeys.ride.localize,
                              image: Assets.rideIcon,
                              onTap: () => context.push(Routes.RIDE),
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.loading.localize,
                              image: Assets.loading,
                              onTap: () {},
                              // onTap: () => context.push(Routes.RIDE),
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.health.localize,
                              image: Assets.healthIcon,
                              onTap: () {},
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.meal.localize,
                              image: Assets.meal,
                              onTap: () {},
                              // onTap: () => context.push(Routes.RIDE),
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.find.localize,
                              image: Assets.find,
                              onTap: () {},
                              // onTap: () => context.push(Routes.),
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.reel.localize,
                              image: Assets.reel,
                              onTap: () => context.push(Routes.REELS),
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.spotlight.localize,
                              image: Assets.spotlight,
                              onTap: () => context.push(Routes.SPOTLIGHT),
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.meet.localize,
                              image: Assets.meet,
                              onTap: () => context.push(Routes.MEETINGROOM),
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.live.localize,
                              image: Assets.liveIcon,
                              onTap: () => context.push(Routes.LIVE),
                            ),
                            drawerRollWidget(
                              label: LocaleKeys.snap.localize,
                              image: Assets.snap,
                              onTap: () => context.push(Routes.SNAP),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    floatNavigator = !floatNavigator;
                    print('taped $floatNavigator');
                  });
                },
                child: Container(
                  // padding: EdgeInsets.all(50),
                  height: 100,
                  width: 15,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadiusDirectional.horizontal(
                      end: Radius.circular(20.r),
                    ),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 10)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget drawerRollWidget(
      {required String label,
      required String image,
      required void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            image,
            width: 40.h,
            height: 40.h,
            fit: BoxFit.cover,
          ),
          Label(
              text: label,
              style: Styles.mediumText(
                  fontWeight: FontWeight.w400, color: Colors.black)),
        ],
      ),
    );
  }
}
