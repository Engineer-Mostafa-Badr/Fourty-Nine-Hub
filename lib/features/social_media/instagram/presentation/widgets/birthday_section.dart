import 'package:flutter/material.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import 'post_instagram_widget.dart';
import '../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../../res/style/styles.dart';

class BirthdaySection extends StatelessWidget {
  const BirthdaySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsetsDirectional.only(start: 10, end: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: ShapeDecoration(
                      shape: OvalBorder(
                        side: BorderSide(
                          width: 0.50,
                          strokeAlign: BorderSide.strokeAlignOutside,
                          color:
                              context.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: context.isDarkMode
                            ? const Color(0xCCFFFFFF)
                            : Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Label(
                    text: LocaleKeys.nnew.localize,
                    style: Styles.mediumText(
                      color: context.isDarkMode
                          ? const Color(0x99FFFFFF)
                          : Colors.black.withValues(alpha: 153),
                    ),
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: EdgeInsetsDirectional.only(end: index == 10 ? 10 : 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 58,
                  width: 58,
                  decoration: ShapeDecoration(
                    shape: OvalBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignOutside,
                        color: context.isDarkMode
                            ? const Color(0xff303030)
                            : const Color(0xFFDBDBDB),
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: const ImageFromInternet(
                    image: testImage,
                    isCircle: true,
                    height: 48,
                    width: 48,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Label(
                  text: 'birthday',
                  style: Styles.mediumText(
                    color: context.isDarkMode
                        ? const Color(0x99FFFFFF)
                        : Colors.black.withValues(alpha: 153),
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          width: 16,
        ),
      ),
    );
  }
}
