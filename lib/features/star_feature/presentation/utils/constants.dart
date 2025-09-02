class StarConstants {
  // Pagination
  static const int pageSize = 10;
  static const int maxRetries = 2;
  static const int searchLimit = 20;

  // Upload limits
  static const int maxVideoSizeMB = 500;
  static const int maxImageSizeMB = 10;
  static const Duration maxVideoDuration = Duration(minutes: 30);

  // Video formats
  static const List<String> supportedVideoFormats = [
    'mp4',
    'mov',
    'avi',
    'mkv'
  ];
  static const List<String> supportedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'bmp',
    'webp'
  ];

  // Bunny CDN
  static const String bunnyTusEndpoint = "https://video.bunnycdn.com/tusupload";

  // UI Constants
  static const Duration hideControlsDelay = Duration(seconds: 3);
  static const Duration videoSeekStepDuration = Duration(seconds: 10);
  static const int maxSearchResults = 50;
  static const Duration searchDebounceDelay = Duration(milliseconds: 500);

  // Cache settings
  static const Duration cacheTimeout = Duration(minutes: 5);
}