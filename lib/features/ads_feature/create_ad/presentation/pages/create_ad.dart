import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/selection_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/labels/badged_label.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../domain/entities/categorization_entity.dart';
import '../widgets/ad_dynamic_inputs.dart';

class CreateAdView extends StatefulWidget {
  final CategorizationEntity categorization;
  const CreateAdView({super.key, required this.categorization});

  @override
  State<CreateAdView> createState() => _CreateAdViewState();
}

class _CreateAdViewState extends State<CreateAdView> {
  @override
  void initState() {
    context
        .read<CreateAdCubit>()
        .loadData(subCategoryId: widget.categorization.fromMarriage==false?widget.categorization.mainCategory.id:widget.categorization.subCategory.id, fromMarriage: widget.categorization.fromMarriage??false);
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
        appBar: BackAppBar(label: LocaleKeys.createAd.localize),
        body: BlocBuilder<CreateAdCubit, CreateAdState>(
          // buildWhen: (previous, current) => previous.status == current.status,
          builder: (context, state) {
            if (state.status == CreateAdStates.loading){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }else {
              return Stack(
                children: [
                  Padding(
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
                                url: widget.categorization.subCategory.image,
                              ),
                              const Sizer(),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Label(
                                    text: context.isArabic
                                        ? widget.categorization.subCategory.nameAr
                                        : widget.categorization.subCategory.nameEn,
                                    style: Styles.mediumText(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Label(
                                      text: context.isArabic
                                          ? widget.categorization.mainCategory
                                                  .name ??
                                              ""
                                          : widget
                                              .categorization.mainCategory.nameEn!),
                                ],
                              )),
                            ],
                          ),
                          const Divider(),
                          _buildImagePicker(),
                          const Sizer(),
                          if(widget.categorization.fromMarriage==false)Row(
                            children: [
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (widget.categorization.mainCategory.nameEn ==
                                        'Dating') {
                                      state.isMale = true;
                                    } else if (widget.categorization.subCategory
                                            .hasAuction ==
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
                                              state.isSale == true &&
                                              state.isMale == true)
                                          ? AppColors.PRIMARY_COLOR
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: AppColors.PRIMARY_COLOR)),
                                  alignment: AlignmentDirectional.center,
                                  child: Text(
                                    widget.categorization.mainCategory.nameEn ==
                                            'Dating'
                                        ? LocaleKeys.maleUser.localize
                                        : widget.categorization.subCategory
                                                    .hasAuction ==
                                                true
                                            ? LocaleKeys.sale.localize
                                            : LocaleKeys.user.localize,
                                    style: Styles.mediumText(
                                        color: (state.isUser == false ||
                                                state.isSale == false ||
                                                state.isMale == false)
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
                                      if (widget
                                              .categorization.mainCategory.nameEn ==
                                          'Dating') {
                                        state.isMale = false;
                                      } else if (widget.categorization.subCategory
                                              .hasAuction ==
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
                                                state.isSale == false ||
                                                state.isMale == false)
                                            ? AppColors.PRIMARY_COLOR
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: AppColors.PRIMARY_COLOR)),
                                    alignment: AlignmentDirectional.center,
                                    child: Text(
                                      widget.categorization.mainCategory.nameEn ==
                                              'Dating'
                                          ? LocaleKeys.femaleUser.localize
                                          : widget.categorization.subCategory
                                                      .hasAuction ==
                                                  true
                                              ? LocaleKeys.rent.localize
                                              : LocaleKeys.provider.localize,
                                      style: Styles.mediumText(
                                          color: (state.isUser == true &&
                                                  state.isSale == true &&
                                                  state.isMale == true)
                                              ? AppColors.PRIMARY_COLOR
                                              : Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Sizer(),
                          Label(text: widget.categorization.fromMarriage==false?LocaleKeys.adTitle.localize:LocaleKeys.name.localize),
                          TextFormField(
                            maxLines: null,
                            onChanged: (v) => controller.title = v,
                            style: Styles.headerText(fontSize: 26),
                            decoration: InputDecoration(
                                fillColor: context.isDarkMode
                                    ? AppColors.GREY_DARK_COLOR
                                    : AppColors.LIGHT_COLOR,
                                contentPadding: const EdgeInsets.all(5),
                                hintText: widget.categorization.fromMarriage==false?LocaleKeys.title.localize:LocaleKeys.name.localize,
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
                            maxLines: 1,
                            keyboardType: TextInputType.number,
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
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: context.isDarkMode
                                          ? AppColors.LIGHT_COLOR
                                          : Colors.black),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: context.isDarkMode
                                          ? AppColors.LIGHT_COLOR
                                          : Colors.black),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: context.isDarkMode
                                          ? AppColors.LIGHT_COLOR
                                          : Colors.black),
                                ),
                                fillColor: context.isDarkMode
                                    ? Colors.transparent
                                    : AppColors.LIGHT_COLOR,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                              ),
                              hint: Text(
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
                                  child: Text(government
                                      .nameEn), // Change to city.nameAr for Arabic
                                );
                              }).toList(),
                            ),
                          ),
                          const Sizer(),
                          state.status == CreateAdStates.loadCities
                              ? const Center(child: CircularProgressIndicator())
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
                                                        : Colors.black),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: context.isDarkMode
                                                        ? AppColors.LIGHT_COLOR
                                                        : Colors.black),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: context.isDarkMode
                                                        ? AppColors.LIGHT_COLOR
                                                        : Colors.black),
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
                          if(widget.categorization.fromMarriage==false)...[Label(
                              text: state.isPrice == true
                                  ? LocaleKeys.price.localize
                                  : LocaleKeys.salary.localize),
                          TextFormField(
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            onChanged: (v) => controller.price = v,
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
                          )],
                          const Sizer(),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final property = state.adProperties![index];
                              return AdDynamicInputWidget(
                                property: property,
                                onChanged: (SelectionEntity v) =>
                                    controller.onChanged(v: v, index: index),
                                onTextChanged: (String v) =>
                                    controller.onTextChanged(v: v, index: index),
                                selectedProp: '',
                              );
                            },
                            separatorBuilder: (context, index) => const Sizer(),
                            shrinkWrap: true,
                            itemCount: state.adProperties?.length ?? 0,
                          ),
                          const Sizer(),
                          DefaultButton(
                              label: LocaleKeys.publish.localize,
                              onPressed: () {
                                controller.createAd(
                                    categorize: widget.categorization,
                                    context: context);
                              }),
                        ],
                      ),
                    ),
                  ),
                  // if(controller.loadImage) Container(
                  //     height: double.infinity,
                  //     width: double.infinity,
                  //     color: Colors.black.withOpacity(0.5),
                  //     child: const Center(child: CircularProgressIndicator.adaptive())),
                ],
              );
            }
          },
        ),
      );
    });
  }

  Widget _buildImagePicker() {
    return BlocBuilder<CreateAdCubit, CreateAdState>(builder: (context, state) {
      final controller = context.read<CreateAdCubit>();
      return Column(
        children: [
          InkWell(
            onTap: () => controller.uploadImage(
                subCategoryId: widget.categorization.subCategory.id,context:context),
            child: Container(
              height: kToolbarHeight * 3,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // if (state.isImageUploading)
                    //   const CircularProgressIndicator.adaptive(),
                    // if (!state.isImageUploading)
                      Image.asset(
                        Assets.image,
                        height: kToolbarHeight * .8,
                      ),
                    // if (controller.loadImage==true)
                      BadgedLabel(
                        label: LocaleKeys.addImages.localize,
                        isBordered: true,
                        style: Styles.mediumText(color: AppColors.LIGHT_COLOR),
                        color: AppColors.SECONDARY_COLOR,
                        isCentered: true,
                        close: false,
                        onTap: () => controller.uploadImage(
                            subCategoryId: widget.categorization.subCategory.id,context:context),

                      ),
                    Label(
                      text: LocaleKeys.addImagesDesc.localize,
                      style: Styles.mediumText(
                        color: context.isDarkMode
                            ? AppColors.LIGHT_COLOR
                            : AppColors.GREY_DARK_COLOR,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ),
          const Sizer(),
          if (state.images?.isNotEmpty ?? false)
            SizedBox(
              height: kToolbarHeight * 1,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final image = state.images![index];
                    final file = state.files![index];
                    return SizedBox(
                      height: kToolbarHeight * 2,
                      width: kToolbarHeight * 2,
                      child: Stack(
                        alignment: AlignmentDirectional.topStart,
                        children: [
                          Positioned.fill(
                              child: Image.file(
                            fit: BoxFit.cover,
                            File(file.path),
                          )),
                          PositionedDirectional(
                            start: 5.w,
                            top: 0,
                            child: IconAppButton(
                              width: 35.w,
                              height: 35.h,
                              icon: Icons.close_sharp,
                              color: Colors.red,
                              backColor: Colors.white,
                              size: 25.w,
                              isCircle: true,
                              onPressed: () => showAreYouSure(
                                  context: context,
                                  title: 'Alert',
                                  subTitle:
                                      'Are you sure you want to remove this image?',
                                  action: () {
                                    controller.removeImage(image: image);
                                  }),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Sizer(),
                  itemCount: state.images?.length ?? 0),
            )
        ],
      );
    });
  }
}
