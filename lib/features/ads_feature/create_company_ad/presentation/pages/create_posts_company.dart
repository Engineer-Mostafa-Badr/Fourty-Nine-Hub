import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/dialog_widget/show_custom_dialog_trip.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/pages/image_gallary_viewer.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../common/functions/global/upload_file.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/styles.dart';
import '../../../../social_media/create_post/presentation/widgets/show_all_images.dart';
import '../cubit/create_company_ad_cubit.dart';

class CreatePostCompanyParams {
  final bool text;
  final bool picture;
  final String title;
  final String type;
  final num totalPrice;

  CreatePostCompanyParams({required this.text, required this.picture, required this.title, required this.type, required this.totalPrice});

}

class CreatePostCompany extends StatefulWidget {
  const CreatePostCompany(
      {super.key,
      required this.params});

  final CreatePostCompanyParams params;

  @override
  State<CreatePostCompany> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostCompany> {
  var postContentTextController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  Future<bool> onBackPressed() async {
    SystemNavigator.pop();
    return true;
  }

  @override
  void dispose() {
    postContentTextController.clear();
    super.dispose();
  }

  showSubscribeDialog(BuildContext context) {
    showCustomDialogTrip(
        context,
        Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.alert.localize,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
                context.isArabic
                    ? "هذه الخدمة ستكلف ${widget.params.totalPrice} ${'ج.م'}. هل تريد المتابعة؟"
                    : "This service will cost ${widget.params.totalPrice} ${"EGP"}. Do you want to proceed?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: FontSize.s16,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                )),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                    width: context.screenWidth / 3.4,
                    label: context.isArabic ? 'إلغاء' : 'Close',
                    backColor: AppColors.SECONDARY_COLOR_DARK2,
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                const SizedBox(width: 16),
                AppButton(
                    width: context.screenWidth / 3.4,
                    label: context.isArabic ? 'متابعة' : 'Continue',
                    backColor: AppColors.PRIMARY_COLOR,
                    onPressed: () async {
                      Navigator.of(context).pop();
                      showLoadingDialog(context);
                      await context
                          .read<
                          CreateCompanyAdCubit>()
                          .addPostCompanyAdvertise(
                        type:
                        widget.params.type,
                        post: widget
                            .params.text
                            ? postContentTextController
                            .text
                            : null,
                        totalPrice: widget
                            .params.totalPrice,
                        context:
                        context,
                      );
                    }),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ));
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateCompanyAdCubit, CreateCompanyAdState>(
      listener: (BuildContext context, state) {
      },
      builder: (BuildContext context, CreateCompanyAdState state) {
        var controller = context.read<CreateCompanyAdCubit>();
        String photo = state.image?.file.path??'';
        return CustomScaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: BackAppBar(
              centerTitle: false,
              label: widget.params.title,
            ),
          ),
          body: GestureDetector(
            onTap: ()=>FocusNode().unfocus(),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: BlocBuilder<CreateCompanyAdCubit, CreateCompanyAdState>(
                  builder: (context,state) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () {
                                  if(formKey.currentState!.validate()){
                                    if(state.files==null||(state.files?.isEmpty??false)){
                                      showErrorMessage(context, context.isArabic?'الصورة مطلوبة':'Image is required');
                                    }else{
                                      bool inArabic = context.isArabic;
                                      showSubscribeDialog(context);
                                    }
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 32),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(20.r)),
                                  child:
                                  Label(text: LocaleKeys.save.localize),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (widget.params.text) _buildCreatePost(),
                        if (widget.params.picture)
                          Column(
                            children: [
                              if (state.files!=null&&(state.files?.isNotEmpty??false))
                                _buildMediaCard(photo),
                              GestureDetector(
                                onTap: () async {
                                  await controller.uploadPhoto(
                                      hasLoading: false,
                                      isGallery: true,
                                      context: context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.all(10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          Assets.uploadImage,
                                          width: 40.h,
                                          height: 40.h,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(
                                          width: 8.w,
                                        ),
                                        Text(
                                          LocaleKeys.uploadImage.localize,
                                          style: Styles.headerText(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    );
                  }
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCreatePost() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        cursorColor: AppColors.PRIMARY_COLOR,
        maxLines: 6,
        maxLength: 150,
        validator: (value) {
          if (value!.isEmpty) {
            return LocaleKeys.fieldIsRequired.localize;
          }
          return null;
        },
        style: const TextStyle(color: AppColors.QUANTITY_COLOR),
        onChanged: (c) {
          if (c.length == 150) {
            showErrorMessage(context, LocaleKeys.character.localize);
          }
        },
        controller: postContentTextController,
        decoration: InputDecoration(
          hintText: LocaleKeys.typeHer.localize,
          hintStyle: const TextStyle(color: AppColors.QUANTITY_COLOR),
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
      ),
    );
  }

  Widget _buildMediaCard(String photo) {
    return BlocBuilder<CreateCompanyAdCubit, CreateCompanyAdState>(
      builder: (context, state) {
        final controller = context.read<CreateCompanyAdCubit>();
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: state.files?.length == 1 ? 1 : 2,
            childAspectRatio: state.files?.length == 1 ? 1:1 ,
          ),
          itemCount: state.files!.length < 4 ? state.files!.length : 4,
          itemBuilder: (context, index) => ClickableWidget(
            // Handle image interactions
            onTap: () {
              if (index != 3 || (index == 3 && state.files!.length == 4)) {
                List<XFile> files = state.files??[];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageGalleryPage(
                      files: files,
                      images: [],
                      initialIndex: index,
                    ),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    List<XFile> files = state.files ?? [];
                    List<String> mediaIds = state.mediaIds ?? [];
                    List<UploadFileEntity> images = List.generate(files.length, (index) {
                      return UploadFileEntity(
                        file: files[index],
                        mediaId: index < mediaIds.length ? mediaIds[index] : '',
                      );
                    });
                    return ShowAllImages(
                      onRemoveImage: (UploadFileEntity image) {
                        controller.removePhoto(image.file, image.mediaId);
                        setState(() {

                        });
                      },
                      images: images,
                    );
                  },
                );
              }
            },
            child: Stack(
              children: [
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsetsDirectional.only(
                          end: 10, bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: FileImage(
                            File(state.files?[index].path ?? ''),
                          ),
                        ),
                      ),
                    ),
                    if (index == 3 && state.files!.length > 4)
                      Container(
                        margin: const EdgeInsetsDirectional.only(
                            end: 10, bottom: 10),
                        // padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: Center(
                          child: Label(
                            text: "+${state.files!.length - 4}",
                            style: Styles.headerText(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if(state.files!.length >4?index<3:index<4)
                  PositionedDirectional(
                    end: 15,
                    top: 5,
                    child: ClickableWidget(
                      onTap: () {
                        controller.removePhoto(state.files?[index], state.mediaIds?[index]);
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget _buildMediaCard() {
  //   return BlocBuilder<CreatePostCubit, CreatePostState>(
  //       builder: (context, state) {
  //     final controller = context.read<CreatePostCubit>();
  //     return GridView.builder(
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         padding: const EdgeInsets.all(10),
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: state.images!.length == 1 ? 1 : 2),
  //         itemCount: state.images!.length < 4 ? state.images!.length : 4,
  //         itemBuilder: (context, index) => InkWell(
  //               onTap: () {
  //                 if (index != 3 || (index == 3 && state.images!.length == 4)) {
  //                   showDialog(
  //                     context: context,
  //                     builder: (context) => ImageDetailsScreen(
  //                       image: state.images![index].file.path,
  //                       isFile: true,
  //                       onRemoveImage: () {
  //                         controller.removePhoto(state.images![index]);
  //                         context.pop();
  //                       },
  //                     ),
  //                   );
  //                 } else {
  //                   showDialog(
  //                       context: context,
  //                       builder: (context) {
  //                         return ShowAllImages(
  //                           images: state.images!,
  //                           onRemoveImage: (UploadFileEntity image) {
  //                             controller.removePhoto(image);
  //                           },
  //                         );
  //                       });
  //                 }
  //               },
  //               child: Stack(
  //                 children: [
  //                   Stack(
  //                     children: [
  //                       Container(
  //                         margin: const EdgeInsetsDirectional.only(
  //                             end: 10, bottom: 10),
  //                         padding: const EdgeInsets.all(10),
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(15),
  //                           image: DecorationImage(
  //                             fit: BoxFit.fill,
  //                             image: FileImage(
  //                               File(state.images?[index].file.path ?? ''),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       if (index == 3 && state.images!.length > 4)
  //                         Container(
  //                           margin: const EdgeInsetsDirectional.only(
  //                               end: 10, bottom: 10),
  //                           // padding: EdgeInsets.all(10),
  //                           alignment: Alignment.center,
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(15),
  //                             color: Colors.black.withOpacity(0.5),
  //                           ),
  //                           child: Center(
  //                             child: Label(
  //                               text: "+${state.images!.length - 4}",
  //                               style: Styles.headerText(
  //                                 color: Colors.white,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                     ],
  //                   ),
  //                   if (index == 0 && state.images!.length == 1)
  //                     PositionedDirectional(
  //                       end: 15,
  //                       top: 5,
  //                       child: InkWell(
  //                         onTap: () {
  //                           controller.removePhoto(state.images?[index]);
  //                         },
  //                         child: const Icon(
  //                           Icons.close,
  //                           color: Colors.red,
  //                         ),
  //                       ),
  //                     ),
  //                 ],
  //               ),
  //             ));
  //   });
  // }
}
