import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/extensions/context_extension.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../res/style/app_colors.dart';
import '../../../../../../../res/style/styles.dart';

class CreateGroupWithContactCart extends StatelessWidget {
  const CreateGroupWithContactCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.PRIMARY_COLOR,
            child: Icon(
              Icons.group,
              color: AppColors.BACKGROUND_COLOR,
              size: 24,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Text(
              '${LocaleKeys.createGroupWith.tr()} Ahmed Nasr',
              style: Styles.mediumText(
                fontWeight: FontWeight.w600,
                color: context.isDarkMode
                    ? AppColors.BACKGROUND_COLOR
                    : AppColors.PRIMARY_COLOR,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
