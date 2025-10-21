import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/register_by_phone_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/register_use_case.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../domain/entities/gift_message_entity.dart';
import '../../../domain/entities/user_tokens_entity.dart';
import '../../../domain/use_cases/attach_token_use_case.dart';
import '../../../domain/use_cases/get_welcome_gift_use_case.dart';
import '../../../domain/use_cases/google_sign_in_use_case.dart';
import '../../../domain/use_cases/save_tokens_use_case.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final GetWelcomeGiftUseCase _getWelcomeGiftUseCase;
  final RegisterUseCase _registerUseCase;
  final RegisterByPhoneUseCase _registerByPhoneUseCase;
  final GoogleSignInUseCase _googleSignInUseCase;

  // final FacebookSignInUseCase _facebookSignInUseCase;
  final SaveTokensUseCase _saveTokens;
  final AttachTokenUseCase _attachToken;
  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  final birthDateTextController = TextEditingController();
  final referralId = TextEditingController();

  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  bool accept = false;
  bool isMale = true;
  double? welcomeGift;

  RegisterCubit(
    this._registerUseCase,
    this._getWelcomeGiftUseCase,
    this._saveTokens,
    this._attachToken,
    this._googleSignInUseCase,
    this._registerByPhoneUseCase,
    // this._facebookSignInUseCase,
  ) : super(RegisterInitial());

  bool isLessThan14YearsOld(String inputDate) {
    // Parse the string to DateTime
    DateTime date = DateFormat("dd/MM/yyyy").parse(inputDate);

    // Today and 14 years ago
    final today = DateTime.now();
    final fourteenYearsAgo = DateTime(today.year - 14, today.month, today.day);

    // Check if date is after the 14 years ago mark
    return date.isAfter(fourteenYearsAgo);
  }
  String birthDate = '';
  Future<void> register() async {
    var currentContext =
    AppPages.router.configuration.navigatorKey.currentContext!;
    showLoadingDialog(currentContext);
    String? token = await FirebaseMessaging.instance.getToken();
    log("message");
    if (state is RegisterLoading) return;
    emit(RegisterLoading());
    if (passwordTextController.text != confirmPasswordTextController.text) {
      emit(RegisterConfirmPassword());
    }else{
      if (_isPhoneNumber(emailTextController.text.trim())) {// if()
        final result = await _registerByPhoneUseCase(
          RegisterByPhoneParams(
            userName: userNameController.text.trim(),
            firstName: firstNameController.text.trim(),
            lastName: lastNameController.text.trim(),
            birthday: birthDate,
            phoneNumber: emailTextController.text.trim(),
            password: passwordTextController.text.trim(),
            confirmPassword: confirmPasswordTextController.text.trim(),
            isMale: isMale,
            referralId: referralId.text.trim(),
            token: token ?? "",
          ),
        );
        emit(
          result.fold(
                (failure)  {
                  currentContext.pop();
                  showErrorMessage(
                      currentContext, getFailureMessage(failure, currentContext));
                return RegisterError(failure);
                },
                (data) {
                  currentContext.pop();
              print("data.isPhoneVerified ${data.isPhoneVerified}");
              print(
                  "data.tokensEntity.accessToken ${data.tokensEntity.accessToken}");
              if (data.isPhoneVerified) {
                _attachToken(data.tokensEntity); // attach to dio
                _saveTokens(data.tokensEntity);
                return RegisterByPhone(
                  userTokensEntity: data.tokensEntity,
                  isPhoneVerified: data.isPhoneVerified,
                  giftMessageEntity: data.giftMessageEntity,
                );
              } else {
                return OTPPhoneSent();
              }
            },
          ),
        );
      }
      else if (_isEmail(emailTextController.text.trim())) {
        final result = await _registerUseCase(
          RegisterParams(
            userName: userNameController.text.trim(),
            firstName: firstNameController.text.trim(),
            lastName: lastNameController.text.trim(),
            birthday: birthDate,
            email: emailTextController.text.trim(),
            password: passwordTextController.text.trim(),
            confirmPassword: confirmPasswordTextController.text.trim(),
            isMale: isMale,
            referralId: referralId.text.trim(),
            token: token ?? "",
          ),
        );
        emit(
          result.fold(
                (failure) {
                  currentContext.pop();
                  return RegisterError(failure);
                },
                (_) {
                  currentContext.pop();
                  return OTPSent();
                },
          ),
        );
      }
    }

  }

  Future<void> signInWithGoogle() async {
    if (state is RegisterLoading) return;
    emit(RegisterLoading());
    final result = await _googleSignInUseCase(const NoParams());
    emit(
      result.fold(
        (failure) => RegisterError(failure),
        (userToken) {
          _attachToken(userToken); // attach to dio
          _saveTokens(userToken); // save to local storage
          return RegisterSuccess(userTokensEntity: userToken);
        },
      ),
    );
  }

  Future<void> signInWithFacebook() async {
    if (state is RegisterLoading) return;
    emit(RegisterLoading());
    // final result = await _facebookSignInUseCase(const NoParams());
    // emit(
    //   result.fold(
    //     (failure) => RegisterError(failure),
    //     (userToken) {
    //       _attachToken(userToken); // attach to dio
    //       _saveTokens(userToken); // save to local storage
    //       return RegisterSuccess(userTokensEntity: userToken);
    //     },
    //   ),
    // );
  }

  void getWelcomeGift() async {
    final result = await _getWelcomeGiftUseCase(const NoParams());
    result.fold(
      (_) {},
      (gift) => welcomeGift = gift,
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
