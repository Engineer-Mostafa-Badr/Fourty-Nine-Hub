String formatFileSize({required int fileSizeInBytes}) {
  const int kb = 1024;
  const int mb = kb * 1024;
  const int gb = mb * 1024;

  if (fileSizeInBytes < kb) {
    return '$fileSizeInBytes B';
  } else if (fileSizeInBytes < mb) {
    double sizeInKB = fileSizeInBytes / kb;
    return '${sizeInKB.toStringAsFixed(2)} KB';
  } else if (fileSizeInBytes < gb) {
    double sizeInMB = fileSizeInBytes / mb;
    return '${sizeInMB.toStringAsFixed(2)} MB';
  } else {
    double sizeInGB = fileSizeInBytes / gb;
    return '${sizeInGB.toStringAsFixed(2)} GB';
  }
}
