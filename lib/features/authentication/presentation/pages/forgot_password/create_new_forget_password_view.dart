import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mtwstat/app/modules/forget_password/controllers/forget_password_controller.dart';

import '../../../core/localization.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/primary_text_field.dart';

class CreateNewForgetPasswordView extends GetView<ForgetPasswordController> {
  const CreateNewForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppbar(
        title: tr(context).createNewPassword,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.newPasswordFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              ValueBuilder<bool?>(
                initialValue: true,
                builder: (value, update) => PrimaryTextField(
                  labelText: tr(context).newPassword,
                  hintText: 'XXXXXXXXXXXXXXXXXX',
                  onSubmit: (_) => controller.createPassword(),
                  controller: controller.newPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: value!,
                  suffixIcon: IconButton(
                    onPressed: () => update(!value),
                    icon: Icon(
                      value ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                  validator: (v) {
                    if (v!.isEmpty) {
                      return tr(context).required;
                    } else if (v.length < 6) {
                      return tr(context).passwordsDoNotMatch;
                    }
                    if (v != controller.newPasswordController.text) {
                      return tr(context).passwordsDoNotMatch;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              ValueBuilder<bool?>(
                initialValue: true,
                builder: (value, update) => PrimaryTextField(
                  labelText: tr(context).enterNewPassword,
                  hintText: 'XXXXXXXXXXXXXXXXXX',
                  onSubmit: (_) => controller.createPassword(),
                  controller: controller.confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: value!,
                  suffixIcon: IconButton(
                    onPressed: () => update(!value),
                    icon: Icon(
                      value ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                  validator: (v) {
                    if (v!.isEmpty) {
                      return tr(context).required;
                    } else if (v.length < 6) {
                      return tr(context).passwordsDoNotMatch;
                    }
                    if (v != controller.newPasswordController.text) {
                      return tr(context).passwordsDoNotMatch;
                    }
                    return null;
                  },
                ),
              ),
              const Spacer(),
              Obx(
                () => PrimaryButton(
                  text: tr(context).createNewPasswordHint,
                  onPressed: controller.createPassword,
                  isLoading: controller.isLoading.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
