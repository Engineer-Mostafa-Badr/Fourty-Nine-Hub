import 'dart:async';
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

  void addPostCompanyAdvertise({
    required context,
    List<dynamic>? media,
    String? post,
    required String type,
    String? description,
    required int totalPrice,
  }) async {
    var result = await companyAdvertiseRepo.addPostCompanyAdvertise(
        type: type,
        totalPrice: totalPrice,
        post: post,
        description: description,
        media: media
    );

    result.fold((failure) {
      emit(AddCompanyAdvertiseError(
          errMessage: getFailureMessage(failure, context)));
      print(getFailureMessage(failure, context));
    }, (_) {
      emit(AddCompanyAdvertiseSuccess());
    });
  }


   fetchAdvertiseCompany(context,String filter) async {
    emit(FetchAllCompanyAdvertiseLoading());
    _startPollingAdvertise(context,filter);
  }

  void _startPollingAdvertise(context,String filter) {
    _pollingTimer?.cancel();

    // Start polling every 10 seconds (adjust the interval as needed)
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
