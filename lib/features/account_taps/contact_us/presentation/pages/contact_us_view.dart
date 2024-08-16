import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/strings/labels.dart';
import '../cubit/contact_us_cubit.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ContactUsCubit>();
    return BlocConsumer<ContactUsCubit, ContactUsState>(
        builder: (context, state) {
      return Scaffold(
        appBar: const BackAppBar(
          label: 'Contact Us',
        ),
        bottomNavigationBar: AppButton(
          color: AppColors.AUTH_CONTAINER_COLOR,
            label: 'Send',
            margin: 10,
            onPressed: () => controller.createContactUs()),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: controller.formKey,
            child: ListView(
              children: [
                const Label(text: '49Hub Team is ready to help'),
                const Sizer(),
                FormTextField(
                  textStyle: TextStyle(
                    color: Theme.of(context).primaryColor
                  ),
                  label: 'Phone (Optional)',
                  required: false,
                  controller: controller.phoneController,
                ),
                const Sizer(),
                FormTextField(
                  textStyle: TextStyle(
                      color: Theme.of(context).primaryColor
                  ),
                  hint: 'Message',
                  maxLines: 3,
                  controller: controller.messageController,
                ),
              ],
            ),
          ),
        ),
      );
    }, listener: (context, state) {
      if (state.status == StateStatus.error) {
        showErrorMessage(
          context,
          getFailureMessage(
            state.failure!,
            context,
          ),
        );
      } else if (state.status == StateStatus.success) {
        context.pop();
        showSuccessMessage(context, state.successMessage ?? Labels.success);
      }
    });
  }
}
