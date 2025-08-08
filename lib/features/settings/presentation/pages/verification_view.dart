import 'package:flutter/material.dart';
import '../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/widget/custom_scaffold.dart';
import 'widgets/verification_view_body.dart';

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: LocaleKeys.verification.localize,
          enableCustomAppBar: true,
        ),
      ),
      body: VerificationViewBody(
        questions: questions,
      ),
    );
  }
}
