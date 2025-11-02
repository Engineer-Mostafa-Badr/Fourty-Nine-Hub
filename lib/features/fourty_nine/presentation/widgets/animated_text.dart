import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/widget/clickable_widget.dart';
import '../controllers/main_categories_cubit/main_categories_cubit.dart';
import '../../../../helpers/manage_vibration.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import 'package:auto_scroll_text/auto_scroll_text.dart';

import '../../../../core/utils/custom_show_dialog.dart';

class ScrollableTextWithAnimation extends StatefulWidget {
  const ScrollableTextWithAnimation({super.key, this.textDirection});

  final TextDirection? textDirection;

  @override
  State<ScrollableTextWithAnimation> createState() =>
      _ScrollableTextWithAnimationState();
}

class _ScrollableTextWithAnimationState
    extends State<ScrollableTextWithAnimation> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  initState(){
    // context.read<MainCategoriesCubit>().getQuestion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCategoriesCubit, MainCategoriesState>(
      builder: (BuildContext context, state) {
        var cubit = context.read<MainCategoriesCubit>();
        return cubit.state.question == null ||
                cubit.state.question?.openInfoOrQuestions == false
            ? const SizedBox.shrink()
            : ClickableWidget(
                onTap: () {
                  if (cubit.state.question?.enableAnswers == true) {
                    ManageVibration.vibrate();
                    showAnimatedDialog(
                        context,
                        AlertDialog(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          surfaceTintColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          title: Text(
                            LocaleKeys.enterYourAnswer.localize,
                            style: Styles.headerText(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color),
                          ),
                          content: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _controller,
                              decoration: InputDecoration(
                                labelText: LocaleKeys.yourAnswer.localize,
                                hintText: LocaleKeys.enterSomething.localize,
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                disabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return LocaleKeys
                                      .pleaseEnterAValue.localize;
                                }
                                return null;
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
    ManageVibration.vibrate();
                                Navigator.of(context)
                                    .pop(); // Close the dialog
                              },
                              child: Text(
                                LocaleKeys.cancel.localize,
                                style: Styles.mediumText(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
    ManageVibration.vibrate();
                                if (_formKey.currentState!.validate()) {
                                  cubit.answerQuestion(
                                      id: cubit.state.question?.id ?? '',
                                      answer: _controller.text,
                                      context: context);
                                }
                              },
                              child: Text(
                                LocaleKeys.submit.localize,
                                style: Styles.mediumText(color: Colors.white),
                              ),
                            ),
                          ],
                        ));
                    // showDialog(
                    //   context: context,
                    //   builder: (context) {
                    //     return AlertDialog(
                    //       backgroundColor:
                    //           Theme.of(context).scaffoldBackgroundColor,
                    //       surfaceTintColor:
                    //           Theme.of(context).scaffoldBackgroundColor,
                    //       title: Text(
                    //         LocaleKeys.enterYourAnswer.localize,
                    //         style: Styles.headerText(
                    //             color: Theme.of(context)
                    //                 .textTheme
                    //                 .bodyMedium
                    //                 ?.color),
                    //       ),
                    //       content: Form(
                    //         key: _formKey,
                    //         child: TextFormField(
                    //           controller: _controller,
                    //           decoration: InputDecoration(
                    //             labelText: LocaleKeys.yourAnswer.localize,
                    //             hintText: LocaleKeys.enterSomething.localize,
                    //             border: const OutlineInputBorder(
                    //               borderRadius:
                    //                   BorderRadius.all(Radius.circular(20.0)),
                    //             ),
                    //             disabledBorder: const OutlineInputBorder(
                    //               borderRadius:
                    //                   BorderRadius.all(Radius.circular(20.0)),
                    //             ),
                    //             enabledBorder: const OutlineInputBorder(
                    //               borderRadius:
                    //                   BorderRadius.all(Radius.circular(20.0)),
                    //             ),
                    //             focusedBorder: const OutlineInputBorder(
                    //               borderRadius:
                    //                   BorderRadius.all(Radius.circular(20.0)),
                    //             ),
                    //           ),
                    //           validator: (value) {
                    //             if (value == null || value.trim().isEmpty) {
                    //               return LocaleKeys
                    //                   .pleaseEnterAValue.localize;
                    //             }
                    //             return null;
                    //           },
                    //         ),
                    //       ),
                    //       actions: [
                    //         TextButton(
                    //           onPressed: () {
    ManageVibration.vibrate();
                    //             Navigator.of(context)
                    //                 .pop(); // Close the dialog
                    //           },
                    //           child: Text(
                    //             LocaleKeys.cancel.localize,
                    //             style: Styles.mediumText(
                    //                 color: Theme.of(context)
                    //                     .textTheme
                    //                     .bodyMedium
                    //                     ?.color),
                    //           ),
                    //         ),
                    //         ElevatedButton(
                    //           onPressed: () {
    ManageVibration.vibrate();
                    //             if (_formKey.currentState!.validate()) {
                    //               cubit.answerQuestion(
                    //                   id: cubit.state.question?.id ?? '',
                    //                   answer: _controller.text,
                    //                   context: context);
                    //             }
                    //           },
                    //           child: Text(
                    //             LocaleKeys.submit.localize,
                    //             style: Styles.mediumText(color: Colors.white),
                    //           ),
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // );
                  }
                },
                child: Container(
                  height: 60.h,
                  alignment: Alignment.center,
                  child: AutoScrollText(
                    context.isArabic
                        ? '${context.read<MainCategoriesCubit>().state.question?.messageAr} ${LocaleKeys.clickHere.localize}                                        ' ??
                            ''
                        : '${context.read<MainCategoriesCubit>().state.question?.messageEn}                                         ' ??
                            '',
                    velocity: const Velocity(pixelsPerSecond: Offset(30, 0)),

                    style: Styles.headerText(
                        fontSize: 30,
                        color: context
                                    .read<MainCategoriesCubit>()
                                    .state
                                    .question
                                    ?.enableAnswers ==
                                true
                            ? AppColors.PRIMARY_COLOR
                            : (context.isDarkMode
                                ? Colors.white
                                : AppColors.PRIMARY_COLOR)),
                    textDirection: widget.textDirection ??
                        (context.isArabic
                            ? TextDirection.ltr
                            : TextDirection.rtl),
                    // textStyle: TextStyle(fontSize: 24),
                  ),
                ),
              );
      },
    );
  }
}
