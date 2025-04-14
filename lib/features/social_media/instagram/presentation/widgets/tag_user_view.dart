import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/tag_users_cubit/tag_users_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/post_instagram_widget.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TagUserView extends StatefulWidget {
  const TagUserView({super.key, required this.image});
  final File image;

  @override
  State<TagUserView> createState() => _TagUserViewState();
}

class _TagUserViewState extends State<TagUserView> {

  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  bool isSearchClicked = false;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: isSearchClicked?
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xffF0F0F0),
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) {},
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                  hintText: LocaleKeys.searchForAUser.localize,
                  hintStyle: Styles.mediumText(
                    color: Colors.black.withValues(alpha: 128),
                    fontSize: 32
                  ),
                ),
              ),
            )
      :  Label(
          text: LocaleKeys.tagPeople.localize,
          style: Styles.headerText(),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close_rounded),
        ),
        actions: !isSearchClicked? [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.check,
              color: Color(0xffFF3308),
            ),
          ),
        ] : null,
      ),
      body: TagUserViewBody(image: widget.image),
    );
  }
}

class TagUserViewBody extends StatelessWidget {
  const TagUserViewBody({
    super.key,
    required this.image,
  });

  final File image;// 01044026623

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagUsersCubit, TagUsersState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.4,
              width: double.infinity,
              child: Image.file(image,
                fit: BoxFit.contain,
              ),
            ),
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
    );
  }
}
