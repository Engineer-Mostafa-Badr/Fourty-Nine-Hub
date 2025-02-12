import 'package:image_picker/image_picker.dart';

class FilePickerHelper {
  Future<XFile?> pickImage({bool isGallery = true}) async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(
        source: isGallery ? ImageSource.gallery : ImageSource.camera);
  }
  Future<XFile?> pickMedia2({bool isGallery = true}) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? file = await picker.pickMedia();

      if (file == null) {
        print("No media selected");
      } else {
        print("Picked file path: ${file.path}");
      }

      return file;
    } catch (e) {
      print("Error picking media: $e");
      return null;
    }
  }

  Future<List<XFile>?> pickImages({bool isGallery = true}) async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickMultiImage(
      imageQuality: 100, // Adjust quality as needed (e.g., 100 for maximum quality)
    );
  }

  Future<XFile?> pickVideo({bool isGallery = true}) async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickVideo(
        source: isGallery ? ImageSource.gallery : ImageSource.camera);
  }

  Future<XFile?> pickMedia({bool isGallery = true}) async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickMedia();
  }
}
