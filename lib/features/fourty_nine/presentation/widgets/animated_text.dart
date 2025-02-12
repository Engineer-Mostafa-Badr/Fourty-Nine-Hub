import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:auto_scroll_text/auto_scroll_text.dart';

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
  Widget build(BuildContext context) {
    return BlocProvider<MainCategoriesCubit>(
      create: (BuildContext context) => serviceLocator()..getQuestion(),
      child: BlocBuilder<MainCategoriesCubit, MainCategoriesState>(
        builder: (BuildContext context, state) {
          var cubit = context.read<MainCategoriesCubit>();
          return cubit.state.question == null ||
                  cubit.state.question?.openInfoOrQuestions == false
              ? const SizedBox.shrink()
              : ClickableWidget(
                  onTap: () {
                    if (cubit.state.question?.enableAnswers == true) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
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
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    height: 60.h,
                    alignment: Alignment.center,
                    child: AutoScrollText(
                      velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),

                      context.isArabic
                          ? '${context.read<MainCategoriesCubit>().state.question?.messageAr}                                         ' ??
                              ''
                          : '${context.read<MainCategoriesCubit>().state.question?.messageEn}                                         ' ??
                              '',
                      style: Styles.headerText(
                          fontSize: 30,
                          color: context
                                      .read<MainCategoriesCubit>()
                                      .state
                                      .question
                                      ?.enableAnswers ==
                                  true
                              ? AppColors.SECONDARY_COLOR
                              : AppColors.PRIMARY_COLOR),
                      textDirection: widget.textDirection ??
                          (context.isArabic
                              ? TextDirection.rtl
                              : TextDirection.ltr),
                      // textStyle: TextStyle(fontSize: 24),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
