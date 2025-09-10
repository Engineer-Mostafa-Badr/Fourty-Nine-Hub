import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../widgets/friends_tile.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../helpers/manage_vibration.dart';

class AllContactsView extends StatefulWidget {
  const AllContactsView({super.key});

  @override
  State<AllContactsView> createState() => _AllContactsViewState();
}

class _AllContactsViewState extends State<AllContactsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.h),
            child: Column(
              children: [
                const Sizer(),
                Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      visualDensity:const VisualDensity(horizontal: -4,vertical: -2),
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color:context.isDarkMode?Colors.white:Colors.black ,
                        size: 50.h,
                      ),
                      onPressed: () =>Navigator.of(context).pop(),
                    )),
                const Sizer(),
                FormTextField(
                  prefix: Icon(Icons.search,color:AppColors.getTextColor(context),),
                  hint: context.isArabic ? 'بحث...' : 'Search...',
                  style: Styles.mediumText(color: AppColors.getTextColor(context)),
                  textStyle: Styles.mediumText(color: AppColors.getTextColor(context)),
                  fillColor: AppColors.getFillColor(context),
                  borderRadius: BorderRadius.circular(20),
                ),
                const Sizer(),
                ...List.generate(10, (index) {
                  return FriendsTile(
                    buttonColor: const Color(0xFFEDEDED),
                    index: index,
                    name: "Ahmed Mohamed",
                    subtitle: "Say Hi!",
                    hasAddButton: true,
                    isMyContact: true,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget blockedUserTile(int index) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        dense: false,
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 50.h,
          backgroundImage: AssetImage(
            Assets.spotlight_profile,
          ),
        ),
        title: Text(
          context.isArabic
              ? 'اخبرنا عن السبب Ahmed Mohamed اخفاء '
              : "Hide Ahmed Mohamed Tell us why?",
          // maxLines: 1,
          // overflow: TextOverflow.ellipsis,
          style: Styles.mediumText(fontSize: 24),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.isArabic
                  ? 'لا اعرف هذا الشخص'
                  : 'I don’t know this person',
              style: Styles.mediumText(
                color: Colors.red,
              ),
            ),
            const Sizer(
              height: 8,
            ),
            Text(
              context.isArabic ? 'سبب اخر' : 'Other reason',
              style: Styles.mediumText(color: Colors.red),
            ),
          ],
        ),
        trailing: TextButton(
          onPressed: () {

      ManageVibration.vibrate();
          },
          clipBehavior: Clip.none,
          child: Text(
            context.isArabic ? 'تراجع' : 'Undo',
            style: Styles.mediumText(color: Colors.red),
          ),
        ),
      ),
    );
  }

}