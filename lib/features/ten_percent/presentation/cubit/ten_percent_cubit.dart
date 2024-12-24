import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/error/failure.dart';
part 'ten_percent_state.dart';

class TenPercentCubit extends Cubit<TenPercentState> {

  TextEditingController searchController = TextEditingController();

  TenPercentCubit() : super(const TenPercentState());
  Future<void> _uploadImage(
      {required dynamic Function(UploadFileEntity) onUploaded}) async {
      // emit(state.copyWith(status: TenPercentStates.loading));
      await UploadFile().uploadImage(
        subCategoryId: '',
        onUploaded: (value) {
          onUploaded(value);
        },
      );
      emit(state.copyWith(status: TenPercentStates.success));

  }

  uploadProfileImage({bool isGallery = true}) async {
    final UploadFile upload = UploadFile();
    print("objectssssssssss");
    await upload.uploadImage(
        isGallery: isGallery,
        subCategoryId: '66a3583454e6e337915514db',
        onUploaded: (UploadFileEntity data) {
          print("file name ${data.file}");
          print("mediaId: ${data.mediaId}");

          emit(state.copyWith(
              file: data.file,
              mediaId: data.mediaId,
              // backColor: '#FFFFFFFF',
              status: TenPercentStates.success));
        });
    print("length${state.mediaId}");
  }
  // Future<void> uploadProfileImage() async {
  //   await _uploadImage(onUploaded: (media) {
  //     emit(state.copyWith(file:media.file,mediaId: media.mediaId));
  //   });
  // }

}
