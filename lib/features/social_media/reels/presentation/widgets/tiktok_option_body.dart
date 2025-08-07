import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extensions/context_extension.dart';
import 'tik_tok_option_app_bar.dart';
import '../../../../../res/style/app_colors.dart';
import 'components/tap/users_content_widget.dart';
import 'hashtags_content_widget.dart';
import 'live_content_widget.dart';
import 'photo_content_widget.dart';
import 'places_content_widget.dart';
import 'sounds_content_widget.dart';
import 'videos_content_widget.dart';

class TiktokOptionBody extends StatelessWidget {
  const TiktokOptionBody({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            const TikTokOptionAppBar(),
            TabBar(
              physics: const BouncingScrollPhysics(),
              dividerColor: Colors.grey,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  color:
                      context.isDarkMode ? AppColors.whiteColor : Colors.black,
                  width: 2.5,
                ),
                insets: EdgeInsets.symmetric(horizontal: -30.w),
              ),
              isScrollable: true,
              indicatorColor: context.isDarkMode ? Colors.white : Colors.black,
              labelColor: context.isDarkMode ? Colors.white : Colors.black,
              unselectedLabelColor: Color(0xff7C7C7C),
              labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              unselectedLabelStyle:
                  TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              tabAlignment: TabAlignment.start,
              indicatorPadding: EdgeInsets.zero,
              labelPadding: EdgeInsets.symmetric(horizontal: 10),
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(text: (context.isArabic ? 'القمة' : 'Top')),
                Tab(text: context.isArabic ? 'مقاطع الفيديو' : 'Videos'),
                Tab(text: context.isArabic ? 'المستخدمون' : 'Users'),
                Tab(text: context.isArabic ? 'الصور' : 'Photos'),
                Tab(text: context.isArabic ? 'الأصوات' : 'Sounds '),
                Tab(text: context.isArabic ? 'علامات التصنيف' : 'Hashtags'),
                Tab(text: context.isArabic ? 'مباشر' : 'LIVE  '),
                Tab(text: context.isArabic ? 'الأماكن' : 'Places '),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  VideosContentWidget(),
                  VideosContentWidget(),
                  UsersContentWidget(),
                  PhotoContentWidget(),
                  SoundsContentWidget(),
                  HashtagsContentWidget(),
                  LiveContentWidget(),
                  PlacesContentWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
