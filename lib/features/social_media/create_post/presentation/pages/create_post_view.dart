import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/file_picker_helper.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/feeling_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/pages/select_activity_view.dart';

import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/custom_sheet/custom_vertical_sheet_item.dart';
import '../../../../../common/widgets/stateless/custom_sheet/sheet_vertical_item.dart';
import '../../../../account_taps/privacy/domain/entities/privacy_status_enum.dart';
import '../cubit/create_post_cubit.dart';
import 'select_feeling_view.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<CreatePostCubit>();
    return BlocConsumer<CreatePostCubit, CreatePostState>(
      listener: (context, state) {
        if (state.status == CreatePostStates.error) {
          // showErrorMessage(
          //   context,
          //   getFailureMessage(
          //     state.failure!,
          //     context,
          //   ),
          // );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: BackAppBar(label: 'Create Post', actions: [
            TextButton(
                child: const Label(text: 'Post'),
                onPressed: () => controller.createPost(context: context)),
          ]),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    if (state.selectedFeeling != null)
                      BadgedLabel(label: state.selectedFeeling!.name),
                    const Sizer(),
                    if (state.selectedActivity != null)
                      BadgedLabel(label: state.selectedActivity!.name),
                  ],
                ),
              ),
              const Sizer(),
              Expanded(child: _buildCreatePost()),
              const Sizer(),
              _buildColorsBallet(context: context),
              const Sizer(),
              _buildOptions(),
              const Sizer(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCreatePost() {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
        builder: (context, state) {
      return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: state.backColor),
          child: TextField(
            maxLines: 40,
            controller:
                context.read<CreatePostCubit>().postContentTextController,
            decoration: const InputDecoration(hintText: 'Type Here ... '),
          ));
    });
  }

  Widget _buildColorsBallet({required BuildContext context}) {
    List<Color> colors = [
      Colors.white,
      Colors.orange,
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purpleAccent,
      Colors.pink,
      Colors.yellow,
      Colors.redAccent,
      Colors.lightGreen,
      Colors.tealAccent
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
                    color: colors[index],
                    border: Border.all(color: Colors.grey, width: .5),
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
          separatorBuilder: (context, index) => const Sizer(),
          itemCount: colors.length),
    );
  }

  Widget _buildOptions() {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
        builder: (context, state) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        IconButton(
            onPressed: () => FilePickerHelper().pickMedia(),
            icon: const Icon(
              Icons.image,
              color: Colors.green,
              size: 30,
            )),
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
        IconButton(
            onPressed: () async {
              final res =
                  await CustomVerticalSheetItem.normal<PrivacyStatus>(context, [
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
