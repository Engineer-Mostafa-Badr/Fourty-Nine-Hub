import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/settings/presentation/pages/widgets/verification_view_body.dart';

import '../../../authentication/domain/entities/forget_password_questions_entity.dart';

class VerificationView extends StatelessWidget {
  const VerificationView({
    super.key,
    required this.questions,
  });

  final ForgetPasswordQuestionsEntity questions;

  // final String questionTwo;
  // final String questionThree;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      enableCustomAppBar: true,
      appBar: BackAppBar(
        label: LocaleKeys.verification.localize,
        enableCustomAppBar: true,
      ),
      body: VerificationViewBody(
        questions: questions,
      ),
    );
  }
}
