import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../common/functions/global/upload_file.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/enums/week_days.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../health_feature/create_doctor/data/models/doctor_day_model.dart';

import 'package:fourtyninehub/features/health_feature/shared/domain/entities/city_entity.dart';
import '../../../../health_feature/create_doctor/domain/entities/doctor_day_entity.dart';
import '../../../../health_feature/create_doctor/domain/entities/governorate_entity.dart'
    as create_doctor;
import '../../../../health_feature/shared/domain/entities/governorate_entity.dart';
import '../../../../health_feature/shared/domain/entities/city_entity.dart';
import '../../../../health_feature/create_doctor/domain/usecases/create_doctor.dart';
import '../../../../health_feature/shared/domain/usecases/get_cities.dart';
import '../../../../health_feature/shared/domain/usecases/get_governorates.dart';
import '../../../../health_feature/health/domain/usecases/get_health_subcategories.dart';
import '../../../../health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import '../../../../subcategories/domain/entities/sub_category_entity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

part 'create_resturant_state.dart';

class CreateResturantCubit extends Cubit<CreateResturantState> {
  final HealthSharedData _shareCubit;
  final GetHealthSubcategoriesUseCase _getHealthSubcategoriesUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final GetCitiesUseCase _getCitiesUseCase;
  final CreateDoctorUseCase _createDoctorUseCase;
  CreateResturantCubit(
      this._shareCubit,
      this._getHealthSubcategoriesUseCase,
      this._getGovernoratesUseCase,
      this._getCitiesUseCase,
      this._createDoctorUseCase)
      : super(CreateResturantInitial());

  Future<void> loadData() async {
    await _getSubCategories();
    await _getGovernorates();
  }

  // Future<void> submit() async {
  //   if (formKey.currentState!.validate()) {
  //     _saveTextEditingControllers();
  //     _saveWorkDays();
  //     String? checkFilledMessage = _createDoctorParams.isFilled();
  //     emit(CreateResturantError(checkFilledMessage ?? ""));
  //   }
  // }

  Future<void> _getSubCategories() async {
    final userId = UserCubit.to.state.data?.id;

    if (_shareCubit.subCategories.isEmpty) {
      final response = await _getHealthSubcategoriesUseCase.call(userId ?? '');
      response.fold((failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(CreateResturantError("Can't Load Specialities"));
      }, (data) {
        _shareCubit.subCategories = data;
        emit(CreateResturantSubCategoriesLoaded(data));
      });
    } else {
      emit(CreateResturantSubCategoriesLoaded(_shareCubit.subCategories));
    }
  }

  Future<void> _getGovernorates() async {
    if (_shareCubit.governorates.isEmpty) {
      final response = await _getGovernoratesUseCase.call(const NoParams());
      response.fold((failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(CreateResturantError("Can't Load Governorates"));
      }, (data) {
        // Convert from create_doctor GovernorateEntity to shared GovernorateEntity
        final sharedGovernorates = data
            .map((e) => GovernorateEntity(
                  id: e.id,
                  nameAr: e.nameAr,
                  nameEn: e.nameEn,
                ))
            .toList();
        _shareCubit.governorates = sharedGovernorates;
        emit(CreateResturantGovernoratesLoaded(sharedGovernorates));
      });
    } else {
      emit(CreateResturantGovernoratesLoaded(_shareCubit.governorates));
    }
  }

