import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../common/widgets/form/text_fields/default_text_form_field.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/extensions/numbers_extensions.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/styles.dart';
import '../cubit/contact_us_cubit.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode messageFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CustomScaffold(
      appBar: BackAppBar(
        label: LocaleKeys.contactUs.localize,
        subTitle: context.isArabic
            ? 'فريق ٤٩ هاب جاهز للمساعدة'
            : LocaleKeys.TeamHelp.localize,
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
          return GlowingOverscrollIndicator(
            color: AppColors.SECONDARY_COLOR,
            axisDirection: AxisDirection.down,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 140.h,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: controller.formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                            contentPadding: EdgeInsets.symmetric(horizontal: 4),
                            inputFormatter: [
                              TextInputFormatter.withFunction(
                                  (oldValue, newValue) {
                                // السماح بالأرقام الإنجليزية والعربية فقط
                                final arabicDigitsRegex =
                                    RegExp(r'^[0-9٠-٩]*$');
                                if (arabicDigitsRegex.hasMatch(newValue.text)) {
                                  return newValue;
                                }
                                return oldValue;
                              }),
                            ],
                            fillColor: Colors.transparent,
                            borderColor: AppColors.getTextColor(context),
                            currentController: controller.phoneController,
                            hint: LocaleKeys.phoneOptional.localize,
                            keyboardType: TextInputType.phone,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: context.isDarkMode
                                        ? Colors.white
                                        : AppColors.PRIMARY_COLOR,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(
                                  Icons.phone,
                                  color: context.isDarkMode
                                      ? AppColors.PRIMARY_COLOR
                                      : Colors.white,
                                  // size: 27,
                                ),
                              ),
                            ),
                            onChanged: (v) {
                              controller.phoneController.text = v;
                            },
                            currentFocusNode: phoneFocusNode,
                            validator: (value) {
                              // الحقل optional، إذا كان فارغ مش مطلوب validation
                              if (value == null || value.isEmpty) {
                                return null;
                              }
                              // تحويل الأرقام العربية للإنجليزية قبل التحقق
                              final englishValue = value.toEnglishNumbers();
                              // التحقق من صحة رقم الهاتف (11 رقم)
                              final phoneRegex = RegExp(r'^\+?\d{11}$');
                              if (!phoneRegex.hasMatch(englishValue)) {
                                return LocaleKeys.invalidPhoneNumber.localize;
                              }
                              return null;
                            },
                          ),
                          const Sizer(),
                          DefaultTextFormField(
                            contentPadding: const EdgeInsets.all(16),
                            // contentPadding: EdgeInsets.all(32),
                            fillColor: Colors.transparent,
                            borderColor: AppColors.getTextColor(context),
                            currentController: controller.messageController,
                            hint: '${LocaleKeys.message.localize}...',
                            hintColor: context.isDarkMode
                                ? Colors.white
                                : Colors.black54,
                            maxLength: 150,
                            maxLines: 5,
                            hintStyle: Styles.headerText(
                              color: context.isDarkMode
                                  ? Colors.white
                                  : Colors.black54,
                            ),
                            textInputAction: TextInputAction.done,
                            currentFocusNode: messageFocusNode,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return LocaleKeys.required.localize;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Spacer(),
                          AppButton(
                              radius: 25,
                              color: AppColors.getReversedTextColor(context),
                              label: LocaleKeys.send.localize,
                              margin: 10,
                              backColor: AppColors.getRedColor(context),
                              onPressed: () =>
                                  controller.createContactUs(context)),
                        ],
                      ),
                    ),
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
        ManageVibration.vibrate();
        onTap!();
      },
      child: Container(
        width: (size.width),
        padding: const EdgeInsets.all(8),
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: context.isDarkMode
              ? AppColors.getFindFillColor(context)
              : AppColors.PRIMARY_COLOR.withValues(alpha: 0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (icon == Icons.email_outlined)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  Assets.aMailIcon,
                  color: context.isDarkMode
                      ? Colors.white
                      : AppColors.PRIMARY_COLOR,
                ),
              )
            else
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

  @override
  void dispose() {
    phoneFocusNode.dispose();
    messageFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      phoneFocusNode.requestFocus();
    });
  }
}
