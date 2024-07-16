import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'verify_forgot_password_otp_state.dart';

class VerifyForgotPasswordOtpCubit extends Cubit<VerifyForgotPasswordOtpState> {
  VerifyForgotPasswordOtpCubit() : super(VerifyForgotPasswordOtpInitial());
}
