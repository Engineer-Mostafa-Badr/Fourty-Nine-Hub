import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../common/widgets/stateless/buttons/default_button.dart';
import '../../../../../routes/routes.dart';

class EnterEmailForgotPasswordView extends StatelessWidget {
  const EnterEmailForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgotPasswordCubit>();
    return Scaffold(
      appBar: const BackAppBar(
        label: 'Forgot Password',
      ),
      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSendOTPSuccess) {
            context.pushNamed(
              Routes.FORGOTPASSWORDOTP,
              extra: cubit.emailController.text,
            );
          }

          if (state is ForgotPasswordSendOTPFailure) {
            showErrorMessage(
              context,
              getFailureMessage(
                state.failure,
                context,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: [
                Form(
                  key: cubit.emailFormKey,
                  child: FormTextField(
                    controller: cubit.emailController,
                    label: 'E-mail',
                    hint: 'Type here',
                    prefix: const Icon(Icons.person),
                  ),
                ),
                const Sizer(),
                DefaultButton(
                  label: 'Send OTP',
                  onPressed: cubit.sendForgetPasswordOTP,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
