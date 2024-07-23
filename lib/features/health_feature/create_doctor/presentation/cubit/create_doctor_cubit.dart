import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/data/models/doctor_location.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/data/models/work_day_model.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/work_day_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/create_doctor.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/address_search_params_model.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:image_picker/image_picker.dart';

part 'create_doctor_state.dart';

class CreateDoctorCubit extends Cubit<CreateDoctorState> {
  CreateDoctorCubit() : super(CreateDoctorInitial());

  void load() {}

  CreateDoctorParams _createDoctorParams = CreateDoctorParams(
    firstName: '',
    lastName: '',
    subCategoryId: '',
    phone: '',
    email: '',
    mediaId: '',
    clinicPrice: '',
    waitingTime: '',
    callsPrice: '',
    description: '',
    idFrontKey: '',
    idBehindKey: '',
    idExpiryDate: '',
    practicingBehind: '',
    practicingFront: '',
    practicingExpiryDate: '',
    clinicWorkDays: [],
    callsWorkDays: [],
    homeVisitWorkDays: [],
    address: AddressSearchParamsModel(address: '', lat: 0, lng: 0),
  );

  // SubCategoryModel _subCategoryModel =
  //     SubCategoryModel(id: '', name: '', image: '', isFavourite: false);

  // List<DoctorWorkDayEntity> clinicWorkDays = [];
  // List<DoctorWorkDayEntity> callWorkDays = [];
  // List<DoctorWorkDayEntity> homeVisitWorkDays = [];

  // DoctorLocationModel _location =
  //     DoctorLocationModel(governorate: '', city: '', address: '');

  // dropdowns

  void selectSubcategory(SubCategoryEntity subCategoryModel) {
    _createDoctorParams.subCategoryId = subCategoryModel.id;
  }

  void selectGovernorate(String value) {
    // _location.governorate = value;
  }

  void selectCity(String value) {
    // _location.city = value;
  }

  // upload images
  Future<void> _uploadImage(
      {required dynamic Function(UploadFileEntity) onUploaded}) async {
    if (_createDoctorParams.subCategoryId.isNotEmpty) {
      emit(CreateDoctorLoading("Uploading Image..."));
      UploadFile().uploadImage(
        subCategoryId: _createDoctorParams.subCategoryId,
        onUploaded: (value) {
          onUploaded(value);
        },
      );
      emit(CreateDoctorCloseLoading());
    } else {
      emit(CreateDoctorError("Select Subcategory First"));
    }
  }

  Future<void> uploadProfileImage() async {
    await _uploadImage(onUploaded: (media) {
      _createDoctorParams.mediaId = media.mediaId;
      emit(CreateDoctorUploadProfileImage(media.file));
    });
  }

  Future<void> uploadIdFrontImage() async {
    await _uploadImage(onUploaded: (media) {
      _createDoctorParams.idFrontKey = media.mediaId;
      emit(CreateDoctorUploadIdFrontImage(media.file));
    });
  }

  Future<void> uploadIdBehindImage() async {
    await _uploadImage(onUploaded: (media) {
      _createDoctorParams.idBehindKey = media.mediaId;
      emit(CreateDoctorUploadIdBehindImage(media.file));
    });
  }

  Future<void> uploadPracticingFrontImage() async {
    await _uploadImage(onUploaded: (media) {
      _createDoctorParams.practicingFront = media.mediaId;
      emit(CreateDoctorUploadPracticingFrontImage(media.file));
    });
  }

  Future<void> uploadPracticingBehindImage() async {
    await _uploadImage(onUploaded: (media) {
      _createDoctorParams.practicingBehind = media.mediaId;
      emit(CreateDoctorUploadPracticingBehindImage(media.file));
    });
  }

  // text controllers
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final specialtyFocusNode = FocusNode();
  final callPriceFocusNode = FocusNode();
  final homeVisitPriceFocusNode = FocusNode();
  final clinicPriceFocusNode = FocusNode();
  final locationFocusNode = FocusNode();
  final waitingTimeFocusNode = FocusNode();
  final clinicExamineDurationFocusNode = FocusNode();
  final callExamineDurationFocusNode = FocusNode();
  final homeVisitExamineDurationFocusNode = FocusNode();
  final homeVisitDurationFocusNode = FocusNode();
  final addressFocusNode = FocusNode();

  final homeVisitExamineDurationController = TextEditingController();
  final addressController = TextEditingController();
  final callExamineDurationController = TextEditingController();
  final waitingTimeController = TextEditingController();
  final clinicExamineDurationController = TextEditingController();
  final locationController = TextEditingController();
  final firstNameController = TextEditingController();
  final specialtyController = TextEditingController();
  final lastNameController = TextEditingController();
  final callPriceController = TextEditingController();
  final homeVisitPriceController = TextEditingController();
  final clinicPriceController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  // services toggles
  void toggleClinic(bool value) {
    emit(CreateDoctorShowClinic(value));
  }

  void toggleCallCheck(bool value) {
    emit(CreateDoctorShowCall(value));
  }

  void toggleHomeVisit(bool value) {
    emit(CreateDoctorShowHomeVisit(value));
  }

// Work days setters
  void addClinicWorkDay(DoctorWorkDayEntity value) {
    _createDoctorParams.clinicWorkDays
        .add(DoctorWorkDayModel.fromEntity(value));
  }

  void addCallWorkDay(DoctorWorkDayEntity value) {
    _createDoctorParams.callsWorkDays.add(DoctorWorkDayModel.fromEntity(value));
  }

  void addHomeVisitWorkDay(DoctorWorkDayEntity value) {
    _createDoctorParams.homeVisitWorkDays
        .add(DoctorWorkDayModel.fromEntity(value));
  }

  void deleteClinicWorkDay(DoctorWorkDayEntity value) {
    _createDoctorParams.clinicWorkDays
        .removeWhere((element) => element.day == value.day);
  }

  void deleteCallWorkDay(DoctorWorkDayEntity value) {
    _createDoctorParams.callsWorkDays
        .removeWhere((element) => element.day == value.day);
  }

  void deleteHomeVisitWorkDay(DoctorWorkDayEntity value) {
    _createDoctorParams.homeVisitWorkDays
        .removeWhere((element) => element.day == value.day);
  }
}
