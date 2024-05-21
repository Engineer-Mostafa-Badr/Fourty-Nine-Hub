import 'package:flutter/material.dart';

class RegisterVerifyOTP extends StatelessWidget {
  const RegisterVerifyOTP({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// import 'package:fourtyninehub/common/widgets/form/otp_text_field.dart';
// import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
// import 'package:fourtyninehub/routes/routes.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../../../common/widgets/stateless/appbar/back_appbar.dart';
// import '../../../../../common/widgets/stateless/labels/label.dart';
//
// class RegisterVerifyOTP extends StatefulWidget {
//   const RegisterVerifyOTP({super.key});
//
//   @override
//   State<RegisterVerifyOTP> createState() => _RegisterVerifyOTPState();
// }
//
// class _RegisterVerifyOTPState extends State<RegisterVerifyOTP> {
//   String otp = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthCubit, AuthState>(
//       listener: (context, state) {
//         if (state.isError) {
//           showSnackBar(context, message: state.errorMessage);
//         } else if (state.isEmailVerified) {
//           _goToLoginPage();
//           showSnackBar(context, message: 'registered_successfully'.tr());
//         } else if (state.isEmailVerificationOTPSent) {
//           showSnackBar(context, message: 'otp_text'.tr());
//         }
//       },
//       child: Scaffold(
//           appBar: const BackAppBar(),
//           bottomSheet: _buildVerifyButton(),
//           body: Column(
//             children: [
//               Label(
//                 text: 'otp_text'.tr(),
//               ),
//               Label(
//                 text: 'otp_sub_text'.tr(),
//               ),
//               const Sizer(),
//               _buildOTPTextField(),
//               const Sizer(),
//               Label(text: 'did_not_receive_email'.tr()),
//               _buildResendButton(),
//             ],
//           )),
//     );
//   }
//
//   void _goToLoginPage() {
//     context.push(Routes.LOGIN);
//   }
//
//   Widget _buildOTPTextField() {
//     return OTPTextField(
//       onSubmitted: (v) => otp = v,
//     );
//   }
//
//   Widget _buildResendButton() {
//     final authCubit = context.read<AuthCubit>();
//     return TextButton(
//         onPressed: () => authCubit.signUp(user: authCubit.state.user!),
//         child: Label(text: 'resend'.tr()));
//   }
//
//   Widget _buildVerifyButton() {
//     final authCubit = context.read<AuthCubit>();
//     return DefaultButton(
//         margin: const EdgeInsets.all(10),
//         width: double.infinity,
//         label: 'Verify',
//         onPressed: () async {
//           if (_verify()) {
//             await authCubit.verifyEmailOTP(
//                 email: authCubit.state.user!.email!, otp: otp);
//           } else {
//             showSnackBar(context, message: 'enter_confirmation_code'.tr());
//           }
//         });
//   }
//
//   bool _verify() {
//     if (otp.isNotEmpty && otp.length == 6) {
//       return true;
//     }
//     return false;
//   }
// }
