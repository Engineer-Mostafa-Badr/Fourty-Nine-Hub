import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_cubit.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_state.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/widget/olx_pagination/banner.dart';
import '../../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import '../../../account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import '../../../social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
import '../custom_video_player.dart';
import 'talent_video_player.dart';

class GetAllTalents extends StatelessWidget {
  final bool isMyTalent;
  final ScrollController? scrollController;

  const GetAllTalents(
      {super.key, this.scrollController, this.isMyTalent = false});

  // final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<StarCubit, StarState>(
        builder: (context, state) {
          var cubit = context.read<StarCubit>();
          if (cubit.loadAllTalents) {
            return const Center(child: CustomCircularProgressIndicator());
          }

          if (state.status == StarStates.error) {
            return Center(
              // child: Text('Error: ${_getErrorMessage(state.failure)}'),
              child: Text('Error: ${state.failure}'),
            );
          }

          if (cubit.allTalents.isEmpty) {
            return CustomEmptyWidget(
              label: LocaleKeys.noResultsFound.localize,
            );
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.61,
            child: OlxPaginationWidget(
              scrollController: scrollController ?? ScrollController(),
              itemsPerPage: 1,
              loadPage: (page) => cubit.getAllTalent(),
              banners: bannersList,
              items: List.generate(
                cubit.allTalents.length +
                    (state.status == StarStates.loading ? 1 : 0),
                (index) {
                  if (index == cubit.allTalents.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomCircularProgressIndicator(),
                      ),
                    );
                  }

                  final talent = cubit.allTalents[index];
                  final user = talent.user;
                  final mediaUrl = talent.mediaUrl.isNotEmpty
                      ? talent.mediaUrl.first.mediaKey
                      : '';
                  final createdAt = talent.createdAt ?? DateTime.now();
                  final isVideo = mediaUrl.toLowerCase().contains('.mp4') ||
                      mediaUrl.toLowerCase().contains('.mov') ||
                      mediaUrl.toLowerCase().contains('.avi');
                  return Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          GestureDetector(
                            onTap: isVideo
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TalentVideoPlayer(
                                          videoUrl: mediaUrl,
                                          talent: talent,
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            child: isVideo
                                ? SizedBox(
                                    height: 200,
                                    child: CustomVideoPlayer(
                                      videoUrl: mediaUrl,
                                      title: 'test',
                                    ),
                                  )
                                // TalentVideo(
                                //         path: mediaUrl,
                                //       )
                                : Container(
                                    height: 300.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      // borderRadius: BorderRadius.circular(12),
                                      image: mediaUrl.isNotEmpty
                                          ? DecorationImage(
                                              image: NetworkImage(mediaUrl),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    // child:
                                    // mediaUrl.isEmpty
                                    //     ?
                                    //     const Center(
                                    //   child: Icon(Icons.image_not_supported, size: 50),
                                    // )
                                    // :
                                    // _buildMediaContent(context, mediaUrl, isVideo),
                                  ),
                          ),
                          // isVideo
                          //     ? Padding(
                          //         padding: const EdgeInsets.only(
                          //             right: 16.0,
                          //             top: 8.0,
                          //             bottom: 8.0,
                          //             left: 8.0),
                          //         child: Container(
                          //           padding: const EdgeInsets.symmetric(
                          //             horizontal: 8,
                          //             vertical: 4,
                          //           ),
                          //           decoration: BoxDecoration(
                          //             color: Colors.black.withOpacity(0.7),
                          //             borderRadius: BorderRadius.circular(4),
                          //           ),
                          //           child: Text(
                          //             talent.totalViews.toString(),
                          //             style: const TextStyle(
                          //               color: Colors.white,
                          //               fontSize: 12,
                          //             ),
                          //           ),
                          //         ),
                          //       )
                          //     : const SizedBox(),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //     top: 8.0,
                            //     bottom: 8.0,
                            //     left: 16.0,
                            //   ),
                            //   child: CircleAvatar(
                            //     radius: 45.r,
                            //     backgroundImage: user.image.isNotEmpty
                            //         ? CachedNetworkImageProvider(user.image)
                            //         : null,
                            //   ),
                            // ),
                            SizedBox(
                              width: 32,
                              height: 32,
                              child: ProfileWithStoriesBorder(
                                profilePictureUrl: talent.user.image ?? '',
                                storiesCount: talent.storyCount ?? 0,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    talent.title,
                                    style: TextStyle(
                                      fontSize: 28.sp,
                                      color: context.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${context.isArabic ? convertToArabicNumbers(talent.totalViews.toShortScale) : talent.totalViews.toShortScale} ${LocaleKeys.views.localize} • ${context.isArabic ? convertToArabicNumbers(timeago.format(createdAt, locale: context.locale.languageCode)) : timeago.format(createdAt, locale: context.locale.languageCode)}",
                                    style: TextStyle(
                                      fontSize: 26.sp,
                                      color: context.isDarkMode
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ...List.generate(
                              5,
                              (index) => Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Image.asset(
                                  index < talent.averageRating.floor()
                                      ? "assets/49-New-icons/star_gold.png"
                                      : "assets/49-New-icons/star.png",
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (isMyTalent)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              showAreYouSure(
                                context: context,
                                title: LocaleKeys.alert.localize,
                                subTitle: LocaleKeys.remove.localize,
                                action: () {
                                  context.read<StarCubit>().deleteMyTalent(
                                        id: talent.id,
                                      );
                                  Navigator.pop(context);
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 70.h),
                              backgroundColor: Colors.red,
                            ),
                            child: Text(
                              LocaleKeys.delete_talent.localize,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),
            ),
          );
          /*return ListView.builder(
            controller: scrollController,
            itemCount: cubit.allTalents.length +
                (state.status == StarStates.loading ? 1 : 0),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index == cubit.allTalents.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CustomCircularProgressIndicator(),
                  ),
                );
              }

              final talent = cubit.allTalents[index];
              final user = talent.user;
              final mediaUrl = talent.mediaUrl.isNotEmpty
                  ? talent.mediaUrl.first.mediaKey
                  : '';
              final createdAt = talent.createdAt ?? DateTime.now();
              final isVideo = mediaUrl.toLowerCase().contains('.mp4') ||
                  mediaUrl.toLowerCase().contains('.mov') ||
                  mediaUrl.toLowerCase().contains('.avi');
              return Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: isVideo
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TalentVideoPlayer(
                                      videoUrl: mediaUrl,
                                      talent: talent,
                                    ),
                                  ),
                                );
                              }
                            : null,
                        child: isVideo
                            ? SizedBox(
                                height: 200,
                                child: CustomVideoPlayer(
                                  videoUrl: mediaUrl,
                                  title: 'test',
                                ),
                              )
                            // TalentVideo(
                            //         path: mediaUrl,
                            //       )
                            : Container(
                                height: 300.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  // borderRadius: BorderRadius.circular(12),
                                  image: mediaUrl.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(mediaUrl),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                // child:
                                // mediaUrl.isEmpty
                                //     ?
                                //     const Center(
                                //   child: Icon(Icons.image_not_supported, size: 50),
                                // )
                                // :
                                // _buildMediaContent(context, mediaUrl, isVideo),
                              ),
                      ),
                      // isVideo
                      //     ? Padding(
                      //         padding: const EdgeInsets.only(
                      //             right: 16.0,
                      //             top: 8.0,
                      //             bottom: 8.0,
                      //             left: 8.0),
                      //         child: Container(
                      //           padding: const EdgeInsets.symmetric(
                      //             horizontal: 8,
                      //             vertical: 4,
                      //           ),
                      //           decoration: BoxDecoration(
                      //             color: Colors.black.withOpacity(0.7),
                      //             borderRadius: BorderRadius.circular(4),
                      //           ),
                      //           child: Text(
                      //             talent.totalViews.toString(),
                      //             style: const TextStyle(
                      //               color: Colors.white,
                      //               fontSize: 12,
                      //             ),
                      //           ),
                      //         ),
                      //       )
                      //     : const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //     top: 8.0,
                        //     bottom: 8.0,
                        //     left: 16.0,
                        //   ),
                        //   child: CircleAvatar(
                        //     radius: 45.r,
                        //     backgroundImage: user.image.isNotEmpty
                        //         ? CachedNetworkImageProvider(user.image)
                        //         : null,
                        //   ),
                        // ),
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: ProfileWithStoriesBorder(
                            profilePictureUrl: talent.user.image ?? '',
                            storiesCount: talent.storyCount ?? 0,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                talent.title,
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  color: context.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${context.isArabic ? convertToArabicNumbers(talent.totalViews.toShortScale) : talent.totalViews.toShortScale} ${LocaleKeys.views.localize} • ${context.isArabic ? convertToArabicNumbers(timeago.format(createdAt, locale: context.locale.languageCode)) : timeago.format(createdAt, locale: context.locale.languageCode)}",
                                style: TextStyle(
                                  fontSize: 26.sp,
                                  color: context.isDarkMode
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...List.generate(
                          5,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Image.asset(
                              index < talent.averageRating.floor()
                                  ? "assets/49-New-icons/star_gold.png"
                                  : "assets/49-New-icons/star.png",
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (isMyTalent)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          showAreYouSure(
                            context: context,
                            title: LocaleKeys.alert.localize,
                            subTitle: LocaleKeys.remove.localize,
                            action: () {
                              context.read<StarCubit>().deleteMyTalent(
                                    id: talent.id,
                                  );
                              Navigator.pop(context);
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 70.h),
                          backgroundColor: Colors.red,
                        ),
                        child: Text(
                          LocaleKeys.delete_talent.localize,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                ],
              );
            },
          );*/
        },
      ),
    );
  }

// Widget _buildMediaContent(
//     BuildContext context, String mediaUrl, bool isVideo) {
//   if (isVideo) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         // Image.network(
//         //   // Use a thumbnail or first frame if available
//         //   mediaUrl.replaceAll('.mp4', '.jpg'),
//         //   fit: BoxFit.cover,
//         //   errorBuilder: (context, error, stackTrace) {
//         //     return Container(
//         //       color: Colors.grey[300],
//         //       child: const Icon(Icons.video_library, size: 50),
//         //     );
//         //   },
//         // ),
//         IconButton(
//           icon: const Icon(
//             Icons.play_circle_fill,
//             size: 60,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => TalentVideoPlayer(videoUrl: mediaUrl),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   } else {
//     return CachedNetworkImage(
//       imageUrl: mediaUrl,
//       fit: BoxFit.cover,
//       placeholder: (context, url) => const Center(
//         child: CustomCircularProgressIndicator(),
//       ),
//       errorWidget: (context, url, error) => const Center(
//         child: Icon(Icons.error),
//       ),
//     );
//   }
// }
}

// Get All Talents
