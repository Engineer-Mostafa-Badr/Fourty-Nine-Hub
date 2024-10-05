import 'dart:io';
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

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/labels/badged_label.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../domain/entity/my_ads_auction.dart';
import '../../domain/entity/my_auction_main_category.dart';
import '../../domain/entity/my_auction_sub_category_entity.dart';
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
                        print(state.images?[0].mediaId);
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
                                                  controller.removePhoto(
                                                      state.images![index]);
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                ),
                              ),
                            const Sizer(),
                            if (widget.item.images != null &&
                                widget.item.images.isNotEmpty)
                              SizedBox(
                                height: 80.h,
                                child: Row(
                                  children: List.generate(
                                      widget.item.images.length,
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
                                                      .item.images[index].photo,
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
                                                              controller.removePhoto(
                                                                  state.images![
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
