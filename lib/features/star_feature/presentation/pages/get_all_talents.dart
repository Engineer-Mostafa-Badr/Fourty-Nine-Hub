import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_cubit.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_state.dart';
import 'package:fourtyninehub/features/star_feature/presentation/helper/youtube_style_video_player.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../core/widget/olx_pagination/banner.dart';
import '../../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import '../../../../helpers/manage_vibration.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/styles.dart';
import '../../../account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import '../../../social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
import '../../../social_media/twitter/presentation/widgets/report_view.dart';
import '../helper/talent_video_player.dart';

// class GetAllTalents extends StatelessWidget {
//   final bool isMyTalent;
//   final ScrollController scrollController;

//   const GetAllTalents(
//       {super.key, required this.scrollController, this.isMyTalent = false});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: BlocBuilder<StarCubit, StarState>(
//         builder: (context, state) {
//           var cubit = context.read<StarCubit>();
//           if (cubit.loadAllTalents) {
//             return const Center(child: CustomCircularProgressIndicator());
//           }

//           if (state.status == StarStates.error) {
//             return Center(
//               child: Text('Error: ${state.failure}'),
//             );
//           }

//           if (cubit.allTalents.isEmpty) {
//             return CustomEmptyWidget(
//               label: LocaleKeys.noResultsFound.localize,
//             );
//           }
//           return SizedBox(
//             height: MediaQuery.of(context).size.height,
//             child: OlxPaginationWidget(
//               scrollController: scrollController,
//               itemsPerPage: 1,
//               loadPage: (page) => cubit.getAllTalent(),
//               banners: bannersList,
//               items: List.generate(
//                 cubit.allTalents.length +
//                     (state.status == StarStates.loading ? 1 : 0),
//                 (index) {
//                   if (index == cubit.allTalents.length) {
//                     return const Center(
//                       child: Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: CustomCircularProgressIndicator(),
//                       ),
//                     );
//                   }

//                   final talent = cubit.allTalents[index];
//                   final user = talent.user;
//                   final mediaUrl = talent.mediaUrl.isNotEmpty
//                       ? talent.mediaUrl.first.mediaKey
//                       : '';
//                   final createdAt = talent.createdAt ?? DateTime.now();
//                   final isVideo = mediaUrl.toLowerCase().contains('.mp4') ||
//                       mediaUrl.toLowerCase().contains('.mov') ||
//                       mediaUrl.toLowerCase().contains('.avi');
//                   return Column(
//                     children: [
//                       Stack(
//                         alignment: Alignment.bottomRight,
//                         children: [
//                           GestureDetector(
//                             onTap: isVideo
//                                 ? () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => TalentVideoPlayer(
//                                           videoUrl: mediaUrl,
//                                           talent: talent,
//                                         ),
//                                       ),
//                                     );
//                                   }
//                                 : null,
//                             child: isVideo
//                                 ? YouTubeStyleVideoPlayer(
//                                     videoUrl: mediaUrl,
//                                     title: talent.title,
//                                     autoPlay: true, // Auto-play when visible
//                                     startMuted: true, // Start muted
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               TalentVideoPlayer(
//                                             videoUrl: mediaUrl,
//                                             talent: talent,
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   )
//                                 : Container(
//                                     height: 300.h,
//                                     width: double.infinity,
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey[300],
//                                       image: mediaUrl.isNotEmpty
//                                           ? DecorationImage(
//                                               image: NetworkImage(mediaUrl),
//                                               fit: BoxFit.cover,
//                                             )
//                                           : null,
//                                     ),
//                                   ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       Padding(
//                         padding: const EdgeInsetsDirectional.only(start: 16.0),
//                         child: Row(
//                           children: [
//                             SizedBox(
//                               width: 32,
//                               height: 32,
//                               child: ProfileWithStoriesBorder(
//                                 profilePictureUrl: talent.user.image ?? '',
//                                 storiesCount: talent.storyCount ?? 0,
//                               ),
//                             ),
//                             SizedBox(width: 16.w),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     talent.title,
//                                     style: TextStyle(
//                                       fontSize: 28.sp,
//                                       color: context.isDarkMode
//                                           ? Colors.white
//                                           : Colors.black,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     "${talent.user.firstName} ${talent.user.lastName} • ${context.isArabic ? convertToArabicNumbers(talent.totalViews.toShortScale) : talent.totalViews.toShortScale} ${LocaleKeys.views.localize} • ${context.isArabic ? convertToArabicNumbers(timeago.format(createdAt, locale: context.locale.languageCode)) : timeago.format(createdAt, locale: context.locale.languageCode)}",
//                                     style: TextStyle(
//                                       fontSize: 20.sp,
//                                       color: context.isDarkMode
//                                           ? Colors.white
//                                           : Colors.grey,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             ...List.generate(
//                               5,
//                               (starIndex) => GestureDetector(
//                                 onTap: () {
//                                   cubit.changeRating(talent.id, starIndex + 1);
//                                   debugPrint(
//                                       'GestureDetector onTap ${talent.averageRating}');
//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 2.0),
//                                   child: Image.asset(
//                                     starIndex < talent.averageRating
//                                         ? "assets/49-New-icons/star_gold.png"
//                                         : "assets/49-New-icons/star.png",
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 10.w),
//                             IconButton(
//                               onPressed: () {
//                                 _youtubeOptions(context, talent);
//                               },
//                               icon: Icon(
//                                 Icons.more_vert_rounded,
//                                 size: 20,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       if (isMyTalent)
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                           child: ElevatedButton(
//                             onPressed: () {
//                               showAreYouSure(
//                                 context: context,
//                                 title: LocaleKeys.alert.localize,
//                                 subTitle: LocaleKeys.remove.localize,
//                                 action: () {
//                                   context.read<StarCubit>().deleteMyTalent(
//                                         id: talent.id,
//                                       );
//                                   Navigator.pop(context);
//                                 },
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               minimumSize: Size(double.infinity, 70.h),
//                               backgroundColor: Colors.red,
//                             ),
//                             child: Text(
//                               LocaleKeys.delete_talent.localize,
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 36.sp,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ),
//                       const SizedBox(height: 8),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   _youtubeOptions(BuildContext context, StarEntity talent) {
//     bottomSheet(
//       context: context,
//       asAlertDialog: true,
//       isDismissible: true,
//       backColor: context.isDarkMode ? Color(0xff0D0D0D) : Colors.white,
//       widget: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: context.isDarkMode ? Color(0xff0D0D0D) : Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Handle indicator
//                 Container(
//                   width: 40,
//                   height: 4,
//                   margin: EdgeInsets.only(top: 8, bottom: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[400],
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),

