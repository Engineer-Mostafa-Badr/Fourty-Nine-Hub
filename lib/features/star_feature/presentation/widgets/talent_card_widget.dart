import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/banner.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/olx_pagination_widget.dart';
import 'package:fourtyninehub/features/star_feature/presentation/pages/video_details_view.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/history_tab_widget.dart';
import 'package:fourtyninehub/features/star_feature/presentation/pages/profile_page.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../common/widgets/stateless/dynamic/are_you_sure.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/numbers_extensions.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../service_locator/service_locator.dart';
import '../../../account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import '../../../social_media/twitter/presentation/widgets/report_view.dart';
import '../../domain/entity/star_entity.dart';
import '../controller/cubit/profile_cubit.dart';
import '../controller/cubit/star_cubit.dart';
import '../controller/cubit/star_state.dart';
import '../helper/youtube_style_video_player.dart';
import '../helper/talent_video_player.dart';

// // Data class for option items
// class OptionItem {
//   final IconData icon;
//   final String title;
//   final VoidCallback onTap;
//   final Color? iconColor;
//   final Color? textColor;

//   OptionItem({
//     required this.icon,
//     required this.title,
//     required this.onTap,
//     this.iconColor,
//     this.textColor,
//   });
// }

// // Unified Options Bottom Sheet
// class OptionsBottomSheet {
//   static void showOptions({
//     required BuildContext context,
//     required List<OptionItem> options,
//     Color backgroundColor = Colors.white,
//     Color indicatorColor = const Color(0xffE4E4E4),
//     double borderRadius = 10,
//     EdgeInsets margin =
//         const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
//   }) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       barrierColor: Colors.black.withOpacity(0.5),
//       builder: (context) => Container(
//         margin: margin,
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.all(
//             Radius.circular(borderRadius),
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Handle indicator
//             Container(
//               width: 42,
//               height: 4,
//               margin: EdgeInsets.only(top: 8, bottom: 0),
//               decoration: BoxDecoration(
//                 color: indicatorColor,
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             // Build options dynamically
//             ...options.map((option) => _buildOptionItem(
//                   context: context,
//                   icon: option.icon,
//                   title: option.title,
//                   onTap: option.onTap,
//                   iconColor: option.iconColor,
//                   textColor: option.textColor,
//                 )),
//           ],
//         ),
//       ),
//     );
//   }

//   static Widget _buildOptionItem({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     Color? iconColor,
//     Color? textColor,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.only(
//           left: 13,
//           top: 16,
//           right: 13,
//           bottom: 2,
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 30,
//               height: 30,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.transparent,
//               ),
//               child: Icon(
//                 icon,
//                 size: 24,
//                 color: iconColor ?? Colors.black87,
//               ),
//             ),
//             SizedBox(width: 12),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w400,
//                 color: textColor ?? Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Main TalentCard class
// class TalentCard {
//   static Widget buildAvailableContentSliver({
//     required BuildContext context,
//     required StarCubit cubit,
//     required bool isSearching,
//     required List<StarEntity> filteredTalents,
//   }) {
//     return BlocBuilder<StarCubit, StarState>(
//       builder: (context, state) {
//         if (cubit.loadAllTalents) {
//           return SliverToBoxAdapter(
//             child: SizedBox(
//               height: 200,
//               child: const Center(child: CustomCircularProgressIndicator()),
//             ),
//           );
//         }

//         final talentsToShow = isSearching ? filteredTalents : cubit.allTalents;

//         if (talentsToShow.isEmpty) {
//           return SliverToBoxAdapter(
//             child: SizedBox(
//               height: 200,
//               child: CustomEmptyWidget(
//                 label: isSearching
//                     ? context.isArabic
//                         ? 'لا يوجد نتائج بحث'
//                         : 'No search results found'
//                     : LocaleKeys.noResultsFound.localize,
//               ),
//             ),
//           );
//         }

//         return SliverToBoxAdapter(
//           child: SizedBox(
//             height: MediaQuery.sizeOf(context).height * .6,
//             child: OlxPaginationWidget(
//               items: List.generate(
//                 talentsToShow.length,
//                 (index) =>
//                     _buildTalentCard(context, talentsToShow[index], cubit),
//               ),
//               banners: bannersList,
//               loadPage: (page) => cubit.getAllTalent(),
//               scrollController: ScrollController(),
//               itemsPerPage: 1,
//             ),
//           ),
//         );

//         // return SliverList(
//         //   delegate: SliverChildBuilderDelegate(
//         //     (context, index) {
//         //       final talent = talentsToShow[index];
//         //       return _buildTalentCard(context, talent, cubit);
//         //     },
//         //     childCount: talentsToShow.length,
//         //   ),
//         // );
//       },
//     );
//   }

//   static Widget buildFavoriteContentSliver({
//     required BuildContext context,
//     required StarCubit cubit,
//   }) {
//     return BlocBuilder<StarCubit, StarState>(
//       builder: (context, state) {
//         final favoriteTalents = cubit.favoriteTalents;

//         if (favoriteTalents.isEmpty) {
//           return SliverToBoxAdapter(
//             child: SizedBox(
//               height: 200,
//               child: CustomEmptyWidget(
//                 label: context.isArabic
//                     ? 'لا يوجد فيديوات مفضلة بعد'
//                     : 'No favorite videos yet',
//               ),
//             ),
//           );
//         }

//         return SliverList(
//           delegate: SliverChildBuilderDelegate(
//             (context, index) {
//               final talent = favoriteTalents[index];
//               return _buildTalentCard(context, talent, cubit);
//             },
//             childCount: favoriteTalents.length,
//           ),
//         );
//       },
//     );
//   }

//   static Widget buildHistoryContentSliver({
//     required BuildContext context,
//     required StarCubit cubit,
//   }) {
//     return BlocBuilder<StarCubit, StarState>(
//       builder: (context, state) {
//         final historyTalents = cubit.allTalents.take(8).toList();

//         if (historyTalents.isEmpty) {
//           return SliverToBoxAdapter(
//             child: SizedBox(
//               height: 200,
//               child: Center(
//                 child: Text(
//                   'No videos in history',
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//               ),
//             ),
//           );
//         }

//         return SliverList(
//           delegate: SliverChildBuilderDelegate(
//             (context, index) {
//               final talent = historyTalents[index];
//               return _buildHistoryVideoItem(context, talent, cubit, index);
//             },
//             childCount: historyTalents.length,
//           ),
//         );
//       },
//     );
//   }

//   static Widget _buildHistoryVideoItem(
//     BuildContext context,
//     StarEntity talent,
//     StarCubit cubit,
//     int index,
//   ) {
//     final mediaUrl =
//         talent.mediaUrl.isNotEmpty ? talent.mediaUrl.first.mediaKey : '';
//     final createdAt = talent.createdAt ?? DateTime.now();

//     return GestureDetector(
//       onTap: () {
//         _navigateToVideoPlayer(context, mediaUrl, talent);
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         color: Colors.white,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Video thumbnail
//             GestureDetector(
//               onTap: () => _navigateToProfile(context, talent),
//               child: Container(
//                 width: 140,
//                 height: 90,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Stack(
//                   children: [
//                     // Thumbnail image
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.grey[300],
//                         image: DecorationImage(
//                           image: AssetImage('assets/images/testforvideo.jpg'),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     // Sound icon in top left
//                     Positioned(
//                       top: 8,
//                       left: 8,
//                       child: Container(
//                         padding: EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.7),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Icon(
//                           Icons.volume_up,
//                           color: Colors.white,
//                           size: 16,
//                         ),
//                       ),
//                     ),
//                     // Duration overlay
//                     Positioned(
//                       bottom: 8,
//                       left: 8,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 6, vertical: 3),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.8),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Text(
//                           '7:54',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             // Video info
//             Expanded(
//               child: GestureDetector(
//                 // onTap: () => _navigateToProfile(context, talent),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       talent.title,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 15,
//                         color: Colors.black87,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       "${talent.user.firstName} ${talent.user.lastName}",
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 13,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       "${talent.totalViews.toShortScale.toArabicNumbers(context)} ${LocaleKeys.views.localize} • ${timeago.format(createdAt, locale: context.locale.languageCode).toArabicNumbers(context)}",
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // More options button
//             GestureDetector(
//               onTap: () => _showHistoryOptions(context, talent, cubit),
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 4),
//                 child: Icon(
//                   Icons.more_vert,
//                   size: 20,
//                   color: Colors.grey[700],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   static Widget _buildMyTalentsVideoItem(
//     BuildContext context,
//     StarEntity talent,
//     StarCubit cubit,
//     int index, {
//     Function(StarEntity, String)? onVideoTap,
//   }) {
//     final mediaUrl =
//         talent.mediaUrl.isNotEmpty ? talent.mediaUrl.first.mediaKey : '';
//     final createdAt = talent.createdAt ?? DateTime.now();

