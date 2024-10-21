import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/style/styles.dart';
import '../cubit/contact_us_cubit.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.contactUs.localize,
      ),
      body: BlocConsumer<ContactUsCubit, ContactUsState>(
        listener: (context, state) {
          if (state.status == StateStatus.success) {
            showSuccessMessage(
                context, LocaleKeys.messageSuccessfully.localize);
          }
          if (state.status == StateStatus.error) {
            showErrorMessage(
              context,
              getFailureMessage(
                state.failure!,
                context,
              ),
            );
          }
        },
        builder: (BuildContext context, ContactUsState state) {
          final controller = context.read<ContactUsCubit>();
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            child: Form(
              key: controller.formKey,
              child: ListView(
                children: [
                  Label(
                    text: LocaleKeys.TeamHelp.localize,
                    style: Styles.mediumText(fontSize: 50.sp),
                  ),
                  const Sizer(),
                  FormTextField(
                    type: TextInputType.phone,
                    textStyle: Styles.mediumText(
                        color: Theme.of(context).scaffoldBackgroundColor),
                    validator: (v) => null,
                    constraints:
                        BoxConstraints(maxHeight: 52.h, minHeight: 52.h),
                    fillColor: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20.r),
                    style: TextStyle(
                        fontSize: 30.sp,
                        color: Theme.of(context).scaffoldBackgroundColor),
                    controller: controller.phoneController,
                    // label: 'E-mail or phone number',
                    hint: LocaleKeys.phoneOptional.localize,
                    prefix: Icon(
                      Icons.phone,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      size: 40.w,
                    ),
                    action: (v) {},
                  ),
                  const Sizer(),
                  FormTextField(
                    textStyle: Styles.mediumText(
                        color: Theme.of(context).scaffoldBackgroundColor),
                    height: 120,
                    maxLines: 4,
                    maxLength: 150,
                    //  constraints:  BoxConstraints(maxHeight: 52.h, minHeight: 52.h),
                    fillColor: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20.r),
                    style: TextStyle(
                        fontSize: 30.sp,
                        color: Theme.of(context).scaffoldBackgroundColor),
                    controller: controller.messageController,
                    // label: 'Password',
                    hint: '${LocaleKeys.message.localize}...',
                    action: (c) {
                      if (c.length == 150) {
                        showErrorMessage(
                            context, LocaleKeys.character.localize);
                      }
                    },
                  ),
                  const Sizer(),
                  AppButton(
                      color: AppColors.AUTH_CONTAINER_COLOR,
                      label: LocaleKeys.send.localize,
                      margin: 10,
                      onPressed: () => controller.createContactUs()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
