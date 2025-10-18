class TubeConstants {
  // Durations
  static const searchDebounceDuration = Duration(milliseconds: 800);
  static const scrollSyncAnimationDuration = Duration(milliseconds: 300);
  static const refreshIndicatorDisplacement = 40.0;
  static const refreshIndicatorStrokeWidth = 2.5;

  // Scroll Sync
  static const scrollSyncThreshold = 1.0;

  // Video approval message
  static const videoNotAvailableAr =
      'تم رفع الفيديو بنجاح!\n\nملاحظة: الفيديو غير متاح حالياً. البث المباشر أو ملف الفيديو غير جاهز بعد. يحتاج وقت ليصبح متاحاً للمستخدمين.';
  static const videoNotAvailableEn =
      'Video uploaded successfully!\n\nNote: Video is not currently available. The live stream or video file are not yet ready. It takes time before it becomes available to users.';

  // Empty state messages
  static const noResultsFoundAr = 'لا يوجد نتائج بحث';
  static const noResultsFoundEn = 'No search results found';

  static const noFavoriteVideosAr = 'لا يوجد فيديوات مفضلة بعد';
  static const noFavoriteVideosEn = 'No favorite videos yet';
  static const addToFavoritesHintAr = 'اضغط على القلب لإضافة فيديوات للمفضلة';
  static const addToFavoritesHintEn = 'Tap the heart icon to add videos to favorites';

  static const noHistoryVideosAr = 'لا يوجد فيديوات في التاريخ';
  static const noHistoryVideosEn = 'No videos in history';
  static const historyHintAr = 'الفيديوات التي شاهدتها ستظهر هنا';
  static const historyHintEn = 'Videos you watch will appear here';

  static const noMyVideosAr = 'لا توجد مقاطع فيديو بعد';
  static const noMyVideosEn = 'No videos yet';
  static const addTalentHintAr = 'اضغط على "إضافة موهبة" لرفع أول فيديو';
  static const addTalentHintEn = 'Tap "Add Talent" to upload your first video';

  static const pullToRefreshAr = 'اسحب للأسفل للتحديث';
  static const pullToRefreshEn = 'Pull down to refresh';

  // Loading messages
  static const loadingAr = 'جاري التحميل...';
  static const loadingEn = 'Loading...';

  static const loadMoreAr = 'تحميل المزيد';
  static const loadMoreEn = 'Load More';

  static const noMoreContentAr = 'لا يوجد المزيد من المحتوى';
  static const noMoreContentEn = 'No more content';

  // UI Sizes
  static const emptyStateIconSize = 64.0;
  static const emptyStateTitleFontSize = 18.0;
  static const emptyStateSubtitleFontSize = 14.0;
  static const loadMoreButtonIconSize = 18.0;
  static const loadMoreButtonFontSize = 14.0;
}
