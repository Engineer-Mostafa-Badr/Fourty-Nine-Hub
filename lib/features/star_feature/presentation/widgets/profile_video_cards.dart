// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
// import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
// import 'package:fourtyninehub/features/star_feature/presentation/widgets/talent_card_widget.dart';
// import 'package:fourtyninehub/core/extensions/context_extension.dart';
// import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
// import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
// import 'package:fourtyninehub/core/extensions/string_extension.dart';
// import 'package:fourtyninehub/helpers/manage_vibration.dart';
// import 'package:path/path.dart';
// import 'package:timeago/timeago.dart' as timeago;

// // Mock Playlist Entity
// class PlaylistEntity {
//   final String id;
//   final String name;
//   final String description;
//   final List<StarEntity> videos;
//   final String thumbnailUrl;
//   final DateTime createdAt;

//   PlaylistEntity({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.videos,
//     required this.thumbnailUrl,
//     required this.createdAt,
//   });
// }

// class ProfileVideoCards {
//   // Horizontal grid card for Home tab
//   static Widget buildTalentCard(StarEntity talent, {VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: () {
//         ManageVibration.vibrate();
//         onTap?.call();
//       },
//       child: Container(
//         margin: EdgeInsets.only(bottom: 16.h),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Video thumbnail
//             Container(
//               height: 200.h,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.r),
//                 color: Colors.grey[300],
//                 image: DecorationImage(
//                   image: AssetImage('assets/images/testforvideo.jpg'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Stack(
//                 children: [
//                   // Heart icon
//                   Positioned(
//                     top: 8,
//                     left: 8,
//                     child: Container(
//                       padding: EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.6),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         Icons.favorite,
//                         color: Colors.red,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                   // Volume icon
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: Container(
//                       padding: EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.6),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         Icons.volume_off,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                   // Duration
//                   Positioned(
//                     bottom: 8,
//                     right: 8,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.8),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Text(
//                         '7:54',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 12.sp,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                   // Play button overlay
//                   Center(
//                     child: Icon(
//                       Icons.play_circle_outline,
//                       size: 60,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 8.h),

//             // Video info
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   radius: 18,
//                   backgroundColor: Colors.grey[300],
//                   backgroundImage: talent.user.image.isNotEmpty
//                       ? NetworkImage(talent.user.image)
//                       : null,
//                   child: talent.user.image.isEmpty
//                       ? Icon(Icons.person, size: 18, color: Colors.grey[600])
//                       : null,
//                 ),
//                 SizedBox(width: 12.w),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         talent.title,
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                           height: 1.3,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       SizedBox(height: 4.h),
//                       Text(
//                         "${talent.user.firstName} ${talent.user.lastName}",
//                         style: TextStyle(
//                           fontSize: 12.sp,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                       SizedBox(height: 2.h),
//                       Text(
//                         "${talent.totalViews.toShortScale.toArabicNumbers(context as BuildContext)} views • ${timeago.format(talent.createdAt ?? DateTime.now())}",
//                         style: TextStyle(
//                           fontSize: 12.sp,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                       SizedBox(height: 4.h),
//                       Row(
//                         children: List.generate(
//                           5,
//                           (starIndex) => Icon(
//                             starIndex < talent.averageRating
//                                 ? Icons.star
//                                 : Icons.star_border,
//                             color: starIndex < talent.averageRating
//                                 ? Colors.amber
//                                 : Colors.grey[400],
//                             size: 16,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () => TalentCard.showYouTubeOptions(
//                       context as BuildContext, talent),
//                   child: Icon(
//                     Icons.more_vert,
//                     size: 20,
//                     color: Colors.grey[700],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Vertical list item for Videos and Home tab
//   static Widget buildHistoryVideoItem(
//     BuildContext context,
//     StarEntity talent, {
//     VoidCallback? onTap,
//   }) {
//     final createdAt = talent.createdAt ?? DateTime.now();

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
//         color: Colors.white,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Video thumbnail
//             Container(
//               width: 140.w,
//               height: 90.h,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//               child: Stack(
//                 children: [
//                   // Thumbnail image
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8.r),
//                       color: Colors.grey[300],
//                       image: DecorationImage(
//                         image: AssetImage('assets/images/testforvideo.jpg'),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   // Sound icon in top left
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
//                   // Duration overlay
//                   Positioned(
//                     bottom: 8,
//                     left: 8,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.8),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Text(
//                         '7:54',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 12.sp,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(width: 12.w),
//             // Video info
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     talent.title,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 15.sp,
//                       color: Colors.black87,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     "${talent.user.firstName} ${talent.user.lastName}",
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   SizedBox(height: 2.h),
//                   Text(
//                     "${talent.totalViews.toShortScale.toArabicNumbers(context)} ${LocaleKeys.views.localize} • ${timeago.format(createdAt, locale: context.locale.languageCode).toArabicNumbers(context)}",
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 13.sp,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // More options button
//             GestureDetector(
//               onTap: () => TalentCard.showYouTubeOptions(context, talent),
//               child: Padding(
//                 padding: EdgeInsets.only(top: 4.h),
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

