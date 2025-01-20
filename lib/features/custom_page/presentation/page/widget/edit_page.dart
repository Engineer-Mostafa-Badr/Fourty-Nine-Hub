import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/custom_page.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/navigate_bar.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/social_page.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';
import 'favourite_category.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  List<Widget> pages = const [
    NavigateBar(),
    SocialPage(),
    FavouriteCategory(),
  ];
  late PageController pageController;
  int currentIndex = 0;
  @override
  initState() {
    pageController = PageController();

    pageController.addListener(() {
      currentIndex = pageController.page!.round();

      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.editPage.localize,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return pages[index];
                }),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: currentIndex != 0,
                  child: CustomElevatedButton(
                    onPressed: () {
                      pageController.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn);
                    },
                    child: Text(LocaleKeys.previus.localize,
                        style: Styles.mediumText(color: Colors.white)),
                  ),
                ),
                CustomElevatedButton(
                  onPressed: () {
                    if (currentIndex != pages.length - 1) {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn);
                    } else {
                      AlertDialog alert = AlertDialog(
                        title: Text(LocaleKeys.doYouWantToActivePage.localize),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ActivatePageBlocConsumer(),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: CustomElevatedButton(
                                  child: Text(
                                    LocaleKeys.finish.localize,
                                    style:
                                        TextStyle(color: AppColors.whiteColor),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }),
                            ),
                          ],
                        ),
                        actions: [],
                      );
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    }
                  },
                  child: Text(
                      currentIndex != pages.length - 1
                          ? LocaleKeys.next.localize
                          : LocaleKeys.finish.localize,
                      style: Styles.mediumText(color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          // ListTile(
          //   title: Label(
          //       text: LocaleKeys.navigateBar.localize,
          //       style: Styles.mediumText(
          //           fontSize: 65.sp, fontWeight: FontWeight.w400)),
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => const NavigateBar()));
          //   },
          //   trailing: Icon(Icons.arrow_forward_ios_outlined, size: 40.h),
          // ),
          // ListTile(
          //   title: Label(
          //       text: LocaleKeys.socialPage.localize,
          //       style: Styles.mediumText(
          //           fontSize: 65.sp, fontWeight: FontWeight.w400)),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const SocialPage(),
          //       ),
          //     );
          //   },
          //   trailing: Icon(Icons.arrow_forward_ios_outlined, size: 40.h),
          // ),
          // ListTile(
          //   title: Label(
          //       text: LocaleKeys.favoriteCategory.localize,
          //       style: Styles.mediumText(
          //           fontSize: 65.sp, fontWeight: FontWeight.w400)),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const FavouriteCategory(),
          //       ),
          //     );
          //   },
          //   trailing: Icon(Icons.arrow_forward_ios_outlined, size: 40.h),
          // ),
          // ListTile(
          //   title: Label(
          //       text: LocaleKeys.subTab.localize,
          //       style: Styles.mediumText(
          //           fontSize: 65.sp, fontWeight: FontWeight.w400)),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const SubTab(),
          //       ),
          //     );
          //   },
          //   trailing: Icon(Icons.arrow_forward_ios_outlined, size: 40.h),
          // ),
        ],
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({super.key, required this.child, this.onPressed});
  final Widget child;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.PRIMARY_COLOR),
      child: child,
    );
  }
}
