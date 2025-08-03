import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/functions/global/upload_file.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/messages/messages.dart';
import '../../domain/usecases/send_bill_request_use_case.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/error/failure.dart';
part 'ten_percent_state.dart';

class TenPercentCubit extends Cubit<TenPercentState> {
  var formKey = GlobalKey<FormState>();
  TextEditingController trafficController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController electricityController = TextEditingController();
  final SentBillRequestUseCase _sentBillRequestUseCase;
  TenPercentCubit(this._sentBillRequestUseCase)
      : super(const TenPercentState());

  uploadMobileBill({bool isGallery = true,required BuildContext context}) async {
    final UploadFile upload = UploadFile();
    print("objectssssssssss");
    await upload.uploadImage(
        isGallery: isGallery,
        subCategoryId: '66a3583454e6e337915514db',
        onUploaded: (UploadFileEntity data) {
          print("file name ${data.file}");
          print("mediaId: ${data.mediaId}");

          emit(state.copyWith(
              mobileFile: data.file.path,
              mobileId: data.mediaId,
              // backColor: '#FFFFFFFF',
              status: TenPercentStates.success));
        }, context: context);
    print("length${state.mobileId}");
  }

  uploadElectricityBill({bool isGallery = true,required BuildContext context}) async {
    final UploadFile upload = UploadFile();
    print("objectssssssssss");
    await upload.uploadImage(
        isGallery: isGallery,
        subCategoryId: '66a3583454e6e337915514db',
        onUploaded: (UploadFileEntity data) {
          print("file name ${data.file}");
          print("mediaId: ${data.mediaId}");

          emit(state.copyWith(
              electricityFile: data.file.path,
              electricityId: data.mediaId,
              // backColor: '#FFFFFFFF',
              status: TenPercentStates.success));
        }, context: context);
    print("length${state.electricityId}");
  }

  uploadTrafficBill({bool isGallery = true,required BuildContext context}) async {
    final UploadFile upload = UploadFile();
    print("objectssssssssss");
    await upload.uploadImage(
        isGallery: isGallery,
        subCategoryId: '66a3583454e6e337915514db',
        onUploaded: (UploadFileEntity data) {
          print("file name ${data.file}");
          print("mediaId: ${data.mediaId}");

          emit(state.copyWith(
              trafficFile: data.file.path,
              trafficId: data.mediaId,
              // backColor: '#FFFFFFFF',
              status: TenPercentStates.success));
        }, context: context);
    print("length${state.trafficId}");
  }
  // Future<void> uploadProfileImage() async {
  //   await _uploadImage(onUploaded: (media) {
  //     emit(state.copyWith(file:media.file,mediaId: media.mediaId));
  //   });
  // }

  Future<void> fetchAdRequests(BuildContext context) async {
    emit(state.copyWith(status: TenPercentStates.loading));

    final response = await _sentBillRequestUseCase(
      SentBillRequestParams(
        electricityAmount: electricityController.text,
        electricityId: state.electricityId,
        mobileAmount: mobileController.text,
        mobileId: state.mobileId,
        trafficAmount: trafficController.text,
        trafficId: state.trafficId,
      ),
    );

    response.fold(
      (failure) {
        showErrorMessage(context, getFailureMessage(failure, context));

        emit(state.copyWith(failure: failure, status: TenPercentStates.error));
      },
      (data) {
        showSuccessMessage(context, LocaleKeys.requestSentSuccess.localize);
        trafficController.clear();
        mobileController.clear();
        electricityController.clear();
        emit(state.copyWith(
            status: TenPercentStates.success,
            electricityFile: '',
            mobileFile: '',
            trafficFile: '',
            electricityId: '',
            mobileId: '',
            trafficId: ''));
        context.pop();
      },
    );
  }
}
