import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../routes/routes.dart';
import '../../controllers/user_cubit/user_cubit.dart';

class RegisterVerifyOTP extends StatelessWidget {
  final String email;

  const RegisterVerifyOTP({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final verifyOtpCubit = context.read<VerifyOtpCubit>();
    return BlocListener<VerifyOtpCubit, VerifyOtpState>(
      listener: (context, state) {
        if (state is VerifyOtpError) {
          showErrorMessage(context, getFailureMessage(state.failure, context));
        } else if (state is ResendOtpError) {
          showErrorMessage(context, getFailureMessage(state.failure, context));
        } else if (state is ResendOtpSuccess) {
          showSuccessMessage(context, 'resend otp success');
        } else if (state is VerifyOtpSuccess) {
          context.read<UserCubit>().setLogin(true);
          context.read<UserCubit>().getUser();
          context.go(Routes.HOME);
        }
      },
      child: Scaffold(
        appBar: const BackAppBar(),
        bottomSheet: DefaultButton(
          margin: const EdgeInsets.all(30),
          width: double.infinity,
          label: 'Verify',
          onPressed: () => verifyOtpCubit.verifyOTP(email),
        ),
        body: Column(
          children: [
            const Label(
              text: 'Email OTP\nVerification',
            ),
            const Label(
              text: 'Please check your phone to see the verification\ncode',
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
              onChanged: (v) => verifyOtpCubit.otp = v,
              keyboardType: TextInputType.number,
              boxShadows: const [
                BoxShadow(
                  offset: Offset(0, 1),
                  color: Colors.black12,
                  blurRadius: 10,
                )
              ],
              onCompleted: (v) => verifyOtpCubit.verifyOTP(email),
              beforeTextPaste: (text) {
                return true;
              },
            ),
            const Sizer(),
            const Label(
              text: 'Didn\'t receive an email?',
            ),
            TextButton(
              onPressed: () => verifyOtpCubit.resendOTP(email),
              child: const Label(
                text: 'Resend',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
