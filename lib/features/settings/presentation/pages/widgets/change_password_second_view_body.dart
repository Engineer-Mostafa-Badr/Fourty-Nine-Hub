import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/loading/custom_loading.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_floating_action_button.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'label_and_text_form_field.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/states/basic_state.dart';
import '../../../../../core/utils/shared_pref.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../authentication/domain/entities/user_entity.dart';
import '../../../../authentication/presentation/controllers/forgot_password_cubit/forgot_password_cubit.dart';
import '../../../../../helpers/manage_vibration.dart';

class ChangePasswordSecondViewBody extends StatefulWidget {
  const ChangePasswordSecondViewBody({super.key});

  @override
  State<ChangePasswordSecondViewBody> createState() =>
      _ChangePasswordSecondViewBodyState();
}

class _ChangePasswordSecondViewBodyState
    extends State<ChangePasswordSecondViewBody> {
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;
  final FocusNode oldPasswordFocusNode = FocusNode();
  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      oldPasswordFocusNode.requestFocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            showSuccessMessage(
                context,
                context.isArabic
                    ? 'تم تغيير كلمة المرور بنجاح'
                    : 'Password changed successfully');
            context.pop();
            print('emit(ChangePasswordSuccess());');
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
                // Navigator.pop(context);
                // Navigator.pop(context);
                context.pushReplacement(Routes.HOME);
              });
          }
          if (state is ConfirmPasswordNotMache) {
            showErrorMessage(
              context,
              context.isArabic
                  ? 'كلمة المرور غير متطابقة'
                  : 'Password does not match',
            );
          }
          if (state is ChangePasswordFailure) {
            showErrorMessage(
                context, getFailureMessage(state.failure, context));
          }
        },
        builder: (context, state) {
          var forgotPasswordCubit = context.read<ForgotPasswordCubit>();
          return Form(
            key: forgotPasswordCubit.changePasswordFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
              child: Column(
                children: [
                  LabelAndTextFormField(
                    label:
                        context.isArabic ? 'كلمة مرور قديمة' : 'Old Password',
                    controller: forgotPasswordCubit.odlPasswordController,
                    hint: context.isArabic ? 'كلمة مرور قديمة' : 'Old Password',
                    focusNodeCurrent: oldPasswordFocusNode,
                    focusNodeNext: newPasswordFocusNode,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  LabelAndTextFormField(
                    label: LocaleKeys.newPassword.localize,
                    controller: forgotPasswordCubit.newPasswordController,
                    hint: LocaleKeys.newPassword.localize,
                    focusNodeCurrent: newPasswordFocusNode,
                    focusNodeNext: confirmPasswordFocusNode,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  LabelAndTextFormField(
                    label: LocaleKeys.confirmNewPassword.localize,
                    controller:
                        forgotPasswordCubit.confirmNewPasswordController,
                    hint: LocaleKeys.confirmNewPassword.localize,
                    focusNodeCurrent: confirmPasswordFocusNode,
                    focusNodeNext: null,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: BlocBuilder<UserCubit, BasicState<UserEntity>>(
                      builder: (context, userState) {
                        if (state is ChangePasswordLoading) {
                          return CustomLoading();
                        }
                        return CustomFloatingActionButton(
                          text: LocaleKeys.confirm.localize,
                          onPressed: () {
                            ManageVibration.vibrate();
                            if (forgotPasswordCubit.odlPasswordController.text.isEmpty ||
                                forgotPasswordCubit
                                    .newPasswordController.text.isEmpty ||
                                forgotPasswordCubit.confirmNewPasswordController
                                    .text.isEmpty) {
                              showErrorMessage(
                                context,
                                context.isArabic
                                    ? 'الرجاء ملء جميع الحقول'
                                    : 'Please fill in all fields',
                              );
                              return;
                            }
                            if (forgotPasswordCubit
                                    .newPasswordController.text !=
                                forgotPasswordCubit
                                    .confirmNewPasswordController.text) {
                              showErrorMessage(
                                context,
                                context.isArabic
                                    ? 'كلمة المرور الجديدة لا تتطابق مع تأكيد كلمة المرور الجديدة'
                                    : 'New password does not match confirm new password',
                              );
                              return;
                            }
                            if (forgotPasswordCubit
                                    .odlPasswordController.text ==
                                forgotPasswordCubit
                                    .newPasswordController.text) {
                              showErrorMessage(
                                context,
                                context.isArabic
                                    ? 'كلمة المرور الجديدة يجب أن تكون مختلفة عن كلمة المرور القديمة'
                                    : 'New password must be different from old password',
                              );
                              return;
                            }
                            forgotPasswordCubit.changePassword(context);
                            // context.push(Routes.VERIFICATION);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
