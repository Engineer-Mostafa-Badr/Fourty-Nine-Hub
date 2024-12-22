import 'dart:typed_data';

// import 'package:image_gallery_saver/image_gallery_saver.dart';

abstract class ImageSaverService {
  Future<bool> saveImage(Uint8List image, int id);
}

class ImageSaverServiceImpl extends ImageSaverService {
  @override
  Future<bool> saveImage(Uint8List image, int id) async {
    final Map<dynamic, dynamic> response = {};
    // await ImageGallerySaver.saveImage(image, name: '$id.png');

    bool success = response["isSuccess"];
    return success;
  }
}
