import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/data/models/doctor_location.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/data/models/work_day_model.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/work_day_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/create_doctor.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/address_search_params_model.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';
import 'package:image_picker/image_picker.dart';

part 'create_doctor_state.dart';

class CreateDoctorCubit extends Cubit<CreateDoctorState> {
  CreateDoctorCubit() : super(CreateDoctorInitial());

  void load() {}

  void selectSubCategory(SubCategoryModel subCategoryModel) {
    _createDoctorParams.subCategoryId = subCategoryModel.id;
  }

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

  void selectGovernorate(String value) {
    // _location.governorate = value;
  }

  void selectSubGategory(String value) {
    // _subCategoryModel = value;
  }

  void selectCity(String value) {
    // _location.city = value;
  }

  // upload images
  Future<UploadFileEntity?> _uploadImage() async {
    UploadFileEntity? media;
    if (_createDoctorParams.subCategoryId.isNotEmpty) {
      await UploadFile().uploadImage(
        subCategoryId: _createDoctorParams.subCategoryId,
        onUploaded: (value) {
          media = value;
        },
      );
    } else {
      emit(CreateDoctorError("Select Subcategory First"));
    }

    return media;
  }

  Future<XFile?> uploadProfileImage() async {
    final media = await _uploadImage();

    if (media != null) {
      _createDoctorParams.mediaId = media.mediaId;
    }
    return media?.file;
  }

  Future<XFile?> uploadIdFrontImage() async {
    final media = await _uploadImage();
    if (media != null) {
      _createDoctorParams.idFrontKey = media.mediaId;
    }
    return media?.file;
  }

  Future<XFile?> uploadIdBehindImage() async {
    final media = await _uploadImage();
    if (media != null) {
      _createDoctorParams.idBehindKey = media.mediaId;
    }
    return media?.file;
  }

  Future<XFile?> uploadPracticingFrontImage() async {
    final media = await _uploadImage();
    if (media != null) {
      _createDoctorParams.practicingFront = media.mediaId;
    }
    return media?.file;
  }

  Future<XFile?> uploadPracticingBehindImage() async {
    final media = await _uploadImage();
    if (media != null) {
      _createDoctorParams.practicingBehind = media.mediaId;
    }
    return media?.file;
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
