// import 'package:flutter/material.dart';
// import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
// import 'package:fourtyninehub/features/star_feature/presentation/controller/cubits/star/star_cubit.dart';
// import 'package:fourtyninehub/features/star_feature/presentation/pages/video_details_view.dart';
// import 'package:fourtyninehub/features/star_feature/presentation/widgets/talent_card_widget.dart';
// import 'package:fourtyninehub/core/extensions/context_extension.dart';

// class BeStarTabContent extends StatelessWidget {  
//   final int selectedTabIndex;
//   final BuildContext context;
//   final StarCubit cubit;
//   final bool isSearching;
//   final bool showVideoDetails;
//   final StarEntity? selectedVideoTalent;
//   final String? selectedVideoUrl;
//   final VoidCallback onBackFromVideoDetails;
//   final Function(StarEntity, String) onVideoSelected;

//   const BeStarTabContent({
//     super.key,
//     required this.selectedTabIndex,
//     required this.context,
//     required this.cubit,
//     required this.isSearching,
//     required this.showVideoDetails,
//     required this.selectedVideoTalent,
//     required this.selectedVideoUrl,
//     required this.onBackFromVideoDetails,
//     required this.onVideoSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     switch (selectedTabIndex) {
//       case 0: // Available
//         return TalentCard.buildAvailableContentSliver(
//           context: context,
//           cubit: cubit,
//           isSearching: isSearching,
//         );
//       case 1: // Favorites
//         return TalentCard.buildFavoriteContentSliver(
//           context: context,
//           cubit: cubit,
//         );
//       case 2: // History
//         return TalentCard.buildHistoryContentSliver(
//           context: context,
//           cubit: cubit,
//         );
//       case 3: // My Talents
//         return _buildMyTalentTab();
//       default:
//         return TalentCard.buildAvailableContentSliver(
//           context: context,
//           cubit: cubit,
//           isSearching: isSearching,
//         );
//     }
//   }

//   Widget _buildMyTalentTab() {
//     final size = MediaQuery.of(context).size;

//     // Show VideoDetailsView if video is selected, otherwise show list
//     if (showVideoDetails &&
//         selectedVideoTalent != null &&
//         selectedVideoUrl != null) {
//       return SliverToBoxAdapter(
//         child: SizedBox(
//           height: size.height * 0.75, // Responsive height
//           child: VideoDetailsView(
//             talent: selectedVideoTalent!,
//             mediaUrl: selectedVideoUrl!,
//             onBack: onBackFromVideoDetails,
//           ),
//         ),
//       );
//     } else {
//       return TalentCard.buildMyTalentContentSliver(
//         context: context,
//         cubit: cubit,
//         onVideoTap: onVideoSelected,
//       );
//     }
//   }
// }
