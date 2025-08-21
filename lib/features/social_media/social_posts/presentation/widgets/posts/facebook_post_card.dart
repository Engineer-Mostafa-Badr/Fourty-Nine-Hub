import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../../core/enums/base_status_enum.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../core/messages/messages.dart';
import '../../../../../../core/widget/clickable_widget.dart';
import '../../../../../ads_feature/ad_details/presentation/pages/image_gallary_viewer.dart';
import '../../../domain/entities/main_post_entity.dart';
import '../../../domain/entities/post_entity.dart';
import '../../cubit/social_posts_cubit.dart';
import '../../pages/search_app_users.dart';
import '../facebook_widgets/facebook_google_maps.dart';
import '../facebook_widgets/image_from_internet.dart';
import 'build_with_users.dart';
import '../../../../../../common/widgets/stateless/labels/read_more_label.dart';
import '../../../../twitter/data/models/twitter_user_model.dart';
import '../../../../twitter/presentation/widgets/report_view.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/widget/custom_scaffold.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../service_locator/service_locator.dart';
import '../../../domain/usecases/post_react_usecase.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../../../../helpers/manage_vibration.dart';

class FacebookPostCard extends StatefulWidget {
  final PostEntity post;
  final int index;
  final String from;
  final bool? fromProfile;
  final Function(PostReactParams) onReact;
  final Function(String id) onShare;
  final Function(String) showPostComments;
  final Function(PostEntity) showPostDetails;
  final Function(String) deletePost;
  final Function(String) hidePost;
  final bool showOptions;
  final bool isMyPost;

  const FacebookPostCard(
      {super.key,
      required this.post,
      required this.onReact,
      this.showOptions = true,
      this.isMyPost = false,
      this.fromProfile = false,
      required this.deletePost,
      required this.hidePost,
      required this.showPostDetails,
      required this.showPostComments,
      required this.onShare,
      required this.from,
      required this.index});

  @override
  State<FacebookPostCard> createState() => _FacebookPostCardState();
}

class _FacebookPostCardState extends State<FacebookPostCard> {
  final pageController = PageController();
  bool isLiked = false;
  bool hide = false;

