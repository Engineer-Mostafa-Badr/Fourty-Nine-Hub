import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_states.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/edit_page.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/page_preview.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class CustomPage extends StatefulWidget {
  const CustomPage({super.key});

  @override
  State<CustomPage> createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.customPage.localize,
      ),
      body: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) =>serviceLocator()..fetchActivate(),
        child: BlocBuilder<CustomPageCubit,CustomPageState>(
          builder: (BuildContext context, state) {
            var controller=context.read<CustomPageCubit>();
            return Column(
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 25.w),
                  child: Row(
                    children: [
                      Expanded(
                          child: Label(
                            text: LocaleKeys.activatePage.localize,
                              style: Styles.mediumText(
                                  fontSize: 65.sp, fontWeight: FontWeight.w400)
                          )),
                      Switch(
                        value: state.activate?.customPage ??false,
                        onChanged: (v){
                          controller.updateActivate(v);
                        },
                        activeColor: Colors.red,
                        inactiveThumbColor: Colors.black,
                        activeTrackColor: AppColors.GREY_NORMAL_COLOR,
                        inactiveTrackColor: AppColors.GREY_NORMAL_COLOR,
                      ),
                    ],
                  ),
                ),
                // SwitchListTile(
                //   title: Text(
                //     LocaleKeys.activatePage.localize,
                //     style: Styles.mediumText(
                //       fontSize: 65.sp,
                //       fontWeight: FontWeight.w400,
                //     ),
                //   ),
                //   value: state.activate?.customPage ??false, // Set the value dynamically
                //   activeColor: AppColors.SECONDARY_COLOR,
                //   activeTrackColor: AppColors.SECONDARY_COLOR,
                //   inactiveTrackColor: AppColors.SECONDARY_COLOR,
                //   onChanged: (value) {
                //     controller.updateActivate(value);
                //     setState(() {
                //
                //     });
                //   },
                // ),
                ListTile(
                  // leading: Image.asset(
                  //   image,
                  //   width: 50.h,
                  //   height: 50.h,
                  // ),
                  title: Label(
                      text: LocaleKeys.editPage.localize,
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
                      text: LocaleKeys.pagePreview.localize,
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
            );
          },
        ),
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
