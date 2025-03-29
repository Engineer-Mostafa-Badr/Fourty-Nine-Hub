import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/edit_page_cubit/edit_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/choose_catgories_view_body.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/navigate_bar.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/page_preview.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/social_page.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../core/widget/custom_scaffold.dart';
import 'custom_Page_categories.dart';

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
    ChooseCategoriesViwBody(),
    PagePreview(
      state: true,
    ),
  ];

  List<String> appBarTitle = [
    LocaleKeys.navigateBar.localize,
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
                      if (BlocProvider.of<EditPageCubit>(context).currentIndex >
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
                      color: Colors.white,
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
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: backgoundColor ?? AppColors.PRIMARY_COLOR,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 20))),
      child: child,
    );
  }
}
