import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/custom_show_dialog.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_states.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/edit_page.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:restart_app/restart_app.dart';

import '../../../../core/widget/custom_scaffold.dart';
import '../../../../core/widget/custom_switch_button.dart';

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
                          text: 'The App will Restart to Apply Changes',
                          style: Styles.mediumText(
                              fontSize: 65.sp, fontWeight: FontWeight.w400)),
                      actions: [
                        AppButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            label: LocaleKeys.cancel.localize,
                        ),
                        AppButton(
                          onPressed: () {
                            controller.updateActivate(v);
                            Restart.restartApp();
                          },
                          label: 'Restart',
                        ),
                      ],
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
