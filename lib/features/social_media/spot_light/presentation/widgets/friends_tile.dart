import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/widget/clickable_widget.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../helpers/manage_vibration.dart';

class FriendsTile extends StatelessWidget {
  const FriendsTile({
    super.key,
    required this.name,
    required this.subtitle,
    required this.index,
    this.hasAddButton = false,
    this.hasAcceptButton = false,
    this.hasCameraButtons = false,
    this.isOnline = false,
    this.hasCloseButtons = false,
    this.isMyContact = false,
    this.onClose,
    this.buttonColor ,
  });

  final String name;
  final String subtitle;
  final int index;
  final bool hasAddButton;
  final bool hasAcceptButton;
  final bool hasCameraButtons;
  final bool isOnline;
  final bool hasCloseButtons;
  final bool isMyContact;
  final Color? buttonColor;
  final void Function()? onClose;


  @override
  Widget build(BuildContext context) {
    Color iconsColor=buttonColor!= AppColors.PRIMARY_COLOR?Colors.black: Colors.white;
    return ListTile(
      dense: false,
      contentPadding: EdgeInsets.zero,
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 50.h,
            backgroundImage: AssetImage(
              Assets.spotlight_profile,
            ),
          ),
          if (isOnline)
            Positioned(
              bottom: 4.h,
              right: 4.h,
              child:
                  const CircleAvatar(radius: 5, backgroundColor: Colors.green),
            ),
        ],
      ),
      title: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          if (isMyContact)
            Text(context.isArabic ? 'من جهات اتصالي' : 'In My Contact'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasAcceptButton)
            customButton(
                color: buttonColor??AppColors.getButtonPrimaryWhiteColor(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_add,
                      color: iconsColor,
                      size: 20.h,
                    ),
                    const Sizer(
                      width: 8,
                    ),
                    Text(
                      context.isArabic ? 'قبول' : 'Accept',
                      style: Styles.mediumText(color: iconsColor),
                    )
                  ],
                )),
          if (hasAddButton)
            customButton(
                color: buttonColor??AppColors.getButtonPrimaryWhiteColor(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_add,
                      color:iconsColor,
                      size: 25.h,
                    ),
                    const Sizer(
                      width: 8,
                    ),
                    Text(
                      context.isArabic ? 'اضافة' : 'Add',
                      style: Styles.mediumText(color: iconsColor,fontWeight: FontWeight.w600),
                    )
                  ],
                )),
          if (hasCameraButtons) ...[
            customButton(
                color: buttonColor??AppColors.getButtonPrimaryWhiteColor(context),
                Icon(
                  Icons.messenger_rounded,
                  color: context.isDarkMode?AppColors.PRIMARY_COLOR:Colors.white,
                  size: 35.h,
                )),
            const Sizer(),
            customButton(
                color: buttonColor??AppColors.getButtonPrimaryWhiteColor(context),
                Icon(Icons.camera_alt, color:context.isDarkMode?AppColors.PRIMARY_COLOR:Colors.white, size: 35.h)),
          ],
          if (hasCloseButtons)
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            ),
        ],
      ),
    );
  }

  Widget customButton(
    Widget widget, {
    required Color color,
  }) {
    return ClickableWidget(
      onTap: () {

      ManageVibration.vibrate();
      },
      child: Container(
        height: 56.h,
        // width: 84.h,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: widget,
        ),
      ),
    );
  }
}