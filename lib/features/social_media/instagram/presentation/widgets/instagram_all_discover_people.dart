import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/suggest_user_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InstagramAllDiscoverPeople extends StatefulWidget {
  const InstagramAllDiscoverPeople({super.key});

  @override
  State<InstagramAllDiscoverPeople> createState() => _InstagramAllDiscoverPeopleState();
}

class _InstagramAllDiscoverPeopleState extends State<InstagramAllDiscoverPeople> {

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
    return Scaffold(
      appBar: BackAppBar(label: !context.isArabic
          ? 'Discover people'
          : 'أشخاص قد تعرفهم',),
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
        return state.status==StateStatus.loading?const Center(
          child: CircularProgressIndicator(),
        ):cubit.facebookSuggestPeople.isEmpty
            ? const SizedBox.shrink()
            : ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: cubit.facebookSuggestPeople.length +
              (cubit.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index ==
                cubit.facebookSuggestPeople.length) {
              return const Center(child: CircularProgressIndicator());
            }

            final user =
            cubit.facebookSuggestPeople[index];
            return GestureDetector(
              onTap: (){
                context.push(Routes.OTHERSACCOUNT,extra: user.id);
              },
              child: Container(
                margin: EdgeInsetsDirectional.all(5.w),
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 15.w, vertical: 0.h),
                child: Row(
                  children: [
                    ImageFromInternet(image: user.profilePicture,height: 100.h,width: 100.w,isCircle: true,defaultLogo: false,),
                    const Sizer(),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Label(text: '${user.firstName} ${user.lastName}',style: Styles.headerText(fontSize: 30),),
                                if(user.mutualFriendsCount>0)...[Sizer(height: 5.h,),Label(text: "${user.mutualFriendsCount} ${LocaleKeys.mutualFriends.localize}",style: Styles.mediumText(fontSize: 26),)],
                                Sizer(height: (user.mutualFriendsCount>0?5.h:30),),

                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const Sizer(),
                                AppButton(
                                  height: 50.h,
                                  padding: 15.w,
                                  backColor: user.followSuccessfully==false?AppColors.SECONDARY_COLOR:AppColors.GREY_DARK_COLOR,
                                  color: Colors.white,
                                  label: user.followSuccessfully==false?LocaleKeys.follow.localize:LocaleKeys.unFollow.localize, onPressed: () async {
                                  if(user.followSuccessfully==false){
                                          bool data =
                                              await cubit.followRequest(
                                                  context: context,
                                                  userId: user.id);
                                          if (data == true) {
                                            cubit.facebookSuggestPeople
                                                .firstWhere(
                                                    (e) => e.id == user.id).followSuccessfully=true;
                                            setState(() {});
                                          }
                                        }else{
                                    bool data =
                                    await cubit.unFollowRequest(
                                        context: context,
                                        userId: user.id);
                                    if (data == true) {
                                      cubit.facebookSuggestPeople
                                          .firstWhere(
                                              (e) => e.id == user.id).followSuccessfully=false;
                                      setState(() {});
                                    }
                                  }
                                      },),
                              const Sizer(),
                              InkWell(onTap: () async {
                                bool data = await cubit.removeSuggestUser(
                                    context:
                                    context,
                                    userId: user.id);
                                if (data ==
                                    true) {
                                  cubit.facebookSuggestPeople.removeWhere((e) =>
                                  e.id ==
                                      user.id);
                                  setState(
                                          () {});
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
