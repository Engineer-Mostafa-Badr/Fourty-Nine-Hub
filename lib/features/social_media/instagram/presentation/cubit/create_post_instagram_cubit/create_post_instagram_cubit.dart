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
      final File futureFile = await Future.value(File(pickedImage.path));
      final List<File> selectedImages = state.selectedImages;
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
      List<File> newSelectedMeda =
          List<File>.from(state.selectedMeda);
      if (newSelectedMeda.contains(state.images[index])) {
        newSelectedMeda.remove(state.images[index]);
      } else {
        newSelectedMeda.add(state.images[index]);
      }

      // تعديل selectedImages
      List<File> newSelectedImages = state.selectedImages;
      // List<Future<File?>>.from(state.selectedImages);
      if (newSelectedImages.contains(state.images[index])) {
        newSelectedImages.remove(state.images[index]);
      } else {
        newSelectedImages.add(state.images[index]);
      }

      emit(state.copyWith(
        selectedImages: newSelectedImages,
        selectedMeda: newSelectedMeda,
      ));
    } else {
      // تعديل selectedImages فقط في حالة عدم تفعيل الاختيار المتعدد
      List<File> newSelectedImages = [state.images[index]];
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
  final List<Widget> _mediaList = [];
  // final List<File> path = [];
  File? _file;
  // int currentPage = 0;
  // int? lastPage;

  // _fetchNewMedia() async {
  //   lastPage = currentPage;
  //   final PermissionState ps = await PhotoManager.requestPermissionExtend();
  //   if (ps.isAuth) {
  //     List<AssetPathEntity> album = await PhotoManager.getAssetPathList(
  //       onlyAll: true,
  //     );
  //     List<AssetEntity> media = await album[0].getAssetListPaged(
  //       page: currentPage,
  //       size: 60,
  //     );
  //     for (var asset in media) {
  //       if (asset.type == AssetType.image) {
  //         final file = await asset.file;
  //         if (file != null) {
  //           path.add(File(file.path));
  //           _file = path[0];
  //         }
  //       }
  //     }
  //     List<Widget> temp = [];
  //     for (var asset in media) {
  //       temp.add(FutureBuilder(
  //         future: asset.thumbnailDataWithSize(
  //           const ThumbnailSize(200, 200),
  //         ),
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.done) {
  //             return Container(
  //               child: Stack(
  //                 children: [
  //                   Positioned.fill(
  //                     child: Image.memory(snapshot.data!, fit: BoxFit.cover),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }
  //           return Container();
  //         },
  //       ));
  //     }
  //   }
  // }

  Future<void> loadImages(context) async {
    emit(state.copyWith(status: CreatePostInstagramStates.loading));
    final hasPermission = await _requestPermission();
    if (hasPermission) {
      List<File> path = await _fetchImagesPage(state.currentPage, 60);

      emit(state.copyWith(
        status: CreatePostInstagramStates.initial,
        isPermissionGranted: true,
        currentPage: 0,
        hasMoreImages: path.length == 60,
        images: path,
      ));
      // List<Widget> temp = [];
      // for (var asset in media) {
      //   temp.add(FutureBuilder(
      //     future: asset.thumbnailDataWithSize(
      //       const ThumbnailSize(200, 200),
      //     ),
      //     builder: (context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.done) {
      //         return Container(
      //           child: Stack(
      //             children: [
      //               Positioned.fill(
      //                 child: Image.memory(snapshot.data!, fit: BoxFit.cover),
      //               ),
      //             ],
      //           ),
      //         );
      //       }
      //       return Container();
      //     },
      //   ));
      // }
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

  // Future<void> loadImages2(context) async {
  //   emit(state.copyWith(status: CreatePostInstagramStates.loading));
  //   final hasPermission = await _requestPermission();
  //   if (hasPermission) {
  //     final List<AssetEntity> initialImages = await _fetchAllImages(0, 80);
  //
  //     // selectedImage = images.first.file;
  //     emit(state.copyWith(
  //       status: CreatePostInstagramStates.initial,
  //       isPermissionGranted: true,
  //       currentPage: 0,
  //       hasMoreImages: initialImages.length == 80,
  //       images: initialImages,
  //     ));
  //   } else {
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   const SnackBar(content: Text('Permission denied!')),
  //     // );
  //     emit(state.copyWith(
  //       status: CreatePostInstagramStates.initial,
  //       isPermissionGranted: false,
  //     ));
  //   }
  // }

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
  Future<List<File>> _fetchImagesPage(int page, int pageSize) async {
    List<File> path = [];
    List<AssetPathEntity> album = await PhotoManager.getAssetPathList(
      onlyAll: true,
    );
    List<AssetEntity> media = await album[0].getAssetListPaged(
      page: page,
      size: pageSize,
    );
    for (var asset in media) {
      if (asset.type == AssetType.image) {
        final file = await asset.file;
        if (file != null) {
          path.add(File(file.path));
          _file = path[0];
        }
      }
    }
    return path;
    // final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
    //   type: RequestType.image,
    // );
    //
    // if (albums.isNotEmpty) {
    //   final AssetPathEntity album = albums.first;
    //   // جلب الصور في الصفحة المحددة فقط
    //   return await album.getAssetListPaged(page: page, size: pageSize);
    // }
    // return [];
  }

  // دالة لتحميل المزيد من الصور عند الحاجة (للاستدعاء عند التمرير لأسفل)
  Future<void> loadMoreImages() async {
    if (!state.hasMoreImages) return;

    final nextPage = state.currentPage + 1;
    final newImages = await _fetchImagesPage(nextPage, 60);

    if (newImages.isNotEmpty) {
      emit(state.copyWith(
        images: [...state.images, ...newImages],
        currentPage: nextPage,
        hasMoreImages: newImages.length == 60,
      ));
    } else {
      emit(state.copyWith(hasMoreImages: false));
    }
  }
}
