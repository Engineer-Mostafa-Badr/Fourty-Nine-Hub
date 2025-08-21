import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/enums/base_status_enum.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../cubit/instagram_cubit.dart';
import '../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/widget/custom_circular_progress_indicator.dart';

import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../helpers/manage_vibration.dart';

class InstagramAllDiscoverPeople extends StatefulWidget {
  const InstagramAllDiscoverPeople({super.key});

  @override
  State<InstagramAllDiscoverPeople> createState() =>
      _InstagramAllDiscoverPeopleState();
}

class _InstagramAllDiscoverPeopleState
    extends State<InstagramAllDiscoverPeople> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<InstagramCubit>().loadInitialSuggestPeople();

    context.read<InstagramCubit>().loadInitialSuggestPeople();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<InstagramCubit>().fetchFacebookSuggestPeople();
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
          label: !context.isArabic ? 'Discover people' : 'أشخاص قد تعرفهم',
        ),
      ),
      body: BlocConsumer<InstagramCubit, InstagramState>(
          listener: (context, state) {
        if (state.status == StateStatus.error) {
          showErrorMessage(
            context,
            getFailureMessage(
              state.failure ?? UnknownFailure(''),
              context,
            ),
          );
        }
      }, builder: (context, state) {
        final cubit = context.read<InstagramCubit>();
        return state.status == StateStatus.loading
            ? const Center(
                child: CustomCircularProgressIndicator(),
              )
            : cubit.facebookSuggestPeople.isEmpty
                ? const SizedBox.shrink()
                : ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: cubit.facebookSuggestPeople.length +
                        (cubit.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == cubit.facebookSuggestPeople.length) {
                        return const Center(
                            child: CustomCircularProgressIndicator());
                      }

                      final user = cubit.facebookSuggestPeople[index];
                      return GestureDetector(
                        onTap: () {
                          ManageVibration.vibrate();
                          context.push(Routes.OTHERSACCOUNT, extra: user.id);
                        },
                        child: Container(
                          margin: EdgeInsetsDirectional.all(5.w),
                          padding: EdgeInsetsDirectional.symmetric(
                              horizontal: 15.w, vertical: 0.h),
                          child: Row(
                            children: [
                              ImageFromInternet(
                                image: user.profilePicture,
                                height: 100.h,
                                width: 100.w,
                                isCircle: true,
                                defaultLogo: false,
                              ),
                              const Sizer(),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Label(
                                            text:
                                                '${user.firstName} ${user.lastName}',
                                            style:
                                                Styles.headerText(fontSize: 30),
                                          ),
                                          if (user.mutualFriendsCount > 0) ...[
                                            Sizer(
                                              height: 5.h,
                                            ),
                                            Label(
                                              text:
                                                  "${user.mutualFriendsCount} ${LocaleKeys.mutualFriends.localize}",
                                              style: Styles.mediumText(
                                                  fontSize: 26),
                                            )
                                          ],
                                          Sizer(
                                            height: (user.mutualFriendsCount > 0
                                                ? 5.h
                                                : 30),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Sizer(),
                                        AppButton(
                                          height: 50.h,
                                          padding: 15.w,
                                          backColor:
                                              user.followSuccessfully == false
                                                  ? AppColors.SECONDARY_COLOR
                                                  : AppColors.GREY_DARK_COLOR,
                                          color: Colors.white,
                                          label: user.followSuccessfully ==
                                                  false
                                              ? LocaleKeys.follow.localize
                                              : LocaleKeys.unFollow.localize,
                                          onPressed: () async {
                                            ManageVibration.vibrate();
                                            if (user.followSuccessfully ==
                                                false) {
                                              bool data =
                                                  await cubit.followRequest(
                                                      context: context,
                                                      userId: user.id);
                                              if (data == true) {
                                                cubit.facebookSuggestPeople
                                                    .firstWhere(
                                                        (e) => e.id == user.id)
                                                    .followSuccessfully = true;
                                                setState(() {});
                                              }
                                            } else {
                                              bool data =
                                                  await cubit.unFollowRequest(
                                                      context: context,
                                                      userId: user.id);
                                              if (data == true) {
                                                cubit.facebookSuggestPeople
                                                    .firstWhere(
                                                        (e) => e.id == user.id)
                                                    .followSuccessfully = false;
                                                setState(() {});
                                              }
                                            }
                                          },
                                        ),
                                        const Sizer(),
                                        InkWell(
                                            onTap: () async {
                                              ManageVibration.vibrate();
                                              bool data =
                                                  await cubit.removeSuggestUser(
                                                      context: context,
                                                      userId: user.id);
                                              if (data == true) {
                                                cubit.facebookSuggestPeople
                                                    .removeWhere(
                                                        (e) => e.id == user.id);
                                                setState(() {});
                                              }
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(8.w),
                                              child: const Icon(Icons.close),
                                            ))
                                      ],
                                    )
                                  ],
                                ),
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
