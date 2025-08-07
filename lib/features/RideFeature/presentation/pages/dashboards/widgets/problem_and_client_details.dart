import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class ProblemAndClientDetails extends StatefulWidget {
  const ProblemAndClientDetails({super.key});

  @override
  State<ProblemAndClientDetails> createState() =>
      _ProblemAndClientDetailsState();
}

class _ProblemAndClientDetailsState extends State<ProblemAndClientDetails> {
  var problemController = TextEditingController();
  var phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String problemState = 'default';
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (problemState == 'default' || problemState == 'waiting') ...[
            FormTextField(
                style: Styles.mediumText(
                    color: AppColors.black, fontWeight: FontWeight.w300),
                constraints: const BoxConstraints(maxHeight: 52, minHeight: 52),
                fillColor: AppColors.colorGreyLight,
                borderRadius: BorderRadius.circular(20),
                controller: problemController,
                hint: LocaleKeys.writeProblem.tr(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your problem';
                  }
                  return null;
                }),
            const SizedBox(height: 16),
            FormTextField(
                type: TextInputType.phone,
                style: Styles.mediumText(
                    color: AppColors.black, fontWeight: FontWeight.w300),
                constraints: const BoxConstraints(maxHeight: 52, minHeight: 52),
                fillColor: const Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(20),
                controller: phoneController,
                hint: LocaleKeys.writePhone.tr(), //'Write your phone number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                }),
          ] else ...[
             Center(
                child: Text(LocaleKeys.clientDetails.tr(),//'Client Details',
                    style: const TextStyle(fontWeight: FontWeight.w600))),
            const SizedBox(height: 16),
            _problemInfo(title:LocaleKeys.clientName.tr(), //'Client Name', 
            value: 'Ahmed mohammed'),
            const SizedBox(height: 8),
            _problemInfo(title:LocaleKeys.clientPhone.tr(), //'Client Phone',
            value: '01578731541'),
            const SizedBox(height: 8),
            _problemInfo(title: LocaleKeys.email.tr(),
             value: 'Ahmedmohammed@gmail.com '),
            const SizedBox(height: 8),
            _problemInfo(title: LocaleKeys.deviceId.tr(), //'Device ID',
             value: '145.545.725.75'),
          ],
          const SizedBox(height: 16),
          AppButton(
              label: problemState == 'default'
                  ? LocaleKeys.requestEmergency.tr()//'Request emergency support'
                  : problemState == 'waiting'
                      ? LocaleKeys.requestSent.tr()//'Request sent'
                      :LocaleKeys.locationLog.tr(), //'Location log',
              onPressed: () {
      ManageVibration.vibrate();
                if (_formKey.currentState!.validate()) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text('Processing Data')),
                  // );
                  if (problemState == 'success') {
                    setState(() {
                      problemState = 'default';
                    });
                  } else if (problemState == 'default') {
                    setState(() {
                      problemState = 'waiting';
                    });
                  } else if (problemState == 'waiting') {
                    setState(() {
                      phoneController.clear();
                      problemController.clear();
                      problemState = 'success';
                    });
                  }
                }
              },
              backColor: AppColors.PRIMARY_COLOR
                  .withOpacity(problemState == 'waiting' ? 0.7 : 1)),
          if (problemState == 'waiting')
             Align(
              alignment: AlignmentDirectional.topEnd,
              child: Text(LocaleKeys.waitingApproval.tr(),//'Waiting Approval',
                  style: const TextStyle(
                      color: AppColors.SECONDARY_COLOR_DARK2,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
            ),
          const SizedBox(height: 16)
        ],
      ),
    );
  }

  Widget _problemInfo({required String title, required String value}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Container(
            width: context.screenWidth,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
                color: AppColors.colorGreyLight,
                borderRadius: BorderRadius.circular(20)),
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w300)),
          ),
        ],
      );
}