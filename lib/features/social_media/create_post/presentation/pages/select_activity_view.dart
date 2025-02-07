import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectActivity extends StatelessWidget {
  final List<ActivityEntity> activities;
  final Function(ActivityEntity) onSelected;

  const SelectActivity(
      {super.key, required this.activities, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.selectActivity.localize,
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 4),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final item = activities[index];
            print("${item.image} ${context.isArabic ? item.name : item.nameEn}");
            return InkWell(
              onTap: () {
                onSelected(item);
                Navigator.pop(context, item);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: .5)),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Label(
                        text: item.image,
                        style: Styles.mediumText(),
                      ),
                    ),
                    Text(
                      '❤️',
                      style: GoogleFonts.notoColorEmoji(), // Ensure the font supports emojis
                    ),
                    const Sizer(),
                    Expanded(child: Label(text: "${item.image} ${context.isArabic ? item.name : item.nameEn}"))
                  ],
                ),
              ),
            );
          }),
    );
  }
}
