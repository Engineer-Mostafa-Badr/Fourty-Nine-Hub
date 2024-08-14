import 'package:image_picker/image_picker.dart';

class FilePickerHelper {
  Future<XFile?> pickImage({bool isGallery = true}) async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(
        source: isGallery ? ImageSource.gallery : ImageSource.camera);
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
