import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/bottom_navigator.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../common/widgets/stateless/buttons/default_button.dart';
import '../../../../../routes/routes.dart';

class EnterEmailForgotPasswordView extends StatelessWidget {
  const EnterEmailForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgotPasswordCubit>();
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.forget.localize,
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
            padding: EdgeInsets.all(20.w),
            child: ListView(
              children: [
                const Sizer(),
                Form(
                  key: cubit.emailFormKey,
                  child: FormTextField(
                    controller: cubit.emailController,
                    label: LocaleKeys.email.localize,
                    hint: LocaleKeys.typeHere.localize,
                    prefix: Icon(
                      Icons.person,
                      color: AppColors.GREY_DARK_COLOR,
                      size: 40.w,
                    ),
                  ),
                ),
                const Sizer(),
                DefaultButton(
                  label: LocaleKeys.sendOTP.localize,
                  onPressed: cubit.sendForgetPasswordOTP,
                  labelStyle: TextStyle(
                      fontSize: 50.sp.w, color: AppColors.AUTH_CONTAINER_COLOR),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
