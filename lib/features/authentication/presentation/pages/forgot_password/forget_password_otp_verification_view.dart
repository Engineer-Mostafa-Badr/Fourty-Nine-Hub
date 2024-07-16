import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mtwstat/app/core/localization.dart';
import 'package:mtwstat/app/modules/forget_password/controllers/forget_password_controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/primary_button.dart';

class ForgetPasswordOtpVerificationView
    extends GetView<ForgetPasswordController> {
  const ForgetPasswordOtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) {
        controller.isVerifying = false;
      },
      child: Scaffold(
        appBar: CustomAppbar(
          title: tr(context).checkVerificationCode,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SvgPicture.asset(
                  'assets/icons/otp_icon.svg',
                  height: 250,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                tr(context).checkVerificationCode,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black.withOpacity(.8),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                tr(context).checkVerificationCodeHint,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black.withOpacity(.7),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                controller.emailController.text,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              PinCodeTextField(
                appContext: context,
                enabled: !controller.isLoading.value,
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
                onChanged: (v) => controller.otp = v,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                boxShadows: const [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 10,
                  )
                ],
                onCompleted: (v) => controller.verifyOtp(),
              ),
              StreamBuilder(
                stream: controller.stopWatchTimer.secondTime,
                initialData: 0,
                builder: (context, snapshot) {
                  final value = snapshot.data as int;
                  final isTimerRunning = value != 0;
                  final seconds = value % 60;
                  final minutes = value ~/ 60;
                  return Row(
                    children: [
                      Text(
                        tr(context).messageNotReceived,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withOpacity(.8),
                        ),
                      ),
                      TextButton(
                        onPressed: isTimerRunning ? null : controller.senOtp,
                        child: Text(
                          tr(context).resend,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isTimerRunning
                                ? Colors.grey
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${minutes < 10 ? '0$minutes' : minutes}:${seconds < 10 ? '0$seconds' : seconds}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(.8),
                        ),
                      )
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: PrimaryButton(
                  text: tr(context).confirm,
                  onPressed: controller.verifyOtp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
