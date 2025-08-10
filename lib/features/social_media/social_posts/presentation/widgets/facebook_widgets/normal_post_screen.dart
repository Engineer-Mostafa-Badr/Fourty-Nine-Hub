import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../../../../core/extensions/numbers_extensions.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../core/widget/clickable_widget.dart';
import '../../../../../ads_feature/ad_details/presentation/pages/image_gallary_viewer.dart';
import '../../../../create_post/presentation/widgets/show_all_images.dart';
import '../../../domain/usecases/add_reply_usecase.dart';
import '../../../domain/usecases/post_comment_usecase.dart';
import '../../cubit/social_posts_cubit.dart';
import 'build_facebook_header.dart';
import 'build_reactions_buttons.dart';
import 'image_from_internet.dart';
import '../posts/facebook_post_comments.dart';
import '../../../../../../service_locator/service_locator.dart';
import '../../../../../../core/widget/custom_circular_progress_indicator.dart';

import '../../../../../../common/widgets/stateless/labels/read_more_label.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../../../../helpers/manage_vibration.dart';

class NormalPostScreen extends StatelessWidget {
  const NormalPostScreen({
    super.key,
    required this.postEntity,
  });

  final PostEntity postEntity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: AppColors.getFindFillColor(context), width: 6)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            child: BuildFacebookHeader(
              user: postEntity.user,
              sinceTime:
             context.isArabic
                  ? DateFormat('d MMM, h:mm a', 'ar')
                      .format(postEntity.createdAt!)
                  : DateFormat('MMM d, h:mm a').format(postEntity.createdAt!),
              activity: postEntity.activity,
              feeling: postEntity.feeling,
              users: postEntity.users,
              location: postEntity.location,
            ),
          ),
          // const SizedBox(height: 8.0),

          // if (postEntity.images?.isNotEmpty??false)
          Column(
            children: [
              if (postEntity.content?.isNotEmpty ?? false)
                Padding(
                  padding:
                      const EdgeInsets.only(right: 10, left: 10, bottom: 16),
                  child: ReadMoreLabel(
                    text: postEntity.content ?? '',
                    // textAlign: isArabic(content) ? TextAlign.right : TextAlign.left,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.getTextColor(context)),
                  ),
                ),
              // if(postEntity.type=="live_event_post")FacebookLifeEventWidget(postEntity: postEntity,),
              if (postEntity.type == "gif_post" &&
                  postEntity.gifUrl != null &&
                  postEntity.gifUrl!.isNotEmpty)
                ImageFromInternet(
                  image: postEntity.gifUrl ?? '',
                  width: double.infinity,
                  height: 256,
                  fit: BoxFit.cover,
                ),
              if (postEntity.images.isNotEmpty &&
                  postEntity.type == "normal_post")
                SizedBox(
                  height: 256,
                  width: double.infinity,
                  child: _buildImageGrid(context, postEntity.images ?? []),
                ),
            ],
          ),
          //const SizedBox(height: 12),

          if(postEntity.totalCount!=0)Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    if(postEntity.likesCount!=0)Positioned(
                      left: 14, // Adjust position for overlap
                      child: Image.asset(
                        Assets.loveReact,
                        width: 20, // Set a fixed width
                        height: 20, // Set a fixed height
                      ),
                    ),
                    if(postEntity.loveCount!=0)Image.asset(
                      Assets.likeReact,
                      width: 20, // Set a fixed width to ensure it's not cut off
                      height: 20, // Set a fixed height to match the other image
                    ),
                    if(postEntity.wowCount!=0)Image.asset(
                      Assets.wowReaction,
                      width: 20, // Set a fixed width to ensure it's not cut off
                      height: 20, // Set a fixed height to match the other image
                    ),
                    if(postEntity.hahaCount!=0)Image.asset(
                      Assets.hahaReaction,
                      width: 20, // Set a fixed width to ensure it's not cut off
                      height: 20, // Set a fixed height to match the other image
                    ),
                    if(postEntity.sadCount!=0)Image.asset(
                      Assets.sadReaction,
                      width: 20, // Set a fixed width to ensure it's not cut off
                      height: 20, // Set a fixed height to match the other image
                    ),
                    if(postEntity.angryCount!=0)Image.asset(
                      Assets.angryReaction,
                      width: 20, // Set a fixed width to ensure it's not cut off
                      height: 20, // Set a fixed height to match the other image
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Increased space between reactions and text
                Label(
                  text:postEntity.totalCount.toString().toArabicNumbers(context)??'',
                     // "Claude-Arthur Mbonzi ${context.isArabic ? 'و' : 'and'} 276 ${context.isArabic ? 'اخرين' : 'Others'}",
                  style: TextStyle(
                    color: context.isDarkMode
                        ? Colors.grey[300]
                        : Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // Align the items to the start
              children: [
                // Like button
                // Row(
                //   children: [
                //     SvgPicture.asset(Assets.likeIcon), // Like Icon
                //     SizedBox(width: 4.w), // Space between icon and text
                //     Label(
                //       text: LocaleKeys.like.localize,
                //       style: const TextStyle(
                //           color: AppColors.black,
                //           fontSize: 14,
                //           fontWeight: FontWeight.w400),
                //     ), // Like Text
                //   ],
                // ),
                SizedBox(
                  child: BuildReactionsButtons(
                    post: postEntity,
                    from: "posts",
                  ),
                ),
                const SizedBox(width: 16), // Space between buttons

                // Comment button
                ClickableWidget(
                  onTap: () {
                    print("postEntity.id ${postEntity.id}");
      ManageVibration.vibrate();
                    bottomSheet(
                        context: context,
                        isScrollControlled: true,
                        widget: BlocProvider.value(
                          value: serviceLocator<SocialPostsCubit>()
                            ..loadPostCommentsData(
                                context: context, postId: postEntity.id),
                          child: FacebookPostComments(
                            postId: postEntity.id,
                            onAddComment: (PostCommentParams params) {
                              return context.read<SocialPostsCubit>().onPostComment(
                                  params: params, from: 'feed');
                            },
                            onCommentReply: (ReplyOnCommentParams params) {
                              return context.read<SocialPostsCubit>().replyOnComment(
                                params: ReplyOnCommentParams(
                                    postId: params.postId,
                                    content: params.content,
                                    commentId:
                                    params.commentId),
                                from: 'feed',
                              );
                            },
                            onDeleteComment: (String id) async {
                              return await context.read<SocialPostsCubit>()
                                  .deleteComment(
                                  context: context,
                                  commentId: id,
                                  postId: postEntity.id,
                                  from: 'feed');
                              // print(result);
                            },
                            onDeleteReply: (String id) async {
                              return await context.read<SocialPostsCubit>()
                                  .deleteComment(
                                  context: context,
                                  commentId: id,
                                  postId: postEntity.id,
                                  from: 'feed');
                            },
                            from: 'feed',
                            onEditComment: (PostCommentParams params) async {
                              var result = await context.read<SocialPostsCubit>()
                                  .editComment(params: params);
                              return result;
                            },
                          ),
                        ));
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(Assets.commentIcon,
                          color: context.isDarkMode ? Colors.white : null),
                      // Comment Icon
                      SizedBox(width: 8.w),
                      // Space between icon and text
                      Label(
                        text: LocaleKeys.comment.localize,
                        style: TextStyle(
                            color: AppColors.getTextColor(context),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      // Comment Text
                    ],
                  ),
                ),
                const SizedBox(width: 16), // Space between buttons

                // Send button
                Row(
                  children: [
                    SvgPicture.asset(
                      Assets.sendIcon,
                      color: context.isDarkMode ? Colors.white : null,
                    ),
                    // Send Icon
                    SizedBox(width: 8.w),
                    // Space between icon and text
                    Label(
                      text: LocaleKeys.send.localize,
                      style: TextStyle(
                          color: AppColors.getTextColor(context),
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    // Send Text
                  ],
                ),
                const SizedBox(width: 16), // Space between buttons

                // Share button
                Row(
                  children: [
                    SvgPicture.asset(Assets.shareIcon,
                        color: context.isDarkMode ? Colors.white : null),
                    // Share Icon
                    SizedBox(width: 8.w),
                    // Space between icon and text
                    Label(
                      text: LocaleKeys.share.localize,
                      style: TextStyle(
                          color: AppColors.getTextColor(context),
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    // Share Text
                  ],
                ),
              ],
            ),
          ),
          const Sizer(),
        ],
      ),
    );
  }

  Widget _buildImageGrid(BuildContext context, List<String> media) {
    if (media.length == 1) {
      return GestureDetector(
        onTap: () {
      ManageVibration.vibrate();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageGalleryPage(
                images: media,
                initialIndex: 0,
              ),
            ),
          );
        },
        child: CachedNetworkImage(
          imageUrl: media[0],
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              const Center(child: CustomCircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );
    } else if (media.length == 2) {
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
      ManageVibration.vibrate();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageGalleryPage(
                      images: media,
                      initialIndex: 0,
                    ),
                  ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: media[0],
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ),
          ),
          const SizedBox(width: 3),
          Expanded(
            child: GestureDetector(
              onTap: () {
      ManageVibration.vibrate();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageGalleryPage(
                      images: media,
                      initialIndex: 1,
                    ),
                  ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: media[1],
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ),
          ),
        ],
      );
    } else if (media.length == 3) {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
      ManageVibration.vibrate();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageGalleryPage(
                      images: media,
                      initialIndex: 0,
                    ),
                  ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: media[0],
                fit: BoxFit.cover,
                height: 256,
              ),
            ),
          ),
          const SizedBox(width: 3.5),
          Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
      ManageVibration.vibrate();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageGalleryPage(
                          images: media,
                          initialIndex: 1,
                        ),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: media[1],
                    fit: BoxFit.cover,
                    width: 150,
                    height: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Expanded(
                child: GestureDetector(
                  onTap: () {
      ManageVibration.vibrate();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageGalleryPage(
                          images: media,
                          initialIndex: 2,
                        ),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: media[2],
                    fit: BoxFit.cover,
                    width: 150,
                    height: double.infinity,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
      ManageVibration.vibrate();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageGalleryPage(
                      images: media,
                      initialIndex: 0,
                    ),
                  ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: media[0],
                fit: BoxFit.cover,
                height: 256,
              ),
            ),
          ),
          const SizedBox(width: 3.5),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
      ManageVibration.vibrate();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageGalleryPage(
                            images: media,
                            initialIndex: 1,
                          ),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: media[1],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
      ManageVibration.vibrate();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ShowAllImages(
                            images: [],
                            imagesUrls: media,
                            onRemoveImage: (image) {},
                          );
                        },
                      );
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: media[2],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        if (media.length > 3)
                          Container(
                            color: Colors.black54,
                            child: Center(
                              child: Text(
                                "+${media.length - 3}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}