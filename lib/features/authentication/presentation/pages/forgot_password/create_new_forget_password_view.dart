import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/create_new_forgot_password_cubit/create_new_forgot_password_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';

import '../../../../../common/widgets/stateless/buttons/default_button.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../routes/routes.dart';

class CreateNewForgetPasswordView extends StatelessWidget {
  final String email;

  CreateNewForgetPasswordView({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateNewForgotPasswordCubit>();
    return BlocConsumer<CreateNewForgotPasswordCubit,
        CreateNewForgotPasswordState>(
      listener: (context, state) {
        if (state is CreateNewForgotPasswordSuccess) {
          showSuccessMessage(context, LocaleKeys.passwordChangedSuccessfully.localize);
          context.pushReplacement(
            Routes.LOGIN,
          );
        } else if (state is CreateNewForgotPasswordFailure) {
          showErrorMessage(context, getFailureMessage(state.failure, context));
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar:  BackAppBar(
            label: LocaleKeys.createNewPassword.localize,
          ),
          bottomSheet: SizedBox(
            height: 160.h,
            child: DefaultButton(
              margin: EdgeInsets.all(30.w),
              width: double.infinity,
              label: LocaleKeys.createNewPassword.localize,
              onPressed: () => cubit.createPassword(email),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: cubit.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  FormTextField(
                    controller: cubit.newPasswordController,
                    label: LocaleKeys.newPassword.localize,
                    hint: '***********',
                    obsecure: true,
                    prefix: const Icon(Icons.password),
                  ),
                  SizedBox(height: 20.h),
                  FormTextField(
                    controller: cubit.confirmPasswordController,
                    label: LocaleKeys.confirmNewPassword.localize,
                    hint: '***********',
                    obsecure: true,
                    prefix: const Icon(Icons.password),
                    action: (v) {},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
