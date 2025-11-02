import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/create_post_request_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/location_instagram_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/user_tag_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/create_post_request_use_case.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../../../core/enums/songs_enum.dart';
import '../../../domain/entities/song_entity.dart';
import '../../../domain/usecases/add_remove_songs_from_favs_usecase.dart';
import '../../../domain/usecases/get_for_you_songs_usecase.dart';
import '../../../domain/usecases/get_saved_songs_useacase.dart';
import '../../../domain/usecases/get_treinding_songs_usecase.dart';
import '../../../domain/usecases/post_confirm_webhook_use_case.dart';
import '../../../domain/usecases/search_songs_usecase.dart';

part 'create_post_instagram_state.dart';

class CreatePostInstagramCubit extends Cubit<CreatePostInstagramState> {
  CreatePostInstagramCubit(
    this.createPostInstagramUseCase,
    this.postConfirmWebhookUseCase,
    this.getForYouSongsUseCase,
    this.getTrendingSongsUseCase,
    this.getSavedSongsUseCase,
    this.addRemoveSongsFromFavsUseCase,
    this.searchSongsUseCase,
  ) : super(CreatePostInstagramState());

  final CreateRequestPostInstagramUseCase createPostInstagramUseCase;
  final PostConfirmWebhookUseCase postConfirmWebhookUseCase;
  final GetForYouSongsUseCase getForYouSongsUseCase;
  final GetTrendingSongsUseCase getTrendingSongsUseCase;
  final GetSavedSongsUseCase getSavedSongsUseCase;
  final AddRemoveSongsFromFavsUseCase addRemoveSongsFromFavsUseCase;
  final SearchSongsUseCase searchSongsUseCase;
  final AudioPlayer _audioPlayer = AudioPlayer();
  TextEditingController searchController = TextEditingController();
  List<SongEntity> searchSongs = [];

  void clearSearch() {
    searchController.clear();
    searchSongs = [];
    emit(state.copyWith(
      status: CreatePostInstagramStates.success,
    ));
  }

