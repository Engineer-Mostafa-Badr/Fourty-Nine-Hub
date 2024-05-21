
import 'package:flutter/material.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:fourtyninehub/common/widgets/form/text_fields/confirm_password_text_field.dart';
// import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
// import 'package:fourtyninehub/common/widgets/form/text_fields/first_name_text_form_field.dart';
// import 'package:fourtyninehub/common/widgets/form/text_fields/last_name_text_form_field.dart';
// import 'package:fourtyninehub/features/authentication/data/models/user_model2.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../../../common/widgets/dynamic/sizer.dart';
// import '../../../../../common/widgets/form/text_fields/password_text_form_field.dart';
// import '../../../../../common/widgets/stateless/appbar/back_appbar.dart';
// import '../../../../../common/widgets/stateless/buttons/app_button.dart';
// import '../../../../../common/widgets/stateless/buttons/default_button.dart';
// import '../../../../../common/widgets/stateless/labels/label.dart';
// import '../../../../../res/style/app_colors.dart';
// import '../../../../../res/style/styles.dart';
// import '../../../../../routes/routes.dart';
// import '../../bloc/auth_cubit.dart';
//
// class RegisterView extends StatefulWidget {
//   const RegisterView({super.key});
//
//   @override
//   State<RegisterView> createState() => _RegisterViewState();
// }
//
// class _RegisterViewState extends State<RegisterView> {
//   late final GlobalKey<FormState> _formKey;
//   late final TextEditingController _firstNameController;
//   late final TextEditingController _lastNameController;
//   late final TextEditingController _emailTextController;
//   late final TextEditingController _passwordTextController;
//   late final TextEditingController _confirmPasswordTextController;
//
//   late final FocusNode _firstNameFocusNode;
//   late final FocusNode _lastNameFocusNode;
//   late final FocusNode _emailFocusNode;
//   late final FocusNode _passwordFocusNode;
//   late final FocusNode _confirmPasswordFocusNode;
//
//   @override
//   void initState() {
//     _formKey = GlobalKey<FormState>();
//
//     _firstNameController = TextEditingController();
//     _lastNameController = TextEditingController();
//     _emailTextController = TextEditingController();
//     _confirmPasswordTextController = TextEditingController();
//     _passwordTextController = TextEditingController();
//
//     _firstNameFocusNode = FocusNode();
//     _lastNameFocusNode = FocusNode();
//     _emailFocusNode = FocusNode();
//     _passwordFocusNode = FocusNode();
//     _confirmPasswordFocusNode = FocusNode();
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthCubit, AuthState>(
//       listener: (context, state) {
//         if (state.isError) {
//           showSnackBar(context, message: state.errorMessage);
//         } else if (state.isEmailVerificationOTPSent) {
//           _goToVerificationPage();
//         }
//       },
//       child: Scaffold(
//         appBar: const BackAppBar(),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Form(
//             key: _formKey,
//             child: ListView(
//               children: [
//                 _buildNameField(),
//                 const Sizer(),
//                 _buildEmailPhoneField(),
//                 const Sizer(),
//                 _buildPasswordField(),
//                 const Sizer(),
//                 _buildConfirmPasswordField(),
//                 const Sizer(),
//                 _buildLoginButton(),
//                 const Sizer(),
//                 _buildLoginOptions(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _goToVerificationPage() => context.push(Routes.VERIFYMAIL);
//
//   Widget _buildNameField() {
//     return Row(
//       children: [
//         Expanded(
//             child: FirstNameTextFormField(
//           currentFocusNode: _firstNameFocusNode,
//           currentController: _firstNameController,
//           nextFocusNode: _lastNameFocusNode,
//           // hint: 'First Name'.tr(),
//           // suffixIcon: const Icon(Icons.person),
//         )),
//         const Sizer(),
//         Expanded(
//             child: LastNameTextFormField(
//           currentFocusNode: _lastNameFocusNode,
//           currentController: _lastNameController,
//           // hint: 'Last Name'.tr(),
//           // suffixIcon: const Icon(Icons.person),
//           nextFocusNode: _emailFocusNode,
//         )),
//       ],
//     );
//   }
//
//   Widget _buildEmailPhoneField() {
//     return DefaultTextFormField(
//       currentFocusNode: _emailFocusNode,
//       currentController: _emailTextController,
//       suffixIcon: const Icon(Icons.email),
//       hint: 'Email'.tr(),
//     );
//   }
//
//   Widget _buildPasswordField() {
//     return PasswordTextFormField(
//       currentFocusNode: _passwordFocusNode,
//       currentController: _passwordTextController,
//     );
//   }
//
//   Widget _buildConfirmPasswordField() {
//     return ConfirmPasswordTextFormField(
//       currentFocusNode: _confirmPasswordFocusNode,
//       currentController: _confirmPasswordTextController,
//       passwordController: _passwordTextController,
//     );
//   }
//
//   Widget _buildLoginButton() {
//     final authCubit = context.read<AuthCubit>();
//
//     return DefaultButton(
//       label: 'register'.tr(),
//       onPressed: () async {
//         if (_isNotValid()) return;
//         await authCubit.signUp(
//             user: User(
//                 firstName: _firstNameController.text,
//                 lastName: _lastNameController.text,
//                 email: _emailTextController.text.trim(),
//                 password: _passwordTextController.text));
//       },
//     );
//   }
//
//   bool _isNotValid() {
//     if (!_formKey.currentState!.validate()) {
//       setState(() => _isAutoValidating = true);
//       return true;
//     }
//     return false;
//   }
//
//   Widget _buildLoginOptions() {
//     return Column(
//       children: [
//         const Sizer(),
//         Label(
//             text: 'Or Continue with',
//             style: Styles.mediumText(color: Colors.grey)),
//         const Sizer(),
//         Row(
//           children: [
//             Expanded(
//               child: AppButton(
//                   label: 'Google',
//                   backColor: AppColors.LIGHT_GRAY_COLOR,
//                   textColor: Colors.black,
//                   icon: FontAwesomeIcons.google,
//                   onPressed: () {}),
//             ),
//             const Sizer(),
//             Expanded(
//               child: AppButton(
//                   label: 'Facebook',
//                   backColor: AppColors.LIGHT_GRAY_COLOR,
//                   textColor: Colors.black,
//                   icon: FontAwesomeIcons.facebook,
//                   onPressed: () {}),
//             ),
//           ],
//         ),
//         const Sizer(),
//         RichText(
//             text: TextSpan(children: [
//           TextSpan(
//               text: "Doesn't have account? ",
//               style: Styles.mediumText(color: Colors.grey)),
//           TextSpan(
//               text: "Register",
//               recognizer: TapGestureRecognizer()
//                 ..onTap = () => context.push(Routes.REGISTER),
//               style: Styles.mediumText(color: Colors.black)),
//         ]))
//       ],
//     );
//   }
// }
