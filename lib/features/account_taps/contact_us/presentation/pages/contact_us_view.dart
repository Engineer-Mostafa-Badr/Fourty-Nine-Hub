import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../common/widgets/form/text_fields/default_text_form_field.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/styles.dart';
import '../cubit/contact_us_cubit.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(46),
        child: BackAppBar(
          label: LocaleKeys.contactUs.localize,
          subTitle: LocaleKeys.TeamHelp.localize,
          enableCustomAppBar: true,
        ),
      ),
      enableCustomAppBar: true,
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
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height-170.h,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      const Sizer(
                        height: 30,
                      ),
                      buildContainerPhoneAndEmail(
                        size,
                        LocaleKeys.email.localize,
                        "49hup.app@gmail.com",
                        Icons.email_outlined,
                        () {},
                      ),
                      const Sizer(
                        height: 50,
                      ),
                      DefaultTextFormField(
                        contentPadding: EdgeInsets.zero,
                        fillColor: Colors.transparent,
                        currentController: controller.phoneController,
                        hint: LocaleKeys.phoneOptional.localize,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
                                borderRadius: BorderRadius.circular(10)),
                            child: Icon(
                              Icons.phone,
                              color: context.isDarkMode ? AppColors.PRIMARY_COLOR : Colors.white,
                              // size: 27,
                            ),
                          ),
                        ),
                      ),
                      const Sizer(),
                      DefaultTextFormField(
                        contentPadding: const EdgeInsets.all(16),
                        // contentPadding: EdgeInsets.all(32),
                        fillColor: Colors.transparent,
                        currentController: controller.messageController,
                        hint: '${LocaleKeys.message.localize}...',
                        hintColor:
                            context.isDarkMode ? Colors.white : Colors.black54,
                        maxLength: 150,
                        maxLines: 5,
                        hintStyle: Styles.headerText(color: context.isDarkMode ? Colors.white : Colors.black54,),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Spacer(),
                      AppButton(
                          radius: 25,
                          color: AppColors.AUTH_CONTAINER_COLOR,
                          label: LocaleKeys.send.localize,
                          margin: 10,
                          backColor: AppColors.SECONDARY_COLOR,
                          onPressed: () => controller.createContactUs(context)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildContainerPhoneAndEmail(
      Size size, String title, String val, IconData icon, Function()? onTap) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Container(
        width: (size.width),
        padding: const EdgeInsets.all(8),
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.PRIMARY_COLOR.withValues(alpha: 0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
              size: 27,
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                  text: title,
                  style: Styles.mediumText(
                      fontSize: 50.sp,
                      color: context.isDarkMode
                          ? Colors.white
                          : AppColors.PRIMARY_COLOR,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 5,
                ),
                Label(
                  text: val,
                  style: Styles.mediumText(
                      fontSize: 50.sp,
                      color: context.isDarkMode
                          ? Colors.white
                          : AppColors.PRIMARY_COLOR,
                      fontWeight: FontWeight.w500),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
