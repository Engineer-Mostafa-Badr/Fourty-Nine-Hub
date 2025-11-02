import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/entities/city_entity.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import '../../../../../core/widget/custom_scaffold.dart';

class GovernorateFilterAdsView extends StatefulWidget {
  final CategorizationEntity categorization;

  const GovernorateFilterAdsView({super.key, required this.categorization});

  @override
  State<GovernorateFilterAdsView> createState() =>
      _GovernorateFilterAdsViewState();
}

class _GovernorateFilterAdsViewState extends State<GovernorateFilterAdsView> {
  @override
  void initState() {
    context.read<CreateAdCubit>().loadGovernorateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateAdCubit, CreateAdState>(
        listener: (context, state) {
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
      return CustomScaffold(
        enableCustomAppBar: true,
        appBar: BackAppBar(
            label: "${LocaleKeys.filter.localize} ${LocaleKeys.city.localize}"),
        body: Expanded(
          child: ListView(
            padding: EdgeInsets.all(16),
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(text: LocaleKeys.governorate.localize),
              SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField<GovernorateEntity>(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.grey, // Border color
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.grey, // Border color
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.grey, // Border color
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.grey, // Border color
                      ),
                    ),
                  ),
                  hint: Text(LocaleKeys.selectGovernorate.tr()),
                  initialValue: null,
                  onChanged: (GovernorateEntity? newValue) {
                    controller.selectGovernorate(newValue?.id ?? '');
                    print("state.governorate${state.governorate}");
                    print("state.city${state.city}");
                    controller.getCities(newValue?.id ?? '');
                  },
                  dropdownColor: context.isDarkMode
                      ? AppColors.QUANTITY_COLOR
                      : Colors.white,
                  items: state.governorates
                      ?.map<DropdownMenuItem<GovernorateEntity>>(
                          (GovernorateEntity government) {
                    return DropdownMenuItem<GovernorateEntity>(
                      value: government,
                      child: Text(getLang() == 'ar'
                          ? government.nameAr
                          : government
                              .nameEn), // Change to city.nameAr for Arabic
                    );
                  }).toList(),
                ),
              ),
              const Sizer(),
              state.status == CreateAdStates.loadCities
                  ? const Center(child: CustomCircularProgressIndicator())
                  : state.status == CreateAdStates.loadCitiesSuccess
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Label(text: LocaleKeys.city.localize),
                            SizedBox(
                              width: double.infinity,
                              child: DropdownButtonFormField<CityEntity>(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Colors.grey, // Border color
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Colors.grey, // Border color
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Colors.grey, // Border color
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Colors.grey, // Border color
                                    ),
                                  ),
                                ),
                                hint: Text(LocaleKeys.selectCity.tr()),
                                initialValue: null,
                                onChanged: (CityEntity? newValue) {
                                  print(newValue?.id);
                                  controller.selectCity(newValue?.id ?? '');
                                  print(
                                      "state.governorate${state.governorate}");
                                  print("state.city${state.city}");
                                },
                                dropdownColor: context.isDarkMode
                                    ? AppColors.QUANTITY_COLOR
                                    : Colors.white,
                                items: state.cities
                                    ?.map<DropdownMenuItem<CityEntity>>(
                                        (CityEntity city) {
                                  return DropdownMenuItem<CityEntity>(
                                    value: city,
                                    child: Text(getLang() == 'ar'
                                        ? city.nameAr
                                        : city
                                            .nameEn), // Change to city.nameAr for Arabic
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
              const Sizer(),
              DefaultButton(
                  width: double.infinity,
                  label: LocaleKeys.filter.localize,
                  onPressed: () {
                    ManageVibration.vibrate();
                    controller.filterGovernorateAds(
                        categorize: widget.categorization, context: context);
                  }),
            ],
          ),
        ),
      );
    });
  }
}
