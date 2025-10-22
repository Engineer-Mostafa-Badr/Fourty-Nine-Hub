import 'dart:developer';
import 'dart:io';

// import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/ads/interstitial_ad_model.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/login_cubit/login_state.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/register_cubit/register_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/widgets/birth_date_field.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/form/text_fields/email_phone_text_form_field.dart';
import '../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../common/widgets/stateless/buttons/default_button.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/localization/locales.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../controllers/login_cubit/login_cubit.dart';
import '../controllers/verify_otp_cubit/verify_otp_cubit.dart';

enum AuthType { LOGIN, REGISTER }

class LoginView extends StatefulWidget {
  AuthType authType;

  LoginView({super.key, required this.authType});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class LoginWidget extends StatefulWidget {
  final LoginCubit loginCubit;

  const LoginWidget({super.key, required this.loginCubit});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

// class RegisterWidget extends StatelessWidget {
//   const RegisterWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

class RegisterWidget extends StatefulWidget {
  final GlobalKey<FormState> formKeyRegister;

  const RegisterWidget({super.key, required this.formKeyRegister});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _LoginViewState extends State<LoginView> {
  // AuthType selectedAuth = AuthType.LOGIN;
  ScrollController scrollController = ScrollController();
  final formKeyLogin = GlobalKey<FormState>();
  final formKeyRegister = GlobalKey<FormState>();
  bool _isLoadingDialogShown = false;

  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();
    final registerCubit = context.read<RegisterCubit>();
    final verifyOtpCubit = context.read<VerifyOtpCubit>();
    // if (MediaQuery.of(context).viewInsets.bottom != 0.0) {
    //   log("lllllllllllllllllllllllllll");
    //   scrollController.jumpTo(409);
    // }
    // log(MediaQuery.of(context).viewInsets.bottom.toString(),
    //     name: "OpenKeyboard");
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) async {
        if (state is RegisterError) {
          // String  isVeryfied = getFailureMessage(state.failure, context).toString();
          // print("Print here ${isVeryfied}");

          showErrorMessage(context, getFailureMessage(state.failure, context));
        } else if (state is RegisterConfirmPassword) {
          showErrorMessage(
              context,
              context.isArabic
                  ? 'كلمة المرور غير متطابقة'
                  : 'Password does not match');
        } else if (state is OTPSent) {
          showSuccessMessage(context, LocaleKeys.oTP.localize);
          context.go(
            Routes.VERIFYMAIL,
            extra: registerCubit.emailTextController.text,
          );
        } else if (state is OTPPhoneSent) {
          showSuccessMessage(context, LocaleKeys.oTP.localize);
          context.go(
            Routes.registerVerifyPhoneOTP,
            extra: registerCubit.emailTextController.text,
          );
        } else if (state is RegisterByPhone) {
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

              // Update notification count after successful registration
              context
                  .read<GetUnreadNotificationsCountCubit>()
                  .getUnreadNotificationsCount();

              // Navigator.pop(context);
              // context.push(Routes.HOME);

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  context.go(
                    Routes.CompleteRegisterWelcomeScreen,
                    extra: context.isArabic
                        ? state.giftMessageEntity.ar
                        : state.giftMessageEntity.en,
                  );
                }
              });
            });
        } else if (state is RegisterSuccess) {
          await context.read<UserCubit>().setLogin(true);
          await context.read<UserCubit>().getUser();
          // Update notification count after successful registration
          context
              .read<GetUnreadNotificationsCountCubit>()
              .getUnreadNotificationsCount();
          context.go(Routes.HOME);
        }
      },
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) async {
          if (state is LoginError) {
            if (_isLoadingDialogShown) {
              Navigator.of(context).pop();
              _isLoadingDialogShown = false;
            }
            String isVerified =
                getFailureMessage(state.failure, context).toString();
            print("Print here $isVerified");
            if (isVerified == "Email not verified") {
              context.go(
                Routes.VERIFYMAIL,
                extra: loginCubit.emailTextController.text,
              );
              // Call the resendOTP method from VerifyOtpCubit
              verifyOtpCubit.resendOTP(
                  loginCubit.emailTextController.text, true);
            }
            showErrorMessage(
              context,
              getFailureMessage(
                state.failure,
                context,
              ),
            );
          } else if (state is LoginSuccess) {
            // await CacheManager.saveAccessToken(
            //     state.userTokensEntity.accessToken);
            // await CacheManager.saveRefreshToken(
            //     state.userTokensEntity.refreshToken);
            // await BackgroundService.reStartWebSocketService(
            //     state.userTokensEntity.accessToken);
            if (!_isLoadingDialogShown) {
              showLoadingDialog(context);
              _isLoadingDialogShown = true;
            }

            serviceLocator<UserCubit>()
              ..setLogin(true)
              ..attachToken()
              ..getUser().then((value) async {
                String? accessToken = await CacheManager.getAccessToken();
                String? refreshToken = await CacheManager.getRefreshToken();
                debugPrint(
                    '/////////////////////////////////////////////////////////////////////////');
                debugPrint('Refresh Token: $refreshToken');
                debugPrint('Access Token: $accessToken');
                debugPrint(
                    '/////////////////////////////////////////////////////////////////////////');
                debugPrint(serviceLocator<UserCubit>().state.data.toString());

                // Update notification count after successful login
                context
                    .read<GetUnreadNotificationsCountCubit>()
                    .getUnreadNotificationsCount();

                // Navigator.pop(context);
                // Navigator.pop(context);
                context.pushReplacement(Routes.HOME);
              });

            showSuccessMessage(context, LocaleKeys.welcomeBack.localize);
          } else if (state is LoginLoading) {
            if (!_isLoadingDialogShown) {
              showLoadingDialog(context);
              _isLoadingDialogShown = true;
            }
          } else if (state is SocialAuthState) {
            // Handle Social Auth States
            _handleSocialAuthState(state);
          }
        },
        child: PopScope(
          onPopInvoked: (bool value) async {
            // Logout while keeping important settings (onboarding, language, dark mode)
            // This also sets ISLOGIN to false
            await CacheManager.logoutKeepingSettings();

            // Remove token from API consumer
            final userCubit = serviceLocator<UserCubit>();
            userCubit.removeToken();

            // Navigate to home in guest mode
            context.go(Routes.HOME);
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: CustomScaffold(
              enableCustomAppBar: true,
              resizeToAvoidBottomInset: true,
              appBar: const BackAppBar(),
              body: Padding(
                padding: EdgeInsets.all(16.0.w),
                child: Form(
                    key: formKeyLogin,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: ListView(
                      physics: const BouncingScrollPhysics(parent: ClampingScrollPhysics()),
                      controller: scrollController,
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
                                ManageVibration.vibrate();
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
                                ManageVibration.vibrate();
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
                            : RegisterWidget(
                                formKeyRegister: formKeyRegister,
                              ),
                        // SizedBox(
                        //   height: widget.authType == AuthType.LOGIN
                        //       ? MediaQuery.of(context).viewInsets.bottom != 0.0
                        //           ? 20
                        //           : 100.h
                        //       : 0,
                        // ),
                        const Sizer(
                          height: 50,
                        ),
                        widget.authType == AuthType.REGISTER
                            ? DefaultButton(
                                labelStyle: TextStyle(
                                    fontSize: 35.sp,
                                    color: AppColors.AUTH_CONTAINER_COLOR),
                                label: LocaleKeys.confirm.localize,
                                width: double.infinity,
                                onPressed: () {
                                  ManageVibration.vibrate();
                                  if (registerCubit.accept) {
                                    if (formKeyRegister.currentState!
                                        .validate()) {
                                      if (registerCubit.isLessThan14YearsOld(
                                          registerCubit
                                              .birthDateTextController.text
                                              .trim())) {
                                        showErrorMessage(
                                            context,
                                            context.isArabic
                                                ? 'يجب ان يكون المستخدم اكبر من 14 سنة'
                                                : 'The user must be older than 14 years');
                                        return;
                                      }

                                      registerCubit.register();
                                    }
                                  } else {
                                    showErrorMessage(
                                        context,
                                        getFailureMessage(
                                            ServerFailure(
                                                message: LocaleKeys
                                                    .terms.localize),
                                            context));
                                  }
                                },
                              )
                            : DefaultButton(
                                width: double.infinity,
                                label: LocaleKeys.confirm.localize,
                                labelStyle: TextStyle(
                                    fontSize: 35.sp,
                                    color: AppColors.AUTH_CONTAINER_COLOR),
                                onPressed: () {
                                  ManageVibration.vibrate();
                                  log("message");
                                  loginCubit.login(formKeyLogin);
                                },
                              ),
                      ],
                    )),
              ),
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

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    log(widget.authType.toString(),
        name: "lllllllllllllllllllllllllllllllllllll");
    // wid, required AuthType authTypeget.authType = widget.authType;
    // log(widget.authType.toString(), name: "lllllllllllllllllllllllllllllllllllll");
  }

  Future<void> _handleLoginSuccess(LoginSuccess state) async {
    _showLoadingIfNeeded();

    try {
      final userCubit = serviceLocator<UserCubit>();
      await userCubit.setLogin(true);
      userCubit.attachToken();

      await userCubit.getUser();

      String? accessToken = await CacheManager.getAccessToken();
      String? refreshToken = await CacheManager.getRefreshToken();

      log('Login successful!');
      log('Access Token: $accessToken');
      log('Refresh Token: $refreshToken');
      log('User data: ${userCubit.state.data}');

      // Update notification count after successful login
      context
          .read<GetUnreadNotificationsCountCubit>()
          .getUnreadNotificationsCount();

      _hideLoadingIfShown();
      context.pushReplacement(Routes.HOME);
      showSuccessMessage(context, LocaleKeys.welcomeBack.localize);
    } catch (e) {
      _hideLoadingIfShown();
      log('Error in login success handler: $e');
      showErrorMessage(context, 'An error occurred during login');
    }
  }

  Future<void> _handleSocialAuthState(SocialAuthState state) async {
    switch (state.status) {
      case AuthStatus.authenticating:
        _showLoadingIfNeeded();
        break;

      case AuthStatus.authenticated:
        if (state.userTokensEntity != null) {
          await _handleSocialLoginSuccess(state.userTokensEntity!);
        }
        break;

      case AuthStatus.authenticateError:
        _hideLoadingIfShown();
        String errorMessage = 'Social login failed';
        if (state.error != null) {
          errorMessage = getFailureMessage(state.error!, context);
        }
        showErrorMessage(context, errorMessage);
        break;

      case AuthStatus.authenticateCanceled:
        _hideLoadingIfShown();
        // User canceled - no error message needed
        break;

      default:
        _hideLoadingIfShown();
        break;
    }
  }

  Future<void> _handleSocialLoginSuccess(UserTokensEntity userTokens) async {
    try {
      final userCubit = serviceLocator<UserCubit>();
      await userCubit.setLogin(true);
      userCubit.attachToken();

      await userCubit.getUser();

      String? accessToken = await CacheManager.getAccessToken();
      String? refreshToken = await CacheManager.getRefreshToken();

      log('Social login successful!');
      log('Access Token: $accessToken');
      log('Refresh Token: $refreshToken');

      // Update notification count after successful social login
      context
          .read<GetUnreadNotificationsCountCubit>()
          .getUnreadNotificationsCount();

      _hideLoadingIfShown();
      context.pushReplacement(Routes.HOME);
      showSuccessMessage(context, LocaleKeys.welcomeBack.localize);
    } catch (e) {
      _hideLoadingIfShown();
      log('Error in social login success handler: $e');
      showErrorMessage(context, 'An error occurred during social login');
    }
  }

  Future<void> _handleGuestSuccess(LoginGuestSuccess state) async {
    _hideLoadingIfShown();
    // Handle guest login success
    context.pushReplacement(Routes.HOME);
  }

  void _showLoadingIfNeeded() {
    if (!_isLoadingDialogShown) {
      showLoadingDialog(context);
      _isLoadingDialogShown = true;
    }
  }

  void _hideLoadingIfShown() {
    if (_isLoadingDialogShown) {
      Navigator.of(context).pop();
      _isLoadingDialogShown = false;
    }
  }
}

