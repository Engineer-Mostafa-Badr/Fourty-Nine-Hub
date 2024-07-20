import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/confirm_password_text_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/first_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/last_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/register_cubit/register_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/form/text_fields/password_text_form_field.dart';
import '../../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/buttons/default_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../controllers/user_cubit/user_cubit.dart';


class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final registerCubit = context.read<RegisterCubit>();
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterError) {
          showErrorMessage(context, getFailureMessage(state.failure, context));
        } else if (state is OTPSent) {
          showSuccessMessage(context, 'OTP Sent successfully');
          context.go(
            Routes.VERIFYMAIL,
            extra: registerCubit.emailTextController.text,
          );
        } else if (state is RegisterSuccess) {
          context.read<UserCubit>().getUser();
          context.go(Routes.HOME);
        }
      },
      child: Scaffold(
        appBar: const BackAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: registerCubit.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: FirstNameTextFormField(
                          currentFocusNode: registerCubit.firstNameFocusNode,
                          currentController: registerCubit.firstNameController,
                          nextFocusNode: registerCubit.lastNameFocusNode,
                        ),
                      ),
                      const Sizer(),
                      Expanded(
                        child: LastNameTextFormField(
                          currentFocusNode: registerCubit.lastNameFocusNode,
                          currentController: registerCubit.lastNameController,
                          nextFocusNode: registerCubit.emailFocusNode,
                        ),
                      ),
                    ],
                  ),
                  const Sizer(),
                  DefaultTextFormField(
                    currentFocusNode: registerCubit.emailFocusNode,
                    currentController: registerCubit.emailTextController,
                    nextFocusNode: registerCubit.passwordFocusNode,
                    suffixIcon: const Icon(Icons.email),
                    hint: 'Email',
                    validator: (v) {
                      if (!EmailValidator.validate(v!)) {
                        return 'invalid email';
                      }
                      return null;
                    },
                  ),
                  const Sizer(),
                  PasswordTextFormField(
                    currentFocusNode: registerCubit.passwordFocusNode,
                    currentController: registerCubit.passwordTextController,
                    nextFocusNode: registerCubit.confirmPasswordFocusNode,
                    hint: 'Password',
                  ),
                  const Sizer(),
                  ConfirmPasswordTextFormField(
                    currentFocusNode: registerCubit.confirmPasswordFocusNode,
                    currentController:
                        registerCubit.confirmPasswordTextController,
                    passwordController: registerCubit.passwordTextController,
                  ),
                  const Sizer(),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Gender : ',
                              style: Styles.headerText(fontSize: 14)),
                          Row(
                            children: [
                              Expanded(
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          registerCubit.isMale = true;
                                        });
                                      },
                                      child: BadgedLabel(
                                          color: registerCubit.isMale
                                              ? AppColors.PRIMARY_COLOR
                                              : Colors.white,
                                          textColor: registerCubit.isMale
                                              ? Colors.white
                                              : Colors.black,
                                          label: 'Male'))),
                              Expanded(
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          registerCubit.isMale = false;
                                        });
                                      },
                                      child: BadgedLabel(
                                          textColor: registerCubit.isMale
                                              ? Colors.black
                                              : Colors.white,
                                          color: registerCubit.isMale
                                              ? Colors.white
                                              : AppColors.PRIMARY_COLOR,
                                          label: 'Female'))),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const Sizer(height: 30),
                  DefaultButton(
                    label: 'Register',
                    width: double.infinity,
                    onPressed: registerCubit.register,
                  ),
                  const Sizer(),
                  const Sizer(),
                  Label(
                    text: 'Or Continue with',
                    style: Styles.mediumText(color: Colors.grey),
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Google',
                          backColor: AppColors.LIGHT_GRAY_COLOR,
                          textColor: Colors.black,
                          icon: FontAwesomeIcons.google,
                          onPressed: () {},
                        ),
                      ),
                      const Sizer(),
                      Expanded(
                        child: AppButton(
                          label: 'Facebook',
                          backColor: AppColors.LIGHT_GRAY_COLOR,
                          textColor: Colors.black,
                          icon: FontAwesomeIcons.facebook,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const Sizer(height: 20),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Does have account? ",
                          style: Styles.mediumText(
                            color: Colors.grey,
                          ),
                        ),
                        TextSpan(
                          text: "Login",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.push(Routes.LOGIN),
                          style: Styles.mediumText(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
