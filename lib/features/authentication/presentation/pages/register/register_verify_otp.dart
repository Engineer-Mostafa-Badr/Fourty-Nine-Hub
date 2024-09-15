import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/notification_socket_io/notification_socket_io_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/utils/shared_pref.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../notifications/presentation/cubits/notification_socket_io/notification_socket_io_cubit.dart';
import '../../controllers/user_cubit/user_cubit.dart';

class RegisterVerifyOTP extends StatefulWidget {
  final String email;

  const RegisterVerifyOTP({
    super.key,
    required this.email,
  });

  @override
  State<RegisterVerifyOTP> createState() => _RegisterVerifyOTPState();
}

class _RegisterVerifyOTPState extends State<RegisterVerifyOTP> {
  @override
  Widget build(BuildContext context) {
    final verifyOtpCubit = context.read<VerifyOtpCubit>();
    return BlocListener<VerifyOtpCubit, VerifyOtpState>(
      listener: (context, state) async {
        if (state is VerifyOtpError) {
          showErrorMessage(context, getFailureMessage(state.failure, context));
        } else if (state is ResendOtpError) {
          showErrorMessage(context, getFailureMessage(state.failure, context));
        } else if (state is ResendOtpSuccess) {
          showSuccessMessage(context, 'resend otp success');
        } else if (state is VerifyOtpSuccess) {
          await TokenManager.saveAccessToken(
              state.userTokensEntity.accessToken);
          await TokenManager.saveRefreshToken(
              state.userTokensEntity.refreshToken);
          context.read<NotificationSocketIoCubit>().notificationListener();
          context
              .read<NotificationSocketIoCubit>()
              .clearAllNotificationsAndRefeatchAfterLogin();

          serviceLocator<UserCubit>()
            ..setLogin(true)
            ..attachToken()
            ..getUser().then((value) async {
              // Ensure the widget is still mounted before proceeding
              if (!mounted) return;

              String? accessToken = await TokenManager.getAccessToken();
              String? refreshToken = await TokenManager.getRefreshToken();

              print(
                  '/////////////////////////////////////////////////////////////////////////');
              print('Refresh Token: $refreshToken');
              print('Access Token: $accessToken');
              print(
                  '/////////////////////////////////////////////////////////////////////////');
              print(serviceLocator<UserCubit>().state.data.toString());

              // Navigate to the home screen
              context.go(Routes.HOME);
              context.pop();
              context.pop();

              // Show the success dialog after navigation
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0.r),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(30.0.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                LocaleKeys.congratulations.localize,
                                style: Styles.headerText(
                                    color: AppColors.SECONDARY_COLOR,
                                    fontSize: 45.sp),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                LocaleKeys.giftApp.localize,
                                textAlign: TextAlign.center,
                                style: Styles.mediumText(),
                              ),
                              SizedBox(height: 40.h),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0.r),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 40.0.w,
                                    vertical: 24.h,
                                  ),
                                  child: Text(
                                    LocaleKeys.close.localize,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              });
            });
        }
      },
      child: Scaffold(
        appBar: const BackAppBar(),
        bottomSheet: DefaultButton(
          margin: const EdgeInsets.all(30),
          width: double.infinity,
          label: 'Verify',
          onPressed: () => verifyOtpCubit.verifyOTP(widget.email),
        ),
        body: Column(
          children: [
            const Label(
              text: 'Email OTP\nVerification',
            ),
            const Label(
              text: 'Please check your phone to see the verification\ncode',
            ),
            Sizer(),
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
              onCompleted: (v) => verifyOtpCubit.verifyOTP(widget.email),
              beforeTextPaste: (text) {
                return true;
              },
            ),
            Sizer(),
            const Label(
              text: 'Didn\'t receive an email?',
            ),
            TextButton(
              onPressed: () => verifyOtpCubit.resendOTP(widget.email),
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
