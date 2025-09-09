enum StarStates { loading, initial, success, uploadSuccess, error }

enum TalentCategory {
  available, // All available talents
  favorites, // User's favorite talents
  history, // User's viewing history
  myTalents // User's uploaded talents
}

enum ProfileStatus { initial, loading, success, error, updating }

enum ImageType { cover, profile }

enum VideoQuality { low, medium, high, auto }

enum UploadStage {
  validating,
  creatingEntry,
  uploadingThumbnail,
  uploadingVideo,
  finalizing,
  completed,
  failed
}
