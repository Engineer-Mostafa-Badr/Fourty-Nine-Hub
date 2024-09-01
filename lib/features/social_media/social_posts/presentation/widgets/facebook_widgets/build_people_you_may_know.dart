import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/suggest_user_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BuildPeopleYouMayKnow extends StatefulWidget {
  const BuildPeopleYouMayKnow({super.key});

  @override
  State<BuildPeopleYouMayKnow> createState() => _BuildPeopleYouMayKnowState();
}

class _BuildPeopleYouMayKnowState extends State<BuildPeopleYouMayKnow> {
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialPostsCubit, SocialPostsState>(
        listener: (context, state) {
      if (state.status == StateStatus.error) {
        showErrorMessage(
          context,
          getFailureMessage(
            state.failure ?? const UnknownFailure(),
            context,
          ),
        );
      }
    }, builder: (context, state) {
      final controller = context.read<SocialPostsCubit>();
      return state.suggestedFriends == null ||
              controller.suggestUserPagingController.itemList == []
          ? const SizedBox.shrink()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 5,
                  color: AppColors.LIGHT_GRAY_COLOR,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(
                        text: "People you may know",
                        style: Styles.headerText(),
                      ),
                      Container(
                        alignment: AlignmentDirectional.topStart,
                        height: 350,
                        child: PagedListView<int, SuggestUserEntity>(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 5),
                          pagingController:
                              controller.suggestUserPagingController,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          builderDelegate:
                              PagedChildBuilderDelegate<SuggestUserEntity>(
                                  noItemsFoundIndicatorBuilder: (context) {
                                    print(controller.suggestUserPagingController
                                        .itemList?.length);
                                    return const Padding(
                                        padding: EdgeInsets.only(top: 200),
                                        child: Center(
                                          child: Label(
                                            text: "No friends suggested",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ));
                                  },
                                  itemBuilder: (context, item, index) {
                                    SuggestUserEntity item = controller
                                        .suggestUserPagingController
                                        .itemList![index];
                                    return InkWell(
                                      onTap: () {
                                        context.push(Routes.OTHERSACCOUNT,
                                            extra: controller
                                                .suggestUserPagingController
                                                .itemList?[index]
                                                .id);
                                      },
                                      child: Container(
                                        width: 260,
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        margin:
                                            const EdgeInsetsDirectional.only(
                                                end: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: AppColors.DARK_GRAY_COLOR),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: ImageFromInternet(
                                                image: item.profilePicture,
                                                // height: 220,
                                                width: 300,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Label(
                                                    text:
                                                        "${item.firstName} ${item.lastName}",
                                                    maxLines: 1,
                                                    style: Styles.mediumText(),
                                                  ),
                                                  SizedBox(
                                                    height: item.sendWelcomeSuccessfully ==
                                                            true
                                                        ? 30
                                                        : item.followSuccessfully ==
                                                                    true &&
                                                                item.addedSuccessfully ==
                                                                    true
                                                            ? 20
                                                            : 30,
                                                  ),
                                                  item.sendWelcomeSuccessfully ==
                                                          true
                                                      ? Label(
                                                          text:
                                                              "Message sent successfully",
                                                          style:
                                                              Styles.mediumText(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14),
                                                        )
                                                      : Row(
                                                          children: [
                                                            Expanded(
                                                              child: InkWell(
                                                                onTap:
                                                                    () async {
                                                                  if (item.addedSuccessfully ==
                                                                      false) {
                                                                    var response = await controller.friendRequest(
                                                                        context:
                                                                            context,
                                                                        userId:
                                                                            item.id);
                                                                    print(item
                                                                        .addedSuccessfully);

                                                                    if (response ==
                                                                        true) {
                                                                      item.addedSuccessfully =
                                                                          true;
                                                                      setState(
                                                                          () {});
                                                                      print(item
                                                                          .addedSuccessfully);
                                                                    }
                                                                  } else if (item
                                                                              .addedSuccessfully ==
                                                                          true &&
                                                                      item.followSuccessfully ==
                                                                          false) {
                                                                    var response = await controller.followRequest(
                                                                        context:
                                                                            context,
                                                                        userId:
                                                                            item.id);
                                                                    if (response ==
                                                                        true) {
                                                                      item.followSuccessfully =
                                                                          true;
                                                                      setState(
                                                                          () {});
                                                                    }
                                                                  } else if (item
                                                                              .addedSuccessfully ==
                                                                          true &&
                                                                      item.followSuccessfully ==
                                                                          true) {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AlertDialog(
                                                                          backgroundColor:
                                                                              AppColors.BACKGROUND_COLOR,
                                                                          surfaceTintColor:
                                                                              AppColors.BACKGROUND_COLOR,
                                                                          title:
                                                                              Label(
                                                                            text:
                                                                                'Enter greet message',
                                                                            style:
                                                                                Styles.headerText(),
                                                                          ),
                                                                          content:
                                                                              TextFormField(
                                                                            controller:
                                                                                messageController,
                                                                            onChanged: (c){
                                                                              setState(() {});
                                                                            },

                                                                            decoration:
                                                                                InputDecoration(hintText: "Greet message",fillColor: Colors.white, hintStyle: Styles.mediumText(color: AppColors.DARK_GRAY_COLOR)),
                                                                          ),
                                                                          actions: <Widget>[
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop(); // Close the dialog
                                                                              },
                                                                              child: Label(
                                                                                text: 'Cancel',
                                                                                style: Styles.headerText(),
                                                                              ),
                                                                            ),
                                                                            InkWell(
                                                                              onTap: () async {
                                                                                if(messageController.text.isNotEmpty){
                                                                                  await controller.sendGreetMessage(context: context, userId: controller.suggestUserPagingController.itemList![index].id, message: messageController.text);
                                                                                  controller.suggestUserPagingController.itemList?.removeWhere((element) => element.id == controller.suggestUserPagingController.itemList?[index].id);
                                                                                  showSuccessMessage(context, 'Message send successfully');
                                                                                  Navigator.of(context).pop();
                                                                                  setState(() {});
                                                                                }
                                                                              },
                                                                              child: Container(
                                                                                width: 100,
                                                                                padding: const EdgeInsets.all(5),
                                                                                decoration: BoxDecoration(
                                                                                  color: AppColors.PRIMARY_COLOR,
                                                                                  borderRadius: BorderRadius.circular(15)
                                                                                ),
                                                                                alignment: Alignment.center,
                                                                                child: Label(
                                                                                  text: 'Send',
                                                                                  style: Styles.headerText(color: Colors.white),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  }
                                                                },
                                                                child: item.sendWelcomeSuccessfully ==
                                                                        true
                                                                    ? Label(
                                                                        text:
                                                                            'Message send successfully',
                                                                        style: Styles
                                                                            .headerText(),
                                                                      )
                                                                    : Container(
                                                                        height:
                                                                            30,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border: item.followSuccessfully == true
                                                                              ? Border.all()
                                                                              : null,
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                          color: item.addedSuccessfully == false
                                                                              ? AppColors.PRIMARY_COLOR
                                                                              : item.addedSuccessfully == true && item.followSuccessfully == false
                                                                                  ? AppColors.PRIMARY_COLOR_DARK
                                                                                  : Colors.white,
                                                                        ),
                                                                        child:
                                                                            Label(
                                                                          text: item.addedSuccessfully == false
                                                                              ? 'Add Friend'
                                                                              : item.addedSuccessfully == true && item.followSuccessfully == false
                                                                                  ? 'Follow'
                                                                                  : "Send Greet Message",
                                                                          style: Styles.mediumText(
                                                                              color: item.followSuccessfully == true ? AppColors.PRIMARY_COLOR_DARK : Colors.white,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            if (item.addedSuccessfully ==
                                                                false)
                                                              Expanded(
                                                                child: InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    bool data = await controller.removeSuggestUser(
                                                                        context:
                                                                            context,
                                                                        userId:
                                                                            item.id);
                                                                    if (data ==
                                                                        true) {
                                                                      controller
                                                                          .suggestUserPagingController
                                                                          .itemList
                                                                          ?.removeWhere((e) =>
                                                                              e.id ==
                                                                              controller.suggestUserPagingController.itemList?[index].id);
                                                                      setState(
                                                                          () {});
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: 30,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    child:
                                                                        Label(
                                                                      text:
                                                                          'Remove',
                                                                      style: Styles.mediumText(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            // Expanded(
                                                            //     child: DefaultButton(
                                                            //         onPressed: () {}))
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
                                  noMoreItemsIndicatorBuilder: (context) =>
                                      Container(),
                                  firstPageProgressIndicatorBuilder:
                                      (context) => const Center(
                                          child: CupertinoActivityIndicator()),
                                  newPageProgressIndicatorBuilder: (context) =>
                                      const Center(
                                          child: CupertinoActivityIndicator())),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 5,
                  color: AppColors.LIGHT_GRAY_COLOR,
                ),
              ],
            );
    });
  }
}
