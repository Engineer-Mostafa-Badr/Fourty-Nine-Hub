import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/tag_users_cubit/tag_users_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/show_image_tag_people_widget.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TagUserViewBody extends StatelessWidget {
  const TagUserViewBody({
    super.key,
    required this.onTap,
  });

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagUsersCubit, TagUsersState>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.4,
                    width: double.infinity,
                    child: ShowImageTagPeopleWidget(onTap: onTap),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1,
                              color: context.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Label(
                        text: LocaleKeys.inviteCollaborators.localize,
                        style: Styles.headerText(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: TextField(
                  //     decoration: InputDecoration(
                  //       labelText: LocaleKeys.searchForAUser.localize,
                  //       border: const OutlineInputBorder(),
                  //     ),
                  //     onChanged: (value) {
                  //       // context.read<TagUsersCubit>().searchUsersTag(value);
                  //     },
                  //   ),
                  // ),
                  // if (state.status.isLoading)
                  //   const CustomLoading()
                  // else if (state.status.isError)
                  //   Label(
                  //     text: getFailureMessage(state.failure!, context),
                  //     style: Styles.headerText(),
                  //   )
                  // else if (state.status.isSuccess)
                  //     Expanded(
                  //       child: ListView.builder(
                  //         itemCount: state
                  //             .users.length, // Replace with the actual number of users
                  //         itemBuilder: (context, index) {
                  //           final user = state.users[index];
                  //           return ListTile(
                  //             leading: ImageFromInternet(
                  //               image: user.imageUrl,
                  //               isCircle: true,
                  //               height: 40,
                  //               width: 40,
                  //               fit: BoxFit.cover,
                  //             ),
                  //             title:
                  //             Text(user.username), // Replace with actual user data
                  //             trailing: const Icon(
                  //               Icons.add_box_outlined,
                  //               color: AppColors.c1B2781,
                  //             ),
                  //             onTap: () {
                  //               log('user tapped ----------------------------------------------------------------');
                  //               log(user.id);
                  //             },
                  //           );
                  //         },
                  //       ),
                  //     ),
                ],
              ),
            ),
            context.read<CreatePostInstagramCubit>().state.usersTag.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Center(
                        child: Label(
                          text: LocaleKeys.tapPhotoToTagPeople.localize,
                          style: Styles.mediumText(
                            color: context.isDarkMode
                                ? Colors.white
                                : Colors.black.withValues(alpha: 128),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                : BlocBuilder<CreatePostInstagramCubit,
                    CreatePostInstagramState>(
                    buildWhen: (previous, current) =>
                        previous.usersTag != current.usersTag,
                    builder: (context, state) {
                      return SliverList.builder(
                          itemCount: context
                              .read<CreatePostInstagramCubit>()
                              .state
                              .usersTag
                              .length,
                          itemBuilder: (context, index) {
                            final user = context
                                .read<CreatePostInstagramCubit>()
                                .state
                                .usersTag[index];
                            return ListTile(
                              leading: ImageFromInternet(
                                image: user.imageUrl,
                                isCircle: true,
                                height: 40,
                                width: 40,
                              ),
                              title: Label(
                                text: user.username,
                                style: Styles.mediumText(
                                  fontWeight: FontWeight.w500,
                                  height: 1.29,
                                ),
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    context
                                        .read<CreatePostInstagramCubit>()
                                        .removeUserTag(user);
                                  },
                                  icon: const Icon(Icons.close_rounded)),
                            );
                          });
                    },
                  ),
          ],
        );
      },
    );
  }
}
