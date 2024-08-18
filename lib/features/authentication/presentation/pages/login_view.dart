import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/confirm_password_text_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/first_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/last_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/password_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/register_cubit/register_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/get_wallet_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../common/widgets/stateless/buttons/default_button.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/error/failure.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../controllers/login_cubit/login_cubit.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  AuthType selectedAuth = AuthType.LOGIN;
  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();
    final registerCubit = context.read<RegisterCubit>();
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterError) {
          showErrorMessage(context, getFailureMessage(state.failure, context));
        } else if (state is OTPSent) {
          showSuccessMessage(context, 'OTP Sent successfully');
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
        listener: (context, state) {
          if (state is LoginError) {
            context.pop();
            showErrorMessage(
              context,
              getFailureMessage(
                state.failure,
                context,
              ),
            );
          } else if (state is LoginSuccess) {
            // context.pop();
            context.go(Routes.HOME);
            context.pop();
            context.read<UserCubit>().setLogin(true);
            context.read<UserCubit>().getUser();
            context.read<GetWalletCubit>().getWallet();

            showSuccessMessage(context, 'welcome back');
          } else if (state is LoginLoading) {
            // showAdaptiveDialog(
            //     context: context,
            //     builder: (context) => const Center(
            //           child: CircularProgressIndicator.adaptive(),
            //         ));
          } else if (state is LoginError) {
            context.pop();
          }
        },
        child: Scaffold(
          appBar: const BackAppBar(),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: loginCubit.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Stack(
                children: [
                  ListView(
                    children: [
                      Image.asset(
                        Assets.logo,
                        width: 200,
                        height: 200,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          chooseAuthWidget(
                              onTap: () {
                                setState(() {
                                  selectedAuth = AuthType.LOGIN;
                                });
                              },
                              active: selectedAuth == AuthType.LOGIN,
                              text: "Login",
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(50),
                                bottomLeft: Radius.circular(50),
                              )),
                          chooseAuthWidget(
                              onTap: () {
                                setState(() {
                                  selectedAuth = AuthType.REGISTER;
                                });
                              },
                              active: selectedAuth == AuthType.REGISTER,
                              text: "Register",
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(50),
                                bottomRight: Radius.circular(50),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      selectedAuth == AuthType.LOGIN
                          ? LoginWidget(
                              loginCubit: loginCubit,
                            )
                          : const RegisterWidget()
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: selectedAuth == AuthType.REGISTER
                        ? DefaultButton(
                            label: 'Register',
                            width: double.infinity,
                            onPressed: () {
                              if (registerCubit.accept) {
                                registerCubit.register;
                              } else {
                                showErrorMessage(
                                    context,
                                    getFailureMessage(
                                        const ServerFailure(
                                            message:
                                                "Please accept the terms and conditions to continue."),
                                        context));
                              }
                            },
                          )
                        : DefaultButton(
                            width: double.infinity,
                            label: 'Login',
                            onPressed: loginCubit.login,
                          ),
                  )
                ],
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
        height: 54,
        width: 165,
        decoration: BoxDecoration(
          color: active ? AppColors.PRIMARY_COLOR : const Color(0xFFEEEEEE),
          borderRadius: borderRadius,
        ),
        child: Center(
          child: Text(
            text,
            style: Styles.mediumText(
                fontSize: 18, color: active ? Colors.white : Colors.black),
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
          constraints: const BoxConstraints(maxHeight: 52, minHeight: 52),
          fillColor: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(20),
          style: const TextStyle(fontSize: 16, color: AppColors.QUANTITY_COLOR),
          controller: widget.loginCubit.emailTextController,
          // label: 'E-mail or phone number',
          hint: 'Email Or Phone',
          prefix: const Icon(Icons.email, color: AppColors.QUANTITY_COLOR),
          action: (v) {},
        ),
        const Sizer(
          height: 30,
        ),
        FormTextField(
          constraints: const BoxConstraints(maxHeight: 52, minHeight: 52),
          fillColor: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(20),
          style: const TextStyle(fontSize: 16, color: AppColors.QUANTITY_COLOR),
          controller: widget.loginCubit.passwordTextController,
          // label: 'Password',
          hint: "Password",
          obsecure: obsecure,
          prefix: GestureDetector(
            onTap: () {
              setState(() {
                obsecure = !obsecure;
              });
            },
            child: Icon(obsecure ? Icons.visibility_off : Icons.visibility,
                color: AppColors.QUANTITY_COLOR),
          ),
          action: (v) {},
        ),
        const Sizer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextAppButton(
                style: const TextStyle(color: Colors.red),
                label: 'Forgot Password?',
                onPressed: () => context.push(Routes.FORGOTPASSWORD)),
          ],
        ),
        // const Sizer(height: ,),
        // Spacer(),
        // DefaultButton(
        //   width: double.infinity,
        //   label: 'Login',
        //   onPressed: widget.loginCubit.login,
        // ),
        // const Sizer(),
        // Column(
        //   children: [
        //     const Sizer(),
        //     Label(
        //       text: 'Or Continue with',
        //       style: Styles.mediumText(color: Colors.grey),
        //     ),
        //     const Sizer(),
        //     Row(
        //       children: [
        //         Expanded(
        //           child: AppButton(
        //             label: 'Google',
        //             backColor: AppColors.LIGHT_GRAY_COLOR,
        //             textColor: Colors.black,
        //             icon: FontAwesomeIcons.google,
        //             onPressed: widget.loginCubit.signInWithGoogle,
        //           ),
        //         ),
        //         const Sizer(),
        //         Expanded(
        //           child: AppButton(
        //             label: 'Facebook',
        //             backColor: AppColors.LIGHT_GRAY_COLOR,
        //             textColor: Colors.black,
        //             icon: FontAwesomeIcons.facebook,
        //             onPressed: widget.loginCubit.signInWithFacebook,
        //           ),
        //         ),
        //         if (Platform.isIOS) const Sizer(),
        //         if (Platform.isIOS)
        //           Expanded(
        //             child: AppButton(
        //               label: 'Apple',
        //               backColor: AppColors.LIGHT_GRAY_COLOR,
        //               textColor: Colors.black,
        //               icon: FontAwesomeIcons.apple,
        //               onPressed: widget.loginCubit.signInWithApple,
        //             ),
        //           ),
        //       ],
        //     ),
        //     const Sizer(),
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
  @override
  Widget build(BuildContext context) {
    final registerCubit = context.read<RegisterCubit>();
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: registerCubit.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              children: [
                FormTextField(
                  constraints:
                      const BoxConstraints(maxHeight: 52, minHeight: 52),
                  fillColor: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(20),
                  style: const TextStyle(
                      fontSize: 16, color: AppColors.QUANTITY_COLOR),
                  controller: registerCubit.firstNameController,
                  // label: 'E-mail or phone number',
                  hint: 'First Name',
                  prefix: const Icon(Icons.person_2_rounded,
                      color: AppColors.QUANTITY_COLOR),
                  action: (v) {},
                ),
                const Sizer(
                  height: 30,
                ),
                FormTextField(
                  constraints:
                      const BoxConstraints(maxHeight: 52, minHeight: 52),
                  fillColor: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(20),
                  style: const TextStyle(
                      fontSize: 16, color: AppColors.QUANTITY_COLOR),
                  controller: registerCubit.lastNameController,
                  // label: 'E-mail or phone number',
                  hint: 'Last Name',
                  prefix: const Icon(Icons.person_2_rounded,
                      color: AppColors.QUANTITY_COLOR),
                  action: (v) {},
                ),
                const Sizer(
                  height: 30,
                ),
                FormTextField(
                  constraints:
                      const BoxConstraints(maxHeight: 52, minHeight: 52),
                  fillColor: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(20),
                  style: const TextStyle(
                      fontSize: 16, color: AppColors.QUANTITY_COLOR),
                  controller: registerCubit.emailTextController,
                  // label: 'E-mail or phone number',
                  hint: 'Email Or Phone',
                  prefix:
                      const Icon(Icons.email, color: AppColors.QUANTITY_COLOR),
                  action: (v) {},
                ),
                const Sizer(
                  height: 30,
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Text('Gender',
                            style: Styles.headerText(
                                fontSize: 17,
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
                                  height: kToolbarHeight * .7,
                                  isCentered: true,
                                  isBordered: !registerCubit.isMale,
                                  color: registerCubit.isMale
                                      ? AppColors.PRIMARY_COLOR
                                      : Colors.white,
                                  textColor: registerCubit.isMale
                                      ? Colors.white
                                      : Theme.of(context)
                                          .scaffoldBackgroundColor,
                                  label: 'Male')),
                          const SizedBox(
                            width: 7,
                          ),
                          Expanded(
                            child: BadgedLabel(
                              onTap: () {
                                registerCubit.isMale = false;

                                setState(() {});
                              },
                              height: kToolbarHeight * .7,
                              isCentered: true,
                              isBordered: true,
                              textColor: registerCubit.isMale
                                  ? Colors.black
                                  : Theme.of(context).primaryColor,
                              color: registerCubit.isMale
                                  ? Colors.white
                                  : AppColors.PRIMARY_COLOR,
                              label: 'Female',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Sizer(height: 30),
                FormTextField(
                  constraints:
                      const BoxConstraints(maxHeight: 52, minHeight: 52),
                  fillColor: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(20),
                  style: const TextStyle(
                      fontSize: 16, color: AppColors.QUANTITY_COLOR),
                  controller: registerCubit.passwordTextController,
                  // label: 'Password',
                  hint: "Password",
                  obsecure: obsecure,
                  prefix: GestureDetector(
                    onTap: () {
                      setState(() {
                        obsecure = !obsecure;
                      });
                    },
                    child: Icon(
                      obsecure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.QUANTITY_COLOR,
                    ),
                  ),
                  action: (v) {},
                ),
                const Sizer(
                  height: 30,
                ),
                FormTextField(
                  constraints:
                      const BoxConstraints(maxHeight: 52, minHeight: 52),
                  fillColor: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(20),
                  style: const TextStyle(
                      fontSize: 16, color: AppColors.QUANTITY_COLOR),
                  controller: registerCubit.firstNameController,
                  // label: 'E-mail or phone number',
                  hint: 'Referral Code(Optional)',
                  prefix: Container(
                    margin: const EdgeInsets.all(9),
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.QUANTITY_COLOR,
                    ),
                  ),
                  action: (v) {},
                ),
                const Sizer(
                  height: 30,
                ),
                const Sizer(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "I Accept All",
                      style: Styles.mediumText(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      " Terms,Rules & Conditions",
                      style: Styles.mediumText(
                          color: const Color(0xFF4898D6),
                          fontSize: 16,
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
                // const Sizer(),
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
                //     const Sizer(),
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
                // const Sizer(height: 20),
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
                const SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