  Future<void> _getCities(String governorateId) async {
    emit(CreateResturantCitiesLoading());
    final response = await _getCitiesUseCase.call(governorateId);

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(CreateResturantError("Can't Load Cities"));
      },
      (data) {
        // Convert from create_doctor CityEntity to shared CityEntity
        final sharedCities = data
            .map((e) => CityEntity(
                  id: e.id,
                  nameAr: e.nameAr,
                  nameEn: e.nameEn,
                ))
            .toList();
        emit(CreateResturantCitiesLoaded(sharedCities));
      },
    );
  }

  // final CreateDoctorParams _createDoctorParams = CreateDoctorParams();

  // // =============================== Timetables ===============================
  // List<DoctorDayEntity> clinicTimetable = [
  //   DoctorDayEntity(day: WeekDays.saturday),
  //   DoctorDayEntity(day: WeekDays.sunday),
  //   DoctorDayEntity(day: WeekDays.monday),
  //   DoctorDayEntity(day: WeekDays.tuesday),
  //   DoctorDayEntity(day: WeekDays.wednesday),
  //   DoctorDayEntity(day: WeekDays.thursday),
  //   DoctorDayEntity(day: WeekDays.friday),
  // ];

  // List<DoctorDayEntity> callTimetable = [
  //   DoctorDayEntity(day: WeekDays.saturday),
  //   DoctorDayEntity(day: WeekDays.sunday),
  //   DoctorDayEntity(day: WeekDays.monday),
  //   DoctorDayEntity(day: WeekDays.tuesday),
  //   DoctorDayEntity(day: WeekDays.wednesday),
  //   DoctorDayEntity(day: WeekDays.thursday),
  //   DoctorDayEntity(day: WeekDays.friday),
  // ];

  // List<DoctorDayEntity> homeVisitTimetable = [
  //   DoctorDayEntity(day: WeekDays.saturday),
  //   DoctorDayEntity(day: WeekDays.sunday),
  //   DoctorDayEntity(day: WeekDays.monday),
  //   DoctorDayEntity(day: WeekDays.tuesday),
  //   DoctorDayEntity(day: WeekDays.wednesday),
  //   DoctorDayEntity(day: WeekDays.thursday),
  //   DoctorDayEntity(day: WeekDays.friday),
  // ];

  // void _saveWorkDays() {
  //   // Build detections array according to new schema
  //   _createDoctorParams.detections = [];

  //   final clinicAvailability = clinicTimetable
  //       .where((e) => e.isAvailable)
  //       .map((e) => DoctorDayModel.fromEntity(e))
  //       .toList();
  //   if (clinicAvailability.isNotEmpty) {
  //     final num clinicPrice = num.tryParse(clinicPriceController.text) ?? 0;
  //     final int clinicPeriod =
  //         int.tryParse(clinicExamineDurationController.text) ?? 0;
  //     _createDoctorParams.detections.add(
  //       DetectionParams(
  //         type: 'clinic_visit',
  //         price: clinicPrice,
  //         detectionPeriod: clinicPeriod,
  //         description: '',
  //         availability: clinicAvailability,
  //       ),
  //     );
  //     debugPrint(
  //         'Clinic detection added - Price: $clinicPrice, Period: $clinicPeriod, Days: ${clinicAvailability.length}');
  //   }

  //   final callAvailability = callTimetable
  //       .where((e) => e.isAvailable)
  //       .map((e) => DoctorDayModel.fromEntity(e))
  //       .toList();
  //   if (callAvailability.isNotEmpty) {
  //     final num callPrice = num.tryParse(callPriceController.text) ?? 0;
  //     final int callPeriod =
  //         int.tryParse(callExamineDurationController.text) ?? 0;
  //     _createDoctorParams.detections.add(
  //       DetectionParams(
  //         type: 'video_call',
  //         price: callPrice,
  //         detectionPeriod: callPeriod,
  //         description: '',
  //         availability: callAvailability,
  //       ),
  //     );
  //     debugPrint(
  //         'Call detection added - Price: $callPrice, Period: $callPeriod, Days: ${callAvailability.length}');
  //   }

  //   final homeAvailability = homeVisitTimetable
  //       .where((e) => e.isAvailable)
  //       .map((e) => DoctorDayModel.fromEntity(e))
  //       .toList();
  //   if (homeAvailability.isNotEmpty) {
  //     final num homePrice = num.tryParse(homeVisitPriceController.text) ?? 0;
  //     final int homePeriod =
  //         int.tryParse(homeVisitExamineDurationController.text) ?? 0;
  //     _createDoctorParams.detections.add(
  //       DetectionParams(
  //         type: 'home_visit',
  //         price: homePrice,
  //         detectionPeriod: homePeriod,
  //         description: '',
  //         availability: homeAvailability,
  //       ),
  //     );
  //     debugPrint(
  //         'Home visit detection added - Price: $homePrice, Period: $homePeriod, Days: ${homeAvailability.length}');
  //   }
  // }

  // // ================================ DatePickers ===============================
  // void pickIDExpiryDate(DateTime value) {
  //   _upsertDocument(
  //     type: 'id_card',
  //     expiryDate: value.toIso8601String(),
  //   );
  //   debugPrint('ID expiry: ${value.toIso8601String()}');
  // }

  // void pickPracticingExpiryDate(DateTime value) {
  //   _upsertDocument(
  //     type: 'license',
  //     expiryDate: value.toIso8601String(),
  //   );
  //   debugPrint('License expiry: ${value.toIso8601String()}');
  // }

  // // ================================ dropdowns ===============================
  // Future<void> selectGovernorate(GovernorateEntity value) async {
  //   _createDoctorParams.address.governorateId = value.id;
  //   debugPrint('Governorate: ${value.nameEn} (${value.id})');
  //   await _getCities(value.id);
  // }

  // void selectCity(CityEntity value) {
  //   _createDoctorParams.address.cityId = value.id;
  //   debugPrint('City: ${value.nameEn} (${value.id})');
  // }

  // void selectSubcategory(SubCategoryEntity subCategoryModel) {
  //   _createDoctorParams.specialityId = subCategoryModel.id;
  //   debugPrint(
  //       'Speciality: ${subCategoryModel.nameAr} (${subCategoryModel.id})');
  // }

  // // ================================= upload images =================================
  // Future<void> _uploadImage(
  //     {required dynamic Function(UploadFileEntity) onUploaded,
  //     required BuildContext context}) async {
  //   if (_createDoctorParams.specialityId.isNotEmpty) {
  //     emit(CreateResturantLoading("Uploading Image..."));
  //     await UploadFile().uploadImage(
  //       subCategoryId: _createDoctorParams.specialityId,
  //       onUploaded: (value) {
  //         onUploaded(value);
  //       },
  //       context: context,
  //     );
  //     emit(CreateResturantCloseLoading());
  //   } else {
  //     emit(CreateResturantError("Select Subcategory First"));
  //   }
  // }

  // Future<void> uploadProfileImage({required BuildContext context}) async {
  //   await _uploadImage(
  //       onUploaded: (media) {
  //         _createDoctorParams.doctorProfilePicMediaId = media.mediaId[0];
  //         debugPrint('Profile mediaId: ${media.mediaId[0]}');
  //         emit(CreateResturantUploadProfileImage(media.file));
  //       },
  //       context: context);
  // }

  // Future<void> uploadIdFrontImage({required BuildContext context}) async {
  //   await _uploadImage(
  //       onUploaded: (media) {
  //         _upsertDocument(
  //           type: 'id_card',
  //           frontMediaId: media.mediaId[0],
  //         );
  //         debugPrint('ID front mediaId: ${media.mediaId[0]}');
  //         emit(CreateResturantUploadIdFrontImage(media.file));
  //       },
  //       context: context);
  // }

  // Future<void> uploadIdBehindImage({required BuildContext context}) async {
  //   await _uploadImage(
  //       onUploaded: (media) {
  //         _upsertDocument(
  //           type: 'id_card',
  //           backMediaId: media.mediaId[0],
  //         );
  //         debugPrint('ID back mediaId: ${media.mediaId[0]}');
  //         emit(CreateResturantUploadIdBehindImage(media.file));
  //       },
  //       context: context);
  // }

  // Future<void> uploadPracticingFrontImage(
  //     {required BuildContext context}) async {
  //   await _uploadImage(
  //       onUploaded: (media) {
  //         _upsertDocument(
  //           type: 'license',
  //           frontMediaId: media.mediaId[0],
  //         );
  //         debugPrint('License front mediaId: ${media.mediaId[0]}');
  //         emit(CreateResturantUploadPracticingFrontImage(media.file));
  //       },
  //       context: context);
  // }

  // Future<void> uploadPracticingBehindImage(
  //     {required BuildContext context}) async {
  //   await _uploadImage(
  //       onUploaded: (media) {
  //         _upsertDocument(
  //           type: 'license',
  //           backMediaId: media.mediaId[0],
  //         );
  //         debugPrint('License back mediaId: ${media.mediaId[0]}');
  //         emit(CreateResturantUploadPracticingBehindImage(media.file));
  //       },
  //       context: context);
  // }

  // void _upsertDocument({
  //   required String type,
  //   String? frontMediaId,
  //   String? backMediaId,
  //   String? expiryDate,
  // }) {
  //   final idx = _createDoctorParams.documents.indexWhere((d) => d.type == type);
  //   if (idx == -1) {
  //     _createDoctorParams.documents.add(
  //       DocumentParams(
  //         type: type,
  //         frontMediaId: frontMediaId ?? '',
  //         backMediaId: backMediaId ?? '',
  //         expiryDate: expiryDate ?? '',
  //       ),
  //     );
  //     return;
  //   }
  //   final doc = _createDoctorParams.documents[idx];
  //   _createDoctorParams.documents[idx] = DocumentParams(
  //     type: type,
  //     frontMediaId: frontMediaId ?? doc.frontMediaId,
  //     backMediaId: backMediaId ?? doc.backMediaId,
  //     expiryDate: expiryDate ?? doc.expiryDate,
  //   );
  // }

  // ================================= toggles =================================

  void toggleClinic(bool value) {
    debugPrint('Clinic toggle: $value');
    emit(CreateResturantShowClinic(value));
  }

  void toggleCallCheck(bool value) {
    debugPrint('Call toggle: $value');
    emit(CreateResturantShowCall(value));
  }

  void toggleHomeVisit(bool value) {
    debugPrint('Home visit toggle: $value');
    emit(CreateResturantShowHomeVisit(value));
  }

  // ================================= TextEditingControllers =================================

  // void _saveTextEditingControllers() {
  //   _createDoctorParams.firstName = firstNameController.text;
  //   _createDoctorParams.lastName = lastNameController.text;
  //   _createDoctorParams.phoneNumber = phoneController.text;
  //   _createDoctorParams.address.address = addressController.text;
  //   _createDoctorParams.description = descriptionController.text;

  //   debugPrint('First name: ${_createDoctorParams.firstName}');
  //   debugPrint('Last name: ${_createDoctorParams.lastName}');
  //   debugPrint('Phone: ${_createDoctorParams.phoneNumber}');
  //   debugPrint('Address: ${_createDoctorParams.address.address}');
  //   debugPrint('Description: ${_createDoctorParams.description}');
  // }

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
