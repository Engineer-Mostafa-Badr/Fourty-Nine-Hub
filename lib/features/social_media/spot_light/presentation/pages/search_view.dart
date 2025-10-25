import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/clickable_widget.dart';
import '../widgets/dialog_content.dart';
import '../widgets/friends_card.dart';
import '../widgets/friends_tile.dart';
import '../widgets/show_dialog.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../helpers/manage_vibration.dart';

class SpotLightSearchView extends StatefulWidget {
  const SpotLightSearchView({super.key});

  @override
  State<SpotLightSearchView> createState() => _SpotLightSearchViewState();
}

class _SpotLightSearchViewState extends State<SpotLightSearchView> {
  List blockedIndexes = [];

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
                Row(children: [
                  Expanded(
                    child: FormTextField(
                      prefix: const Icon(Icons.search),
                      hint: context.isArabic ? 'بحث...' : 'Search...',
                      fillColor: const Color(0xFFEDEDED),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const Sizer(),
                  ClickableWidget(
                    child: Text(LocaleKeys.cancel.localize,
                        style: Styles.headerText(
                            fontWeight: FontWeight.w500, fontSize: 32)),
                  ),
                ]),
                const Sizer(),
                sectionTitle(context.isArabic ? 'مؤخراً' : "Recents",
                    trailing: context.isArabic ? 'مسح الكل' : "Clear All",onTap:()=> showDialogSpotLight(context,SpotLightDialogContent(bottomButtonTitle:LocaleKeys.cancel.localize ,topButtonTitle: context.isArabic ? 'مسح' : 'Clear' ,))),
                const Sizer(),
                SizedBox(
                  height: 0.22.sh,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => FriendsCard(
                          icon: Icons.messenger,
                          iconTitle: LocaleKeys.chat.localize,
                          hasStory: false,
                          text: 'Ahmed Mohamed'),
                      itemCount: 4),
                ),
                const Sizer(),
                sectionTitle(
                  context.isArabic
                      ? 'تابع'
                      : "Follow",
                ),

                const Sizer(),
                SizedBox(
                  height: 0.22.sh,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => FriendsCard(
                          icon: Icons.add_outlined,
                          text: 'Ahmed Mohamed',
                          hasStory: true,
                          iconTitle: LocaleKeys.add.localize),
                      itemCount: 4),
                ),
                const Sizer(),
                sectionTitle(
                  context.isArabic ? 'ابحث عن اصدقاء' : 'Find Friends',
                ),
                const Sizer(),
                ...List.generate(10, (index) {
                  if (blockedIndexes.contains(index)) {
                    return blockedUserTile(index);
                  }
                  return FriendsTile(
                    index: index,
                    name: "Ahmed Mohamed",
                    subtitle: "Say Hi!",
                    hasAddButton: true,
                    isMyContact: true,
                    hasCloseButtons: true,
                    onClose: () => setState(() {
                      blockedIndexes.add(index);
                    }),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title, {String? trailing,void Function()? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        if (trailing != null)
          ClickableWidget(
            onTap: onTap,
            child: Row(
              children: [
                Text(trailing, style: Styles.mediumText()),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 26.h,
                )
              ],
            ),
          ),
      ],
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
              context.isArabic ? 'سبب آخر' : 'Other reason',
              style: Styles.mediumText(color: Colors.red),
            ),
          ],
        ),
        trailing: TextButton(
          onPressed: () {
      ManageVibration.vibrate();
            setState(() {
              blockedIndexes.remove(index);
            });
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