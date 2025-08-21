// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fourtyninehub/core/extensions/context_extension.dart';
// import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
// import 'package:fourtyninehub/core/extensions/string_extension.dart';

// class HistoryTabContent extends StatelessWidget {
//   const HistoryTabContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SliverList(
//       delegate: SliverChildBuilderDelegate(
//         (context, index) => _buildHistoryVideoItem(context, index),
//         childCount: 10, // عدد الفيديوهات في التاريخ
//       ),
//     );
//   }

//   Widget _buildHistoryVideoItem(BuildContext context, int index) {
//     // بيانات تجريبية للفيديوهات في التاريخ
//     final List<String> videoTitles = [
//       'Config 2022 Opening Keynote - Dylan Field',
//       'Design Systems at Scale - Advanced Techniques',  
//       'Component Libraries: Best Practices',
//       'Figma Auto Layout Tutorial',
//       'Building Design Tokens for Consistency',
//       'Advanced Prototyping Techniques',
//       'Design System Documentation',
//       'Figma Variables Deep Dive',
//       'Color Tokens Best Practices',
//       'Component Architecture Patterns',
//     ];

//     final List<String> channelNames = [
//       'Figma',
//       'Design System Hub',
//       'UI/UX Academy', 
//       'Figma Academy',
//       'Design Tools Pro',
//       'UX Mastery',
//       'Design Forward',
//       'Creative Studios',
//       'Tech Design',
//       'Modern UI',
//     ];

//     final List<String> viewCounts = [
//       '1.2M views',
//       '850K views',
//       '640K views', 
//       '420K views',
//       '380K views',
//       '290K views',
//       '180K views',
//       '95K views',
//       '75K views',
//       '45K views',
//     ];

//     final List<String> durations = [
//       '12:40',
//       '8:25',
//       '15:30',
//       '6:15', 
//       '11:45',
//       '9:20',
//       '7:35',
//       '13:10',
//       '5:45',
//       '10:25',
//     ];

//     final List<String> watchedDates = [
//       'Yesterday',
//       '2 days ago',
//       '3 days ago',
//       '1 week ago',
//       '1 week ago', 
//       '2 weeks ago',
//       '2 weeks ago',
//       '3 weeks ago',
//       '1 month ago',
//       '1 month ago',
//     ];

//     return GestureDetector(
//       onTap: () {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Opening ${videoTitles[index]}...')),
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         color: context.isDarkMode ? Colors.black : Colors.white,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Video thumbnail
//             Container(
//               width: 120,
//               height: 80,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Stack(
//                 children: [
//                   // Placeholder for video thumbnail
//                   Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           Colors.grey[400]!,
//                           Colors.grey[600]!,
//                         ],
//                       ),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Center(
//                       child: Icon(
//                         Icons.play_circle_filled,
//                         color: Colors.white.withOpacity(0.8),
//                         size: 40,
//                       ),
//                     ),
//                   ),
//                   // Duration overlay
//                   Positioned(
//                     bottom: 4,
//                     right: 4,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 4, vertical: 2),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.8),
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                       child: Text(
//                         durations[index],
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                   // Watched overlay indicator
//                   Positioned(
//                     top: 4,
//                     left: 4,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 4, vertical: 2),
//                       decoration: BoxDecoration(
//                         color: Colors.green.withOpacity(0.8),
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                       child: Icon(
//                         Icons.check,
//                         color: Colors.white,
//                         size: 12,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 12),

//             // Video info
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     videoTitles[index],
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 14,
//                       color: context.isDarkMode ? Colors.white : Colors.black,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Container(
//                         width: 16,
//                         height: 16,
//                         decoration: BoxDecoration(
//                           color: context.isDarkMode ? Colors.white : Colors.black,
//                           borderRadius: BorderRadius.circular(3),
//                         ),
//                         child: Center(
//                           child: Icon(
//                             Icons.edit,
//                             color: context.isDarkMode ? Colors.black : Colors.white,
//                             size: 10,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         channelNames[index],
//                         style: TextStyle(
//                           color: context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     '${viewCounts[index]} • ${watchedDates[index]}',
//                     style: TextStyle(
//                       color: context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
//                       fontSize: 12,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   // Watched date indicator
//                   Text(
//                     'Watched ${watchedDates[index]}',
//                     style: TextStyle(
//                       color: Colors.green,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // More options
//             GestureDetector(
//               onTap: () {
//                 _showHistoryOptions(context, videoTitles[index]);
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(4),
//                 child: Icon(
//                   Icons.more_vert,
//                   size: 18,
//                   color: context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showHistoryOptions(BuildContext context, String videoTitle) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: context.isDarkMode ? Color(0xff0D0D0D) : Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Handle indicator
//             Container(
//               width: 40,
//               height: 4,
//               margin: EdgeInsets.only(bottom: 16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[400],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
            
//             ListTile(
//               leading: Icon(
//                 Icons.play_arrow,
//                 color: context.isDarkMode ? Colors.white : Colors.black,
//               ),
//               title: Text(
//                 'Watch Again',
//                 style: TextStyle(
//                   color: context.isDarkMode ? Colors.white : Colors.black,
//                 ),
//               ),
//               onTap: () => Navigator.pop(context),
//             ),
//             ListTile(
//               leading: Icon(
//                 Icons.playlist_add,
//                 color: context.isDarkMode ? Colors.white : Colors.black,
//               ),
//               title: Text(
//                 'Add to playlist',
//                 style: TextStyle(
//                   color: context.isDarkMode ? Colors.white : Colors.black,
//                 ),
//               ),
//               onTap: () => Navigator.pop(context),
//             ),
//             ListTile(
//               leading: Icon(
//                 Icons.share,
//                 color: context.isDarkMode ? Colors.white : Colors.black,
//               ),
//               title: Text(
//                 'Share',
//                 style: TextStyle(
//                   color: context.isDarkMode ? Colors.white : Colors.black,
//                 ),
//               ),
//               onTap: () => Navigator.pop(context),
//             ),
//             ListTile(
//               leading: Icon(
//                 Icons.delete_outline,
//                 color: Colors.red,
//               ),
//               title: Text(
//                 'Remove from history',
//                 style: TextStyle(
//                   color: Colors.red,
//                 ),
//               ),
//               onTap: () => Navigator.pop(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }