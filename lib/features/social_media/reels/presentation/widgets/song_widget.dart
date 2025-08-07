import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../res/assets/assets.dart';

class SongWidget extends StatelessWidget {
  const SongWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          SvgPicture.asset(
            Assets.songIcon,
          ),
          const SizedBox(width: 5),
          Text(
            context.isArabic
                ? 'اسم الأغنية - فنان الأغنية'
                : "Song name - song artist",
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
