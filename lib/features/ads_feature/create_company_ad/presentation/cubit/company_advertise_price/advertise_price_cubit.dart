// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../../../core/error/failure.dart';
// import '../../../data/repositories/company_advertise_repo/company_advertise_repo.dart';
// import 'advertise_price_state.dart';
//
// class AdvertisePriceCubit extends Cubit<AdvertisePriceState> {
//   AdvertisePriceCubit(this.companyAdvertiseRepo)
//       : super(AdvertisePriceInitial());
//
//   final CompanyAdvertiseRepo companyAdvertiseRepo;
//
//   static AdvertisePriceCubit get(context) => BlocProvider.of(context);
//
// // Timer? _pollingTimer;
//
//   void fetchPrice(context) async {
//     emit(AdvertisePriceLoading());
//     var result = await companyAdvertiseRepo.fetchPrice();
//
//     result.fold((failure) {
//       emit(AdvertisePriceError(
//           errMessage: getFailureMessage(failure, context)));
//       print(getFailureMessage(failure, context));
//     }, (company) {
//       //emit(AdvertiseSuccess());
//       emit(AdvertisePriceSuccess(advertisePriceModel: company));
//     });
//   }
//
//   // void _startPolling(context) async{
//   //  _pollingTimer?.cancel();
//   //
//   // //  Start polling every 10 seconds (adjust the interval as needed)
//   //  _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
//   //
//   //  });
//   // }
// }