//                 // Options list
//                 _buildOption(
//                   context: context,
//                   icon: Icons.bookmark_border,
//                   title: LocaleKeys.save.localize,
//                   onTap: () {
//                     ManageVibration.vibrate();
//                     Navigator.pop(context);
//                     // cubit.saveTalent(talent.id);
//                   },
//                 ),

//                 _buildOption(
//                   context: context,
//                   icon: Icons.visibility_off_outlined,
//                   title: LocaleKeys.hide.localize,
//                   onTap: () {
//                     ManageVibration.vibrate();
//                     Navigator.pop(context);
//                     // cubit.hideTalent(talent.id);
//                   },
//                 ),

//                 _buildOption(
//                   context: context,
//                   icon: Icons.flag_outlined,
//                   title: LocaleKeys.report.localize,
//                   iconColor: Colors.red,
//                   textColor: Colors.red,
//                   onTap: () {
//                     ManageVibration.vibrate();
//                     Navigator.pop(context);
//                     bottomSheet(
//                       context: context,
//                       widget: ReportView(
//                         id: talent.id,
//                         categoryId: "67e952dbbb085740a35d4281",
//                       ),
//                     );
//                   },
//                 ),

//                 _buildOption(
//                   context: context,
//                   icon: Icons.block_outlined,
//                   title: LocaleKeys.block.localize,
//                   iconColor: Colors.red,
//                   textColor: Colors.red,
//                   onTap: () {
//                     ManageVibration.vibrate();
//                     Navigator.pop(context);
//                     bottomSheet(
//                       context: context,
//                       widget: ReportView(
//                         id: talent.id,
//                         categoryId: "67e952dbbb085740a35d4281",
//                       ),
//                     );
//                   },
//                   isLast: true,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOption({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     Color? iconColor,
//     Color? textColor,
//     bool isLast = false,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         margin: EdgeInsets.only(bottom: isLast ? 16 : 0),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               size: 24,
//               color: iconColor ??
//                   (context.isDarkMode ? Colors.white : Colors.black87),
//             ),
//             SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w400,
//                   color: textColor ??
//                       (context.isDarkMode ? Colors.white : Colors.black87),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//!

class GetAllTalents extends StatelessWidget {
  final bool isMyTalent;
  final ScrollController scrollController;