  Future<void> searchForSongs() async {
    emit(state.copyWith(status: CreatePostInstagramStates.loading));
    final result = await searchSongsUseCase(query: searchController.text);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CreatePostInstagramStates.failure,
            failure: failure,
          ),
        );
      },
      (data) {
        searchSongs = data;
        emit(
          state.copyWith(
            status: CreatePostInstagramStates.success,
          ),
        );
      },
    );
  }

  void changeMusicSection(SongsEnum song) {
    if (state.selectedSong == song) return;
    emit(state.copyWith(
      selectedSong: song,
    ));
  }

  Future<void> addRemoveSongFromFavs({required SongEntity song}) async {
    final result = await addRemoveSongsFromFavsUseCase(songId: song.id);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CreatePostInstagramStates.failure,
            failure: failure,
          ),
        );
      },
      (data) {
        song.isSaved = !song.isSaved;
        if (song.isSaved) {
          if (favoriteSongs.where((e) => e.id == song.id).isEmpty) {
            favoriteSongs.add(song);
          }
        } else {
          favoriteSongs.removeWhere((e) => e.id == song.id);
        }
        emit(
          state.copyWith(
            status: CreatePostInstagramStates.success,
          ),
        );
      },
    );
  }

  Future<void> refreshUI() async {
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith());
  }

  Future<void> setSong({required SongEntity song}) async {
    emit(state.copyWith(song: song, isPlaying: true));

    try {
      await _audioPlayer.setUrl(song.songUrl); // رابط الصوت
      await _audioPlayer.play();
      // emit(state.copyWith(isPlaying: true, song: song));
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  void makeSongNull() {
    emit(state.copyWith(clearSong: true));
  }

  void disposeAudioPlayer() {
    _audioPlayer.pause();
    emit(state.copyWith(isPlaying: false));
  }

  Future<void> togglePlayPause() async {
    emit(state.copyWith(isPlaying: !state.isPlaying));
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }

  // for you songs
  List<SongEntity> forYouSongs = [];
  bool isLoadingMoreForYou = false;
  bool hasMoreDataForYou = true;
  int currentPageForYou = 1;

  // trending songs
  List<SongEntity> trendingSongs = [];
  bool isLoadingMoreTrending = false;
  bool hasMoreDataTrending = true;
  int currentPageTrending = 1;

  // favorite songs
  List<SongEntity> favoriteSongs = [];
  bool isLoadingMoreFavorite = false;
  bool hasMoreDataFavorite = true;
  int currentPageFavorite = 1;
  int pageSize = 10;

  // for you
  Future<void> loadInitialForYouSongs() async {
    forYouSongs.clear();
    currentPageForYou = 1;
    hasMoreDataForYou = true;
    emit(state.copyWith(status: CreatePostInstagramStates.loading));
    await _fetchForYouSongs();
  }

  Future<void> getForYouSongs() async {
    if (!hasMoreDataForYou || isLoadingMoreForYou) return;
    isLoadingMoreForYou = true;
    emit(state.copyWith(status: CreatePostInstagramStates.loading));
    await _fetchForYouSongs();
  }

  Future<void> _fetchForYouSongs() async {
    final result = await getForYouSongsUseCase(
      params: SongsPaginationParams(
        page: currentPageForYou,
        limit: pageSize,
      ),
    );

    result.fold(
      (l) {
        isLoadingMoreForYou = false; // Reset loading state on error
        emit(state.copyWith(
            status: CreatePostInstagramStates.failure, failure: l));
      },
      (data) {
        forYouSongs.addAll(data);

        if (data.length < pageSize) {
          hasMoreDataForYou = false;
        } else {
          currentPageForYou++;
        }
        isLoadingMoreForYou = false;
        emit(state.copyWith(status: CreatePostInstagramStates.success));
      },
    );
  }

  // trending
  Future<void> loadInitialTrending() async {
    trendingSongs.clear();
    currentPageTrending = 1;
    hasMoreDataTrending = true;
    emit(state.copyWith(status: CreatePostInstagramStates.loading));
    await _fetchTrendingSongs();
  }

  Future<void> getTrendingSongs() async {
    if (!hasMoreDataTrending || isLoadingMoreTrending) return;
    isLoadingMoreTrending = true;
    emit(state.copyWith(status: CreatePostInstagramStates.loading));
    await _fetchTrendingSongs();
  }

  Future<void> _fetchTrendingSongs() async {
    final result = await getTrendingSongsUseCase(
      params: SongsPaginationParams(
        page: currentPageTrending,
        limit: pageSize,
      ),
    );

    result.fold(
      (l) {
        isLoadingMoreTrending = false; // Reset loading state on error
        emit(state.copyWith(
            status: CreatePostInstagramStates.failure, failure: l));
      },
      (data) {
        trendingSongs.addAll(data);

        if (data.length < pageSize) {
          hasMoreDataTrending = false;
        } else {
          currentPageTrending++;
        }
        isLoadingMoreTrending = false;
        emit(state.copyWith(status: CreatePostInstagramStates.success));
      },
    );
  }

  // saved
  Future<void> loadInitialSaved() async {
    favoriteSongs.clear();
    currentPageFavorite = 1;
    hasMoreDataFavorite = true;
    emit(state.copyWith(status: CreatePostInstagramStates.loading));
    await _fetchFavoriteSongs();
  }

  Future<void> getFavoriteSongs() async {
    if (!hasMoreDataFavorite || isLoadingMoreFavorite) return;
    isLoadingMoreFavorite = true;
    emit(state.copyWith(status: CreatePostInstagramStates.loading));
    await _fetchFavoriteSongs();
  }

  Future<void> _fetchFavoriteSongs() async {
    final result = await getSavedSongsUseCase(
      params: SongsPaginationParams(
        page: currentPageFavorite,
        limit: pageSize,
      ),
    );

    result.fold(
      (l) {
        isLoadingMoreFavorite = false; // Reset loading state on error
        emit(state.copyWith(
            status: CreatePostInstagramStates.failure, failure: l));
      },
      (data) {
        favoriteSongs.addAll(data);

        if (data.length < pageSize) {
          hasMoreDataFavorite = false;
        } else {
          currentPageFavorite++;
        }
        isLoadingMoreFavorite = false;
        emit(state.copyWith(status: CreatePostInstagramStates.success));
      },
    );
  }

  // Future<File?>? selectedImage;
  List<CteatePostTypeInstagram> postTypes = CteatePostTypeInstagram.postTypes;

  // void nextPage(BuildContext context) {
  //   log('nextPage ------------------------------------------------------------');
  //   if (state.postTypeSelectedIndex == 0) {
  //     context.push(
  //       Routes.CREATEPOSTSECONDPAGEINSTAGRAM,
  //       extra: state.selectedGalleryPost,
  //     );
  //   } else if (state.postTypeSelectedIndex == 2) {
  //     context.push(
  //       Routes.CREATEPOSTSECONDPAGEINSTAGRAM,
  //       extra: state.selectedGalleryReels,
  //     );
  //   }
  // }

  void changeCoverImage() {
    emit(state.copyWith(isImageCover: !state.isImageCover));
  }

  void onTapGalleryReel({
    required AssetEntity itemOfGallery,
  }) {
    List<AssetEntity> selectedGalleryReels =
        List.from(state.selectedGalleryReels);
    if (state.multiSelectGalleryReel) {
      if (state.selectedGalleryReels.contains(itemOfGallery)) {
        selectedGalleryReels.remove(itemOfGallery);
        emit(state.copyWith(
          selectedGalleryReels: selectedGalleryReels,
          // isVideoInitialized: false,
        ));
      } else {
        selectedGalleryReels.add(itemOfGallery);
        emit(state.copyWith(
          selectedGalleryReels: selectedGalleryReels,
          // isVideoInitialized: false,
        ));
      }
    } else {
      selectedGalleryReels = [itemOfGallery];
      emit(state.copyWith(
        selectedGalleryReels: selectedGalleryReels,
        // isVideoInitialized: false,
      ));
    }

    // // تحرير الموارد من المشغل السابق إن وجد
    // await controller?.dispose();

    // // الحصول على ملف الفيديو
    // final file = await video.file;
    // if (file == null) return;

    // // إنشاء مشغل فيديو جديد
    // controller = VideoPlayerController.file(file)
    //   ..initialize().then((_) {
    //     if (context.mounted) {
    //       emit(state.copyWith(
    //         isVideoInitialized: true,
    //       ));
    //       controller?.play();
    //     }
    //   });
  }

  Future<void> fetchVideos(BuildContext context) async {
    emit(state.copyWith(loadingReelsScreen: true));

    // طلب الصلاحيات
    final PermissionState permission =
        await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) {
      if (context.mounted) {
        emit(
          state.copyWith(
            isPermissionGranted: false,
          ),
        );
      }
      return;
    }

    // الحصول على جميع الفيديوهات من الجهاز
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.all,
      onlyAll: true,
    );

    if (albums.isNotEmpty) {
      final recentAlbum = albums.first;
      final List<AssetEntity> videoList = await recentAlbum.getAssetListRange(
        start: 0,
        end: 100, // يمكنك تعديل هذا الرقم حسب الحاجة
      );

      if (context.mounted) {
        emit(state.copyWith(
          status: CreatePostInstagramStates.initial,
          isPermissionGranted: true,
          galleryReels: videoList,
          loadingReelsScreen: false,
        ));
        // setState(() {
        //   _videos = videoList;
        //   _isLoading = false;
        // });
      }
    } else {
      if (context.mounted) {
        emit(state.copyWith(
          status: CreatePostInstagramStates.initial,
          isPermissionGranted: true,
          loadingReelsScreen: false,
        ));
        // setState(() {
        //   _isLoading = false;
        // });
      }
    }
  }

  Future<int> _getAssetFileSize(AssetEntity entity) async {
    File? file = await entity.file;
    return await file!.length();
    return 0;
  }

  // إضافة هذه الطرق إلى CreatePostInstagramCubit

  // void addUserTag(UserTagEntity user, {Offset? position, int? imageIndex}) {
  //   final updatedTags = List<UserTagEntity>.from(state.usersTag);
  //
  //   // التحقق من عدم وجود المستخدم مسبقاً
  //   final alreadyExists = updatedTags.any((u) => u.id == user.id);
  //
  //   if (!alreadyExists) {
  //     final userWithPositionAndIndex = user.copyWith(
  //       position: position != null
  //           ? TagPosition(x: position.dx, y: position.dy)
  //           : null,
  //       imageIndex: imageIndex,
  //     );
  //
  //     updatedTags.add(userWithPositionAndIndex);
  //     emit(state.copyWith(usersTag: updatedTags));
  //   }
  // }

  void removeUserTag(UserTagEntity user) {
    final updatedTags = List<UserTagEntity>.from(state.usersTag)
      ..removeWhere((u) => u.id == user.id);
    emit(state.copyWith(usersTag: updatedTags));
  }

  void removeAllUserTag() {
    final updatedTags = List<UserTagEntity>.from(state.usersTag)..clear();
    emit(state.copyWith(usersTag: updatedTags));
  }

  // تحديث دالة createPost لتشمل معلومات التاج
  // أضف هذه الطريقة إلى CreatePostInstagramCubit

  void addUserTag(UserTagEntity user, {Offset? position, int? imageIndex}) {
    final updatedTags = List<UserTagEntity>.from(state.usersTag);

    // التحقق من عدم وجود المستخدم مسبقاً
    final alreadyExists = updatedTags.any((u) => u.id == user.id);

    if (!alreadyExists) {
      print(
          'Adding user tag with position: $position, imageIndex: $imageIndex');

      final userWithPositionAndIndex = user.copyWith(
        position: position != null
            ? TagPosition(x: position.dx, y: position.dy)
            : null,
        imageIndex: imageIndex,
      );

      updatedTags.add(userWithPositionAndIndex);
      print('Total tags after adding: ${updatedTags.length}');

      emit(state.copyWith(usersTag: updatedTags));
    } else {
      print('User already exists in tags');
    }
  }

