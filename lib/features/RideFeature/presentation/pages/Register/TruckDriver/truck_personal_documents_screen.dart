import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:go_router/go_router.dart';

import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';

import '../widgets/close_widget.dart';
import '../widgets/register_floating_action_button.dart';
import '../widgets/upload_file_widget.dart';

class TruckPersonalDocumentsScreen extends StatelessWidget {
  const TruckPersonalDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> uploadFilesTitles = [
      LocaleKeys.nationalIdCard.localize,
      LocaleKeys.backOfTheId.localize,
    ];
    TextEditingController idNumberController = TextEditingController();
    TextEditingController expirationDateController = TextEditingController();
    return CustomScaffold(
      appBar: const HomeAppbar(),
      floatingActionButton: registerFloatingActionButton(
        context,
        index: 3,
        onTap: () => context.push(Routes.truckVehicleInformationScreen),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32,left: 16,right: 16,),
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              closeWidget(context),
              Label(
                text: LocaleKeys.personalDocuments.localize,
                style: Styles.headerText(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Sizer(),
              SizedBox(
                height: MediaQuery.sizeOf(context).width*.35,
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  crossAxisCount: 3,
                  childAspectRatio: .75,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: List.generate(
                    uploadFilesTitles.length,
                    (index) => uploadFileWidget(
                      title: uploadFilesTitles[index],
                    ),
                  ),
                ),
              ),
              const Sizer(),
              DefaultTextFormField(
                currentController: idNumberController,
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
    );
  }
}
