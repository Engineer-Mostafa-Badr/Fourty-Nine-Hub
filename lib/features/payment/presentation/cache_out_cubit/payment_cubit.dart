import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../domain/entities/instapay_cache_out_entity.dart';
import '../../domain/use_cases/cache_out/instapay_cache_out_use_case.dart';

part 'payment_state.dart';

class PaymentCacheOutCubit extends Cubit<PaymentCacheOutState> {
  PaymentCacheOutCubit(
      this._instapayCacheOutUseCase,) : super(PaymentCacheOutState());

  final InstapayCacheOutUseCase _instapayCacheOutUseCase;

  Future<void> postInstaPay({
    required InstapayParams params,
  }) async {
    emit(state.copyWith(status: StateStatus.loading));

    final response = await _instapayCacheOutUseCase(params);

    response.fold(
      (failure) {
        emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
      (data) {
        emit(state.copyWith(
          instaPay: data,
          status: StateStatus.success,
        ));
       // print("InstaPay Data: ${data.message}");
      },
    );
  }
}
