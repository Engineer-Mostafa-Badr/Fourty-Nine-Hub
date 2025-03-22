import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../widgets/close_widget.dart';
import '../widgets/register_expansion_tile.dart';
import '../widgets/register_floating_action_button.dart';

class TruckMoreInfoScreen extends StatelessWidget {
  const TruckMoreInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
    return CustomScaffold(
      appBar: const HomeAppbar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32,left: 16,right: 16,),
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
                      title: Label(text: LocaleKeys.favoriteCity.localize),
                      onChange: (Widget selectedItem) {
                        // print("Selected Item: ${(selectedItem as Label).text}");
                      }, length: favoriteCity.length,
                      children: List.generate(favoriteCity.length,
                          (index) => Label(text: favoriteCity[index])),
                    ),
                  ],
                ),
              ),
            ),
          ),
          RegisterNextRow(
            index: 5,
            onTap: () => context.push(Routes.completeRegisterScreen),
          ),
        ],
      ),
    );
  }
}
