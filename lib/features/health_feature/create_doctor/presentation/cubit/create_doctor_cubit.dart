import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/week_days.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/data/models/doctor_address.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/data/models/doctor_day_model.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/entities/city_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/doctor_day_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart'
    as create_doctor;
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/create_doctor.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/usecases/get_cities.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/usecases/get_governorates.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_health_subcategories.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:image_picker/image_picker.dart';

part 'create_doctor_state.dart';

class CreateDoctorCubit extends Cubit<CreateDoctorState> {
  final HealthSharedData _shareCubit;
  final GetHealthSubcategoriesUseCase _getHealthSubcategoriesUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final GetCitiesUseCase _getCitiesUseCase;
  final CreateDoctorUseCase _createDoctorUseCase;

  final CreateDoctorParams _createDoctorParams = CreateDoctorParams();

  DoctorAddressModel get address => _createDoctorParams.address;

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

  final emailFocusNode = FocusNode();

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
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  CreateDoctorCubit(
      this._shareCubit,
      this._getHealthSubcategoriesUseCase,
      this._getGovernoratesUseCase,
      this._getCitiesUseCase,
      this._createDoctorUseCase)
      : super(CreateDoctorInitial());
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
    emailFocusNode.dispose();
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
    emailController.dispose();
    return super.close();
  }

  Future<void> loadData() async {
    await _getSubCategories();
    await _getGovernorates();
  }

  // ================================ DatePickers ===============================
  // removed old date pickers; handled later with temporary fields

  void selectCity(CityEntity value) {
    _createDoctorParams.address.cityId = value.id;
    debugPrint('City: ${value.nameEn} (${value.id})');
  }

  // ================================ dropdowns ===============================
  Future<void> selectGovernorate(create_doctor.GovernorateEntity value) async {
    _createDoctorParams.address.governorateId = value.id;
    debugPrint('Governorate: ${value.nameEn} (${value.id})');
    await _getCities(value.id);
  }

  void selectSubcategory(SubCategoryEntity subCategoryModel) {
    _createDoctorParams.specialityId = subCategoryModel.id;
    debugPrint(
        'Speciality: ${subCategoryModel.nameAr} (${subCategoryModel.id})');
  }

  Future<void> submit(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      _saveTextEditingControllers();
      _saveDetections();
      _saveDocumentsIfAvailable();

      // Validate that at least one service type is selected
      if (!hasCalls && !hasClinic && !hasHomeVisit) {
        final errorMessage = context.isArabic
            ? 'يجب اختيار نوع خدمة واحد على الأقل (زيارة عيادة، اتصال، أو زيارة منزل)'
            : 'Please select at least one service type (Clinic visit, Call, or Home visit)';
        emit(CreateDoctorError(errorMessage));
        // Error will be shown in BlocListener, no need to call showErrorMessage here
        return;
      }

      // Validate profile photo
      if (_createDoctorParams.doctorProfilePicMediaId.isEmpty) {
        final errorMessage = context.isArabic
            ? 'الرجاء رفع صورة الملف الشخصي'
            : 'Please upload profile photo';
        emit(CreateDoctorError(errorMessage));
        // Error will be shown in BlocListener, no need to call showErrorMessage here
        return;
      }

      // Validate ID photos (front and back)
      if (_tempIdFront.isEmpty || _tempIdBehind.isEmpty) {
        final errorMessage = context.isArabic
            ? 'الرجاء رفع صور الهوية (الوجه والظهر)'
            : 'Please upload ID photos (Front and Back)';
        emit(CreateDoctorError(errorMessage));
        // Error will be shown in BlocListener, no need to call showErrorMessage here
        return;
      }

      // Validate ID expiry date
      if (_idExpiryDateIso.isEmpty) {
        final errorMessage = context.isArabic
            ? 'الرجاء اختيار تاريخ انتهاء صلاحية الهوية'
            : 'Please select ID expiry date';
        emit(CreateDoctorError(errorMessage));
        // Error will be shown in BlocListener, no need to call showErrorMessage here
        return;
      }

      // Validate license photos (front and back)
      if (_tempLicenseFront.isEmpty || _tempLicenseBehind.isEmpty) {
        final errorMessage = context.isArabic
            ? 'الرجاء رفع صور الترخيص (الوجه والظهر)'
            : 'Please upload license photos (Front and Back)';
        emit(CreateDoctorError(errorMessage));
        // Error will be shown in BlocListener, no need to call showErrorMessage here
        return;
      }

      // Validate license expiry date
      if (_licenseExpiryDateIso.isEmpty) {
        final errorMessage = context.isArabic
            ? 'الرجاء اختيار تاريخ انتهاء صلاحية الترخيص'
            : 'Please select license expiry date';
        emit(CreateDoctorError(errorMessage));
        // Error will be shown in BlocListener, no need to call showErrorMessage here
        return;
      }

      String? checkFilledMessage = _createDoctorParams.isFilled();
      // Translate validation messages
      String? localizedMessage = checkFilledMessage;
      if (context.isArabic) {
        switch (checkFilledMessage) {
          case 'Please choose your specialty':
            localizedMessage = 'الرجاء اختيار التخصص';
            break;
          case 'Please upload your photo':
            localizedMessage = 'الرجاء رفع صورتك';
            break;
          case 'Please enter your first name':
            localizedMessage = 'الرجاء إدخال الاسم الأول';
            break;
          case 'Please enter your last name':
            localizedMessage = 'الرجاء إدخال الاسم الأخير';
            break;
          case 'Please enter your phone number':
            localizedMessage = 'الرجاء إدخال رقم الهاتف';
            break;
          case 'Please enter your description':
            localizedMessage = 'الرجاء إدخال الوصف';
            break;
          case 'Please enter your governorate':
            localizedMessage = 'الرجاء اختيار المحافظة';
            break;
          case 'Please enter your city':
            localizedMessage = 'الرجاء اختيار المدينة';
            break;
          case 'Please enter your address':
            localizedMessage = 'الرجاء إدخال العنوان';
            break;
          case 'Please add at least one detection type':
            localizedMessage = 'الرجاء اختيار نوع خدمة واحد على الأقل';
            break;
        }
      }
      emit(CreateDoctorError(localizedMessage!));
      // Error will be shown in BlocListener, no need to call showErrorMessage here
    }
  }

  bool hasCalls = false;
  bool hasClinic = false;
  bool hasHomeVisit = false;

  void toggleCallCheck(bool value) {
    hasCalls = value;
    debugPrint('Call toggle: $value');
    emit(CreateDoctorShowCall(value));
  }
  // ================================= toggles =================================

  void toggleClinic(bool value) {
    hasClinic = value;
    debugPrint('Clinic toggle: $value');
    emit(CreateDoctorShowClinic(value));
  }

  void toggleHomeVisit(bool value) {
    hasHomeVisit = value;
    debugPrint('Home visit toggle: $value');
    emit(CreateDoctorShowHomeVisit(value));
  }

  Future<void> uploadIdBehindImage({required BuildContext context}) async {
    await _uploadImage(
        onUploaded: (media) {
          // documents will be built before submit
          _tempIdBehind = media.mediaId;
          debugPrint('ID back mediaId: ${media.mediaId}');
          emit(CreateDoctorUploadIdBehindImage(media.file));
        },
        context: context);
  }

  Future<void> uploadIdFrontImage({required BuildContext context}) async {
    await _uploadImage(
        onUploaded: (media) {
          _tempIdFront = media.mediaId;
          debugPrint('ID front mediaId: ${media.mediaId}');
          emit(CreateDoctorUploadIdFrontImage(media.file));
        },
        context: context);
  }

  Future<void> uploadPracticingBehindImage(
      {required BuildContext context}) async {
    await _uploadImage(
        onUploaded: (media) {
          _tempLicenseBehind = media.mediaId;
          debugPrint('License back mediaId: ${media.mediaId}');
          emit(CreateDoctorUploadPracticingBehindImage(media.file));
        },
        context: context);
  }

  Future<void> uploadPracticingFrontImage(
      {required BuildContext context}) async {
    await _uploadImage(
        onUploaded: (media) {
          _tempLicenseFront = media.mediaId;
          debugPrint('License front mediaId: ${media.mediaId}');
          emit(CreateDoctorUploadPracticingFrontImage(media.file));
        },
        context: context);
  }

  Future<void> uploadProfileImage({required BuildContext context}) async {
    await _uploadImage(
        onUploaded: (media) {
          _createDoctorParams.doctorProfilePicMediaId = media.mediaId;
          debugPrint('Profile mediaId: ${media.mediaId}');
          emit(CreateDoctorUploadProfileImage(media.file));
        },
        context: context);
  }

  Future<void> _getCities(String governorateId) async {
    emit(CreateDoctorCitiesLoading());
    final response = await _getCitiesUseCase.call(governorateId);

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(CreateDoctorError("Can't Load Cities"));
      },
      (data) => emit(CreateDoctorCitiesLoaded(data)),
    );
  }

  Future<void> _getGovernorates() async {
    if (_shareCubit.governorates.isEmpty) {
      final response = await _getGovernoratesUseCase.call(const NoParams());
      response.fold((failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(CreateDoctorError("Can't Load Governorates"));
      }, (data) {
        // data is shared GovernorateEntity; cache as-is for shared store
        _shareCubit.governorates = data;

        // Convert to create_doctor GovernorateEntity for UI state that expects it
        final createDoctorGovernorates = data
            .map((e) => create_doctor.GovernorateEntity(
                  id: e.id,
                  nameAr: e.nameAr,
                  nameEn: e.nameEn,
                ))
            .toList();

        emit(CreateDoctorGovernoratesLoaded(createDoctorGovernorates));
      });
    } else {
      // Convert from shared GovernorateEntity to create_doctor GovernorateEntity
      final createDoctorGovernorates = _shareCubit.governorates
          .map((e) => create_doctor.GovernorateEntity(
                id: e.id,
                nameAr: e.nameAr,
                nameEn: e.nameEn,
              ))
          .toList();
      emit(CreateDoctorGovernoratesLoaded(createDoctorGovernorates));
    }
  }

  Future<void> _getSubCategories() async {
    final userId = UserCubit.to.state.data?.id;

    if (_shareCubit.subCategories.isEmpty) {
      final response = await _getHealthSubcategoriesUseCase.call(userId ?? '');
      response.fold((failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(CreateDoctorError("Can't Load Specialities"));
      }, (data) {
        _shareCubit.subCategories = data;
        emit(CreateDoctorSubCategoriesLoaded(data));
      });
    } else {
      emit(CreateDoctorSubCategoriesLoaded(_shareCubit.subCategories));
    }
  }
  // ================================= TextEditingControllers =================================

  void _saveTextEditingControllers() {
    _createDoctorParams.firstName = firstNameController.text;
    _createDoctorParams.lastName = lastNameController.text;
    _createDoctorParams.phoneNumber = phoneController.text;
    _createDoctorParams.email = emailController.text;
    _createDoctorParams.address.address = addressController.text;
    _createDoctorParams.description = descriptionController.text;

    debugPrint('First name: ${_createDoctorParams.firstName}');
    debugPrint('Last name: ${_createDoctorParams.lastName}');
    debugPrint('Phone: ${_createDoctorParams.phoneNumber}');
    debugPrint('Email: ${_createDoctorParams.email}');
    debugPrint('Address: ${_createDoctorParams.address.address}');
    debugPrint('Description: ${_createDoctorParams.description}');
  }

  String _idExpiryDateIso = '';
  String _licenseExpiryDateIso = '';
  String _tempIdFront = '';
  String _tempIdBehind = '';
  String _tempLicenseFront = '';
  String _tempLicenseBehind = '';

  void pickIDExpiryDateNew(DateTime value) {
    _idExpiryDateIso = value.toIso8601String();
    debugPrint('ID expiry: ${value.toIso8601String()}');
  }

  void pickPracticingExpiryDateNew(DateTime value) {
    _licenseExpiryDateIso = value.toIso8601String();
    debugPrint('License expiry: ${value.toIso8601String()}');
  }

  void _saveDetections() {
    _createDoctorParams.detections.clear();

    num parsePrice(String s) => num.tryParse(s.trim()) ?? 0;
    int parsePeriod(String s) => int.tryParse(s.trim()) ?? 0;

    if (hasClinic) {
      final availability = clinicTimetable
          .where((e) => e.isAvailable)
          .map((e) => DoctorDayModel.fromEntity(e))
          .toList();
      final price = parsePrice(clinicPriceController.text);
      final period = parsePeriod(clinicExamineDurationController.text);
      _createDoctorParams.detections.add(DetectionParams(
        type: 'clinic_visit',
        price: price,
        detectionPeriod: period,
        description: 'كشف عيادة',
        availability: availability,
      ));
      debugPrint(
          'Clinic detection added - Price: $price, Period: $period, Days: ${availability.length}');
    }

    if (hasCalls) {
      final availability = callTimetable
          .where((e) => e.isAvailable)
          .map((e) => DoctorDayModel.fromEntity(e))
          .toList();
      final price = parsePrice(callPriceController.text);
      final period = parsePeriod(callExamineDurationController.text);
      _createDoctorParams.detections.add(DetectionParams(
        type: 'video_call',
        price: price,
        detectionPeriod: period,
        description: 'استشارة عبر مكالمة',
        availability: availability,
      ));
      debugPrint(
          'Call detection added - Price: $price, Period: $period, Days: ${availability.length}');
    }

    if (hasHomeVisit) {
      final availability = homeVisitTimetable
          .where((e) => e.isAvailable)
          .map((e) => DoctorDayModel.fromEntity(e))
          .toList();
      final price = parsePrice(homeVisitPriceController.text);
      final period = parsePeriod(homeVisitExamineDurationController.text.isEmpty
          ? '0'
          : homeVisitExamineDurationController.text);
      _createDoctorParams.detections.add(DetectionParams(
        type: 'home_visit',
        price: price,
        detectionPeriod: period,
        description: 'زيارة منزلية',
        availability: availability,
      ));
      debugPrint(
          'Home visit detection added - Price: $price, Period: $period, Days: ${availability.length}');
    }
  }

  void _saveDocumentsIfAvailable() {
    _createDoctorParams.documents.clear();
    if (_tempIdFront.isNotEmpty &&
        _tempIdBehind.isNotEmpty &&
        _idExpiryDateIso.isNotEmpty) {
      _createDoctorParams.documents.add(DocumentParams(
        type: 'id_card',
        frontMediaId: _tempIdFront,
        backMediaId: _tempIdBehind,
        expiryDate: _idExpiryDateIso,
      ));
    }
    if (_tempLicenseFront.isNotEmpty &&
        _tempLicenseBehind.isNotEmpty &&
        _licenseExpiryDateIso.isNotEmpty) {
      _createDoctorParams.documents.add(DocumentParams(
        type: 'license',
        frontMediaId: _tempLicenseFront,
        backMediaId: _tempLicenseBehind,
        expiryDate: _licenseExpiryDateIso,
      ));
    }
  }

  // ================================= upload images =================================
  Future<void> _uploadImage(
      {required dynamic Function(UploadFileEntity) onUploaded,
      required BuildContext context}) async {
    if (_createDoctorParams.specialityId.isNotEmpty) {
      emit(CreateDoctorLoading("Uploading Image..."));
      await UploadFile().uploadImage(
        subCategoryId: _createDoctorParams.specialityId,
        onUploaded: (value) {
          onUploaded(value);
        },
        context: context,
      );
      emit(CreateDoctorCloseLoading());
    } else {
      final errorMessage = context.isArabic
          ? 'الرجاء اختيار التخصص قبل رفع الصورة'
          : 'Please select speciality before uploading image';
      emit(CreateDoctorError(errorMessage));
      // Error will be shown in BlocListener, no need to call showErrorMessage here
    }
  }
}
