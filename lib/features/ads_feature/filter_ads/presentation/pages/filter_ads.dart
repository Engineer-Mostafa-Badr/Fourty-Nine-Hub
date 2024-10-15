import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/selection_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/presentation/pages/widgets/filter_ad_dynamic_inputs.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class FilterAdsView extends StatefulWidget {
  final CategorizationEntity categorization;
  const FilterAdsView({super.key, required this.categorization});

  @override
  State<FilterAdsView> createState() => _FilterAdsViewState();
}

class _FilterAdsViewState extends State<FilterAdsView> {
  @override
  void initState() {
    context.read<CreateAdCubit>().loadData(subCategoryId: widget.categorization.mainCategory.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateAdCubit, CreateAdState>(listener: (context, state) {
      if (state.isError) {
        showErrorMessage(
          context,
          getFailureMessage(
            state.failure!,
            context,
          ),
        );
      }
    }, builder: (context, state) {
      final controller = context.read<CreateAdCubit>();
      return Scaffold(
        appBar: BackAppBar(label: LocaleKeys.filter.localize),
        body: Form(
          key: controller.formState,
          child: BlocBuilder<CreateAdCubit, CreateAdState>(
              builder: (context, state) {
              return ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8.0),
                children: [
                  Row(
                    children: [
                      SquareImage(
                        width: kToolbarHeight * .8,
                        height: kToolbarHeight * .8,
                        radius: 10,
                        url: widget.categorization.subCategory.image,
                      ),
                      const Sizer(),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label(
                            text: widget.categorization.subCategory.name,
                            style: Styles.mediumText(fontWeight: FontWeight.bold),
                          ),
                          Label(text: widget.categorization.mainCategory.name),
                        ],
                      )),
                    ],
                  ),
                  const Divider(),

                  Label(text: LocaleKeys.governorate.localize),
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButtonFormField<GovernorateEntity>(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.grey, // Border color
                            width: 1.0,         // Border width
                          ),
                        ),
                      ),
                      hint: Text(LocaleKeys.selectGovernorate.tr()),
                      value: null,
                      onChanged: (GovernorateEntity? newValue) {
                        controller.selectGovernorate(newValue?.id??'');
                        print("state.governorate${state.governorate}");
                        print("state.city${state.city}");
                        controller.getCities(newValue?.id??'');
                      },
                      dropdownColor: Colors.white,
                      items: state.governorates?.map<DropdownMenuItem<GovernorateEntity>>((GovernorateEntity government) {
                        return DropdownMenuItem<GovernorateEntity>(
                          value: government,
                          child: Text(government.nameEn), // Change to city.nameAr for Arabic
                        );
                      }).toList(),
                    ),
                  ),
                  const Sizer(),
                  state.status==CreateAdStates.loadCities?const Center(child: CircularProgressIndicator()):state.status==CreateAdStates.loadCitiesSuccess?Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Label(text: LocaleKeys.city.localize),
                      SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField<CityEntity>(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.grey, // Border color
                                width: 1.0,         // Border width
                              ),
                            ),
                          ),
                          hint: Text(LocaleKeys.selectCity.tr()),
                          value: null,
                          onChanged: (CityEntity? newValue) {
                            print(newValue?.id);
                            controller.selectCity(newValue?.id??'');
                            print("state.governorate${state.governorate}");
                            print("state.city${state.city}");
                          },
                          dropdownColor: Colors.white,
                          items: state.cities?.map<DropdownMenuItem<CityEntity>>((CityEntity city) {
                            return DropdownMenuItem<CityEntity>(
                              value: city,
                              child: Text(city.nameEn), // Change to city.nameAr for Arabic
                            );
                          }).toList(),
                        ),
                      ),

                    ],
                  ):const SizedBox.shrink(),
                  // const Sizer(),
                  // Label(text: state.isPrice == true ? LocaleKeys.price.localize : LocaleKeys.salary.localize),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: TextFormField(
                  //         maxLines: null,
                  //         onChanged: (v) => controller.priceFrom = v,
                  //         style: Styles.headerText(fontSize: 26),
                  //         keyboardType: TextInputType.number,
                  //         decoration: InputDecoration(
                  //             fillColor: Colors.white,
                  //             contentPadding: const EdgeInsets.all(5),
                  //             hintText: LocaleKeys.from.localize,
                  //             hintStyle: Styles.mediumText(),
                  //             prefix: Sizer(
                  //               width: 20.w,
                  //             )),
                  //         validator: (value) {
                  //           if ((value == null || value.isEmpty)) {
                  //             return LocaleKeys.required.localize;
                  //           } else {
                  //             return null;
                  //           }
                  //         },
                  //       ),
                  //     ),
                  //     const Sizer(),
                  //     Expanded(
                  //       child: TextFormField(
                  //         maxLines: null,
                  //         onChanged: (v) => controller.priceTo = v,
                  //         keyboardType: TextInputType.number,
                  //         style: Styles.headerText(fontSize: 26),
                  //         decoration: InputDecoration(
                  //             fillColor: Colors.white,
                  //             contentPadding: const EdgeInsets.all(5),
                  //             hintText: LocaleKeys.to.localize ,
                  //             hintStyle: Styles.mediumText(),
                  //             prefix: Sizer(
                  //               width: 20.w,
                  //             )),
                  //         validator:(value) {
                  //           if((value == null || value.isEmpty)){
                  //             return LocaleKeys.required.localize;
                  //           }else{
                  //             return null;
                  //           }
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const Sizer(),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final property = state.filterAdProperties![index];
                      return FilterAdDynamicInputWidget(
                        property: property,
                        onChanged: (SelectionEntity v) => controller.onChanged(v: v, index: index),
                        onTextChanged: (String v,bool from,String type) => controller.onTextChanged(v: v, index: index,isNumber: property.type=='number',from: from,type: type),
                      );
                    },
                    separatorBuilder: (context, index) => const Sizer(),
                    shrinkWrap: true,
                    itemCount: state.filterAdProperties?.length??0,
                  ),
                  const Sizer(),
                  DefaultButton(
                      label: LocaleKeys.filter.localize,
                      onPressed: () {
                        controller.filterAds(categorize: widget.categorization, context: context);
                      }),
                ],
              );}

          ),
        ),
      );
    });
  }

}
