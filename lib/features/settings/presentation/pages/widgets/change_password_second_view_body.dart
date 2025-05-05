import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_floating_action_button.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/settings/presentation/pages/widgets/label_and_text_form_field.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/states/basic_state.dart';
import '../../../../../core/utils/shared_pref.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../authentication/domain/entities/user_entity.dart';
import '../../../../authentication/presentation/controllers/forgot_password_cubit/forgot_password_cubit.dart';
import '../../../../notifications/presentation/cubits/notification_socket_io/notification_socket_io_cubit.dart';

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

  @override
  void initState() {
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
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
            context
                .read<NotificationSocketIoCubit>()
                .notificationListener(languageCode: 'en');
            context
                .read<NotificationSocketIoCubit>()
                .clearAllNotificationsAndRefeatchAfterLogin(languageCode: 'en');
          }
          if (state is ConfirmPasswordNotMache) {
            showErrorMessage(
              context,
              context.isArabic
                  ? 'كلمة المرور غير متطابقة'
                  : 'Password does not match',
            );
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
                    label: LocaleKeys.oldPassword.localize,
                    controller: forgotPasswordCubit.odlPasswordController,
                    hint: LocaleKeys.oldPassword.localize,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  LabelAndTextFormField(
                    label: LocaleKeys.newPassword.localize,
                    controller: forgotPasswordCubit.newPasswordController,
                    hint: LocaleKeys.newPassword.localize,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  LabelAndTextFormField(
                    label: LocaleKeys.confirmNewPassword.localize,
                    controller:
                        forgotPasswordCubit.confirmNewPasswordController,
                    hint: LocaleKeys.confirmNewPassword.localize,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: BlocBuilder<UserCubit, BasicState<UserEntity>>(
                      builder: (context, state) {
                        return CustomFloatingActionButton(
                          text: LocaleKeys.submit.localize,
                          onPressed: () {
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
