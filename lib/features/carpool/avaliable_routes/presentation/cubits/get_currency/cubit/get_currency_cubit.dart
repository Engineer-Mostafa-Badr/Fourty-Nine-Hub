import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart'; // For Either
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';

part 'get_currency_state.dart';

class GetCurrencyCubit extends Cubit<GetCurrencyState> {
  final ApiConsumer apiConsumer;
  String currency = "";
  // Inject ApiConsumer through the constructor
  GetCurrencyCubit(this.apiConsumer) : super(GetCurrencyInitial());

  Future<void> getCurrencyData() async {
    try {
      emit(GetCurrencyLoading());
      // Make the API call using ApiConsumer
      final Either<Failure, Map<String, dynamic>> response =
          await apiConsumer.get(EndPoints.getCurrencyCarPool);

      // Handle the Either response
      response.fold(
        (failure) => emit(GetCurrencyFailure(_mapFailureToMessage(failure))),
        (data) {
          if (data['status']) {
            currency = data['data'];
            emit(GetCurrencySuccess(data['data']));
          } else {
            emit(GetCurrencyFailure('Failed to fetch currency'));
          }
        },
      );
    } catch (e) {
      emit(GetCurrencyFailure('An error occurred: ${e.toString()}'));
    }
  }

  // Helper method to map failures to error messages
  String _mapFailureToMessage(Failure failure) {
    // Customize this based on your failure handling strategy
    return 'Unexpected error occurred';
  }
}
