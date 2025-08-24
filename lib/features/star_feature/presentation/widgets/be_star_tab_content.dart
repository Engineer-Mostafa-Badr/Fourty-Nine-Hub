import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_cubit.dart';
import 'package:fourtyninehub/features/star_feature/presentation/pages/video_details_view.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/talent_card_widget.dart';

class BeStarTabContent extends StatelessWidget {
  final int selectedTabIndex;
  final BuildContext context;
  final StarCubit cubit;
  final bool isSearching;
  final List<StarEntity> filteredTalents;
  final bool showVideoDetails;
  final StarEntity? selectedVideoTalent;
  final String? selectedVideoUrl;
  final VoidCallback onBackFromVideoDetails;
  final Function(StarEntity, String) onVideoSelected;

  const BeStarTabContent({
    super.key,
    required this.selectedTabIndex,
    required this.context,
    required this.cubit,
    required this.isSearching,
    required this.filteredTalents,
    required this.showVideoDetails,
    required this.selectedVideoTalent,
    required this.selectedVideoUrl,
    required this.onBackFromVideoDetails,
    required this.onVideoSelected,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedTabIndex) {
      case 0:
        return TalentCard.buildAvailableContentSliver(
          context: context,
          cubit: cubit,
          isSearching: isSearching,
          filteredTalents: filteredTalents,
        );
      case 1:
        return TalentCard.buildFavoriteContentSliver(
          context: context,
          cubit: cubit,
        );
      case 2:
        return TalentCard.buildHistoryContentSliver(
          context: context,
          cubit: cubit,
        );
      case 3:
        return _buildMyTalentTab();
      default:
        return TalentCard.buildAvailableContentSliver(
          context: context,
          cubit: cubit,
          isSearching: isSearching,
          filteredTalents: filteredTalents,
        );
    }
  }

  Widget _buildMyTalentTab() {
    // Show VideoDetailsView if video is selected, otherwise show list
    if (showVideoDetails &&
        selectedVideoTalent != null &&
        selectedVideoUrl != null) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: VideoDetailsView(
            talent: selectedVideoTalent!,
            mediaUrl: selectedVideoUrl!,
            onBack: onBackFromVideoDetails,
          ),
        ),
      );
    } else {
      return TalentCard.buildMyTalentContentSliver(
        context: context,
        cubit: cubit,
        onVideoTap: onVideoSelected,
      );
    }
  }
}