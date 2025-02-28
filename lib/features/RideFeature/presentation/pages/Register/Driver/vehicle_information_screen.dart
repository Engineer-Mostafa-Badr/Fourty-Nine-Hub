import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/hex_color_helper.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import '../widgets/close_widget.dart';
import '../widgets/register_expansion_tile.dart';
import '../widgets/register_floating_action_button.dart';
import '../widgets/upload_file_widget.dart';

class VehicleInformationScreen extends StatelessWidget {
  const VehicleInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> uploadFilesTitles = [
      LocaleKeys.vehiclePicture.localize,
      LocaleKeys.backSideOfTheCertificate.localize,
      LocaleKeys.vehiclePicture.localize
    ];
    List<String> vehicleBrand = [
      'Alfa Romeo',
      'Aston Martin',
      'Audi',
      'BMW',
      'Baic',
      'Bestune',
      'Brilliance',
      'Buick'
    ];

    List<String> vehicleModel = [
      'A1',
      'MZ 40',
      'X3',
    ];

    List<Map> vehicleColor=[
      {
        "color":'000000',
        "text":'Black'
      },
      {
        "color":'ffffff',
        "text":'White'
      },
      {
        "color":'00ff00',
        "text":'Green'
      },
      {
        "color":'ff0000',
        "text":'Red'
      },
      {
        "color":'0000ff',
        "text":'Blue'
      },
    ];
    TextEditingController yearOfProductionController = TextEditingController();
    TextEditingController expirationDateController = TextEditingController();
    TextEditingController licensePlateNumberController =
        TextEditingController();
    return CustomScaffold(
      appBar: const HomeAppbar(),
      floatingActionButton: registerFloatingActionButton(
        context,
        index: 4,
        onTap: () => context.push(Routes.moreInfoScreen),
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
                text: LocaleKeys.vehicleInformation.localize,
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
              RegisterExpansionTile(
                title: Label(text: LocaleKeys.vehicleBrand.localize),
                children: List.generate(vehicleBrand.length,
                    (index) => Label(text: vehicleBrand[index])),
                onChange: (Widget selectedItem) {
                  // print("Selected Item: ${(selectedItem as Label).text}");
                },
              ),
              const Sizer(),
              RegisterExpansionTile(
                title: Label(text: LocaleKeys.vehicleModel.localize),
                children: List.generate(vehicleModel.length,
                        (index) => Label(text: vehicleModel[index])),
                onChange: (Widget selectedItem) {
                  print("Selected Item: ${(selectedItem as Label).text}");
                },
              ),
              const Sizer(),
              RegisterExpansionTile(
                title: Label(text: LocaleKeys.vehicleColor.localize),
                children: List.generate(vehicleColor.length,
                        (index) => Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: HexColor(vehicleColor[index]['color']),
                              ),
                            ),
                            const Sizer(),
                            Label(text: vehicleColor[index]['text']),
                          ],
                        )),
                onChange: (Widget selectedItem) {
                  print("Selected Item: ${(selectedItem).toString()}");
                },
              ),
              const Sizer(),
              DefaultTextFormField(
                currentController: yearOfProductionController,
                fillColor: AppColors.GREYBG,
                borderColor: Colors.transparent,
                hint: LocaleKeys.yearOfProduction.localize,
              ),
              const Sizer(),
              DefaultTextFormField(
                currentController: licensePlateNumberController,
                fillColor: AppColors.GREYBG,
                borderColor: Colors.transparent,
                hint: LocaleKeys.licensePlateNumber.localize,
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
