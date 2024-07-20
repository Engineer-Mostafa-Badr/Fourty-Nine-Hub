import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../../common/widgets/stateless/buttons/default_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
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
            height: 110,
            child: DefaultButton(
              margin: const EdgeInsets.all(30),
              width: double.infinity,
              label: 'Verify',
              onPressed: () => cubit.verifyOtp(email),
            ),
          ),
          body: Column(
            children: [
              const Label(
                text: 'Email OTP\nVerification',
              ),
              Label(
                text:
                    'Please check your email to see the verification\ncode ($email)',
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
                  fieldHeight: 50,
                  fieldWidth: 50,
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
