import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/week_days.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/data/models/doctor_day_model.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/doctor_day_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/create_doctor.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/get_cities.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/get_governorates.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_health_subcategories.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:image_picker/image_picker.dart';

part 'create_doctor_state.dart';

class CreateDoctorCubit extends Cubit<CreateDoctorState> {
  final HealthSharedData _shareCubit;
  final GetHealthSubcategoriesUseCase _getHealthSubcategoriesUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final GetCitiesUseCase _getCitiesUseCase;
  final CreateDoctorUseCase _createDoctorUseCase;

  CreateDoctorCubit(
      this._shareCubit,
      this._getHealthSubcategoriesUseCase,
      this._getGovernoratesUseCase,
      this._getCitiesUseCase,
      this._createDoctorUseCase)
      : super(CreateDoctorInitial());

  Future<void> loadData() async {
    await _getSubCategories();
    await _getGovernorates();
  }

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      _saveTextEditingControllers();
      _saveWorkDays();
      String? checkFilledMessage = _createDoctorParams.isFilled();
      if (checkFilledMessage == null) {
        emit(CreateDoctorLoading("Creating Account..."));
        final response = await _createDoctorUseCase.call(_createDoctorParams);
        emit(CreateDoctorCloseLoading());
        response
            .fold((failure) => emit(CreateDoctorError("Can't Create Doctor")),
                (data) {
          emit(CreateDoctorSuccess(
              "You are submit successfully. Please wait admin approve and approval."));
        });
      } else {
        emit(CreateDoctorError(checkFilledMessage));
      }
    }
  }

  Future<void> _getSubCategories() async {
    final userId = UserCubit.to.state.data?.id;

    if (_shareCubit.subCategories.isEmpty) {
      final response = await _getHealthSubcategoriesUseCase.call(userId ?? '');
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

  Future<void> _getCities(String governorateId) async {
    emit(CreateDoctorCitiesLoading());
    final response = await _getCitiesUseCase.call(governorateId);

    response.fold(
      (failure) => emit(CreateDoctorError("Can't Load Cities")),
      (data) => emit(CreateDoctorCitiesLoaded(data)),
    );
  }

  final CreateDoctorParams _createDoctorParams = CreateDoctorParams();

  // =============================== Timetables ===============================
  List<DoctorDayEntity> clinicTimetable = [
    DoctorDayEntity(day: WeekDays.saturday),
    DoctorDayEntity(day: WeekDays.sunday),
    DoctorDayEntity(day: WeekDays.monday),
    DoctorDayEntity(day: WeekDays.tuesday),
    DoctorDayEntity(day: WeekDays.wednesday),
    DoctorDayEntity(day: WeekDays.thursday),
    DoctorDayEntity(day: WeekDays.friday),
  ];

  List<DoctorDayEntity> callTimetable = [
    DoctorDayEntity(day: WeekDays.saturday),
    DoctorDayEntity(day: WeekDays.sunday),
    DoctorDayEntity(day: WeekDays.monday),
    DoctorDayEntity(day: WeekDays.tuesday),
    DoctorDayEntity(day: WeekDays.wednesday),
    DoctorDayEntity(day: WeekDays.thursday),
    DoctorDayEntity(day: WeekDays.friday),
  ];

  List<DoctorDayEntity> homeVisitTimetable = [
    DoctorDayEntity(day: WeekDays.saturday),
    DoctorDayEntity(day: WeekDays.sunday),
    DoctorDayEntity(day: WeekDays.monday),
    DoctorDayEntity(day: WeekDays.tuesday),
    DoctorDayEntity(day: WeekDays.wednesday),
    DoctorDayEntity(day: WeekDays.thursday),
    DoctorDayEntity(day: WeekDays.friday),
  ];

  void _saveWorkDays() {
    _createDoctorParams.clinic?.workDays.clear();
    _createDoctorParams.calls?.workDays.clear();
    _createDoctorParams.visitHome?.workDays.clear();
    for (var element in clinicTimetable) {
      if (element.isAvailable == true) {
        _createDoctorParams.clinic?.workDays
            .add(DoctorDayModel.fromEntity(element));
      }
    }

    for (var element in callTimetable) {
      if (element.isAvailable) {
        _createDoctorParams.calls?.workDays
            .add(DoctorDayModel.fromEntity(element));
      }
    }

    for (var element in homeVisitTimetable) {
      if (element.isAvailable) {
        _createDoctorParams.visitHome?.workDays
            .add(DoctorDayModel.fromEntity(element));
      }
    }
    _createDoctorParams.clinic?.workDays.toSet().toList();
    _createDoctorParams.calls?.workDays.toSet().toList();
    _createDoctorParams.visitHome?.workDays.toSet().toList();
  }

  // ================================ DatePickers ===============================
  void pickIDExpiryDate(DateTime value) {
    _createDoctorParams.idExpiryDate = value.toIso8601String();
  }

  void pickPracticingExpiryDate(DateTime value) {
    _createDoctorParams.practicingExpiryDate = value.toIso8601String();
  }

  // ================================ dropdowns ===============================
  Future<void> selectGovernorate(GovernorateEntity value) async {
    _createDoctorParams.address.governorateId = value.id;
    await _getCities(value.id);
  }

  void selectCity(CityEntity value) {
    _createDoctorParams.address.cityId = value.id;
  }

  void selectSubcategory(SubCategoryEntity subCategoryModel) {
    _createDoctorParams.subCategoryId = subCategoryModel.id;
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
    _createDoctorParams.hasClinic = value;
    emit(CreateDoctorShowClinic(value));
  }

  void toggleCallCheck(bool value) {
    _createDoctorParams.hasCalls = value;
    emit(CreateDoctorShowCall(value));
  }

  void toggleHomeVisit(bool value) {
    _createDoctorParams.hasHomeVisit = value;
    emit(CreateDoctorShowHomeVisit(value));
  }

  // ================================= TextEditingControllers =================================

  void _saveTextEditingControllers() {
    _createDoctorParams.firstName = firstNameController.text;
    _createDoctorParams.lastName = lastNameController.text;
    _createDoctorParams.phone = phoneController.text;
    _createDoctorParams.address.address = addressController.text;
    _createDoctorParams.detectionPeriodClinic =
        clinicExamineDurationController.text;
    _createDoctorParams.detectionPeriodCalls =
        callExamineDurationController.text;
    _createDoctorParams.detectionPeriodvisitHome = '84864';
    _createDoctorParams.callsPrice = callPriceController.text;
    _createDoctorParams.visitHomePrice = homeVisitPriceController.text;
    _createDoctorParams.clinicPrice = clinicPriceController.text;
    _createDoctorParams.waitingTime = waitingTimeController.text;
    _createDoctorParams.description = descriptionController.text;
  }

  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final callPriceFocusNode = FocusNode();
  final homeVisitPriceFocusNode = FocusNode();
  final clinicPriceFocusNode = FocusNode();
  final waitingTimeFocusNode = FocusNode();
  final clinicExamineDurationFocusNode = FocusNode();
  final callExamineDurationFocusNode = FocusNode();
  final homeVisitExamineDurationFocusNode = FocusNode();
  final homeVisitDurationFocusNode = FocusNode();
  final addressFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();

  final homeVisitExamineDurationController = TextEditingController();
  final addressController = TextEditingController();
  final callExamineDurationController = TextEditingController();
  final waitingTimeController = TextEditingController();
  final clinicExamineDurationController = TextEditingController();
  final firstNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final lastNameController = TextEditingController();
  final callPriceController = TextEditingController();
  final homeVisitPriceController = TextEditingController();
  final clinicPriceController = TextEditingController();
  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Future<void> close() {
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    descriptionFocusNode.dispose();
    callPriceFocusNode.dispose();
    homeVisitPriceFocusNode.dispose();
    clinicPriceFocusNode.dispose();
    waitingTimeFocusNode.dispose();
    clinicExamineDurationFocusNode.dispose();
    callExamineDurationFocusNode.dispose();
    homeVisitExamineDurationFocusNode.dispose();
    homeVisitDurationFocusNode.dispose();
    addressFocusNode.dispose();
    phoneFocusNode.dispose();
    homeVisitExamineDurationController.dispose();
    addressController.dispose();
    callExamineDurationController.dispose();
    waitingTimeController.dispose();
    clinicExamineDurationController.dispose();
    firstNameController.dispose();
    descriptionController.dispose();
    lastNameController.dispose();
    callPriceController.dispose();
    homeVisitPriceController.dispose();
    clinicPriceController.dispose();
    phoneController.dispose();
    return super.close();
  }
}
