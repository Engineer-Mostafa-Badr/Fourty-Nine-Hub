import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/clickable_widget.dart';
import 'all_contacts.dart';
import '../widgets/friends_tile.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../helpers/manage_vibration.dart';

class AddFriendsScreen extends StatefulWidget {
  const AddFriendsScreen({super.key});

  @override
  State<AddFriendsScreen> createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  List blockedIndexes = [];

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'Add Friends',
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.h),
              child: Column(
                children: [
                  const Sizer(),
                  Row(
                    children: [
                      ClickableWidget(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(Icons.arrow_back_rounded,
                              color: context.isDarkMode
                                  ? Colors.white
                                  : Colors.black)),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                                context.isArabic
                                    ? 'اضافة اصدقاء'
                                    : 'Add Friends',
                                style: Styles.headerText(
                                    color: context.isDarkMode
                                        ? Colors.white
                                        : Colors.black)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 12.h,
                                  backgroundColor: const Color(0xFF13D209),
                                ),
                                Text(
                                  ' 76+ ${context.isArabic ? 'اقتراح كان نشط اليوم السابق' : 'suggestions were active in the last day!'}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      ClickableWidget(
                          onTap: () => showFilterBottomSheet(context),
                          child: Icon(Icons.more_horiz,
                              color: context.isDarkMode
                                  ? Colors.white
                                  : Colors.black)),
                    ],
                  ),
                  const Sizer(),

                  FormTextField(
                    prefix: Icon(
                      Icons.search,
                      color: AppColors.getTextColor(context),
                    ),
                    hint: context.isArabic ? 'بحث...' : 'Search...',
                    style: Styles.mediumText(color: AppColors.getTextColor(context)),
                    textStyle: Styles.mediumText(color: AppColors.getTextColor(context)),
                    fillColor: AppColors.getFillColor(context),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  const Sizer(),
                  sectionTitle(context.isArabic ? 'اضف' : "Added Me"),
                  const Sizer(),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      if (blockedIndexes.contains(index)) {
                        return blockedUserTile(index);
                      }
                      return FriendsTile(
                        index: index,
                        name: "Ahmed Mohamed",
                        subtitle: context.isArabic?'مرحباً!':"Say Hi!",
                        hasCameraButtons: index == 1 ? false : true,
                        isMyContact: index == 1 ? true : false,
                        hasAcceptButton: index == 1 ? true : false,
                        hasCloseButtons: index == 1 ? true : false,
                        onClose: () => setState(() {
                          blockedIndexes.add(index);
                        }),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                  ),
                  // ...List.generate(3, (index) {
                  //   if (blockedIndexes.contains(index)) {
                  //     return blockedUserTile(index);
                  //   }
                  //   return FriendsTile(
                  //     index: index,
                  //     name: "Ahmed Mohamed",
                  //     subtitle: "Say Hi!",
                  //     hasCameraButtons: index == 1 ? false : true,
                  //     isMyContact: index == 1 ? true : false,
                  //     hasAcceptButton: index == 1 ? true : false,
                  //     hasCloseButtons: index == 1 ? true : false,
                  //     onClose: () => setState(() {
                  //       blockedIndexes.add(index);
                  //     }),
                  //   );
                  // }),
                  viewMoreButton(),

                  // قائمة "Find Friends"
                  sectionTitle(
                      context.isArabic ? 'ابحث عن اصدقاء' : "Find Friends",
                      trailing:
                          context.isArabic ? 'جهات اتصالي' : "All Contacts",
                      onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AllContactsView(),
                            ),
                          )),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      int totalIndex = index + 3;
                      if (blockedIndexes.contains(totalIndex)) {
                        return blockedUserTile(totalIndex);
                      }
                      return FriendsTile(
                        index: totalIndex,
                        name: "Ahmed Mohamed",
                        subtitle: "Say Hi!",
                        hasAddButton: true,
                        isMyContact: true,
                        hasCloseButtons: true,
                        onClose: () => setState(() {
                          blockedIndexes.add(totalIndex);
                        }),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                  ),

                  // ...List.generate(5, (index) {
                  //   int totalIndex = index + 3;
                  //   if (blockedIndexes.contains(totalIndex)) {
                  //     return blockedUserTile(totalIndex);
                  //   }
                  //   return FriendsTile(
                  //     index: totalIndex,
                  //     name: "Ahmed Mohamed",
                  //     subtitle: "Say Hi!",
                  //     hasAddButton: true,
                  //     isMyContact: true,
                  //     hasCloseButtons: true,
                  //     onClose: () => setState(() {
                  //       blockedIndexes.add(totalIndex);
                  //     }),
                  //   );
                  // }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title,
      {String? trailing, void Function()? onTap}) {
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
                Text(trailing,
                    style: Styles.mediumText(
                        color:
                            context.isDarkMode ? Colors.white : Colors.black)),
                Icon(Icons.arrow_forward_ios,
                    size: 26.h,
                    color: context.isDarkMode ? Colors.white : Colors.black)
              ],
            ),
          ),
      ],
    );
  }

  Widget blockedUserTile(int index) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        color: context.isDarkMode?AppColors.getFindFillColor(context):Colors.grey.shade300,
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

  Widget viewMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextButton.icon(
        onPressed: () {

      ManageVibration.vibrate();
        },
        icon: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
              color: AppColors.getTextColor(context), borderRadius: BorderRadius.circular(6)),
          child: Text(context.isArabic ? 'جديد' : "New",
              style: Styles.mediumText(color:AppColors.getReversedTextColor(context))),
        ),
        label: Text(
          context.isArabic ? 'مشاهدة 2 اخرين' : "view 2 more",
          style: Styles.mediumText(
              fontWeight: FontWeight.w500,
              color: context.isDarkMode ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 10.h),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    title: Text(
                        context.isArabic
                            ? 'مخفي من البحث عن اصدقاء'
                            : "Hidden From Find Friends",
                        style: Styles.mediumText(
                            fontWeight: FontWeight.w500,
                            color: context.isDarkMode
                                ? Colors.white
                                : Colors.black)),
                    onTap: () => Navigator.of(context).pop(),
                    dense: false,
                    visualDensity:
                        const VisualDensity(horizontal: -2, vertical: -2),
                  ),
                  ListTile(
                      title: Text(
                          context.isArabic
                              ? 'طلبات الصداقة التي تم تجاهلها'
                              : "Friends Requests I've Ignored",
                          style: Styles.mediumText(
                              fontWeight: FontWeight.w500,
                              color: context.isDarkMode
                                  ? Colors.white
                                  : Colors.black)),
                      onTap: () => Navigator.of(context).pop(),
                      dense: false,
                      visualDensity:
                          const VisualDensity(horizontal: -2, vertical: -2)),
                  ListTile(
                      title: Text(
                          context.isArabic
                              ? 'الاصدقاء المضافين حديثاً'
                              : "Friends I've Recently Added",
                          style: Styles.mediumText(
                              fontWeight: FontWeight.w500,
                              color: context.isDarkMode
                                  ? Colors.white
                                  : Colors.black)),
                      onTap: () => Navigator.of(context).pop(),
                      dense: false,
                      visualDensity:
                          const VisualDensity(horizontal: -2, vertical: -2)),
                ],
              ),
            ),
            const Sizer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    LocaleKeys.done.localize,
                    style: TextStyle(
                      fontSize: 16,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}