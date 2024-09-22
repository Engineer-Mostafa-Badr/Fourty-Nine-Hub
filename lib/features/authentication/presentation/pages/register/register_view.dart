// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:fourtyninehub/common/widgets/form/text_fields/confirm_password_text_field.dart';
// import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
// import 'package:fourtyninehub/common/widgets/form/text_fields/first_name_text_form_field.dart';
// import 'package:fourtyninehub/common/widgets/form/text_fields/last_name_text_form_field.dart';
// import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
// import 'package:fourtyninehub/core/error/failure.dart';
// import 'package:fourtyninehub/core/messages/messages.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/register_cubit/register_cubit.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../../common/widgets/dynamic/sizer.dart';
// import '../../../../../common/widgets/form/text_fields/password_text_form_field.dart';
// import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
// import '../../../../../common/widgets/stateless/buttons/app_button.dart';
// import '../../../../../common/widgets/stateless/buttons/default_button.dart';
// import '../../../../../common/widgets/stateless/labels/label.dart';
// import '../../../../../res/style/app_colors.dart';
// import '../../../../../res/style/styles.dart';
// import '../../../../../routes/routes.dart';
// import '../../controllers/user_cubit/user_cubit.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class RegisterView extends StatefulWidget {
//   RegisterView({super.key});
//
//   @override
//   State<RegisterView> createState() => _RegisterViewState();
// }
//
// class _RegisterViewState extends State<RegisterView> {
//   bool _obscureTextLogin = true;
//   @override
//   Widget build(BuildContext context) {
//     final registerCubit = context.read<RegisterCubit>();
//     return BlocListener<RegisterCubit, RegisterState>(
//       listener: (context, state) {
//         if (state is RegisterError) {
//           showErrorMessage(context, getFailureMessage(state.failure, context));
//         } else if (state is OTPSent) {
//           showSuccessMessage(context, 'OTP Sent successfully');
//           context.go(
//             Routes.VERIFYMAIL,
//             extra: registerCubit.emailTextController.text,
//           );
//         } else if (state is RegisterSuccess) {
//           context.read<UserCubit>().setLogin(true);
//           context.read<UserCubit>().getUser();
//           context.go(Routes.HOME);
//           context.pop();
//         }
//       },
//       child: Scaffold(
//         appBar: const BackAppBar(),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Form(
//             key: registerCubit.formKey,
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: FirstNameTextFormField(
//                           currentFocusNode: registerCubit.firstNameFocusNode,
//                           currentController: registerCubit.firstNameController,
//                           nextFocusNode: registerCubit.lastNameFocusNode,
//                         ),
//                       ),
//                       Sizer(),
//                       Expanded(
//                         child: LastNameTextFormField(
//                           currentFocusNode: registerCubit.lastNameFocusNode,
//                           currentController: registerCubit.lastNameController,
//                           nextFocusNode: registerCubit.emailFocusNode,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Sizer(),
//                   DefaultTextFormField(
//                     currentFocusNode: registerCubit.emailFocusNode,
//                     currentController: registerCubit.emailTextController,
//                     nextFocusNode: registerCubit.passwordFocusNode,
//                     keyboardType: TextInputType.emailAddress,
//                     suffixIcon: const Icon(Icons.email),
//                     hint: 'Email',
//                     validator: (v) {
//                       String pattern =
//                           r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
//                       RegExp regex = RegExp(pattern);
//                       if (!regex.hasMatch(v!)) {
//                         return 'invalid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   Sizer(),
//                   PasswordTextFormField(
//                     currentFocusNode: registerCubit.passwordFocusNode,
//                     currentController: registerCubit.passwordTextController,
//                     nextFocusNode: registerCubit.confirmPasswordFocusNode,
//                     suffixIcon: GestureDetector(
//                       onTap: _toggleLogin,
//                       child: Icon(
//                         _obscureTextLogin
//                             ? FontAwesomeIcons.eyeSlash
//                             : FontAwesomeIcons.eye,
//                         size: 18,
//                         color: AppColors.PRIMARY_COLOR,
//                       ),
//                     ),
//                     hint: 'Password',
//                   ),
//                   Sizer(),
//                   ConfirmPasswordTextFormField(
//                     currentFocusNode: registerCubit.confirmPasswordFocusNode,
//                     currentController:
//                         registerCubit.confirmPasswordTextController,
//                     passwordController: registerCubit.passwordTextController,
//                   ),
//                   Sizer(),
//                   StatefulBuilder(
//                     builder: (context, setState) {
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Gender : ',
//                               style: Styles.headerText(fontSize: 14.sp)),
//                           Row(
//                             children: [
//                               Expanded(
//                                   child: InkWell(
//                                       onTap: () {
//                                         setState(() {
//                                           registerCubit.isMale = true;
//                                         });
//                                       },
//                                       child: BadgedLabel(
//                                           color: registerCubit.isMale
//                                               ? AppColors.PRIMARY_COLOR
//                                               : Colors.white,
//                                           textColor: registerCubit.isMale
//                                               ? Colors.white
//                                               : Colors.black,
//                                           label: 'Male'))),
//                               Expanded(
//                                 child: InkWell(
//                                   onTap: () {
//                                     setState(() {
//                                       registerCubit.isMale = false;
//                                     });
//                                   },
//                                   child: BadgedLabel(
//                                     textColor: registerCubit.isMale
//                                         ? Colors.black
//                                         : Colors.white,
//                                     color: registerCubit.isMale
//                                         ? Colors.white
//                                         : AppColors.PRIMARY_COLOR,
//                                     label: 'Female',
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                   Sizer(height: 30.h),
//                   DefaultButton(
//                     label: 'Register',
//                     width: double.infinity,
//                     onPressed: registerCubit.register,
//                     // onPressed: () async {
//                     //   var r = await getDeviceId();
//                     //   log(r.toString());
//                     // },
//                   ),
//                   Sizer(),
//                   Sizer(),
//                   Label(
//                     text: 'Or Continue with',
//                     style: Styles.mediumText(color: Colors.grey),
//                   ),
//                   Sizer(),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: AppButton(
//                           style:
//                               const TextStyle(color: AppColors.QUANTITY_COLOR),
//                           label: 'Google',
//                           backColor: AppColors.LIGHT_GRAY_COLOR,
//                           textColor: Colors.black,
//                           icon: FontAwesomeIcons.google,
//                           onPressed: () {},
//                         ),
//                       ),
//                       Sizer(),
//                       Expanded(
//                         child: AppButton(
//                           style:
//                               const TextStyle(color: AppColors.QUANTITY_COLOR),
//                           label: 'Facebook',
//                           backColor: AppColors.LIGHT_GRAY_COLOR,
//                           textColor: Colors.black,
//                           icon: FontAwesomeIcons.facebook,
//                           onPressed: () {},
//                         ),
//                       ),
//                     ],
//                   ),
//                   Sizer(height: 20.h),
//                   RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: "Does have account? ",
//                           style: Styles.mediumText(
//                             color: Colors.grey,
//                           ),
//                         ),
//                         TextSpan(
//                           text: "Login",
//                           recognizer: TapGestureRecognizer()
//                             ..onTap = () => context.push(Routes.LOGIN),
//                           style: Styles.mediumText(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _toggleLogin() => setState(() => _obscureTextLogin = !_obscureTextLogin);
// }
