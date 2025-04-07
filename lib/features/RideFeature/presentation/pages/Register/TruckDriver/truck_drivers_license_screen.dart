import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../widgets/close_widget.dart';
import '../widgets/register_floating_action_button.dart';
import '../widgets/upload_file_widget.dart';

class TruckDriversLicenseScreen extends StatelessWidget {
  const TruckDriversLicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> uploadFilesTitles = [
      LocaleKeys.driversLicense.localize,
      LocaleKeys.backOfTheLicense.localize,
      LocaleKeys.aSelfieWithTheLicense.localize,
    ];
    TextEditingController licenseNumberController = TextEditingController();
    TextEditingController expirationDateController = TextEditingController();
    return CustomScaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(30),
        child: HomeAppbar(),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 32,
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    closeWidget(context:context,onAcceptSaveData: (){}, closeRemoveData: (){}),
                    Label(
                      text: LocaleKeys.driversLicense.localize,
                      style: Styles.headerText(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Sizer(),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).width * .35,
                      child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        crossAxisCount: 3,
                        childAspectRatio: .75,
                        mainAxisSpacing: 32.w,
                        crossAxisSpacing: 32.h,
                        children: List.generate(
                          uploadFilesTitles.length,
                          (index) => UploadFileWidget(
                            title: uploadFilesTitles[index],
                          ),
                        ),
                      ),
                    ),
                    const Sizer(),
                    DefaultTextFormField(
                      currentController: licenseNumberController,
                      fillColor: AppColors.GREYBG,
                      borderColor: Colors.transparent,
                      hint: LocaleKeys.licenseNumber.localize,
                    ),
                    const Sizer(),
                    DefaultTextFormField(
                      currentController: expirationDateController,
                      fillColor: AppColors.GREYBG,
                      borderColor: Colors.transparent,
                      hint: LocaleKeys.expireDate.localize,
                    ),
                  ],
                ),
              ),
            ),
          ),
          RegisterNextRow(
            index: 2,
            onTap: () => context.push(Routes.truckPersonalDocumentsScreen),
          ),
        ],
      ),
    );
  }
}
