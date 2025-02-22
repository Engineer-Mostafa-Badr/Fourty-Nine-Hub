import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class BuildFacebookSuggestPeople extends StatefulWidget {
  const BuildFacebookSuggestPeople({super.key,});

  @override
  State<BuildFacebookSuggestPeople> createState() => _BuildFacebookSuggestPeopleState();
}

class _BuildFacebookSuggestPeopleState extends State<BuildFacebookSuggestPeople> {
  TextEditingController messageController = TextEditingController();
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SocialPostsCubit>().getSuggestedFriends();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocialPostsCubit, SocialPostsState>(
      builder: (context,state) {
        var cubit = context.read<SocialPostsCubit>();
        return Container(
          width: double.infinity,
          // margin: const EdgeInsets.only(bottom: 16),
          decoration: const BoxDecoration(
            color: AppColors.BG_GRAY_COLOR,
            // border: Border(bottom: BorderSide(color: AppColors.BG_GRAY_COLOR,width: 6)),
          ),
          padding: const EdgeInsetsDirectional.only(start: 10,bottom: 16,top: 12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(end:8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SvgPicture.asset(Assets.groupIcon,height: 18,width: 24,),
                          // const Icon(
                          //   Icons.group_rounded,
                          //   size: 24,
                          //   color: AppColors.black,
                          // ),
                          const Sizer(),
                          Text(
                            context.locale == Locales.english
                                ? 'People you may know'
                                : 'أشخاص قد تعرفهم',
                            style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.black,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ],
                      ),
                    ),
                    ClickableWidget(
                      onTap: (){
                            context.push(Routes.FacebookSuggestPeople);
                      },
                      child: Text(
                        context.locale == Locales.english
                            ? 'See More'
                            : 'عرض الكل',
                        style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 244,
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        controller: _scrollController,
                        shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context,index)=>ClickableWidget(
                        onTap: () {
                          context.push(Routes.OTHERSACCOUNT,
                              extra: cubit.suggestedFriends[index]
                                  .id);
                        },
                        child:Container(
                          width: 167,
                          // padding: const EdgeInsets.only(bottom: 10,left: 8,right: 8),
                          margin: const EdgeInsetsDirectional.only(end: 10,start: 1,bottom: 2,top: 1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                            // border: Border.all(color: AppColors.DIVIDER_GRAY_COLOR),
                            color: Colors.white, // White background for the entire container
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Half: Profile Image
                              Expanded(
                                flex: 3, // Takes half of the container height
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12), // Rounded top corners
                                  ),
                                  child: ImageFromInternet(
                                    image: cubit.suggestedFriends[index].profilePicture,
                                    fit: BoxFit.fill, // Ensures the image covers the area
                                  ),
                                ),
                              ),
                              // Bottom Half: White Container with Details and Buttons
                              Expanded(
                                flex: 2, // Takes the other half of the container height
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 10,left: 8,right: 8,top: 8),
                                  // padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                                  decoration: const BoxDecoration(
                                    color: Colors.white, // White background
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(12), // Rounded bottom corners
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      // User Name
                                      Text(
                                        "${cubit.suggestedFriends[index].firstName} ${cubit.suggestedFriends[index].lastName}",
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: AppColors.PRIMARY_COLOR
                                        ),
                                      ),
                                      // const SizedBox(height: 4), // Spacing
                                      // Mutual Friends Count
                                      Text(
                                        "${cubit.suggestedFriends[index].mutualFriendsCount} ${LocaleKeys.mutualFriend.localize}",
                                        maxLines: 1,
                                        style:  TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: AppColors.black.withOpacity(0.5)
                                        ),
                                      ),
                                      // const Spacer(),
                                      // Action Buttons
                                      const SizedBox(height: 8,),
                                      Row(
                                        children: [
                                          // Add Friend / Follow / Send Greet Message Button
                                          Expanded(
                                            flex: 2,
                                            child: ClickableWidget(
                                              onTap: () async {
                                                if (cubit.suggestedFriends[index].addedSuccessfully == false) {
                                                  var response = await context.read<SocialPostsCubit>().friendRequest(
                                                    context: context,
                                                    userId: cubit.suggestedFriends[index].id,
                                                  );
                                                  if (response == true) {
                                                    cubit.suggestedFriends[index].addedSuccessfully = true;
                                                    setState(() {});
                                                  }
                                                } else if (cubit.suggestedFriends[index].addedSuccessfully == true &&
                                                    cubit.suggestedFriends[index].followSuccessfully == false) {
                                                  var response = await context.read<SocialPostsCubit>().followRequest(
                                                    context: context,
                                                    userId: cubit.suggestedFriends[index].id,
                                                  );
                                                  if (response == true) {
                                                    cubit.suggestedFriends[index].followSuccessfully = true;
                                                    setState(() {});
                                                  }
                                                } else if (cubit.suggestedFriends[index].addedSuccessfully == true &&
                                                    cubit.suggestedFriends[index].followSuccessfully == true) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        backgroundColor: AppColors.BACKGROUND_COLOR,
                                                        surfaceTintColor: AppColors.BACKGROUND_COLOR,
                                                        title: Label(
                                                          text: LocaleKeys.enterGreetMessage.localize,
                                                          style: Styles.headerText(),
                                                        ),
                                                        content: TextField(
                                                          controller: messageController,
                                                          maxLines: null,
                                                          maxLength: 150,
                                                          decoration: InputDecoration(
                                                            hintText: LocaleKeys.greetMessage.localize,
                                                            fillColor: Colors.white,
                                                            hintStyle: Styles.mediumText(
                                                              color: AppColors.DARK_GRAY_COLOR,
                                                            ),
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Container(
                                                              width: 100,
                                                              padding: const EdgeInsets.all(2),
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(4),
                                                                border: Border.all(
                                                                  color: AppColors.PRIMARY_COLOR,
                                                                ),
                                                              ),
                                                              alignment: Alignment.center,
                                                              child: Label(
                                                                text: LocaleKeys.cancel.localize,
                                                                style: Styles.headerText(
                                                                  color: Colors.red,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          ClickableWidget(
                                                            onTap: () async {
                                                              if (messageController.text.isNotEmpty) {
                                                                bool result = await cubit.sendGreetMessage(
                                                                  context: context,
                                                                  userId: cubit
                                                                      .suggestedFriends[index]
                                                                      .id,
                                                                  message: messageController.text,
                                                                );
                                                                if(result==true){
                                                                  cubit
                                                                      .suggestedFriends.removeWhere((element) =>
                                                                  element.id ==
                                                                      cubit
                                                                          .suggestedFriends[index]
                                                                          .id);
                                                                  showSuccessMessage(
                                                                    context,
                                                                    LocaleKeys.messageSentSuccessfully
                                                                        .localize,
                                                                  );
                                                                }
                                                                Navigator.of(context).pop();
                                                                setState(() {});
                                                              }
                                                            },
                                                            child: Container(
                                                              width: 100,
                                                              padding: const EdgeInsets.all(2),
                                                              decoration: BoxDecoration(
                                                                color: AppColors.PRIMARY_COLOR,
                                                                borderRadius: BorderRadius.circular(4),
                                                              ),
                                                              alignment: Alignment.center,
                                                              child: Label(
                                                                text: LocaleKeys.send.localize,
                                                                style: Styles.headerText(
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              child: Container(
                                                height: 31,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  border: cubit.suggestedFriends[index].followSuccessfully == true
                                                      ? Border.all(color: AppColors.PRIMARY_COLOR_DARK)
                                                      : null,
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: cubit.suggestedFriends[index].addedSuccessfully == false
                                                      ? AppColors.PRIMARY_COLOR
                                                      : cubit.suggestedFriends[index].addedSuccessfully == true &&
                                                      cubit.suggestedFriends[index].followSuccessfully == false
                                                      ? AppColors.PRIMARY_COLOR_DARK
                                                      : Colors.white,
                                                ),
                                                child: Text(
                                                  cubit.suggestedFriends[index].addedSuccessfully == false
                                                      ? LocaleKeys.addFriend.localize
                                                      : cubit.suggestedFriends[index].addedSuccessfully == true &&
                                                      cubit.suggestedFriends[index].followSuccessfully == false
                                                      ? LocaleKeys.follow.localize
                                                      : LocaleKeys.sendGreetMessage.localize,
                                                  style: TextStyle(
                                                    color: cubit.suggestedFriends[index].followSuccessfully == true
                                                        ? AppColors.PRIMARY_COLOR_DARK
                                                        : Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4), // Spacing
                                          // Remove Button
                                          if (cubit.suggestedFriends[index].addedSuccessfully == false)
                                            Expanded(child:    ClickableWidget(
                                              onTap: () async {
                                                bool data = await context.read<SocialPostsCubit>().removeSuggestUser(
                                                  context: context,
                                                  userId: cubit.suggestedFriends[index].id,
                                                );
                                                if (data == true) {
                                                  cubit.suggestedFriends
                                                      .removeWhere((e) =>
                                                  e.id ==
                                                      cubit.suggestedFriends[index].id);
                                                  setState(() {});
                                                }
                                              },
                                              child: Container(
                                                height: 31,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: AppColors.whiteColor,
                                                    border: Border.all(
                                                        color: AppColors.PRIMARY_COLOR_DARK
                                                    )
                                                ),
                                                child: Text(
                                                  LocaleKeys.deleteRequest.localize,
                                                  style: const TextStyle(
                                                    color: AppColors.PRIMARY_COLOR_DARK,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ), separatorBuilder: (context, index)=>const SizedBox(width: 8,), itemCount: cubit.suggestedFriends.length),
                    ),
                    if(cubit.isLoadingPeopleMore==true) const Center(child: CircularProgressIndicator(),),
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }
}
