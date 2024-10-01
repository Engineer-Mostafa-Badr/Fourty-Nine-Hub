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
      "Medical Service": preferences.medicalService,
      "Home Service": preferences.homeService,
      "Craft": preferences.craft,
      "Real Estate": preferences.realEstate,
      "Equipment": preferences.equipment,
      "Spare Parts": preferences.spareParts,
      "Cars": preferences.cars,
      "Vehicles": preferences.vehicles,
      "Smoking": preferences.smoking,
      "Remnants": preferences.remnants,
      "Raw Materials": preferences.rawMaterials,
      "Wholesale Trade": preferences.wholesaleTrade,
      "Home Essentials": preferences.homeEssentials,
      "Mobiles Tablets": preferences.mobilesTablets,
      "Electrical Devices": preferences.electricalDevices,
      "Doctor Job": preferences.doctorJob,
      "Technology": preferences.technology,
      "Packaging": preferences.packaging,
      "Projects": preferences.projects,
      "Computers Cameras": preferences.computersCameras,
      "Marketing Sales": preferences.marketingSales,
      "Talent": preferences.talent,
      "Scenery": preferences.scenery,
      "Accountant Job": preferences.accountantJob,
      "Engineer Job": preferences.engineerJob,
      "Events": preferences.events,
      "Musical Instruments": preferences.musicalInstruments,
      "Travel Tourism": preferences.travelTourism,
      "Education": preferences.education,
      "Handmades": preferences.handmades,
      "Other Job": preferences.otherJob,
      "Fitness": preferences.fitness,
      "Libraries": preferences.libraries,
      "Healthy Tools": preferences.healthyTools,
      "Jewelry Watches": preferences.jewelryWatches,
      "Accessories": preferences.accessories,
      "Charitys": preferences.charitys,
      "Collectibles Gifts": preferences.collectiblesGifts,
      "Discounts Offers": preferences.discountsOffers,
      "Fashion Beauty": preferences.fashionBeauty,
      "Animals": preferences.animals,
      "Ports": preferences.ports,
      "Dating": preferences.dating,
      "Farming": preferences.farming,
      "Government Services": preferences.governmentServices,
      "Social": preferences.social,
    };
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(LocaleKeys.favoriteCategory.localize),
      ),
      body: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) =>
        serviceLocator<CustomPageCubit>()..fetchFavouriteCat(),
        child: BlocBuilder<CustomPageCubit, CustomPageState>(
          builder: (BuildContext context, state) {
            if (state.status == CustomPageStates.success) {
              // Only initialize the categories map once
              if (_categoriesMap.isEmpty) {
                _categoriesMap = _initFavouriteCategories(state.favourite!);
              }

              return ListView.builder(
                itemCount: _categoriesMap.length,
                itemBuilder: (context, index) {
                  final categoryName = _categoriesMap.keys.elementAt(index);
                  final isSelected = _categoriesMap[categoryName]!;

                  return ListTile(
                    leading: Checkbox(
                      value: isSelected,
                      checkColor: Theme.of(context).scaffoldBackgroundColor,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (bool? value) {
                        setState(() {
                          _categoriesMap[categoryName] = value ?? false;
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
              return Center(child: Text(LocaleKeys.failedToLoadCategories.localize));
            }
          },
        ),
      ),
      floatingActionButton: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) => serviceLocator(),
        child: BlocConsumer<CustomPageCubit, CustomPageState>(
          listener: (BuildContext context, state) {
            if (state.status == CustomPageStates.success) {
              showSuccessMessage(context, LocaleKeys.updateSuccessfully.localize);
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
                  context.read<CustomPageCubit>().updateFavouriteCat(FavouriteCatParams(
                    animals: _categoriesMap["Animals"] ?? false,
                    cars: _categoriesMap["Cars"] ?? false,
                    collectiblesGifts: _categoriesMap["Collectibles Gifts"] ?? false,
                    computersCameras: _categoriesMap["Computers Cameras"] ?? false,
                    craft: _categoriesMap["Craft"] ?? false,
                    dating: _categoriesMap["Dating"] ?? false,
                    discountsOffers: _categoriesMap["Discounts Offers"] ?? false,
                    doctorJob: _categoriesMap["Doctor Job"] ?? false,
                    electricalDevices: _categoriesMap["Electrical Devices"] ?? false,
                    equipment: _categoriesMap["Equipment"] ?? false,
                    farming: _categoriesMap["Farming"] ?? false,
                    fashionBeauty: _categoriesMap["Fashion Beauty"] ?? false,
                    governmentServices: _categoriesMap["Government Services"] ?? false,
                    homeEssentials: _categoriesMap["Home Essentials"] ?? false,
                    homeService: _categoriesMap["Home Service"] ?? false,
                    marketingSales: _categoriesMap["Marketing Sales"] ?? false,
                    medicalService: _categoriesMap["Medical Service"] ?? false,
                    mobilesTablets: _categoriesMap["Mobiles Tablets"] ?? false,
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
                    wholesaleTrade: _categoriesMap["Wholesale Trade"] ?? false,
                    // Adding the missing fields
                    accessories: _categoriesMap["Accessories"] ?? false,
                    accountantJob: _categoriesMap["Accountant Job"] ?? false,
                    charitys: _categoriesMap["Charitys"] ?? false,
                    education: _categoriesMap["Education"] ?? false,
                    engineerJob: _categoriesMap["Engineer Job"] ?? false,
                    events: _categoriesMap["Events"] ?? false,
                    fitness: _categoriesMap["Fitness"] ?? false,
                    handmades: _categoriesMap["Handmades"] ?? false,
                    healthyTools: _categoriesMap["Healthy Tools"] ?? false,
                    jewelryWatches: _categoriesMap["Jewelry Watches"] ?? false,
                    libraries: _categoriesMap["Libraries"] ?? false,
                    musicalInstruments: _categoriesMap["Musical Instruments"] ?? false,
                    scenery: _categoriesMap["Scenery"] ?? false,
                    talent: _categoriesMap["Talent"] ?? false,
                    travelTourism: _categoriesMap["Travel Tourism"] ?? false,
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
              child: Icon(Icons.check, color: Theme.of(context).scaffoldBackgroundColor),
            );
          },
        ),
      ),
    );
  }
}