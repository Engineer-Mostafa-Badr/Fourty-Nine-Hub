import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/utils/custom_show_dialog.dart';
import '../cubit/custom_page_cubit.dart';
import '../cubit/custom_page_states.dart';
import 'widget/edit_page.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../../../../service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:restart_app/restart_app.dart';

import '../../../../core/widget/custom_scaffold.dart';
import '../../../../core/widget/custom_switch_button.dart';
import '../../../../helpers/manage_vibration.dart';

class CustomPage extends StatefulWidget {
  const CustomPage({super.key});

  @override
  State<CustomPage> createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: LocaleKeys.customPage.localize,
        ),
      ),
      //  drawer: const DrawerWidget(),
      body: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) => serviceLocator()..fetchActivate(),
        child: BlocConsumer<CustomPageCubit, CustomPageState>(
          listener: (BuildContext context, CustomPageState state) {
            if (state.status == CustomPageStates.updateSuccess) {
              if (state.activate!.customPage == true) {
                context.pushReplacementNamed(Routes.CUSTOMPAGE);
              } else {
                context.pushReplacementNamed(Routes.HOME);
              }
              print('''''' '''''' '''object''' '''''' '''''');
            }
          },
          builder: (BuildContext context, state) {
            var controller = context.read<CustomPageCubit>();
            return Column(
              children: [
                const ActivatePageBlocConsumer(),
                ListTile(
                  title: Label(
                      text: LocaleKeys.editPage.localize,
                      style: Styles.mediumText(
                          fontSize: 65.sp, fontWeight: FontWeight.w400)),
                  onTap: () {
                    ManageVibration.vibrate();
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
                  title: Label(
                      text: LocaleKeys.pagePreview.localize,
                      style: Styles.mediumText(
                          fontSize: 65.sp, fontWeight: FontWeight.w400)),
                  onTap: () {
                    ManageVibration.vibrate();
                    context.push(Routes.PAGEPREVIEW,
                        extra: state.activate?.customPage == true);
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
}

class ActivatePageBlocConsumer extends StatelessWidget {
  const ActivatePageBlocConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomPageCubit, CustomPageState>(
      listener: (context, state) {
        if (state.status == CustomPageStates.updateSuccess) {
          if (state.activate!.customPage == true) {
            context.pushReplacementNamed(Routes.CUSTOMPAGE);
          } else {
            context.pushReplacementNamed(Routes.HOME);
          }
          print('''''' '''''' '''object''' '''''' '''''');
        }
      },
      builder: (context, state) {
        var controller = context.read<CustomPageCubit>();

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Row(
            children: [
              Expanded(
                  child: Label(
                      text: LocaleKeys.activatePage.localize,
                      style: Styles.mediumText(
                          fontSize: 65.sp, fontWeight: FontWeight.w400))),
              CustomSwitchButton(
                value: state.activate?.customPage ?? false,
                onChanged: (v) {
                  showAnimatedDialog(
                    context,
                    AlertDialog(
                      title: Label(
                        text: context.isArabic
                            ? LocaleKeys.restartToApply.localize
                            : 'Restart to Apply',
                        style: Styles.mediumText(
                            fontSize: 65.sp, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        AppButton(
                          onPressed: () {
                            ManageVibration.vibrate();
                            controller.updateActivate(v);
                            Restart.restartApp();
                          },
                          label: LocaleKeys.restart.localize,
                          color: AppColors.getReversedTextColor(context),
                          backColor: AppColors.getButtonPrimaryColor(context),
                        ),
                        Sizer(),
                        AppButton(
                          onPressed: () {
                            ManageVibration.vibrate();
                            Navigator.pop(context);
                          },
                          label: LocaleKeys.cancel.localize,
                        ),
                      ],
                      backgroundColor: AppColors.getFindFillColor(context),
                      alignment: Alignment.center,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
