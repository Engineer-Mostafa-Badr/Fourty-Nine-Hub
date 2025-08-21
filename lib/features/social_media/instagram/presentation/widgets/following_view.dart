import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../cubit/followers_cubit/follower_cubit.dart';
import '../cubit/followers_cubit/followers_state.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/widget/custom_circular_progress_indicator.dart';

import 'instagram_user_follow_widget.dart';
import '../../../../../helpers/manage_vibration.dart';

class FollowingView extends StatefulWidget {
  const FollowingView({super.key, required this.otherId});
  final String otherId;

  @override
  State<FollowingView> createState() => _FollowingViewState();
}

class _FollowingViewState extends State<FollowingView> {
  String search = '';

  late ScrollController _scrollController;
  late FollowCubit _cubit;
  bool isFirstSearchListenerCall = true;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<FollowCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
    _cubit.loadInitialDataFollowing(search, widget.otherId);

    _cubit.searchController.addListener(() {
      if (isFirstSearchListenerCall) {
        isFirstSearchListenerCall = false;
        return;
      }
      _cubit.loadInitialDataFollowing(
          _cubit.searchController.text, widget.otherId);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _cubit.fetchAllFollowing(_cubit.searchController.text, widget.otherId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
          child: Container(
            width: double.infinity,
            height: 70.h,
            decoration: BoxDecoration(
              color: AppColors.GREY_DARK_COLOR,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                style: BorderStyle.none,
              ),
            ),
            child: TextFormField(
              controller: _cubit.searchController,
              decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 5.h),
                  hintStyle: Styles.mediumText(fontSize: 65.sp),
                  hintText: LocaleKeys.search.localize,
                  prefixIcon: Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: 30.sp,
                  )),
            ),
          ),
        ),
        const Sizer(),
        BlocBuilder<FollowCubit, FollowState>(
          builder: (context, state) {
            if (state.isLoading && _cubit.following.isEmpty) {
              return const Center(child: CustomCircularProgressIndicator());
            }
            return Expanded(
              child: ListView.separated(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount:
                    _cubit.following.length + (_cubit.isLoadingMore ? 1 : 0),
                separatorBuilder: (context, index) => const Sizer(),
                itemBuilder: (context, index) {
                  if (index == _cubit.following.length) {
                    return const Center(
                        child: CustomCircularProgressIndicator());
                  }
                  final following = _cubit.following[index];
                  return GestureDetector(
                    onTap: () {
                      ManageVibration.vibrate();
                      context.push(Routes.INSTAGRAMPROFILE,
                          extra: following.userId);
                    },
                    child: InstagramUserFollowWidget(
                      inFollowers: true,
                      image: following.profilePictureUrl,
                      userName: following.username,
                      fullName: '${following.firstName} ${following.lastname}',
                      userId: following.userId,
                    ),

                    /*child: Row(
                      children: [
                        ImageFromInternet(
                          image: following.image,
                          height: 100.h,
                          width: 100.w,
                          isCircle: true,
                        ),
                        const Sizer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text:
                                      "${following.firstName} ${following.lastname}",
                                  style: Styles.headerText(
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                            Label(
                                text: following.email.split('@')[0],
                                style: Styles.mediumText(
                                  color: AppColors.GREY_NORMAL_COLOR,
                                )),
                          ],
                        ),
                      ],
                    ),*/
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }
}
