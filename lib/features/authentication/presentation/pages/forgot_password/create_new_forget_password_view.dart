import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/create_new_forgot_password_cubit/create_new_forgot_password_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';

import '../../../../../common/widgets/stateless/buttons/default_button.dart';
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
          showSuccessMessage(context, 'Password Changed Successfully');
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
          appBar: const BackAppBar(
            label: 'Create New Password',
          ),
          bottomSheet: SizedBox(
            height: 110.h,
            child: DefaultButton(
              margin: EdgeInsets.all(30.w),
              width: double.infinity,
              label: 'Create New Password',
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
                    label: 'New Password',
                    hint: '***********',
                    obsecure: true,
                    prefix: const Icon(Icons.password),
                  ),
                  SizedBox(height: 20.h),
                  FormTextField(
                    controller: cubit.confirmPasswordController,
                    label: 'Confirm New Password',
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
