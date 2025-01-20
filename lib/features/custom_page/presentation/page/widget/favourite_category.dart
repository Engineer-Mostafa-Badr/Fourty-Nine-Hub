import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_states.dart';

import '../../../../../core/messages/messages.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../domain/entity/favourite_categ_entity.dart';
import '../../../domain/use_case/update_favourite_cat_use_case.dart';

class FavouriteCategory extends StatefulWidget {
  const FavouriteCategory({super.key});

  @override
  _FavouriteCategoryState createState() => _FavouriteCategoryState();
}

class _FavouriteCategoryState extends State<FavouriteCategory> {
  // A map to keep track of selected categories
  Map<String, bool> _categoriesMap = {};

  // Method to initialize categories based on UserPreferences
  Map<String, bool> _initFavouriteCategories(FavouriteCatEntity preferences) {
    return {
      "Medical Service": preferences.medicalService.enabled,
      "Home Service": preferences.homeService.enabled,
      "Craft": preferences.craft.enabled,
      "Real Estate": preferences.realEstate.enabled,
      "Equipment": preferences.equipment.enabled,
      "Spare Parts": preferences.spareParts.enabled,
      "Cars": preferences.cars.enabled,
      "Vehicles": preferences.vehicles.enabled,
      "Smoking": preferences.smoking.enabled,
      "Remnants": preferences.remnants.enabled,
      "Raw Materials": preferences.rawMaterials.enabled,
      "Wholesale Trade": preferences.wholesaleTrade.enabled,
      "Home Essentials": preferences.homeEssentials.enabled,
      "Mobiles Tablets": preferences.mobilesTablets.enabled,
      "Electrical Devices": preferences.electricalDevices.enabled,
      "Doctor Job": preferences.doctorJob.enabled,
      "Technology": preferences.technology.enabled,
      "Packaging": preferences.packaging.enabled,
      "Projects": preferences.projects.enabled,
      "Computers Cameras": preferences.computersCameras.enabled,
      "Marketing Sales": preferences.marketingSales.enabled,
      "Talent": preferences.talent.enabled,
      "Scenery": preferences.scenery.enabled,
      "Accountant Job": preferences.accountantJob.enabled,
      "Engineer Job": preferences.engineerJob.enabled,
      "Events": preferences.events.enabled,
      "Musical Instruments": preferences.musicalInstruments.enabled,
      "Travel Tourism": preferences.travelTourism.enabled,
      "Education": preferences.education.enabled,
      "Handmades": preferences.handmades.enabled,
      "Other Job": preferences.otherJob.enabled,
      "Fitness": preferences.fitness.enabled,
      "Libraries": preferences.libraries.enabled,
      "Healthy Tools": preferences.healthyTools.enabled,
      "Jewelry Watches": preferences.jewelryWatches.enabled,
      "Accessories": preferences.accessories.enabled,
      "Charitys": preferences.charitys.enabled,
      "Collectibles Gifts": preferences.collectiblesGifts.enabled,
      "Discounts Offers": preferences.discountsOffers.enabled,
      "Fashion Beauty": preferences.fashionBeauty.enabled,
      "Animals": preferences.animals.enabled,
      "Ports": preferences.ports.enabled,
      "Dating": preferences.dating.enabled,
      "Farming": preferences.farming.enabled,
      "Government Services": preferences.governmentServices.enabled,
      "Social": preferences.social.enabled,
    };
  }

