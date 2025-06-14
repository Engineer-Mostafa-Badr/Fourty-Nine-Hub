import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/default_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../controllers/verify_forgot_password_otp/verify_forgot_password_otp_cubit.dart';
import '../../controllers/verify_otp_cubit/verify_otp_cubit.dart';
import 'otp_timer.dart';

class ForgetPasswordOtpVerificationView extends StatelessWidget {
  final String email;

  const ForgetPasswordOtpVerificationView({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final verifyOtpCubit = context.read<VerifyOtpCubit>();
    final cubit = context.read<VerifyForgotPasswordOtpCubit>();
    return BlocConsumer<VerifyForgotPasswordOtpCubit,
        VerifyForgotPasswordOtpState>(
      listener: (context, state) {
        if (state is VerifyForgotPasswordOtpSuccess) {
          context.pushReplacementNamed(
            Routes.CREATENEWFORGOTPASSWORD,
            extra: {"email": email, "userId": null},
          );
        } else if (state is VerifyForgotPasswordOtpFailure) {
          showErrorMessage(context, getFailureMessage(state.failure, context));
        }
      },
      builder: (context, state) {
        return CustomScaffold(
          enableCustomAppBar: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: BackAppBar(
              label:"${LocaleKeys.oTPVerifyFor.localize} ${LocaleKeys.email.localize}",
              enableCustomAppBar: true,
            ),
          ),
          bottomSheet: SizedBox(
            child: DefaultButton(
              margin: EdgeInsets.all(30.w),
              width: double.infinity,
              label: LocaleKeys.verify.localize,
              labelStyle: TextStyle(
                  fontSize: 60.sp.w, color: AppColors.AUTH_CONTAINER_COLOR),
              onPressed: () => cubit.verifyOtp(email),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Sizer(),
                Label(
                  text: LocaleKeys.checkVerification.localize,
                  style: Styles.headerText(),
                  maxLines: 2,
                ),
                const Sizer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Label(
                      text: LocaleKeys.weHaveSentACodeTo.localize,
                      style: Styles.mediumText(color: Colors.black87),
                    ),
                    Label(
                      text: email,
                      style: Styles.mediumText(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Sizer(
                  height: 32,
                ),
                Label(
                  text: LocaleKeys.otpCode.localize,
                  style: Styles.headerText(),
                ),
                const Sizer(),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: PinCodeTextField(
                    appContext: context,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    length: 6,
                    obscureText: false,
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(4),
                      // fieldHeight: 50.h,
                      // fieldWidth: 50.w,
                      activeFillColor: context.theme.scaffoldBackgroundColor,
                      selectedFillColor: context.theme.scaffoldBackgroundColor,
                      inactiveFillColor: context.theme.scaffoldBackgroundColor,
                      inactiveColor: Theme.of(context).primaryColor,
                      activeColor: Theme.of(context).primaryColor,
                      selectedColor: Theme.of(context).primaryColor,
                      disabledColor: Colors.grey[100],
                      errorBorderColor: Colors.red,
                      activeBorderWidth: 1,
                      selectedBorderWidth: 1,
                      inactiveBorderWidth: 1,
                      disabledBorderWidth: 1,
                      errorBorderWidth: 1,
                      borderWidth: 1,
                    ),
                    cursorColor: AppColors.PRIMARY_COLOR,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    onChanged: (v) => cubit.otp = v,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                    onCompleted: (v) => cubit.verifyOtp(email),
                    beforeTextPaste: (text) {
                      return true;
                    },
                  ),
                ),
                const Sizer(),
                OTPTimer(
                  onResendPressed: () {
                    verifyOtpCubit.resendOTP(email, false);
                  },
                ),
                const Sizer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
