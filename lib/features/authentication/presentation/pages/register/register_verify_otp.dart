import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/utils/shared_pref.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

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
          await CacheManager.saveAccessToken(
              state.userTokensEntity.accessToken);
          await CacheManager.saveRefreshToken(
              state.userTokensEntity.refreshToken);

          serviceLocator<UserCubit>()
            ..setLogin(true)
            ..attachToken()
            ..getUser().then((value) async {
              if (!mounted) return;

              String? accessToken = await CacheManager.getAccessToken();
              String? refreshToken = await CacheManager.getRefreshToken();

              print('Refresh Token: $refreshToken');
              print('Access Token: $accessToken');
              print(serviceLocator<UserCubit>().state.data.toString());

              context.pop();
              context.push(Routes.HOME);

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
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                LocaleKeys.congratulations.localize,
                                style: Styles.headerText(
                                  color: AppColors.SECONDARY_COLOR,
                                ),
                              ),
                              Sizer(),
                              Text(
                                context.isArabic
                                    ? state.giftMessageEntity.ar
                                    : state.giftMessageEntity.en,
                                textAlign: TextAlign.center,
                                style: Styles.mediumText(),
                              ),
                              SizedBox(height: 40.h),
                              SizedBox(
                                height: 40,
                                width: double.infinity,
                                child: Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        ManageVibration.vibrate();
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColors.SECONDARY_COLOR,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0.r),
                                        ),
                                      ),
                                      child: Label(
                                        text: LocaleKeys.close.localize,
                                        style: Styles.mediumText(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                      ),
                                    ),
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
      child: CustomScaffold(
        enableCustomAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: BackAppBar(
            label: context.isArabic ? 'التحقق من OTP للبريد الإلكتروني' : 'OTP Verify For Email',
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
            onPressed: () => verifyOtpCubit.verifyOTP(widget.email),
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
              ),
              const Sizer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Label(
                    text: context.isArabic ?'لقد ارسلنا كود ل':'We\'ve sent a code to ',
                    style: Styles.mediumText(color: Colors.black87),
                  ),
                  Label(
                    text: widget.email,
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
                text: context.isArabic ? 'كود التحقق':'OTP Code',
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
              ),
              const Sizer(),
            ],
          ),
        ),
      ),
      // child: Scaffold(
      //   appBar: const BackAppBar(),
      //   bottomSheet: Container(
      //     padding: const EdgeInsets.all(30),
      //     decoration: const BoxDecoration(
      //       color: Colors.white,
      //       boxShadow: [
      //         BoxShadow(
      //           color: Colors.black12,
      //           blurRadius: 10,
      //           offset: Offset(0, -2),
      //         ),
      //       ],
      //     ),
      //     child: DefaultButton(
      //       width: double.infinity,
      //       label: LocaleKeys.verify.localize,
      //       onPressed: () => verifyOtpCubit.verifyOTP(widget.email),
      //     ),
      //   ),
      //   body: SingleChildScrollView(
      //     padding: const EdgeInsets.symmetric(horizontal: 20),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         const SizedBox(height: 60),
      //         // Animated Title
      //         TweenAnimationBuilder(
      //           duration: const Duration(milliseconds: 500),
      //           tween: Tween<double>(begin: 0, end: 1),
      //           builder: (context, value, child) {
      //             return Opacity(
      //               opacity: value,
      //               child: Transform.translate(
      //                 offset: Offset(0, (1 - value) * 20),
      //                 child:  Text(
      //                   LocaleKeys.emailOtpVerification.localize,
      //                   style: const TextStyle(
      //                     fontSize: 28,
      //                     fontWeight: FontWeight.bold,
      //                     color: Colors.black87,
      //                   ),
      //                   textAlign: TextAlign.center,
      //                 ),
      //               ),
      //             );
      //           },
      //         ),
      //         const SizedBox(height: 16),
      //         ShaderMask(
      //           shaderCallback: (bounds) {
      //             return LinearGradient(
      //               colors: [Colors.blue.shade600, Colors.purple.shade600],
      //               begin: Alignment.topLeft,
      //               end: Alignment.bottomRight,
      //             ).createShader(bounds);
      //           },
      //           child:  Text(
      //             LocaleKeys.pleaseCheckEmail.localize,
      //             style: const TextStyle(
      //               fontSize: 16,
      //               color: Colors.white,
      //             ),
      //             textAlign: TextAlign.center,
      //           ),
      //         ),
      //         const SizedBox(height: 40),
      //         PinCodeTextField(
      //           appContext: context,
      //           length: 6,
      //           obscureText: false,
      //           animationType: AnimationType.scale,
      //           pinTheme: PinTheme(
      //             shape: PinCodeFieldShape.box,
      //             borderRadius: BorderRadius.circular(12),
      //             fieldWidth: 50,
      //             fieldHeight: 70,
      //             activeFillColor: Colors.white,
      //             selectedFillColor: Colors.white,
      //             inactiveFillColor: Colors.white,
      //             activeColor: Theme.of(context).primaryColor,
      //             selectedColor: Theme.of(context).primaryColor,
      //             inactiveColor: Colors.grey[300],
      //             borderWidth: 2,
      //           ),
      //           cursorColor: Colors.black,
      //           animationDuration: const Duration(milliseconds: 300),
      //           enableActiveFill: true,
      //           onChanged: (v) => verifyOtpCubit.otp = v,
      //           keyboardType: TextInputType.number,
      //           boxShadows: const [
      //             BoxShadow(
      //               offset: Offset(0, 4),
      //               color: Colors.black12,
      //               blurRadius: 8,
      //             ),
      //           ],
      //           onCompleted: (v) => verifyOtpCubit.verifyOTP(widget.email),
      //         ),
      //         const SizedBox(height: 40), // Spacing
      //
      //          Text(
      //           LocaleKeys.didntReciveEmail.localize,
      //           style: const TextStyle(
      //             fontSize: 16,
      //             color: AppColors.PRIMARY_COLOR_DARK,
      //           ),
      //         ),
      //         const SizedBox(height: 20), // Spacing
      //
      //         BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
      //           builder: (context, state) {
      //             final verifyOtpCubit = context.read<VerifyOtpCubit>();
      //             return TweenAnimationBuilder(
      //               duration: const Duration(milliseconds: 300),
      //               tween: Tween<double>(begin: 0, end: 1),
      //               builder: (context, value, child) {
      //                 return Opacity(
      //                   opacity: value,
      //                   child: Transform.translate(
      //                     offset: Offset(0, (1 - value) * 20),
      //                     child: Padding(
      //                       padding: const EdgeInsets.symmetric(horizontal: 20),
      //                       child: Row(
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         children: [
      //                           TextButton(
      //                             onPressed: verifyOtpCubit.isTimeOff
      //                                 ? () {
      //                               verifyOtpCubit.resendOTP(widget.email);
      //                             }
      //                                 : null,
      //                             style: TextButton.styleFrom(
      //                               foregroundColor: verifyOtpCubit.isTimeOff
      //                                   ? Theme.of(context).primaryColor
      //                                   : Colors.grey,
      //                               padding: const EdgeInsets.symmetric(
      //                                 horizontal: 20,
      //                                 vertical: 10,
      //                               ),
      //                               shape: RoundedRectangleBorder(
      //                                 borderRadius: BorderRadius.circular(8),
      //                               ),
      //                               backgroundColor: verifyOtpCubit.isTimeOff
      //                                   ? Theme.of(context).primaryColor.withOpacity(0.1)
      //                                   : Colors.grey.withOpacity(0.1),
      //                             ),
      //                             child:  Text(
      //                               LocaleKeys.resend.localize,
      //                               style: const TextStyle(
      //                                 fontSize: 16,
      //                                 fontWeight: FontWeight.bold,
      //                               ),
      //                             ),
      //                           ),
      //                           const SizedBox(width: 10), // Spacing
      //                           CountdownTimer(
      //                             controller: verifyOtpCubit.controller,
      //                             onEnd: verifyOtpCubit.onEnd,
      //                             endTime: verifyOtpCubit.endTime,
      //                             endWidget: const Text(
      //                               "00:00",
      //                               style: TextStyle(
      //                                 fontSize: 16,
      //                                 color: AppColors.PRIMARY_COLOR,
      //                               ),
      //                             ),
      //                             widgetBuilder: (context, CurrentRemainingTime? time) {
      //                               if (time == null) {
      //                                 return const Text(
      //                                   '00:00',
      //                                   style: TextStyle(
      //                                     fontSize: 16,
      //                                     color: Colors.grey,
      //                                   ),
      //                                 );
      //                               }
      //                               return Text(
      //                                 '${time.sec} : 00',
      //                                 style: const TextStyle(
      //                                   fontSize: 16,
      //                                   color:AppColors.PRIMARY_COLOR,
      //                                   fontWeight: FontWeight.bold,
      //                                 ),
      //                               );
      //                             },
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                 );
      //               },
      //             );
      //           },
      //         ),
      //         const SizedBox(height: 40),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
