import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/error/failure.dart';
import '../../../data/repositories/company_advertise_repo/company_advertise_repo.dart';
import 'company_advertise_state.dart';

class CompanyAdvertiseCubit extends Cubit<CompanyAdvertiseState> {
  CompanyAdvertiseCubit(this.companyAdvertiseRepo)
      : super(CompanyAdvertiseInitial());

  final CompanyAdvertiseRepo companyAdvertiseRepo;

  static CompanyAdvertiseCubit get(context) => BlocProvider.of(context);

  Timer? _pollingTimer;


  Future<void> addPostCompanyAdvertise({
    required BuildContext context,
    String? post,
    required String type,
    String? description,
    required int totalPrice,
    List<String>? mediaIds, // Make sure this is used correctly
  }) async {

    var result = await companyAdvertiseRepo.addPostCompanyAdvertise(
      type: type,
      totalPrice: totalPrice,
      post: post,
      description: description,
      mediaIds: mediaIds,  // Pass mediaIds here
    );

    result.fold((failure) {
      emit(AddCompanyAdvertiseError(
          errMessage: getFailureMessage(failure, context)));
      print('Error: ${getFailureMessage(failure, context)}');
    }, (_) {
      emit(AddCompanyAdvertiseSuccess());
      mediaIds?.clear(); // Clear the mediaIds if needed after successful post
      print('Media IDs cleared after successful post.');
    });
  }

  Future<void> fetchAdvertiseCompany(BuildContext context, String filter) async {
    emit(FetchAllCompanyAdvertiseLoading());
    _startPollingAdvertise(context, filter);
  }

  void _startPollingAdvertise(BuildContext context, String filter) {
    _pollingTimer?.cancel();

    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      var result = await companyAdvertiseRepo.fetchPostCompanyAdvertise(filter);

      result.fold((failure) {
        emit(FetchAllCompanyAdvertiseError(
            errMessage: getFailureMessage(failure, context)));
        print(getFailureMessage(failure, context));
      }, (company) {
        emit(FetchAllCompanyAdvertiseSuccess(advertiseCompanyModel: company));
      });
    });
  }
}
