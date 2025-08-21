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

import '../../../../../service_locator/service_locator.dart';

class TagUserViewBody extends StatelessWidget {
  const TagUserViewBody({
    super.key,
    required this.onSearchTap,
  });

  final void Function(Offset tapPosition, int imageIndex) onSearchTap;

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
                    child: ShowImageTagPeopleWidget(
                      onTap: onSearchTap,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                    },
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
                  const SizedBox(height: 8),
                ],
              ),
            ),
            serviceLocator<CreatePostInstagramCubit>().state.usersTag.isEmpty
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
                    itemCount: serviceLocator<CreatePostInstagramCubit>()
                        .state
                        .usersTag
                        .length,
                    itemBuilder: (context, index) {
                      final user = serviceLocator<CreatePostInstagramCubit>()
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
                        subtitle: user.imageIndex != null
                            ? context.isArabic? Text('صورة ${user.imageIndex! + 1}') : Text('Image ${user.imageIndex! + 1}')
                            : null,
                        trailing: IconButton(
                            onPressed: () {
                              serviceLocator<CreatePostInstagramCubit>()
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