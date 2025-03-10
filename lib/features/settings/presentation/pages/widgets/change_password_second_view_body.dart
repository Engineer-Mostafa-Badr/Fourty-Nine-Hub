import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_floating_action_button.dart';
import 'package:fourtyninehub/features/settings/presentation/pages/widgets/label_and_text_form_field.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
      child: Column(
        children: [
          LabelAndTextFormField(
            label: 'Old Password',
            controller: oldPasswordController,
            hint: 'Old Password',
          ),
          const SizedBox(
            height: 8,
          ),
          LabelAndTextFormField(
            label: LocaleKeys.newPassword.localize,
            controller: newPasswordController,
            hint: LocaleKeys.newPassword.localize,
          ),
          const SizedBox(
            height: 8,
          ),
          LabelAndTextFormField(
            label: LocaleKeys.confirmNewPassword.localize,
            controller: confirmPasswordController,
            hint: LocaleKeys.confirmNewPassword.localize,
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            width: double.infinity,
            child: CustomFloatingActionButton(
              text: LocaleKeys.submit.localize,
              onPressed: () {
                context.push(Routes.VERIFICATION);
              },
            ),
          ),
        ],
      ),
    );
  }
}