//     return GestureDetector(
//       onTap: () {
//         // Use callback instead of navigation
//         if (onVideoTap != null) {
//           onVideoTap(talent, mediaUrl);
//         } else {
//           // Fallback to original navigation behavior
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => VideoDetailsView(
//                 talent: talent,
//                 mediaUrl: mediaUrl,
//               ),
//             ),
//           );
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         color: Colors.white,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Video thumbnail
//             Container(
//               width: 140,
//               height: 90,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Stack(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       color: Colors.grey[300],
//                       image: DecorationImage(
//                         image: AssetImage('assets/images/testforvideo.jpg'),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 8,
//                     left: 8,
//                     child: Container(
//                       padding: EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.7),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Icon(
//                         Icons.volume_up,
//                         color: Colors.white,
//                         size: 16,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 8,
//                     left: 8,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 6, vertical: 3),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.8),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Text(
//                         '7:54',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 12),
//             // Video info
//             Expanded(
//               child: GestureDetector(
//                 // onTap: () => _navigateToProfile(context, talent),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       talent.title,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 15,
//                         color: Colors.black87,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       "${talent.user.firstName} ${talent.user.lastName}",
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 13,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       "${talent.totalViews.toShortScale.toArabicNumbers(context)} ${LocaleKeys.views.localize} • ${timeago.format(createdAt, locale: context.locale.languageCode).toArabicNumbers(context)}",
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // More options button
//             GestureDetector(
//               onTap: () => _showHistoryOptions(context, talent, cubit),
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 4),
//                 child: Icon(
//                   Icons.more_vert,
//                   size: 20,
//                   color: Colors.grey[700],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   static void _showHistoryOptions(
//       BuildContext context, StarEntity talent, StarCubit cubit) {
//     OptionsBottomSheet.showOptions(
//       context: context,
//       options: [
//         OptionItem(
//           icon: Icons.delete_outline,
//           title:
//               context.isArabic ? 'حذف من التاريخ' : 'Remove from watch history',
//           onTap: () {
//             Navigator.pop(context);
//             // Add remove from history logic
//           },
//         ),
//         OptionItem(
//           icon: Icons.playlist_play_rounded,
//           title: context.isArabic
//               ? 'تشغيل التالي في قائمة التشغيل'
//               : 'Play next in queue',
//           onTap: () {
//             Navigator.pop(context);
//             // Add play next logic
//           },
//         ),
//         OptionItem(
//           icon: Icons.access_time,
//           title:
//               context.isArabic ? 'حفظ للمشاهدة لاحقا' : 'Save to Watch later',
//           onTap: () {
//             Navigator.pop(context);
//             // Add save to watch later logic
//           },
//         ),
//         OptionItem(
//           icon: Icons.bookmark_border,
//           title: context.isArabic ? 'حفظ في قائمة التشغيل' : 'Save to playlist',
//           onTap: () {
//             Navigator.pop(context);
//             // Add save to playlist logic
//           },
//         ),
//         OptionItem(
//           icon: cubit.isFavorite(talent.id)
//               ? Icons.favorite
//               : Icons.favorite_border,
//           title: cubit.isFavorite(talent.id)
//               ? (context.isArabic ? 'حذف من المفضلة' : 'Remove from favorites')
//               : (context.isArabic ? 'اضافة للمفضلة' : 'Add to favorites'),
//           onTap: () {
//             Navigator.pop(context);
//             cubit.toggleFavorite(talent.id);
//           },
//         ),
//       ],
//     );
//   }