  @override
  void initState() {
    pageController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialPostsCubit, SocialPostsState>(
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
      final controller = context.read<SocialPostsCubit>();
      return Container();
      // if (widget.from == 'posts') {
      //   if (controller.feedPagingController.itemList?[widget.index].type ==
      //       'advertisement') {
      //     return FacebookAdvertisementCard(
      //       post: controller.feedPagingController.itemList![widget.index],
      //     );
      //   } else if (controller
      //       .feedPagingController.itemList![widget.index].type ==
      //       'twitter_post') {
      //     return FacebookTweetCard(
      //       post: controller.feedPagingController.itemList![widget.index],
      //     );
      //   } else {
      //     var myPost = widget.from == 'details'
      //         ? widget.post
      //         : controller.feedPagingController.itemList![widget.index];
      //     return ClickableWidget(
      //       onTap: (widget.from == 'posts' && widget.post.isShared == true)
      //           ? () => widget.showPostDetails(
      //           controller.feedPagingController.itemList![widget.index])
      //           : null,
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           _buildAccountHeader(context: context, post: myPost),
      //           _buildContentWidget(
      //               content: myPost.content ?? '',
      //               backgroundColor: myPost.backgroundColor,
      //               images: myPost.images ?? []),
      //           Container(
      //             margin: EdgeInsets.all(myPost.isShared == true ? 10 : 0),
      //             padding: EdgeInsets.all(
      //                 (myPost.isShared == true && myPost.mainPost != null)
      //                     ? 10
      //                     : 0),
      //             decoration: BoxDecoration(
      //                 border: myPost.isShared == true
      //                     ? Border.all(color: AppColors.DIVIDER_GRAY_COLOR)
      //                     : null),
      //             child: Column(
      //               children: [
      //                 if (myPost.type != 'advertisement' &&
      //                     myPost.isShared == true &&
      //                     myPost.mainPost != null) ...[
      //                   if (myPost.type != 'advertisement' &&
      //                       myPost.isShared == true)
      //                     _buildMainAccountHeader(
      //                         context: context, post: myPost.mainPost!),
      //                   if (myPost.isShared == true)
      //                     _buildContentWidget(
      //                         content: myPost.mainPost?.content ?? '',
      //                         share: true,
      //                         backgroundColor: myPost.mainPost?.backgroundColor,
      //                         images: myPost.mainPost?.images ?? []),
      //                 ],
      //                 if (myPost.type != 'advertisement' &&
      //                     myPost.isShared == true &&
      //                     myPost.mainPost == null)
      //                   SizedBox(
      //                     width: double.infinity,
      //                     height: 100.h,
      //                     child: Center(
      //                       child: Row(
      //                         children: [
      //                           const Sizer(),
      //                           const Icon(
      //                             Icons.lock,
      //                           ),
      //                           const Sizer(),
      //                           Label(
      //                             text: "This content is not available now.",
      //                             style: Styles.headerText(),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   )
      //               ],
      //             ),
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.only(left: 8, right: 8),
      //             child: Row(
      //               children: [
      //                 if (myPost.likesCount != 0)
      //                   _buildCounterWidget(
      //                     value: myPost.likesCount,
      //                     image: Assets.like,
      //                   ),
      //                 if (myPost.hahaCount != 0)
      //                   _buildCounterWidget(
      //                     value: myPost.hahaCount,
      //                     image: Assets.haha,
      //                   ),
      //                 if (myPost.loveCount != 0)
      //                   _buildCounterWidget(
      //                     value: myPost.loveCount,
      //                     image: Assets.heart,
      //                   ),
      //                 if (myPost.wowCount != 0)
      //                   _buildCounterWidget(
      //                     value: myPost.wowCount,
      //                     image: Assets.wow,
      //                   ),
      //                 if (myPost.sadCount != 0)
      //                   _buildCounterWidget(
      //                     value: myPost.sadCount,
      //                     image: Assets.sad,
      //                   ),
      //                 if (myPost.angryCount != 0)
      //                   _buildCounterWidget(
      //                     value: myPost.angryCount,
      //                     image: Assets.angry,
      //                   ),
      //                 const Spacer(),
      //                 ClickableWidget(
      //                   onTap: () => widget.showPostComments(myPost.id),
      //                   child: Row(
      //                     children: [
      //                       Label(
      //                         text: myPost.commentsCount.toString(),
      //                         style: Styles.mediumText(),
      //                       ),
      //                       const Sizer(
      //                         width: 5,
      //                       ),
      //                       Label(
      //                         text: LocaleKeys.comments.localize,
      //                         style: Styles.mediumText(),
      //                       )
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           const Divider(
      //             color: AppColors.LIGHT_GRAY_COLOR,
      //           ),
      //           SizedBox(
      //             height: kToolbarHeight * .95,
      //             child: Row(
      //               children: [
      //                 Expanded(
      //                     child: BuildReactionsButtons(
      //                       post: myPost,
      //                       from: widget.from,
      //                     )),
      //                 if (widget.from == 'posts')
      //                   Expanded(
      //                     child: _buildReactionPlaceHolder(
      //                         icon: FontAwesomeIcons.comment,
      //                         label: LocaleKeys.comment.localize,
      //                         // image: Assets.comment,
      //                         onTap: () => widget.showPostComments(myPost.id)),
      //                   ),
      //                 Expanded(
      //                   child: MessageButton(
      //
      //                     fromFacebook: true,
      //                     user: UserProfileEntity(id: widget.post.user.id??'', firstName: widget.post.user.firstName, lastName: widget.post.user.lastName, email: widget.post.user.email, totalView: 0, profilePicture: widget.post.user?.image, profileCover: '', friendsCount: 0, maritalStatus: '', followersCount: 0, followingCount: 0, posts: 0, instagramPosts: 0, bio: '', city: '', country: '', job: '', phone: '',),
      //                     normalPress: () async {
      //                       if (context.read<UserCubit>().isLoggedIn) {
      //                         if (state.profileData?.areFriends == true) {
      //                           ChatEntity? chat = await context
      //                               .read<UserCubit>()
      //                               .createNormalChat(
      //                             otherId: widget.post.user.id??'',
      //                             categoryId: ChatCategoriesIds.social,
      //                           );
      //                           context.pop();
      //                           context.push(
      //                             Routes.CHAT,
      //                             extra: ChatsViewParams(
      //                               isFromStartChat: true,
      //                               initialTabIndex: 0,
      //                               selectedChat: chat,
      //                             ),
      //                           );
      //                         } else {
      //                           ChatEntity? chat = await context
      //                               .read<UserCubit>()
      //                               .createNormalChat(
      //                             otherId: widget.post.user.id,
      //                             categoryId: ChatCategoriesIds.greet,
      //                           );
      //                           context.pop();
      //                           context.push(
      //                             Routes.CHAT,
      //                             extra: ChatsViewParams(
      //                               isFromStartChat: true,
      //                               initialTabIndex: 0,
      //                               selectedChat: chat,
      //                             ),
      //                           );
      //                         }
      //                       } else {
      //                         context.push(Routes.LOGIN);
      //                       }
      //                     },
      //                     anonymousPress: () async {
      //                       if (context.read<UserCubit>().isLoggedIn) {
      //                         ChatEntity? chat = await context
      //                             .read<UserCubit>()
      //                             .createAnonymousChat(
      //                           otherId: widget.post.user.id,
      //                         );
      //                         context.pop();
      //                         context.push(
      //                           Routes.CHAT,
      //                           extra: ChatsViewParams(
      //                             isFromStartChat: true,
      //                             initialTabIndex: 0,
      //                             selectedChat: chat,
      //                           ),
      //                         );
      //                       } else {
      //                         context.push(Routes.LOGIN);
      //                       }
      //                     },
      //                   ),
      //                 ),
      //                 Expanded(
      //                   child: _buildReactionPlaceHolder(
      //                       label: LocaleKeys.share.localize,
      //                       isImage: false,
      //                       icon: FontAwesomeIcons.share,
      //                       onTap: () async {
      ManageVibration.vibrate();
      //                         showModalBottomSheet(
      //                           backgroundColor: Colors.white,
      //                           context: context,
      //                           shape: const RoundedRectangleBorder(
      //                             borderRadius: BorderRadius.only(
      //                               topLeft: Radius.circular(15.0),
      //                               topRight: Radius.circular(15.0),
      //                             ),
      //                           ),
      //                           isDismissible: true,
      //                           isScrollControlled: true,
      //                           builder: (BuildContext context) {
      //                             return AnimatedPadding(
      //                               padding: MediaQuery.of(context).viewInsets,
      //                               duration: const Duration(milliseconds: 50),
      //                               child: Container(
      //                                 height: 400.h,
      //                                 padding: EdgeInsets.symmetric(
      //                                   vertical: 10.h,
      //                                   horizontal: 10,
      //                                 ),
      //                                 child: Column(
      //                                   children: [
      //                                     Label(
      //                                       text: LocaleKeys.share.localize,
      //                                       style: Styles.headerText(),
      //                                     ),
      //                                     Sizer(
      //                                       height: 30.h,
      //                                     ),
      //                                     Container(
      //                                       constraints: BoxConstraints(
      //                                           maxHeight: 220.h,
      //                                           minHeight: 180.h),
      //                                       child: Form(
      //                                         key: controller.shareFormKey,
      //                                         child: TextFormField(
      //                                           validator: (value) {
      //                                             if ((value == null ||
      //                                                 value.isEmpty)) {
      //                                               return LocaleKeys
      //                                                   .required.localize;
      //                                             } else {
      //                                               return null;
      //                                             }
      //                                           },
      //                                           // focusNode: focusNode,
      //                                           maxLines: null,
      //                                           maxLength: 100,
      //                                           onChanged: (c) => controller
      //                                               .changeContent(v: c),
      //                                           // controller: controller,
      //                                           decoration: InputDecoration(
      //                                               hintText: LocaleKeys
      //                                                   .saySomthing.localize,
      //                                               fillColor: Colors.white,
      //                                               hintStyle: Styles.mediumText(
      //                                                   color: AppColors
      //                                                       .DARK_GRAY_COLOR)),
      //                                         ),
      //                                       ),
      //                                     ),
      //                                     Expanded(
      //                                       child: Row(
      //                                         children: [
      //                                           Expanded(
      //                                             child: ClickableWidget(
      //                                               onTap: () async {
      ManageVibration.vibrate();
      //                                                 if (controller
      //                                                     .shareFormKey
      //                                                     .currentState!
      //                                                     .validate()) {
      //                                                   var result = await controller
      //                                                       .onShare(
      //                                                       postId: myPost
      //                                                           .isShared ==
      //                                                           true
      //                                                           ? myPost
      //                                                           .mainPost!
      //                                                           .id
      //                                                           : myPost
      //                                                           .id);
      //                                                   if (result == true) {
      //                                                     showSuccessMessage(
      //                                                         context,
      //                                                         LocaleKeys
      //                                                             .postSharedSuccessfully
      //                                                             .localize);
      //                                                     context.pop();
      //                                                   }
      //                                                 }
      //                                               },
      //                                               child: Container(
      //                                                 width: 100,
      //                                                 height: 80.h,
      //                                                 padding:
      //                                                 const EdgeInsets.all(
      //                                                     5),
      //                                                 decoration: BoxDecoration(
      //                                                     color: AppColors
      //                                                         .PRIMARY_COLOR,
      //                                                     borderRadius:
      //                                                     BorderRadius
      //                                                         .circular(
      //                                                         15)),
      //                                                 alignment:
      //                                                 Alignment.center,
      //                                                 child: Label(
      //                                                   text: LocaleKeys
      //                                                       .share.localize,
      //                                                   style:
      //                                                   Styles.headerText(
      //                                                       color: Colors
      //                                                           .white),
      //                                                 ),
      //                                               ),
      //                                             ),
      //                                           ),
      //                                           Expanded(
      //                                             child: TextButton(
      //                                               onPressed: () {
      ManageVibration.vibrate();
      //                                                 Navigator.of(context)
      //                                                     .pop();
      //                                               },
      //                                               child: Label(
      //                                                 text: LocaleKeys
      //                                                     .cancel.localize,
      //                                                 style:
      //                                                 Styles.headerText(),
      //                                               ),
      //                                             ),
      //                                           ),
      //                                         ],
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ),
      //                             );
      //                           },
      //                         );
      //                       }),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     );
      //   }
      // } else
      // {
      //   var myPost = widget.from == 'details'
      //       ? widget.post
      //       : controller.feedPagingController.itemList![widget.index];
      //   return ClickableWidget(
      //     onTap: (widget.from == 'posts' && widget.post.isShared == true)
      //         ? () => widget.showPostDetails(
      //         controller.feedPagingController.itemList![widget.index])
      //         : null,
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         if (myPost.type != 'advertisement')
      //           _buildAccountHeader(context: context, post: myPost),
      //         _buildContentWidget(
      //             content: myPost.content ?? '',
      //             backgroundColor: myPost.backgroundColor,
      //             images: myPost.images),
      //         Padding(
      //           padding: const EdgeInsets.only(left: 8, right: 8),
      //           child: Row(
      //             children: [
      //               if (myPost.likesCount != 0)
      //                 _buildCounterWidget(
      //                   value: myPost.likesCount,
      //                   image: Assets.like,
      //                 ),
      //               if (myPost.hahaCount != 0)
      //                 _buildCounterWidget(
      //                   value: myPost.hahaCount,
      //                   image: Assets.haha,
      //                 ),
      //               if (myPost.loveCount != 0)
      //                 _buildCounterWidget(
      //                   value: myPost.loveCount,
      //                   image: Assets.heart,
      //                 ),
      //               if (myPost.wowCount != 0)
      //                 _buildCounterWidget(
      //                   value: myPost.wowCount,
      //                   image: Assets.wow,
      //                 ),
      //               if (myPost.sadCount != 0)
      //                 _buildCounterWidget(
      //                   value: myPost.sadCount,
      //                   image: Assets.sad,
      //                 ),
      //               if (myPost.angryCount != 0)
      //                 _buildCounterWidget(
      //                   value: myPost.angryCount,
      //                   image: Assets.angry,
      //                 ),
      //               const Spacer(),
      //               ClickableWidget(
      //                 onTap: () => widget.showPostComments(myPost.id),
      //                 child: Row(
      //                   children: [
      //                     Label(
      //                       text: myPost.commentsCount.toString(),
      //                       style: Styles.mediumText(),
      //                     ),
      //                     const Sizer(
      //                       width: 5,
      //                     ),
      //                     Label(
      //                       text: LocaleKeys.comments.localize,
      //                       style: Styles.mediumText(),
      //                     )
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         const Divider(
      //           color: AppColors.LIGHT_GRAY_COLOR,
      //         ),
      //         SizedBox(
      //           height: kToolbarHeight * .95,
      //           child: Row(
      //             children: [
      //               Expanded(
      //                   child: BuildReactionsButtons(
      //                     post: myPost,
      //                     from: 'posts',
      //                   )),
      //               if (widget.from == 'posts')
      //                 Expanded(
      //                   child: _buildReactionPlaceHolder(
      //                       icon: FontAwesomeIcons.message,
      //                       image: Assets.comment,
      //                       label: LocaleKeys.comments.localize,
      //                       onTap: () => widget.showPostComments(myPost.id)),
      //                 ),
      //               Expanded(
      //                 child: _buildReactionPlaceHolder(
      //                     icon: FontAwesomeIcons.share,
      //                     label: LocaleKeys.share.localize,
      //                     isImage: true,
      //                     image: Assets.facebookShare,
      //                     onTap: () async {
      ManageVibration.vibrate();
      //                       var result = await controller.onShare(
      //                           postId: myPost.isShared == true
      //                               ? myPost.mainPost!.id
      //                               : myPost.id);
      //                       if (result == true) {
      //                         showSuccessMessage(
      //                             context, "Post shared successfully");
      //                       }
      //                     }),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   );
      // }
    });
  }

