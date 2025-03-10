import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_floating_action_button.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordViewBody extends StatefulWidget {
  const ChangePasswordViewBody({super.key});

  @override
  State<ChangePasswordViewBody> createState() => _ChangePasswordViewBodyState();
}

class _ChangePasswordViewBodyState extends State<ChangePasswordViewBody> {
  late TextEditingController currentController;

  @override
  initState() {
    currentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    currentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          DefaultTextFormField(
            currentController: currentController,
            hint:
                '${LocaleKeys.email.localize} / ${LocaleKeys.phoneNumber.localize}',
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            width: double.infinity,
            child: CustomFloatingActionButton(
              text: LocaleKeys.sendOTP.localize,
              onPressed: () {
                context.push(Routes.CHANGEPASSWORDSECOND);
              },
            ),
          )
        ],
      ),
    );
  }
}
