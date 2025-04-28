import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/data_suggest_follow_instagram_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/profile_instagram_cubit/profile_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/post_instagram_widget.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DiscoverPeopleProfileInstagramListViewItem extends StatelessWidget {
  const DiscoverPeopleProfileInstagramListViewItem(
      {super.key, required this.suggest});

  final SuggestionEntity suggest;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      // width: MediaQuery.of(context).size.width * 0.3,
      aspectRatio: 121 / 151,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ImageFromInternet(
                image: testImage,
                height: 60,
                width: 60,
                isCircle: true,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 4,
              ),
              Label(
                text: '${suggest.firstName} ${suggest.lastName}',
                style: Styles.mediumText(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Label(
                text: LocaleKeys.followedBy.localize,
                style: Styles.mediumText(
                  fontSize: 22,
                  color: Colors.black.withValues(alpha: 153),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Label(
                  text:
                      '${suggest.followers.first.firstName} ${suggest.followers.first.lastName} + ${suggest.followers.length - 1}',
                  style: Styles.mediumText(
                    fontSize: 22,
                    color: Colors.black.withValues(alpha: 153),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              AppButton(
                height: 24,
                width: 121,
                label: LocaleKeys.follow.localize,
                style: Styles.headerText(
                  fontSize: 24,
                  color: Colors.white,
                  height: 1.50,
                ),
                backColor: const Color(0xFF0B1035),
                onPressed: () {
                  context
                      .read<ProfileInstagramCubit>()
                      .followUser(suggest.userId);
                },
              ),
            ],
          ),
          PositionedDirectional(
            top: 0,
            end: 0,
            child: InkWell(
              onTap: () {
                context
                    .read<ProfileInstagramCubit>()
                    .removeFollowUser(suggest.userId);
              },
              child: const Icon(
                Icons.close,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