  Widget _buildCounterWidget({
    required num value,
    required String image,
  }) {
    return ClickableWidget(
      onTap: () {
        ManageVibration.vibrate();
        showCustomBottomSheet(context);
        // bottomSheet(
        //   context: context,
        //   isScrollControlled: true,
        //   widget: SafeArea(
        //     child: Column(
        //       children: [
        //         Sizer(
        //           height: 80.h,
        //         ),
        //         Row(
        //           children: [
        //             IconButton(
        //               onPressed: () {
        ManageVibration.vibrate();
        //                 Navigator.pop(context);
        //               },
        //               icon: const Icon(Icons.arrow_back),
        //             ),
        //             const Sizer(),
        //             Expanded(
        //               child: Label(
        //                 text: 'People who interacted',
        //                 style: Styles.mediumText(fontSize: 65.sp),
        //               ),
        //             ),
        //            // const Spacer(),
        //             IconButton(
        //                 onPressed: () {
        ManageVibration.vibrate();
        //                   showDialog(
        //                       context: context,
        //                       builder: (_) =>
        //                       const SearchAppUsers());
        //                 },
        //                 icon:  Icon(
        //                   FontAwesomeIcons.search,
        //                   size: 35.sp,
        //                 )),
        //           ],
        //         ),
        //         Row(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [
        //             ClickableWidget(
        //               onTap: () {
        ManageVibration.vibrate();
        //                 if (widget.fromProfile == false) {
        //                   context.push(Routes.OTHERSACCOUNT, extra: post.user.id);
        //                 }
        //               },
        //               child: Stack(
        //                 alignment: AlignmentDirectional.bottomEnd,
        //                 children: [
        //                   ImageFromInternet(
        //                     image: post.user.image ?? '',
        //                     isCircle: true,
        //                     width: 90.w,
        //                     height: 90.h,
        //                   ),
        //                   CircleAvatar(
        //                     radius: 25.r,
        //                     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //                     child: Image.asset('assets/images/haha.png',
        //                     height: 40.h,
        //                       width: 40.w,
        //                     ),
        //                   )
        //                 ],
        //               ),
        //             ),
        //             const Sizer(),
        //             ClickableWidget(
        //               onTap: () {
        ManageVibration.vibrate();
        //                 if (widget.fromProfile == false) {
        //                   context.push(Routes.OTHERSACCOUNT,
        //                       extra: post.user.id);
        //                 }
        //               },
        //               child: Text('${post.user.firstName} ${post.user.lastName}',
        //               style: Styles.headerText(fontSize: 65.sp),
        //               ),
        //             ),
        //             const Sizer(),
        //             // (user.areFriends == true ||
        //             //     user.isSenTRequest == true)
        //             //     ? PopupMenuButton(
        //             //   // iconSize: 210,
        //             //     itemBuilder: (context) {
        //             //       return [
        //             //         if (user.isSenTRequest == true) ...[
        //             //           PopupMenuItem<int>(
        //             //             value: 0,
        //             //             child: Text(
        //             //                 LocaleKeys.Accept.localize),
        //             //             onTap: () => onAcceptFriend(),
        //             //           ),
        //             //           PopupMenuItem<int>(
        //             //             value: 1,
        //             //             child: Text(
        //             //                 LocaleKeys.reject.localize),
        //             //             onTap: () => onRejectFriend(),
        //             //           ),
        //             //         ],
        //             //         if (user.areFriends == true)
        //             //           PopupMenuItem<int>(
        //             //             value: 0,
        //             //             child: Text(LocaleKeys
        //             //                 .deleteFriend.localize),
        //             //             onTap: () => onDeleteFriend(),
        //             //           ),
        //             //       ];
        //             //     },
        //             //     child: Container(
        //             //         alignment: Alignment.center,
        //             //         padding: const EdgeInsets.symmetric(
        //             //             horizontal: 10),
        //             //         decoration: BoxDecoration(
        //             //           borderRadius:
        //             //           BorderRadius.circular(5),
        //             //           color: AppColors.PRIMARY_COLOR,
        //             //         ),
        //             //         child: Text(
        //             //           user.isSenTRequest == true
        //             //               ? LocaleKeys
        //             //               .acceptRequest.localize
        //             //               : user.areFriends == true
        //             //               ? LocaleKeys
        //             //               .friends.localize
        //             //               : '',
        //             //           style: Styles.mediumText(
        //             //               color: Colors.white),
        //             //         )))
        //             //     : SizedBox(
        //             //   width: 180.w,
        //             //   child: AppButton(
        //             //     // height: 80.h,
        //             //       padding: 5,
        //             //       backColor:
        //             //       user.sentFriendRequest == true
        //             //           ? AppColors.PRIMARY_COLOR
        //             //           : null,
        //             //       style: Styles.mediumText(
        //             //           color: Colors.white,
        //             //           fontSize: 24),
        //             //       label: user.isSenTRequest == true
        //             //           ? LocaleKeys
        //             //           .acceptRequest.localize
        //             //           : user.areFriends == true
        //             //           ? LocaleKeys
        //             //           .friends.localize
        //             //           : user.sentFriendRequest ==
        //             //           true
        //             //           ? LocaleKeys
        //             //           .removeRequest
        //             //           .localize
        //             //           : LocaleKeys
        //             //           .addFriend.localize,
        //             //       onPressed: () {
        ManageVibration.vibrate();
        //             //         onAddFriend();
        //             //       }),
        //             // )
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // );
      },
      child: Row(
        children: [
          Image.asset(
            image,
            height: 45.w,
          ),
          Label(
            text: value.toString(),
            style: Styles.mediumText(),
          )
        ],
      ),
    );
  }

