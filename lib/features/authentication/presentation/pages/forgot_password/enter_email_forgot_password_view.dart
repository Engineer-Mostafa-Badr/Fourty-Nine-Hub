import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/forgot_password_cubit/forgot_password_cubit.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/default_button.dart';
import '../../../../../helpers/manage_vibration.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class EnterEmailForgotPasswordView extends StatefulWidget {
  const EnterEmailForgotPasswordView({super.key});

  @override
  State<EnterEmailForgotPasswordView> createState() => _EnterEmailForgotPasswordViewState();
}

class _EnterEmailForgotPasswordViewState extends State<EnterEmailForgotPasswordView> {
  @override
  void initState() {
    super.initState();
    // Load existing timer when view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ForgotPasswordCubit>().timerService.loadExistingTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgotPasswordCubit>();
    return CustomScaffold(
      enableCustomAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          enableCustomAppBar: true,
          label: LocaleKeys.forget.localize,
        ),
      ),
      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSendOTPSuccess) {
            // context.push(
            //   Routes.FORGOTPASSWORDOTP,
            //   extra: cubit.emailController.text,
            // );
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
          return ListenableBuilder(
            listenable: cubit.timerService,
            builder: (context, child) {
          return Padding(
            padding: EdgeInsets.all(20.w),
            child: ListView(
              children: [
                const Sizer(),
                Form(
                  key: cubit.emailFormKey,
                  child: DefaultTextFormField(
                    fillColor: Colors.transparent,
                    currentController: cubit.emailController,
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
                // Timer display
                if (cubit.timerService.isTimerActive) ...[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer,
                          color: AppColors.GREY_DARK_COLOR,
                          size: 20.w,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Resend OTP in ${cubit.timerService.formattedRemainingTime}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.GREY_DARK_COLOR,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Sizer(),
                ],
                DefaultButton(
                  label: cubit.timerService.isTimerActive 
                      ? '${LocaleKeys.sendOTP.localize} (${cubit.timerService.formattedRemainingTime})'
                      : LocaleKeys.sendOTP.localize,
                  onPressed: cubit.timerService.isTimerActive 
                      ? null 
                      : () {
                          ManageVibration.vibrate();
                          cubit.sendForgetPasswordOTP(context);
                        },
                  labelStyle: TextStyle(
                      fontSize: 60.sp.w, 
                      color: cubit.timerService.isTimerActive 
                          ? AppColors.GREY_DARK_COLOR.withOpacity(0.5)
                          : AppColors.AUTH_CONTAINER_COLOR),
                ),
              ],
            ));
          },
        );
        },
      ),
    );
  }
}
