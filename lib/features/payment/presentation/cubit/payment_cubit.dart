import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/payment/domain/entities/payment_provider_entity.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/get_payment_provider_use_case.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit(this.getPaymentProviderUseCase) : super(PaymentState());
  final GetPaymentProviderUseCase getPaymentProviderUseCase;



  /// get PaymentProvider

  Future<List<PaymentProviderEntity>> getAdvertisements() async {
    final response =
    await getPaymentProviderUseCase(const NoParams());
    List<PaymentProviderEntity> paymentProviderList=[];
    response.fold(
            (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
            (data) {
              paymentProviderList.addAll(data);
          emit(state.copyWith(data:paymentProviderList, status: StateStatus.success));
        });
    print("Payment Data:${paymentProviderList.length}");
    return paymentProviderList;
  }


}
