import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/labels/badged_label.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/strings/labels.dart';
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
        appBar: const BackAppBar(
          label: Labels.adDetails,
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
                FormTextField(
                  label: 'title',
                  height: kToolbarHeight * .8,
                  hint: 'Type here',
                  action: (v) => controller.title = v,
                ),
                const Sizer(),
                FormTextField(
                  label: 'Description',
                  // height: kToolbarHeight * .8,
                  hint: 'Type here',
                  action: (v) => controller.description = v,
                  maxLines: 3,
                ),
                const Sizer(),
                FormTextField(
                  label: 'Phone',
                  type: TextInputType.phone,
                  // height: kToolbarHeight * .8,
                  hint: 'Type here',
                  action: (v) => controller.phone = v,
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
                FormTextField(
                  label: 'Price',
                  type: TextInputType.number,
                  hint: 'Type here',
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Label(
                        text: 'EGP',
                        style: Styles.mediumText(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  action: (v) => controller.price = v,
                ),
                const Sizer(),
                DefaultButton(
                    label: 'Publish',
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
              height: kToolbarHeight * 1.8,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
                        label: 'Add Images',
                        isBordered: true,
                        style: Styles.smallText(color: Colors.black),
                        color: AppColors.SECONDARY_COLOR,
                      ),
                    Label(
                      text:
                          '5MB maximum file size accepted in the following formats: jpg, Jpeg, png, gif',
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
                      height: kToolbarHeight * 1,
                      width: kToolbarHeight * 1,
                      child: Stack(
                        children: [
                          Positioned.fill(
                              child: Image.file(
                            fit: BoxFit.cover,
                            File(image.file.path),
                          )),
                          Positioned(
                            child: IconAppButton(
                              icon: Icons.close_sharp,
                              color: Colors.red,
                              backColor: Colors.white,
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