  const GetAllTalents(
      {super.key, required this.scrollController, this.isMyTalent = false});

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
              child: Text('Error: ${state.failure}'),
            );
          }

          if (cubit.allTalents.isEmpty) {
            return CustomEmptyWidget(
              label: LocaleKeys.noResultsFound.localize,
            );
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: OlxPaginationWidget(
              scrollController: scrollController,
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
                  
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    color: context.isDarkMode ? Colors.black : Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Video/Image Section
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
                              ? YouTubeStyleVideoPlayer(
                                  videoUrl: mediaUrl,
                                  title: talent.title,
                                  autoPlay: true,
                                  startMuted: true,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TalentVideoPlayer(
                                          videoUrl: mediaUrl,
                                          talent: talent,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  height: 250,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    image: mediaUrl.isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(mediaUrl),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                ),
                        ),
                        
                        // Video Info Section
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Profile Picture
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: talent.user.image?.isNotEmpty == true
                                    ? NetworkImage(talent.user.image!)
                                    : null,
                                child: talent.user.image?.isEmpty ?? true
                                    ? Icon(Icons.person, size: 20, color: Colors.grey[600])
                                    : null,
                              ),
                              
                              SizedBox(width: 12),
                              
                              // Title and Channel Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Video Title
                                    Text(
                                      talent.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: context.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    
                                    SizedBox(height: 4),
                                    
                                    // Channel Name, Views, and Time
                                    Text(
                                      "${talent.user.firstName} ${talent.user.lastName} • ${context.isArabic ? convertToArabicNumbers(talent.totalViews.toShortScale) : talent.totalViews.toShortScale} ${LocaleKeys.views.localize} • ${context.isArabic ? convertToArabicNumbers(timeago.format(createdAt, locale: context.locale.languageCode)) : timeago.format(createdAt, locale: context.locale.languageCode)}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: context.isDarkMode
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    
                                    SizedBox(height: 8),
                                    
                                    // Rating Stars
                                    Row(
                                      children: [
                                        ...List.generate(
                                          5,
                                          (starIndex) => GestureDetector(
                                            onTap: () {
                                              cubit.changeRating(talent.id, starIndex + 1);
                                              debugPrint(
                                                  'GestureDetector onTap ${talent.averageRating}');
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(right: 4),
                                              child: Icon(
                                                starIndex < talent.averageRating
                                                    ? Icons.star
                                                    : Icons.star_border,
                                                color: starIndex < talent.averageRating
                                                    ? Colors.amber
                                                    : Colors.grey,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          talent.averageRating.toStringAsFixed(1),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: context.isDarkMode
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              
                              // More Options Button
                              IconButton(
                                onPressed: () {
                                  _youtubeOptions(context, talent);
                                },
                                icon: Icon(
                                  Icons.more_vert,
                                  color: context.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  size: 20,
                                ),
                                padding: EdgeInsets.all(8),
                                constraints: BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                        
                        // Delete Button for My Talents
                        if (isMyTalent)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: SizedBox(
                              width: double.infinity,
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
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  LocaleKeys.delete_talent.localize,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  _youtubeOptions(BuildContext context, StarEntity talent) {
    bottomSheet(
      context: context,
      asAlertDialog: true,
      isDismissible: true,
      backColor: context.isDarkMode ? Color(0xff0D0D0D) : Colors.white,
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.isDarkMode ? Color(0xff0D0D0D) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle indicator
                Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(top: 8, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Options list
                _buildOption(
                  context: context,
                  icon: Icons.bookmark_border,
                  title: LocaleKeys.save.localize,
                  onTap: () {
                    ManageVibration.vibrate();
                    Navigator.pop(context);
                    // cubit.saveTalent(talent.id);
                  },
                ),

                _buildOption(
                  context: context,
                  icon: Icons.visibility_off_outlined,
                  title: LocaleKeys.hide.localize,
                  onTap: () {
                    ManageVibration.vibrate();
                    Navigator.pop(context);
                    // cubit.hideTalent(talent.id);
                  },
                ),

                _buildOption(
                  context: context,
                  icon: Icons.flag_outlined,
                  title: LocaleKeys.report.localize,
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  onTap: () {
                    ManageVibration.vibrate();
                    Navigator.pop(context);
                    bottomSheet(
                      context: context,
                      widget: ReportView(
                        id: talent.id,
                        categoryId: "67e952dbbb085740a35d4281",
                      ),
                    );
                  },
                ),

                _buildOption(
                  context: context,
                  icon: Icons.block_outlined,
                  title: LocaleKeys.block.localize,
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  onTap: () {
                    ManageVibration.vibrate();
                    Navigator.pop(context);
                    bottomSheet(
                      context: context,
                      widget: ReportView(
                        id: talent.id,
                        categoryId: "67e952dbbb085740a35d4281",
                      ),
                    );
                  },
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        margin: EdgeInsets.only(bottom: isLast ? 16 : 0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: iconColor ??
                  (context.isDarkMode ? Colors.white : Colors.black87),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: textColor ??
                      (context.isDarkMode ? Colors.white : Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
