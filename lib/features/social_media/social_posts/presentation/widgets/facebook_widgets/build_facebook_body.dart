import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/face_book_view.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/facebook_other_profile.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/facebook_people_view.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/facebook_profile.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../stories/presentation/cubit/stories_cubit.dart';

class FacebookBody extends StatefulWidget {
  const FacebookBody({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<FacebookBody> createState() => _FacebookBodyState();
}

class _FacebookBodyState extends State<FacebookBody>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      // إغلاق الكيبورد عند تغيير التاب
      FocusScope.of(context).unfocus();
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    // تنظيف TabController
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SocialPostsCubit>(
          create: (_) => serviceLocator()..loadData(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<StoryCubit>()
            ..fetchStories()
            ..getMutedStories(),
          // create: (context) => serviceLocator<StoryCubit>(),
        ),
        BlocProvider(
          create: (_) => PeopleTabCubit(),
        ),
      ],
      child: Column(
        children: [
          TabBar(
              controller: tabController,
              padding: EdgeInsets.zero,
              labelPadding: EdgeInsets.zero,
              onTap: (i){
                if(i==0){
                  context.read<SocialPostsCubit>().loadData();
                }
              },
              tabs: [
                Tab(
                  height: 44,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.home,
                          width: 30.h,
                          height: 30.h,
                          color: tabController.index == 0
                              ? AppColors.getButtonPrimaryWhiteColor(context)
                              : AppColors.grey,
                        ),
                        const Sizer(),
                        Text(LocaleKeys.home.localize,
                            style: TextStyle(
                                color: tabController.index == 0
                                    ? AppColors.getTextColor(context)
                                    : AppColors.grey,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700))
                      ]),
                  // icon: SvgPicture.asset(Assets.home,width: 18,height: 18,),
                  // text: LocaleKeys.home.localize,
                ),
                Tab(
                  height: 44,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.people,
                          width: 30.h,
                          height: 30.h,
                          color: tabController.index == 1
                              ? AppColors.getButtonPrimaryWhiteColor(context)
                              : AppColors.grey,
                        ),
                        const Sizer(),
                        Text(LocaleKeys.people.localize,
                            style: TextStyle(
                                color: tabController.index == 1
                                    ? AppColors.getTextColor(context)
                                    : AppColors.grey,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700))
                      ]),
                  // icon: SvgPicture.asset(Assets.people,width: 18,height: 18,),
                  // text: LocaleKeys.people.localize,
                ),
                Tab(
                  height: 44,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.profile,
                          width: 30.h,
                          height: 30.h,
                          color: tabController.index == 2
                              ? AppColors.getButtonPrimaryWhiteColor(context)
                              : AppColors.grey,
                        ),
                        const Sizer(),
                        Label(
                          text: LocaleKeys.profile.localize,
                          style: TextStyle(
                              color: tabController.index == 2
                                  ? AppColors.getTextColor(context)
                                  : AppColors.grey,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                        )
                      ]),
                  // text: LocaleKeys.profile.localize,
                ),
              ]),
          Expanded(
              child: TabBarView(controller: tabController, children: [
            FaceBookView(scrollController: widget.scrollController),
            FacebookPeopleView(scrollController: widget.scrollController),
            BlocBuilder<PeopleTabCubit, ProfileTabState>(
              builder: (context, state) {
                if (state is OtherProfileState) {
                  return FacebookOtherProfile(
                      scrollController: widget.scrollController);
                } else {
                  return FacebookProfile(
                    scrollController: widget.scrollController,
                  );
                }
              },
            ),
          ]))
        ],
      ),
      // child: FaceBookView(),
    );
  }
}
