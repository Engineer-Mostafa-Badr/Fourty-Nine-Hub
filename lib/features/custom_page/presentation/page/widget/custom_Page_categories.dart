import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_floating_action_button.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_states.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/edit_page_cubit/edit_page_cubit.dart';

import '../../../../../core/messages/messages.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import 'navigator_subcategories_view.dart';

class FavouriteCategory extends StatefulWidget {
  const FavouriteCategory({super.key});

  @override
  _FavouriteCategoryState createState() => _FavouriteCategoryState();
}

class _FavouriteCategoryState extends State<FavouriteCategory> {
  // // A map to keep track of selected categories
  // Map<String, bool> _categoriesMap = {};
  //
  // // Method to initialize categories based on UserPreferences
  // Map<String, bool> _initFavouriteCategories(CustomPageCategoriesEntity preferences) {
  //   return {
  //     "Home Service": preferences.homeService.enabled,
  //     "Craft": preferences.craft.enabled,
  //     "Real Estate": preferences.realEstate.enabled,
  //     "Cars": preferences.cars.enabled,
  //     "Smoking": preferences.smoking.enabled,
  //     "Home Essentials": preferences.homeEssentials.enabled,
  //     "Technology": preferences.technology.enabled,
  //     "Projects": preferences.projects.enabled,
  //     "Computers Cameras": preferences.computersCameras.enabled,
  //     "Musical Instruments": preferences.musicalInstruments.enabled,
  //     "Travel Tourism": preferences.travelTourism.enabled,
  //     "Libraries": preferences.libraries.enabled,
  //     "Fashion Beauty": preferences.fashionBeauty.enabled,
  //     "Animals": preferences.animals.enabled,
  //     "Farming": preferences.farming.enabled,
  //     "Government Services": preferences.governmentServices.enabled,
  //     "Social": preferences.industry.enabled,
  //     "Jobs": preferences.jobs.enabled,
  //     "Fitness": preferences.fitness.enabled,
  //     "Marriage": preferences.marriage.enabled,
  //   };
  // }
  //
  // List<String> _getLocalizedNames(FavouriteCatEntity preferences) {
  //   final isArabic = Localizations.localeOf(context).languageCode == 'ar';
  //   return [
  //     isArabic
  //         ? preferences.homeService.nameAr
  //         : preferences.homeService.nameEn,
  //     isArabic ? preferences.craft.nameAr : preferences.craft.nameEn,
  //     isArabic ? preferences.realEstate.nameAr : preferences.realEstate.nameEn,
  //     isArabic ? preferences.cars.nameAr : preferences.cars.nameEn,
  //     isArabic ? preferences.smoking.nameAr : preferences.smoking.nameEn,
  //     isArabic
  //         ? preferences.homeEssentials.nameAr
  //         : preferences.homeEssentials.nameEn,
  //     isArabic ? preferences.technology.nameAr : preferences.technology.nameEn,
  //     isArabic ? preferences.projects.nameAr : preferences.projects.nameEn,
  //     isArabic
  //         ? preferences.computersCameras.nameAr
  //         : preferences.computersCameras.nameEn,
  //     isArabic
  //         ? preferences.musicalInstruments.nameAr
  //         : preferences.musicalInstruments.nameEn,
  //     isArabic
  //         ? preferences.travelTourism.nameAr
  //         : preferences.travelTourism.nameEn,
  //     isArabic ? preferences.libraries.nameAr : preferences.libraries.nameEn,
  //     isArabic
  //         ? preferences.fashionBeauty.nameAr
  //         : preferences.fashionBeauty.nameEn,
  //     isArabic ? preferences.animals.nameAr : preferences.animals.nameEn,
  //     isArabic ? preferences.farming.nameAr : preferences.farming.nameEn,
  //     isArabic
  //         ? preferences.governmentServices.nameAr
  //         : preferences.governmentServices.nameEn,
  //     isArabic ? preferences.industry.nameAr : preferences.industry.nameEn,
  //     isArabic ? preferences.jobs.nameAr : preferences.jobs.nameEn,
  //     isArabic ? preferences.marriage.nameAr : preferences.marriage.nameEn,
  //     isArabic ? preferences.fitness.nameAr : preferences.fitness.nameEn,
  //   ];
  // }

  bool isNextShow = true;
  late ScrollController controller;

