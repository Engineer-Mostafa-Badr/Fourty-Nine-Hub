import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

part 'create_post_instagram_state.dart';

class CreatePostInstagramCubit extends Cubit<CreatePostInstagramState> {
  CreatePostInstagramCubit() : super(const CreatePostInstagramState());

  // Future<File?>? selectedImage;
  List postTypes = ["Post", "Story", "Reel"];

  Future<void> pickImage() async {
    var pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      Future<File?> futureFile = Future.value(File(pickedImage.path));
      emit(state.copyWith(selectedImage: futureFile));
      // selectedImage =
      //     futureFile; // تعيين الصورة في selectedImage
    }
  }

  void changeMultiSelect() {
    emit(state.copyWith(multiSelect: !state.multiSelect));
  }

  void onTapImage(index) {
    if (state.multiSelect) {
      // selectedMeda.add(images[index]);
      if (state.selectedMeda.contains(state.images[index])) {
        state.selectedMeda.remove(state.images[index]);
      } else {
        state.selectedMeda.add(state.images[index]);
      }
      emit(state.copyWith(
        selectedImage: state.images[index].file,
      ));
      // selectedImage = widget.images[index].file;
    } else {
      emit(state.copyWith(selectedImage: state.images[index].file));
      // selectedImage = widget.images[index].file;
    }
  }

  void changePostType(int index) {
    emit(state.copyWith(postTypeSelectedIndex: index));
  }

  Future<void> loadImages(context) async {
    emit(state.copyWith(status: CreatePostInstagramStates.loading));
    final hasPermission = await _requestPermission();
    if (hasPermission) {
      final fetchedImages = await _fetchAllImages();

      // selectedImage = images.first.file;
      emit(state.copyWith(
        status: CreatePostInstagramStates.initial,
        isPermissionGranted: true,
        images: fetchedImages,
      ));
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Permission denied!')),
      // );
      emit(state.copyWith(
        status: CreatePostInstagramStates.initial,
        isPermissionGranted: false,
      ));
    }
  }

  Future<bool> _requestPermission() async {
    final PermissionState result = await PhotoManager.requestPermissionExtend();
    return result.isAuth; // تحقق من أن الإذن مُعطى
  }

  Future<List<AssetEntity>> _fetchAllImages() async {
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        // type: RequestType.fromTypes([RequestType.image, RequestType.video]), // جلب الصور فقط
        type: RequestType.image,
        );

    if (albums.isNotEmpty) {
      final AssetPathEntity album = albums.first; // اختر الألبوم الأول
      List<AssetEntity> allImages = [];
      int page = 0; // ابدأ من الصفحة الأولى
      const int pageSize = 20;

      while (true) {
        // جلب الصور في الصفحة الحالية
        final List<AssetEntity> images =
            await album.getAssetListPaged(page: page, size: pageSize);
        if (images.isEmpty) {
          break; // إذا لم تكن هناك صور إضافية، أخرج من الحلقة
        }
        allImages.addAll(images); // أضف الصور إلى القائمة النهائية
        page++; // انتقل إلى الصفحة التالية
      }

      return allImages;
    }

    return [];
  }
}