  Widget _buildPostOptions(
      {required bool fromDetails, required PostEntity post}) {
    return SizedBox(
      height: widget.isMyPost ? 270.h : 270.h,
      child: Column(
        children: [
          if (!widget.isMyPost)
            listTile(
                iconColor: Theme.of(context).primaryColor,
                icon: Icons.report,
                title: LocaleKeys.reportPost.localize,
                subTitle: LocaleKeys.youWillReportPost.localize,
                onTap: () async {
                  ManageVibration.vibrate();
                  Future.delayed(const Duration(milliseconds: 200), () {
                    bottomSheet(
                        context: context,
                        widget: ReportView(
                          id: widget.post.id,
                          categoryId: '66a3583454e6e337915514db',
                        ));
                  });
                }),
          if (widget.isMyPost)
            listTile(
                icon: Icons.delete,
                iconColor: Theme.of(context).primaryColor,
                title: LocaleKeys.deletePost.localize,
                subTitle: LocaleKeys.youWillDeletePost.localize,
                onTap: () {
                  ManageVibration.vibrate();
                  widget.deletePost(post.id);
                  if (fromDetails == true) {
                    context.pop();
                  }
                }),
          listTile(
              icon: Icons.visibility_off,
              iconColor: Theme.of(context).primaryColor,
              title: LocaleKeys.hidePost.localize,
              subTitle: LocaleKeys.youWillHidePost.localize,
              onTap: () {
                ManageVibration.vibrate();
                widget.hidePost(post.id);
                if (fromDetails == true) {
                  context.pop();
                }
              }),
        ],
      ),
    );
  }

