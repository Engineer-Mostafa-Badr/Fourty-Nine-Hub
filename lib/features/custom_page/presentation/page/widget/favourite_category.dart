import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_states.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/edit_page_cubit/edit_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/edit_page.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../core/messages/messages.dart';
import '../../../../../core/widget/custom_scaffold.dart';
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
      "Home Service": preferences.homeService.enabled,
      "Craft": preferences.craft.enabled,
      "Real Estate": preferences.realEstate.enabled,
      "Cars": preferences.cars.enabled,
      "Smoking": preferences.smoking.enabled,
      "Home Essentials": preferences.homeEssentials.enabled,
      "Technology": preferences.technology.enabled,
      "Projects": preferences.projects.enabled,
      "Computers Cameras": preferences.computersCameras.enabled,
      "Musical Instruments": preferences.musicalInstruments.enabled,
      "Travel Tourism": preferences.travelTourism.enabled,
      "Libraries": preferences.libraries.enabled,
      "Fashion Beauty": preferences.fashionBeauty.enabled,
      "Animals": preferences.animals.enabled,
      "Farming": preferences.farming.enabled,
      "Government Services": preferences.governmentServices.enabled,
      "Social": preferences.industry.enabled,
    };
  }

  List<String> _getLocalizedNames(FavouriteCatEntity preferences) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return [
      isArabic ? preferences.homeService.nameAr : preferences.homeService.nameEn,
      isArabic ? preferences.craft.nameAr : preferences.craft.nameEn,
      isArabic ? preferences.realEstate.nameAr : preferences.realEstate.nameEn,
      isArabic ? preferences.cars.nameAr : preferences.cars.nameEn,
      isArabic ? preferences.smoking.nameAr : preferences.smoking.nameEn,
      isArabic ? preferences.homeEssentials.nameAr : preferences.homeEssentials.nameEn,
      isArabic ? preferences.technology.nameAr : preferences.technology.nameEn,
      isArabic ? preferences.projects.nameAr : preferences.projects.nameEn,
      isArabic ? preferences.computersCameras.nameAr : preferences.computersCameras.nameEn,
      isArabic ? preferences.musicalInstruments.nameAr : preferences.musicalInstruments.nameEn,
      isArabic ? preferences.travelTourism.nameAr : preferences.travelTourism.nameEn,
      isArabic ? preferences.libraries.nameAr : preferences.libraries.nameEn,
      isArabic ? preferences.fashionBeauty.nameAr : preferences.fashionBeauty.nameEn,
      isArabic ? preferences.animals.nameAr : preferences.animals.nameEn,
      isArabic ? preferences.farming.nameAr : preferences.farming.nameEn,
      isArabic ? preferences.governmentServices.nameAr : preferences.governmentServices.nameEn,
      isArabic ? preferences.industry.nameAr : preferences.industry.nameEn,
    ];
  }

  bool isNextShow = true;
  late ScrollController controller;
  initState() {
    super.initState();
    controller = ScrollController();
    controller.addListener(() {
      changeNextVisibleState();
    });
  }

  void changeNextVisibleState() {
    if (controller.position.userScrollDirection == ScrollDirection.reverse) {
      isNextShow = false;
    } else {
      isNextShow = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
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
              return Column(
                children: [
                  ListTile(
                    title: Text(LocaleKeys.favoriteCategory.localize),
                    subtitle: Text(LocaleKeys.favouriteDescrepion.localize),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: _categoriesMap.length,
                      itemBuilder: (context, index) {
                        final categoryName = localizedNames[index];
                        final isSelected =
                            _categoriesMap.values.elementAt(index);
                        return ListTile(
                          leading: Checkbox(
                            shape: const CircleBorder(),
                            value: isSelected,
                            checkColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (bool? value) {
                              setState(() {
                                _categoriesMap[_categoriesMap.keys
                                    .elementAt(index)] = value ?? false;
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
                    ),
                  ),
                ],
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
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isNextShow ? 1.0 : 0.0,
        child: BlocProvider<CustomPageCubit>(
          create: (BuildContext context) => serviceLocator(),
          child: BlocConsumer<CustomPageCubit, CustomPageState>(
            listener: (BuildContext context, state) {
              if (state.status == CustomPageStates.success) {
                showSuccessMessage(
                    context, LocaleKeys.updateSuccessfully.localize);
                BlocProvider.of<EditPageCubit>(context).changePage(
                    BlocProvider.of<EditPageCubit>(context).currentIndex + 1);
              }
            },
            builder: (BuildContext context, Object? state) {
              return CustomElevatedButton(
                child: Text(
                  LocaleKeys.next.localize,
                  style: const TextStyle(color: AppColors.whiteColor),
                ),
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
                          rawMaterials:
                              _categoriesMap["Raw Materials"] ?? false,
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
                          healthyTools:
                              _categoriesMap["Healthy Tools"] ?? false,
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
              );
            },
          ),
        ),
      ),
    );
  }
}
