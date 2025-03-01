
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_image.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_shipping_categories_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/ride_category_entity.dart';
import '../../../domain/usecases/get_ride_categories_usecase.dart';



class RideCubit extends Cubit<RideState> {
  final GetRideCategoriesUseCase getRideCategories;
  final GetShippingCategoriesUsecase getShippingCategoriesUsecase;

  TextEditingController rideNameController = TextEditingController();
  TextEditingController rideSurNameController = TextEditingController();
  TextEditingController rideDateOfBirthController = TextEditingController();
  TextEditingController ridePhoneNumberController = TextEditingController();
  TextEditingController rideDriverLicenseNumController = TextEditingController();
  TextEditingController rideDriverExpireDateController = TextEditingController();
  TextEditingController ridePersonalDocLicenseNumController = TextEditingController();
  TextEditingController ridePersonalDocExpireDateController = TextEditingController();
  TextEditingController rideVehicleLicenseNumController = TextEditingController();
  TextEditingController rideVehicleExpireDateController = TextEditingController();
  TextEditingController rideDragAnalysisExpireDateController = TextEditingController();
  TextEditingController rideCriminalRecordExpireDateController = TextEditingController();
  TextEditingController rideVehicleProductionYearController = TextEditingController();
  TextEditingController ridePricingPerKmController = TextEditingController();


  RideCubit(
        this.getRideCategories,
        this.getShippingCategoriesUsecase,
      ) : super(const RideState()) {}

  Future<void> fetchRideCategories(String userId) async {
    if (isClosed) return;  // Prevents state emission if the cubit is already disposed.
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, RideCategoryEntityUpdated> result = await getRideCategories(userId);

    if (isClosed) return;  // Double-check before emitting a state
    result.fold(
          (failure) => emit(state.copyWith(status: RideStates.error, failure: failure)),
          (rideCategory) => emit(state.copyWith(status: RideStates.success, rideCategory: rideCategory)),
    );
  }


  Future<void> fetchShippingCategories(String userId) async {
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, RideCategoryEntityUpdated> result = await getShippingCategoriesUsecase(userId);

    result.fold(
          (failure) => emit(state.copyWith(status: RideStates.error, failure: failure)),
          (rideCategory) => emit(state.copyWith(status: RideStates.success, shippingCategory: rideCategory)),
    );
  }


  onUploadPersonalPicture(BuildContext context){
    UploadImage().uploadImage(context: context, onUploaded: (file){
      emit(state.copyWith(personalPicture: file));
    });
  }
  onUploadDriverLicensePicture(BuildContext context){
    UploadImage().uploadImage(context: context, onUploaded: (file){
      emit(state.copyWith(driverLicensePicture: file));
    });
  } onUploadBackOfDriverLicensePicture(BuildContext context){
    UploadImage().uploadImage(context: context, onUploaded: (file){
      emit(state.copyWith(backOfDriverLicensePicture: file));
    });
  } onUploadSelfieDriverLicensePicture(BuildContext context){
    UploadImage().uploadImage(context: context, onUploaded: (file){
      emit(state.copyWith(selfieDriverLicensePicture: file));
    });
  } onUploadPersonalFrontIdPicture(BuildContext context){
    UploadImage().uploadImage(context: context, onUploaded: (file){
      emit(state.copyWith(personalFrontIdPicture: file));
    });
  } onUploadPersonalBackIdPicture(BuildContext context){
    UploadImage().uploadImage(context: context, onUploaded: (file){
      emit(state.copyWith(personalBackIdPicture: file));
    });
  } onUploadPersonalCriminalRecordPicture(BuildContext context){
    UploadImage().uploadImage(context: context, onUploaded: (file){
      emit(state.copyWith(personalCriminalRecordPicture: file));
    });
  } onUploadPersonalDrugAnalysisPicture(BuildContext context){
    UploadImage().uploadImage(context: context, onUploaded: (file){
      emit(state.copyWith(personalDrugAnalysisPicture: file));
    });
  } onUploadVehicleFrontPicture(BuildContext context){
    UploadImage().uploadImage(context: context, onUploaded: (file){
      emit(state.copyWith(vehicleFrontPicture: file));
    });
  } onUploadVehicleBackPicture(BuildContext context){
    UploadImage().uploadImage(context: context, onUploaded: (file){
      emit(state.copyWith(vehicleBackPicture: file));
    });
  } onUploadVehiclePicture(BuildContext context){
    UploadImage().uploadImage(context: context, onUploaded: (file){
      emit(state.copyWith(vehiclePicture: file));
    });
  }

}
