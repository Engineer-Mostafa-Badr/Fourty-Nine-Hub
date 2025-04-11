import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/tag_users_cubit/tag_users_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/post_instagram_widget.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TagUserView extends StatelessWidget {
  const TagUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Label(
          text: LocaleKeys.tagPeople.localize,
          style: Styles.headerText(),
        ),
      ),
      body: BlocBuilder<TagUsersCubit, TagUsersState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: LocaleKeys.searchForAUser.localize,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    // context.read<TagUsersCubit>().searchUsersTag(value);
                  },
                ),
              ),
              if (state.status.isLoading)
                const CustomLoading()
              else if (state.status.isError)
                Label(
                  text: getFailureMessage(state.failure!, context),
                  style: Styles.headerText(),
                )
              else if (state.status.isSuccess)
                Expanded(
                  child: ListView.builder(
                    itemCount: state.users
                        .length, // Replace with the actual number of users
                    itemBuilder: (context, index) {
                      final user = state.users[index];
                      return ListTile(
                        leading: ImageFromInternet(
                          image: user.imageUrl,
                          isCircle: true,
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                            user.username), // Replace with actual user data
                        trailing: const Icon(
                          Icons.add_box_outlined,
                          color: AppColors.c1B2781,
                        ),
                        onTap: () {
                          log('user tapped ----------------------------------------------------------------');
                          log(user.id);
                        },
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
