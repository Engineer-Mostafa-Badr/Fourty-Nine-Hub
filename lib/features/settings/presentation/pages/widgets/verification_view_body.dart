import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/custom_show_dialog.dart';
import 'package:fourtyninehub/core/widget/custom_floating_action_button.dart';
import 'package:fourtyninehub/features/settings/presentation/pages/widgets/dialog_verification_widget.dart';
import 'package:fourtyninehub/features/settings/presentation/pages/widgets/label_and_text_form_field.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class VerificationViewBody extends StatefulWidget {
  const VerificationViewBody({super.key});

  @override
  State<VerificationViewBody> createState() => _VerificationViewBodyState();
}

class _VerificationViewBodyState extends State<VerificationViewBody> {
  late TextEditingController questionOneController;
  late TextEditingController questionTwoController;
  late TextEditingController questionThreeController;

  @override
  void initState() {
    questionOneController = TextEditingController();
    questionTwoController = TextEditingController();
    questionThreeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    questionOneController.dispose();
    questionTwoController.dispose();
    questionThreeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
      child: Column(
        children: [
          LabelAndTextFormField(
            label: '"What is your birthday?"',
            controller: questionOneController,
            hint: 'Day/Month/Year',
          ),
          const SizedBox(
            height: 8,
          ),
          LabelAndTextFormField(
            label: '"How much cash back you have?"',
            controller: questionTwoController,
            hint: 'Answer',
          ),
          const SizedBox(
            height: 8,
          ),
          LabelAndTextFormField(
            label: '"How lucky wheel money you have?"',
            controller: questionThreeController,
            hint: 'Answer',
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            width: double.infinity,
            child: CustomFloatingActionButton(
              text: LocaleKeys.confirm.localize,
              onPressed: () {
                showAnimatedDialog(
                  context,
                  DialogVerificationWidget(
                    okOnPressed: () {
                      Navigator.of(context).pop();
                    },
                    cancelOnPressed: () {
                      context.go(
                        Routes.SETTINGS,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