  @override
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
    return BlocProvider(
      create: (BuildContext context) =>
          serviceLocator<CustomPageCubit>()..fetchFavouriteCat(false),
      child: Scaffold(
        body: BlocBuilder<CustomPageCubit, CustomPageState>(
          builder: (BuildContext context, state) {
            final cubit = context.read<CustomPageCubit>();
            if (state.status == CustomPageStates.success) {
              return Column(
                children: [
                  ListTile(
                    subtitle: Text(LocaleKeys.favouriteDescription.localize),
                  ),
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              context
                                  .read<CustomPageCubit>()
                                  .fetchFavouriteSubCat(
                                      state.favourite![index].id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: cubit
                                      ..fetchFavouriteSubCat(
                                          state.favourite![index].id),
                                    child: NavigatorSubCategoriesView(
                                      mainCategory: state.favourite![index],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withValues(alpha: .0),
                                ),
                                child: Row(
                                  children: [
                                    Label(
                                      text: context.isArabic
                                          ? state.favourite![index].nameAr
                                          : state.favourite![index].nameEn,
                                      style: Styles.mediumText(
                                          fontSize: 65.sp,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    const Spacer(),
                                    if (state.favourite![index].selected)
                                      Image.asset(
                                        Assets.checkCircle,
                                        width: 24,
                                        color: AppColors.PRIMARY_COLOR,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Sizer(),
                        itemCount: state.favourite!.length),
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
        floatingActionButton: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isNextShow ? 1.0 : 0.0,
          child: BlocConsumer<CustomPageCubit, CustomPageState>(
            listener: (BuildContext context, state) {
              print(
                  "🟢 BlocConsumer Listener Triggered! New state: ${state.updateData}");
              if (state.status == CustomPageStates.uploadSubCatSuccess) {
                showSuccessMessage(
                    context, LocaleKeys.updateSuccessfully.localize);
                BlocProvider.of<EditPageCubit>(context).changePage(
                    BlocProvider.of<EditPageCubit>(context).currentIndex + 1);
              }
            },
            builder: (BuildContext context, state) {
              print(
                  "🔵 BlocConsumer Rebuild! Current state: ${state.updateData}");
              return CustomFloatingActionButton(
                onPressed: () {
                  print("🟠 FloatingActionButton Pressed!");
                  print(
                      "📊 Current state.updateData before press: ${state.updateData}");
                  print(
                      "📊 Current state.favourite before press: ${state.favourite}");

                  if (state.updateData!.length >= 3 &&
                      state.updateData!.length <= 5) {
                    context
                        .read<CustomPageCubit>()
                        .updateFavouriteCat(state.updateData!);
                  } else {
                    print(
                        "⚠️ Invalid selection length: ${state.updateData!.length}");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(LocaleKeys.atLeast3atMost5items.localize),
                      ),
                    );
                  }
                },
                text: LocaleKeys.next.localize,
              );
            },
          ),
        ),
        // floatingActionButton: AnimatedOpacity(
        //   duration: const Duration(milliseconds: 300),
        //   opacity: isNextShow ? 1.0 : 0.0,
        //   child: BlocConsumer<CustomPageCubit, CustomPageState>(
        //     listener: (BuildContext context, state) {
        //       if (state.status == CustomPageStates.uploadSubCatSuccess) {
        //         showSuccessMessage(
        //             context, LocaleKeys.updateSuccessfully.localize);
        //         BlocProvider.of<EditPageCubit>(context).changePage(
        //             BlocProvider.of<EditPageCubit>(context).currentIndex + 1);
        //       }
        //     },
        //     builder: (BuildContext context, state) {
        //       return CustomFloatingActionButton(
        //         onPressed: () {
        //           context
        //               .read<CustomPageCubit>()
        //               .updateFavouriteCat();
        //           print("state.updateData ${state.updateData}");
        //           // if (state.updateData == null) return;
        //           if (state.updateData!.length >= 3 &&
        //               state.updateData!.length <= 5) {
        //             // context
        //             //     .read<CustomPageCubit>()
        //             //     .updateFavouriteCat(state.updateData!);
        //           } else {
        //             // Show a message if the selection is not valid
        //             ScaffoldMessenger.of(context).showSnackBar(
        //               SnackBar(
        //                 content: Text(LocaleKeys.atLeast3atMost5items.localize),
        //               ),
        //             );
        //           }
        //
        //           // // Collect selected categories
        //           // final selectedCategories = _categoriesMap.entries
        //           //     .where((entry) => entry.value == true)
        //           //     .map((entry) => entry.key)
        //           //     .toList();
        //           //
        //           // if (selectedCategories.length >= 3 &&
        //           //     selectedCategories.length <= 8) {
        //           //   // context
        //           //   //     .read<CustomPageCubit>()
        //           //   //     .updateFavouriteCat(FavouriteCatParams(
        //           //   //   animals: _categoriesMap["Animals"] ?? false,
        //           //   //   cars: _categoriesMap["Cars"] ?? false,
        //           //   //   collectiblesGifts:
        //           //   //       _categoriesMap["Collectibles Gifts"] ?? false,
        //           //   //   computersCameras:
        //           //   //       _categoriesMap["Computers Cameras"] ?? false,
        //           //   //   craft: _categoriesMap["Craft"] ?? false,
        //           //   //   dating: _categoriesMap["Dating"] ?? false,
        //           //   //   discountsOffers:
        //           //   //       _categoriesMap["Discounts Offers"] ?? false,
        //           //   //   doctorJob: _categoriesMap["Doctor Job"] ?? false,
        //           //   //   electricalDevices:
        //           //   //       _categoriesMap["Electrical Devices"] ?? false,
        //           //   //   equipment: _categoriesMap["Equipment"] ?? false,
        //           //   //   farming: _categoriesMap["Farming"] ?? false,
        //           //   //   fashionBeauty:
        //           //   //       _categoriesMap["Fashion Beauty"] ?? false,
        //           //   //   governmentServices:
        //           //   //       _categoriesMap["Government Services"] ?? false,
        //           //   //   homeEssentials:
        //           //   //       _categoriesMap["Home Essentials"] ?? false,
        //           //   //   homeService: _categoriesMap["Home Service"] ?? false,
        //           //   //   marketingSales:
        //           //   //       _categoriesMap["Marketing Sales"] ?? false,
        //           //   //   medicalService:
        //           //   //       _categoriesMap["Medical Service"] ?? false,
        //           //   //   mobilesTablets:
        //           //   //       _categoriesMap["Mobiles Tablets"] ?? false,
        //           //   //   packaging: _categoriesMap["Packaging"] ?? false,
        //           //   //   ports: _categoriesMap["Ports"] ?? false,
        //           //   //   projects: _categoriesMap["Projects"] ?? false,
        //           //   //   rawMaterials:
        //           //   //       _categoriesMap["Raw Materials"] ?? false,
        //           //   //   realEstate: _categoriesMap["Real Estate"] ?? false,
        //           //   //   remnants: _categoriesMap["Remnants"] ?? false,
        //           //   //   smoking: _categoriesMap["Smoking"] ?? false,
        //           //   //   social: _categoriesMap["Social"] ?? false,
        //           //   //   spareParts: _categoriesMap["Spare Parts"] ?? false,
        //           //   //   technology: _categoriesMap["Technology"] ?? false,
        //           //   //   vehicles: _categoriesMap["Vehicles"] ?? false,
        //           //   //   wholesaleTrade:
        //           //   //       _categoriesMap["Wholesale Trade"] ?? false,
        //           //   //   // Adding the missing fields
        //           //   //   accessories: _categoriesMap["Accessories"] ?? false,
        //           //   //   accountantJob:
        //           //   //       _categoriesMap["Accountant Job"] ?? false,
        //           //   //   charitys: _categoriesMap["Charitys"] ?? false,
        //           //   //   education: _categoriesMap["Education"] ?? false,
        //           //   //   engineerJob: _categoriesMap["Engineer Job"] ?? false,
        //           //   //   events: _categoriesMap["Events"] ?? false,
        //           //   //   fitness: _categoriesMap["Fitness"] ?? false,
        //           //   //   handmades: _categoriesMap["Handmades"] ?? false,
        //           //   //   healthyTools:
        //           //   //       _categoriesMap["Healthy Tools"] ?? false,
        //           //   //   jewelryWatches:
        //           //   //       _categoriesMap["Jewelry Watches"] ?? false,
        //           //   //   libraries: _categoriesMap["Libraries"] ?? false,
        //           //   //   musicalInstruments:
        //           //   //       _categoriesMap["Musical Instruments"] ?? false,
        //           //   //   scenery: _categoriesMap["Scenery"] ?? false,
        //           //   //   talent: _categoriesMap["Talent"] ?? false,
        //           //   //   travelTourism:
        //           //   //       _categoriesMap["Travel Tourism"] ?? false,
        //           //   //   otherJob: _categoriesMap["Other Job"] ?? false,
        //           //   // ));
        //           // } else {
        //           //   // Show a message if the selection is not valid
        //           //   ScaffoldMessenger.of(context).showSnackBar(
        //           //     SnackBar(
        //           //       content: Text(LocaleKeys.atLeast3atMost8items.localize),
        //           //     ),
        //           //   );
        //           // }
        //         },
        //         text: LocaleKeys.next.localize,
        //       );
        //     },
        //   ),
        // ),
      ),
    );
  }
}
