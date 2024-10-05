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
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../ads_feature/create_ad/domain/entities/categorization_entity.dart';
import '../../../../ads_feature/create_ad/presentation/widgets/ad_dynamic_inputs.dart';
import '../../domain/entity/my_ads_auction.dart';
import '../../domain/entity/my_auction_image_entity.dart';
import '../../domain/entity/my_auction_main_category.dart';
import '../../domain/entity/my_auction_sub_category_entity.dart';
import '../../domain/usecases/edit_my_ads_use_case.dart';
import '../cubit/my_adds_cubit.dart';

class EditMyAds extends StatefulWidget {
//  final CategorizationEntity categorization;
  final MyAuctionSubCategoryEntity sub;
  final MyAuctionMainCategory main;
  final MyAuctionAdsEntity item;

  const EditMyAds({
    super.key,
    required this.sub,
    required this.main,
    required this.item,
  });

  @override
  State<EditMyAds> createState() => _EditMyAdsState();
}

class _EditMyAdsState extends State<EditMyAds> {
  var formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _phoneController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the existing data from widget.item
    _titleController = TextEditingController(text: widget.item.title);
    _descController = TextEditingController(text: widget.item.desc);
    _phoneController = TextEditingController(text: widget.item.phone);
    _priceController =
        TextEditingController(text: widget.item.price.toString());
  }

  @override
  void dispose() {
    // Dispose of the controllers to avoid memory leaks
    _titleController.dispose();
    _descController.dispose();
    _phoneController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyAddsCubit>(
      create: (BuildContext context) => serviceLocator(),
      child: BlocConsumer<MyAddsCubit, MyAddsState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: BackAppBar(label: LocaleKeys.createAd.localize),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    Row(
                      children: [
                        SquareImage(
                          width: kToolbarHeight * .8,
                          height: kToolbarHeight * .8,
                          radius: 10,
                          url: widget.sub.picture,
                        ),
                        const Sizer(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Label(
                                text: widget.sub.nameEn,
                                style: Styles.mediumText(
                                    fontWeight: FontWeight.bold),
                              ),
                              Label(text: widget.main.nameEn),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(),

                    _buildImagePicker(),
                    const Sizer(),
                    Label(text: LocaleKeys.adTitle.localize),
                    TextFormField(
                      controller: _titleController,
                      // Add controller here
                      maxLines: null,
                      style: Styles.headerText(fontSize: 26),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(5),
                        hintText: LocaleKeys.title.localize,
                        hintStyle: Styles.mediumText(),
                        prefix: Sizer(width: 20.w),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.required.localize;
                        }
                        return null;
                      },
                    ),
                    const Sizer(),
                    Label(text: LocaleKeys.desc.localize),
                    TextFormField(
                      controller: _descController,
                      // Add controller here
                      maxLines: null,
                      style: Styles.headerText(fontSize: 26),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(5),
                        hintText: LocaleKeys.desc.localize,
                        hintStyle: Styles.mediumText(),
                        prefix: Sizer(width: 20.w),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.required.localize;
                        }
                        return null;
                      },
                    ),
                    const Sizer(),
                    Label(text: LocaleKeys.phone.localize),
                    TextFormField(
                      controller: _phoneController,
                      // Add controller here
                      maxLines: null,
                      style: Styles.headerText(fontSize: 26),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(5),
                        hintText: LocaleKeys.phone.localize,
                        hintStyle: Styles.mediumText(),
                        prefix: Sizer(width: 20.w),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.required.localize;
                        }
                        return null;
                      },
                    ),
                    const Sizer(),
                    Label(text: LocaleKeys.price.localize),
                    TextFormField(
                      controller: _priceController,
                      // Add controller here
                      maxLines: null,
                      style: Styles.headerText(fontSize: 26),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(5),
                        hintText: LocaleKeys.price.localize,
                        prefix: Sizer(width: 20.w),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.required.localize;
                        }
                        return null;
                      },
                    ),
                    const Sizer(),
                    DefaultButton(
                      label: "Edit",
                      onPressed: () {
                        // Ensure that the current values from the TextEditingControllers are passed
                        final updatedTitle = _titleController.text.trim();
                        final updatedDesc = _descController.text.trim();
                        final updatedPhone = _phoneController.text.trim();
                        final updatedPrice = _priceController.text.trim();


                        print(context.read<MyAddsCubit>().selectedImages);
                        // Perform validation if necessary (can also be managed in the Form's validator)
                        // if (formKey.currentState!.validate()) {
                        //   context.read<MyAddsCubit>().editMyAds(
                        //     params: EditParams(
                        //         id: widget.item.id, // Required
                        //         description: updatedDesc.isNotEmpty ? updatedDesc : widget.item.desc,
                        //         phone: updatedPhone.isNotEmpty ? updatedPhone : widget.item.phone,
                        //         title: updatedTitle.isNotEmpty ? updatedTitle : widget.item.title,
                        //         subCategoryId: widget.sub.id,
                        //         mainCategoryId: widget.main.id,
                        //         price: double.tryParse(updatedPrice) ?? widget.item.price, // Convert the price
                        //         images: [], // Handle image updates here if needed
                        //         details: [] // Update any other details if needed
                        //     ),
                        //   );
                        // }
                      },
                    )


                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImagePicker() {
    return BlocProvider<MyAddsCubit>(
      create: (BuildContext context) => serviceLocator(),
      child: BlocBuilder<MyAddsCubit, MyAddsState>(builder: (context, state) {
        final controller = context.read<MyAddsCubit>();
        return Column(
          children: [
         //   if (widget.item.images.isEmpty)
            InkWell(
              onTap: () {
                controller.uploadPhoto();
              },
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
                      // if (state.status == MyAddsStates.imageUploading)
                      //   const CircularProgressIndicator.adaptive(),
                    //  if (widget.item.images.isEmpty)
                        Image.asset(
                          Assets.image,
                          height: kToolbarHeight * .8,
                        ),
                   //   if (widget.item.images.isEmpty)
                        BadgedLabel(
                          label: LocaleKeys.addImages.localize,
                          isBordered: true,
                          style: Styles.smallText(color: Colors.black),
                          color: AppColors.SECONDARY_COLOR,
                          isCentered: true,
                          close: false,
                        ),
                      Label(
                        text: LocaleKeys.addImagesDesc.localize,
                        style: Styles.mediumText(
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            const Sizer(),
            if (state.images != null &&
                state.images!.isNotEmpty)
              SizedBox(
                height: kToolbarHeight * 1,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                 //     final image = state.images![index];
                      return SizedBox(
                        height: kToolbarHeight * 2,
                        width: kToolbarHeight * 2,
                        child: Stack(
                          alignment: AlignmentDirectional.topStart,
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
                                margin: const EdgeInsetsDirectional.only(
                                    end: 10, bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: FileImage(
                                      File(state.images![index].file.path),
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
                                   //   controller.removeImage(image: image);
                                    }),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Sizer(),
                    itemCount: widget.item.images.length ?? 0),
              )
          ],
        );
      }),
    );
  }
}
