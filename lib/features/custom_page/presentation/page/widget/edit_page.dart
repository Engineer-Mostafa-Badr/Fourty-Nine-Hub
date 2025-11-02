import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../cubit/edit_page_cubit/edit_page_cubit.dart';
import 'choose_catgories_view_body.dart';
import 'page_preview.dart';
import 'social_page.dart';
import '../../../../../res/style/app_colors.dart';

import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../helpers/manage_vibration.dart';
import 'custom_Page_categories.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  List<Widget> pages = const [
    // NavigateBar(),
    SocialPage(),
    FavouriteCategory(),
    ChooseCategoriesViwBody(),
    PagePreview(
      state: true,
    ),
  ];

  List<String> appBarTitle = [
    // LocaleKeys.navigateBar.localize,
    LocaleKeys.socialPage.localize,
    LocaleKeys.favoriteCategory.localize,
    LocaleKeys.chooseCategoryView.localize,
    LocaleKeys.pagePreview.localize,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditPageCubit>(
      create: (context) => EditPageCubit(),
      child: BlocBuilder<EditPageCubit, EditPageState>(
        builder: (context, state) {
          return CustomScaffold(
            enableCustomAppBar: true,
            // backgroundColor: Colors.transparent,
            appBar: BackAppBar(
              enableCustomAppBar: true,
              leading: Builder(builder: (context) {
                return IconButton(
                    onPressed: () {
                      ManageVibration.vibrate();
                      if (BlocProvider.of<EditPageCubit>(context)
                              .currentIndex >
                          0) {
                        BlocProvider.of<EditPageCubit>(context).changePage(
                            BlocProvider.of<EditPageCubit>(context)
                                    .currentIndex -
                                1);
                      } else {
                        log("index ${BlocProvider.of<EditPageCubit>(context).currentIndex}");

                        Navigator.of(context).pop();
                      }
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 40.w,
                      color: AppColors.getReversedTextColor(context),
                    ));
              }),
              label: appBarTitle[
                  BlocProvider.of<EditPageCubit>(context).currentIndex],
            ),
            body: pages[BlocProvider.of<EditPageCubit>(context).currentIndex],
          );
        },
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {super.key,
      required this.child,
      this.onPressed,
      this.borderRadius,
      this.backgoundColor});

  final Widget child;
  final void Function()? onPressed;
  final double? borderRadius;
  final Color? backgoundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ManageVibration.vibrate();
        onPressed?.call();
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: backgoundColor ?? AppColors.PRIMARY_COLOR,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 20))),
      child: child,
    );
  }
}
