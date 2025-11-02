import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import '../../../../../common/functions/global/upload_file.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/elevated_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../domain/usecases/request_document_usecase.dart';
import '../bloc/twitter_bloc.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class BuildMetaVerified extends StatefulWidget {
  const BuildMetaVerified({
    super.key,
  });

  @override
  State<BuildMetaVerified> createState() => _BuildMetaVerifiedState();
}

class _BuildMetaVerifiedState extends State<BuildMetaVerified> {
  TextEditingController nameTextController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  initState() {
    context.read<TwitterCubit>().getVerification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: BlocConsumer<TwitterCubit, TwitterState>(
          listener: (context, state) {},
          builder: (context, state) {
            final controller = context.read<TwitterCubit>();
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 80.h),
                child: ListView(
                  shrinkWrap: true,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back)),
                        SizedBox(
                          width: 40.w,
                        ),
                        Label(
                          text: LocaleKeys.verification.localize,
                          style: Styles.mediumText(
                            fontSize: 70.sp,
                          ),
                        ),
                      ],
                    ),
                    Sizer(
                      height: 70.sp,
                    ),
                    // Label(
                    //   text: LocaleKeys.name.localize,
                    //   style: Styles.mediumText(fontSize: 65.sp),
                    // ),
                    // SizedBox(
                    //   height: 5.h,
                    // ),
                    // Form(
                    //     key: formKey,
                    //     child: TextFormField(
                    //       maxLines: null,
                    //       controller: nameTextController,
                    //       onChanged: (v) {
                    //         setState(() {});
                    //       },
                    //       validator: (v) {
                    //         if (v!.isEmpty) {
                    //           return LocaleKeys.nameRequired.localize;
                    //         }
                    //         return null;
                    //       },
                    //       style: Styles.mediumText(),
                    //       decoration: InputDecoration(
                    //         contentPadding: EdgeInsets.all(10.w),
                    //         border: const OutlineInputBorder(
                    //             borderSide: BorderSide(
                    //                 color: AppColors.PRIMARY_COLOR)),
                    //         enabledBorder: const OutlineInputBorder(
                    //             borderSide: BorderSide(
                    //                 color: AppColors.PRIMARY_COLOR)),
                    //         focusedBorder: const OutlineInputBorder(
                    //             borderSide: BorderSide(
                    //                 color: AppColors.PRIMARY_COLOR)),
                    //         hintText:
                    //             '${LocaleKeys.typeYourName.localize} ....',
                    //         hintStyle: Styles.mediumText(),
                    //       ),
                    //     )),
                    Sizer(
                      height: 50.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(
                            text: LocaleKeys.personalPhoto.localize,
                            style: Styles.mediumText(fontSize: 65.sp)),
                        SizedBox(
                          height: 5.h,
                        ),
                        _buildImageCard(
                          label: '',
                          onTap: () {
                            controller.uploadPersonalPhoto(context: context);
                          },
                          onRemove: () {
                            controller.removePersonalPhoto();
                          },
                          fileData: state.personalPhoto,
                        ),
                        Sizer(
                          height: 50.h,
                        ),
                        Label(
                          text: LocaleKeys.id.localize,
                          style: Styles.mediumText(fontSize: 65.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildImageCard(
                                  label: '',
                                  text: LocaleKeys.front.localize,
                                  onTap: () {
                                    controller.uploadFrontId(context: context);
                                  },
                                  onRemove: () {
                                    controller.removeFrontId();
                                  },
                                  fileData: state.frontId),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: _buildImageCard(
                                  label: '',
                                  text: LocaleKeys.back.localize,
                                  onTap: () {
                                    controller.uploadBackId(context: context);
                                  },
                                  onRemove: () {
                                    print('back');
                                    controller.removeBackId();
                                  },
                                  fileData: state.backId),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    _buildButton(onTap: () async {
                      // if (formKey.currentState!.validate()) {
                      if (state.isVerified == false) {
                        SubscriptionMethod().subscribe(
                            subscribeId: '66bb94c3083de8342c9d4f38',
                            title: context.isArabic
                                ? "توثيق الحساب"
                                : "Verify Account",
                            onSubscribe: (success) {
                              context.pop();
                              if (success) controller.getVerification();
                            });
                        return;
                      }
                      if (state.personalPhoto == null) {
                        showErrorMessage(context, "Select Personal Photo");
                      } else if (state.frontId == null) {
                        showErrorMessage(context, "Select Front ID");
                      } else if (state.backId == null) {
                        showErrorMessage(context, "Select Back ID");
                      } else {
                        List<String> mediaIds = [];
                        mediaIds.add(state.personalPhoto!.mediaId);
                        mediaIds.add(state.frontId!.mediaId);
                        mediaIds.add(state.backId!.mediaId);

                        await controller.onRequestVerification(
                          params: TwitterDocumentationParams(
                            idImageFront: state.frontId!.mediaId,
                            idImageBack: state.backId!.mediaId,
                            personalImage: state.personalPhoto!.mediaId,
                          ),
                        );

                        showSuccessMessage(
                            context, LocaleKeys.documentSuccessfully.localize);
                        context.pop();
                      }
                      // }
                      // onSendRequest();
                    }),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _buildImage(String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.camera_alt,
          size: 90.sp,
          color: AppColors.LIGHT_GRAY_COLOR,
        ),
        if (text.isNotEmpty) _buildTitle(text),
      ],
    );
  }

  Widget _buildButton({required Function onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 70.h,
      child: ElevatedAppButton(
        label: LocaleKeys.requestVerification.localize,
        backColor: AppColors.PRIMARY_COLOR,
        onPressed: onTap,
        textStyle: Styles.mediumText(
            fontSize: 65.sp, color: AppColors.AUTH_CONTAINER_COLOR),
      ),
    );
  }

  Widget _buildImageCard(
      {Function()? onTap,
      Function()? onRemove,
      required String label,
      String? text,
      UploadFileEntity? fileData}) {
    return Column(
      children: [
        if (label.isNotEmpty) ...[
          Label(
            text: label,
            style: Styles.headerText(),
          ),
          const Sizer(),
        ],
        if (fileData == null)
          InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(UIConst.radius),
              ),
              child: _buildImage(text ?? ''),
            ),
          )
        else
          Stack(
            children: [
              InkWell(
                onTap: onTap,
                child: Container(
                  width: double.infinity,
                  height: 200.h, // Set your desired height here
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(UIConst.radius),
                    image: DecorationImage(
                      image: FileImage(File(fileData.file.path)),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              // PositionedDirectional(
              //     top: 5,
              //     end: 5,
              //     child: InkWell(onTap: onRemove,child: Icon(Icons.close,color: Colors.red,)))
            ],
          )
      ],
    );
  }

  Widget _buildTitle(String text) {
    return Text(text);
  }
}