//   static void showYouTubeOptions(BuildContext context, StarEntity talent) {
//     final cubit = context.read<StarCubit>();
//     OptionsBottomSheet.showOptions(
//       context: context,
//       options: [
//         OptionItem(
//           icon: Icons.playlist_add,
//           title: context.isArabic ? 'انشاء قائمة' : 'Play next in queue',
//           onTap: () {
//             Navigator.pop(context);
//             // Handle play next
//           },
//         ),
//         OptionItem(
//           icon: Icons.block,
//           title: context.isArabic ? 'غير مهتم' : 'Not interested',
//           onTap: () {
//             Navigator.pop(context);
//             // Handle not interested
//           },
//         ),
//         OptionItem(
//           icon: Icons.visibility_off,
//           title: context.isArabic ? 'اخفاء' : 'Hide',
//           onTap: () {
//             Navigator.pop(context);
//             // Handle hide
//           },
//         ),
//         OptionItem(
//           icon: cubit.isFavorite(talent.id)
//               ? Icons.favorite
//               : Icons.favorite_border,
//           title: cubit.isFavorite(talent.id)
//               ? (context.isArabic
//                   ? 'ازالة من المفضلة'
//                   : 'Remove from favorites')
//               : (context.isArabic ? 'اضافة للمفضلة' : 'Add to favorites'),
//           onTap: () {
//             Navigator.pop(context);
//             cubit.toggleFavorite(talent.id);
//           },
//         ),
//         OptionItem(
//           icon: Icons.flag,
//           title: context.isArabic ? 'ابلاغ' : 'Report',
//           iconColor: Colors.red,
//           textColor: Colors.red,
//           onTap: () {
//             Navigator.pop(context);
//             _showReportBottomSheet(context, talent);
//           },
//         ),
//       ],
//     );
//   }

//   static Widget buildMyTalentContentSliver({
//     required BuildContext context,
//     required StarCubit cubit,
//     Function(StarEntity, String)? onVideoTap,
//   }) {
//     return BlocBuilder<StarCubit, StarState>(
//       builder: (context, state) {
//         final myTalent = cubit.allTalents.take(8).toList();
//         if (cubit.loadMyTalents) {
//           return SliverToBoxAdapter(
//             child: SizedBox(
//               height: 200,
//               child: const Center(child: CustomCircularProgressIndicator()),
//             ),
//           );
//         }

//         if (myTalent.isEmpty) {
//           return SliverToBoxAdapter(
//             child: SizedBox(
//               height: 200,
//               child: CustomEmptyWidget(
//                 label: LocaleKeys.noResultsFound.localize,
//               ),
//             ),
//           );
//         }

