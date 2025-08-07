import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../core/widget/clickable_widget.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';

import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../helpers/manage_vibration.dart';

class FacebookPeopleView extends StatefulWidget {
  const FacebookPeopleView({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  State<FacebookPeopleView> createState() => _FacebookPeopleViewState();
}

class _FacebookPeopleViewState extends State<FacebookPeopleView>
    with TickerProviderStateMixin {
  late TabController tabController;
  List confirmedIndexes = [];
  List requestsIndexes = [];
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    widget.scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  bool _showSearch = false;
  bool _showPeople = true;
  bool _showBlocked = false;
  bool _showSuggestion = false;

  // دالة لإغلاق الكيبورد
  void _dismissKeyboard() {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        backgroundColor: AppColors.getFillColor(context),
        color: AppColors.getTextColor(context),
        child: ListView(
          controller: widget.scrollController,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 15.h),
          children: [
            Row(spacing: 5, children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
      ManageVibration.vibrate();
                    // إغلاق الكيبورد عند الانتقال لتاب People
                    _dismissKeyboard();

                    // if (context.read<UserCubit>().isLoggedIn) {
                    setState(() {
                      _showPeople = true;
                      if (_showPeople) {
                        _showSearch = false;
                        _showBlocked = false;
                        _showSuggestion = false;
                      } else if (!_showPeople) {
                        //context.read<RestaurantsCubit>().loadInitialRestaurantsData('');
                      }
                    });
                    // } else {
                    //   return pleaseLoginDialog(context);

                    // context.push(Routes.LOGIN);
                    // }
                  },
                  child: _tabButton(LocaleKeys.people.localize, _showPeople),
                ),
              ),
              Expanded(
                child: GestureDetector(
                    onTap: () {
      ManageVibration.vibrate();
                      // إغلاق الكيبورد عند الانتقال لتاب Blocked
                      _dismissKeyboard();

                      // if (context.read<UserCubit>().isLoggedIn) {
                      setState(() {
                        _showBlocked = true;
                        if (_showBlocked) {
                          _showSearch = false;
                          _showPeople = false;
                          _showSuggestion = false;
                        }
                      });
                      // } else {
                      //   return pleaseLoginDialog(context);
                      //
                      //   // context.push(Routes.LOGIN);
                      // }
                    },
                    child:
                        _tabButton(LocaleKeys.blocked.localize, _showBlocked)),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
      ManageVibration.vibrate();
                    // إغلاق الكيبورد عند الانتقال لتاب Suggestion
                    _dismissKeyboard();

                    // if (context.read<UserCubit>().isLoggedIn) {
                    setState(() {
                      _showSuggestion = true;
                      if (_showSuggestion) {
                        _showSearch = false;
                        _showPeople = false;
                        _showBlocked = false;
                      }
                    });
                    // } else {
                    //   return pleaseLoginDialog(context);
                    //
                    //   // context.push(Routes.LOGIN);
                    // }
                  },
                  child: _tabButton(
                      context.isArabic ? 'اقتراحات' : 'Suggestion',
                      _showSuggestion),
                ),
              ),
              GestureDetector(
                onTap: () {
      ManageVibration.vibrate();
                  // if (context.read<UserCubit>().isLoggedIn) {
                  setState(() {
                    _showSearch = !_showSearch;
                    if (_showSearch) {
                      _showPeople = false;
                      _showBlocked = false;
                      _showSuggestion = false;
                      // التركيز على حقل البحث عند فتحه
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        focusNode.requestFocus();
                      });
                    } else {
                      // إغلاق الكيبورد عند إغلاق البحث
                      _dismissKeyboard();
                    }
                  });
                  // } else {
                  //   return pleaseLoginDialog(context);

