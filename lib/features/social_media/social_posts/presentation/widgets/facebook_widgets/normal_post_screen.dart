import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/pages/image_gallary_viewer.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/show_all_images.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/build_with_users.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/widgets/stateless/labels/read_more_label.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../domain/entities/post_entity.dart';

class NormalPostScreen extends StatelessWidget {
  NormalPostScreen({super.key, required this.postEntity});

  final PostEntity postEntity;

  // void _openImageGallery(BuildContext context, int initialIndex) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Dialog(
  //         insetPadding: EdgeInsets.zero,
  //         child: SizedBox(
  //           height: MediaQuery.of(context).size.height,
  //           width: MediaQuery.of(context).size.width,
  //           child: Column(
  //             children: [
  //               AppBar(
  //                 backgroundColor: Colors.transparent,
  //                 elevation: 0,
  //                 actions: [
  //                   IconButton(
  //                     icon: const Icon(Icons.close, color: Colors.white),
  //                     onPressed: () => Navigator.of(context).pop(),
  //                   ),
  //                 ],
  //               ),
  //               Expanded(
  //                 child: PageView.builder(
  //                   itemCount: imageUrls.length,
  //                   controller: PageController(initialPage: initialIndex),
  //                   itemBuilder: (context, index) {
  //                     return CachedNetworkImage(
  //                       imageUrl: imageUrls[index],
  //                       fit: BoxFit.contain,
  //                       placeholder: (context, url) =>
  //                           const Center(child: CircularProgressIndicator()),
  //                       errorWidget: (context, url, error) =>
  //                           const Icon(Icons.error),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildImageGrid(BuildContext context,List<String> media) {
    if (media.length == 1) {
      return GestureDetector(
        onTap: () {
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
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );
    } else if (media.length == 2) {
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (){
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
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ShowAllImages(
                            images: [],
                            imagesUrls: media,
                            onRemoveImage: (image) {
                            },
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // if (postEntity.user != null && postEntity.user.image != null)
              ImageFromInternet(
                image: postEntity.user.image??'',
                isCircle: true,
                defaultLogo: false,
                width: 80.w,
                height: 80.h,
              ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(text: TextSpan(children: [
                    TextSpan(
                        text: '${postEntity.user.firstName} ${postEntity.user.lastName}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.PRIMARY_COLOR)),
                    if(
                    (postEntity.activity!=null&&(postEntity.activity?.id.isNotEmpty??false))
                        ||(postEntity.feeling!=null&&(postEntity.feeling?.id.isNotEmpty??false))
                        ||(postEntity.location!=null&&(postEntity.location?.place.isNotEmpty??false))
                    )
                      const WidgetSpan(child: Icon(Icons.remove)),

                    if(postEntity.feeling!=null&&(postEntity.feeling?.id.isNotEmpty??false))TextSpan(
                      children: [
                        WidgetSpan(child:

                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(postEntity.feeling?.image??''),
                          // child: Label(
                          //   text: item.image,
                          //   style: Styles.mediumText(),
                          // ),
                        )),
                        const WidgetSpan(child: SizedBox(width: 5,)),
                        TextSpan(
                            text: LocaleKeys.feeling.localize,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.PRIMARY_COLOR)
                        ),
                        const WidgetSpan(child: SizedBox(width: 5,)),
                        TextSpan(
                            text: context.isArabic?postEntity.feeling?.name??'':postEntity.feeling?.nameEn??'',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.PRIMARY_COLOR)
                        )
                      ],
                    ),

                    if(postEntity.activity!=null&&(postEntity.activity?.id.isNotEmpty??false))TextSpan(
                      children: [
                        WidgetSpan(child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(postEntity.activity?.mainActivity?.image??''),
                          // child: Label(
                          //   text: item.image,
                          //   style: Styles.mediumText(),
                          // ),
                        )),
                        const WidgetSpan(child: SizedBox(width: 5,)),
                        TextSpan(
                            text: context.isArabic?postEntity.activity?.mainActivity?.name??'':postEntity.activity?.mainActivity?.nameEn??'',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.PRIMARY_COLOR)
                        ),
                        const WidgetSpan(child: SizedBox(width: 5,)),
                        TextSpan(
                            text: context.isArabic?postEntity.activity?.name??'':postEntity.activity?.nameEn??'',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.PRIMARY_COLOR)
                        )
                      ],
                    ),
                    if(postEntity.users != null &&
                        (postEntity.users?.isNotEmpty??false))TextSpan(
                        children: [
                          const WidgetSpan(child: Sizer()),
                          TextSpan(text: LocaleKeys.withKey.localize,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.GREY_DARK_COLOR)),
                          const WidgetSpan(child: Sizer()),
                          WidgetSpan(child: ClickableWidget(
                              onTap: (){
                                context.push(Routes.OTHERSACCOUNT,
                                    extra: postEntity.users?[0].id??'');
                              },
                              child: Text("${postEntity.users?.first.firstName??''} ${postEntity.users?.first.lastName??''}",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.PRIMARY_COLOR)))),
                          if((postEntity.users?.length??0)>1)WidgetSpan(child: ClickableWidget(
                              onTap: (){
                                showDialog(
                                    context: context,
                                    builder: (_) => BuildWithUsers(
                                      users: postEntity.users??[],
                                    ));
                                // sheetController.collapse();
                                // bottomSheet(
                                //     isScrollControlled: true,
                                //     context: context,
                                //     widget: BuildSearchFriends(
                                //       controller: context.read<CreatePostCubit>(),
                                //       onSelectUser: (user) => context
                                //           .read<CreatePostCubit>()
                                //           .selectUsers(user),
                                //     ));
                              },
                              child: Text( context.isArabic? "و ${(postEntity.users?.length??0)-1} أخرين": " and ${(postEntity.users?.length??0)-1} others", style: const TextStyle(fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.LIGHT_BLUE))))
                        ]
                    ),
                    if(postEntity.location != null &&
                        (postEntity.location?.place.isNotEmpty??false))TextSpan(
                        children: [
                          const WidgetSpan(child: Sizer()),
                          TextSpan(text: context.isArabic?'في':'at',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.GREY_DARK_COLOR)),
                          const WidgetSpan(child: Sizer()),
                          TextSpan(text: postEntity.location?.place??'',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.PRIMARY_COLOR))
                        ]
                    ),
                  ])),

                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: postEntity.sinceTime,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: AppColors.PRIMARY_COLOR)),
                    WidgetSpan(
                      child: SizedBox(width: 6.w),
                    ),
                    const WidgetSpan(
                        child: Icon(
                      Icons.group,
                      size: 14,
                      color: AppColors.PRIMARY_COLOR,
                    ))
                  ]))
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),

        // if (postEntity.images?.isNotEmpty??false)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ReadMoreLabel(
                  text: postEntity.content??'',
                  // textAlign: isArabic(content) ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black),
                ),
              ),
              if(postEntity.images!=null&&postEntity.images!.isNotEmpty)SizedBox(
                height: 256,
                width: double.infinity,
                child: _buildImageGrid(context,postEntity.images??[]),
              ),
            ],
          ),

        // GestureDetector(
        //   onTap: () {
        //     if (imageUrls.length > 3) {
        //       _openImageGallery(context);
        //     }
        //   },
        //   child: Column(
        //     children: [
        //       const Padding(
        //         padding: EdgeInsets.symmetric(horizontal: 10),
        //         child: Text("Lorem ipsum dolor sit amet consectetur. Ac diam curabitur accumsan commodo a et sit neque nullam. Fermentum see more"),
        //       ),
        //       Container(
        //         height: 256,
        //         width: double.infinity,
        //         child: imageUrls.length == 1
        //             ? CachedNetworkImage(
        //           imageUrl: imageUrls[0],
        //           fit: BoxFit.cover,
        //           placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        //           errorWidget: (context, url, error) => const Icon(Icons.error),
        //         )
        //             : (imageUrls.length == 2
        //             ? Row(
        //           children: [
        //             Expanded(child: CachedNetworkImage(imageUrl: imageUrls[0], fit: BoxFit.cover,
        //               height: double.infinity, // This ensures the image takes full available height
        //             )),
        //             const SizedBox(width: 3),
        //             Expanded(child: CachedNetworkImage(imageUrl: imageUrls[1], fit: BoxFit.cover,
        //               height: double.infinity, // This ensures the image takes full available height
        //             )),
        //           ],
        //         )
        //             : (imageUrls.length == 3
        //             ? Row(
        //           children: [
        //             // Full-sized image (takes up most of the width)
        //             Expanded(
        //               flex: 2, // The flex value determines how much space the image occupies
        //               child: CachedNetworkImage(
        //                 imageUrl: imageUrls[0],
        //                 fit: BoxFit.cover,
        //                 width: double.infinity, // This makes the image take the full width of the parent
        //                 height: 256, // Set the desired height for the full image
        //                 placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        //                 errorWidget: (context, url, error) => Icon(Icons.error),
        //               ),
        //             ),
        //             const SizedBox(width: 3.5), // Spacing between the images
        //             // Column for the two other images, taking full height of the single image
        //             Column(
        //               children: [
        //                 // First image in column, taking half of the height
        //                 Expanded(
        //                   child: CachedNetworkImage(
        //                     imageUrl: imageUrls[1],
        //                     fit: BoxFit.cover,
        //                     width: 150, // Set a fixed width for the images in the column
        //                     height: double.infinity, // This ensures the image takes full available height
        //                     placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        //                     errorWidget: (context, url, error) => Icon(Icons.error),
        //                   ),
        //                 ),
        //                 const SizedBox(height: 3), // Spacing between the images in the column
        //                 // Second image in column, taking the remaining half of the height
        //                 Expanded(
        //                   child: CachedNetworkImage(
        //                     imageUrl: imageUrls[2],
        //                     fit: BoxFit.cover,
        //                     width: 150, // Fixed width for the second image in the column
        //                     height: double.infinity, // Ensures the second image takes the full remaining height
        //                     placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        //                     errorWidget: (context, url, error) => Icon(Icons.error),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ],
        //         )
        //             : Row(
        //           children: [
        //             // Full-sized image (takes up most of the width)
        //             Expanded(
        //               flex: 2, // The flex value determines how much space the image occupies
        //               child: CachedNetworkImage(
        //                 imageUrl: imageUrls[0],
        //                 fit: BoxFit.cover,
        //                 width: double.infinity, // This makes the image take the full width of the parent
        //                 height: 256, // Set the desired height for the full image
        //                 placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        //                 errorWidget: (context, url, error) => Icon(Icons.error),
        //               ),
        //             ),
        //             const SizedBox(width: 3.5), // Spacing between the images
        //             // Column for the two other images, taking full height of the single image
        //             Expanded(
        //               flex: 1, // Take up the remaining space
        //               child: Column(
        //                 children: [
        //                   // First image in column, taking half of the height
        //                   Expanded(
        //                     child: CachedNetworkImage(
        //                       imageUrl: imageUrls[1],
        //                       fit: BoxFit.cover,
        //                       width: double.infinity, // Ensures the image takes the full width
        //                       height: double.infinity, // Ensures the image takes full available height
        //                       placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        //                       errorWidget: (context, url, error) => Icon(Icons.error),
        //                     ),
        //                   ),
        //                   const SizedBox(height: 3), // Spacing between the images in the column
        //                   // Stack for the second image in column, also taking full available height
        //                   Expanded(
        //                     child: Stack(
        //                       children: [
        //                         Positioned.fill(
        //                           child: CachedNetworkImage(
        //                             imageUrl: imageUrls[2],
        //                             fit: BoxFit.cover,
        //                             width: double.infinity, // Ensures the image takes the full width
        //                             height: double.infinity, // Ensures the image takes full available height
        //                             placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        //                             errorWidget: (context, url, error) => Icon(Icons.error),
        //                           ),
        //                         ),
        //                         // If there are more than 3 images, show the "+x" label
        //                         if (imageUrls.length > 3)
        //                           Container(
        //                             color: Colors.black54,
        //                             height: double.infinity, // Ensures the image takes full available height
        //                             width: double.infinity,
        //                             child: Center(
        //                               child: Text(
        //                                 "+${imageUrls.length - 3}",
        //                                 style: const TextStyle(
        //                                   color: Colors.white,
        //                                   fontSize: 20,
        //                                   fontWeight: FontWeight.bold,
        //                                 ),
        //                               ),
        //                             ),
        //                           ),
        //                       ],
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ],
        //         )
        //
        //         )),
        //       ),
        //     ],
        //   ),
        // ),
        const SizedBox(height: 12),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 14, // Adjust position for overlap
                    child: Image.asset(
                      Assets.loveReact,
                      width: 20, // Set a fixed width
                      height: 20, // Set a fixed height
                    ),
                  ),
                  Image.asset(
                    Assets.likeReact,
                    width: 20, // Set a fixed width to ensure it's not cut off
                    height: 20, // Set a fixed height to match the other image
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Increased space between reactions and text
              const Label(
                text: "Claude-Arthur Mbonzi And 276 Others",
                style: TextStyle(
                  color: AppColors.c46484B,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10.0),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // Align the items to the start
            children: [
              // Like button
              Row(
                children: [
                  SvgPicture.asset(Assets.likeIcon), // Like Icon
                  SizedBox(width: 4.w), // Space between icon and text
                  Label(
                    text: LocaleKeys.like.localize,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ), // Like Text
                ],
              ),
              const SizedBox(width: 16), // Space between buttons

              // Comment button
              Row(
                children: [
                  SvgPicture.asset(Assets.commentIcon), // Comment Icon
                  SizedBox(width: 4.w), // Space between icon and text
                  Label(
                    text: LocaleKeys.comment.localize,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ), // Comment Text
                ],
              ),
              const SizedBox(width: 16), // Space between buttons

              // Send button
              Row(
                children: [
                  SvgPicture.asset(Assets.sendIcon), // Send Icon
                  SizedBox(width: 4.w), // Space between icon and text
                  Label(
                    text: LocaleKeys.send.localize,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ), // Send Text
                ],
              ),
              const SizedBox(width: 16), // Space between buttons

              // Share button
              Row(
                children: [
                  SvgPicture.asset(Assets.shareIcon), // Share Icon
                  SizedBox(width: 4.w), // Space between icon and text
                  Label(
                    text: LocaleKeys.share.localize,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ), // Share Text
                ],
              ),
            ],
          ),
        )
      ],
    );

    // User profile and post header
    // Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 16),
    //   child: Row(
    //     children: [
    //       if (postEntity.user?.image != null)
    //         CircleAvatar(
    //           backgroundImage: NetworkImage(postEntity.user!.image!),
    //           radius: 40.w,
    //         ),
    //       const SizedBox(width: 10.0),
    //       const Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             "", // User name or other details
    //             style: TextStyle(
    //                 fontWeight: FontWeight.w600,
    //                 fontSize: 16,
    //                 color: Colors.blue), // Use your color here
    //           ),
    //           Row(
    //             children: [
    //               Icon(
    //                 Icons.group,
    //                 size: 14,
    //                 color: Colors.blue,
    //               ),
    //               SizedBox(width: 6),
    //               Text(
    //                 "Claude-Arthur Mbonzi and 276 Others",
    //                 style: TextStyle(color: Colors.black, fontSize: 14),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // ),
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // User profile and post header

          Row(
            children: [
              if (postEntity.user != null && postEntity.user.image != null)
                ImageFromInternet(
                  image: postEntity.user.image??'',
                  isCircle: true,
                  defaultLogo: false,
                  width: 80.w,
                  height: 80.h,
                ),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Label(
                    text: "",
                    // text: postEntity.user.firstName ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.PRIMARY_COLOR),
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: postEntity.sinceTime,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: AppColors.PRIMARY_COLOR)),
                    WidgetSpan(
                      child: SizedBox(width: 6.w),
                    ),
                    const WidgetSpan(
                        child: Icon(
                      Icons.group,
                      size: 14,
                      color: AppColors.PRIMARY_COLOR,
                    ))
                  ]))
                ],
              ),
            ],
          ),
          const SizedBox(height: 10.0),

          // Post content
          ReadMoreLabel(
            text: postEntity.content!,
            // textAlign: isArabic(content) ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.black),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 14, // Adjust position for overlap
                    child: Image.asset(
                      Assets.loveReact,
                      width: 20, // Set a fixed width
                      height: 20, // Set a fixed height
                    ),
                  ),
                  Image.asset(
                    Assets.likeReact,
                    width: 20, // Set a fixed width to ensure it's not cut off
                    height: 20, // Set a fixed height to match the other image
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Increased space between reactions and text
              const Label(
                text: "Claude-Arthur Mbonzi And 276 Others",
                style: TextStyle(
                  color: AppColors.c46484B,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10.0),

          // Post interactions (like, comment, share)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // Align the items to the start
            children: [
              // Like button
              Row(
                children: [
                  SvgPicture.asset(Assets.likeIcon), // Like Icon
                  SizedBox(width: 4.w), // Space between icon and text
                  Label(
                    text: LocaleKeys.like.localize,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ), // Like Text
                ],
              ),
              const SizedBox(width: 16), // Space between buttons

              // Comment button
              Row(
                children: [
                  SvgPicture.asset(Assets.commentIcon), // Comment Icon
                  SizedBox(width: 4.w), // Space between icon and text
                  Label(
                    text: LocaleKeys.comment.localize,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ), // Comment Text
                ],
              ),
              const SizedBox(width: 16), // Space between buttons

              // Send button
              Row(
                children: [
                  SvgPicture.asset(Assets.sendIcon), // Send Icon
                  SizedBox(width: 4.w), // Space between icon and text
                  Label(
                    text: LocaleKeys.send.localize,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ), // Send Text
                ],
              ),
              const SizedBox(width: 16), // Space between buttons

              // Share button
              Row(
                children: [
                  SvgPicture.asset(Assets.shareIcon), // Share Icon
                  SizedBox(width: 4.w), // Space between icon and text
                  Label(
                    text: LocaleKeys.share.localize,
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ), // Share Text
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
