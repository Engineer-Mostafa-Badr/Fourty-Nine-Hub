import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/request_document_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class BuildMetaVerified extends StatefulWidget {
  const BuildMetaVerified({super.key,});

  @override
  State<BuildMetaVerified> createState() => _BuildMetaVerifiedState();
}

class _BuildMetaVerifiedState extends State<BuildMetaVerified> {
  TextEditingController nameTextController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Label(
          text: "Documentation",
          style: Styles.headerText(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: BlocProvider<TwitterCubit>(
        create: (_)=>serviceLocator(),
        child: BlocConsumer<TwitterCubit, TwitterState>(
          listener: (context,state){},
          builder: (context,state) {
            final controller = context.read<TwitterCubit>();
            return Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: ListView(
                shrinkWrap: true,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(text: "User name",style: Styles.headerText(
                      fontSize: 20, color: AppColors.GREY_DARK_COLOR),),
                  const SizedBox(
                    height: 15,
                  ),
                  Form(
                    key: formKey,
                    child: FormTextField(
                        hint: 'Type your name ....',
                        height: kToolbarHeight * .7,
                        action: (v) {
                          setState(() {});
                        },

                        controller: nameTextController),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(
                          text: "Personal Photo",
                          style: Styles.headerText(
                              fontSize: 20, color: AppColors.GREY_DARK_COLOR),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        _buildImageCard(
                          label: '',
                          onTap: (){
                            controller.uploadPersonalPhoto();
                          },
                          fileData: state.personalPhoto,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Label(
                          text: "ID",
                          style: Styles.headerText(
                              fontSize: 20, color: AppColors.GREY_DARK_COLOR),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildImageCard(
                                label: '',
                                text: 'front',
                                onTap: (){
                                  controller.uploadFrontId();
                                },
                                fileData: state.frontId
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: _buildImageCard(
                                label: '',
                                text: 'back',
                                onTap: (){
                                  controller.uploadBackId();
                                },
                                fileData: state.backId
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildButton(onTap:()async{
                    if(formKey.currentState!.validate()){
                      if(state.personalPhoto==null){
                        showErrorMessage(context, "Select Personal Photo");
                      }else if(state.frontId==null){
                        showErrorMessage(context, "Select Front ID");
                      }else if(state.backId==null){
                        showErrorMessage(context, "Select Back ID");
                      }else{
                        List<String> mediaIds =[];
                        mediaIds.add(state.personalPhoto!.mediaId);
                        mediaIds.add(state.frontId!.mediaId);
                        mediaIds.add(state.backId!.mediaId);

                        await controller.onRequestVerification(params: TwitterDocumentationParams(
                          mediaIds: mediaIds,
                          name: nameTextController.text
                        ));

                          showSuccessMessage(context, "You have successfully uploaded your document. It is now awaiting administration review and approval.");
                          context.pop();

                      }
                    }
                    // onSendRequest();
                  } ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _buildImage(String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.camera_alt,
          size: 50,
          color: AppColors.LIGHT_GRAY_COLOR,
        ),
        if (text.isNotEmpty) _buildTitle(text),
      ],
    );
  }

  Widget _buildButton({required Function onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedAppButton(
        label: 'Request Verification',
        backColor: AppColors.Arrow_Icon_color,
        onPressed: onTap,
        textStyle: Styles.headerText(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
    );
  }

  Widget _buildImageCard(
      {Function()? onTap, required String label, String? text,UploadFileEntity? fileData}) {
    return Column(
      children: [
        if (label.isNotEmpty) ...[
          Label(
            text: label,
            style: Styles.headerText(),
          ),
          const Sizer(),
        ],
        if (fileData ==null) InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(UIConst.radius),
            ),
            child: _buildImage(text ?? ''),
          ),
        ) else Container(
          width: double.infinity,
          height: 200, // Set your desired height here
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(UIConst.radius),
            image: DecorationImage(
              image: FileImage(File(fileData.file.path)),
              fit: BoxFit.fill,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTitle(String text) {
    return Text(text);
  }
}