// تحديث دالة createPost
  Future<void> createPost({required String caption}) async {
    List<AssetEntity> uploadMedia = [];
    if (state.selectedGalleryPost.isNotEmpty) {
      uploadMedia.addAll(state.selectedGalleryPost);
    } else if (state.selectedGalleryReels.isNotEmpty) {
      uploadMedia.addAll(state.selectedGalleryReels);
    }

    // تحضير بيانات التاجز
    List<Map<String, dynamic>> userTags = state.usersTag
        .where((user) => user.position != null && user.imageIndex != null)
        .map((user) => {
              'id': user.id,
              'imageId': (user.imageIndex! + 1).toString(),
              'position': {
                'x': user.position!.x,
                'y': user.position!.y,
              },
            })
        .toList();

    print('Sending userTags: $userTags');
    print('Total userTags count: ${userTags.length}');

    await createRequestPost(
      CreatePostRequestInstagramParams(
        content: caption,
        songId: state.song?.id,
        media: await Future.wait(
          uploadMedia.map((AssetEntity e) async {
            final num size = await _getAssetFileSize(e);
            return MediaCreatePostInstagramParams(
              itemId: (uploadMedia.indexOf(e) + 1).toString(),
              type: e.mimeType ?? '',
              size: size,
            );
          }).toList(),
        ),
        userTagIds: state.usersTag.map((user) => user.id).toList(),
        userTags: userTags, // إضافة التاجز مع المواقع
      ),
      await Future.wait(
        uploadMedia.map((AssetEntity e) async {
          final file = await e.file;
          return file?.path ?? '';
        }).toList(),
      ),
    );
  }

  Future<List<CreatePostRequestEntity>> createRequestPost(
      CreatePostRequestInstagramParams params, List<String> path) async {
    final result = await createPostInstagramUseCase.call(params);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CreatePostInstagramStates.failure,
            failure: failure,
          ),
        );
        return [];
      },
      (data) async {
        List<String> mediaIds = [];
        for (int i = 0; i < data.length; i++) {
          await uploadMedia(signedUrl: data[i].signedUrl, path: path[i]);
          mediaIds.add(data[i].mediaHolderId);
        }
        await postConfirmWebhook(mediaIds: mediaIds);
        return data;
      },
    );
    return [];
  }

  Future<void> uploadMedia({
    required String signedUrl,
    required String path,
  }) async {
    final dio = Dio();
    final file = File(path);

    try {
      final response = await dio.put(
        signedUrl,
        data: file.openRead(), // stream the file
        options: Options(
          headers: {
            HttpHeaders.contentLengthHeader: await file.length(),
            // required
            HttpHeaders.contentTypeHeader: 'application/octet-stream',
            // or the actual MIME type
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Upload successful');
      } else {
        print('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Upload error: $e');
    }
  }

  Future<void> postConfirmWebhook({required List<String> mediaIds}) async {
    final result = await postConfirmWebhookUseCase.call(
      PostConfirmWebhookParams(
        mediaIds: mediaIds,
      ),
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CreatePostInstagramStates.failure,
            failure: failure,
          ),
        );
        return [];
      },
      (data) {
        return data;
      },
    );
  }

  // Future<void> _uploadMedia() async {
  //   final result = await UploadFile().uploadImage(
  //     subCategoryId: "66b6167938e6690c102ffa9c",
  //     onUploaded: (media) {
  //       emit(state.copyWith(
  //           uploadedImage: File(media.file.path),
  //           uploadStatus: StateStatus.success,
  //           imageMediaId: media.mediaId));
  //     },
  //     context: context,
  //   );
  //   if (result != null) {
  //   } else {
  //     emit(state.copyWith(uploadStatus: StateStatus.error));
  //   }
  // }

  void addLocation(LocationInstagramEntity location) {
    emit(state.copyWith(
      location: location,
      clearLocation: false,
    ));
  }

  void removeLocation() {
    state.location = null;
    emit(state.copyWith(
      clearLocation: true,
      status: CreatePostInstagramStates.success,
    ));
  }

  // void addUserTag(UserTagEntity user) {
  //   final updatedTags = List<UserTagEntity>.from(state.usersTag);
  //
  //   final alreadyExists = updatedTags.any((u) => u.id == user.id);
  //
  //   if (!alreadyExists) {
  //     updatedTags.add(user);
  //     emit(state.copyWith(usersTag: updatedTags));
  //   }
  // }
  //
  // void removeUserTag(UserTagEntity user) {
  //   final updatedTags = List<UserTagEntity>.from(state.usersTag)
  //     ..removeWhere((u) => u.id == user.id);
  //   emit(state.copyWith(usersTag: updatedTags));
  // }
  //
  // void removeAllUserTag() {
  //   final updatedTags = List<UserTagEntity>.from(state.usersTag)..clear();
  //   emit(state.copyWith(usersTag: updatedTags));
  // }

  Future<void> pickImage() async {
    var pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      final File futureFile = await Future.value(File(pickedImage.path));
      // final List<AssetEntity> selectedImages =
      //     List<AssetEntity>.from(state.selectedGalleryPost);
      // final AssetEntity assetEntity = await AssetEntity.fromFile(futureFile);
      final AssetEntity assetEntity =
          await PhotoManager.editor.saveImageWithPath(
        futureFile.path,
        title: 'Image_${DateTime.now().millisecondsSinceEpoch}',
      );
      final List<AssetEntity> selectedImages =
          List<AssetEntity>.from(state.selectedGalleryPost)..add(assetEntity);
      // final List<File> selectedImages = state.selectedGalleryPost;
      // selectedImages.add(futureFile);
      emit(state.copyWith(selectedGalleryPost: selectedImages));
      // selectedImage =
      //     futureFile; // تعيين الصورة في selectedImage
    }
  }

  void changeMultiSelectGalleryPost() {
    emit(state.copyWith(multiSelectGalleryPost: !state.multiSelectGalleryPost));
  }

  void changeMultiSelectGalleryReel() {
    emit(state.copyWith(multiSelectGalleryReel: !state.multiSelectGalleryReel));
  }

  void onTapGalleryPost({
    required AssetEntity itemOfGallery,
  }) {
    List<AssetEntity> selectedGalleryPosts =
        List.from(state.selectedGalleryPost);

    if (state.multiSelectGalleryPost) {
      if (state.selectedGalleryPost.contains(itemOfGallery)) {
        selectedGalleryPosts.remove(itemOfGallery);
        emit(state.copyWith(selectedGalleryPost: selectedGalleryPosts));
      } else {
        selectedGalleryPosts.add(itemOfGallery);
        emit(state.copyWith(selectedGalleryPost: selectedGalleryPosts));
      }
      // // تعديل selectedMeda
      // List<AssetEntity> newSelectedGalleryPost =
      //     List<AssetEntity>.from(state.selectedGalleryPost);
      // if (newSelectedGalleryPost.contains(state.selectedGalleryPost[index])) {
      //   newSelectedGalleryPost.remove(state.selectedGalleryPost[index]);
      // } else {
      //   newSelectedGalleryPost.add(state.selectedGalleryPost[index]);
      // }
      // // // تعديل selectedImages
      // // List<AssetEntity> newSelectedImages = state.selectedGalleryPost;
      // // // List<Future<File?>>.from(state.selectedImages);
      // // if (newSelectedImages.contains(state.selectedGalleryPost[index])) {
      // //   newSelectedImages.remove(state.images[index]);
      // // } else {
      // //   newSelectedImages.add(state.images[index]);
      // // }
      // emit(state.copyWith(
      //   selectedGalleryPost: newSelectedGalleryPost,
      //   // selectedMeda: newSelectedMeda,
      // ));
    } else {
      selectedGalleryPosts = [itemOfGallery];
      emit(state.copyWith(selectedGalleryPost: selectedGalleryPosts));
      // // تعديل selectedImages فقط في حالة عدم تفعيل الاختيار المتعدد
      // List<AssetEntity> newSelectedImages = [state.galleryPost[index]];
      // // List<Future<File?>>.from(state.selectedImages)
      // //   ..add(state.images[index].file);
      // // if (newSelectedImages.contains(state.images[index].file)) {
      // //   newSelectedImages.remove(state.images[index].file);
      // // } else {
      // //   newSelectedImages.add(state.images[index].file);
      // // }
      // emit(
      //   state.copyWith(
      //     selectedGalleryPost: newSelectedImages,
      //   ),
      // );
    }
    //   if (state.multiSelect) {
    //     // تعديل selectedMeda
    //     List<File> newSelectedMeda = List<File>.from(state.selectedMeda);
    //     if (newSelectedMeda.contains(state.images[index])) {
    //       newSelectedMeda.remove(state.images[index]);
    //     } else {
    //       newSelectedMeda.add(state.images[index]);
    //     }
    //     // تعديل selectedImages
    //     List<File> newSelectedImages = state.selectedImages;
    //     // List<Future<File?>>.from(state.selectedImages);
    //     if (newSelectedImages.contains(state.images[index])) {
    //       newSelectedImages.remove(state.images[index]);
    //     } else {
    //       newSelectedImages.add(state.images[index]);
    //     }
    //     emit(state.copyWith(
    //       selectedImages: newSelectedImages,
    //       selectedMeda: newSelectedMeda,
    //     ));
    //   } else {
    //     // تعديل selectedImages فقط في حالة عدم تفعيل الاختيار المتعدد
    //     List<File> newSelectedImages = [state.images[index]];
    //     // List<Future<File?>>.from(state.selectedImages)
    //     //   ..add(state.images[index].file);
    //     // if (newSelectedImages.contains(state.images[index].file)) {
    //     //   newSelectedImages.remove(state.images[index].file);
    //     // } else {
    //     //   newSelectedImages.add(state.images[index].file);
    //     // }
    //     emit(
    //       state.copyWith(
    //         selectedImages: newSelectedImages,
    //       ),
    //     );
    //   }
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

  // final List<Widget> _mediaList = [];
  // final List<File> path = [];
  // File? _file;
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
      List<AssetEntity> assetsEntity =
          await _fetchImagesPage(state.currentPage, 60);

      emit(
        state.copyWith(
          status: CreatePostInstagramStates.initial,
          isPermissionGranted: true,
          currentPage: 0,
          hasMoreImages: assetsEntity.length == 60,
          galleryPost: assetsEntity,
        ),
      );
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

  // Future<List<AssetEntity>> _fetchAllImages(int page, int pageSize) async {
  //   final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
  //     onlyAll: true,
  //     // type: RequestType.fromTypes([RequestType.image, RequestType.video]), // جلب الصور فقط
  //     type: RequestType.image,
  //   );
  //   if (albums.isNotEmpty) {
  //     final AssetPathEntity album = albums.first;
  //     // جلب الصور في الصفحة المحددة فقط
  //     return await album.getAssetListPaged(page: page, size: pageSize);
  //   }
  //   return [];
  //
  //   // if (albums.isNotEmpty) {
  //   //   final AssetPathEntity album = albums.first; // اختر الألبوم الأول
  //   //   List<AssetEntity> allImages = [];
  //   //   int page = 0; // ابدأ من الصفحة الأولى
  //   //   const int pageSize = 20;
  //   //   while (true) {
  //   //     // جلب الصور في الصفحة الحالية
  //   //     final List<AssetEntity> images =
  //   //         await album.getAssetListPaged(page: page, size: pageSize);
  //   //     if (images.isEmpty) {
  //   //       break; // إذا لم تكن هناك صور إضافية، أخرج من الحلقة
  //   //     }
  //   //     allImages.addAll(images); // أضف الصور إلى القائمة النهائية
  //   //     page++; // انتقل إلى الصفحة التالية
  //   //   }
  //   //   return allImages;
  //   // }
  //   // return [];
  // }

// تحميل صفحة محددة من الصور
  Future<List<AssetEntity>> _fetchImagesPage(int page, int pageSize) async {
    List<AssetEntity> assets = [];
    List<AssetPathEntity> album = await PhotoManager.getAssetPathList(
      onlyAll: true,
    );
    List<AssetEntity> media = await album[0].getAssetListPaged(
      page: page,
      size: pageSize,
    );
    assets = media;
    // for (var asset in media) {
    //   final file = await asset.file;
    //   if (file != null) {
    //     assets.add(asset);
    //     // _file = path[0];
    //   }
    // if (asset.type == AssetType.image) {
    //
    // }
    // }
    return assets;
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
    final newGalleryPost = await _fetchImagesPage(nextPage, 60);

    if (newGalleryPost.isNotEmpty) {
      emit(state.copyWith(
        galleryPost: [...state.galleryPost, ...newGalleryPost],
        currentPage: nextPage,
        hasMoreImages: newGalleryPost.length == 60,
      ));
    } else {
      emit(state.copyWith(hasMoreImages: false));
    }
  }
}

class CteatePostTypeInstagram {
  final PostType postType;
  final String title;
  final int index;

  const CteatePostTypeInstagram({
    required this.postType,
    required this.title,
    required this.index,
  });

  static List<CteatePostTypeInstagram> postTypes = [
    CteatePostTypeInstagram(
      postType: PostType.post,
      title: LocaleKeys.post2.localize,
      index: 0,
    ),
    CteatePostTypeInstagram(
      postType: PostType.story,
      title: LocaleKeys.story.localize,
      index: 1,
    ),
    CteatePostTypeInstagram(
      postType: PostType.reel,
      title: LocaleKeys.reel.localize,
      index: 2,
    ),
  ];
}

enum PostType {
  post,
  story,
  reel,
}