class _LoginWidgetState extends State<LoginWidget> {
  bool obsecure = true;
  final FocusNode emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final loginCubit = BlocProvider.of<LoginCubit>(context);

    return Column(
      children: [
        EmailOrPhoneTextFormField(
          autofillHints: const [AutofillHints.email],
          currentController: loginCubit.emailTextController,
          borderColor: Colors.black,
          hint:
              '${LocaleKeys.email.localize} / ${LocaleKeys.phoneNumber.localize}',
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              Assets.phoneMail,
              color: AppColors.GREY_DARK_COLOR,
              width: 14,
              height: 14,
            ),
          ),
          currentFocusNode: emailFocusNode, // <-- Use this
          isRequired: true,
        ),
        const Sizer(),
        DefaultTextFormField(
          // constraints: BoxConstraints(maxHeight: 52.h, minHeight: 52.h),
          // fillColor: const Color(0xFFEEEEEE),
          borderColor: Colors.black,
          currentController: loginCubit.passwordTextController,
          hint: LocaleKeys.password.localize,
          obscureText: obsecure,
          prefixIcon: GestureDetector(
            onTap: () {
              ManageVibration.vibrate();
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
          validator: (v) {
            if (v!.isEmpty) {
              return LocaleKeys.passwordRequired.localize;
            }
            return null;
          },
        ),
        const Sizer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextAppButton(
                style: Styles.smallText(
                    fontSize: 24, color: Theme.of(context).primaryColor),
                label: LocaleKeys.forgetPassword.localize,
                onPressed: () => context.push(Routes.FORGOTPASSWORD)),
          ],
        ),
        const Sizer(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    // Request focus after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      emailFocusNode.requestFocus();
    });
  }
}

