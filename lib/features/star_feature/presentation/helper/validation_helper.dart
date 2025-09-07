import 'dart:io';
import '../utils/constants.dart';

class ValidationHelper {
  static ValidationResult validateVideoFile(File videoFile) {
    final result = ValidationResult();

    try {
      // Check file size
      final fileSizeInBytes = videoFile.lengthSync();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      if (fileSizeInMB > StarConstants.maxVideoSizeMB) {
        result.addError(
            'File too large: ${fileSizeInMB.toStringAsFixed(2)}MB (max ${StarConstants.maxVideoSizeMB}MB)');
      } else if (fileSizeInMB > 100) {
        result.addWarning(
            'Large file: ${fileSizeInMB.toStringAsFixed(2)}MB - upload may take longer');
      }

      // Check file extension
      final extension = videoFile.path.split('.').last.toLowerCase();
      if (!StarConstants.supportedVideoFormats.contains(extension)) {
        result.addError('Unsupported video format: $extension');
      }

      // Check filename
      final fileName = videoFile.path.split('/').last;
      if (fileName.contains(' ')) {
        result.addWarning('File name contains spaces - may cause issues');
      }

      // Add file info
      result.info['fileName'] = fileName;
      result.info['extension'] = extension;
      result.info['sizeInBytes'] = fileSizeInBytes;
      result.info['sizeInMB'] = fileSizeInMB.toStringAsFixed(2);
    } catch (e) {
      result.addError('Error validating file: $e');
    }

    return result;
  }

  static ValidationResult validateImageFile(File imageFile) {
    final result = ValidationResult();

    try {
      // Check file size
      final fileSizeInBytes = imageFile.lengthSync();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      if (fileSizeInMB > StarConstants.maxImageSizeMB) {
        result.addError(
            'Image too large: ${fileSizeInMB.toStringAsFixed(2)}MB (max ${StarConstants.maxImageSizeMB}MB)');
      }

      // Check file extension
      final extension = imageFile.path.split('.').last.toLowerCase();
      if (!StarConstants.supportedImageFormats.contains(extension)) {
        result.addError('Unsupported image format: $extension');
      }

      // Add file info
      result.info['fileName'] = imageFile.path.split('/').last;
      result.info['extension'] = extension;
      result.info['sizeInBytes'] = fileSizeInBytes;
      result.info['sizeInMB'] = fileSizeInMB.toStringAsFixed(2);
    } catch (e) {
      result.addError('Error validating image: $e');
    }

    return result;
  }

  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

class ValidationResult {
  final List<String> _errors = [];
  final List<String> _warnings = [];
  final Map<String, dynamic> info = {};

  List<String> get errors => List.unmodifiable(_errors);
  List<String> get warnings => List.unmodifiable(_warnings);

  bool get isValid => _errors.isEmpty;
  bool get hasWarnings => _warnings.isNotEmpty;

  void addError(String error) => _errors.add(error);
  void addWarning(String warning) => _warnings.add(warning);

  Map<String, dynamic> toMap() {
    return {
      'isValid': isValid,
      'errors': errors,
      'warnings': warnings,
      'info': info,
    };
  }
}
