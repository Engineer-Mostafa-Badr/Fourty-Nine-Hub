import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/extensions/context_extension.dart';
import '../../../../../../../res/style/app_colors.dart';
import '../../../../../../../res/style/styles.dart';

class CommonGroupCart extends StatelessWidget {
  const CommonGroupCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              "https://cdn-icons-png.flaticon.com/512/8068/8068189.png",
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flutter Team',
                  style: Styles.mediumText(
                    fontWeight: FontWeight.w600,
                    color: context.isDarkMode
                        ? AppColors.BACKGROUND_COLOR
                        : AppColors.PRIMARY_COLOR,
                  ),
                ),
                Text(
                  'Eng. Mohamed Gamal,  Abdullrahman Allam',
                  overflow: TextOverflow.ellipsis,
                  style: Styles.mediumText(
                    fontWeight: FontWeight.w400,
                    color: AppColors.DARK_GRAY_COLOR,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
