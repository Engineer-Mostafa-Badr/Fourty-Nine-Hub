import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../constants/tube_constants.dart';

enum EmptyStateType {
  noResults,
  noFavorites,
  noHistory,
  noMyVideos,
}

class EmptyStateWidget extends StatelessWidget {
  final EmptyStateType type;
  final bool isSearching;

  const EmptyStateWidget({
    super.key,
    required this.type,
    this.isSearching = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            config.icon,
            size: TubeConstants.emptyStateIconSize,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            config.title,
            style: TextStyle(
              fontSize: TubeConstants.emptyStateTitleFontSize,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          if (config.subtitle != null) ...[
            SizedBox(height: 8),
            Text(
              config.subtitle!,
              style: TextStyle(
                fontSize: TubeConstants.emptyStateSubtitleFontSize,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  _EmptyStateConfig _getConfig(BuildContext context) {
    final isArabic = context.isArabic;

    switch (type) {
      case EmptyStateType.noResults:
        return _EmptyStateConfig(
          icon: Icons.video_library_outlined,
          title: isSearching
              ? (isArabic
                  ? TubeConstants.noResultsFoundAr
                  : TubeConstants.noResultsFoundEn)
              : (isArabic
                  ? TubeConstants.noResultsFoundAr
                  : TubeConstants.noResultsFoundEn),
          subtitle: !isSearching
              ? (isArabic
                  ? TubeConstants.pullToRefreshAr
                  : TubeConstants.pullToRefreshEn)
              : null,
        );

      case EmptyStateType.noFavorites:
        return _EmptyStateConfig(
          icon: Icons.favorite_border,
          title: isArabic
              ? TubeConstants.noFavoriteVideosAr
              : TubeConstants.noFavoriteVideosEn,
          subtitle: isArabic
              ? TubeConstants.addToFavoritesHintAr
              : TubeConstants.addToFavoritesHintEn,
        );

      case EmptyStateType.noHistory:
        return _EmptyStateConfig(
          icon: Icons.history,
          title: isArabic
              ? TubeConstants.noHistoryVideosAr
              : TubeConstants.noHistoryVideosEn,
          subtitle: isArabic
              ? TubeConstants.historyHintAr
              : TubeConstants.historyHintEn,
        );

      case EmptyStateType.noMyVideos:
        return _EmptyStateConfig(
          icon: Icons.video_library_outlined,
          title: isArabic
              ? TubeConstants.noMyVideosAr
              : TubeConstants.noMyVideosEn,
          subtitle: isArabic
              ? TubeConstants.addTalentHintAr
              : TubeConstants.addTalentHintEn,
        );
    }
  }
}

class _EmptyStateConfig {
  final IconData icon;
  final String title;
  final String? subtitle;

  _EmptyStateConfig({
    required this.icon,
    required this.title,
    this.subtitle,
  });
}
