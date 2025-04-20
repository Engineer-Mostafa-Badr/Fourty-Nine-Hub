import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

part 'create_post_instagram_state.dart';

class CreatePostInstagramCubit extends Cubit<CreatePostInstagramState> {
  CreatePostInstagramCubit() : super(const CreatePostInstagramState());

  // Future<File?>? selectedImage;
  List postTypes = ["Post", "Story", "Reel"];

  void nextPage(BuildContext context) {
    log('nextPage ------------------------------------------------------------');
    context.push(
      Routes.CREATEPOSTSECONDPAGEINSTAGRAM,
      extra: state.selectedImages,
    );
  }

  Future<void> pickImage() async {
    var pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      final Future<File?> futureFile = Future.value(File(pickedImage.path));
      final List<Future<File?>> selectedImages = state.selectedImages;
      selectedImages.add(futureFile);
      emit(state.copyWith(selectedImages: selectedImages));
      // selectedImage =
      //     futureFile; // تعيين الصورة في selectedImage
    }
  }

  void changeMultiSelect() {
    emit(state.copyWith(multiSelect: !state.multiSelect));
  }

  void onTapImage(index) {
    if (state.multiSelect) {
      // تعديل selectedMeda
      List<AssetEntity> newSelectedMeda =
          List<AssetEntity>.from(state.selectedMeda);
      if (newSelectedMeda.contains(state.images[index])) {
        newSelectedMeda.remove(state.images[index]);
      } else {
        newSelectedMeda.add(state.images[index]);
      }

      // تعديل selectedImages
      List<Future<File?>> newSelectedImages = state.selectedImages;
      // List<Future<File?>>.from(state.selectedImages);
      if (newSelectedImages.contains(state.images[index].file)) {
        newSelectedImages.remove(state.images[index].file);
      } else {
        newSelectedImages.add(state.images[index].file);
      }

      emit(state.copyWith(
        selectedImages: newSelectedImages,
        selectedMeda: newSelectedMeda,
      ));
    } else {
      // تعديل selectedImages فقط في حالة عدم تفعيل الاختيار المتعدد
      List<Future<File?>> newSelectedImages = [state.images[index].file];
      // List<Future<File?>>.from(state.selectedImages)
      //   ..add(state.images[index].file);
      // if (newSelectedImages.contains(state.images[index].file)) {
      //   newSelectedImages.remove(state.images[index].file);
      // } else {
      //   newSelectedImages.add(state.images[index].file);
      // }

      emit(
        state.copyWith(
          selectedImages: newSelectedImages,
        ),
      );
    }
  }

  // void onTapImage(index) {
  //   if (state.multiSelect) {
  //     // selectedMeda.add(images[index]);
  //     if (state.selectedMeda.contains(state.images[index])) {
  //       state.selectedMeda.remove(state.images[index]);
  //     } else {
  //       state.selectedMeda.add(state.images[index]);
  //     }
  //     List<Future<File?>> selectedImages = state.selectedImages;
  //     if (selectedImages.contains(state.images[index].file)) {
  //       selectedImages.remove(state.images[index].file);
  //     } else {
  //       selectedImages.add(state.images[index].file);
  //     }
  //     emit(state.copyWith(
  //       selectedImages: selectedImages,
  //     ));
  //     // selectedImage = widget.images[index].file;
  //   } else {
  //      List<Future<File?>> selectedImages = state.selectedImages;
  //     if (selectedImages.contains(state.images[index].file)) {
  //       selectedImages.remove(state.images[index].file);
  //     } else {
  //       selectedImages.add(state.images[index].file);
  //     }
  //     emit(state.copyWith(selectedImages: selectedImages));
  //     // selectedImage = widget.images[index].file;
  //   }
  // }

  void changePostType(int index) {
    emit(state.copyWith(postTypeSelectedIndex: index));
  }

  Future<void> loadImages(context) async {
    emit(state.copyWith(status: CreatePostInstagramStates.loading));
  }

  Future<void> loadImages2(context) async {
    emit(state.copyWith(status: CreatePostInstagramStates.loading));
    final hasPermission = await _requestPermission();
    if (hasPermission) {
      final List<AssetEntity> initialImages = await _fetchAllImages(0, 80);

      // selectedImage = images.first.file;
      emit(state.copyWith(
        status: CreatePostInstagramStates.initial,
        isPermissionGranted: true,
        currentPage: 0,
        hasMoreImages: initialImages.length == 80,
        images: initialImages,
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

  Future<List<AssetEntity>> _fetchAllImages(int page, int pageSize) async {
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      onlyAll: true,
      // type: RequestType.fromTypes([RequestType.image, RequestType.video]), // جلب الصور فقط
      type: RequestType.image,
    );
    if (albums.isNotEmpty) {
      final AssetPathEntity album = albums.first;
      // جلب الصور في الصفحة المحددة فقط
      return await album.getAssetListPaged(page: page, size: pageSize);
    }
    return [];

    // if (albums.isNotEmpty) {
    //   final AssetPathEntity album = albums.first; // اختر الألبوم الأول
    //   List<AssetEntity> allImages = [];
    //   int page = 0; // ابدأ من الصفحة الأولى
    //   const int pageSize = 20;
    //   while (true) {
    //     // جلب الصور في الصفحة الحالية
    //     final List<AssetEntity> images =
    //         await album.getAssetListPaged(page: page, size: pageSize);
    //     if (images.isEmpty) {
    //       break; // إذا لم تكن هناك صور إضافية، أخرج من الحلقة
    //     }
    //     allImages.addAll(images); // أضف الصور إلى القائمة النهائية
    //     page++; // انتقل إلى الصفحة التالية
    //   }
    //   return allImages;
    // }
    // return [];
  }

// تحميل صفحة محددة من الصور
  Future<List<AssetEntity>> _fetchImagesPage(int page, int pageSize) async {
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    if (albums.isNotEmpty) {
      final AssetPathEntity album = albums.first;
      // جلب الصور في الصفحة المحددة فقط
      return await album.getAssetListPaged(page: page, size: pageSize);
    }
    return [];
  }

  // دالة لتحميل المزيد من الصور عند الحاجة (للاستدعاء عند التمرير لأسفل)
  Future<void> loadMoreImages() async {
    if (!state.hasMoreImages) return;

    final nextPage = state.currentPage + 1;
    final newImages = await _fetchImagesPage(nextPage, 20);

    if (newImages.isNotEmpty) {
      emit(state.copyWith(
        images: [...state.images, ...newImages],
        currentPage: nextPage,
        hasMoreImages: newImages.length == 20,
      ));
    } else {
      emit(state.copyWith(hasMoreImages: false));
    }
  }
}
