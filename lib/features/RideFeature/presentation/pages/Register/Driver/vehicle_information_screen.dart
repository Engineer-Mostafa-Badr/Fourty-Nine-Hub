import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
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
          child: BlocBuilder<RideCubit, RideState>(
            builder: (context,state) {
              var cubit = context.read<RideCubit>();
              return Column(
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
                        (index) => UploadFileWidget(
                          title: uploadFilesTitles[index],
                          onTap: (){
                            if(index==0){
                              cubit.onUploadVehicleFrontPicture(context);
                            }else if(index==1){
                              cubit.onUploadVehicleBackPicture(context);
                            }else{
                              cubit.onUploadVehiclePicture(context);
                            }
                          },
                          imageUrl: index==0?state.vehicleFrontPicture:index==1?state.vehicleBackPicture:state.vehiclePicture,
                        ),
                      ),
                    ),
                  ),
                  const Sizer(),
                  RegisterExpansionTile(
                    title: Label(text: LocaleKeys.vehicleBrand.localize),
                    children: List.generate(state.brands?.length??0,
                        (index) => Label(text: state.brands?[index]??'')),
                    onChange: (Widget selectedItem) {
                      // print("Selected Item: ${(selectedItem as Label).text}");
                    },
                  ),
                  const Sizer(),
                  RegisterExpansionTile(
                    title: Label(text: LocaleKeys.vehicleModel.localize),
                    children: List.generate(state.models?.length??0,
                            (index) => Label(text: state.models?[index]??'')),
                    onChange: (Widget selectedItem) {
                      print("Selected Item: ${(selectedItem as Label).text}");
                    },
                  ),
                  const Sizer(),
                  RegisterExpansionTile(
                    title: Label(text: LocaleKeys.vehicleColor.localize),
                    children: List.generate(state.colors?.length??0,
                            (index) => Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: HexColor(state.colors?[index].code??''),
                                  ),
                                ),
                                const Sizer(),
                                Label(text: context.isArabic?(state.colors?[index].nameAr??''):state.colors?[index].nameEn??''),
                              ],
                            )),
                    onChange: (Widget selectedItem) {
                      print("Selected Item: ${(selectedItem).toString()}");
                    },
                  ),
                  const Sizer(),
                  DefaultTextFormField(
                    currentController: cubit.rideVehicleProductionYearController,
                    fillColor: AppColors.GREYBG,
                    borderColor: Colors.transparent,
                    hint: LocaleKeys.yearOfProduction.localize,
                  ),
                  const Sizer(),
                  DefaultTextFormField(
                    currentController: cubit.rideVehicleLicenseNumController,
                    fillColor: AppColors.GREYBG,
                    borderColor: Colors.transparent,
                    hint: LocaleKeys.licensePlateNumber.localize,
                  ),
                  const Sizer(),
                  DefaultTextFormField(
                    currentController: cubit.rideVehicleExpireDateController,
                    fillColor: AppColors.GREYBG,
                    borderColor: Colors.transparent,
                    hint: LocaleKeys.expireDate.localize,
                  ),

                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
