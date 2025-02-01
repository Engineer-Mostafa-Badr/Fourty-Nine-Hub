import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/media_post_request_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/repositories/instagram_repository.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/Post/post_instagram_state.dart';
import 'package:path/path.dart' as path;

class CreatePostInstagramCubit extends Cubit<PostInstagramState> {
  final InstagramRepository repository;
  CreatePostInstagramCubit({required this.repository})
      : super(InitialPostInstagramState());

  create({required String content, required List<File> images}) async {
    emit(LoadingPostInstagramState());
    List<MediaPostRequestModel> media = [];
    for (var i = 0; i < images.length; i++) {
      int size = await getFileSize(images[i]);
      String type = getFileExtension(images[i]);
      media.add(MediaPostRequestModel(itemId: "$i", size: size, type: type));
    }
    var response = await repository.createPost(content: content, media: media);
    response.fold(
      (l) {
        emit(FailurePostInstagramState(failure: l));
      },
      (r) {
        emit(SuccessCreatePostInstagramState());
      },
    );
  }

  String getFileExtension(File file) {
    if (file.existsSync()) {
      String extension = path
          .extension(file.path)
          .substring(1); // الحصول على الامتداد بدون النقطة
      if (extension == 'mp4' ||
          extension == 'avi' ||
          extension == 'mkv' ||
          extension == 'mov') {
        return "video/$extension"; // إذا كان الفيديو
      } else if (extension == 'png' ||
          extension == 'jpg' ||
          extension == 'jpeg' ||
          extension == 'gif') {
        return "image/$extension"; // إذا كانت الصورة
      } else {
        return "unknown/$extension"; // إذا كان نوعًا آخر غير معروف
      }
    } else {
      return "image/png"; // إذا لم يكن الملف موجودًا، نرجع صورة افتراضية
    }
  }

  Future<int> getFileSize(File file) async {
    final bytes = await file.readAsBytes();
    return bytes.length;
  }
}
