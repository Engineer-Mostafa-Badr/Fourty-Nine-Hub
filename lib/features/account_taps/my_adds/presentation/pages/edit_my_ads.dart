import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
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
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../ads_feature/create_ad/presentation/widgets/ad_dynamic_inputs.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../domain/entity/my_ads_auction.dart';

class EditMyAds extends StatefulWidget {
  final MyAuctionAdsEntity categorization;

  const EditMyAds({super.key, required this.categorization});

  @override
  State<EditMyAds> createState() => _EditMyAdsState();
}

class _EditMyAdsState extends State<EditMyAds> {
  @override
  void initState() {
    context
        .read<CreateAdCubit>()
        .loadData(subCategoryId: widget.categorization.mainCategory.id);
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
      return Scaffold(
        appBar: BackAppBar(label: LocaleKeys.editMyAds.localize),
        body: BlocBuilder<CreateAdCubit, CreateAdState>(
          builder: (context, state) {
            if (state.status == CreateAdStates.success ||
                state.status == CreateAdStates.loadCitiesSuccess ||
                state.status == CreateAdStates.loadCities ||
                state.status == CreateAdStates.imageUploading ||
                state.status == CreateAdStates.initState) {
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
                            url: widget.categorization.subCategory.picture,
                          ),
                          const Sizer(),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Label(
                                text: widget.categorization.subCategory.nameEn,
                                style: Styles.mediumText(
                                    fontWeight: FontWeight.bold),
                              ),
                              Label(
                                  text:
                                      widget.categorization.mainCategory.nameEn),
                            ],
                          )),
                        ],
                      ),
                      const Divider(),
                      _buildImagePicker(),
                      const Sizer(),
                      Row(
                        children: [
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.categorization.subCategory
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
                                          state.isSale == true)
                                      ? AppColors.PRIMARY_COLOR
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: AppColors.PRIMARY_COLOR)),
                              alignment: AlignmentDirectional.center,
                              child: Text(
                                widget.categorization.subCategory.hasAuction ==
                                        true
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
                                  if (widget.categorization.subCategory
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
                                            state.isSale == false)
                                        ? AppColors.PRIMARY_COLOR
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: AppColors.PRIMARY_COLOR)),
                                alignment: AlignmentDirectional.center,
                                child: Text(
                                  widget.categorization.subCategory
                                              .hasAuction ==
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
                        onChanged: (v) => controller.title = v,
                        style: Styles.headerText(fontSize: 26),
                        decoration: InputDecoration(
                            fillColor: Colors.white,
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
                        maxLines: null,
                        onChanged: (v) => controller.description = v,
                        style: Styles.headerText(fontSize: 26),
                        decoration: InputDecoration(
                            fillColor: Colors.white,
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
                        maxLines: null,
                        onChanged: (v) => controller.phone = v,
                        style: Styles.headerText(fontSize: 26),
                        decoration: InputDecoration(
                            fillColor: Colors.white,
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
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.grey, // Border color
                                width: 1.0, // Border width
                              ),
                            ),
                          ),
                          hint: Text(LocaleKeys.selectGovernorate.tr()),
                          value: null,
                          onChanged: (GovernorateEntity? newValue) {
                            controller.selectGovernorate(newValue?.id ?? '');
                            print("state.governorate${state.governorate}");
                            print("state.city${state.city}");
                            controller.getCities(newValue?.id ?? '');
                          },
                          dropdownColor: Colors.white,
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
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 12),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color:
                                                  Colors.grey, // Border color
                                              width: 1.0, // Border width
                                            ),
                                          ),
                                        ),
                                        hint: Text(LocaleKeys.selectCity.tr()),
                                        value: null,
                                        onChanged: (CityEntity? newValue) {
                                          print(newValue?.id);
                                          controller
                                              .selectCity(newValue?.id ?? '');
                                          print(
                                              "state.governorate${state.governorate}");
                                          print("state.city${state.city}");
                                        },
                                        dropdownColor: Colors.white,
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
                        onChanged: (v) => controller.price = v,
                        style: Styles.headerText(fontSize: 26),
                        decoration: InputDecoration(
                            fillColor: Colors.white,
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
                          return AdDynamicInputWidget(
                            property: property,
                            onChanged: (SelectionEntity v) =>
                                controller.onChanged(v: v, index: index),
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
                          label: LocaleKeys.publish.localize,
                          onPressed: () {
                            // controller.createAd(
                            //     categorize: widget.categorization,
                            //     context: context);
                          }
                          ),
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
      );
    });
  }

  Widget _buildImagePicker() {
    return BlocProvider<CreateAdCubit>(
      create: (BuildContext context) => serviceLocator(),
      child: BlocBuilder<CreateAdCubit, CreateAdState>(builder: (context, state) {
        final controller = context.read<CreateAdCubit>();
        return Column(
          children: [
            //   if (widget.item.images.isEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.r)),
              child: Center(
                child: Row(
                  children: [
                    SizedBox(
                      height: 80.h,
                      width: 100.w,
                      child: BadgedLabel(
                        label: '+',
                        isBordered: true,
                        style: Styles.headerText(color: Colors.white),
                        color: AppColors.SECONDARY_COLOR,
                        isCentered: true,
                        close: false,
                      ),
                    ),
                    const Sizer(),
                    Expanded(
                      child: SingleChildScrollView(
                        // scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            if (state.images != null &&
                                state.images!.isNotEmpty)
                              SizedBox(
                                height: kToolbarHeight * 1,
                                child: Row(
                                  children: List.generate(
                                      state.images?.length ??0,
                                          (index)=>SizedBox(
                                            height: 100.h,
                                            width: 100.w,
                                    child: Stack(
                                      alignment:
                                      AlignmentDirectional.topStart,
                                      children: [
                                        // Positioned.fill(
                                        //   child: Image.network(widget.item.images[index].photo),
                                        // //     child: Image.file(
                                        // //   fit: BoxFit.cover,
                                        // //   File(image.file.path),
                                        // // ),
                                        // ),
                                        // if (state.images != null &&
                                        //     state.images!.isNotEmpty)
                                        Container(
                                          height: 200,
                                          width: 200,
                                          margin:
                                          const EdgeInsetsDirectional
                                              .only(
                                              end: 10, bottom: 10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(15),
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: FileImage(
                                                File(state.images![index]
                                                    .file.path),
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
                                                  controller.removeImage(
                                                    image: state.images![index]);
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                ),
                              ),
                            const Sizer(),
                            if (widget.categorization.images != null &&
                                widget.categorization.images.isNotEmpty)
                              SizedBox(
                                height: 80.h,
                                child: Row(
                                  children: List.generate(
                                      widget.categorization.images.length,
                                      (index) => SizedBox(
                                            height: 100.h,
                                            width: 100.w,
                                            child: Stack(
                                              alignment:
                                                  AlignmentDirectional.topStart,
                                              children: [
                                                // Positioned.fill(
                                                //   child: Image.network(widget.item.images[index].photo),
                                                // //     child: Image.file(
                                                // //   fit: BoxFit.cover,
                                                // //   File(image.file.path),
                                                // // ),
                                                // ),
                                                // if (state.images != null &&
                                                //     state.images!.isNotEmpty)
                                                ImageFromInternet(
                                                  height: 100.h,
                                                  width: 100.w,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.r),
                                                  fit: BoxFit.fill,
                                                  image: widget
                                                      .categorization.images[index].photo,
                                                ),
                                                // Container(
                                                //   height: 100.h,
                                                //   width: 100.w,
                                                //   padding: const EdgeInsets.all(10),
                                                //   decoration: BoxDecoration(
                                                //     borderRadius:
                                                //         BorderRadius.circular(20.r),
                                                //     image: DecorationImage(
                                                //       fit: BoxFit.fill,
                                                //       image: NetworkImage(
                                                //         widget.item.images[index].photo,
                                                //       ),
                                                //     ),
                                                //   ),
                                                // ),
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
                                                    onPressed: () =>
                                                        showAreYouSure(
                                                            context: context,
                                                            title: 'Alert',
                                                            subTitle:
                                                                'Are you sure you want to remove this image?',
                                                            action: () {
                                                              controller.removeImage(
                                                                image:   state.images![
                                                                      index]);
                                                            }),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
// import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
// import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
// import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
// import 'package:fourtyninehub/core/extensions/string_extension.dart';
// import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
//
// import '../../../../../common/widgets/dynamic/sizer.dart';
// import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
// import '../../../../../common/widgets/stateless/labels/badged_label.dart';
// import '../../../../../common/widgets/stateless/labels/label.dart';
// import '../../../../../res/assets/assets.dart';
// import '../../../../../res/style/app_colors.dart';
// import '../../../../../res/style/styles.dart';
// import '../../../../../service_locator/service_locator.dart';
// import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
// import '../../domain/entity/my_ads_auction.dart';
// import '../../domain/entity/my_auction_main_category.dart';
// import '../../domain/entity/my_auction_sub_category_entity.dart';
// import '../cubit/my_adds_cubit.dart';
//
// class EditMyAds extends StatefulWidget {
// //  final CategorizationEntity categorization;
//   final MyAuctionSubCategoryEntity sub;
//   final MyAuctionMainCategory main;
//   final MyAuctionAdsEntity item;
//
//   const EditMyAds({
//     super.key,
//     required this.sub,
//     required this.main,
//     required this.item,
//   });
//
//   @override
//   State<EditMyAds> createState() => _EditMyAdsState();
// }
//
// class _EditMyAdsState extends State<EditMyAds> {
//   var formKey = GlobalKey<FormState>();
//   late TextEditingController _titleController;
//   late TextEditingController _descController;
//   late TextEditingController _phoneController;
//   late TextEditingController _priceController;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize the controllers with the existing data from widget.item
//     _titleController = TextEditingController(text: widget.item.title);
//     _descController = TextEditingController(text: widget.item.desc);
//     _phoneController = TextEditingController(text: widget.item.phone);
//     _priceController =
//         TextEditingController(text: widget.item.price.toString());
//   }
//
//   @override
//   void dispose() {
//     // Dispose of the controllers to avoid memory leaks
//     _titleController.dispose();
//     _descController.dispose();
//     _phoneController.dispose();
//     _priceController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<MyAddsCubit>(
//       create: (BuildContext context) => serviceLocator(),
//       child: BlocConsumer<MyAddsCubit, MyAddsState>(
//         listener: (context, state) {},
//         builder: (context, state) {
//           return Scaffold(
//             appBar: BackAppBar(label: LocaleKeys.createAd.localize),
//             body: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Form(
//                 key: formKey,
//                 child: ListView(
//                   children: [
//                     Row(
//                       children: [
//                         SquareImage(
//                           width: kToolbarHeight * .8,
//                           height: kToolbarHeight * .8,
//                           radius: 10,
//                           url: widget.sub.picture,
//                         ),
//                         const Sizer(),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Label(
//                                 text: widget.sub.nameEn,
//                                 style: Styles.mediumText(
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               Label(text: widget.main.nameEn),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Divider(),
//                     _buildImagePicker(),
//                     const Sizer(),
//                     Label(text: LocaleKeys.adTitle.localize),
//                     TextFormField(
//                       controller: _titleController,
//                       // Add controller here
//                       maxLines: null,
//                       style: Styles.headerText(fontSize: 26),
//                       decoration: InputDecoration(
//                         fillColor: Colors.white,
//                         contentPadding: const EdgeInsets.all(5),
//                         hintText: LocaleKeys.title.localize,
//                         hintStyle: Styles.mediumText(),
//                         prefix: Sizer(width: 20.w),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return LocaleKeys.required.localize;
//                         }
//                         return null;
//                       },
//                     ),
//                     const Sizer(),
//                     Label(text: LocaleKeys.desc.localize),
//                     TextFormField(
//                       controller: _descController,
//                       // Add controller here
//                       maxLines: null,
//                       style: Styles.headerText(fontSize: 26),
//                       decoration: InputDecoration(
//                         fillColor: Colors.white,
//                         contentPadding: const EdgeInsets.all(5),
//                         hintText: LocaleKeys.desc.localize,
//                         hintStyle: Styles.mediumText(),
//                         prefix: Sizer(width: 20.w),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return LocaleKeys.required.localize;
//                         }
//                         return null;
//                       },
//                     ),
//                     const Sizer(),
//                     Label(text: LocaleKeys.phone.localize),
//                     TextFormField(
//                       controller: _phoneController,
//                       // Add controller here
//                       maxLines: null,
//                       style: Styles.headerText(fontSize: 26),
//                       decoration: InputDecoration(
//                         fillColor: Colors.white,
//                         contentPadding: const EdgeInsets.all(5),
//                         hintText: LocaleKeys.phone.localize,
//                         hintStyle: Styles.mediumText(),
//                         prefix: Sizer(width: 20.w),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return LocaleKeys.required.localize;
//                         }
//                         return null;
//                       },
//                     ),
//                     const Sizer(),
//                     Label(text: LocaleKeys.price.localize),
//                     TextFormField(
//                       controller: _priceController,
//                       // Add controller here
//                       maxLines: null,
//                       style: Styles.headerText(fontSize: 26),
//                       decoration: InputDecoration(
//                         fillColor: Colors.white,
//                         contentPadding: const EdgeInsets.all(5),
//                         hintText: LocaleKeys.price.localize,
//                         prefix: Sizer(width: 20.w),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return LocaleKeys.required.localize;
//                         }
//                         return null;
//                       },
//                     ),
//                     const Sizer(),
//                     DefaultButton(
//                       label: "Edit",
//                       onPressed: () {
//                         // Ensure that the current values from the TextEditingControllers are passed
//                         final updatedTitle = _titleController.text.trim();
//                         final updatedDesc = _descController.text.trim();
//                         final updatedPhone = _phoneController.text.trim();
//                         final updatedPrice = _priceController.text.trim();
//
//                         print(context.read<MyAddsCubit>().selectedImages);
//                         print(state.images?[0].mediaId);
//                         // Perform validation if necessary (can also be managed in the Form's validator)
//                         // if (formKey.currentState!.validate()) {
//                         //   context.read<MyAddsCubit>().editMyAds(
//                         //     params: EditParams(
//                         //         id: widget.item.id, // Required
//                         //         description: updatedDesc.isNotEmpty ? updatedDesc : widget.item.desc,
//                         //         phone: updatedPhone.isNotEmpty ? updatedPhone : widget.item.phone,
//                         //         title: updatedTitle.isNotEmpty ? updatedTitle : widget.item.title,
//                         //         subCategoryId: widget.sub.id,
//                         //         mainCategoryId: widget.main.id,
//                         //         price: double.tryParse(updatedPrice) ?? widget.item.price, // Convert the price
//                         //         images: [], // Handle image updates here if needed
//                         //         details: [] // Update any other details if needed
//                         //     ),
//                         //   );
//                         // }
//                       },
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildImagePicker() {
//     return BlocProvider<MyAddsCubit>(
//       create: (BuildContext context) => serviceLocator(),
//       child: BlocBuilder<MyAddsCubit, MyAddsState>(builder: (context, state) {
//         final controller = context.read<MyAddsCubit>();
//         return Column(
//           children: [
//             //   if (widget.item.images.isEmpty)
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//               decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(10.r)),
//               child: Center(
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       height: 80.h,
//                       width: 100.w,
//                       child: BadgedLabel(
//                         label: '+',
//                         isBordered: true,
//                         style: Styles.headerText(color: Colors.white),
//                         color: AppColors.SECONDARY_COLOR,
//                         isCentered: true,
//                         close: false,
//                       ),
//                     ),
//                     const Sizer(),
//                     Expanded(
//                       child: SingleChildScrollView(
//                         // scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: [
//                             if (state.images != null &&
//                                 state.images!.isNotEmpty)
//                               SizedBox(
//                                 height: kToolbarHeight * 1,
//                                 child: Row(
//                                   children: List.generate(
//                                       state.images?.length ??0,
//                                           (index)=>SizedBox(
//                                             height: 100.h,
//                                             width: 100.w,
//                                     child: Stack(
//                                       alignment:
//                                       AlignmentDirectional.topStart,
//                                       children: [
//                                         // Positioned.fill(
//                                         //   child: Image.network(widget.item.images[index].photo),
//                                         // //     child: Image.file(
//                                         // //   fit: BoxFit.cover,
//                                         // //   File(image.file.path),
//                                         // // ),
//                                         // ),
//                                         // if (state.images != null &&
//                                         //     state.images!.isNotEmpty)
//                                         Container(
//                                           height: 200,
//                                           width: 200,
//                                           margin:
//                                           const EdgeInsetsDirectional
//                                               .only(
//                                               end: 10, bottom: 10),
//                                           padding: const EdgeInsets.all(10),
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                             BorderRadius.circular(15),
//                                             image: DecorationImage(
//                                               fit: BoxFit.fill,
//                                               image: FileImage(
//                                                 File(state.images![index]
//                                                     .file.path),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         PositionedDirectional(
//                                           start: 5.w,
//                                           top: 0,
//                                           child: IconAppButton(
//                                             width: 35.w,
//                                             height: 35.h,
//                                             icon: Icons.close_sharp,
//                                             color: Colors.red,
//                                             backColor: Colors.white,
//                                             size: 25.w,
//                                             isCircle: true,
//                                             onPressed: () => showAreYouSure(
//                                                 context: context,
//                                                 title: 'Alert',
//                                                 subTitle:
//                                                 'Are you sure you want to remove this image?',
//                                                 action: () {
//                                                   controller.removePhoto(
//                                                       state.images![index]);
//                                                 }),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   )),
//                                 ),
//                               ),
//                             const Sizer(),
//                             if (widget.item.images != null &&
//                                 widget.item.images.isNotEmpty)
//                               SizedBox(
//                                 height: 80.h,
//                                 child: Row(
//                                   children: List.generate(
//                                       widget.item.images.length,
//                                       (index) => SizedBox(
//                                             height: 100.h,
//                                             width: 100.w,
//                                             child: Stack(
//                                               alignment:
//                                                   AlignmentDirectional.topStart,
//                                               children: [
//                                                 // Positioned.fill(
//                                                 //   child: Image.network(widget.item.images[index].photo),
//                                                 // //     child: Image.file(
//                                                 // //   fit: BoxFit.cover,
//                                                 // //   File(image.file.path),
//                                                 // // ),
//                                                 // ),
//                                                 // if (state.images != null &&
//                                                 //     state.images!.isNotEmpty)
//                                                 ImageFromInternet(
//                                                   height: 100.h,
//                                                   width: 100.w,
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           20.r),
//                                                   fit: BoxFit.fill,
//                                                   image: widget
//                                                       .item.images[index].photo,
//                                                 ),
//                                                 // Container(
//                                                 //   height: 100.h,
//                                                 //   width: 100.w,
//                                                 //   padding: const EdgeInsets.all(10),
//                                                 //   decoration: BoxDecoration(
//                                                 //     borderRadius:
//                                                 //         BorderRadius.circular(20.r),
//                                                 //     image: DecorationImage(
//                                                 //       fit: BoxFit.fill,
//                                                 //       image: NetworkImage(
//                                                 //         widget.item.images[index].photo,
//                                                 //       ),
//                                                 //     ),
//                                                 //   ),
//                                                 // ),
//                                                 PositionedDirectional(
//                                                   start: 5.w,
//                                                   top: 0,
//                                                   child: IconAppButton(
//                                                     width: 35.w,
//                                                     height: 35.h,
//                                                     icon: Icons.close_sharp,
//                                                     color: Colors.red,
//                                                     backColor: Colors.white,
//                                                     size: 25.w,
//                                                     isCircle: true,
//                                                     onPressed: () =>
//                                                         showAreYouSure(
//                                                             context: context,
//                                                             title: 'Alert',
//                                                             subTitle:
//                                                                 'Are you sure you want to remove this image?',
//                                                             action: () {
//                                                               controller.removePhoto(
//                                                                   state.images![
//                                                                       index]);
//                                                             }),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           )),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }
