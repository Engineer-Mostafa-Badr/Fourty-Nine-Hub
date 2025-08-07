import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/widget/custom_scaffold.dart';

import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../../../helpers/manage_vibration.dart';

class AddAboutScreen extends StatefulWidget {
  const AddAboutScreen({super.key, required this.currentBio});

  final String currentBio;

  @override
  State<AddAboutScreen> createState() => _AddAboutScreenState();
}

class _AddAboutScreenState extends State<AddAboutScreen> {
  late TextEditingController currentController;

  @override
  void initState() {
    currentController = TextEditingController(text: widget.currentBio);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> about = [
      {
        'key': currentController.text,
        'ar': currentController.text,
        'en': currentController.text,
      },
      {
        'key': 'available',
        'ar': 'متاح',
        'en': 'Available',
      },
      {
        'key': 'busy',
        'ar': 'مشغول',
        'en': 'Busy',
      },
      {
        'key': 'atSchool',
        'ar': 'في المدرسة',
        'en': 'At school',
      },
      {
        'key': 'atTheMovies',
        'ar': 'في السينما',
        'en': 'At the movies',
      },
      {
        'key': 'atWork',
        'ar': 'في العمل',
        'en': 'At work',
      },
      {
        'key': 'batteryAboutToDie',
        'ar': 'البطارية على وشك النفاد',
        'en': 'Battery about to die',
      },
      {
        'key': 'inAMeeting',
        'ar': 'في اجتماع',
        'en': 'In a meeting',
      },
      {
        'key': 'atTheGym',
        'ar': 'في النادي الرياضي',
        'en': 'At the gym',
      },
      {
        'key': 'sleeping',
        'ar': 'نائم',
        'en': 'Sleeping',
      },
      {
        'key': 'urgentCallsOnly',
        'ar': 'للمكالمات العاجلة فقط',
        'en': 'Urgent calls only',
      },
    ];
    /* List<String> aboutAr = [
      currentController.text,
      'Available',
      'Busy',
      'At school',
      'At the movies',
      'At work',
      'Battery about to die',
      'In a meeting',
      'At the gym',
      'Sleeping',
      'Urgent calls only',
    ];
    List<String> aboutEn = [
      currentController.text,
      'متاح',
      'مشغول',
      'في المدرسة',
      'في السينما',
      'في العمل',
      'البطارية على وشك النفاد',
      'في اجتماع',
      'في النادي الرياضي',
      'نائم',
      'للمكالمات العاجلة فقط',
    ];
*/
    return CustomScaffold(
      appBar: BackAppBar(label: LocaleKeys.about.localize),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(),
              Divider(
                thickness: 1,
                color: context.isDarkMode ? Colors.white12 : Colors.black12,
                height: 1,
              ),
              const Sizer(),
              Label(
                text: context.isArabic
                    ? 'تم ضبطه حاليًا على'
                    : 'currently set to',
                style: Styles.mediumText(
                  color: context.isDarkMode ? Colors.white54 : Colors.black54,
                ),
              ),
              const Sizer(),

              TextField(
                controller: currentController,
                decoration: InputDecoration(
                  hintText: context.isArabic ? 'الحاله' : 'About',
                  filled: false,
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder:
                      const OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      const OutlineInputBorder(borderSide: BorderSide.none),
                  suffixIcon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.SECONDARY_COLOR,
                  ),
                ),
                onSubmitted: (value) async {
                  await context.read<UserCubit>().updateUserBio(bio: value);
                  await context.read<UserCubit>().getUser();
                  setState(() {});
                },
              ),
              const Sizer(),

              Divider(
                thickness: 1,
                color: context.isDarkMode ? Colors.white12 : Colors.black12,
                height: 1,
              ),
              const Sizer(),

              Label(
                text: context.isArabic ? 'اختر حالتك' : 'select about',
                style: Styles.mediumText(
                  color: context.isDarkMode ? Colors.white54 : Colors.black54,
                ),
              ),
              const Sizer(),

              ...List.generate(
                about.length,
                (index) {
                  bool isArabic = context.isArabic;
                  final selectedText = isArabic ? about[index]['ar'] : about[index]['en'];
                  final currentText = currentController.text;

                  if ((index == 0 || selectedText != currentText)) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: InkWell(
                        onTap: () async {
      ManageVibration.vibrate();
                          currentController.text = selectedText;
                          await context.read<UserCubit>().updateUserBio(bio: selectedText);
                          await context.read<UserCubit>().getUser();
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Label(
                                text: selectedText!,
                                style: Styles.headerText(fontWeight: FontWeight.w400),
                              ),
                              if (selectedText == currentText)
                                const Icon(Icons.check, color: AppColors.SECONDARY_COLOR),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}