import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/clickable_widget.dart';
import 'add_friends_view.dart';
import '../widgets/posts_grid.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../helpers/manage_vibration.dart';

class SpotLightProfileScreen extends StatelessWidget {
  const SpotLightProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.topCenter,
            fit: BoxFit.fitWidth,
            image: AssetImage(Assets.spotlight_profile),
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(iconTheme: IconThemeData(
              color: Colors.black
            ),
              expandedHeight: MediaQuery.of(context).size.height * 0.42,
              pinned: false,
              backgroundColor: Colors.transparent,
              actions: [
                ClickableWidget(
                  child: const Icon(Icons.camera_alt, color: Colors.black),
                  onTap: () {

      ManageVibration.vibrate();
                  },
                ),
                const Sizer(
                  width: 30,
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: SizedBox(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // const Align(
                      //   alignment: Alignment.topLeft,
                      //   child: SafeArea(
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(
                      //           horizontal: 12.0, vertical: 10),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           // ClickableWidget(
                      //           //   child: const Icon(Icons.camera_alt,
                      //           //       color: Colors.black),
                      //           //   onTap: () {},
                      //           // ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Positioned(
                          bottom: 30.h,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0.h),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Esraa Khlifah",
                                    style: Styles.headerText(
                                      color: Colors.white,
                                      fontSize: 54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "esraakhlifah",
                                    style: Styles.headerText(
                                      color: Color(0xFFA0B7B0),
                                    ),
                                  ),
                                ]),
                          ))
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                // height: MediaQuery.of(context).size.height,
                decoration:  BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  // color:context.isDarkMode?AppColors.QUANTITY_COLOR:Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Sizer(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              infoButton(context,'🎈', "Apr 2", Colors.red),
                              const Sizer(),
                              infoButton(context,null, "3", Colors.grey.shade300),
                              const Sizer(),
                              infoButton(context,'♈', "Aries", Colors.purple.shade200),
                            ],
                          ),
                          const Sizer(),
                          Text(LocaleKeys.friends.localize,
                              style: Styles.headerText(
                                  fontSize: 48, fontWeight: FontWeight.bold)),
                          const Sizer(),
                          profileTile(context,Icons.person_add_alt_outlined,
                              context.isArabic ? 'اضف اصدقاء' : "Add Friends",
                              onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddFriendsScreen(),
                                    ),
                                  )),
                          const Sizer(),
                          profileTile(context,Icons.groups_rounded,
                              context.isArabic ? 'اصدقائي' : "My Friends"),
                        ],
                      ),
                    ),
                    const Sizer(
                      height: 30,
                    ),
                    const PostsGrid(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoButton(BuildContext context,String? icon, String text, Color color) {
    return Container(
      width: 152.h,
      height: 80.h,
      //padding: const EdgeInsets.symmetric( vertical: 8),
      decoration: BoxDecoration(
        color: context.isDarkMode?AppColors.SPLASH_BLACK_COLOR:Colors.transparent,
        border: Border.all(
          color: const Color(0xFF333231),
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Text(icon,
                  style: Styles.mediumText(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  )),
              Sizer(width: 10.h),
            ],
            Text(text,
                style: Styles.mediumText(
                    fontWeight: FontWeight.w700,
                    fontSize: icon == null ? 34 : 24,
                    color: const Color(0xFF6A6A6A))),
          ],
        ),
      ),
    );
  }

  Widget profileTile(BuildContext context,IconData icon, String text, {void Function()? onTap}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.h),
      decoration: BoxDecoration(
        color:context.isDarkMode?AppColors.SPLASH_BLACK_COLOR:Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(2, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon),
        title: Text(text),
        trailing: Icon(Icons.arrow_forward_ios, size: 32.h),
        onTap: onTap,
      ),
    );
  }
}