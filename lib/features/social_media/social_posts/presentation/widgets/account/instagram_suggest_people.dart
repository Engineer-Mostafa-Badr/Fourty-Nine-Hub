import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/suggest_user_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InstagramProfileSuggestPeople extends StatefulWidget {
  const InstagramProfileSuggestPeople({super.key});

  @override
  State<InstagramProfileSuggestPeople> createState() => _InstagramProfileSuggestPeopleState();
}

class _InstagramProfileSuggestPeopleState extends State<InstagramProfileSuggestPeople> {
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialPostsCubit, SocialPostsState>(listener: (context, state) {
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
      final controller = context.read<SocialPostsCubit>();
      return state.suggestedFriends == null || controller.suggestUserPagingController.itemList == []
          ? const SizedBox.shrink()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(
                        text: LocaleKeys.discoverPeople.localize,
                        style: Styles.headerText(),
                      ),
                      Container(
                        alignment: AlignmentDirectional.topStart,
                        height: 240.h,
                        child: PagedListView<int, SuggestUserEntity>(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5),
                          pagingController: controller.suggestUserPagingController,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          builderDelegate: PagedChildBuilderDelegate<SuggestUserEntity>(
                              noItemsFoundIndicatorBuilder: (context) {
                                print(controller.suggestUserPagingController.itemList?.length);
                                return Padding(
                                    padding: const EdgeInsets.only(top: 200),
                                    child: Center(
                                      child: Label(
                                        text: LocaleKeys.noFriendsSuggested.localize,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ));
                              },
                              itemBuilder: (context, item, index) {
                                SuggestUserEntity item = controller.suggestUserPagingController.itemList![index];
                                return InkWell(
                                  onTap: () {
                                    context.push(Routes.OTHERSACCOUNT,
                                        extra: controller.suggestUserPagingController.itemList?[index].id);
                                  },
                                  child: Container(
                                    width: 260.w,
                                    padding: const EdgeInsets.only(bottom: 10),
                                    margin: const EdgeInsetsDirectional.only(end: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: AppColors.DARK_GRAY_COLOR),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: AlignmentDirectional.topEnd,
                                          child: InkWell(
                                            onTap: () async {
                                              bool data =
                                                  await controller.removeSuggestUser(context: context, userId: item.id);
                                              if (data == true) {
                                                controller.suggestUserPagingController.itemList?.removeWhere((e) =>
                                                    e.id == controller.suggestUserPagingController.itemList?[index].id);
                                                setState(() {});
                                              }
                                            },
                                            child: const Icon(Icons.close),
                                          ),
                                        ),
                                        Expanded(
                                          child: ImageFromInternet(
                                            image: item.profilePicture,
                                            // height: 220.h,
                                            width: 120.w,
                                            height: 120.h,
                                            isCircle: true,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Label(
                                                text: "${item.firstName} ${item.lastName}",
                                                maxLines: 1,
                                                style: Styles.mediumText(),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              item.sendWelcomeSuccessfully == true
                                                  ? Label(
                                                      text: LocaleKeys.messageSentSuccessfully.localize,
                                                      style: Styles.mediumText(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14),
                                                    )
                                                  : Row(
                                                      children: [
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () async {
                                                              if (item.followSuccessfully == false) {
                                                                var response = await controller.followRequest(
                                                                    context: context, userId: item.id);
                                                                if (response == true) {
                                                                  item.followSuccessfully = true;
                                                                  setState(() {});
                                                                }
                                                              } else if (item.followSuccessfully == true) {
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    return AlertDialog(
                                                                      backgroundColor: AppColors.BACKGROUND_COLOR,
                                                                      surfaceTintColor: AppColors.BACKGROUND_COLOR,
                                                                      shape: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(4)),
                                                                      title: Label(
                                                                        text: LocaleKeys.enterGreetMessage.localize,
                                                                        style: Styles.headerText(),
                                                                      ),
                                                                      content: TextField(
                                                                        // focusNode: focusNode,
                                                                        maxLines: null,
                                                                        maxLength: 150,
                                                                        onChanged: (c) {},
                                                                        controller: messageController,
                                                                        decoration: InputDecoration(
                                                                            hintText: LocaleKeys.greetMessage.localize,
                                                                            fillColor: Colors.white,
                                                                            border: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(4)),
                                                                            hintStyle: Styles.mediumText(
                                                                                color: AppColors.DARK_GRAY_COLOR)),
                                                                      ),
                                                                      actions: <Widget>[
                                                                        TextButton(
                                                                          onPressed: () {
                                                                            Navigator.of(context)
                                                                                .pop(); // Close the dialog
                                                                          },
                                                                          child: Label(
                                                                            text: LocaleKeys.cancel.localize,
                                                                            style: Styles.headerText(),
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap: () async {
                                                                            if (messageController.text.isNotEmpty) {
                                                                              await controller.sendGreetMessage(
                                                                                  context: context,
                                                                                  userId: controller
                                                                                      .suggestUserPagingController
                                                                                      .itemList![index]
                                                                                      .id,
                                                                                  message: messageController.text);
                                                                              controller
                                                                                  .suggestUserPagingController.itemList
                                                                                  ?.removeWhere((element) =>
                                                                                      element.id ==
                                                                                      controller
                                                                                          .suggestUserPagingController
                                                                                          .itemList?[index]
                                                                                          .id);
                                                                              showSuccessMessage(
                                                                                  context,
                                                                                  LocaleKeys.messageSentSuccessfully
                                                                                      .localize);
                                                                              Navigator.of(context).pop();
                                                                              setState(() {});
                                                                            }
                                                                          },
                                                                          child: Container(
                                                                            width: 100,
                                                                            padding: const EdgeInsets.all(5),
                                                                            decoration: BoxDecoration(
                                                                                color: AppColors.PRIMARY_COLOR,
                                                                                borderRadius:
                                                                                    BorderRadius.circular(15)),
                                                                            alignment: Alignment.center,
                                                                            child: Label(
                                                                              text: LocaleKeys.send.localize,
                                                                              style: Styles.headerText(
                                                                                  color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              }
                                                            },
                                                            child: item.sendWelcomeSuccessfully == true
                                                                ? Label(
                                                                    text: LocaleKeys.messageSentSuccessfully.localize,
                                                                    style: Styles.headerText(),
                                                                  )
                                                                : Container(
                                                                    height: 25,
                                                                    alignment: Alignment.center,
                                                                    decoration: BoxDecoration(
                                                                      border: item.followSuccessfully == true
                                                                          ? Border.all()
                                                                          : null,
                                                                      borderRadius: BorderRadius.circular(4),
                                                                      color: item.followSuccessfully == false
                                                                          ? AppColors.PRIMARY_COLOR
                                                                          : Colors.white,
                                                                    ),
                                                                    child: Label(
                                                                      text: item.followSuccessfully == false
                                                                          ? LocaleKeys.follow.localize
                                                                          : LocaleKeys.sendGreetMessage.localize,
                                                                      style: Styles.mediumText(
                                                                          color: item.followSuccessfully == true
                                                                              ? AppColors.PRIMARY_COLOR_DARK
                                                                              : Colors.white,
                                                                          fontSize: 22,
                                                                          fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              noMoreItemsIndicatorBuilder: (context) => Container(),
                              firstPageProgressIndicatorBuilder: (context) =>
                                  const Center(child: CupertinoActivityIndicator()),
                              newPageProgressIndicatorBuilder: (context) =>
                                  const Center(child: CupertinoActivityIndicator())),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
    });
  }
}
