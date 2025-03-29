import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/read_more_text.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DescriptionPost extends StatelessWidget {
  const DescriptionPost({
    super.key,
    required this.name,
    required this.description,
  });
  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 19),
      child: ReadMoreText(
        username: name,
        description: description,
        usernameStyle: Styles.mediumText(
          fontWeight: FontWeight.w600,
        ),
        descriptionStyle: Styles.mediumText(),
      ),
    );
  }
}