                  // context.push(Routes.LOGIN);
                  //}
                },
                child: Icon(Icons.search, color: AppColors.Facebook_Red_DARK),
              ),
            ]),
            Divider(
              color: AppColors.getFindFillColor(context),
            ),
            if (_showPeople) friendTile(),
            if (_showBlocked) blockedFriendTile(),
            if (_showSuggestion) suggestionTile(),
            if (_showSearch) searchTile(focusNode),
          ],
        ),
        onRefresh: () async {
          // إغلاق الكيبورد عند السحب للتحديث
          _dismissKeyboard();
        });
  }

  Widget _tabButton(String title, bool category) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: category
              ? AppColors.getFacebookFillRedColor(context)
              : Colors.transparent),
      child: Label(
        text: title,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: category
                ? AppColors.Facebook_Red_DARK
                : context.isDarkMode
                    ? Colors.white.withOpacity(.3)
                    : Colors.black.withOpacity(.3)),
      ),
    );
  }

  Widget friendTile() {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: context.isArabic ? 'طلبات الصداقة' : 'Friend Requests',
              style: Styles.headerText(
                  fontSize: 32, color: AppColors.getTextColor(context)),
            ),
            TextSpan(
              text: ' ${40}',
              style: Styles.headerText(
                color: AppColors.Facebook_Red_DARK,
                fontSize: 32,
              ),
            ),
          ])),
          ClickableWidget(
            onTap: () {

      ManageVibration.vibrate();
            },
            child: Label(
              text: context.isArabic ? 'مشاهدة المزيد' : 'See More',
              style: Styles.mediumText(
                decoration: TextDecoration.underline,
              ),
            ),
          )
        ]),
        const Sizer(),
        SizedBox(
            width: double.infinity,
            child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: SizedBox(
                        width: 160.w,
                        child: CircleAvatar(
                          radius: 180.sp,
                          child: CircleAvatar(
                              radius: 90,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  AssetImage(Assets.personalImage)),
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label(
                            text: 'Ahmed Ali',
                            style: Styles.headerText(
                              fontSize: 40,
                            ),
                          ),
                          if (!(confirmedIndexes.contains(index)))
                            Label(
                              text:
                                  "${4} ${LocaleKeys.mutualFriends.localize} . ${3} ${context.isArabic ? 'يوم' : 'd'}",
                              style: Styles.mediumText(
                                  color: context.isDarkMode
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.black.withOpacity(0.7)),
                            )
                          else
                            Label(
                              text: context.isArabic
                                  ? 'لقد اصبحتم اصدقاء بالفعل'
                                  : 'You are now friends',
                              style: Styles.mediumText(
                                  color: context.isDarkMode
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.black.withOpacity(0.7)),
                            ),
                          const Sizer(),
                          if (!(confirmedIndexes.contains(index)))
                            Row(
                              children: [
                                Expanded(
                                  child: ClickableWidget(
                                    onTap: () {
      ManageVibration.vibrate();
                                      confirmedIndexes.add(index);
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 8.h),
                                      decoration: BoxDecoration(
                                        color: context.isDarkMode
                                            ? Colors.white
                                            : AppColors.PRIMARY_COLOR,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Label(
                                          text: LocaleKeys.confirm.localize,
                                          style: Styles.mediumText(
                                              color: AppColors
                                                  .getReversedTextColor(
                                                      context)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Sizer(),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 8.h),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.Facebook_Red_DARK),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Label(
                                        text: LocaleKeys.remove.localize,
                                        style: Styles.mediumText(
                                            color: AppColors.Facebook_Red_DARK),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                separatorBuilder: (context, index) => const Sizer(),
                itemCount: 10)),
      ],
    );
  }

  Widget suggestionTile() {
    return Column(
      children: [
        SizedBox(
            width: double.infinity,
            child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: SizedBox(
                        width: 160.w,
                        child: CircleAvatar(
                          radius: 180.sp,
                          child: CircleAvatar(
                              radius: 90,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  AssetImage(Assets.personalImage)),
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label(
                            text: 'Ahmed Ali',
                            style: Styles.headerText(
                              fontSize: 40,
                            ),
                          ),
                          if (!(requestsIndexes.contains(index)))
                            Label(
                              text:
                                  "${4} ${LocaleKeys.mutualFriends.localize} . ${3} ${context.isArabic ? 'يوم' : 'd'}",
                              style: Styles.mediumText(
                                  color: context.isDarkMode
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.black.withOpacity(0.7)),
                            )
                          else
                            Label(
                              text: context.isArabic
                                  ? 'تم ارسال طلب الصداقة'
                                  : 'Friend Request sent',
                              style: Styles.mediumText(
                                  color: context.isDarkMode
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.black.withOpacity(0.7)),
                            ),
                          const Sizer(),
                          if (!(requestsIndexes.contains(index)))
                            Row(
                              children: [
                                Expanded(
                                  child: ClickableWidget(
                                    onTap: () {
      ManageVibration.vibrate();
                                      requestsIndexes.add(index);
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 8.h),
                                      decoration: BoxDecoration(
                                        color: context.isDarkMode
                                            ? Colors.white
                                            : AppColors.PRIMARY_COLOR,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Label(
                                          text: LocaleKeys.addFriend.localize,
                                          style: Styles.mediumText(
                                              color: AppColors
                                                  .getReversedTextColor(
                                                      context)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Sizer(),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 8.h),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.Facebook_Red_DARK),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Label(
                                        text: LocaleKeys.remove.localize,
                                        style: Styles.mediumText(
                                            color: AppColors.Facebook_Red_DARK),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                separatorBuilder: (context, index) => const Sizer(),
                itemCount: 10)),
      ],
    );
  }

  Widget blockedFriendTile() {
    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(
                width: 160.w,
                child: CircleAvatar(
                  radius: 180.sp,
                  child: CircleAvatar(
                      radius: 90,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(Assets.personalImage)),
                ),
              ),
              title: Label(
                text: 'Ahmed Ali',
                style: Styles.headerText(
                  fontSize: 40,
                ),
              ),
              trailing: ClickableWidget(
                  onTap: () {

      ManageVibration.vibrate();
                  },
                  child: Icon(
                    Icons.close,
                    color: AppColors.Facebook_Red_DARK,
                  )),
            ),
        separatorBuilder: (context, index) => const Sizer(),
        itemCount: 10);
  }

  Widget searchTile(FocusNode focusNode) {
    return Column(children: [
      TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        style: Styles.mediumText(
            fontSize: 32,
            color: context.isDarkMode ? AppColors.whiteColor : Colors.black),
        decoration: InputDecoration(
            contentPadding: const EdgeInsetsDirectional.only(start: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
            hintStyle: Styles.mediumText(
                fontSize: 32,
                color:
                    context.isDarkMode ? AppColors.whiteColor : Colors.black),
            hintText: LocaleKeys.search.localize,
            prefixIcon: Icon(
              Icons.search,
            )),
        focusNode: focusNode,
      ),
      const Sizer(),
      SizedBox(
          width: double.infinity,
          child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: SizedBox(
                      width: 160.w,
                      child: CircleAvatar(
                        radius: 180.sp,
                        child: CircleAvatar(
                            radius: 90,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(Assets.personalImage)),
                      ),
                    ),
                    title: Label(
                      text: 'Ahmed Ali',
                      style: Styles.headerText(
                        fontSize: 40,
                      ),
                    ),
                    trailing: ClickableWidget(
                        onTap: () {

      ManageVibration.vibrate();
                        },
                        child: Icon(
                          Icons.close,
                          color: AppColors.Facebook_Red_DARK,
                        )),
                  ),
              separatorBuilder: (context, index) => const Sizer(),
              itemCount: 10))
    ]);
  }
}