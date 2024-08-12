import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/translations/translation_cubit.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/zoom_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/zoom_state.dart';
import 'package:fourtyninehub/features/zoom/presentation/widgets/meeting_dialogue.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/labels/label.dart';

import '../../../../common/widgets/dynamic/drawer.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';

class MeetingView extends StatelessWidget {
  const MeetingView({super.key});

  @override
  Widget build(BuildContext context) {
    // init signalling service

    return Scaffold(
      backgroundColor: AppColors.GRAY_LIGHT_COLOR3,
      appBar: const HomeAppbar(
        isWithBackArrow: true,
      ),
      drawer: const DrawerWidget(),
      body: BlocBuilder<MeetingCubit, MeetingState>(
        builder: (context, state) {
          var cubit = context.read<MeetingCubit>();
          return Column(
            children: [
              ElevatedButton(
                style: context.theme.elevatedButtonTheme.style!.copyWith(
                  backgroundColor: MaterialStatePropertyAll(
                   context.themeMode==ThemeMode.light? Colors.green:Colors.yellow,
                  ),
                ),
                onPressed: () {
                  context
                      .read<TranslationCubit>()
                      .changeLanguage(const Locale('en'), context);
                },
                child: const Text('english').tr(),
              ),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<TranslationCubit>()
                      .changeLanguage(const Locale('ar'), context);
                },
                child: const Text('arabic').tr(),
              ),
              BlocBuilder<ThemeCubit,ThemeStates>(
                builder: (BuildContext context, theme) {
                  return SwitchListTile(
                    title: theme is DarkThemeModeStates?Text('dark mode'.localize): Text('light mode'.localize),
                    value: ThemeCubit.get(context).isDarkTheme,
                    onChanged: (value){
                      if(theme is LightThemeModeStates){
                        ThemeCubit.get(context).darkThemeMode();
                      } if(theme is DarkThemeModeStates){
                        ThemeCubit.get(context).lightThemeMode();
                      }
                    },
                  );
                },
              ),
              SizedBox(
                height: 200,
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    crossAxisCount: 2,
                  ),
                  children: [
                    _buildMeetingItem(
                      color: AppColors.ACCENT_COLOR,
                      label: 'new_meeting'.tr(),
                      icon: Icons.video_call,
                      onTap: () async {
                        await newMeeting(cubit);
                        if (context.mounted) {
                          context.push(
                            Routes.MEETINGROOM,
                            extra: ZegoArgs(genRandNo, true),
                          );
                        }
                      },
                    ),
                    _buildMeetingItem(
                        color: AppColors.PRIMARY_COLOR,
                        label: 'join'.tr(),
                        icon: Icons.add_box_rounded,
                        onTap: () {
                          // join meeting
                          showMeetingDialogue(context);
                        }),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> newMeeting(MeetingCubit cubit) async {
    cubit.addRoom(genRandNo);
  }

  Widget _buildMeetingItem(
      {required Color color,
        required String label,
        required IconData icon,
        required Function onTap}) {
    return InkWell(
      onTap: () => onTap(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: color),
            child: Icon(
              icon,
              color: Colors.white,
              size: 35,
            ),
          ),
          const Sizer(),
          Label(text: label, style: Styles.headerText(fontSize: 13))
        ],
      ),
    );
  }
}