//         return SliverList(
//           delegate: SliverChildBuilderDelegate(
//             (context, index) {
//               final talent = myTalent[index];
//               return _buildMyTalentsVideoItem(
//                 context,
//                 talent,
//                 cubit,
//                 index,
//                 onVideoTap: onVideoTap,
//               );
//             },
//             childCount: myTalent.length,
//           ),
//         );
//       },
//     );
//   }

//   // static Widget buildMyTalentContentSliver({
//   //   required BuildContext context,
//   //   required StarCubit cubit,
//   //   Function(StarEntity, String)? onVideoTap,
//   // }) {
//   //   return BlocBuilder<StarCubit, StarState>(
//   //     builder: (context, state) {
//   //       // Use myTalents instead of allTalents.take(8)
//   //       if (cubit.loadMyTalents) {
//   //         return SliverToBoxAdapter(
//   //           child: SizedBox(
//   //             height: 200,
//   //             child: const Center(child: CustomCircularProgressIndicator()),
//   //           ),
//   //         );
//   //       }

//   //       if (cubit.myTalents.isEmpty) {
//   //         // Initialize loading if not done yet
//   //         if (!cubit.loadMyTalents) {
//   //           cubit.loadMyTalentsData();
//   //         }
//   //         return SliverToBoxAdapter(
//   //           child: SizedBox(
//   //             height: 200,
//   //             child: CustomEmptyWidget(
//   //               label: LocaleKeys.noResultsFound.localize,
//   //             ),
//   //           ),
//   //         );
//   //       }

//   //       return SliverList(
//   //         delegate: SliverChildBuilderDelegate(
//   //           (context, index) {
//   //             final talent = cubit.myTalents[index];
//   //             return _buildMyTalentsVideoItem(
//   //               context,
//   //               talent,
//   //               cubit,
//   //               index,
//   //               onVideoTap: onVideoTap,
//   //             );
//   //           },
//   //           childCount: cubit.myTalents.length,
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }

//   static Widget _buildTalentCard(
//     BuildContext context,
//     StarEntity talent,
//     StarCubit cubit, {
//     bool isMyTalent = false,
//   }) {
//     final mediaUrl =
//         talent.mediaUrl.isNotEmpty ? talent.mediaUrl.first.mediaKey : '';
//     final createdAt = talent.createdAt ?? DateTime.now();
//     final isVideo = mediaUrl.toLowerCase().contains('.mp4') ||
//         mediaUrl.toLowerCase().contains('.mov') ||
//         mediaUrl.toLowerCase().contains('.avi');

//     return Container(
//       margin: EdgeInsets.only(bottom: 16),
//       color: context.isDarkMode ? Colors.black : Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           //? Video/Image Section
//           GestureDetector(
//             onTap: isVideo
//                 ? () => _navigateToVideoPlayer(context, mediaUrl, talent)
//                 : () => _navigateToProfile(context, talent),
//             child: isVideo
//                 ? YouTubeStyleVideoPlayer(
//                     videoUrl: mediaUrl,
//                     title: talent.title,
//                     autoPlay: true,
//                     startMuted: true,
//                     thumbnailUrl: "assets/images/testforvideo.jpg",
//                     talent: talent,
//                     onTap: () => _navigateToProfile(context, talent),
//                   )
//                 : Container(
//                     height: 250,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       image: mediaUrl.isNotEmpty
//                           ? DecorationImage(
//                               image: NetworkImage(mediaUrl),
//                               fit: BoxFit.cover,
//                             )
//                           : null,
//                     ),
//                   ),
//           ),
//           //? Video Info Section
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Profile Picture
//                 GestureDetector(
//                   onTap: () => _navigateToProfile(context, talent),
//                   child: CircleAvatar(
//                     radius: 25,
//                     backgroundColor: Colors.grey[300],
//                     backgroundImage: talent.user.image.isNotEmpty
//                         ? NetworkImage(talent.user.image)
//                         : null,
//                     child: talent.user.image.isEmpty
//                         ? Icon(Icons.person, size: 18, color: Colors.grey[600])
//                         : null,
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 // Title and Info
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () => _navigateToProfile(context, talent),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           talent.title,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: context.isDarkMode
//                                 ? Colors.white
//                                 : Colors.black,
//                             height: 1.3,
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           "${talent.user.firstName} ${talent.user.lastName}",
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: context.isDarkMode
//                                 ? Colors.grey[400]
//                                 : Colors.grey[600],
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         SizedBox(height: 2),
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.visibility,
//                               size: 14,
//                               color: context.isDarkMode
//                                   ? Colors.grey[400]
//                                   : Colors.grey[600],
//                             ),
//                             SizedBox(width: 4),
//                             Text(
//                               "${talent.totalViews.toShortScale.toArabicNumbers(context)} ${LocaleKeys.views.localize} • ${timeago.format(createdAt, locale: context.locale.languageCode).toArabicNumbers(context)}",
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: context.isDarkMode
//                                     ? Colors.grey[400]
//                                     : Colors.grey[600],
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // More Options and Stars
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     IconButton(
//                       onPressed: () => showYouTubeOptions(context, talent),
//                       icon: Icon(
//                         Icons.more_vert,
//                         color: context.isDarkMode ? Colors.white : Colors.black,
//                         size: 25,
//                       ),
//                       padding: EdgeInsets.all(4),
//                       constraints: BoxConstraints(minWidth: 32, minHeight: 32),
//                     ),
//                     SizedBox(height: 4),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         ...List.generate(
//                           5,
//                           (starIndex) => GestureDetector(
//                             onTap: () {
//                               cubit.changeRating(talent.id, starIndex + 1);
//                             },
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 1),
//                               child: Icon(
//                                 starIndex < talent.averageRating
//                                     ? Icons.star
//                                     : Icons.star_border,
//                                 color: starIndex < talent.averageRating
//                                     ? Colors.amber
//                                     : Colors.grey[400],
//                                 size: 25,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           //? Delete Button for My Talents
//           if (isMyTalent)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () => _handleDeleteTalent(context, talent),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                     padding: EdgeInsets.symmetric(vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Text(
//                     LocaleKeys.delete_talent.localize,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   static void _navigateToVideoPlayer(
//       BuildContext context, String mediaUrl, StarEntity talent) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => TalentVideoPlayer(
//           talent: talent,
//           videoUrl: mediaUrl,
//         ),
//       ),
//     );
//   }

