import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_floating_action_button.dart';


import '../../../../../common/widgets/form/text_fields/email_text_form_field.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../authentication/presentation/controllers/forgot_password_cubit/forgot_password_cubit.dart';
import '../../../../../helpers/manage_vibration.dart';

class ChangePasswordViewBody extends StatefulWidget {
  const ChangePasswordViewBody({super.key});

  @override
  State<ChangePasswordViewBody> createState() => _ChangePasswordViewBodyState();
}

class _ChangePasswordViewBodyState extends State<ChangePasswordViewBody> {
  // late TextEditingController currentController;

  @override
  initState() {
    // currentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // currentController.dispose();
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
      child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
        builder: (context, state) {
          var forgotPasswordCubit = context.read<ForgotPasswordCubit>();
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                EmailTextFormField(
                  currentController: forgotPasswordCubit.emailController,
                  hint:
                      '${LocaleKeys.email.localize} / ${LocaleKeys.phoneNumber.localize}',
                    isRequired:true,
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: CustomFloatingActionButton(
                    text: LocaleKeys.sendOTP.localize,
                    onPressed: () {
      ManageVibration.vibrate();
                      forgotPasswordCubit.sendForgetPasswordOTP(context);
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}