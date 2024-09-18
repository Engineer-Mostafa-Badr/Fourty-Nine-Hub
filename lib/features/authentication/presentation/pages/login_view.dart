import 'dart:developer';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/register_cubit/register_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/get_wallet_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/notification_socket_io/notification_socket_io_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../common/widgets/stateless/buttons/default_button.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/localization/locales.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../controllers/login_cubit/login_cubit.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key, required this.authType});

  AuthType authType;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // AuthType selectedAuth = AuthType.LOGIN;
  ScrollController scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
    log(widget.authType.toString(),
        name: "lllllllllllllllllllllllllllllllllllll");
    // wid, required AuthType authTypeget.authType = widget.authType;
    // log(widget.authType.toString(), name: "lllllllllllllllllllllllllllllllllllll");
  }

  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();
    final registerCubit = context.read<RegisterCubit>();
    if (MediaQuery.of(context).viewInsets.bottom != 0.0) {
      log("lllllllllllllllllllllllllll");
      scrollController.jumpTo(409);
    }
    log(MediaQuery.of(context).viewInsets.bottom.toString(),
        name: "OpenKeyboard");
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) async {
        if (state is RegisterError) {
          showErrorMessage(context, getFailureMessage(state.failure, context));
        } else if (state is OTPSent) {
          showSuccessMessage(context, LocaleKeys.oTP.localize);
          context.go(
            Routes.VERIFYMAIL,
            extra: registerCubit.emailTextController.text,
          );
        } else if (state is RegisterSuccess) {
          context.read<UserCubit>().setLogin(true);
          context.read<UserCubit>().getUser();
          context.go(Routes.HOME);
        }
      },
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) async {
          if (state is LoginError) {
            showErrorMessage(
              context,
              getFailureMessage(
                state.failure,
                context,
              ),
            );
          } else if (state is LoginSuccess) {
            await TokenManager.saveAccessToken(
                state.userTokensEntity.accessToken);
            await TokenManager.saveRefreshToken(
                state.userTokensEntity.refreshToken);

            serviceLocator<UserCubit>()
              ..setLogin(true)
              ..attachToken()
              ..getUser().then((value) async {
                serviceLocator<GetWalletCubit>().getWallet();
                serviceLocator<WalletCubit>().getWallet();
                String? accessToken = await TokenManager.getAccessToken();
                String? refreshToken = await TokenManager.getRefreshToken();
                debugPrint(
                    '/////////////////////////////////////////////////////////////////////////');
                debugPrint('Refresh Token: $refreshToken');
                debugPrint('Access Token: $accessToken');
                debugPrint(
                    '/////////////////////////////////////////////////////////////////////////');
                debugPrint(serviceLocator<UserCubit>().state.data.toString());
                // Navigator.pop(context);
                Navigator.pop(context);
                context.push(Routes.HOME);
              });
            context.read<NotificationSocketIoCubit>().notificationListener();
            context
                .read<NotificationSocketIoCubit>()
                .clearAllNotificationsAndRefeatchAfterLogin();
            showSuccessMessage(context, LocaleKeys.welcomeBack.localize);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: const BackAppBar(),
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(16.0.w),
              child: Form(
                  key: formKey,
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Image.asset(
                        Assets.logo,
                        width: 200.h,
                        height: 200.h,
                      ),
                      SizedBox(
                        height: 60.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          chooseAuthWidget(
                            onTap: () {
                              setState(() {
                                widget.authType = AuthType.LOGIN;
                              });
                            },
                            active: widget.authType == AuthType.LOGIN,
                            text: LocaleKeys.login.localize,
                            borderRadius: context.locale == Locales.english
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(100.r),
                                    bottomLeft: Radius.circular(100.r),
                                  )
                                : BorderRadius.only(
                                    topRight: Radius.circular(100.r),
                                    bottomRight: Radius.circular(100.r),
                                  ),
                          ),
                          chooseAuthWidget(
                            onTap: () {
                              setState(() {
                                widget.authType = AuthType.REGISTER;
                              });
                            },
                            active: widget.authType == AuthType.REGISTER,
                            text: LocaleKeys.register.localize,
                            borderRadius: context.locale == Locales.english
                                ? const BorderRadius.only(
                                    topRight: Radius.circular(50),
                                    bottomRight: Radius.circular(50),
                                  )
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    bottomLeft: Radius.circular(50),
                                  ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60.h,
                      ),
                      widget.authType == AuthType.LOGIN
                          ? LoginWidget(
                              loginCubit: loginCubit,
                            )
                          : const RegisterWidget(),
                      SizedBox(
                        height: widget.authType == AuthType.LOGIN
                            ? MediaQuery.of(context).viewInsets.bottom != 0.0
                                ? 20
                                : 100.h
                            : 0,
                      ),
                      widget.authType == AuthType.REGISTER
                          ? DefaultButton(
                              labelStyle: TextStyle(
                                  fontSize: 35.sp,
                                  color: AppColors.AUTH_CONTAINER_COLOR),
                              label: LocaleKeys.register.localize,
                              width: double.infinity,
                              onPressed: () {
                                if (registerCubit.accept) {
                                  registerCubit.register();
                                } else {
                                  showErrorMessage(
                                      context,
                                      getFailureMessage(
                                          ServerFailure(
                                              message:
                                                  LocaleKeys.terms.localize),
                                          context));
                                }
                              },
                            )
                          : DefaultButton(
                              width: double.infinity,
                              label: LocaleKeys.login.localize,
                              labelStyle: TextStyle(
                                  fontSize: 35.sp,
                                  color: AppColors.AUTH_CONTAINER_COLOR),
                              onPressed: () => loginCubit.login(formKey),
                            ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  chooseAuthWidget(
      {required bool active,
      required String text,
      required BorderRadius borderRadius,
      void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70.h,
        width: 200.h,
        decoration: BoxDecoration(
          color: active ? AppColors.PRIMARY_COLOR : const Color(0xFFEEEEEE),
          borderRadius: borderRadius,
        ),
        child: Center(
          child: Text(
            text,
            style:
                Styles.mediumText(color: active ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}

enum AuthType { LOGIN, REGISTER }

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key, required this.loginCubit});
  final LoginCubit loginCubit;

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool obsecure = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormTextField(
          constraints: BoxConstraints(maxHeight: 52.h, minHeight: 52.h),
          fillColor: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(20.r),
          style: TextStyle(fontSize: 30.sp, color: AppColors.QUANTITY_COLOR),
          controller: widget.loginCubit.emailTextController,
          // label: 'E-mail or phone number',
          hint: LocaleKeys.emailOrPhone.localize,
          prefix: Icon(
            Icons.email,
            color: AppColors.GREY_DARK_COLOR,
            size: 40.w,
          ),
          action: (v) {},
        ),
        const Sizer(),
        FormTextField(
          constraints: BoxConstraints(maxHeight: 52.h, minHeight: 52.h),
          fillColor: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(20.r),
          style: TextStyle(fontSize: 30.sp, color: AppColors.QUANTITY_COLOR),
          controller: widget.loginCubit.passwordTextController,
          // label: 'Password',
          hint: LocaleKeys.password.localize,
          obsecure: obsecure,
          prefix: GestureDetector(
            onTap: () {
              setState(() {
                obsecure = !obsecure;
              });
            },
            child: Icon(
              obsecure ? Icons.visibility_off : Icons.visibility,
              color: AppColors.GREY_DARK_COLOR,
              size: 40.w,
            ),
          ),
          action: (v) {},
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextAppButton(
                style: Styles.smallText(
                    fontSize: 40.sp, color: Theme.of(context).primaryColor),
                label: LocaleKeys.forgetPassword.localize,
                onPressed: () => context.push(Routes.FORGOTPASSWORD)),
          ],
        ),
        // Sizer(height: ,),
        // Spacer(),
        // DefaultButton(
        //   width: double.infinity,
        //   label: 'Login',
        //   onPressed: widget.loginCubit.login,
        // ),
        // Sizer(),
        // Column(
        //   children: [
        const Sizer(),
        Label(
          text: LocaleKeys.orContinueWith.localize,
          style: Styles.mediumText(color: Colors.grey),
        ),
        const Sizer(),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: LocaleKeys.google.localize,
                backColor: AppColors.LIGHT_GRAY_COLOR,
                textColor: Colors.black,
                icon: FontAwesomeIcons.google,
                onPressed: widget.loginCubit.signInWithGoogle,
              ),
            ),
            const Sizer(),
            Expanded(
              child: AppButton(
                label: LocaleKeys.facebook.localize,
                backColor: AppColors.LIGHT_GRAY_COLOR,
                textColor: Colors.black,
                icon: FontAwesomeIcons.facebook,
                onPressed: widget.loginCubit.signInWithFacebook,
              ),
            ),
            if (Platform.isIOS) const Sizer(),
            if (Platform.isIOS)
              Expanded(
                child: AppButton(
                  label: 'Apple',
                  backColor: AppColors.LIGHT_GRAY_COLOR,
                  textColor: Colors.black,
                  icon: FontAwesomeIcons.apple,
                  onPressed: widget.loginCubit.signInWithApple,
                ),
              ),
          ],
        ),
        //     Sizer(),
        //     RichText(
        //       text: TextSpan(
        //         children: [
        //           TextSpan(
        //             text: "Doesn't have account? ",
        //             style: Styles.headerText(color: Colors.grey),
        //           ),
        //           TextSpan(
        //             text: "Register",
        //             recognizer: TapGestureRecognizer()
        //               ..onTap = () => context.push(Routes.REGISTER),
        //             style: Styles.headerText(color: Colors.black),
        //           ),
        //         ],
        //       ),
        //     )
        //   ],
        // ),
      ],
    );
  }
}

