import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../cubit/social_posts_cubit.dart';
import 'image_from_internet.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/widget/custom_circular_progress_indicator.dart';

import '../../../../../../core/widget/custom_scaffold.dart';
import '../../../../../../helpers/manage_vibration.dart';

class FacebookSuggestedPeople extends StatefulWidget {
  const FacebookSuggestedPeople({super.key});

  @override
  State<FacebookSuggestedPeople> createState() =>
      _FacebookSuggestedPeopleState();
}

class _FacebookSuggestedPeopleState extends State<FacebookSuggestedPeople> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<SocialPostsCubit>().loadInitialSuggestPeople();

    context.read<SocialPostsCubit>().loadInitialSuggestPeople();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SocialPostsCubit>().fetchFacebookSuggestPeople();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: !context.isArabic ? 'People you may know' : 'أشخاص قد تعرفهم',
        ),
      ),
      body: BlocBuilder<SocialPostsCubit, SocialPostsState>(
          builder: (context, state) {
        var cubit = context.read<SocialPostsCubit>();
        return ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: cubit.facebookSuggestPeople.length +
              (cubit.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == cubit.facebookSuggestPeople.length) {
              return const Center(child: CustomCircularProgressIndicator());
            }

            final user = cubit.facebookSuggestPeople[index];
            return GestureDetector(
              onTap: () {
                ManageVibration.vibrate();
                context.pushNamed(Routes.OTHERSACCOUNT, extra: user.id);
              },
              child: Container(
                margin: EdgeInsetsDirectional.all(5.w),
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 15.w, vertical: 0.h),
                child: Row(
                  children: [
                    ImageFromInternet(
                      image: user.profilePicture,
                      height: 150.h,
                      width: 150.w,
                      isCircle: true,
                      defaultLogo: false,
                    ),
                    const Sizer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(
                          text: '${user.firstName}${user.lastName}',
                          style: Styles.headerText(fontSize: 30),
                        ),
                        if (user.mutualFriendsCount > 0) ...[
                          Sizer(
                            height: 5.h,
                          ),
                          Label(
                            text:
                                "${user.mutualFriendsCount} ${LocaleKeys.mutualFriends.localize}",
                            style: Styles.mediumText(fontSize: 26),
                          )
                        ],
                        Sizer(
                          height: (user.mutualFriendsCount > 0 ? 5.h : 30),
                        ),
                        Row(
                          children: [
                            AppButton(
                              height: 50.h,
                              width: user.addedSuccessfully == true
                                  ? MediaQuery.of(context).size.width * 0.6
                                  : null,
                              backColor: user.addedSuccessfully == true
                                  ? AppColors.getFillColor(context)
                                  : AppColors.getButtonPrimaryColor(context),
                              color: user.addedSuccessfully == true
                                  ? AppColors.getTextColor(context)
                                  : AppColors.getReversedTextColor(context),
                              padding: 15.w,
                              label: user.addedSuccessfully == true
                                  ? LocaleKeys.remove.localize
                                  : LocaleKeys.addFriend.localize,
                              onPressed: () async {
                                ManageVibration.vibrate();
                                if (user.addedSuccessfully == false) {
                                  bool result = await cubit.friendRequest(
                                      context: context, userId: user.id);
                                  if (result == true) {
                                    cubit.facebookSuggestPeople
                                        .firstWhere(
                                            (element) => element.id == user.id)
                                        .addedSuccessfully = true;
                                    setState(() {});
                                  }
                                } else {
                                  bool result = await cubit.removeFriendRequest(
                                      context: context, userId: user.id);
                                  if (result == true) {
                                    cubit.facebookSuggestPeople
                                        .firstWhere(
                                            (element) => element.id == user.id)
                                        .addedSuccessfully = false;
                                    setState(() {});
                                  }
                                }
                              },
                            ),
                            if (user.addedSuccessfully == false) ...[
                              const Sizer(),
                              AppButton(
                                height: 50.h,
                                padding: 15.w,
                                backColor: AppColors.getRedColor(context),
                                color: AppColors.getReversedTextColor(context),
                                label: LocaleKeys.remove.localize,
                                onPressed: () async {
                                  ManageVibration.vibrate();
                                  bool data = await cubit.removeSuggestUser(
                                      context: context, userId: user.id);
                                  if (data == true) {
                                    cubit.facebookSuggestPeople
                                        .removeWhere((e) => e.id == user.id);
                                    setState(() {});
                                  }
                                },
                              )
                            ],
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
