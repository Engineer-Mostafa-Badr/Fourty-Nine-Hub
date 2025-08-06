import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class SoundTitleWidget extends StatelessWidget {
  const SoundTitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 16, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              context.pop();
            },
            child: const Icon(
              Icons.close,
              size: 20,
            ),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.isArabic
                    ? 'الصوت الأصلي - xrvvuib'
                    : 'Original Sound - xrvvuib',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                context.isArabic
                    ? ' ٨٤٧ قطعة. تم التحديث قبل ٢١ ساعة'
                    : ' 847 parts . Updated 21h ago',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: context.isDarkMode
                      ? Colors.white
                      : const Color(0xff676767),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              SizedBox(width: 5),
              SvgPicture.asset(
                width: 15,
                Assets.saveSong,
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
              SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  Share.share(
                      'https://www.youtube.com/watch?v=ka0eicWdyyE&ab_channel=ThepathtoAllah%D8%A7%D9%84%D8%B7%D8%B1%D9%8A%D9%82%D8%A7%D9%84%D9%8A%D8%A7%D9%84%D9%84%D9%87%E2%99%A5'); // النص اللي هيتشارك
                },
                child: SvgPicture.asset(
                  Assets.shareSong,
                  width: 15,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
