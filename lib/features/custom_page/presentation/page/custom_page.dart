import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/edit_page.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/page_preview.dart';

import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class CustomPage extends StatelessWidget {
  const CustomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: 'Custom Page',
      ),
      body: Column(
        children: [
          SwitchListTile(
            // secondary: Image.asset(
            //   Assets.theme,
            //   width: 50.h,
            //   height: 50.h,
            //   fit: BoxFit.cover,
            // ),
            title: Text(
              'Activate Page',
              style: Styles.mediumText(
                  fontSize: 65.sp, fontWeight: FontWeight.w400),
            ),
            value: false,
            activeColor: AppColors.SECONDARY_COLOR,
            activeTrackColor: AppColors.AUTH_CONTAINER_COLOR,
            inactiveTrackColor: AppColors.AUTH_CONTAINER_COLOR,
            onChanged: (value) {
              // if (theme is LightThemeModeStates) {
              //   ThemeCubit.get(context).darkThemeMode();
              // }
              // if (theme is DarkThemeModeStates) {
              //   ThemeCubit.get(context).lightThemeMode();
              // }
            },
          ),
          ListTile(
            // leading: Image.asset(
            //   image,
            //   width: 50.h,
            //   height: 50.h,
            // ),
            title: Label(
                text: 'Edit Page',
                style: Styles.mediumText(
                    fontSize: 65.sp, fontWeight: FontWeight.w400)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditPage(),
                ),
              );
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined, size: 40.h),
          ),
          ListTile(
            // leading: Image.asset(
            //   image,
            //   width: 50.h,
            //   height: 50.h,
            // ),
            title: Label(
                text: 'Page Preview',
                style: Styles.mediumText(
                    fontSize: 65.sp, fontWeight: FontWeight.w400)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PagePreview(),
                ),
              );
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined, size: 40.h),
          ),
        ],
      ),
    );
  }

  Widget listTileWidget(
      {required String image,
      required Widget trailing,
      required String label,
      required Function onTap}) {
    return ListTile(
      leading: Image.asset(
        image,
        width: 50.h,
        height: 50.h,
      ),
      title: Label(
          text: label,
          style:
              Styles.mediumText(fontSize: 65.sp, fontWeight: FontWeight.w400)),
      onTap: () => onTap(),
      trailing: trailing,
    );
  }
}
