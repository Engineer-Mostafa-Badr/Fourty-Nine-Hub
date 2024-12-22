import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/functions/global/upload_file.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../core/enums/base_status_enum.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../social_media/create_post/presentation/cubit/create_post_cubit.dart';
import '../../../../social_media/create_post/presentation/widgets/image_details.dart';
import '../../../../social_media/create_post/presentation/widgets/show_all_images.dart';
import '../cubit/create_company_ad_cubit.dart';

class CreatePostCompany extends StatefulWidget {
  const CreatePostCompany(
      {super.key,
      this.text = true,
      this.picture = true,
      required this.title,
      required this.totalPrice,
      required this.type});

  final bool text;
  final bool picture;
  final String title;
  final String type;
  final num totalPrice;

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => serviceLocator<CreatePostCubit>(),
      child: BlocConsumer<CreatePostCubit, CreatePostState>(
        listener: (BuildContext context, photo) {},
        builder: (BuildContext context, photo) {
          final controller = context.read<CreatePostCubit>();
          return BlocProvider<CreateCompanyAdCubit>(
            create: (_) => serviceLocator(),
            child: BlocConsumer<CreateCompanyAdCubit, CreateCompanyAdState>(
              listener: (BuildContext context, state) {
                if (state.status == StateStatus.success) {
                  showSuccessMessage(
                      context, LocaleKeys.postSubmitted.localize);

                  context.pop();
                  context.pop();

                  context.push(Routes.CREATECOMPANYAD);
                }
                // if(state.status == StateStatus.error){
                //   showErrorMessage(context,LocaleKeys.imageNotSelected.localize);
                // }
              },
              builder: (BuildContext context, Object? state) {
                return Scaffold(
                  appBar: BackAppBar(
                    centerTitle: false,
                    label: widget.title,
                    actions: [
                      TextButton(
                          child: Label(text: LocaleKeys.post.localize),
                          onPressed: () {
                            print('**************************************');
                            print(controller.selectedImages);
                            print('**************************************');
                            if (formKey.currentState!.validate()) {
                              context
                                  .read<CreateCompanyAdCubit>()
                                  .addPostCompanyAdvertise(
                                    mediaIds: widget.picture
                                        ? controller.selectedImages ??
                                            showErrorMessage(
                                              context,
                                              LocaleKeys
                                                  .imageNotSelected.localize,
                                            )
                                        : null,
                                    type: widget.type,
                                    post: widget.text
                                        ? postContentTextController.text
                                        : null,
                                    totalPrice: widget.totalPrice,
                                  );
                            }
                          }),
                    ],
                  ),
                  body: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (widget.text) _buildCreatePost(),
                          if (widget.picture)
                            Column(
                              children: [
                                if (photo.images != null &&
                                    photo.images!.isNotEmpty)
                                  _buildMediaCard(),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Wrap(
                                          children: <Widget>[
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.photo_library),
                                              title: Text(
                                                LocaleKeys.gallery.localize,
                                              ),
                                              onTap: () async {
                                                Navigator.pop(context);
                                                controller.uploadPhoto(
                                                    isGallery: true);
                                              },
                                            ),
                                            ListTile(
                                              leading:
                                                  const Icon(Icons.camera_alt),
                                              title: Text(
                                                  LocaleKeys.camera.localize),
                                              onTap: () async {
                                                Navigator.pop(context);
                                                controller.uploadPhoto(
                                                    isGallery: false);
                                                // await CompanyAdvertiseCubit.get(context)
                                                //     .uploadPhoto(isGallery: false);
                                                // Reload user data if needed
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.all(10),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        LocaleKeys.uploadImage.localize,
                                        style: Styles.headerText(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCreatePost() {
    return Container(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          cursorColor: AppColors.PRIMARY_COLOR,
          maxLines: 4,
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
              fillColor: Colors.white),
        ));
  }

  Widget _buildMediaCard() {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
        builder: (context, state) {
      final controller = context.read<CreatePostCubit>();
      return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: state.images!.length == 1 ? 1 : 2),
          itemCount: state.images!.length < 4 ? state.images!.length : 4,
          itemBuilder: (context, index) => InkWell(
                onTap: () {
                  if (index != 3 || (index == 3 && state.images!.length == 4)) {
                    showDialog(
                        context: context,
                        builder: (context) => ImageDetailsScreen(
                              image: state.images![index].file.path,
                              isFile: true,
                              onRemoveImage: () {
                                controller.removePhoto(state.images![index]);
                                context.pop();
                              },
                            ));
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => ShowAllImages(
                              images: state.images!,
                              onRemoveImage: (UploadFileEntity image) {
                                controller.removePhoto(image);
                              },
                            ));
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
                                File(state.images?[index].file.path ?? ''),
                              ),
                            ),
                          ),
                        ),
                        if (index == 3 && state.images!.length > 4)
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
                                text: "+${state.images!.length - 4}",
                                style: Styles.headerText(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (index == 0 && state.images!.length == 1)
                      PositionedDirectional(
                        end: 15,
                        top: 5,
                        child: InkWell(
                          onTap: () {
                            controller.removePhoto(state.images?[index]);
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
              ));
    });
  }
}
