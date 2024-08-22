import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class BuildSearchFriends extends StatefulWidget {
  const BuildSearchFriends(
      {super.key,});
  @override
  State<BuildSearchFriends> createState() => _BuildSearchFriendsState();
}

class _BuildSearchFriendsState extends State<BuildSearchFriends> {
  final searchController = TextEditingController();

  @override
  void initState() {
    print("object");
    context.read<CreatePostCubit>().resetPagination();
    context.read<CreatePostCubit>().initScroll();
    context.read<CreatePostCubit>().getFriendsFollowers('');
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
        builder: (context, state) {
      final controller = context.read<CreatePostCubit>();
      return Padding(
        padding: const EdgeInsetsDirectional.only(top: 20.0, end: 8,start: 8),
        child: Column(
          children: [
            FormTextField(
              hint: 'search ....',
              height: kToolbarHeight * .7,
              action: (v) async {
                setState(() {});
                context.read<CreatePostCubit>().resetPagination();
                await context.read<CreatePostCubit>().getFriendsFollowers(v);
                // controller.usersPagingController.itemList = [];
                // await controller.getFriendsFollowers(PaginationParams(page: 1), v);
              },
              controller: searchController,
              suffix: const Icon(Icons.search),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: state.users?.length??0,
                controller: controller.scrollController,
                itemBuilder: (context, index) => Container(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(state.users?[index]
                                .profilePicture ??
                                ''),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Label(
                            text: state.users?[index].fullName??'',
                            style: Styles.headerText(),
                          ),
                        ],
                      ),
                      Checkbox(
                          value: state.users?[index].isSelected,
                          onChanged: (v) {
                            controller.selectUsers(state.users??[],index);
                            setState(() {});
                          }),
                    ],
                  ),
                ),
              ),
            )

          ],
        ),
      );
    });
  }
}
