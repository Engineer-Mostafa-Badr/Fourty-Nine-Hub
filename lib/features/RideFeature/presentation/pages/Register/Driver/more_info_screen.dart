import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import 'package:go_router/go_router.dart';

import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/core/widget/custom_switch_list_title.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import '../widgets/close_widget.dart';
import '../widgets/register_expansion_tile.dart';
import '../widgets/register_floating_action_button.dart';

class MoreInfoScreen extends StatelessWidget {
  const MoreInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> subscriptionPlans = [
      'Percentage',
      'Subscribe Package',
    ];
    List<String> favoriteCity = [
      'Cairo',
      'Giza',
      'Alexandria',
      'Dakahlia',
      'Red Sea',
      'Beheira',
      'Fayoum',
      'Gharbia',
      'Ismailia',
      'Menoufia',
    ];
    TextEditingController pricingPerKmController = TextEditingController();

    return CustomScaffold(
      appBar: const HomeAppbar(),
      floatingActionButton: registerFloatingActionButton(
        context,
        index: 5,
        onTap: () => context.push(Routes.completeRegisterScreen),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              closeWidget(context),
              Label(
                text: LocaleKeys.moreInfo.localize,
                style: Styles.headerText(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Sizer(),
              RegisterExpansionTile(
                title: Label(text: LocaleKeys.subscriptionPlan.localize),
                children: List.generate(subscriptionPlans.length,
                    (index) => Label(text: subscriptionPlans[index])),
                onChange: (Widget selectedItem) {
                  // print("Selected Item: ${(selectedItem as Label).text}");
                },
              ),
              const Sizer(),
              RegisterExpansionTile(
                title: Label(text: LocaleKeys.favoriteCity.localize),
                children: List.generate(favoriteCity.length,
                    (index) => Label(text: favoriteCity[index])),
                onChange: (Widget selectedItem) {
                  // print("Selected Item: ${(selectedItem as Label).text}");
                },
              ),
              const Sizer(),
              DefaultTextFormField(
                currentController: pricingPerKmController,
                // fillColor: AppColors.GREYBG,
                // borderColor: Colors.transparent,
                hint: LocaleKeys.pricingPerKm.localize,
              ),
              const Sizer(),
              CustomSwitchListTile(
                title: Text(
                  LocaleKeys.nonSmokerDriver.localize,
                  style: Styles.mediumText(
                      fontSize: 65.sp, fontWeight: FontWeight.w400),
                ),
                value: true,
                onChanged: (value) async {},
              ),
              CustomSwitchListTile(
                title: Text(
                  LocaleKeys.captainShare.localize,
                  style: Styles.mediumText(
                      fontSize: 65.sp, fontWeight: FontWeight.w400),
                ),
                value: false,
                onChanged: (value) async {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
