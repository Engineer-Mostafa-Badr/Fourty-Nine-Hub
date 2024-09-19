import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/labels/badged_label.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
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
        .loadData(subCategoryId: widget.categorization.subCategory.id);
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
        appBar: BackAppBar(
          label: LocaleKeys.createAd.localize
        ),
        body: Padding(
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
                          text: widget.categorization.subCategory.name,
                          style: Styles.mediumText(fontWeight: FontWeight.bold),
                        ),
                        Label(text: widget.categorization.mainCategory.name),
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
                              state.isUser = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: state.isUser == true
                                    ? AppColors.PRIMARY_COLOR
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border:
                                Border.all(color: AppColors.PRIMARY_COLOR)),
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              LocaleKeys.user.localize,
                              style: Styles.mediumText(
                                  color: state.isUser == false
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
                            state.isUser = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: state.isUser == false
                                  ? AppColors.PRIMARY_COLOR
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border:
                              Border.all(color: AppColors.PRIMARY_COLOR)),
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            LocaleKeys.provider.localize,
                            style: Styles.mediumText(
                                color: state.isUser == true
                                    ? AppColors.PRIMARY_COLOR
                                    : Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Sizer(),
                TextFormField(
                  maxLines: null,
                  onChanged: (v) =>controller.title = v,
                  style: Styles.headerText(fontSize: 26),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(5),
                    hintText: LocaleKeys.title.localize,
                    hintStyle: Styles.mediumText(),
                      prefix: Sizer(width: 20.w,)
                  ),
                  validator: (value) {
                    if ((value == null || value.isEmpty)) {
                      return LocaleKeys.required.localize;
                    } else {
                      return null;
                    }
                  },
                ),
                const Sizer(),
                TextFormField(
                  maxLines: null,
                  onChanged: (v) =>controller.description = v,
                  style: Styles.headerText(fontSize: 26),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(5),
                    hintText: LocaleKeys.desc.localize,
                    hintStyle: Styles.mediumText(),
                      prefix: Sizer(width: 20.w,)
                  ),
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
                      onChanged: (String v) =>
                          controller.onChanged(v: v, index: index),
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
                          categorize: widget.categorization, context: context);
                    }),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildImagePicker() {
    final controller = context.read<CreateAdCubit>();
    return BlocBuilder<CreateAdCubit, CreateAdState>(builder: (context, state) {
      final controller = context.read<CreateAdCubit>();
      return Column(
        children: [
          InkWell(
            onTap: () => controller.uploadImage(
                subCategoryId: widget.categorization.subCategory.id),
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
                    if (state.isImageUploading)
                      const CircularProgressIndicator.adaptive(),
                    if (!state.isImageUploading)
                      Image.asset(
                        Assets.image,
                        height: kToolbarHeight * .8,
                      ),
                    if (!state.isImageUploading)
                      BadgedLabel(
                        label: LocaleKeys.addImages.localize,
                        isBordered: true,
                        style: Styles.smallText(color: Colors.black),
                        color: AppColors.SECONDARY_COLOR,
                        isCentered: true,
                        close: false,
                      ),
                    Label(
                      text:
                      LocaleKeys.addImagesDesc.localize,
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
          if (state.images?.isNotEmpty ?? false)
            SizedBox(
              height: kToolbarHeight * 1,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final image = state.images![index];
                    return SizedBox(
                      height: kToolbarHeight * 2,
                      width: kToolbarHeight * 2,
                      child: Stack(
                        alignment: AlignmentDirectional.topStart,
                        children: [
                          Positioned.fill(
                              child: Image.file(
                            fit: BoxFit.cover,
                            File(image.file.path),
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