//   static void _navigateToProfile(BuildContext context, StarEntity talent) {
//     // Generate mock videos for the profile
//     final mockVideos = List.generate(
//         10,
//         (index) => StarEntity(
//               id: '${talent.id}_mock_$index',
//               title: '${talent.title} - Part ${index + 1}',
//               description: 'Mock video ${index + 1}',
//               user: talent.user,
//               mediaUrl: talent.mediaUrl,
//               totalViews: talent.totalViews + (index * 1000),
//               averageRating: talent.averageRating,
//               isApproved: talent.isApproved,
//               haveStories: talent.haveStories,
//               storyCount: talent.storyCount,
//               createdAt: DateTime.now().subtract(Duration(days: index * 30)),
//             ));

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProfilePageView(
//           user: talent.user,
//           userVideos: mockVideos,
//         ),
//       ),
//     );
//   }

//   static void _handleDeleteTalent(BuildContext context, StarEntity talent) {
//     showAreYouSure(
//       context: context,
//       title: LocaleKeys.alert.localize,
//       subTitle: LocaleKeys.remove.localize,
//       action: () {
//         context.read<StarCubit>().deleteMyTalent(id: talent.id);
//         Navigator.pop(context);
//       },
//     );
//   }

//   static void _showReportBottomSheet(BuildContext context, StarEntity talent) {
//     bottomSheet(
//       context: context,
//       widget: ReportView(
//         id: talent.id,
//         categoryId: "67e952dbbb085740a35d4281",
//       ),
//     );
//   }
// }

//!

class TalentCard {
  // Available content (main feed)
  static Widget buildAvailableContentSliver({
    required BuildContext context,
    required StarCubit cubit,
    required bool isSearching,
  }) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        // Show loading if first load
        if (state.status == StarStates.loading &&
            state.availableTalents.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: const Center(child: CustomCircularProgressIndicator()),
            ),
          );
        }

        // Determine which data to show
        final talentsToShow =
            isSearching ? state.searchResults : state.availableTalents;

        if (talentsToShow.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: CustomEmptyWidget(
                label: isSearching
                    ? (context.isArabic
                        ? 'لا يوجد نتائج بحث'
                        : 'No search results found')
                    : LocaleKeys.noResultsFound.localize,
              ),
            ),
          );
        }

        return SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * .6,
            child: OlxPaginationWidget(
              items: List.generate(
                talentsToShow.length,
                (index) =>
                    _buildTalentCard(context, talentsToShow[index], cubit),
              ),
              banners: bannersList,
              loadPage: (page) => isSearching
                  ? Future.value()
                  : cubit.loadTalents(TalentCategory.available),
              scrollController: ScrollController(),
              itemsPerPage: 1,
            ),
          ),
        );
      },
    );
  }

  // Favorite content
  static Widget buildFavoriteContentSliver({
    required BuildContext context,
    required StarCubit cubit,
  }) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        if (state.isLoading(TalentCategory.favorites)) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: const Center(child: CustomCircularProgressIndicator()),
            ),
          );
        }

        if (state.favoriteTalents.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: CustomEmptyWidget(
                label: context.isArabic
                    ? 'لا يوجد فيديوات مفضلة بعد'
                    : 'No favorite videos yet',
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == state.favoriteTalents.length) {
                // Load more button or loading indicator
                return _buildLoadMoreWidget(
                    context, state, TalentCategory.favorites, cubit);
              }

              final talent = state.favoriteTalents[index];
              return _buildTalentCard(context, talent, cubit);
            },
            childCount: state.favoriteTalents.length +
                (state.hasMore(TalentCategory.favorites) ? 1 : 0),
          ),
        );
      },
    );
  }

  // History content
  static Widget buildHistoryContentSliver({
    required BuildContext context,
    required StarCubit cubit,
  }) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        if (state.isLoading(TalentCategory.history)) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: const Center(child: CustomCircularProgressIndicator()),
            ),
          );
        }

        if (state.historyTalents.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  context.isArabic
                      ? 'لا يوجد فيديوات في التاريخ'
                      : 'No videos in history',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == state.historyTalents.length) {
                return _buildLoadMoreWidget(
                    context, state, TalentCategory.history, cubit);
              }

              final talent = state.historyTalents[index];
              return _buildHistoryVideoItem(context, talent, cubit, index);
            },
            childCount: state.historyTalents.length +
                (state.hasMore(TalentCategory.history) ? 1 : 0),
          ),
        );
      },
    );
  }

  // My talents content
  static Widget buildMyTalentContentSliver({
    required BuildContext context,
    required StarCubit cubit,
    Function(StarEntity, String)? onVideoTap,
  }) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        if (state.isLoading(TalentCategory.myTalents)) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: const Center(child: CustomCircularProgressIndicator()),
            ),
          );
        }

        if (state.myTalents.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: CustomEmptyWidget(
                label: LocaleKeys.noResultsFound.localize,
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == state.myTalents.length) {
                return _buildLoadMoreWidget(
                    context, state, TalentCategory.myTalents, cubit);
              }

              final talent = state.myTalents[index];
              return _buildMyTalentsVideoItem(
                context,
                talent,
                cubit,
                index,
                onVideoTap: onVideoTap,
              );
            },
            childCount: state.myTalents.length +
                (state.hasMore(TalentCategory.myTalents) ? 1 : 0),
          ),
        );
      },
    );
  }

  // Load more widget for pagination
  static Widget _buildLoadMoreWidget(
    BuildContext context,
    StarState state,
    TalentCategory category,
    StarCubit cubit,
  ) {
    if (state.isLoading(category)) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Center(child: CustomCircularProgressIndicator()),
      );
    }

    if (!state.hasMore(category)) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            context.isArabic ? 'لا يوجد المزيد' : 'No more content',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: ElevatedButton(
          onPressed: () => cubit.loadTalents(category),
          child: Text(context.isArabic ? 'تحميل المزيد' : 'Load More'),
        ),
      ),
    );
  }

  // Main talent card builder
  static Widget _buildTalentCard(
    BuildContext context,
    StarEntity talent,
    StarCubit cubit, {
    bool isMyTalent = false,
  }) {
    final mediaUrl =
        talent.mediaUrl.isNotEmpty ? talent.mediaUrl.first.mediaKey : '';
    final createdAt = talent.createdAt ?? DateTime.now();
    final isVideo = _isVideoUrl(mediaUrl);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      color: context.isDarkMode ? Colors.black : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video/Image Section
          GestureDetector(
            onTap: isVideo
                ? () => _navigateToVideoPlayer(context, mediaUrl, talent)
                : () => _navigateToProfile(context, talent),
            child: isVideo
                ? YouTubeStyleVideoPlayer(
                    videoUrl: mediaUrl,
                    title: talent.title,
                    autoPlay: true,
                    startMuted: true,
                    thumbnailUrl: "assets/images/testforvideo.jpg",
                    talent: talent,
                    onTap: () => _navigateToProfile(context, talent),
                  )
                : _buildImageContainer(mediaUrl),
          ),

          // Video Info Section
          _buildVideoInfoSection(context, talent, cubit),

          // Delete Button for My Talents
          if (isMyTalent) _buildDeleteButton(context, talent),
        ],
      ),
    );
  }

  static Widget _buildImageContainer(String mediaUrl) {
    return Container(
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
    );
  }

  static Widget _buildVideoInfoSection(
    BuildContext context,
    StarEntity talent,
    StarCubit cubit,
  ) {
    final createdAt = talent.createdAt ?? DateTime.now();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture
          GestureDetector(
            onTap: () => _navigateToProfile(context, talent),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[300],
              backgroundImage: talent.user.image.isNotEmpty
                  ? NetworkImage(talent.user.image)
                  : null,
              child: talent.user.image.isEmpty
                  ? Icon(Icons.person, size: 18, color: Colors.grey[600])
                  : null,
            ),
          ),
          SizedBox(width: 12),

          // Title and Info
          Expanded(
            child: GestureDetector(
              onTap: () => _navigateToProfile(context, talent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    talent.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${talent.user.firstName} ${talent.user.lastName}",
                    style: TextStyle(
                      fontSize: 13,
                      color: context.isDarkMode
                          ? Colors.grey[400]
                          : Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.visibility,
                        size: 14,
                        color: context.isDarkMode
                            ? Colors.grey[400]
                            : Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        "${talent.totalViews.toShortScale.toArabicNumbers(context)} ${LocaleKeys.views.localize} • ${timeago.format(createdAt, locale: context.locale.languageCode).toArabicNumbers(context)}",
                        style: TextStyle(
                          fontSize: 13,
                          color: context.isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // More Options and Stars
          _buildOptionsAndRating(context, talent, cubit),
        ],
      ),
    );
  }

  static Widget _buildOptionsAndRating(
    BuildContext context,
    StarEntity talent,
    StarCubit cubit,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () => showYouTubeOptions(context, talent),
          icon: Icon(
            Icons.more_vert,
            color: context.isDarkMode ? Colors.white : Colors.black,
            size: 25,
          ),
          padding: EdgeInsets.all(4),
          constraints: BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            5,
            (starIndex) => GestureDetector(
              onTap: () => cubit.updateRating(talent.id, starIndex + 1),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 1),
                child: Icon(
                  starIndex < talent.averageRating
                      ? Icons.star
                      : Icons.star_border,
                  color: starIndex < talent.averageRating
                      ? Colors.amber
                      : Colors.grey[400],
                  size: 25,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildDeleteButton(BuildContext context, StarEntity talent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _handleDeleteTalent(context, talent),
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
    );
  }

  // History video item builder
  static Widget _buildHistoryVideoItem(
    BuildContext context,
    StarEntity talent,
    StarCubit cubit,
    int index,
  ) {
    final mediaUrl =
        talent.mediaUrl.isNotEmpty ? talent.mediaUrl.first.mediaKey : '';
    final createdAt = talent.createdAt ?? DateTime.now();

    return GestureDetector(
      onTap: () => _navigateToVideoPlayer(context, mediaUrl, talent),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video thumbnail
            _buildThumbnailWithOverlays(140, 90),
            const SizedBox(width: 12),

            // Video info
            Expanded(
              child: _buildVideoInfoColumn(context, talent, createdAt),
            ),

            // More options button
            _buildMoreOptionsButton(context, talent, cubit),
          ],
        ),
      ),
    );
  }

  // My talents video item builder
  static Widget _buildMyTalentsVideoItem(
    BuildContext context,
    StarEntity talent,
    StarCubit cubit,
    int index, {
    Function(StarEntity, String)? onVideoTap,
  }) {
    final mediaUrl =
        talent.mediaUrl.isNotEmpty ? talent.mediaUrl.first.mediaKey : '';
    final createdAt = talent.createdAt ?? DateTime.now();

    return GestureDetector(
      onTap: () {
        if (onVideoTap != null) {
          onVideoTap(talent, mediaUrl);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoDetailsView(
                talent: talent,
                mediaUrl: mediaUrl,
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnailWithOverlays(140, 90),
            const SizedBox(width: 12),
            Expanded(
              child: _buildVideoInfoColumn(context, talent, createdAt),
            ),
            _buildMoreOptionsButton(context, talent, cubit),
          ],
        ),
      ),
    );
  }

  static Widget _buildThumbnailWithOverlays(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[300],
              image: DecorationImage(
                image: AssetImage('assets/images/testforvideo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Sound icon in top left
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.volume_up,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          // Duration overlay
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '7:54',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildVideoInfoColumn(
    BuildContext context,
    StarEntity talent,
    DateTime createdAt,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          talent.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          "${talent.user.firstName} ${talent.user.lastName}",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          "${talent.totalViews.toShortScale.toArabicNumbers(context)} ${LocaleKeys.views.localize} • ${timeago.format(createdAt, locale: context.locale.languageCode).toArabicNumbers(context)}",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  static Widget _buildMoreOptionsButton(
    BuildContext context,
    StarEntity talent,
    StarCubit cubit,
  ) {
    return GestureDetector(
      onTap: () => _showHistoryOptions(context, talent, cubit),
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Icon(
          Icons.more_vert,
          size: 20,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  // Utility methods
  static bool _isVideoUrl(String url) {
    return url.toLowerCase().contains('.mp4') ||
        url.toLowerCase().contains('.mov') ||
        url.toLowerCase().contains('.avi') ||
        url.toLowerCase().contains('.m3u8');
  }

  static void _navigateToVideoPlayer(
    BuildContext context,
    String mediaUrl,
    StarEntity talent,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TalentVideoPlayer(
          talent: talent,
          videoUrl: mediaUrl,
        ),
      ),
    );
  }

  static void _navigateToProfile(BuildContext context, StarEntity talent) {
    final mockVideos = List.generate(
      10,
      (index) => StarEntity(
        id: '${talent.id}_mock_$index',
        title: '${talent.title} - Part ${index + 1}',
        description: 'Mock video ${index + 1}',
        user: talent.user,
        mediaUrl: talent.mediaUrl,
        totalViews: talent.totalViews + (index * 1000),
        averageRating: talent.averageRating,
        isApproved: talent.isApproved,
        haveStories: talent.haveStories,
        storyCount: talent.storyCount,
        createdAt: DateTime.now().subtract(Duration(days: index * 30)),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<ProfileCubit>(
          create: (context) => serviceLocator<ProfileCubit>()..getMyProfile(),
          child: ProfilePageView(
            user: talent.user,
            userVideos: mockVideos,
          ),
        ),
      ),
    );
  }

  static void _handleDeleteTalent(BuildContext context, StarEntity talent) {
    showAreYouSure(
      context: context,
      title: LocaleKeys.alert.localize,
      subTitle: LocaleKeys.remove.localize,
      action: () {
        context.read<StarCubit>().deleteMyTalent(id: talent.id);
        Navigator.pop(context);
      },
    );
  }

  // Options methods
  static void _showHistoryOptions(
    BuildContext context,
    StarEntity talent,
    StarCubit cubit,
  ) {
    OptionsBottomSheet.showOptions(
      context: context,
      options: [
        OptionItem(
          icon: Icons.delete_outline,
          title:
              context.isArabic ? 'حذف من التاريخ' : 'Remove from watch history',
          onTap: () {
            Navigator.pop(context);
            // Add remove from history logic
          },
        ),
        OptionItem(
          icon: Icons.playlist_play_rounded,
          title: context.isArabic
              ? 'تشغيل التالي في قائمة التشغيل'
              : 'Play next in queue',
          onTap: () {
            Navigator.pop(context);
            // Add play next logic
          },
        ),
        OptionItem(
          icon: Icons.access_time,
          title:
              context.isArabic ? 'حفظ للمشاهدة لاحقا' : 'Save to Watch later',
          onTap: () {
            Navigator.pop(context);
            // Add save to watch later logic
          },
        ),
        OptionItem(
          icon: Icons.bookmark_border,
          title: context.isArabic ? 'حفظ في قائمة التشغيل' : 'Save to playlist',
          onTap: () {
            Navigator.pop(context);
            // Add save to playlist logic
          },
        ),
        OptionItem(
          icon: cubit.isFavorite(talent.id)
              ? Icons.favorite
              : Icons.favorite_border,
          title: cubit.isFavorite(talent.id)
              ? (context.isArabic ? 'حذف من المفضلة' : 'Remove from favorites')
              : (context.isArabic ? 'اضافة للمفضلة' : 'Add to favorites'),
          onTap: () {
            Navigator.pop(context);
            cubit.toggleFavorite(talent.id);
          },
        ),
      ],
    );
  }

  static void showYouTubeOptions(BuildContext context, StarEntity talent) {
    final cubit = context.read<StarCubit>();
    OptionsBottomSheet.showOptions(
      context: context,
      options: [
        OptionItem(
          icon: Icons.playlist_add,
          title: context.isArabic ? 'انشاء قائمة' : 'Play next in queue',
          onTap: () {
            Navigator.pop(context);
            // Handle play next
          },
        ),
        OptionItem(
          icon: Icons.block,
          title: context.isArabic ? 'غير مهتم' : 'Not interested',
          onTap: () {
            Navigator.pop(context);
            // Handle not interested
          },
        ),
        OptionItem(
          icon: Icons.visibility_off,
          title: context.isArabic ? 'اخفاء' : 'Hide',
          onTap: () {
            Navigator.pop(context);
            // Handle hide
          },
        ),
        OptionItem(
          icon: cubit.isFavorite(talent.id)
              ? Icons.favorite
              : Icons.favorite_border,
          title: cubit.isFavorite(talent.id)
              ? (context.isArabic
                  ? 'ازالة من المفضلة'
                  : 'Remove from favorites')
              : (context.isArabic ? 'اضافة للمفضلة' : 'Add to favorites'),
          onTap: () {
            Navigator.pop(context);
            cubit.toggleFavorite(talent.id);
          },
        ),
        OptionItem(
          icon: Icons.flag,
          title: context.isArabic ? 'ابلاغ' : 'Report',
          iconColor: Colors.red,
          textColor: Colors.red,
          onTap: () {
            Navigator.pop(context);
            _showReportBottomSheet(context, talent);
          },
        ),
      ],
    );
  }

  static void _showReportBottomSheet(BuildContext context, StarEntity talent) {
    bottomSheet(
      context: context,
      widget: ReportView(
        id: talent.id,
        categoryId: "67e952dbbb085740a35d4281",
      ),
    );
  }
}

// Data class for option items remains the same
class OptionItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  OptionItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });
}

// Unified Options Bottom Sheet remains the same
class OptionsBottomSheet {
  static void showOptions({
    required BuildContext context,
    required List<OptionItem> options,
    Color backgroundColor = Colors.white,
    Color indicatorColor = const Color(0xffE4E4E4),
    double borderRadius = 10,
    EdgeInsets margin =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Container(
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle indicator
            Container(
              width: 42,
              height: 4,
              margin: EdgeInsets.only(top: 8, bottom: 0),
              decoration: BoxDecoration(
                color: indicatorColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Build options dynamically
            ...options.map((option) => _buildOptionItem(
                  context: context,
                  icon: option.icon,
                  title: option.title,
                  onTap: option.onTap,
                  iconColor: option.iconColor,
                  textColor: option.textColor,
                )),
          ],
        ),
      ),
    );
  }

  static Widget _buildOptionItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 13, top: 16, right: 13, bottom: 2),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Icon(
                icon,
                size: 24,
                color: iconColor ?? Colors.black87,
              ),
            ),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: textColor ?? Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
