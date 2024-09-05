import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/place_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/post_user_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_search_friends.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_search_places.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/feeling_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/pages/select_activity_view.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/image_details.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/show_all_images.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/custom_sheet/custom_vertical_sheet_item.dart';
import '../../../../../common/widgets/stateless/custom_sheet/sheet_vertical_item.dart';
import '../../../../account_taps/privacy/domain/entities/privacy_status_enum.dart';
import '../cubit/create_post_cubit.dart';
import 'select_feeling_view.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key, required this.social});
  final String social;

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<CreatePostCubit>();
    return BlocConsumer<CreatePostCubit, CreatePostState>(
      listener: (context, state) {
        if (state.status == CreatePostStates.error) {}
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: BackAppBar(label: 'Create Post', actions: [
                TextButton(
                    child: const Label(text: 'Post'),
                    onPressed: () => controller.createPost(
                        context: context, type: widget.social)),
              ]),
              body: ListView(
                shrinkWrap: true,
                children: [
                  if (state.place != null && state.place!.name.isNotEmpty)
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 30,
                            ),
                            Expanded(
                              child: BadgedLabel(
                                label: state.place!.name,
                                style: Styles.headerText(),
                                onRemove: () {
                                  controller.onRemovePlace();
                                },
                              ),
                            ),
                            if (state.place!.name.length < 30)
                              const Flexible(child: SizedBox.shrink()),
                          ],
                        ),
                      ),
                    ),
                  if (widget.social != 'twitter')
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          if (state.selectedFeeling != null &&
                              state.selectedFeeling!.name.isNotEmpty)
                            BadgedLabel(
                              label: state.selectedFeeling!.name,
                              onRemove: () {
                                controller.onRemoveFeeling();
                              },
                            ),
                          const Sizer(),
                          if (state.selectedActivity != null &&
                              state.selectedActivity!.name.isNotEmpty)
                            BadgedLabel(
                              label: state.selectedActivity!.name,
                              onRemove: () {
                                controller.onRemoveActivity();
                              },
                            ),
                        ],
                      ),
                    ),
                  if (state.selectedUsers != null &&
                      state.selectedUsers!.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Label(
                        text: 'with: ',
                        style: Styles.headerText(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Wrap(
                        direction: Axis.horizontal,
                        runSpacing: 10,
                        spacing: 10,
                        children: List.generate(
                          state.selectedUsers!.length,
                          (index) => GestureDetector(
                              onTap: () {},
                              child: BadgedLabel(
                                label:
                                    state.selectedUsers?[index].fullName ?? '',
                                width: 100,
                                onRemove: () {
                                  controller.onRemoveUser(
                                      state.selectedUsers![index]);
                                },
                              )),
                        ),
                      ),
                    ),
                  ],
                  const Sizer(),
                  _buildCreatePost(),
                  const Sizer(),
                  if (widget.social != 'twitter' &&
                      (state.images == null || state.images!.isEmpty))
                    _buildColorsBallet(context: context),
                  const Sizer(),
                  _buildOptions(controller),
                  const Sizer(),
                  if (state.images != null && state.images!.isNotEmpty)
                    Expanded(child: _buildMediaCard()),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCreatePost() {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
        builder: (context, state) {
      return Container(
          padding: const EdgeInsets.all(10),
          color: state.backColor.isNotEmpty
              ? Color(int.parse(state.backColor.substring(1), radix: 16))
              : Colors.white,
          child: TextField(
            maxLines: 4,
            maxLength: 150,
            style: const TextStyle(color: AppColors.QUANTITY_COLOR),
            onChanged: (c) {
              if (c.length == 150) {
                showErrorMessage(
                    context, "You can't type more than 150 character");
              }
            },
            controller:
                context.read<CreatePostCubit>().postContentTextController,
            decoration: const InputDecoration(
                hintText: 'Type Here ... ',
                hintStyle: TextStyle(color: AppColors.QUANTITY_COLOR),
                fillColor: Colors.white),
          ));
    });
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
                            // padding: const EdgeInsets.all(10),
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

  Widget _buildColorsBallet({required BuildContext context}) {
    final List<String> colors = [
      "#FFFFFFFF", // Colors.white
      "#FFFFA500", // Colors.orange
      "#FF0000FF", // Colors.blue
      "#FFFF0000", // Colors.red
      "#FF008000", // Colors.green
      "#FFDA70D6", // Colors.purpleAccent
      "#FFFFC0CB", // Colors.pink
      "#FFFFFF00", // Colors.yellow
      "#FFFF5252", // Colors.redAccent
      "#FF90EE90", // Colors.lightGreen
      "#FF64FFDA" // Colors.tealAccent
    ];
    final controller = context.read<CreatePostCubit>();
    return SizedBox(
      height: 30,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => controller.selectColor(color: colors[index]),
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color:
                        Color(int.parse(colors[index].substring(1), radix: 16)),
                    border: Border.all(color: Colors.grey, width: .5),
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
          separatorBuilder: (context, index) => const Sizer(),
          itemCount: colors.length),
    );
  }

  Widget _buildOptions(CreatePostCubit controller) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
        builder: (context, state) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        IconButton(
            onPressed: () async {
              await controller.uploadPhoto();
            },
            icon: const Icon(
              Icons.image,
              color: Colors.green,
              size: 30,
            )),
        if (widget.social != 'twitter')
          IconButton(
              onPressed: () {
                bottomSheet(
                    isScrollControlled: true,
                    context: context,
                    widget: SelectActivity(
                      activities: state.activities ?? [],
                      onSelected: (ActivityEntity item) => context
                          .read<CreatePostCubit>()
                          .selectActivity(item: item),
                    ));
              },
              icon: const Icon(
                Icons.local_activity,
                color: Colors.blue,
                size: 30,
              )),
        if (widget.social != 'twitter')
          IconButton(
              onPressed: () {
                bottomSheet(
                    isScrollControlled: true,
                    context: context,
                    widget: SelectFeelingView(
                      feelings: state.feelings ?? [],
                      onSelected: (FeelingEntity item) => context
                          .read<CreatePostCubit>()
                          .selectedFeeling(item: item),
                    ));
              },
              icon: const Icon(
                Icons.emoji_emotions_outlined,
                color: Colors.orangeAccent,
                size: 30,
              )),
        if (widget.social != 'twitter')
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => BuildSearchFriends(
                          onSelectUser: (PostUserEntity user) {
                            controller.selectUsers(user);
                            // context.pop(true);
                          },
                          controller: controller,
                        ));
              },
              icon: const Icon(
                Icons.people,
                color: Colors.grey,
                size: 30,
              )),
        if (widget.social != 'twitter')
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => BuildSearchPlaces(
                        onSelectPlace: (PlaceEntity place) {
                          controller.onSelectPlace(place);
                          context.pop();
                        },
                        controller: controller));
              },
              icon: const Icon(
                Icons.location_on,
                color: Colors.grey,
                size: 30,
              )),
        if (widget.social != 'twitter')
          IconButton(
              onPressed: () async {
                final res = await CustomVerticalSheetItem.normal<PrivacyStatus>(
                    context, [
                  CustomSheetModel(
                    text: "Public",
                    value: PrivacyStatus.public,
                    iconData: Icons.language,
                  ),
                  CustomSheetModel(
                    text: "Friends",
                    value: PrivacyStatus.friends,
                    iconData: Icons.family_restroom,
                  ),
                  CustomSheetModel(
                    text: "Followers",
                    value: PrivacyStatus.followers,
                    iconData: Icons.accessibility_sharp,
                  ),
                  CustomSheetModel(
                    text: "Friends / Followers",
                    value: PrivacyStatus.friendsAndFollowers,
                    iconData: Icons.supervised_user_circle_outlined,
                  ),
                  CustomSheetModel(
                    text: "Only Me",
                    value: PrivacyStatus.onlyMe,
                    iconData: Icons.lock,
                  ),
                ]);
                print(res?.name);
                print("============>");
                controller.selectPrivacy(privacy: res?.name ?? 'public');
              },
              icon: const Icon(
                Icons.privacy_tip,
                color: Colors.grey,
                size: 30,
              )),
      ]);
    });
  }
}