//   // Playlist card for Playlists tab
//   static Widget buildPlaylistItem(
//     BuildContext context,
//     PlaylistEntity playlist, {
//     VoidCallback? onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.only(bottom: 12),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Thumbnail with playlist icon overlay
//             Stack(
//               children: [
//                 // Thumbnail
//                 Container(
//                   width: MediaQuery.of(context).size.width * 0.35,
//                   height: MediaQuery.of(context).size.width * 0.22,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     image: DecorationImage(
//                       image: AssetImage('assets/images/testforvideo.jpg'),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 // Volume icon overlay
//                 Positioned(
//                   top: (8),
//                   left: (8),
//                   child: Container(
//                     padding: EdgeInsets.all((6)),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.7),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Icons.volume_up,
//                       color: Colors.white,
//                       size: (14),
//                     ),
//                   ),
//                 ),
//                 // Playlist count overlay
//                 Positioned(
//                   bottom: (8),
//                   right: (8),
//                   child: Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: (8),
//                       vertical: (4),
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.8),
//                       borderRadius: BorderRadius.circular((4)),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           Icons.playlist_play,
//                           color: Colors.white,
//                           size: (16),
//                         ),
//                         SizedBox(width: (4)),
//                         Text(
//                           '${playlist.videos.length}',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: (12),
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(width: (16)),

//             // Playlist info
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Title
//                   Text(
//                     'Heart Touching Nasheed',
//                     style: TextStyle(
//                       fontSize: (16),
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: (6)),
//                   // Subtitle
//                   Text(
//                     'Heart Touching • Playlist',
//                     style: TextStyle(
//                       fontSize: (14),
//                       color: Colors.grey[600],
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),

//             // More options button
//             IconButton(
//               icon: Icon(
//                 Icons.more_vert,
//                 color: Colors.grey[700],
//                 size: (22),
//               ),
//               onPressed: () {
//                 ManageVibration.vibrate();
//                 _showPlaylistOptions(context, playlist);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// // Helper method for thumbnail placeholder
//   static Widget _buildThumbnailPlaceholder() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//       ),
//       child: Center(
//         child: Icon(
//           Icons.music_video,
//           size: 20.sp,
//           color: Colors.grey[500],
//         ),
//       ),
//     );
//   }

//   static void _showPlaylistOptions(
//       BuildContext context, PlaylistEntity playlist) {
//     OptionsBottomSheet.showOptions(
//       context: context,
//       options: [
//         OptionItem(
//           icon: Icons.play_arrow,
//           title: 'Play all',
//           onTap: () {
//             Navigator.pop(context);
//             // Add play all logic
//           },
//         ),
//         OptionItem(
//           icon: Icons.shuffle,
//           title: 'Shuffle play',
//           onTap: () {
//             Navigator.pop(context);
//             // Add shuffle play logic
//           },
//         ),
//         OptionItem(
//           icon: Icons.playlist_add,
//           title: 'Add to queue',
//           onTap: () {
//             Navigator.pop(context);
//             // Add to queue logic
//           },
//         ),
//         OptionItem(
//           icon: Icons.share,
//           title: 'Share playlist',
//           onTap: () {
//             Navigator.pop(context);
//             // Add share logic
//           },
//         ),
//         OptionItem(
//           icon: Icons.edit,
//           title: 'Edit playlist',
//           onTap: () {
//             Navigator.pop(context);
//             // Add edit logic
//           },
//         ),
//       ],
//     );
//   }
// }
