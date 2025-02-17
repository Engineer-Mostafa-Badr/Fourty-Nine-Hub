import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/face_book_view.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../stories/presentation/cubit/stories_cubit.dart';

class FacebookBody extends StatefulWidget {
  const FacebookBody({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<FacebookBody> createState() => _FacebookBodyState();
}

class _FacebookBodyState extends State<FacebookBody> with TickerProviderStateMixin{
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
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
      ],
      child: Column(
        children: [
          TabBar(
              controller: tabController,
              tabs: [
                Tab(
                  height: 44,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        SvgPicture.asset(Assets.home,width: 18,height: 18,),
                        SizedBox(width: 10),
                        Text(LocaleKeys.home.localize,style:TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight:FontWeight.w700
                        ))
                      ]
                  ),
                  // icon: SvgPicture.asset(Assets.home,width: 18,height: 18,),
                  // text: LocaleKeys.home.localize,
                ),
                Tab(
                  height: 44,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        SvgPicture.asset(Assets.people,width: 18,height: 18,),
                        SizedBox(width: 10),
                        Text(LocaleKeys.people.localize,style:TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight:FontWeight.w700
                        ))
                      ]
                  ),
                  // icon: SvgPicture.asset(Assets.people,width: 18,height: 18,),
                  // text: LocaleKeys.people.localize,
                ),
                Tab(
                  height: 44,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        SvgPicture.asset(Assets.profile,width: 18,height: 18,),
                        SizedBox(width: 10),
                        Text(LocaleKeys.profile.localize,style:TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight:FontWeight.w700
                        ))
                      ]
                  ),
                  // text: LocaleKeys.profile.localize,
                ),
              ]),
          Expanded(child: TabBarView(
              controller: tabController,
              children: [
                FaceBookView(),
                Container(),
                Container(),
              ]))
        ],
      ),
      // child: FaceBookView(),
    );
  }
}