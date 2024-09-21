import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';

import '../../../../../common/widgets/stateless/buttons/default_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';
import '../../controllers/verify_forgot_password_otp/verify_forgot_password_otp_cubit.dart';

class ForgetPasswordOtpVerificationView extends StatelessWidget {
  final String email;

  const ForgetPasswordOtpVerificationView({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VerifyForgotPasswordOtpCubit>();
    return BlocConsumer<VerifyForgotPasswordOtpCubit,
        VerifyForgotPasswordOtpState>(
      listener: (context, state) {
        if (state is VerifyForgotPasswordOtpSuccess) {
          context.pushReplacementNamed(
            Routes.CREATENEWFORGOTPASSWORD,
            extra: email,
          );
        } else if (state is VerifyForgotPasswordOtpFailure) {
          showErrorMessage(context, getFailureMessage(state.failure, context));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const BackAppBar(),
          bottomSheet: SizedBox(
            child: DefaultButton(
              margin: EdgeInsets.all(30.zW),
              width: double.infinity,
              label: LocaleKeys.verify.localize,
              labelStyle: TextStyle(
                  fontSize: 35.zW, color: AppColors.AUTH_CONTAINER_COLOR),
              onPressed: () => cubit.verifyOtp(email),
            ),
          ),
          body: Column(
            children: [
              Label(
                text: LocaleKeys.emailOtp.localize,
              ),
              Label(
                text: LocaleKeys.verification.localize,
              ),
              Label(
                text: '${LocaleKeys.checkVerification.localize} ($email)',
              ),
              const Sizer(),
              PinCodeTextField(
                appContext: context,
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
                  fieldHeight: 50.zH,
                  fieldWidth: 50.zW,
                  activeFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
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
                cursorColor: Colors.black,
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
              const Sizer(),
            ],
          ),
        );
      },
    );
  }
}
