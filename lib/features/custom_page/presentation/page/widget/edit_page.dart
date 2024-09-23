import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/navigate_bar.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/social_page.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/sub_tab.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';
import 'favourite_category.dart';

class EditPage extends StatelessWidget {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: 'Edit Page',
      ),
      body: Column(
        children: [
          ListTile(
            title: Label(
                text: 'Navigate Bar',
                style: Styles.mediumText(
                    fontSize: 65.sp, fontWeight: FontWeight.w400)),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NavigateBar()));
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined, size: 40.h),
          ),
          ListTile(
            title: Label(
                text: 'Social Page',
                style: Styles.mediumText(
                    fontSize: 65.sp, fontWeight: FontWeight.w400)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SocialPage(),
                ),
              );
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined, size: 40.h),
          ),
          ListTile(
            title: Label(
                text: 'Favorite Category',
                style: Styles.mediumText(
                    fontSize: 65.sp, fontWeight: FontWeight.w400)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavouriteCategory(),
                ),
              );
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined, size: 40.h),
          ),
          ListTile(
            title: Label(
                text: 'Sub Tab',
                style: Styles.mediumText(
                    fontSize: 65.sp, fontWeight: FontWeight.w400)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SubTab(),
                ),
              );
            },
            trailing: Icon(Icons.arrow_forward_ios_outlined, size: 40.h),
          ),
        ],
      ),
    );
  }
}
