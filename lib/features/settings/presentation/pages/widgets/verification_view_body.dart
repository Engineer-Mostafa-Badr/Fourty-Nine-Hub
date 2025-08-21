import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/utils/custom_show_dialog.dart';
import '../../../../../core/widget/custom_floating_action_button.dart';
import '../../../../authentication/presentation/controllers/forgot_password_cubit/forgot_password_cubit.dart';
import 'dialog_verification_widget.dart';
import 'label_and_text_form_field.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../authentication/domain/entities/forget_password_questions_entity.dart';
import '../../../../../helpers/manage_vibration.dart';

class VerificationViewBody extends StatefulWidget {
  const VerificationViewBody({
    super.key,
    required this.questions,
  });

  final ForgetPasswordQuestionsEntity questions;

  @override
  State<VerificationViewBody> createState() => _VerificationViewBodyState();
}

class _VerificationViewBodyState extends State<VerificationViewBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is VerifyQuestionsFailure) {
          showAnimatedDialog(
            context,
            DialogVerificationWidget(
              okOnPressed: () {
                Navigator.of(context).pop();
              },
              cancelOnPressed: () {
                context.go(Routes.LOGIN);
              },
            ),
          );
        }
      },
      builder: (context, state) {
        var forgotPasswordCubit = context.read<ForgotPasswordCubit>();
        return Form(
          key: forgotPasswordCubit.verificationFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
            child: Column(
              children: [
                LabelAndTextFormField(
                  label: context.isArabic
                      ? widget.questions.questions.questionsAr[0]
                      : widget.questions.questions.questionsEn[0],
                  controller: forgotPasswordCubit.questionOneAnswerController,
                  hint: 'Answer',
                ),
                const Sizer(),
                LabelAndTextFormField(
                  label: context.isArabic
                      ? widget.questions.questions.questionsAr[1]
                      : widget.questions.questions.questionsEn[1],
                  controller: forgotPasswordCubit.questionTwoAnswerController,
                  hint: 'Answer',
                ),
                const Sizer(),
                LabelAndTextFormField(
                  label: context.isArabic
                      ? widget.questions.questions.questionsAr[2]
                      : widget.questions.questions.questionsEn[2],
                  controller: forgotPasswordCubit.questionThreeAnswerController,
                  hint: 'Answer',
                ),
                const Sizer(
                  height: 32,
                ),
                SizedBox(
                  width: double.infinity,
                  child: CustomFloatingActionButton(
                    text: LocaleKeys.confirm.localize,
                    onPressed: () {
                      ManageVibration.vibrate();
                      forgotPasswordCubit.verifyQuestions(
                        context,
                        userId: widget.questions.userId,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