  List<String> _getLocalizedNames(FavouriteCatEntity preferences) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return [
      isArabic
          ? preferences.medicalService.nameAr
          : preferences.medicalService.nameEn,
      isArabic
          ? preferences.homeService.nameAr
          : preferences.homeService.nameEn,
      isArabic ? preferences.craft.nameAr : preferences.craft.nameEn,
      isArabic ? preferences.realEstate.nameAr : preferences.realEstate.nameEn,
      isArabic ? preferences.equipment.nameAr : preferences.equipment.nameEn,
      isArabic ? preferences.spareParts.nameAr : preferences.spareParts.nameEn,
      isArabic ? preferences.cars.nameAr : preferences.cars.nameEn,
      isArabic ? preferences.vehicles.nameAr : preferences.vehicles.nameEn,
      isArabic ? preferences.smoking.nameAr : preferences.smoking.nameEn,
      isArabic ? preferences.remnants.nameAr : preferences.remnants.nameEn,
      isArabic
          ? preferences.rawMaterials.nameAr
          : preferences.rawMaterials.nameEn,
      isArabic
          ? preferences.wholesaleTrade.nameAr
          : preferences.wholesaleTrade.nameEn,
      isArabic
          ? preferences.homeEssentials.nameAr
          : preferences.homeEssentials.nameEn,
      isArabic
          ? preferences.mobilesTablets.nameAr
          : preferences.mobilesTablets.nameEn,
      isArabic
          ? preferences.electricalDevices.nameAr
          : preferences.electricalDevices.nameEn,
      isArabic ? preferences.doctorJob.nameAr : preferences.doctorJob.nameEn,
      isArabic ? preferences.technology.nameAr : preferences.technology.nameEn,
      isArabic ? preferences.packaging.nameAr : preferences.packaging.nameEn,
      isArabic ? preferences.projects.nameAr : preferences.projects.nameEn,
      isArabic
          ? preferences.computersCameras.nameAr
          : preferences.computersCameras.nameEn,
      isArabic
          ? preferences.marketingSales.nameAr
          : preferences.marketingSales.nameEn,
      isArabic ? preferences.talent.nameAr : preferences.talent.nameEn,
      isArabic ? preferences.scenery.nameAr : preferences.scenery.nameEn,
      isArabic
          ? preferences.accountantJob.nameAr
          : preferences.accountantJob.nameEn,
      isArabic
          ? preferences.engineerJob.nameAr
          : preferences.engineerJob.nameEn,
      isArabic ? preferences.events.nameAr : preferences.events.nameEn,
      isArabic
          ? preferences.musicalInstruments.nameAr
          : preferences.musicalInstruments.nameEn,
      isArabic
          ? preferences.travelTourism.nameAr
          : preferences.travelTourism.nameEn,
      isArabic ? preferences.education.nameAr : preferences.education.nameEn,
      isArabic ? preferences.handmades.nameAr : preferences.handmades.nameEn,
      isArabic ? preferences.otherJob.nameAr : preferences.otherJob.nameEn,
      isArabic ? preferences.fitness.nameAr : preferences.fitness.nameEn,
      isArabic ? preferences.libraries.nameAr : preferences.libraries.nameEn,
      isArabic
          ? preferences.healthyTools.nameAr
          : preferences.healthyTools.nameEn,
      isArabic
          ? preferences.jewelryWatches.nameAr
          : preferences.jewelryWatches.nameEn,
      isArabic
          ? preferences.accessories.nameAr
          : preferences.accessories.nameEn,
      isArabic ? preferences.charitys.nameAr : preferences.charitys.nameEn,
      isArabic
          ? preferences.collectiblesGifts.nameAr
          : preferences.collectiblesGifts.nameEn,
      isArabic
          ? preferences.discountsOffers.nameAr
          : preferences.discountsOffers.nameEn,
      isArabic
          ? preferences.fashionBeauty.nameAr
          : preferences.fashionBeauty.nameEn,
      isArabic ? preferences.animals.nameAr : preferences.animals.nameEn,
      isArabic ? preferences.ports.nameAr : preferences.ports.nameEn,
      isArabic ? preferences.dating.nameAr : preferences.dating.nameEn,
      isArabic ? preferences.farming.nameAr : preferences.farming.nameEn,
      isArabic
          ? preferences.governmentServices.nameAr
          : preferences.governmentServices.nameEn,
      isArabic ? preferences.social.nameAr : preferences.social.nameEn,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(LocaleKeys.favoriteCategory.localize),
      ),
      body: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) =>
            serviceLocator<CustomPageCubit>()..fetchFavouriteCat(),
        child: BlocBuilder<CustomPageCubit, CustomPageState>(
          builder: (BuildContext context, state) {
            if (state.status == CustomPageStates.success) {
              if (_categoriesMap.isEmpty) {
                _categoriesMap = _initFavouriteCategories(state.favourite!);
              }
              final localizedNames = _getLocalizedNames(state.favourite!);
              return ListView.builder(
                itemCount: _categoriesMap.length,
                itemBuilder: (context, index) {
                  final categoryName = localizedNames[index];
                  final isSelected = _categoriesMap.values.elementAt(index);
                  return ListTile(
                    leading: Checkbox(
                      value: isSelected,
                      checkColor: Theme.of(context).scaffoldBackgroundColor,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (bool? value) {
                        setState(() {
                          _categoriesMap[_categoriesMap.keys.elementAt(index)] =
                              value ?? false;
                        });
                      },
                    ),
                    title: Text(
                      categoryName,
                      style: Styles.mediumText(
                          fontSize: 65.sp,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).primaryColor),
                    ),
                    selected: isSelected,
                  );
                },
              );
            } else if (state.status == CustomPageStates.loading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Center(
                  child: Text(LocaleKeys.failedToLoadCategories.localize));
            }
          },
        ),
      ),
      floatingActionButton: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) => serviceLocator(),
        child: BlocConsumer<CustomPageCubit, CustomPageState>(
          listener: (BuildContext context, state) {
            if (state.status == CustomPageStates.success) {
              showSuccessMessage(
                  context, LocaleKeys.updateSuccessfully.localize);
            }
          },
          builder: (BuildContext context, Object? state) {
            return FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                // Collect selected categories
                final selectedCategories = _categoriesMap.entries
                    .where((entry) => entry.value == true)
                    .map((entry) => entry.key)
                    .toList();

                if (selectedCategories.length >= 3 &&
                    selectedCategories.length <= 8) {
                  context
                      .read<CustomPageCubit>()
                      .updateFavouriteCat(FavouriteCatParams(
                        animals: _categoriesMap["Animals"] ?? false,
                        cars: _categoriesMap["Cars"] ?? false,
                        collectiblesGifts:
                            _categoriesMap["Collectibles Gifts"] ?? false,
                        computersCameras:
                            _categoriesMap["Computers Cameras"] ?? false,
                        craft: _categoriesMap["Craft"] ?? false,
                        dating: _categoriesMap["Dating"] ?? false,
                        discountsOffers:
                            _categoriesMap["Discounts Offers"] ?? false,
                        doctorJob: _categoriesMap["Doctor Job"] ?? false,
                        electricalDevices:
                            _categoriesMap["Electrical Devices"] ?? false,
                        equipment: _categoriesMap["Equipment"] ?? false,
                        farming: _categoriesMap["Farming"] ?? false,
                        fashionBeauty:
                            _categoriesMap["Fashion Beauty"] ?? false,
                        governmentServices:
                            _categoriesMap["Government Services"] ?? false,
                        homeEssentials:
                            _categoriesMap["Home Essentials"] ?? false,
                        homeService: _categoriesMap["Home Service"] ?? false,
                        marketingSales:
                            _categoriesMap["Marketing Sales"] ?? false,
                        medicalService:
                            _categoriesMap["Medical Service"] ?? false,
                        mobilesTablets:
                            _categoriesMap["Mobiles Tablets"] ?? false,
                        packaging: _categoriesMap["Packaging"] ?? false,
                        ports: _categoriesMap["Ports"] ?? false,
                        projects: _categoriesMap["Projects"] ?? false,
                        rawMaterials: _categoriesMap["Raw Materials"] ?? false,
                        realEstate: _categoriesMap["Real Estate"] ?? false,
                        remnants: _categoriesMap["Remnants"] ?? false,
                        smoking: _categoriesMap["Smoking"] ?? false,
                        social: _categoriesMap["Social"] ?? false,
                        spareParts: _categoriesMap["Spare Parts"] ?? false,
                        technology: _categoriesMap["Technology"] ?? false,
                        vehicles: _categoriesMap["Vehicles"] ?? false,
                        wholesaleTrade:
                            _categoriesMap["Wholesale Trade"] ?? false,
                        // Adding the missing fields
                        accessories: _categoriesMap["Accessories"] ?? false,
                        accountantJob:
                            _categoriesMap["Accountant Job"] ?? false,
                        charitys: _categoriesMap["Charitys"] ?? false,
                        education: _categoriesMap["Education"] ?? false,
                        engineerJob: _categoriesMap["Engineer Job"] ?? false,
                        events: _categoriesMap["Events"] ?? false,
                        fitness: _categoriesMap["Fitness"] ?? false,
                        handmades: _categoriesMap["Handmades"] ?? false,
                        healthyTools: _categoriesMap["Healthy Tools"] ?? false,
                        jewelryWatches:
                            _categoriesMap["Jewelry Watches"] ?? false,
                        libraries: _categoriesMap["Libraries"] ?? false,
                        musicalInstruments:
                            _categoriesMap["Musical Instruments"] ?? false,
                        scenery: _categoriesMap["Scenery"] ?? false,
                        talent: _categoriesMap["Talent"] ?? false,
                        travelTourism:
                            _categoriesMap["Travel Tourism"] ?? false,
                        otherJob: _categoriesMap["Other Job"] ?? false,
                      ));
                } else {
                  // Show a message if the selection is not valid
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(LocaleKeys.atLeast3atMost8items.localize),
                    ),
                  );
                }
              },
              child: Icon(Icons.check,
                  color: Theme.of(context).scaffoldBackgroundColor),
            );
          },
        ),
      ),
    );
  }
}
