import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/utils/shared_pref.dart';
import '../../../../../routes/routes.dart';
import '../../../../../shared_web_socket.dart';
import '../../../domain/use_cases/change_password_use_case.dart';
import '../../../domain/use_cases/send_forget_password_otp_use_case.dart';
import '../../../domain/use_cases/send_forget_password_question_use_case.dart';
import '../../../domain/use_cases/verify_questions_use_case.dart';
import '../user_cubit/user_cubit.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final SendForgetPasswordOTPUseCase sendForgetPasswordOTPUseCase;
  final SendForgetPasswordQuestionUseCase sendForgetPasswordQuestionsUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final VerifyQuestionsUseCase verifyQuestionsUseCase;
  final emailFormKey = GlobalKey<FormState>();
  final changePasswordFormKey = GlobalKey<FormState>();
  final verificationFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final odlPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();
  final questionOneAnswerController = TextEditingController();
  final questionTwoAnswerController = TextEditingController();
  final questionThreeAnswerController = TextEditingController();

  ForgotPasswordCubit(
    this.sendForgetPasswordOTPUseCase,
    this.sendForgetPasswordQuestionsUseCase,
    this.changePasswordUseCase,
    this.verifyQuestionsUseCase,
  ) : super(ForgotPasswordInitial());

  Future<void> sendForgetPasswordOTP(BuildContext context) async {
    if (!emailFormKey.currentState!.validate()) return;
    if (state is ForgotPasswordLoading) return;
    emit(ForgotPasswordLoading());

    if (_isPhoneNumber(emailController.text.trim())) {
      final result = await sendForgetPasswordQuestionsUseCase(
        SendForgetPasswordParams(
          email: emailController.text.trim(),
        ),
      );
      result.fold(
        (failure) => emit(ForgotPasswordSendOTPFailure(failure)),
        (questions) {
          context.pushNamed(Routes.VERIFICATION, extra: questions);
          emit(ForgotPasswordSendOTPSuccess());
        },
      );
    } else if (_isEmail(emailController.text.trim())) {
      final result = await sendForgetPasswordOTPUseCase(
        SendForgetPasswordParams(
          email: emailController.text.trim(),
        ),
      );
      result.fold(
        (failure) => emit(ForgotPasswordSendOTPFailure(failure)),
        (_) {
          print('is email');
          context.pushNamed(
            Routes.FORGOTPASSWORDOTP,
            extra: emailController.text.trim(),
          );
          emit(ForgotPasswordSendOTPSuccess());
        },
      );
    }
  }

  Future<void> changePassword(BuildContext context) async {
    if (!changePasswordFormKey.currentState!.validate()) return;
    if (state is ChangePasswordLoading) return;
    emit(ChangePasswordLoading());
    final result = await changePasswordUseCase(
      ChangePasswordParams(
        currentPassword: odlPasswordController.text,
        newPassword: newPasswordController.text,
        confirmNewPassword: confirmNewPasswordController.text,
      ),
    );
    result.fold(
      (failure) => emit(ChangePasswordFailure(failure)),
      (userToken) async {
        // log("Token logout ${await CacheManager.getAccessToken()}");
        // log("Token userToken access ${userToken.accessToken}");
        // log("Token userToken refresh ${userToken.refreshToken}");
        // await CacheManager.saveAccessToken(userToken.accessToken);
        // await CacheManager.saveRefreshToken(userToken.refreshToken);
        // SharedWebSocket.connect(token: userToken.accessToken);
        // print('ChangePasswordSuccess()');
        // print('emit(ChangePasswordSuccess());');
        // emit(ChangePasswordSuccess());
        await context.read<UserCubit>().logout(context);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("ISLOGIN", false);
        context.go(Routes.LOGIN);
        emit(ChangePasswordSuccess());
        // context.go(Routes.SETTINGS);
      },
    );
  }

  Future<void> verifyQuestions(BuildContext context,
      {required String userId}) async {
    if (!verificationFormKey.currentState!.validate()) return;
    if (state is VerifyQuestionsLoading) return;
    emit(VerifyQuestionsLoading());
    final result = await verifyQuestionsUseCase(
      VerifyQuestionsParams(
        userId: userId,
        caskBackBalance: int.parse(questionOneAnswerController.text),
        walletAmount: int.parse(questionThreeAnswerController.text),
        giftWalletAmount: int.parse(questionTwoAnswerController.text),
      ),
    );
    result.fold(
      (failure) => emit(VerifyQuestionsFailure(failure)),
      (_) {
        context.pushNamed(Routes.CREATENEWFORGOTPASSWORD,
            extra: {"userId": userId, "email": null});
        emit(VerifyQuestionsSuccess());
      },
    );
  }

  bool _isEmail(String input) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(input);
  }

  bool _isPhoneNumber(String input) {
    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    return phoneRegex.hasMatch(input);
  }
}