// class RegisterWidget extends StatelessWidget {
//   const RegisterWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  bool obsecure = true;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final registerCubit = context.read<RegisterCubit>();
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {},
      child: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: Form(
          key: formKey,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              children: [
                FormTextField(
                  constraints: BoxConstraints(maxHeight: 52.h, minHeight: 52.h),
                  fillColor: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(20.r),
                  controller: registerCubit.firstNameController,
                  // label: 'E-mail or phone number',
                  style: const TextStyle(color: AppColors.QUANTITY_COLOR),
                  hint: LocaleKeys.firstName.localize,
                  prefix: Icon(
                    Icons.person_2_rounded,
                    color: AppColors.GREY_DARK_COLOR,
                    size: 40.w,
                  ),
                  action: (v) {},
                ),

                Sizer(
                  height: 30.h,
                ),
                FormTextField(
                  constraints: BoxConstraints(maxHeight: 52.h, minHeight: 52.h),
                  fillColor: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(20.r),
                  controller: registerCubit.lastNameController,
                  style: const TextStyle(color: AppColors.QUANTITY_COLOR),
                  // label: 'E-mail or phone number',
                  hint: LocaleKeys.lastName.localize,
                  prefix: Icon(
                    Icons.person_2_rounded,
                    color: AppColors.GREY_DARK_COLOR,
                    size: 40.w,
                  ),
                  action: (v) {},
                ),
                Sizer(
                  height: 30.h,
                ),
                FormTextField(
                  constraints: BoxConstraints(maxHeight: 52.h, minHeight: 52.h),
                  fillColor: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(20.r),
                  controller: registerCubit.emailTextController,
                  // label: 'E-mail or phone number',
                  style: const TextStyle(color: AppColors.QUANTITY_COLOR),
                  hint: LocaleKeys.emailOrPhone.localize,
                  prefix: Icon(
                    Icons.email,
                    color: AppColors.GREY_DARK_COLOR,
                    size: 40.w,
                  ),
                  action: (v) {},
                ),
                Sizer(
                  height: 30.h,
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Text(LocaleKeys.gender.localize,
                            style: Styles.mediumText(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w400))),
                    Flexible(
                      child: Row(
                        children: [
                          Expanded(
                              child: BadgedLabel(
                                  onTap: () {
                                    registerCubit.isMale = true;

                                    setState(() {});
                                  },
                                  height: kToolbarHeight.h,
                                  isCentered: true,
                                  close: false,
                                  isBordered: !registerCubit.isMale,
                                  color: registerCubit.isMale
                                      ? AppColors.PRIMARY_COLOR
                                      : Colors.transparent,
                                  textColor: registerCubit.isMale
                                      ? AppColors.AUTH_CONTAINER_COLOR
                                      : Theme.of(context).primaryColor,
                                  label: 'male'.localize)),
                          SizedBox(
                            width: 14.h,
                          ),
                          Expanded(
                            child: BadgedLabel(
                              onTap: () {
                                registerCubit.isMale = false;

                                setState(() {});
                              },
                              height: kToolbarHeight.h,
                              isCentered: true,
                              isBordered: true,
                              close: false,
                              textColor: registerCubit.isMale
                                  ? Theme.of(context).primaryColor
                                  : AppColors.AUTH_CONTAINER_COLOR,
                              color: registerCubit.isMale
                                  ? Colors.transparent
                                  : AppColors.PRIMARY_COLOR,
                              label: 'female'.localize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Sizer(
                  height: 30.h,
                ),
                FormTextField(
                  style: const TextStyle(color: AppColors.QUANTITY_COLOR),
                  constraints: BoxConstraints(maxHeight: 52.h, minHeight: 52.h),
                  fillColor: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(20.r),
                  controller: registerCubit.passwordTextController,
                  // label: 'Password',
                  hint: LocaleKeys.password.localize,
                  obsecure: obsecure,
                  prefix: GestureDetector(
                    onTap: () {
                      setState(() {
                        obsecure = !obsecure;
                      });
                    },
                    child: Icon(
                      obsecure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.GREY_DARK_COLOR,
                      size: 40.w,
                    ),
                  ),
                  action: (v) {},
                ),
                Sizer(
                  height: 30.h,
                ),
                FormTextField(
                  style: const TextStyle(color: AppColors.QUANTITY_COLOR),
                  constraints: BoxConstraints(maxHeight: 52.h, minHeight: 52.h),
                  fillColor: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(20.r),
                  controller: registerCubit.confirmPasswordTextController,
                  // label: 'Password',
                  hint:
                      '${LocaleKeys.confirm.localize} ${LocaleKeys.password.localize}',
                  obsecure: obsecure,
                  prefix: GestureDetector(
                    onTap: () {
                      setState(() {
                        obsecure = !obsecure;
                      });
                    },
                    child: Icon(
                      obsecure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.GREY_DARK_COLOR,
                      size: 40.w,
                    ),
                  ),
                  action: (v) {},
                ),
                Sizer(
                  height: 30.h,
                ),
                FormTextField(
                  validator: (p0) {
                    return null;
                  },
                  constraints: BoxConstraints(maxHeight: 52.h, minHeight: 52.h),
                  fillColor: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(20.r),
                  // controller: registerCubit.firstNameController,
                  // label: 'E-mail or phone number',
                  style: const TextStyle(color: AppColors.QUANTITY_COLOR),
                  hint: LocaleKeys.code.localize,
                  prefix: Container(
                    margin: const EdgeInsets.all(9),
                    width: 20,
                    height: 20.h,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.GREY_DARK_COLOR,
                      size: 40.w,
                    ),
                  ),
                  action: (v) {},
                ),
                Sizer(
                  height: 60.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${LocaleKeys.iAcceptAll.localize} ',
                      style: Styles.mediumText(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      LocaleKeys.conditions.localize,
                      style: Styles.mediumText(
                          color: const Color(0xFF4898D6),
                          fontWeight: FontWeight.w600),
                    ),
                    Checkbox(
                      activeColor: Colors.red,
                      value: registerCubit.accept,
                      onChanged: (value) {
                        setState(() {
                          registerCubit.accept = value ?? false;
                        });
                      },
                    )
                  ],
                ),
                // Label(
                //   text: 'Or Continue with',
                //   style: Styles.mediumText(color: Colors.grey),
                // ),
                // Sizer(),
                // Row(
                //   children: [
                //     Expanded(
                //       child: AppButton(
                //         label: 'Google',
                //         backColor: AppColors.LIGHT_GRAY_COLOR,
                //         textColor: Colors.black,
                //         icon: FontAwesomeIcons.google,
                //         onPressed: () {},
                //       ),
                //     ),
                //     Sizer(),
                //     Expanded(
                //       child: AppButton(
                //         label: 'Facebook',
                //         backColor: AppColors.LIGHT_GRAY_COLOR,
                //         textColor: Colors.black,
                //         icon: FontAwesomeIcons.facebook,
                //         onPressed: () {},
                //       ),
                //     ),
                //   ],
                // ),
                // Sizer(height: 20.h),
                // RichText(
                //   text: TextSpan(
                //     children: [
                //       TextSpan(
                //         text: "Does have account? ",
                //         style: Styles.headerText(
                //           color: Colors.grey,
                //         ),
                //       ),
                //       TextSpan(
                //         text: "Login",
                //         recognizer: TapGestureRecognizer()
                //           ..onTap = () => context.push(Routes.LOGIN),
                //         style: Styles.headerText(
                //           color: Colors.black,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 80.h,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
