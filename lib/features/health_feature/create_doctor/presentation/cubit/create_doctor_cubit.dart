import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/work_day_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/create_doctor.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/get_cities.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/get_governorates.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/usecases/request/get_ride_sub_categories_use_case.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:image_picker/image_picker.dart';

part 'create_doctor_state.dart';

class CreateDoctorCubit extends Cubit<CreateDoctorState> {
  final HealthSharedData _shareCubit;
  final GetSubCategoriesUseCase _getSubCategoriesUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final GetCitiesUseCase _getCitiesUseCase;
  CreateDoctorCubit(this._shareCubit, this._getSubCategoriesUseCase,
      this._getGovernoratesUseCase, this._getCitiesUseCase)
      : super(CreateDoctorInitial());

  Future<void> loadData() async {
    await _getSubCategories();
    await _getGovernorates();
  }

  Future<void> _getSubCategories() async {
    if (_shareCubit.subCategories.isEmpty) {
      final response =
          await _getSubCategoriesUseCase.call('62c8b57c9332225799fe3306');
      response
          .fold((failure) => emit(CreateDoctorError("Can't Load Specialities")),
              (data) {
        _shareCubit.subCategories = data;
        emit(CreateDoctorSubCategoriesLoaded(data));
      });
    } else {
      emit(CreateDoctorSubCategoriesLoaded(_shareCubit.subCategories));
    }
  }

  Future<void> _getGovernorates() async {
    if (_shareCubit.governorates.isEmpty) {
      final response = await _getGovernoratesUseCase.call(const NoParams());
      response
          .fold((failure) => emit(CreateDoctorError("Can't Load Governorates")),
              (data) {
        _shareCubit.governorates = data;
        emit(CreateDoctorGovernoratesLoaded(data));
      });
    } else {
      emit(CreateDoctorGovernoratesLoaded(_shareCubit.governorates));
    }
  }

  Future<void> getCities(String governorateId) async {
    emit(CreateDoctorCitiesLoading());
    final response = await _getCitiesUseCase.call(governorateId);

    response.fold(
      (failure) => emit(CreateDoctorError("Can't Load Cities")),
      (data) => emit(CreateDoctorCitiesLoaded(data)),
    );
  }

  late CreateDoctorParams _createDoctorParams;

  // SubCategoryModel _subCategoryModel =
  //     SubCategoryModel(id: '', name: '', image: '', isFavourite: false);

  // List<DoctorWorkDayEntity> clinicWorkDays = [];
  // List<DoctorWorkDayEntity> callWorkDays = [];
  // List<DoctorWorkDayEntity> homeVisitWorkDays = [];

  // DoctorLocationModel _location =
  //     DoctorLocationModel(governorate: '', city: '', address: '');

  // dropdowns

  void selectSubcategory(SubCategoryEntity subCategoryModel) {
    // _createDoctorParams.subCategoryId = subCategoryModel.id;
  }

  // ================================ location ===============================
  Future<void> selectGovernorate(GovernorateEntity value) async {
    // _createDoctorParams.governorateId = value.id;
    // _createDoctorParams.cityId = '';
    await getCities(value.id);
    // _location.governorate = value;
  }

  void selectCity(CityEntity value) {
    // _location.city = value;
  }

  // ================================= upload images =================================
  Future<void> _uploadImage(
      {required dynamic Function(UploadFileEntity) onUploaded}) async {
    if (_createDoctorParams.subCategoryId.isNotEmpty) {
      emit(CreateDoctorLoading("Uploading Image..."));
      await UploadFile().uploadImage(
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

  // ================================= toggles =================================

  void toggleClinic(bool value) {
    emit(CreateDoctorShowClinic(value));
  }

  void toggleCallCheck(bool value) {
    emit(CreateDoctorShowCall(value));
  }

  void toggleHomeVisit(bool value) {
    emit(CreateDoctorShowHomeVisit(value));
  }

  // ================================= work days =================================
  void addClinicWorkDay(DoctorDayEntity value) {
    // _createDoctorParams.clinicWorkDays
    //     .add(DoctorWorkDayModel.fromEntity(value));
  }

  void addCallWorkDay(DoctorDayEntity value) {
    // _createDoctorParams.callsWorkDays.add(DoctorWorkDayModel.fromEntity(value));
  }

  void addHomeVisitWorkDay(DoctorDayEntity value) {
    // _createDoctorParams.homeVisitWorkDays
    //     .add(DoctorWorkDayModel.fromEntity(value));
  }

  void deleteClinicWorkDay(DoctorDayEntity value) {
    // _createDoctorParams.clinicWorkDays
    //     .removeWhere((element) => element.day == value.day);
  }

  void deleteCallWorkDay(DoctorDayEntity value) {
    // _createDoctorParams.callsWorkDays
    //     .removeWhere((element) => element.day == value.day);
  }

  void deleteHomeVisitWorkDay(DoctorDayEntity value) {
    // _createDoctorParams.homeVisitWorkDays
    //     .removeWhere((element) => element.day == value.day);
  }

  // ================================= TextEditingControllers =================================
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
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
  final descriptionController = TextEditingController();
  final lastNameController = TextEditingController();
  final callPriceController = TextEditingController();
  final homeVisitPriceController = TextEditingController();
  final clinicPriceController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Future<void> close() {
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    descriptionFocusNode.dispose();
    callPriceFocusNode.dispose();
    homeVisitPriceFocusNode.dispose();
    clinicPriceFocusNode.dispose();
    locationFocusNode.dispose();
    waitingTimeFocusNode.dispose();
    clinicExamineDurationFocusNode.dispose();
    callExamineDurationFocusNode.dispose();
    homeVisitExamineDurationFocusNode.dispose();
    homeVisitDurationFocusNode.dispose();
    addressFocusNode.dispose();
    homeVisitExamineDurationController.dispose();
    addressController.dispose();
    callExamineDurationController.dispose();
    waitingTimeController.dispose();
    clinicExamineDurationController.dispose();
    locationController.dispose();
    firstNameController.dispose();
    descriptionController.dispose();
    lastNameController.dispose();
    callPriceController.dispose();
    homeVisitPriceController.dispose();
    clinicPriceController.dispose();
    return super.close();
  }
}
