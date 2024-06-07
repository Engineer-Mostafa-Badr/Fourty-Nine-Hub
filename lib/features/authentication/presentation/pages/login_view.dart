import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../common/widgets/stateless/buttons/default_button.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/error/failure.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../controllers/login_cubit/login_cubit.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginError) {
          showErrorMessage(
            context,
            getFailureMessage(
              state.failure,
              context,
            ),
          );
        } else if (state is LoginSuccess) {
          context.read<UserCubit>().getUser();
          context.go(Routes.HOME);
          showSuccessMessage(context, 'welcome back');
        } else if (state is LoginLoading) {
          showAdaptiveDialog(
              context: context,
              builder: (context) => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ));
        } else if (state is LoginError) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: const BackAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: loginCubit.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              children: [
                FormTextField(
                  controller: loginCubit.emailTextController,
                  label: 'E-mail or phone number',
                  hint: 'Type here',
                  prefix: const Icon(Icons.person),
                  action: (v) {},
                ),
                const Sizer(),
                FormTextField(
                  controller: loginCubit.passwordTextController,
                  label: 'Password',
                  hint: '***********',
                  obsecure: true,
                  prefix: const Icon(Icons.password),
                  action: (v) {},
                ),
                const Sizer(),
                DefaultButton(
                  label: 'Login',
                  onPressed: loginCubit.login,
                ),
                const Sizer(),
                Column(
                  children: [
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
                            onPressed: loginCubit.signInWithGoogle,
                          ),
                        ),
                        const Sizer(),
                        Expanded(
                          child: AppButton(
                            label: 'Facebook',
                            backColor: AppColors.LIGHT_GRAY_COLOR,
                            textColor: Colors.black,
                            icon: FontAwesomeIcons.facebook,
                            onPressed: loginCubit.signInWithFacebook,
                          ),
                        ),
                        if (Platform.isIOS) const Sizer(),
                        if (Platform.isIOS)
                          Expanded(
                            child: AppButton(
                              label: 'Apple',
                              backColor: AppColors.LIGHT_GRAY_COLOR,
                              textColor: Colors.black,
                              icon: FontAwesomeIcons.apple,
                              onPressed: loginCubit.signInWithApple,
                            ),
                          ),
                      ],
                    ),
                    const Sizer(),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Doesn't have account? ",
                            style: Styles.mediumText(color: Colors.grey),
                          ),
                          TextSpan(
                            text: "Register",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context.push(Routes.REGISTER),
                            style: Styles.mediumText(color: Colors.black),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
