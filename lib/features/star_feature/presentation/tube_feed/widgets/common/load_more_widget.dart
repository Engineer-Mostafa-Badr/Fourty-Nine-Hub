import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

import '../../../presentation_exports.dart';
import '../../constants/tube_constants.dart';

class LoadMoreWidget extends StatelessWidget {
  final StarState state;
  final TalentCategory category;
  final StarCubit cubit;

  const LoadMoreWidget({
    super.key,
    required this.state,
    required this.category,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading(category)) {
      return _buildLoadingWidget(context);
    }

    if (!state.hasMore(category)) {
      return _buildNoMoreContentWidget(context);
    }

    return _buildLoadMoreButton(context);
  }

  Widget _buildLoadingWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          children: [
            CustomCircularProgressIndicator(),
            SizedBox(height: 8),
            Text(
              context.isArabic
                  ? TubeConstants.loadingAr
                  : TubeConstants.loadingEn,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: TubeConstants.loadMoreButtonFontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoMoreContentWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 24,
            ),
            SizedBox(height: 8),
            Text(
              context.isArabic
                  ? TubeConstants.noMoreContentAr
                  : TubeConstants.noMoreContentEn,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: TubeConstants.loadMoreButtonFontSize,
              ),
            ),
            SizedBox(height: 4),
            Text(
              context.isArabic
                  ? TubeConstants.pullToRefreshAr
                  : TubeConstants.pullToRefreshEn,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () => cubit.loadTalents(category),
          icon: Icon(
            Icons.refresh,
            size: TubeConstants.loadMoreButtonIconSize,
            color: Colors.white,
          ),
          label: Text(
            context.isArabic
                ? TubeConstants.loadMoreAr
                : TubeConstants.loadMoreEn,
            style: TextStyle(
              fontSize: TubeConstants.loadMoreButtonFontSize,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ),
    );
  }
}
