import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/my_ads_auction.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/edit_my_ads_use_case.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/presentation/widgets/ad_dynamic_input_edit.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/create_ad_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/selection_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/labels/badged_label.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';

class EditMyAds extends StatefulWidget {
  final MyAuctionAdsEntity categorization;

  const EditMyAds({super.key, required this.categorization});

  @override
  State<EditMyAds> createState() => _EditMyAdsState();
}

class _EditMyAdsState extends State<EditMyAds> {
  SelectionEntity? selectedExperienceLevel;
  SelectionEntity? selectedEducationLevel;

  @override
  void initState() {
    super.initState();
  }

  List<CreateAdEntity> details = [];
  var selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(label: LocaleKeys.editMyAds.localize),
      body: BlocProvider<CreateAdCubit>(
        create: (BuildContext context) => serviceLocator()
          ..loadDataInEdit(
              subCategoryId: widget.categorization.mainCategory?.id ?? '',
              id: widget.categorization.id),
        child: BlocConsumer<CreateAdCubit, CreateAdState>(
          listener: (BuildContext context, CreateAdState state) {
            if (state.status == CreateAdStates.updateSuccess) {
              showSuccessMessage(
                  context, LocaleKeys.updateSuccessfully.localize);
            }
          },
          builder: (context, state) {
            final controller = context.read<CreateAdCubit>();
            if (state.status == CreateAdStates.success ||
                state.status == CreateAdStates.loadCitiesSuccess ||
                state.status == CreateAdStates.loadCities ||
                state.status == CreateAdStates.imageUploading ||
                state.status == CreateAdStates.initState) {
              controller.titleController.text = state.myAdById?.title ?? '';
              controller.descController.text = state.myAdById?.desc ?? '';
              controller.phoneController.text = state.myAdById?.phone ?? '';
              controller.priceController.text = '${state.myAdById?.price ?? 0}';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: controller.formState,
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          SquareImage(
                            width: kToolbarHeight * .8,
                            height: kToolbarHeight * .8,
                            radius: 10,
                            url: state.myAdById!.subCategoryId.picture,
                          ),
                          const Sizer(),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Label(
                                text: context.locale == Locales.english
                                    ? state.myAdById!.subCategoryId.nameEn
                                    : state.myAdById!.subCategoryId.nameAr,
                                style: Styles.mediumText(
                                    fontWeight: FontWeight.bold),
                              ),
                              Label(
                                text: context.locale == Locales.english
                                    ? state.myAdById!.mainCategoryId.nameEn
                                    : state.myAdById!.mainCategoryId.nameAr,
                              ),
                            ],
                          )),
                        ],
                      ),
                      const Divider(),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 16.h),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 80.h,
                                    width: 100.w,
                                    child: BadgedLabel(
                                      label: '+',
                                      onTap: () {
                                        controller.uploadImage(
                                          subCategoryId: widget
                                              .categorization.subCategory.id,
                                        );
                                      },
                                      isBordered: true,
                                      style: Styles.headerText(
                                          color: Colors.white),
                                      color: AppColors.SECONDARY_COLOR,
                                      isCentered: true,
                                      close: false,
                                    ),
                                  ),
                                  const Sizer(),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Row(
                                        children: [
                                          if (state.myAdById?.images
                                                  .isNotEmpty ??
                                              false)
                                            state.images == null?  SizedBox(
                                              height: 80.h,
                                              child: Row(
                                                children: List.generate(
                                                  state.myAdById?.images
                                                          .length ??
                                                      0,
                                                  (index) => SizedBox(
                                                    height: 100.h,
                                                    width: 100.w,
                                                    child: Stack(
                                                      alignment:
                                                          AlignmentDirectional
                                                              .topStart,
                                                      children: [
                                                        ImageFromInternet(
                                                          height: 100.h,
                                                          width: 100.w,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.r),
                                                          fit: BoxFit.fill,
                                                          image: state
                                                                  .myAdById
                                                                  ?.images[
                                                                      index]
                                                                  .photo ??
                                                              '',
                                                        ),
                                                        PositionedDirectional(
                                                          start: 5.w,
                                                          top: 0,
                                                          child: IconAppButton(
                                                            width: 35.w,
                                                            height: 35.h,
                                                            icon: Icons
                                                                .close_sharp,
                                                            color: Colors.red,
                                                            backColor:
                                                                Colors.white,
                                                            size: 25.w,
                                                            isCircle: true,
                                                            onPressed: () =>
                                                                showAreYouSure(
                                                              context: context,
                                                              title: 'Alert',
                                                              subTitle:
                                                                  'Are you sure you want to remove this image?',
                                                              action: () {
                                                                controller.removeImage(
                                                                    image: state
                                                                            .images![
                                                                        index]);
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ) :const SizedBox.shrink(),
                                          const Sizer(),
                                          if (state.images != null &&
                                              state.images!.isNotEmpty)
                                            SizedBox(
                                              height: 80.h,
                                              child: Row(
                                                children: List.generate(
                                                  state.images?.length ?? 0,
                                                  (index) => SizedBox(
                                                    height: 100.h,
                                                    width: 100.w,
                                                    child: Stack(
                                                      alignment:
                                                          AlignmentDirectional
                                                              .topStart,
                                                      children: [
                                                        Container(
                                                          height: 100.h,
                                                          width: 100.w,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            image:
                                                                DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: FileImage(
                                                                File(state
                                                                    .images![
                                                                        index]
                                                                    .file
                                                                    .path),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        PositionedDirectional(
                                                          start: 5.w,
                                                          top: 0,
                                                          child: IconAppButton(
                                                            width: 35.w,
                                                            height: 35.h,
                                                            icon: Icons
                                                                .close_sharp,
                                                            color: Colors.red,
                                                            backColor:
                                                                Colors.white,
                                                            size: 25.w,
                                                            isCircle: true,
                                                            onPressed: () =>
                                                                showAreYouSure(
                                                              context: context,
                                                              title: 'Alert',
                                                              subTitle:
                                                                  'Are you sure you want to remove this image?',
                                                              action: () {
                                                                controller.removeImage(
                                                                    image: state
                                                                            .images![
                                                                        index]);
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          const Sizer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Sizer(),
                      Row(
                        children: [
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              setState(() {
                                if (state.myAdById!.subCategoryId.hasAuction ==
                                    true) {
                                  state.isSale = true;
                                } else {
                                  state.isUser = true;
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: (state.isUser == true &&
                                          state.isSale == true)
                                      ? AppColors.PRIMARY_COLOR
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: AppColors.PRIMARY_COLOR)),
                              alignment: AlignmentDirectional.center,
                              child: Text(
                                state.myAdById!.subCategoryId.hasAuction == true
                                    ? LocaleKeys.sale.localize
                                    : LocaleKeys.user.localize,
                                style: Styles.mediumText(
                                    color: (state.isUser == false ||
                                            state.isSale == false)
                                        ? AppColors.PRIMARY_COLOR
                                        : Colors.white),
                              ),
                            ),
                          )),
                          const Sizer(),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (state
                                          .myAdById!.subCategoryId.hasAuction ==
                                      true) {
                                    state.isSale = false;
                                    print(state.isSale);
                                    print(state.isSale);
                                  } else {
                                    state.isUser = false;
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: (state.isUser == false ||
                                            state.isSale == false)
                                        ? AppColors.PRIMARY_COLOR
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: AppColors.PRIMARY_COLOR)),
                                alignment: AlignmentDirectional.center,
                                child: Text(
                                  state.myAdById!.subCategoryId.hasAuction ==
                                          true
                                      ? LocaleKeys.rent.localize
                                      : LocaleKeys.provider.localize,
                                  style: Styles.mediumText(
                                      color: (state.isUser == true &&
                                              state.isSale == true)
                                          ? AppColors.PRIMARY_COLOR
                                          : Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Sizer(),
                      Label(text: LocaleKeys.adTitle.localize),
                      TextFormField(
                        maxLines: null,
                        controller: controller.titleController,
                        onChanged: (v) => controller.title = v,
                        style: Styles.headerText(fontSize: 26),
                        decoration: InputDecoration(
                            fillColor: context.isDarkMode
                                ? AppColors.GREY_DARK_COLOR
                                : AppColors.LIGHT_COLOR,
                            contentPadding: const EdgeInsets.all(5),
                            hintText: LocaleKeys.title.localize,
                            hintStyle: Styles.mediumText(),
                            prefix: Sizer(
                              width: 20.w,
                            )),
                        validator: (value) {
                          if ((value == null || value.isEmpty)) {
                            return LocaleKeys.required.localize;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const Sizer(),
                      Label(text: LocaleKeys.desc.localize),
                      TextFormField(
                        controller: controller.descController,
                        maxLines: null,
                        onChanged: (v) => controller.description = v,
                        style: Styles.headerText(fontSize: 26),
                        decoration: InputDecoration(
                            fillColor: context.isDarkMode
                                ? AppColors.GREY_DARK_COLOR
                                : AppColors.LIGHT_COLOR,
                            contentPadding: const EdgeInsets.all(5),
                            hintText: LocaleKeys.desc.localize,
                            hintStyle: Styles.mediumText(),
                            prefix: Sizer(
                              width: 20.w,
                            )),
                        validator: (value) {
                          if ((value == null || value.isEmpty)) {
                            return LocaleKeys.required.localize;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const Sizer(),
                      Label(text: LocaleKeys.phone.localize),
                      TextFormField(
                        controller: controller.phoneController,
                        maxLines: null,
                        onChanged: (v) => controller.phone = v,
                        style: Styles.headerText(fontSize: 26),
                        decoration: InputDecoration(
                            fillColor: context.isDarkMode
                                ? AppColors.GREY_DARK_COLOR
                                : AppColors.LIGHT_COLOR,
                            contentPadding: const EdgeInsets.all(5),
                            hintText: LocaleKeys.phone.localize,
                            hintStyle: Styles.mediumText(),
                            prefix: Sizer(
                              width: 20.w,
                            )),
                        validator: (value) {
                          if ((value == null || value.isEmpty)) {
                            return LocaleKeys.required.localize;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const Sizer(),
                      Label(text: LocaleKeys.governorate.localize),
                      SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField<GovernorateEntity>(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: context.isDarkMode
                                      ? AppColors.LIGHT_COLOR
                                      : Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: context.isDarkMode
                                      ? AppColors.LIGHT_COLOR
                                      : Colors.grey),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: context.isDarkMode
                                      ? AppColors.LIGHT_COLOR
                                      : Colors.grey),
                            ),
                          ),
                          hint: Text(
                            context.locale == Locales.english
                                ? state.myAdById?.governorateNameEn ??
                                    LocaleKeys.selectGovernorate.tr()
                                : state.myAdById?.governorateNameAr ??
                                    LocaleKeys.selectGovernorate.tr(),
                            style: TextStyle(
                              color: context.isDarkMode
                                  ? AppColors.LIGHT_COLOR
                                  : AppColors.GREY_DARK_COLOR,
                            ),
                          ),
                          value: null,
                          onChanged: (GovernorateEntity? newValue) {
                            controller.selectGovernorate(newValue?.id ?? '');
                            print("state.governorate${state.governorate}");
                            print("state.city${state.city}");
                            controller.getCities(newValue?.id ?? '');
                          },
                          dropdownColor: context.isDarkMode
                              ? AppColors.GREY_DARK_COLOR
                              : AppColors.LIGHT_COLOR,
                          items: state.governorates
                              ?.map<DropdownMenuItem<GovernorateEntity>>(
                                  (GovernorateEntity government) {
                            return DropdownMenuItem<GovernorateEntity>(
                              value: government,
                              child: Text(context.locale == Locales.english
                                  ? government.nameEn
                                  : government.nameAr),
                            );
                          }).toList(),
                        ),
                      ),
                      const Sizer(),
                      state.status == CreateAdStates.loadCities
                          ? Center(child: const CircularProgressIndicator())
                          : state.status == CreateAdStates.loadCitiesSuccess
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Label(text: LocaleKeys.city.localize),
                                    SizedBox(
                                      width: double.infinity,
                                      child:
                                          DropdownButtonFormField<CityEntity>(
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: context.isDarkMode
                                                    ? AppColors.LIGHT_COLOR
                                                    : Colors.grey),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: context.isDarkMode
                                                    ? AppColors.LIGHT_COLOR
                                                    : Colors.grey),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: context.isDarkMode
                                                    ? AppColors.LIGHT_COLOR
                                                    : Colors.grey),
                                          ),
                                          fillColor: context.isDarkMode
                                              ? Colors.transparent
                                              : AppColors.LIGHT_COLOR,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 12),
                                        ),
                                        hint: Text(
                                          LocaleKeys.selectCity.tr(),
                                          style: TextStyle(
                                            color: context.isDarkMode
                                                ? AppColors.LIGHT_COLOR
                                                : AppColors.GREY_DARK_COLOR,
                                          ),
                                        ),
                                        value: null,
                                        onChanged: (CityEntity? newValue) {
                                          print(newValue?.id);
                                          controller
                                              .selectCity(newValue?.id ?? '');
                                          print(
                                              "state.governorate${state.governorate}");
                                          print("state.city${state.city}");
                                        },
                                        dropdownColor: context.isDarkMode
                                            ? AppColors.GREY_DARK_COLOR
                                            : AppColors.LIGHT_COLOR,
                                        items: state.cities
                                            ?.map<DropdownMenuItem<CityEntity>>(
                                                (CityEntity city) {
                                          return DropdownMenuItem<CityEntity>(
                                            value: city,
                                            child: Text(city
                                                .nameEn), // Change to city.nameAr for Arabic
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                      const Sizer(),
                      Label(
                          text: state.isPrice == true
                              ? LocaleKeys.price.localize
                              : LocaleKeys.salary.localize),
                      TextFormField(
                        maxLines: null,
                        controller: controller.priceController,
                        onChanged: (v) => controller.price = v,
                        keyboardType: TextInputType.number,
                        style: Styles.headerText(fontSize: 26),
                        decoration: InputDecoration(
                            fillColor: context.isDarkMode
                                ? AppColors.GREY_DARK_COLOR
                                : AppColors.LIGHT_COLOR,
                            contentPadding: const EdgeInsets.all(5),
                            hintText: state.isPrice == true
                                ? LocaleKeys.price.localize
                                : LocaleKeys.salary.localize,
                            hintStyle: Styles.mediumText(),
                            prefix: Sizer(
                              width: 20.w,
                            )),
                        validator: (value) {
                          if ((value == null || value.isEmpty)) {
                            return LocaleKeys.required.localize;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const Sizer(),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final property = state.adProperties![index];
                          bool isExperienceLevel =
                              property.nameEn == "Experience Level";
                          bool isEducationLevel =
                              property.nameEn == "Education Level";
                          return AdDynamicInputEdit(
                            property: property,
                            // selectedPropName: selectedValue,
                            onChanged: (SelectionEntity v) {
                              if (isExperienceLevel) {
                                setState(() {
                                  selectedExperienceLevel = v;
                                });
                              } else if (isEducationLevel) {
                                setState(() {
                                  selectedEducationLevel = v;
                                });
                              }
                              controller.onChangedd(v: v, index: index);
                            },
                            onTextChanged: (String v) =>
                                controller.onTextChanged(v: v, index: index),
                          );
                        },
                        separatorBuilder: (context, index) => const Sizer(),
                        shrinkWrap: true,
                        itemCount: state.adProperties?.length ?? 0,
                      ),
                      const Sizer(),
                      DefaultButton(
                        label: LocaleKeys.edit.localize,
                        onPressed: () {
                          print(
                              'state.images ${state.images?.map((e) => e.mediaId).toList() ?? []}');
                          final List<Map<String, dynamic>> props = [];
                          final List<Map<String, dynamic>> props2 = [];
                          final existingProps = state.myAdById!.props;

                          for (var prop in existingProps) {
                            if (selectedExperienceLevel != null &&
                                selectedEducationLevel == null) {
                              props.add({
                                "propertyId": '66f56c06414240a8e48520b3',
                                // Experience property ID
                                "value": {
                                  "ar": selectedExperienceLevel!.nameAr,
                                  "en": selectedExperienceLevel!.nameEn,
                                },
                              });
                              // No need to add education level if only experience is selected
                              continue; // Skip the rest of the loop for this iteration
                            }

                            // Check if education level is selected
                            if (selectedEducationLevel != null &&
                                selectedExperienceLevel == null) {
                              props.add({
                                "propertyId": "66f56c06414240a8e48520b2",
                                // Education property ID
                                "value": {
                                  "ar": selectedEducationLevel!.nameAr,
                                  "en": selectedEducationLevel!.nameEn,
                                },
                              });
                              // No need to add experience level if only education is selected
                              continue; // Skip the rest of the loop for this iteration
                            }

                            // Add both experience and education if both are selected
                            if (selectedExperienceLevel != null &&
                                selectedEducationLevel != null) {
                              props.add({
                                "propertyId": '66f56c06414240a8e48520b3',
                                // Experience property ID
                                "value": {
                                  "ar": selectedExperienceLevel!.nameAr,
                                  "en": selectedExperienceLevel!.nameEn,
                                },
                              });
                              props.add({
                                "propertyId": "66f56c06414240a8e48520b2",
                                // Education property ID
                                "value": {
                                  "ar": selectedEducationLevel!.nameAr,
                                  "en": selectedEducationLevel!.nameEn,
                                },
                              });
                              break; // Exit the loop once both are added
                            }

                            // Default to existing values if neither experience nor education are selected
                            if (selectedExperienceLevel == null &&
                                selectedEducationLevel == null) {
                              props2.add({
                                "propertyId": prop.id,
                                "value": {
                                  "ar": prop.value.ar,
                                  "en": prop.value.en,
                                },
                              });
                            }
                          }

                          print('////////////////////////////');
                          selectedExperienceLevel == null &&
                                  selectedEducationLevel == null
                              ? print('Props2 ${props2}')
                              : print('Props ${props}');
                          print('////////////////////////////');

                          print(
                              'state.myAdById!.images: ${state.myAdById!.images.map((e) => e.id).toList()}');

                          controller.editMyAds(
                            categorization: widget.categorization,
                            selectedEducationLevel:selectedEducationLevel ,
                            selectedExperienceLevel: selectedExperienceLevel,
                          );
                        },
                      )
                      // DefaultButton(
                      //   label: LocaleKeys.edit.localize,
                      //   onPressed: () {
                      //     print(
                      //         'state.images ${state.images?.map((e) => e.mediaId).toList() ?? []}');
                      //     final List<Map<String, dynamic>> props = [];
                      //     final List<Map<String, dynamic>> props2 = [];
                      //     final existingProps = state.myAdById!.props;
                      //
                      //     for (var prop in existingProps) {
                      //       if (selectedExperienceLevel != null &&
                      //           selectedEducationLevel == null) {
                      //         props.add({
                      //           "propertyId": '66f56c06414240a8e48520b3',
                      //           // Experience property ID
                      //           "value": {
                      //             "ar": selectedExperienceLevel!.nameAr,
                      //             "en": selectedExperienceLevel!.nameEn,
                      //           },
                      //         });
                      //         // No need to add education level if only experience is selected
                      //         continue; // Skip the rest of the loop for this iteration
                      //       }
                      //
                      //       // Check if education level is selected
                      //       if (selectedEducationLevel != null &&
                      //           selectedExperienceLevel == null) {
                      //         props.add({
                      //           "propertyId": "66f56c06414240a8e48520b2",
                      //           // Education property ID
                      //           "value": {
                      //             "ar": selectedEducationLevel!.nameAr,
                      //             "en": selectedEducationLevel!.nameEn,
                      //           },
                      //         });
                      //         // No need to add experience level if only education is selected
                      //         continue; // Skip the rest of the loop for this iteration
                      //       }
                      //
                      //       // Add both experience and education if both are selected
                      //       if (selectedExperienceLevel != null &&
                      //           selectedEducationLevel != null) {
                      //         props.add({
                      //           "propertyId": '66f56c06414240a8e48520b3',
                      //           // Experience property ID
                      //           "value": {
                      //             "ar": selectedExperienceLevel!.nameAr,
                      //             "en": selectedExperienceLevel!.nameEn,
                      //           },
                      //         });
                      //         props.add({
                      //           "propertyId": "66f56c06414240a8e48520b2",
                      //           // Education property ID
                      //           "value": {
                      //             "ar": selectedEducationLevel!.nameAr,
                      //             "en": selectedEducationLevel!.nameEn,
                      //           },
                      //         });
                      //         break; // Exit the loop once both are added
                      //       }
                      //
                      //       // Default to existing values if neither experience nor education are selected
                      //       if (selectedExperienceLevel == null &&
                      //           selectedEducationLevel == null) {
                      //         props2.add({
                      //           "propertyId": prop.id,
                      //           "value": {
                      //             "ar": prop.value.ar,
                      //             "en": prop.value.en,
                      //           },
                      //         });
                      //       }
                      //     }
                      //
                      //     print('////////////////////////////');
                      //     selectedExperienceLevel == null &&
                      //             selectedEducationLevel == null
                      //         ? print('Props2 ${props2}')
                      //         : print('Props ${props}');
                      //     print('////////////////////////////');
                      //
                      //     print(
                      //         'state.myAdById!.images: ${state.myAdById!.images.map((e) => e.id).toList()}');
                      //
                      //     controller.editMyAds(
                      //       params: EditParams(
                      //         id: widget.categorization.id,
                      //         title: controller.titleController.text,
                      //         description: controller.descController.text,
                      //         phone: controller.phoneController.text,
                      //         price:
                      //             double.parse(controller.priceController.text),
                      //         details: selectedExperienceLevel == null &&
                      //                 selectedEducationLevel == null
                      //             ? props2
                      //             : props,
                      //         subCategoryId:
                      //             widget.categorization.subCategory.id,
                      //         mainCategoryId:
                      //             widget.categorization.mainCategory!.id,
                      //         images: state.images
                      //                 ?.map((e) => e.mediaId)
                      //                 .toList() ??
                      //             state.myAdById!.images
                      //                 .map((e) => e.id)
                      //                 .toList(),
                      //       ),
                      //     );
                      //   },
                      // )
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