class _RegisterWidgetState extends State<RegisterWidget> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  final FocusNode nameFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final registerCubit = context.read<RegisterCubit>();
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {},
      child: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: Form(
          key: widget.formKeyRegister,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DefaultTextFormField(
                        borderColor: Colors.black,
                        currentController: registerCubit.firstNameController,
                        hint: LocaleKeys.firstName.localize,
                        prefixIcon: Icon(
                          Icons.person_2_rounded,
                          color: AppColors.GREY_DARK_COLOR,
                          size: 40.w,
                        ),
                        // action: (v) {},
                        validator: (v) {
                          if (v!.isEmpty) {
                            return LocaleKeys.firstNameRequired.localize;
                          }
                          return null;
                        },
                      ),
                    ),
                    Sizer(
                      width: 30.h,
                    ),
                    Expanded(
                      child: DefaultTextFormField(
                        // fillColor: const Color(0xFFEEEEEE),
                        borderColor: Colors.black,
                        currentController: registerCubit.lastNameController,
                        // style: const TextStyle(color: AppColors.QUANTITY_COLOR),
                        // label: 'E-mail or phone number',
                        hint: LocaleKeys.lastName.localize,
                        prefixIcon: Icon(
                          Icons.person_2_rounded,
                          color: AppColors.GREY_DARK_COLOR,
                          size: 40.w,
                        ),
                        validator: (v) {
                          if (v!.isEmpty) {
                            return LocaleKeys.lastNameRequired.localize;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                Sizer(
                  height: 30.h,
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(LocaleKeys.gender.localize,
                                style: Styles.mediumText(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w400)),
                          ],
                        )),
                    Flexible(
                      child: Row(
                        children: [
                          Expanded(
                              child: BadgedLabel(
                                  hasHighlightColor: true,
                                  hasSplashColor: true,
                                  onTap: () {
                                    ManageVibration.vibrate();
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
                              hasHighlightColor: true,
                              hasSplashColor: true,
                              onTap: () {
                                ManageVibration.vibrate();
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
                DefaultTextFormField(
                  currentFocusNode: nameFocusNode,

                  // fillColor: const Color(0xFFEEEEEE),
                  borderColor: Colors.black,
                  currentController: registerCubit.userNameController,
                  inputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
                  ],
                  hint: 'Example: User123',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      Assets.aMailIcon,
                      color: AppColors.GREY_DARK_COLOR,
                    ),
                  ),
                  validator: (v) {
                    if (v!.isEmpty) {
                      return LocaleKeys.userNameRequired.localize;
                    }
                    return null;
                  },
                  // action: (v) {},
                ),
                Sizer(
                  height: 30.h,
                ),
                BirthDatePicker(
                    controller: registerCubit.birthDateTextController,
                    onDateChanged: (date) {
                      registerCubit.birthDate = date ?? '';
                      setState(() {});
                      print(
                          "registerCubit.birthDate ${registerCubit.birthDate}");
                      print("registerCubit.birthDate $date");
                    }),
                Sizer(
                  height: 30.h,
                ),
                EmailOrPhoneTextFormField(
                  borderColor: Colors.black,
                  currentController: registerCubit.emailTextController,
                  hint:
                      '${LocaleKeys.email.localize} / ${LocaleKeys.phoneNumber.localize}',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      Assets.phoneMail,
                      // color: AppColors.GREY_DARK_COLOR,
                      width: 14,
                      height: 14,
                    ),
                  ),
                  isRequired: true,
                ),
                Sizer(
                  height: 30.h,
                ),
                DefaultTextFormField(
                  // fillColor: const Color(0xFFEEEEEE),
                  borderColor: Colors.black,
                  currentController: registerCubit.passwordTextController,
                  hint: LocaleKeys.password.localize,
                  obscureText: obscurePassword,
                  prefixIcon: GestureDetector(
                    onTap: () {
                      ManageVibration.vibrate();
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    child: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.GREY_DARK_COLOR,
                      size: 40.w,
                    ),
                  ),
                  validator: (v) {
                    if (v!.isEmpty) {
                      return LocaleKeys.passwordRequired.localize;
                    }
                    return null;
                  },
                ),
                Sizer(
                  height: 30.h,
                ),
                DefaultTextFormField(
                  // fillColor: const Color(0xFFEEEEEE),
                  borderColor: Colors.black,
                  currentController:
                      registerCubit.confirmPasswordTextController,
                  hint:
                      '${LocaleKeys.confirm.localize} ${LocaleKeys.password.localize}',
                  obscureText: obscureConfirmPassword,
                  prefixIcon: GestureDetector(
                    onTap: () {
                      ManageVibration.vibrate();
                      setState(() {
                        obscureConfirmPassword = !obscureConfirmPassword;
                      });
                    },
                    child: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.GREY_DARK_COLOR,
                      size: 40.w,
                    ),
                  ),
                  validator: (v) {
                    if (v!.isEmpty) {
                      return LocaleKeys.passwordRequired.localize;
                    }
                    return null;
                  },
                ),
                Sizer(
                  height: 30.h,
                ),
                DefaultTextFormField(
                  validator: (p0) {
                    return null;
                  },
                  borderColor: Colors.black,
                  // fillColor: const Color(0xFFEEEEEE),
                  currentController: registerCubit.referralId,
                  hint: LocaleKeys.code.localize,
                  prefixIcon: Container(
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
                ),
                Sizer(
                  height: 60.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${LocaleKeys.iAcceptAll.localize} ',
                      style: Styles.mediumText(
                        fontWeight: FontWeight.w600,
                        color: context.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    ClickableWidget(
                      onTap: () {
                        ManageVibration.vibrate();
                        AdInterstitialTop.loadIntersitialAd();
                        AdInterstitialTop.showInterstitialAd();
                        context.push(Routes.APPPOLICY, extra: true);
                      },
                      child: Text(
                        LocaleKeys.conditions.localize,
                        style: Styles.mediumText(
                            color: const Color(0xFF4898D6),
                            fontWeight: FontWeight.w600),
                      ),
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

  @override
  void initState() {
    super.initState();
    // Request focus after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameFocusNode.requestFocus();
    });
  }
}