  Widget listTile(
      {required IconData icon,
      Color? iconColor,
      required String title,
      required String subTitle,
      required Function onTap}) {
    return ListTile(
      title: Label(text: title),
      onTap: () {
        ManageVibration.vibrate();
        onTap();
        context.pop();
      },
      leading: Icon(
        icon,
        color: iconColor ?? Colors.black,
      ),
      subtitle: Label(
        text: subTitle,
        style: Styles.mediumText(color: Colors.grey),
      ),
    );
  }

  Widget _buildAccountHeader({
    required BuildContext context,
    required PostEntity post,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClickableWidget(
                onTap: () {
                  ManageVibration.vibrate();
                  if (widget.fromProfile == false) {
                    context.push(Routes.OTHERSACCOUNT, extra: post.user.id);
                  }
                },
                child: ImageFromInternet(
                  image: post.user.image ?? '',
                  isCircle: true,
                  width: 80.w,
                  height: 80.h,
                ),
              ),
              const Sizer(),
              Expanded(
                child: ClickableWidget(
                  onTap: () {
                    ManageVibration.vibrate();
                    if (widget.fromProfile == false) {
                      context.push(Routes.OTHERSACCOUNT, extra: post.user.id);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextAppButton(
                          label: "${post.user.firstName} ${post.user.lastName}",
                          style: Styles.headerText(fontSize: 32),
                          onPressed: () {
                            ManageVibration.vibrate();
                            if (widget.fromProfile == false) {
                              context.push(Routes.OTHERSACCOUNT,
                                  extra: post.user.id);
                            }
                          }),
                      _buildActivityFeelingWidget(post),
                      RichText(
                          text: TextSpan(children: [
                        // TextSpan(
                        //     text: "${post.sinceTime}.",
                        //     style: Styles.mediumText(color: Colors.grey)),
                        const WidgetSpan(child: Sizer()),

                        WidgetSpan(
                            child: ClickableWidget(
                          onTap: () {
                            ManageVibration.vibrate();
                          },
                          child: const Icon(
                            Icons.group,
                            size: 14,
                            color: Colors.grey,
                          ),
                        ))
                      ])),
                    ],
                  ),
                ),
              ),
              const Sizer(),
              IconAppButton(
                icon: Icons.more_horiz_outlined,
                onPressed: () {
                  ManageVibration.vibrate();
                  bottomSheet(
                    backColor: Theme.of(context).scaffoldBackgroundColor,
                    context: context,
                    widget: _buildPostOptions(
                      fromDetails: widget.from == 'details',
                      post: post,
                    ),
                  );
                },
              ),
            ],
          ),
          if (post.location != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 40.0),
              child: ClickableWidget(
                onTap: () {
                  ManageVibration.vibrate();
                  showDialog(
                      context: context,
                      builder: (_) => CustomScaffold(
                            body: FacebookUserOnMap(
                              location: post.location!,
                            ),
                          ));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 40.sp,
                    ),
                    Expanded(
                        child: Label(
                      text: post.location?.place ?? '',
                      style: Styles.mediumText(),
                    ))
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainAccountHeader({
    required BuildContext context,
    required MainPostEntity post,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          ClickableWidget(
            onTap: () {
              ManageVibration.vibrate();
              if (widget.fromProfile == false) {
                context.push(Routes.OTHERSACCOUNT, extra: post.user.id);
              }
            },
            child: ImageFromInternet(
              image: post.user.image,
              isCircle: true,
              defaultLogo: false,
              width: 80.w,
              height: 80.h,
            ),
          ),
          const Sizer(),
          Expanded(
              child: Row(
            children: [
              ClickableWidget(
                onTap: () {
                  ManageVibration.vibrate();
                  if (widget.fromProfile == false) {
                    context.push(Routes.OTHERSACCOUNT, extra: post.user.id);
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TextAppButton(
                            // style: TextStyle(color: Theme.of(context).primaryColor),
                            label:
                                "${post.user.firstName} ${post.user.lastName} . ",
                            style: Styles.headerText(
                                fontSize: 32,
                                color: Theme.of(context).primaryColor),
                            onPressed: () {
                              ManageVibration.vibrate();
                              if (widget.fromProfile == false) {
                                context.push(Routes.OTHERSACCOUNT,
                                    extra: post.user.id);
                              }
                            }),

                        TextAppButton(
                            // style: TextStyle(color: Theme.of(context).primaryColor),
                            label: "Follow",
                            style: Styles.headerText(
                                fontSize: 32, color: AppColors.LIGHT_BLUE),
                            onPressed: () {
                              ManageVibration.vibrate();
                              // if (widget.fromProfile == false) {
                              //   context.push(Routes.OTHERSACCOUNT,
                              //       extra: post.user.id);
                              // }
                            }),
                        // Expanded(child: RichText(text: TextSpan(children: [
                        //   TextSpan(
                        //       text: post.sinceTime,
                        //       style: Styles.mediumText(color: Colors.grey)),
                        // ]))),
                      ],
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: post.sinceTime,
                          style: Styles.mediumText(color: Colors.grey)),
                      const WidgetSpan(
                          child: Icon(
                        Icons.group,
                        size: 14,
                        color: Colors.grey,
                      ))
                    ]))
                  ],
                ),
              ),
              // _buildActivityFeelingWidget(post),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildContentWidget(
      {String? backgroundColor,
      required String content,
      List<String>? images,
      bool? share = false}) {
    return (backgroundColor != null && backgroundColor != '#FFFFFFFF') &&
            images!.isEmpty &&
            content.isNotEmpty
        ? Container(
            width: double.infinity,
            height: 500.h,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.h),
            decoration: BoxDecoration(
              color: images.isEmpty
                  ? Color(int.parse(backgroundColor.substring(1), radix: 16))
                  : Colors.white,
              borderRadius: BorderRadius.circular((share == true ? 10 : 0).r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReadMoreLabel(
                  text: content,
                  textAlign:
                      isArabic(content) ? TextAlign.right : TextAlign.left,
                  style: Styles.headerText(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          )
        : Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (content.isNotEmpty) ...[
                  ReadMoreLabel(
                    text: content,
                    textAlign:
                        isArabic(content) ? TextAlign.right : TextAlign.left,
                    style: Styles.headerText(
                        color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(
                    height: 10.h,
                  )
                ],
                if ((images?.isNotEmpty ?? false))
                  StaggeredGrid.count(
                    crossAxisCount:
                        (images?.length ?? 0) > 4 ? 4 : images?.length ?? 0,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    children: List.generate(
                      (images?.length ?? 0) > 4 ? 4 : images?.length ?? 0,
                      (index) {
                        // Define layout pattern dynamically
                        int crossAxisCellCount;
                        int mainAxisCellCount;

                        if (index % 5 == 0) {
                          crossAxisCellCount = 2;
                          mainAxisCellCount = 2;
                        } else if (index % 5 == 1) {
                          crossAxisCellCount = 2;
                          mainAxisCellCount = 1;
                        } else {
                          crossAxisCellCount = 1;
                          mainAxisCellCount = 1;
                        }

                        return StaggeredGridTile.count(
                          crossAxisCellCount: crossAxisCellCount,
                          mainAxisCellCount: mainAxisCellCount,
                          child: ClickableWidget(
                            onTap: () {
                              ManageVibration.vibrate();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageGalleryPage(
                                    images: images ?? [],
                                    initialIndex: index,
                                  ),
                                ),
                              );
                              // if (index != 3 ||
                              //     (index == 3 && (images?.length??0) == 4)) {
                              //   showDialog(
                              //       context: context,
                              //       builder: (context) => ImageDetailsScreen(
                              //         image: images?[index]??'',
                              //         fromPost: true,
                              //         onRemoveImage: () {
                              //           // controller
                              //           //     .removePhoto(images![index]);
                              //           context.pop();
                              //         },
                              //       ));
                              // } else {
                              //   showDialog(
                              //       context: context,
                              //       builder: (context) {
                              //         return ShowPostsImages(
                              //           images: images??[],
                              //           onRemoveImage:
                              //               (UploadFileEntity image) {
                              //             // controller.removePhoto(image);
                              //           },
                              //         );
                              //       });
                              // }
                            },
                            child: Stack(
                              children: [
                                Stack(
                                  children: [
                                    ImageFromInternet(
                                      image: images?[index] ?? '',
                                      defaultLogo: true,
                                    ),
                                    if (index == 3 && (images?.length ?? 0) > 4)
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                        child: Center(
                                          child: Label(
                                            text:
                                                "+${(images?.length ?? 0) - 4}",
                                            style: Styles.headerText(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                // SizedBox(
                //   child: GridView.builder(
                //       padding: const EdgeInsets.all(10),
                //       shrinkWrap: true,
                //       physics: const NeverScrollableScrollPhysics(),
                //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //           crossAxisCount: images!.length == 1 ? 1 : 2),
                //       itemCount: images.length < 4 ? images.length : 4,
                //       itemBuilder: (context, index) => ClickableWidget(
                //             onTap: () {
                //               if (index != 3 ||
                //                   (index == 3 && images.length == 4)) {
                //                 showDialog(
                //                     context: context,
                //                     builder: (context) => ImageDetailsScreen(
                //                           image: images[index],
                //                           fromPost: true,
                //                           onRemoveImage: () {
                //                             // controller
                //                             //     .removePhoto(images![index]);
                //                             context.pop();
                //                           },
                //                         ));
                //               } else {
                //                 showDialog(
                //                     context: context,
                //                     builder: (context) {
                //                       return ShowPostsImages(
                //                         images: images,
                //                         onRemoveImage:
                //                             (UploadFileEntity image) {
                //                           // controller.removePhoto(image);
                //                         },
                //                       );
                //                     });
                //               }
                //             },
                //             child: Stack(
                //               children: [
                //                 Stack(
                //                   children: [
                //                     ImageFromInternet(
                //                       image: images[index],
                //                       defaultLogo: true,
                //                     ),
                //                     if (index == 3 && images.length > 4)
                //                       Container(
                //                         alignment: Alignment.center,
                //                         decoration: BoxDecoration(
                //                           color:
                //                               Colors.black.withOpacity(0.5),
                //                         ),
                //                         child: Center(
                //                           child: Label(
                //                             text: "+${images.length - 4}",
                //                             style: Styles.headerText(
                //                               color: Colors.white,
                //                             ),
                //                           ),
                //                         ),
                //                       ),
                //                   ],
                //                 ),
                //               ],
                //             ),
                //           )),
                // ),
              ],
            ),
          );
  }

  Widget _buildReactionPlaceHolder({
    IconData? icon,
    required String label,
    String? image,
    bool? isImage = false,
    Function? onTap,
  }) {
    if (onTap == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (image != null)
            Image.asset(
              image,
              width: 24.w,
              height: 24.h,
              color: Colors.grey,
            ),
          if (isImage == false)
            FaIcon(
              icon,
              color: Colors.grey,
              size: 32.sp,
            ),
          Label(text: label, style: Styles.mediumText(color: Colors.grey))
        ],
      );
    } else {
      return ClickableWidget(
        onTap: () => onTap(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null)
              Image.asset(
                image,
                width: 40.w,
                height: 40.h,
                color: Colors.grey,
              ),
            if (image == null)
              FaIcon(
                icon,
                color: Colors.grey,
                size: 32.sp,
              ),
            // Sizer(),
            Label(text: label, style: Styles.mediumText(color: Colors.grey))
          ],
        ),
      );
    }
  }

  Widget _buildActivityFeelingWidget(PostEntity post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.feeling != null || post.activity != null) ...[
            Text(
              '${LocaleKeys.feeling.localize} ${post.feeling != null ? post.feeling?.name ?? '' : ''}${post.activity != null ? ', ${post.activity?.name}' : ''}',
              style: Styles.mediumText(),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
          if (post.users.isNotEmpty)
            Row(
              children: [
                Label(
                  text: '${LocaleKeys.withKey.localize}: ',
                  style: Styles.smallText(color: AppColors.GREY_NORMAL_COLOR),
                ),
                GestureDetector(
                  onTap: () {
                    ManageVibration.vibrate();
                    context.push(Routes.OTHERSACCOUNT, extra: post.users[0].id);
                  },
                  child: Label(
                    text:
                        "${post.users[0].firstName} ${post.users[0].lastName} ",
                    style: Styles.smallText(
                        decoration: TextDecoration.underline,
                        color: AppColors.GREY_NORMAL_COLOR),
                  ),
                ),
                if (post.users.length > 1)
                  GestureDetector(
                      onTap: () {
                        ManageVibration.vibrate();
                        showDialog(
                            context: context,
                            builder: (_) => BuildWithUsers(
                                  users: post.users,
                                ));
                      },
                      child: Label(
                        text: '+${post.users.length - 1}',
                        style: Styles.mediumText(
                            color: AppColors.GREY_NORMAL_COLOR),
                      ))
              ],
            ),
        ],
      ),
    );
  }

  bool isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }

  void showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) => DefaultTabController(
        length: Reaction.values.length,
        child: SafeArea(
          child: BlocProvider<SocialPostsCubit>(
            create: (BuildContext context) => serviceLocator()..loadData(),
            child: BlocBuilder<SocialPostsCubit, SocialPostsState>(
              builder: (BuildContext context, state) {
                // Reaction mapping with icons and labels
                // final reactionsMap = {
                //   Reaction.like: {'asset': Assets.like, 'label': 'Likes'},
                //   Reaction.love: {'asset': Assets.heart, 'label': 'Hearts'},
                //   Reaction.haha: {'asset': Assets.haha, 'label': 'Hahas'},
                //   Reaction.sad: {'asset': Assets.sad, 'label': 'Sads'},
                //   Reaction.angry: {'asset': Assets.angry, 'label': 'Angries'},
                //   Reaction.wow: {'asset': Assets.wow, 'label': 'Wows'},
                // };

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header Section
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            ManageVibration.vibrate();
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                        const Spacer(),
                        Expanded(
                          child: Text(
                            'People who interacted',
                            style: Styles.mediumText(fontSize: 65.sp),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ManageVibration.vibrate();
                            showDialog(
                              context: context,
                              builder: (_) => const SearchAppUsers(),
                            );
                          },
                          icon: Icon(
                            FontAwesomeIcons.search,
                            size: 35.sp,
                          ),
                        ),
                      ],
                    ),
                    TabBar(
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.blue,
                      isScrollable: true,
                      tabs: Reaction.values.map((reaction) {
                        return Tab(
                          child: Row(
                            children: [
                              Image.asset(
                                reaction.image(),
                                height: 60.h,
                                width: 60.w,
                              ),
                              Text(
                                // state.posts![index].getReactionCount(reaction).toString(),
                                '1',
                                style: Styles.mediumText(
                                    color: AppColors.GREY_NORMAL_COLOR),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    // Reaction TabBarView
                    Expanded(
                      child: TabBarView(
                        children: Reaction.values.map((reaction) {
                          final users =
                              getUsersForReaction(reaction, state.posts![0]);
                          return ListView.separated(
                            itemBuilder: (context, userIndex) => Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClickableWidget(
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    if (widget.fromProfile == false) {
                                      context.push(
                                        Routes.OTHERSACCOUNT,
                                        extra: users[userIndex].id,
                                      );
                                    }
                                  },
                                  child: Stack(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    children: [
                                      ImageFromInternet(
                                        image: users[userIndex].image ?? '',
                                        isCircle: true,
                                        width: 90.w,
                                        height: 90.h,
                                      ),
                                      CircleAvatar(
                                        radius: 25.r,
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        child: Image.asset(
                                          reaction.image(),
                                          height: 40.h,
                                          width: 40.w,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Sizer(),
                                ClickableWidget(
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    if (widget.fromProfile == false) {
                                      context.push(
                                        Routes.OTHERSACCOUNT,
                                        extra: users[userIndex].id,
                                      );
                                    }
                                  },
                                  child: Text(
                                    '${users[userIndex].firstName} ${users[userIndex].lastName}',
                                    style: Styles.headerText(fontSize: 65.sp),
                                  ),
                                ),
                                const Sizer(),
                              ],
                            ),
                            separatorBuilder: (context, _) => const Sizer(),
                            itemCount: users.length,
                          );
                        }).toList(),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

// Helper function to get users for a specific reaction
  List<TwitterUserModel> getUsersForReaction(
      Reaction reaction, PostEntity post) {
    switch (reaction) {
      case Reaction.like:
        return post.likedUsers ?? [];
      case Reaction.haha:
        return post.hahaUsers ?? [];
      case Reaction.love:
        return post.loveUsers ?? [];
      case Reaction.wow:
        return post.wowUsers ?? [];
      case Reaction.sad:
        return post.sadUsers ?? [];
      case Reaction.angry:
        return post.angryUsers ?? [];
    }
  }

// void showCustomBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//     builder: (_) => DefaultTabController(
//       length: 6, // Adjust according to the number of tabs
//       child: SafeArea(
//         child: BlocProvider<SocialPostsCubit>(
//           create: (BuildContext context) =>serviceLocator()..loadData(),
//           child: BlocBuilder<SocialPostsCubit,SocialPostsState>(
//             builder: (BuildContext context, state) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Sizer(
//                     height: 80.h,
//                   ),
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         icon: const Icon(Icons.arrow_back),
//                       ),
//                       const Sizer(),
//                       Expanded(
//                         child: Label(
//                           text: 'People who interacted',
//                           style: Styles.mediumText(fontSize: 65.sp),
//                         ),
//                       ),
//                       // const Spacer(),
//                       IconButton(
//                           onPressed: () {
//                             showDialog(
//                                 context: context,
//                                 builder: (_) => const SearchAppUsers());
//                           },
//                           icon: Icon(
//                             FontAwesomeIcons.search,
//                             size: 35.sp,
//                           )),
//                     ],
//                   ),
//                   TabBar(
//                     labelColor: Colors.blue,
//                     unselectedLabelColor: Colors.grey,
//                     indicatorColor: Colors.blue,
//                     isScrollable: true,
//                     tabAlignment: TabAlignment.start,
//                     tabs: [
//                       Tab(
//                         child: Row(
//                           children: [
//                             Image.asset(
//                               Assets.like,
//                               height: 60.h,
//                               width: 60.w,
//                             ),
//                             Text(
//                               '100',
//                               style: Styles.mediumText(
//                                   color: AppColors.GREY_NORMAL_COLOR),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Tab(
//                         child: Row(
//                           children: [
//                             Image.asset(
//                               Assets.heart,
//                               height: 60.h,
//                               width: 60.w,
//                             ),
//                             Text(
//                               '100',
//                               style: Styles.mediumText(
//                                   color: AppColors.GREY_NORMAL_COLOR),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Tab(
//                         child: Row(
//                           children: [
//                             Image.asset(
//                               Assets.haha,
//                               height: 60.h,
//                               width: 60.w,
//                             ),
//                             Text(
//                               '100',
//                               style: Styles.mediumText(
//                                   color: AppColors.GREY_NORMAL_COLOR),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Tab(
//                         child: Row(
//                           children: [
//                             Image.asset(
//                               Assets.sad,
//                               height: 60.h,
//                               width: 60.w,
//                             ),
//                             Text(
//                               '100',
//                               style: Styles.mediumText(
//                                   color: AppColors.GREY_NORMAL_COLOR),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Tab(
//                         child: Row(
//                           children: [
//                             Image.asset(
//                               Assets.angry,
//                               height: 60.h,
//                               width: 60.w,
//                             ),
//                             Text(
//                               '100',
//                               style: Styles.mediumText(
//                                   color: AppColors.GREY_NORMAL_COLOR),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Tab(
//                         child: Row(
//                           children: [
//                             Image.asset(
//                               Assets.wow,
//                               height: 60.h,
//                               width: 60.w,
//                             ),
//                             Text(
//                               '100',
//                               style: Styles.mediumText(
//                                   color: AppColors.GREY_NORMAL_COLOR),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Expanded(
//                     child: TabBarView(
//                       children: [
//                         ListView.separated(
//                           itemBuilder: (context,index)=>Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               ClickableWidget(
//                                 onTap: () {
//                                   if (widget.fromProfile == false) {
//                                     context.push(Routes.OTHERSACCOUNT,
//                                         extra: state.posts![index].likedUsers![index].id);
//                                   }
//                                 },
//                                 child: Stack(
//                                   alignment: AlignmentDirectional.bottomEnd,
//                                   children: [
//                                     ImageFromInternet(
//                                       image: state.posts![index].likedUsers![index].image ?? '',
//                                       isCircle: true,
//                                       width: 90.w,
//                                       height: 90.h,
//                                     ),
//                                     CircleAvatar(
//                                       radius: 25.r,
//                                       backgroundColor:
//                                       Theme.of(context).scaffoldBackgroundColor,
//                                       child: Image.asset(
//                                         Assets.like,
//                                         height: 40.h,
//                                         width: 40.w,
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               const Sizer(),
//                               ClickableWidget(
//                                 onTap: () {
//                                   if (widget.fromProfile == false) {
//                                     context.push(Routes.OTHERSACCOUNT,
//                                         extra: state.posts![index].likedUsers![index].id);
//                                   }
//                                 },
//                                 child: Text(
//                                   '${state.posts![index].likedUsers![index].firstName} ${state.posts![index].likedUsers![index].lastName}',
//                                   style: Styles.headerText(fontSize: 65.sp),
//                                 ),
//                               ),
//                               const Sizer(),
//                             ],
//                           ),
//                           separatorBuilder: (context,index)=>Sizer(),
//                           itemCount: 2,
//                         ),
//                         Center(child: Text('Likes Reactions')),
//                         Center(child: Text('Hearts Reactions')),
//                         Center(child: Text('Haha Reactions')),
//                         Center(child: Text('Haha Reactions')),
//                         Center(child: Text('Haha Reactions')),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     ),
//   );
// }
}
