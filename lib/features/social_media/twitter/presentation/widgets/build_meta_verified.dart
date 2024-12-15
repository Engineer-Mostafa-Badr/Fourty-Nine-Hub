import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/request_document_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<TwitterCubit>(
        create: (_) => serviceLocator(),
        child: BlocConsumer<TwitterCubit, TwitterState>(
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
                            text: LocaleKeys.documentation.localize,
                            style: Styles.mediumText(
                              fontSize: 70.sp,
                            ),
                          ),
                        ],
                      ),
                      Sizer(
                        height: 70.sp,
                      ),
                      Label(
                        text: LocaleKeys.userName.localize,
                        style: Styles.mediumText(fontSize: 65.sp),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Form(
                          key: formKey,
                          child: TextFormField(
                            maxLines: null,
                            controller: nameTextController,
                            onChanged: (v) {
                              setState(() {});
                            },
                            validator: (v) {
                              if (v!.isEmpty) {
                                return LocaleKeys.nameRequired.localize;
                              }
                            },
                            style: Styles.mediumText(),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.w),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                              hintText:
                                  '${LocaleKeys.typeYourName.localize} ....',
                              hintStyle: Styles.mediumText(),
                            ),
                          )),
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
                              controller.uploadPersonalPhoto();
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
                                      controller.uploadFrontId();
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
                                      controller.uploadBackId();
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
                        if (formKey.currentState!.validate()) {
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
                                    mediaIds: mediaIds,
                                    name: nameTextController.text));

                            showSuccessMessage(context,
                                LocaleKeys.documentSuccessfully.localize);
                            context.pop();
                          }
                        }
                        // onSendRequest();
                      }),
                    ],
                  ),
                ),
              );
            }),
      ),
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
        backColor: AppColors.Arrow_Icon_color,
        onPressed: onTap,
        textStyle: Styles.mediumText(fontSize: 65.sp,color: AppColors.AUTH_CONTAINER_COLOR),
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
